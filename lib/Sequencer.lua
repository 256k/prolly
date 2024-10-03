Sequencer = {}

function Sequencer:new(id, noteArray, length, prob, cutoff)
	local s = setmetatable({}, {
		__index = Sequencer,
	})
	s.id = id
	s.seq = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	s.noteArray = noteArray
	s.noteIndex = id
	s.oct = 57
	s.note = noteArray[s.noteIndex]
	s.length = length
	s.prob = prob
	s.step = 0
	s.cutoff = cutoff
	s.release = 0.3
	s.play = true
	s.tempoDiv = 4

	-- params:
	params:add_group("Track " .. id, 5)
	-------------------------------

	-- ControlSpec.new (min, max, warp, step, default, units, quantum, wrap)

	params:add({
		type = "control",
		id = "cutoff" .. id,
		name = "Cutoff",
		controlspec = controlspec.new(50, 5000, "exp", 0, 800, "hz"),
		action = function(x)
			s.cutoff = x
		end,
	})
	params:add({
		type = "option",
		id = "timeDiv" .. id,
		name = "Time div",
		default = 4,
		options = { 1, 2, 3, 4, 6, 8, 16, 32 },
		action = function(x)
			s.tempoDiv = x
		end,
	})
	params:add({
		type = "option",
		id = "note" .. id,
		name = "Note",
		options = s.noteArray,
		action = function(x)
			s.note = s.noteArray[x]
		end,
		default = s.noteArray[s.noteIndex],
	})
	params:add({
		type = "option",
		id = "octave" .. id,
		name = "octave",
		default = 5,
		options = { 1, 2, 3, 4, 5, 6, 7, 8 },
		action = function(x)
			s.oct = x * 12
		end,
	})

	s_release = controlspec.new(0.05, 3, "lin", 0, 0.5, "s")
	params:add({
		type = "control",
		id = "release" .. id,
		controlspec = s_release,
		action = function(x)
			s.release = x
			print(x)
		end,
	})

	return s
end

function Sequencer:lengthChange(d)
	s.length = util.clamp(s.length + d, 1, SEQUENCER_LENGTH)
end

function Sequencer:lengthChange(d)
	s.prob = util.clamp(s.prob + d, 1, 100)
end

function Sequencer:randomize()
	for i = 1, #self.seq do
		self.seq[i] = math.random(1, 100)
	end
end

function Sequencer:play()
	self.play = true
end

function Sequencer:stop()
	self.play = false
end

function Sequencer:draw_track_linear()
	print("track draw linear trigggered track: ")
	local startx = 6
	local starty = 40
	local blockw = 4
	local blockh = 8
	local offset = 4
	local xMargin = 10
	step = 1
	screen.blend_mode(1)
	for i = 1, SEQUENCER_LENGTH do
		if i == SEQUENCER_LENGTH + 1 then
			i = 1
		end

		stepLevel = map(self.seq[i], 0, 100, 20, 1)
		screen.level(15)

		-- this is the step value block
		screen.rect(xMargin + offset + startx * step, starty + 20, blockw, -stepLevel)
		if i > self.length then
			screen.level(0)
		end
		screen.fill()

		if i == self.step then
			screen.level(15)
		else
			screen.level(0)
		end
		if i > self.length then
			screen.level(0)
		end

		-- this is the step indicator stoke
		screen.rect(xMargin + offset + startx * step, starty + 20, blockw, -stepLevel)
		screen.stroke()
		screen.level(15)
		step = step + 1
	end

	-- this is the probability line
	screen.blend_mode(0)
	local probMapped = map(self.prob, 0, 100, 0, 20)
	screen.rect(xMargin + offset + startx - (blockw / 2), starty + probMapped - 1, (blockw + 2) * SEQUENCER_LENGTH, 1)
	-------------------------------
end

function Sequencer:trigger()
	-- checks probability for bang or no bang
	self:inc_step()
	if self.seq[self.step] < self.prob then
		local notefreq = MusicUtil.note_num_to_freq(self.note + self.oct)
		print("note: ", notefreq, self.note, self.oct)
		self:setEngine()
		engine.hz(notefreq)
	else
		-- skip step
	end
end

function Sequencer:setEngine()
	-- this is to update the engine with the cutoff and release values
	engine.cutoff(self.cutoff)
	engine.release(self.release)
end

function Sequencer:run()
	clock.run(function()
		while true do
			clock.sync(1 / self.tempoDiv)
			self:trigger()
			if menu_page == self.id then
			end
		end
	end)
end

function Sequencer:inc_step()
	-- increases the step advance and resets to 1 if over the length
	if self.step + 1 <= self.length then
		self.step = self.step + 1
	else
		self.step = 1
	end
end

return Sequencer
