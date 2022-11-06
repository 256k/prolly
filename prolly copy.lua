-- prolly
-- a port of the euro module
-- by 256k

MusicUtil = require("musicutil")
sequins = require 'sequins'
SEQUENCER_LENGTH = 16

-- import local sequencer object
local Sequencer = include('lib/Sequencer')

local Seq_A = Sequencer:new()

notes_num = MusicUtil.generate_scale(60,"dorian")
-- print("notes_num")
-- print(notes_num)
notes_freq = MusicUtil.note_nums_to_freqs(notes_num)
-- print("notes_freq")
-- tab.print(notes_freq)
-- notes = sequins{notes_freq}

-- notes = sequins{MusicUtil.generate_scale(60,"dorian")}
-- tab.print(notes)

engine.name = "PolyPerc"
local a_seq = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local a_length = 16
local a_prob = 100
local a_step = 1
local a_cutoff = 20
local a_release = 1
local a_play = true
local a_tempofreq = 2

local b_seq = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local b_length = 16
local b_prob = 100
local b_step = 1
local b_cutoff = 20
local b_release = 1
local b_play = true

local b_tempofreq = 1

function init()
  engine.release(2)
  randomize_seq(a_seq)
  clock.run(function()  -- redraw the screen 
    while true do
      clock.sleep(1/15)
      redraw()
    end
  end)
  
  
  -- clock.run(function()
  --   while true do
  --     clock.sleep(1/a_tempofreq)

  --     a_trigger()
  --   end
  -- end)
  
  -- clock.run(function()
  --   while true do
  --     clock.sleep(1/b_tempofreq)
   
  --     b_trigger()
  --   end
  -- end)
  clock.run(function()
    while true do
      clock.sleep(1/Seq_A.tempoDiv)
      Seq_A:trigger()
    end
  end)
  
  
end

function redraw()
screen.clear()
screen.move(10,10)
screen.text("A Length: ".. a_length)
screen.move(10,20)
screen.text("A probability: ".. a_prob)
screen.update()  
end

function key(k,z)
if k==3 and z== 1 then randomize_seq(a_seq) randomize_seq(b_seq) end 
if k==2 and z==1 and a_play then a_play = false else a_play = true end
  print(a_play)
end

function enc(n,d)
  if n==2 then a_length = util.clamp(a_length + d, 1, 16) util.clamp(b_length + d, 1, 16) end
  if n==3 then a_prob = util.clamp(a_prob + d, 0, 100) util.clamp(b_prob + d, 0, 100) end
end

function a_trigger()
  -- notes_freq = 
  -- ta.print(notes())
  if a_seq[a_step] < a_prob then engine.hz(notes_freq[math.random(1,8)]) else print("skip") end
    if a_step + 1 <= a_length then a_step = a_step + 1 else a_step = 1 end
end

function b_trigger()
  -- notes_freq = 
  -- ta.print(notes())
  if b_seq[b_step] < b_prob then engine.hz(notes_freq[math.random(1,8)]) else print("skip") end
    if b_step + 1 <= b_length then b_step = b_step + 1 else b_step = 1 end
end


function randomize_seq(seq)
for i=1,#seq do
seq[i] = math.random(1, 100);
end

end
