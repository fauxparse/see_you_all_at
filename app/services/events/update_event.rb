class UpdateEvent
  attr_reader :event

  delegate :errors, to: :event

  def initialize(event, params)
    @event = event
    @params = params
  end

  def call
    @event.with_lock do
      update_sorted_collection(:packages)
      update_sorted_collection(:activity_types)
      @event.assign_attributes(@params)
      @event.save!
    end
  end

  private

  def update_sorted_collection(key)
    return unless hash = @params.delete(key)
    values = hash.to_a.sort_by { |a| a.first.to_i }.map(&:last)
    ids = []
    collection = event.send(key)

    values.each.with_index do |attrs, position|
      id = attrs[:id]
      record = id && collection.detect { |r| r.id == attrs[:id].to_i } ||
             collection.build
      record.assign_attributes(attrs.merge(position: position))
      ids << id
    end
  end
end
