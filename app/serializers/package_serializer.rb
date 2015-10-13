class PackageSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :position, :limits

  def limits
    object.limits.map.with_object({}) do |limit, hash|
      hash[limit.activity_type_id] = limit.maximum
    end
  end
end
