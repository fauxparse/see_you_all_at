class PackageEditor
  constructor: (options = {}) ->
    packages = (options.packages || []).sort(byPosition)
    @packages = m.prop(new App.Models.Package(pkg) for pkg in packages)
    types = (options.activity_types || []).sort(byPosition)
    @activityTypes = m.prop(new App.Models.ActivityType(a) for a in types)

  view: =>
    m("div",
      { class: "package-editor" },
      m("table", { config: @init },
        m("thead",
          m("tr",
            { class: "package-names" }
            m("th", class: "top-left"),
            (@header(pkg) for pkg in @packages())
          )
        ),
        m("tbody",
          { class: "activity-types" },
          (@row(type) for type in @activityTypes())
        )
      ),
      m("div", { class: "buttons" },
        m("button", { rel: "save", type: "submit" }, "Save")
      )
    )

  header: (pkg) ->
    prefix = "event[packages][#{pkg.position()}]"
    m("th", { class: "package-editor-column", "data-package-id": pkg.id() },
      m("div", { class: "package-editor-header" },
        @icon("settings"),
        m("span", pkg.name())
      ),
      @hidden(prefix, "id", pkg.id())
    )

  row: (type) ->
    prefix = "event[activity_types][#{type.position()}]"
    m("tr",
      { class: "package-editor-row", "data-activity-type-id": type.id() },
      m("th",
        m("div", { class: "package-editor-header" },
          @icon("settings"),
          m("span", type.name().pluralize().capitalize())
        ),
        @hidden(prefix, "id", type.id())
      ),
      (@cell(pkg, type) for pkg in @packages())
    )

  cell: (pkg, type) ->
    m("td",
      {
        "class": "package-limit"
        "data-package-id": pkg.id(),
        "data-activity-type-id": type.id()
      },
      m.component(LimitEditor.component, { package: pkg, activityType: type})
    )

  icon: (icon) ->
    m("a", { href: "#", rel: icon }, m("i", { class: "material-icons" }, icon))

  hidden: (prefix, field, value) ->
    m("input", { type: "hidden", name: "#{prefix}[#{field}]", value: value })

  init: (@table, isInitialized, context) =>
    return if isInitialized

    @dragRows = dragula
      isContainer: (el) -> el.classList.contains("activity-types")
      direction: "vertical"
    .on("drag", @dragStart)
    .on("cloned", @dragRowCloned)
    .on("dragend", @dragRowEnd)

    @dragColumns = dragula
      isContainer: (el) -> el.classList.contains("package-names")
      direction: "horizontal"
      moves: (el, source, handle, sibling) ->
        !handle.classList.contains("top-left")
      accepts: (el, target, source, sibling) ->
        !sibling?.classList.contains("top-left")
    .on("drag", @dragStart)
    .on("cloned", @dragColumnCloned)
    .on("shadow", @dragColumnShadow)
    .on("dragend", @dragColumnEnd)

  dragStart: ->
    drop.close() for drop in Drop.drops

  dragRowCloned: (clone, original, type) ->
    clone.style.width = original.offsetWidth + "px"
    for child, i in original.children
      clone.children[i].style.width = child.offsetWidth + "px"

  dragRowEnd: (el) =>
    m.computation =>
      for row, position in @table.querySelectorAll("[data-activity-type-id]")
        id = parseInt(row.getAttribute("data-activity-type-id"))
        for type in @activityTypes() when type.id() == id
          type.position(position)

  dragColumnCloned: (clone, original, type) =>
    clone.innerHTML = ""
    id = original.getAttribute("data-package-id")
    h = 0
    for child in @table.querySelectorAll("[data-package-id='#{id}']")
      cell = child.cloneNode(true)
      cell.style.height = "#{child.offsetHeight}px"
      cell.classList.remove("gu-transit")
      clone.appendChild(cell)
      h += child.offsetHeight
      child.classList.add("gu-transit")
    clone.style.height = "#{h}px"

  dragColumnShadow: (el, container, source) =>
    id = el.getAttribute("data-package-id")
    cells = @table.querySelectorAll("[data-package-id='#{id}']")
    if sibling = el.nextSibling
      nextID = sibling.getAttribute("data-package-id")
      nxt = "[data-package-id='#{nextID}']"
      for cell in cells
        cell.parentNode.insertBefore(cell, cell.parentNode.querySelector(nxt))
    else
      for cell in cells
        cell.parentNode.appendChild(cell)

  dragColumnEnd: (el) =>
    for cell in @table.querySelectorAll(".gu-transit")
      cell.classList.remove("gu-transit")
    m.computation =>
      for cell, position in @table.querySelectorAll("th[data-package-id]")
        id = parseInt(cell.getAttribute("data-package-id"))
        for pkg in @packages() when pkg.id() == id
          pkg.position(position)

class LimitEditor
  constructor: (options = {}) ->
    @package = m.prop(options.package)
    @type = m.prop(options.activityType)

  limit: (maximum) ->
    @package().limit(@type().id(), maximum) || 0

  view: (controller) =>
    name = "event[packages][#{@package().position()}]" +
      "[limits][#{@type().id()}]"
    m("div",
      { class: "package-limit-editor" },
      m("input", { type: "hidden", name: name, value: @limit() }),
      m("div", { config: @init }, m("span", @label(@limit()))),
      m("div",
        @button("none", "block", @selectNone, @limit() == 0),
        @button("minus", "remove_circle_outline", @minus),
        m("span", @label(@limit())),
        @button("plus", "add_circle_outline", @plus),
        @button("all", "all", @selectAll, @limit() == -1)
      )
    )

  init: (el, isInitialized, context) =>
    unless isInitialized
      new Drop
        target: el
        content: el.nextSibling
        classes: "package-limit-editor-ui"
        tetherOptions:
          attachment: "middle center"
          targetAttachment: "middle center"

  label: (limit) ->
    if limit == -1
      "∞"
    else if limit == 0
      "—"
    else
      limit

  button: (rel, icon, action, selected) ->
    options = { rel: rel }
    options.onmousedown = action if action
    options.class = "selected" if selected
    options.onclick = @noop

    if rel == "all"
      m("button", options, "∞")
    else
      m("button", options, m("i", { class: "material-icons" }, icon))

  selectNone: (e) =>
    preventDefault(e)
    m.computation => @limit(0)

  selectAll: (e) =>
    preventDefault(e)
    m.computation => @limit(-1)

  minus: (e) =>
    preventDefault(e)
    @timedRepeatButton(@increment)

  increment: =>
    m.computation =>
      limit = if @limit() == -1
        10
      else if @limit() > 0
        @limit() - 1
      else
        @limit()
      @limit(limit)

  plus: (e) =>
    preventDefault(e)
    @timedRepeatButton(@decrement)

  decrement: =>
    m.computation =>
      @limit(if @limit() == -1 then 10 else @limit() + 1)

  timedRepeatButton: (callback) ->
    repeat = false
    delay = setTimeout ->
      callback()
      repeat = setInterval(callback, 100)
    , 250

    callback()
    clearRepeat = ->
      clearTimeout(delay)
      clearTimeout(repeat)
      document.removeEventListener("mouseup", clearRepeat)
    document.addEventListener("mouseup", clearRepeat)

  noop: (e) ->
    preventDefault(e)

LimitEditor.component =
  controller: (options = {}) ->
    new LimitEditor(options)

  view: (controller) ->
    controller.view()

byPosition = (a, b) -> a.position - b.position

preventDefault = (e) ->
  if e.preventDefault?
    e.preventDefault()
  else
    e.returnValue = false

App.Components.PackageEditor =
  controller: (options = {}) ->
    new PackageEditor(options)

  view: (controller) ->
    controller.view()
