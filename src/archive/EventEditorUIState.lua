eventeditui = {}

function eventeditui.load()
    -- load and save control --
    gui:typetext("Load and save", {x=90, y=100, w=120})
    mapname = gui:input("position X", {x=90, y=130, w=128, h=24}, nil, "")
    songName = gui:input("position Y", {x=90, y=158, w=128, h=24}, nil, "dubnix")
    saveButton = gui:button("save", {x=90, y=186, w=64, h=24})
    loadButton = gui:button("load", {x=159, y=186, w=64, h=24})
    function saveButton.click(this, x, y, button)
        
    end
    function loadButton.click(this, x, y, button)
        mapraw = love.filesystem.read("resources/data/" .. mapname.value .. ".lvl")
        MapSettings = json.decode(mapraw)
    end

    -- camera controls --
    gui:typetext("Camera Controls", {x=390, y=100, w=120})
    xinput = gui:input("position X", {x=390, y=130, w=128, h=24}, nil, "1")
    yinput = gui:input("position Y", {x=390, y=158, w=128, h=24}, nil, "1")
    rotinput = gui:input("Camera angle", {x=390, y=186, w=128, h=24}, nil, "1")
    zoominput = gui:input("Camera zoom", {x=390, y=214, w=128, h=24}, nil, "1")
    bindButton = gui:button("Bind", {x=410, y=242, w=64, h=24})
    function bindButton.click(this, x, y, button)
        MapSettings.Events[selectedNoteID].events = {
            camX = xinput.value,
            camY = yinput.value,
            angle = rotinput.value,
            zoom = zoominput.value
        }
        debugcomponent.showTableContent(MapSettings.Events)
        MapSettings.Events[selectedNoteID].events.hasEvents = true
    end
end

return eventeditui