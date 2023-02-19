menustate = {}

function menustate:init()
    atlasparser = require 'src.components.AtlasParser'
    transition = require 'src.Transition'
    menuFX = require 'src.states.resources.MenuStateFX'
    conductor = require 'src.components.Conductor'
    Math = require 'src.Math'
    utilities = require 'src.Utilities'

    conductor.load("abstraction")
    conductor.bpm = 122
    audioPlay = conductor.play()
    if not audioPlay then
        audioPlay = conductor.play()
    end

    MenuItemsIndex = {1, 3, 5}
    MenuItemsIndexSelected = {2, 4, 6}

    LogoSize = 0.5

    CurrentItem = 1
    Selected = false

    menuItemsImage, MenuItemsQuads = atlasparser.getQuads("menu/menu_atlas")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    logo = love.graphics.newImage("resources/images/menu/logo.png")
    transition.newIn(2)
end

function menustate:draw()
    love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
    local yp = 200
    for i = 1, #MenuItemsIndex, 1 do
        love.graphics.draw(menuItemsImage, MenuItemsQuads[MenuItemsIndex[i]], 20, yp, 0, 0.5, 0.5)
        yp = yp + 150
    end
    menuFX.render()
    love.graphics.draw(logo, 800, 300, 0, LogoSize, LogoSize, logo:getWidth() / 2, logo:getHeight() / 2)
    transition.render()
end

function menustate:update(elapsed)
    MenuItemsIndex = {1, 3, 5}
    MenuItemsIndex[CurrentItem] = MenuItemsIndexSelected[CurrentItem]

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
    end
    conductor.update()

    if utilities.varChanged(conductor.songPositionInSteps) then
        print("[EVENT] : On step")
        bumpLogo(0.55)
    end

    menuFX.update()
    LogoSize = Math.lerp(LogoSize, 0.5, 0.4)
end

function menustate:keypressed(k, code)
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
    menuFX.new(800, 300)
end

return menustate