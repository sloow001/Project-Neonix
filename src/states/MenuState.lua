menustate = {}

function menustate:init()
    atlasparser = require 'src.components.AtlasParser'
    transition = require 'src.Transition'
    menuFX = require 'src.states.resources.MenuStateFX'
    conductor = require 'src.components.Conductor'
    Math = require 'src.Math'
    utilities = require 'src.Utilities'
    tween = require 'libraries.tween'

    conductor.load("abstraction")
    conductor.bpm = 122
    audioPlay = conductor.play()
    if not audioPlay then
        audioPlay = conductor.play()
    end

    MenuItemsIndex = {7,5,3,1}
    MenuItemsIndexSelected = {8,6,4,2}

    lastSavedBeat = conductor.songPositionInSteps

    LogoSize = 0.5

    --particle system
    fade = love.graphics.newImage("resources/images/FX/glow.png")
    psystem = love.graphics.newParticleSystem(fade, 32)
	psystem:setParticleLifetime(10) -- Particles live at least 2s and at most 5s.
	psystem:setLinearAcceleration(-5, -5, 50, 100) -- Randomized movement towards the bottom of the screen.
    psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to black.

    CurrentItem = 1
    Selected = false

    menuItemsImage, MenuItemsQuads = atlasparser.getQuads("menu/menu_atlas")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    logo = love.graphics.newImage("resources/images/menu/logo.png")
    studioLogo = love.graphics.newImage("resources/images/logoTransparent.png")
    transition.newIn(2)

    quicksand = love.graphics.newFont("resources/fonts/quicksand-semibold.ttf", 40)
    love.graphics.setFont(quicksand)
end

function menustate:draw()
    local txt = "Press [Enter] to start"
    love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
    local yp = 100
    for i = 1, #MenuItemsIndex, 1 do
        love.graphics.draw(menuItemsImage, 
        MenuItemsQuads[MenuItemsIndex[i]], 30, yp, 0, 0.5, 0.5)
        yp = yp + 150
    end
    menuFX.render()
    love.graphics.draw(psystem, 800, 280, 0, 0.5, 0.5)
    love.graphics.draw(logo, 800, 280, 0, 
    LogoSize, LogoSize, 
    logo:getWidth() / 2, logo:getHeight() / 2)
    love.graphics.draw(studioLogo, 1060, 580, 0, 0.2, 0.2)
    transition.render()
end

function menustate:update(elapsed)
    MenuItemsIndex = {7,5,3,1}
    MenuItemsIndex[CurrentItem] = MenuItemsIndexSelected[CurrentItem]

    psystem:update(elapsed)

    if CurrentItem < 1 then
        CurrentItem = #MenuItemsIndex
    end
    if CurrentItem > #MenuItemsIndex then
        CurrentItem = 1
    end

    if Selected then
        onComplete = transition.update(elapsed)
    end
    if onComplete then
        if CurrentItem == 1 then
            gamestate.switch(states.LevelSelect)
        end
        if CurrentItem == 2 then
            gamestate.switch(states.Playlist)
        end
        if CurrentItem == 3 then
            gamestate.switch(states.Options)
        end
        if CurrentItem == 3 then
            gamestate.switch(states.Credits)
        end
    end
    conductor.update()

    if conductor.songPositionInSteps ~= lastSavedBeat then
        lastSavedBeat = conductor.songPositionInSteps
        print("[EVENT] : On step")
        bumpLogo(0.55)
    end

    menuFX.update()
    LogoSize = Math.lerp(LogoSize, 0.5, 0.4)
end

function menustate:keypressed(k, code)
    if not enterPressed then
        if k == Controls.Keyboard.ACCEPT then
            enterPressed = true
        end
    end
    if not Selected then
        if k == Controls.Keyboard.SELECT_UP then
            CurrentItem = CurrentItem - 1
        end
        if k == Controls.Keyboard.SELECT_DOWN then
            CurrentItem = CurrentItem + 1
        end
        if k == Controls.Keyboard.ACCEPT then
            transition.newIn(2)
            Selected = true
        end
    end
end

function menustate:gamepadpressed(jstk, button)
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_UP) then
        CurrentItem = CurrentItem - 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_DOWN) then
        CurrentItem = CurrentItem + 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.ACCEPT) then
        Selected = true
    end
end

--------------------------------------------------

function bumpLogo(amount)
    LogoSize = amount
    menuFX.new(800, 280)
    psystem:emit(10)
end

return menustate