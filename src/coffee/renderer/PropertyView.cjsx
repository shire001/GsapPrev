React = require 'react'
FilePropertyView = require './property/FilePropertyView.js'
module.exports = React.createClass
  getDefaultProps: ->
    type: null
    item: null
  render: ->
    if @props.type?
      item = switch @props.type
        when "file"
          <FilePropertyView item={@props.item} />
    <div id="PropertyView">
      {item}
    </div>
