_interopRequire = (obj) ->
  if(obj? and obj.__esModule) then obj["default"] else obj

update = require 'react-addons-update'
{ipcRenderer, remote} = require 'electron'
React = require 'react'
ReactDOM = require 'react-dom'
MainView = require './js/renderer/MainView'
FileView = require './js/renderer/FileView'
PropertyView = require './js/renderer/PropertyView'
FilePropertyView = require './js/renderer/property/FilePropertyView'
{CodeView} = require './js/renderer/CodeView'

document.ondragover = document.ondrop = (e) ->
  e.preventDefault()
  false

window.Timeline = null

class @Contents extends React.Component
  constructor: (props) ->
    super props
    @state =
      projectPath: null
      type: null
      item: null
      code: ""
      selectedAnimElem: null;
    ipcRenderer.on 'requestPath-reply', (err, path) =>
      console.log err if err?
      console.log path
      @setState projectPath: path
    ipcRenderer.send 'requestPath-message', ''

    ipcRenderer.on 'capture', (err, type) =>
      console.log type

  setSelectedAnimElem: (elem) =>
    @setState selectedAnimElem: elem

  setProperty: (type, item) =>
    @setState type: type, item: item

  setCurrentTime: (time) ->
    @setState curTime: time

  updateState: (newState, callback) ->
    @setState newState, callback

  render: () ->
    return (
      <div id="Contents">
        <MainView path={@state.projectPath} selectedAnimElem={@state.selectedAnimElem} Action={{@setCurrentTime, @setSelectedAnimElem}}/>
        <CodeView path={@state.projectPath} Action={{}}/>
        <FileView path={@state.projectPath} Action={{@setProperty}}/>
        <PropertyView type={@state.type} item={@state.item}/>
      </div>
    )

window.onload = () ->
  ReactDOM.render(
    <Contents />
    document.getElementById 'Top'
  )
