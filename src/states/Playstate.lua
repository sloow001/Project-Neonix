playstate = {}

playstate.levelToLoad = "nip-trip"

function playstate:init()
    player = require 'src.Player'
    conductor = require 'src.components.Conductor'
    camera = require 'libraries.camera'
    eventhandler = require 'src.components.EventHandler'
    
    Camera = camera(love.graphics.getWidth() / 2 , love.graphics.getHeight() / 2)
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    tileImage, tileQuads = atlasparser.getQuads("atlas_sheet1")
    
    player:set(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    MapSettings = {
        speed = 1.0,
        Blocks = {}
    }

    conductor.load(playstate.levelToLoad)
    raw = love.filesystem.read("resources/data/maps/" .. playstate.levelToLoad .. "/map.lvl")
    rawData = love.filesystem.read("resources/data/maps/" .. playstate.levelToLoad .. "/info.data")
    eventhandler.load(playstate.levelToLoad)
    MapSettings = json.decode(raw)

    editorOffset = 0
    conductor.play()
end

function playstate:draw()
    love.graphics.draw(bg, 0, 0, 0, 1.2, 1.2)
    effect(function()
        player:render()  
        Camera:attach()
            for k, Block in pairs(MapSettings.Blocks) do
                love.graphics.draw(tileImage, tileQuads[Block.id], Block.x, Block.y)
            end    
        Camera:detach()  
    end)
end

function playstate:update(elapsed)
    player:update(elapsed)
    conductor.update()
    editorOffset = (MapSettings.speed * 1.5) + (editorOffset + (conductor.dspSongTime * 1000) * 0.5) + elapsed
    Camera:lookAt(math.floor(editorOffset), love.graphics.getHeight() / 2)
    eventhandler.update(elapsed)
end

-------------------------------

function cameraBump(amount)
    Camera:zoom()
end

return playstate