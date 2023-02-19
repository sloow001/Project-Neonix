conductor = {
    bpm = 0.0,
    secPerBeat = 0,
    songPosition = 0,
    songPositionInBeats = 0,
    crochet = 0,
    stepCrochet = 0,
    firstBeatOffset = 0,
    dspSongTime = 0,
    songPositionInSteps = 0,
}


function conductor.load(filename)
    audio = love.audio.newSource("resources/sounds/" .. filename .. ".ogg", "static")

    conductor.secPerBeat = 60.0 / conductor.bpm
    conductor.crochet = ((60 / conductor.bpm) * 1000)
    conductor.stepCrochet = conductor.crochet / 4
    conductor.dspSongTime = audio:tell("seconds")
end

function conductor.setPosition(seconds)
    if audio ~= nil then
        audio:seek(seconds, "seconds")
        return true
    else
        return false
    end
end

function conductor.play()
    if audio ~= nil then
        audio:play()
        return true
    else
        return false
    end
end

function conductor.pause()
    if audio ~= nil then
        audio:pause()
        return true
    else
        return false
    end
end

function conductor.stop()
    if audio ~= nil then
        audio:stop()
        return true
    else
        return false
    end
end

function conductor.update(dt)
    if audio ~= nil then
        conductor.songPosition = audio:tell("seconds") - conductor.dspSongTime - conductor.firstBeatOffset
        conductor.songPositionInBeats = math.floor(conductor.songPosition / conductor.secPerBeat)
        conductor.songPositionInSteps = math.floor(audio:tell("seconds") - conductor.dspSongTime / conductor.stepCrochet)
    end
end

return conductor