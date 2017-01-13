{app, BrowserWindow, Menu, Dialog, ipcMain, crashReporter} = require('electron')
fs = require 'fs'

# crashReporter.start()

mainWindow = null

app.on('window-all-closed', () ->
  if (process.platform != 'darwin')
    app.quit()
)
path = null
path = "/Users/tsunade/Documents/test/" #for debugging
createProject =  (cb) ->
  if path?
    cb()
  else
    Dialog.showSaveDialog (p)->
      path = p + '/'
      fs.mkdir p, (err)->
        if err
          console.log err
        cb()

captureWindow = () ->
  console.log "capture"
  mainWindow.capturePage (image) ->
    console.log image
    fs.writeFile "#{path}dist/screenshot.bmp", image.toBitmap()
  mainWindow.webContents.send('capture', 'start')

ipcMain.on 'requestPath-message', (e) ->
  e.sender.send 'requestPath-reply', path

showSetting = () ->

name = 'GSAP PlayGround'
menu = Menu.buildFromTemplate([
  {
    label: name,
    submenu: [
      {label: 'Preferences...', accelerator: 'CmdOrCtrl+,', click: showSetting},
      {
        type: 'separator'
      },
      {
        label: 'Hide ' + name,
        accelerator: 'Command+H',
        role: 'hide'
      },
      {
        label: 'Hide Others',
        accelerator: 'Command+Alt+H',
        role: 'hideothers'
      },
      {
        label: 'Show All',
        role: 'unhide'
      },
      {
        type: 'separator'
      },
      {label: 'Exit', accelerator: 'CmdOrCtrl+Q', click: app.quit}
    ]
  },
  {
    label: 'File',
    submenu: [
      {
        label: 'New Project',
        accelerator: 'CmdOrCtrl+N',
        click: createProject
      },
      {
        label: 'Capture',
        accelerator: 'CmdOrCtrl+Shift+C',
        click: captureWindow
      },
    ]
  },
  {
    label: 'Edit',
    submenu: [
      {
        label: 'Undo',
        accelerator: 'CmdOrCtrl+Z',
        role: 'undo'
      },
      {
        label: 'Redo',
        accelerator: 'Shift+CmdOrCtrl+Z',
        role: 'redo'
      },
      {
        type: 'separator'
      },
      {
        label: 'Cut',
        accelerator: 'CmdOrCtrl+X',
        role: 'cut'
      },
      {
        label: 'Copy',
        accelerator: 'CmdOrCtrl+C',
        role: 'copy'
      },
      {
        label: 'Paste',
        accelerator: 'CmdOrCtrl+V',
        role: 'paste'
      },
      {
        label: 'Select All',
        accelerator: 'CmdOrCtrl+A',
        role: 'selectall'
      },
    ]
  },
  {
    label: 'View',
    submenu: [
      {
        label: 'Reload',
        accelerator: 'CmdOrCtrl+R',
        click: (item, focusedWindow) ->
          if (focusedWindow)
            focusedWindow.reload()
      },
      {
        label: 'Toggle Full Screen',
        accelerator: (() ->
          if (process.platform == 'darwin')
            return 'Ctrl+Command+F'
          else
            return 'F11';
        )(),
        click: (item, focusedWindow) ->
          if (focusedWindow)
            focusedWindow.setFullScreen(!focusedWindow.isFullScreen())
      },
      {
        label: 'Toggle Developer Tools',
        accelerator: (() ->
          if (process.platform == 'darwin')
            return 'Alt+Command+I';
          else
            return 'Ctrl+Shift+I';
        )(),
        click: (item, focusedWindow) ->
          if (focusedWindow)
            focusedWindow.toggleDevTools()
      },
    ]
  },
  {
    label: 'Window',
    role: 'window',
    submenu: [
      {
        label: 'Minimize',
        accelerator: 'CmdOrCtrl+M',
        role: 'minimize'
      },
      {
        label: 'Close',
        accelerator: 'CmdOrCtrl+W',
        role: 'close'
      },
    ]
  },
  {
    label: 'Help',
    role: 'help',
    submenu: [
      {
        label: 'Learn More',
        click: () -> require('electron').shell.openExternal('http://electron.atom.io')
      },
    ]
  },
])

app.on('ready', () ->
  # ブラウザ(Chromium)の起動, 初期画面のロード
  cb = ->
    mainWindow = new BrowserWindow({width: 1200, height: 800})
    mainWindow.loadURL('file://' + __dirname + '/index.html')
    Menu.setApplicationMenu(menu)

    mainWindow.on('closed', () ->
      mainWindow = null
    )
  createProject cb
)
