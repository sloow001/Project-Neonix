function love.load()
    gamestate = require 'libraries.gamestate'
    gui = require 'libraries.gspot'
    json = require 'libraries.json'
    camera = require 'libraries.camera'
    require 'libraries.json-beautify'
    lovefs = require 'libraries.nativefs'
    Controls = require 'src.components.Controls'
    Switch = require 'libraries.switch'
    Console = require 'libraries.console'
    moonshine = require 'libraries.moonshine'

    quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 20)
    love.graphics.setFont(quicksand)

    love.keyboard.setKeyRepeat(true)

    -- allowing joysticks and gamepads --
    local joysticks = love.joystick.getJoysticks()
	joystick = joysticks[1]

    states = {
        Menu = require 'src.states.MenuState',
        LevelEditor = require 'src.states.LevelEditorState',
        LevelSelect = require 'src.states.LevelSelectState',
        Playstate = require 'src.states.Playstate',
        Options = require 'src.states.OptionsState',
        Playlist = require 'src.states.PlaylistState'
        --EventEditor = require 'src.states.EventEditor'
    }

    effect = moonshine(moonshine.effects.glow)
    effect.glow.min_luma = 0.3

    gamestate.registerEvents()
    gamestate.switch(states.Playlist)
end

function love.draw()
    
end

function love.update(dt)
end
