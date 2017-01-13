React = require 'react'
brace = _interopRequire(require 'brace')
AceEditor = _interopRequire(require 'react-ace')
require 'brace/mode/javascript'
require 'brace/theme/github'

class @CodeView extends React.Component
  constructor: (props) ->
    super(props)

  onChange: (value) ->
    # @props.Action.setCode value
    console.log value

  render: ->
    width = (document.getElementById "Top").clientWidth
    <div id="code" className="codeView">
      <AceEditor
        key="code"
        mode="javascript"
        theme="github"
        onChange={@onChange}
        name="gsap"
        width="#{width - 800}px"
        height="625px"
        editorProps={"$blockScrolling": true}
      />
    </div>
