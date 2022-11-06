Sequencer = {}

function Sequencer:new(note, length, prob)
  print("new Sequencer created")
    local s = setmetatable({}, {
        __index = Sequencer
    })
    -- s.generation = (g or counters.music_generation)
    -- s.x = x
    -- s.y = y
    -- s.id = "Sequencer-" .. fn.id() -- unique identifier for this Sequencer
    -- s.index = fn.index(x, y) -- location on the grid
    -- s.heading = h
    s.seq = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    s.note = note
    s.length = length
    s.prob = prob
    s.step = 1
    s.cutoff = 20
    s.release = 1
    s.play = true
    s.tempoDiv = 4

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
        self.seq[i] = math.random(1, 100);
    end
    tab.print(self.seq)
end

function Sequencer:play()
    self.play = true
end

function Sequencer:stop()
    self.play = false
end

function Sequencer:trigger()
    -- checks probability for bang or no bang
    if self.seq[self.step] < self.prob then
        engine.hz(self.note)
    else
        -- print("skip")
    end
    self:inc_step()
end

function Sequencer:run()
  clock.run(function()
    while true do
      clock.sleep(1/self.tempoDiv)
      self:trigger()
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