eventhandler = {}

conductor = require 'src.components.Conductor'
utilities = require 'src.Utilities'

function eventhandler.load(filename)
    code, error = love.filesystem.load("resources/data/maps/" .. filename .. "/event.lua")
    if error ~= nil then
        print(error)
    end
end

function eventhandler.update(elapsed)
    if error == nil then
        conductor.update(elapsed)
        if utilities.varChanged(conductor.songPositionInBeats) then
            print("[EVENT] : On beat")
            pcall(code(), onBeat())
        end
        if utilities.varChanged(conductor.songPositionInSteps) then
            print("[EVENT] : On step")
            pcall(code(), onStep())
        end
    end
end

return eventhandler