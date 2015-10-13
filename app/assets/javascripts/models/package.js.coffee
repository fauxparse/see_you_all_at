class App.Models.Package
  constructor: (attrs) ->
    @id = m.prop(attrs.id)
    @name = m.prop(attrs.name)
    @slug = m.prop(attrs.slug)
    @position = m.prop(attrs.position)
    @limits = m.prop(attrs.limits)

  limit: (activityTypeID, value) ->
    @limits()[activityTypeID] = value if value?
    @limits()[activityTypeID]
