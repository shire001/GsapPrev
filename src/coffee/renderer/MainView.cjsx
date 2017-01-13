React = require 'react'
update = require 'react-addons-update'

module.exports = React.createClass
  getInitialState: ->
    items: []
  onDropItem: (e) ->
    e.preventDefault()
    e.stopPropagation()
    image = new Image()
    path = e.dataTransfer.getData("text")
    image.src = "#{@props.path}#{path}"
    x = e.nativeEvent.offsetX
    y = e.nativeEvent.offsetY
    image.onload = =>
      item =
        path: path
        x: x - image.width/2
        y: y - image.height/2
        height: image.height
        width: image.width
        id: @state.items.length
      @setState items: @state.items.concat(item)
      console.log @props.path, path
  onClickPlay: (e) ->
    window.Timeline.timeScale 1
  onClickPause: (e) ->
    window.Timeline.timeScale 0
  onClickStop: (e) ->
    window.Timeline.progress(0).timeScale(0)
    @props.Action.setCurrentTime 0
  onClickFastBack: (e) ->
    window.Timeline.progress 0
    @props.Action.setCurrentTime 0
  onClickFastFor: (e) ->
    window.Timeline.progress 1
    @props.Action.setCurrentTime window.totalTime
  onClickElem: (e) ->
    e.stopPropagation()
    @props.Action.setSelectedAnimElem e.target.id
  onClickView: (e) ->
    @props.Action.setSelectedAnimElem null
  render: ->
    items = @state.items.map (item) =>
      id = "AnimationElement##{item.id}"
      coverCl = "animElem-cover" + " ac#{item.id}"
      cl = "animElem" + " a#{item.id}"
      cl += " selected" if id is @props.selectedAnimElem
      style =
        left: "#{pxToVh item.x}vh",
        top: "#{pxToVh item.y}vh",
        height: "#{pxToVh item.height}vh",
        width: "#{pxToVh item.width}vh"
      <div className={coverCl} key={"cover-#{id}"}>
        <div className={cl} id={id} key={id} style={style} onClick={@onClickElem}>
          <img src={"#{@props.path}#{item.path}"}/>
        </div>
      </div>
    <div id="MainView" onDrop={@onDropItem} onClick={@onClickView}>
      <div className="mainView-inner">
        {items}
      </div>
      <div id="Controller">
        <div className="fa fa-fast-backward" onClick={@onClickFastBack}/>
        <div className="fa fa-pause" onClick={@onClickPause}/>
        <div className="fa fa-play" onClick={@onClickPlay}/>
        <div className="fa fa-stop" onClick={@onClickStop}/>
        <div className="fa fa-fast-forward" onClick={@onClickFastFor}/>
      </div>
    </div>
