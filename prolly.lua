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
-- notes_freq = MusicUtil.note_nums_to_freqs(notes_num)


local seq_count = 8
local seqs = {}


local menu_page = 1

engine.name = "PolyPerc"

function init()
  for i=1,seq_count do
    -- sequencer(note, length, probability)
seqs[i] = Sequencer:new(notes_num[i], 16, 0)
end

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
  local y_space = 8
screen.clear()
screen.move(4,y_space*1)
screen.text("Length: ".. seqs[menu_page].length)
screen.move(4,y_space*2)
screen.text("probability: ".. seqs[menu_page].prob)
screen.move(4,y_space*3)
local note_name = MusicUtil.note_num_to_name(seqs[menu_page].note) 
-- print(note_name)
screen.text("note: "..note_name )
screen.move(90, 10)
screen.font_size(16)
screen.text("[ "..menu_page.." ]")
screen.font_size(8)

-- seqs[menu_page].draw_map()
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

