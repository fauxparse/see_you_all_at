init = (document, window, m) ->
  CLASS_NAME_ATTR = "data-mithril-class"
  PROPS_ATTR = "data-mithril-props"

  $ = jQuery? && jQuery

  findMithrilDOMNodes = ->
    SELECTOR = "[#{CLASS_NAME_ATTR}]"
    $?(SELECTOR) ? document.querySelectorAll(SELECTOR)

  mountComponents = ->
    for node in findMithrilDOMNodes()
      className = node.getAttribute(CLASS_NAME_ATTR)
      constructor = window[className] || eval.call(window, className)
      propsJson = node.getAttribute(PROPS_ATTR)
      props = propsJson && JSON.parse(propsJson)
      m.module(node, m.component(constructor, props));

  CSRFtoken = ""

  setUpCSRF = ->
    if $
      CSRFparam = $("[name=csrf-param]").attr("content")
      CSRFtoken = $("[name=csrf-token]").attr("content")
    else
      if el = document.querySelector("[name=csrf-param]")
        CSRFparam = el.getAttribute("content")
      if el = document.querySelector("[name=csrf-token]")
        CSRFtoken = el.getAttribute("content")

    if CSRFparam && CSRFtoken && !m.requestWithoutCSRFProtection
      m.requestWithoutCSRFProtection = m.request
      m.request = (options) ->
        config = options.config

        if options.method && !/^(GET|HEAD)$/i.test(options.method)
          options.config = (xhr) ->
            xhr.setRequestHeader('X-CSRF-Token', CSRFtoken)
            config && config(xhr)

        m.requestWithoutCSRFProtection(options);

  initMithrilUJS = ->
    setUpCSRF()
    mountComponents()

  $?(initMithrilUJS) || document.addEventListener('DOMContentLoaded', initMithrilUJS)

  if Turbolinks?
    handleEvent = if $
      (eventName, callback) -> $(document).on(eventName, callback)
    else
      (eventName, callback) -> document.addEventListener(eventName, callback)
    handleEvent('page:change', initMithrilUJS)

  m.computation = (callback) ->
    m.startComputation()
    callback()
    m.endComputation()

init(document, window, m)
