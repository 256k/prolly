-- prolly
--
-- a looping
-- rando-probabilistic
-- sequencer
--
-- by 256k
hs = include("lib/halfsecond")
MusicUtil = require("musicutil")
sequins = require("sequins")
SEQUENCER_LENGTH = 16

-- import local sequencer object
local Sequencer = include("lib/Sequencer")

notes_num = MusicUtil.generate_scale(57, "dorian")

-- notes_freq = MusicUtil.note_nums_to_freqs(notes_num)

local seq_count = 8
local seqs = {}

local menu_page = 1

engine.name = "PolyPerc"

local SCALE_NAMES = {}

for i = 1, #MusicUtil.SCALES do
	SCALE_NAMES[i] = MusicUtil.SCALES[i].name
end

tab.print(SCALE_NAMES)

function init()
	params:add({
		type = "option",
		id = "scale_selection",
		name = "Scale",
		options = SCALE_NAMES,
		action = function(x)
			notes_num = MusicUtil.generate_scale(57, x)
		end,
	})

	params:add_separator("tracks")
	for i = 1, seq_count do
		-- sequencer(id, notearray, length, probability)
		seqs[i] = Sequencer:new(i, notes_num, 16, 0, 800)
	end

	engine.release(0.33)
	engine.cutoff(600)
	for i = 1, #seqs do
		seqs[i]:randomize()
		seqs[i]:run()
	end
	-- Seq_A:randomize()
	-- Seq_B:randomize()
	-- Seq_C:randomize()

	clock.run(function() -- redraw the screen
		while true do
			clock.sleep(1 / 10)
			-- redraw()
		end
	end)
end

hs.init()

function redraw()
	local y_space = 8
	screen.clear()
	screen.move(4, y_space * 1)
	screen.text("Length: " .. seqs[menu_page].length)
	screen.move(4, y_space * 2)
	screen.text("probability: " .. seqs[menu_page].prob)
	screen.move(4, y_space * 3)
	local note_name = MusicUtil.note_num_to_name(seqs[menu_page].note)
	-- print(note_name)
	screen.text("note: " .. note_name)
	screen.move(90, 10)
	screen.font_size(16)
	screen.text("[ " .. menu_page .. " ]")
	screen.font_size(8)
	seqs[menu_page]:draw_track()

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
