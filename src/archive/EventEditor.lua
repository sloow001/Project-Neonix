eventeditor = {}

function eventeditor:init()
	local UI = require 'src.states.resources.EventEditorUIState'
	conductor = require 'src.components.Conductor'
	atlasparser = require 'src.components.AtlasParser'
	utilities = require 'src.Utilities'
	debugcomponent = require 'src.components.Debug'

	quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 15)
    love.graphics.setFont(quicksand)

	UI.load()

	-- cursor -
	cursor = love.graphics.newImage("resources/images/editor/cursor_default.png")
	love.mouse.setVisible(false)

	bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
	EventNote = love.graphics.newImage("resources/images/editor/eventNote.png")
    tileImage, tileQuads = atlasparser.getQuads("atlas_sheet3")

	MapSettings = {
		speed = 1.0,
		Events = {},
		Blocks = {}
	}

	marker = 0
	selectedNoteID = 1

	editorOffset = 0
	isPlaystating = false
	isEditing = true
	canPlace = true
end

function eventeditor:draw()

	love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
	love.graphics.print("is Editing :" .. tostring(isEditing), 10, 80)
	print(selectedNoteID)
	
	love.graphics.setColor(utilities.rgbToColor(100, 100, 100, 100))
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 64)
	love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))
	love.graphics.setLineWidth(5)
	love.graphics.rectangle("line", 0, 0, love.graphics.getWidth() - 5, 64)
	love.graphics.setLineWidth(1)
	love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 100))
	for g = 1, 1280, 64 do
		love.graphics.rectangle("line", g, 0, 64, 64)
	end
	love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))
	for k, note in pairs(MapSettings.Events) do
		if note.hasEvents then
			love.graphics.setColor(utilities.rgbToColor(0, 255, 255, 255))
		else
			love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))
		end
		if note.isSelected then
			love.graphics.setColor(utilities.rgbToColor(255, 0, 255, 255))
		else
			love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))
		end
		love.graphics.draw(EventNote, note.x - (editorOffset * 32), 0)
		love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))
	end


	for k, Block in pairs(MapSettings.Blocks) do
        love.graphics.draw(tileImage, tileQuads[Block.id], Block.x - (editorOffset * 32), Block.y)
        if Block.collidable then
            love.graphics.setColor(utilities.rgbToColor(255, 0, 0, 100))
            love.graphics.rectangle("fill", Block.x - (editorOffset * 32), Block.y, Block.w, Block.h)
            love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))
        end
    end

	if canPlace then
		love.graphics.setColor(utilities.rgbToColor(255, 0, 0, 255))
		love.graphics.rectangle("line", marker, 0, 64, 64)
		love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))
	end


    gui:draw()
	love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end

function eventeditor:update(elapsed)
    gui:update(elapsed)

	if isPlaystating then
		conductor.update(elapsed)
	end

	marker = math.floor(love.mouse.getX() / 32) * 32

	if love.mouse.getY() < 64 then
		canPlace = true
	else
		canPlace = false
	end
end

function eventeditor:keypressed (key, code, isrepeat)
	if gui.focus then
		gui:keypress(key)
	end
	if key == "tab" then
		if isEditing then
			isEditing = false
		else
			isEditing = true
		end
	end
end

function eventeditor:textinput(key)
	if gui.focus then
		gui:textinput(key) 
	end
end

function eventeditor:mousepressed(x, y, button)
	gui:mousepress(x, y, button)
	if button == 1 then
		if isEditing and canPlace then
			placeNote(marker)
		end
		if not isEditing and canPlace then
			selectedNoteID = selectNote(marker)
		end
	end
	if button == 2 then
		if isEditing and canPlace then
			removeNote(marker)
		end
	end
end

function eventeditor:mousereleased(x, y, button)
	gui:mouserelease(x, y, button)
end

function eventeditor:wheelmoved(x, y)
    if y > 0 then
		editorOffset = editorOffset + 1
	end
	if y < 0 then
		editorOffset = editorOffset - 1
	end
end

---------------------------------------------------------------

function placeNote(x)
	Note = {
		x = x,
		hasEvents = false,
		isSelected = false,
		events = nil
	}

	table.insert(MapSettings.Events, Note)
end

function removeNote(x)
	for k, note in pairs(MapSettings.Events) do
		if note.x == x then
			table.remove(MapSettings.Events, k)
		end
	end
end

function selectNote(x)
	for k, note in pairs(MapSettings.Events) do
		if note.x == x then
			return k
		end
	end
end

return eventeditor