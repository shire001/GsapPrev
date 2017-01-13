React = require 'react'
mime = require 'mime-types'
fs = require 'fs'
module.exports = React.createClass
  render: ->
    m = mime.lookup(@props.item?.name)
    switch m.split("/")?[0]
      when "image"
        cn = "property-image"
        content = <img src={@props.item.path} width="100%" />
      when "text"
        cn = "property-text"
        content = <pre> {fs.readFileSync(@props.item.path).toString()} </pre>
      when "audio"
        cn = "property-audio"
        content = <audio src={@props.item.path} controls />
      else
        console.log m
    size =
      if @props.item.size//1000000 > 0
        "#{(@props.item.size/1000000).toFixed(1)} MB"
      else if @props.item.size//1000 > 0
        "#{@props.item.size//1000} kB"
      else
        "#{@props.item.size} B"
    <ul id="FilePropertyView">
      <li>{"name: #{@props.item.name}"}</li>
      <li>{"size: #{size}"}</li>
      <li className={cn}>
        {content}
      </li>
    </ul>
