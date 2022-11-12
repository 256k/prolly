Sequencer = {}

function Sequencer:new(id, noteArray, length, prob, cutoff)
  print("new Sequencer created")
  tab.print(noteArray)
    local s = setmetatable({}, {
        __index = Sequencer
    })
    s.id = id
    s.seq = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    s.noteArray = noteArray
    s.noteIndex = id
    s.note = s.noteArray[s.noteIndex]
    s.length = length
    s.prob = prob
    s.step = 1
    s.cutoff = cutoff
    s.release = 0.3
    s.play = true
    s.tempoDiv = 4

    -- params:
    
    params:add_group("Track "..id,4)
    s_cutoff = controlspec.new(50,5000,'exp',0,800,'hz')
  params:add{type="control",id="cutoff"..id,controlspec=s_cutoff,
    action=function(x) s.cutoff=x print(x) end}
    s_release = controlspec.new(0.05,3,'lin',0,0.5,'s')
  params:add{type="control",id="release"..id,controlspec=s_release,
    action=function(x) s.release=x print(x) end}
    s_note = controlspec.new(1,8,'lin',1,1)
  params:add{type="control",id="note"..id,controlspec=s_note,
    action=function(x) s.note=s.noteArray[x] print(x) end}
    s_div = controlspec.new(1,8,'lin',1,1)
  params:add{type="control",id="division"..id,name="time div",controlspec=s_div,
  action=function(x) s.tempoDiv = 2^x end}
-- print(s.noteArray[s.noteIndex])
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
    -- tab.print(self.seq)
end

function Sequencer:play()
    self.play = true
end

function Sequencer:stop()
    self.play = false
end

function Sequencer:draw_map()
local startx = 10
local starty = 40
local blockw = 4
local blockh = 4
screen.move(startx, starty)
for i=1,SEQUENCER_LENGTH do
    screen.level(15)
    screen.move_rel()
screen.rect(blockw, blockw)
screen.stroke()
screen.move_rel(blockw, starty)
end
end

function Sequencer:trigger()
  print("trigger", self.id)
    -- checks probability for bang or no bang
    if self.seq[self.step] < self.prob then
        -- print("test" .. self.noteArray[self.noteIndex])
        local notefreq = MusicUtil.note_num_to_freq(self.note)
        self:setEngine()
        print(notefreq)
        engine.hz(notefreq)
    else
        -- print("skip")
    end
    self:inc_step()
end
function Sequencer:setEngine()
    print("set engine")
    engine.cutoff(self.cutoff)
    engine.release(self.release)
end

function Sequencer:run()
  clock.run(function()
    while true do
      clock.sync(1/self.tempoDiv)
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