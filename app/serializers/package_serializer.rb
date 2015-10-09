class PackageSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :position
end
