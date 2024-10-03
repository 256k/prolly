-- prolly
--
-- a looping
-- rando-probabilistic
-- sequencer
--
-- :by 256k

engine.name = "PolyPerc"
HALFSECOND = include("lib/halfsecond")
MusicUtil = require("musicutil")
SEQUENCER_LENGTH = 16

-- import local sequencer object
local Sequencer = include("lib/Sequencer")

notes_num = MusicUtil.generate_scale(3, "dorian", 3)

local seq_count = 16
local seqs = {}

menu_page = 1

local SCALE_NAMES = {}

for i = 1, #MusicUtil.SCALES do
	SCALE_NAMES[i] = MusicUtil.SCALES[i].name
end

function init()
	HALFSECOND.init()
	engine.release(0.33)
	engine.cutoff(600)

	params:add_separator(" ")
	params:add_separator("prolly settings")
	for i = 1, seq_count do
		-- sequencer(id, notearray, length, probability, cutoff)
		seqs[i] = Sequencer:new(i, notes_num, 16, 0, 800)
	end

	for i = 1, #seqs do
		seqs[i]:randomize()
		seqs[i]:run()
	end
end

function refresh()
	redraw()
end

function redraw()
	local y_space = 8
	screen.clear()
	screen.move(4, y_space * 1)
	screen.text("Length: " .. seqs[menu_page].length)
	screen.move(4, y_space * 2)
	screen.text("probability: " .. seqs[menu_page].prob)
	screen.move(4, y_space * 3)
	local note_name = MusicUtil.note_num_to_name(seqs[menu_page].note + seqs[menu_page].oct, true)
	screen.text("note: " .. note_name)
	screen.move(90, 10)
	screen.font_size(16)
	screen.text("[ " .. menu_page .. " ]")
	screen.font_size(8)
	seqs[menu_page]:draw_track_linear()

	screen.update()
end

function key(k, z)
	if k == 1 and z == 1 then
		seqs[menu_page]:randomize()
		screen.clear()
		screen.move(35, 28)
		screen.text("REGEN")
		screen.update()
		redraw()
	end
end

function enc(n, d)
	-- changing pages between diff sequencers
	if n == 1 then
		menu_page = util.clamp(menu_page + d, 1, seq_count)
	end
	if n == 2 then
		seqs[menu_page].length = util.clamp(seqs[menu_page].length + d, 1, 16)
	end
	if n == 3 then
		seqs[menu_page].prob = util.clamp(seqs[menu_page].prob + d, 0, 100)
	end
	redraw()
end

function map(OldValue, OldMin, OldMax, NewMin, NewMax)
	OldRange = (OldMax - OldMin)
	NewRange = (NewMax - NewMin)
	NewValue = (((OldValue - OldMin) * NewRange) / OldRange) + NewMin
	return math.floor(NewValue)
end

-- norns.script.load("code/prolly/prolly.lua")
