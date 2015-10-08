class TabStrip
  constructor: (@options = {}) ->
    @options.tabs ||= []
    @showTabContent(@selected())

  selected: (id) =>
    if arguments.length
      id = id.replace(/^[^#]+#/, "")
      @options.selected = id
      @showTabContent(id)
    @options.selected || @defaultTab()

  selectedIndex: ->
    (id for [label, id] in @options.tabs).indexOf(@selected())

  defaultTab: ->
    if location.hash > "#" && document.querySelector(location.hash)
      location.hash.slice(1)
    else
      @options.tabs[0]?[1]

  showTabContent: (selector) =>
    if target = document.querySelector("##{selector}")
      node.classList.add("hide") for node in target.parentNode.children
      target.classList.remove("hide")

  view: =>
    m("ul", (@tab(label, id) for [label, id] in @options.tabs))

  tab: (label, id) ->
    classNames = []
    classNames.push("selected") if @selected() == id
    tabWidth = 100.0 / @options.tabs.length

    [
      m("li", { class: classNames },
        m("a[href='##{id}']", {
          onclick: m.withAttr("href", @selected)
        }, label)
      ),
      m("div", {
        class: "tab-strip-highlight",
        style: "left:#{@selectedIndex() * tabWidth}%; width:#{tabWidth}%"
      })
    ]

App.Components.TabStrip =
  controller: (options = {}) ->
    new TabStrip(options)

  view: (controller) ->
    controller.view()
