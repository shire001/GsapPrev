React = require 'react'
brace = _interopRequire(require 'brace')
AceEditor = _interopRequire(require 'react-ace')
require 'brace/mode/javascript'
require 'brace/mode/css'
require 'brace/mode/html'
require 'brace/theme/monokai'

class @CodeView extends React.Component
  constructor: (props) ->
    super(props)
    this.state = {
      "selected": "gsap"
    }
    this.tabs = ["GSAP", "HTML", "CSS"]

  onChange: (value) ->
    # @props.Action.setCode value
    console.log value

  onClickTab: (e) =>
    name = e.target.getAttribute("name")
    @setState
      selected: name

  render: ->
    selectors = []
    editors = []
    for l in @tabs
      name = l.toLowerCase();
      cl = "code-selector" + if(@state.selected == name) then " selected" else ""
      selectors.push(
        <div className={cl} name={l.toLowerCase()} key={"code-sel-#{l}"} onClick={@onClickTab}> {l} </div>
      )
      editors.push(
        <CodeEditor key={"code-editor-#{name}"} Action={@onChange} name={l} type={if(name == "gsap") then "javascript" else name}/>
      )
    <div id="CodeView" className="codeView">
      <div className="code-set">
        {selectors}
      </div>
      {editors}
    </div>

class CodeEditor extends React.Component
  constructor: (props) ->
    super(props)

  render: () ->
    width = (document.getElementById "Top").clientWidth
    type = @props.type.toLowerCase()
    name = @props.name
    <div className={"codeTab code-#{name}"} id={"code-#{name}"}>
      <AceEditor
        key={"#{name}Code"}
        mode={type}
        theme="monokai"
        onChange={@props.Action.onChange}
        name={name}
        width="#{width - 800}px"
        height="595px"
        editorProps={"$blockScrolling": true}
      />
    </div>
