playstate = {}

playstate.levelToLoad = "nip-trip"

function playstate:init()
    player = require 'src.Player'
    conductor = require 'src.components.Conductor'
    camera = require 'libraries.camera'
    eventhandler = require 'src.components.EventHandler'
    Math = require 'src.Math'
    shoot = require 'src.events.Shoot'
    
    Camera = camera(love.graphics.getWidth() / 2 , love.graphics.getHeight() / 2)
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    tileImage, tileQuads = atlasparser.getQuads("atlas_sheet1")
    
    player:set(0, love.graphics.getHeight() / 2)

    MapSettings = {
        speed = 1.0,
        Blocks = {}
    }

    camZoom = 0.5

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
        Camera:attach()
            player:render() 
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
    camZoom = Math.lerp(camZoom, 1, 1.4)
    Camera:zoomTo(camZoom)

    for k, Block in pairs(MapSettings.Blocks) do
        if Block.x < 0 then
            table.remove(MapSettings.Blocks, k)
        end
        if utilities.collision(player:getHitbox(), Block) then
            print("[COLLISION] block")
        end
    end

    for k, projectile in pairs(shoot.Shoots) do
        if utilities.collision(player:getHitbox(), projectile) then
            print(print("[COLLISION] shoot"))
        end
    end
end

-------------------------------

function cameraBump(amount)
    camZoom = amount
end

return playstate