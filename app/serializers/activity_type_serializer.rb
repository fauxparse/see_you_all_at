class ActivityTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :position
end
