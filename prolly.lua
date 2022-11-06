-- prolly
-- a port of the euro module
-- by 256k
hs = include('lib/halfsecond')
MusicUtil = require("musicutil")
sequins = require 'sequins'
SEQUENCER_LENGTH = 16

-- import local sequencer object
local Sequencer = include('lib/Sequencer')

notes_num = MusicUtil.generate_scale(57,"dorian")
notes_freq = MusicUtil.note_nums_to_freqs(notes_num)


local seq_count = 8
local seqs = {}

for i=1,seq_count do
seqs[i] = Sequencer:new(notes_freq[i], 16, 0)
end

local menu_page = 1

engine.name = "PolyPerc"

function init()
  engine.release(0.33)
  engine.cutoff(600)
  for i=1,#seqs do
  seqs[i]:randomize()
  seqs[i]:run()
  end
  -- Seq_A:randomize()
  -- Seq_B:randomize()
  -- Seq_C:randomize()

  clock.run(function()  -- redraw the screen 
    while true do
      clock.sleep(1/10)
      redraw()
    end
  end)
  
end

hs.init()

function redraw()
screen.clear()
screen.move(10,10)
screen.text("sequencer "..menu_page.." Length: ".. seqs[menu_page].length)
screen.move(10,20)
screen.text("sequencer "..menu_page.." probability: ".. seqs[menu_page].prob)
screen.update()  
end

function key(k,z)
if k==1 and z== 1 then 
  seqs[menu_page]:randomize()
  screen.clear()
  screen.move(35,28)
  screen.text("REGEN")
  screen.update()
  -- redraw()
  end
end

function enc(n,d)
  -- changing pages between diff sequencers
  if n==1 then menu_page = util.clamp(menu_page + d, 1,seq_count) end
  if n==2 then seqs[menu_page].length = util.clamp(seqs[menu_page].length + d, 1, 16)  end
  if n==3 then seqs[menu_page].prob = util.clamp(seqs[menu_page].prob + d, 0, 100)  end
end

-- function a_trigger()
--   -- notes_freq = 
--   -- ta.print(notes())
--   if a_seq[a_step] < a_prob then engine.hz(notes_freq[math.random(1,8)]) else print("skip") end
--     if a_step + 1 <= a_length then a_step = a_step + 1 else a_step = 1 end
-- end

-- function b_trigger()
--   -- notes_freq = 
--   -- ta.print(notes())
--   if b_seq[b_step] < b_prob then engine.hz(notes_freq[math.random(1,8)]) else print("skip") end
--     if b_step + 1 <= b_length then b_step = b_step + 1 else b_step = 1 end
-- end


-- function randomize_seq(seq)
-- for i=1,#seq do
-- seq[i] = math.random(1, 100);
-- end

-- end
