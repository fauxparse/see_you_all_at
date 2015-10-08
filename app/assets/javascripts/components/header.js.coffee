resized = ->
  if header = document.querySelector("header.primary-toolbar")
    document.querySelector("main").style.paddingTop = header.offsetHeight + "px"

document.addEventListener("page:load", resized)
document.addEventListener("page:change", resized)
window.addEventListener("resize", resized)
