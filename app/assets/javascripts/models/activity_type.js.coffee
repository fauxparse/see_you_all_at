class App.Models.ActivityType
  constructor: (attrs) ->
    @id = m.prop(attrs.id)
    @name = m.prop(attrs.name)
    @slug = m.prop(attrs.slug)
    @position = m.prop(attrs.position)
