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
    collection.select(&:persisted?).each do |record|
      record.mark_for_destruction unless ids.include?(record.id)
    end
  end

  def add_or_update_sorted_items(collection, values)
    ids = []
    values.each.with_index do |attrs, position|
      id = attrs[:id].to_i
      record = id && collection.detect { |r| r.id == id } ||
               collection.build
      assign_attributes(record, attrs.merge(position: position))
      ids << id
    end
    ids
  end

  def assign_attributes(record, attributes)
    limits = attributes.delete(:limits)
    assign_limits(record, limits) if limits
    record.assign_attributes(attributes)
  end

  def assign_limits(record, limits)
    ids = record.event.activity_types.map(&:id)

    record.limits.each do |limit|
      limit.mark_for_destruction unless ids.include?(limit.activity_type_id)
    end

    limits.each_pair do |id, maximum|
      id = id.to_i
      limit = record.limits.detect { |l| l.activity_type_id == id } ||
              record.limits.build(activity_type_id: id)
      limit.maximum = maximum.to_i
    end
  end
end
