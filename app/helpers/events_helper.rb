module EventsHelper
  def package_editor(event)
    packages = ActiveModel::SerializableResource.new(event.packages)
    activity_types = ActiveModel::SerializableResource.new(event.activity_types)

    mithril_component(
      "App.Components.PackageEditor",
      {
        packages: packages.serializable_hash,
        activity_types: activity_types.serializable_hash
      },
      class: "package-editor"
    )
  end
end
