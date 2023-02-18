playstate = {}

playstate.levelToLoad = "nip-trip"

function playstate:init()
    player = require 'src.Player'
    conductor = require 'src.components.Conductor'
    camera = require 'libraries.camera'
    
    Camera = camera(love.graphics.getWidth() / 2 , love.graphics.getHeight() / 2)
    camera.smooth.linear(3)
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    tileImage, tileQuads = atlasparser.getQuads("atlas_sheet1")
    
    player:set(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    MapSettings = {
        speed = 1.0,
        Blocks = {}
    }

    conductor.load(playstate.levelToLoad)
    raw = love.filesystem.read("resources/data/maps/" .. playstate.levelToLoad .. "/map.lvl")
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
    Console.draw()
end

function playstate:update(elapsed)
    player:update(elapsed)
    conductor.update()
    editorOffset = (MapSettings.speed * 1.5) + (editorOffset + (conductor.dspSongTime * 1000) * 0.5) + elapsed
    Camera:lookAt(math.floor(editorOffset), love.graphics.getHeight() / 2)

end


function playstate:keypressed(key, scancode, isrepeat)
    Console.keypressed(key, scancode, isrepeat)
end
  
function playstate:textinput(text)
    Console.textinput(text)
end

-------------------------------

function cameraBump(amount)
    
end

return playstate