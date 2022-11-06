-- prolly
-- a port of the euro module
-- by 256k

MusicUtil = require("musicutil")
sequins = require 'sequins'
SEQUENCER_LENGTH = 16

-- import local sequencer object
local Sequencer = include('lib/Sequencer')

notes_num = MusicUtil.generate_scale(57,"dorian")
-- print("notes_num")
-- print(notes_num)
notes_freq = MusicUtil.note_nums_to_freqs(notes_num)
-- print("notes_freq")
-- tab.print(notes_freq)
-- notes = sequins{notes_freq}

-- notes = sequins{MusicUtil.generate_scale(60,"dorian")}
-- tab.print(notes)


local Seq_A = Sequencer:new(notes_freq[1], 7, 40)
local Seq_B = Sequencer:new(notes_freq[3], 3, 30)
local Seq_C = Sequencer:new(notes_freq[7], 5, 60)


engine.name = "PolyPerc"
-- local a_seq = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
-- local a_length = 16
-- local a_prob = 100
-- local a_step = 1
-- local a_cutoff = 20
-- local a_release = 1
-- local a_play = true
-- local a_tempofreq = 2

-- local b_seq = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
-- local b_length = 16
-- local b_prob = 100
-- local b_step = 1
-- local b_cutoff = 20
-- local b_release = 1
-- local b_play = true
-- local b_tempofreq = 1

function init()
  engine.release(0.33)
  engine.cutoff(600)
  Seq_A:randomize()
  Seq_B:randomize()
  Seq_C:randomize()

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
      clock.sleep(1/4)
      Seq_A:trigger()
    end
  end)

  clock.run(function()
    while true do
      clock.sleep(1/4)
      Seq_B:trigger()
    end
  end)
 
  clock.run(function()
    while true do
      clock.sleep(1/4)
      Seq_C:trigger()
    end
  end)
  
  
end

function redraw()
screen.clear()
screen.move(10,10)
screen.text("A Length: ".. Seq_A.length)
screen.move(10,20)
screen.text("A probability: ".. Seq_A.prob)
screen.update()  
end

function key(k,z)
if k==3 and z== 1 then 
  Seq_A:randomize() 
   Seq_B:randomize() 
    Seq_C:randomize() 
  end 
if k==2 and z==1 and a_play then a_play = false else a_play = true end
  print(a_play)
end

function enc(n,d)
  if n==2 then Seq_A.length = util.clamp(Seq_A.length + d, 1, 16) Seq_B.length =  util.clamp(Seq_B.length + d, 1, 16) Seq_C.length =   util.clamp(Seq_C.length + d, 1, 16)  end
  if n==3 then Seq_A.prob = util.clamp(Seq_A.prob + d, 0, 100) Seq_B.prob = util.clamp(Seq_B.prob + d, 0, 100)Seq_C.prob = util.clamp(Seq_C.prob + d, 0, 100) end
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
