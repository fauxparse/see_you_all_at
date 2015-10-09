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
    hash = @params.delete(key)
    return if hash.nil?

    values = hash.to_a.sort_by { |a| a.first.to_i }.map(&:last)
    collection = event.send(key)
    ids = add_or_update_sorted_items(collection, values)
    collection.each do |record|
      record.mark_for_destruction unless ids.include?(record.id)
    end
  end

  def add_or_update_sorted_items(collection, values)
    ids = []
    values.each.with_index do |attrs, position|
      id = attrs[:id]
      record = id && collection.detect { |r| r.id == attrs[:id].to_i } ||
               collection.build
      record.assign_attributes(attrs.merge(position: position))
      ids << id
    end
    ids
  end
end
