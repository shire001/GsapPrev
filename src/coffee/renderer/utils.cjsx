pxToVh = (px) ->
  if (typeof(px) is "string") and px.endsWith("px")
    px = px.slice(0, px.length - 2)
  height = window.innerHeight
  px / (height / 100)
