React = require 'react'

fs = require 'fs'
{remote} = require 'electron'
{exec} = remote.require('child_process')
update = require 'react-addons-update'
module.exports = React.createClass
  getInitialState: ->
    files: []
    selected: null
  componentDidMount: ->
  onDropItem: (e) ->
    e.preventDefault()
    e.stopPropagation()
    console.log e.dataTransfer.files?[0]
    targetPath = @props.path
    if e.currentTarget.classList.contains("directory")
      targetPath += e.currentTarget.attributes.value.textContent
    console.log targetPath
    exec "cp \"#{e.dataTransfer.files?[0].path}\" \"#{targetPath}\"", (err) =>
      if err?
        console.log err
      else
      @readDir()
  setFiles: (target, obj) ->
    if Array.isArray target
      indexes = target
    else
      target = target.parentNode while not target.classList.contains("fileview-ele")
      indexes = target.attributes.alt.textContent.split("-")
    diff = {}
    cur_inner = diff
    for i in indexes
      cur = cur_inner[i] = {}
      cur_inner = cur.inner = {}
    delete cur.inner
    cur["$merge"] = obj
    newFiles = update @state.files, diff
    @setState files: newFiles
  createFileList: (files, path="", indexes="") ->
    i = 0
    items = files.map (file) =>
      if file.name[0] is "."
        i++
        return null
      cl = "fileview-ele"
      cl += " selected" if @state.selected is "#{path}#{file.name}"
      if file.isDirectory
        if file.isLoaded and file.isOpen
          cl += " open"
          inner = @createFileList file.inner, "#{path}#{file.name}/", "#{indexes}#{i}-"
        cl += " directory"
        draggable = false
      else
        draggable = true
        ondrag = (e) ->
          e.dataTransfer.setData "text/plain", e.currentTarget.attributes.value.textContent
      <li key={file.name} onClick={file.onclick} onDrop={@onDropItem} onDragStart={ondrag} draggable={draggable}
          className={cl} value="#{path}#{file.name}" alt="#{indexes}#{i++}">
        <i className={file.className}/> {file.name}
        {inner}
      </li>
    <ul className="fileview" onDrop={@onDropItem}>{items}</ul>
  readDir: (path=@props.path, cb=((files) => @setState files: files)) ->
    fs.readdir path, (err, ret) =>
      files = []
      return unless ret?
      for file in ret
        f = {}
        f.name = file
        f.isDirectory = fs.statSync("#{path}#{file}").isDirectory()
        if f.isDirectory
          f.className = "fa fa-folder"
          f.onclick = ((n) => ((e) =>
            e.stopPropagation()
            target = e.target
            target = target.parentNode while not target.classList.contains("fileview-ele")
            indexes = target.attributes.alt.textContent.split("-")
            currentTarget = @state.files
            currentTarget_inner = currentTarget
            diff = {}
            cur_inner = diff
            for i in indexes
              currentTarget = currentTarget_inner[i]
              currentTarget_inner = currentTarget.inner
              cur = cur_inner[i] = {}
              cur_inner = cur.inner = {}
            delete cur.inner
            if currentTarget?.isOpen
              cur["$merge"] = {isOpen: false}
              newFiles = update @state.files, diff
              @setState files: newFiles
            else
              p = e.currentTarget.attributes.value.textContent
              @readDir "#{@props.path}#{p}/", ((c, d) => ((inner) =>
                c["$merge"] = {inner: inner, isLoaded: true, isOpen: true}
                newFiles = update @state.files, d
                @setState files: newFiles))(cur, diff)
            ))(files.length)
        else
          f.className = "fa fa-file-o"
          f.onclick = (e) =>
            selected = {}
            path = e.currentTarget.attributes.getNamedItem("value")?.value
            selected.path = @props.path + path
            selected.name = selected.path.split("/").pop()
            stat = fs.statSync(selected.path)
            selected.size = stat.size
            console.log selected
            target = e.currentTarget
            @props.Action.setProperty "file", selected
            console.log
            @setState selected: path
        files.push f
      cb files
  render: ->
    if @props.path? and @state.files.length < 1
      @readDir()
    items = @createFileList @state.files
    <div id="FileView" onDrop={@onDropItem}>
      {items}
    </div>
