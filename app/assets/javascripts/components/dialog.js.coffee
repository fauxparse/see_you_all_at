class App.Components.Dialog
  constructor: ->
    @open = m.prop(false)

  view: =>
    toggle = if @open() then "in" else "out"
    m("div", { class: "dialog #{toggle}", config: @init },
      m("div", { class: "dialog-scrim", onclick: @scrimClicked }),
      m("div", { class: "dialog-wrapper" },
        m("div", { class: "dialog-container" },
          @header(),
          @body(),
          @footer()
        )
      )
    )

  header: ->
    m("header", { class: "dialog-header" })

  body: ->
    m("div", { class: "dialog-body" })

  footer: ->
    m("footer", { class: "dialog-footer" })

  init: (@el, isInitialized) =>
    setTimeout(@show, 0) unless isInitialized

  show: =>
    m.computation => @open(true)

  hide: =>
    m.computation => @open(false)

  scrimClicked: (e) =>
    @hide()

  @controller: (options = {}) =>
    new this(options)

  @view: (controller) ->
    controller.view()

  @show: (constructor, args) ->
    container = document.createElement("div")
    container.classList.add("dialog")
    document.body.appendChild(container)
    dialog = m.component(constructor, args)
    m.mount(container, dialog)
    dialog
