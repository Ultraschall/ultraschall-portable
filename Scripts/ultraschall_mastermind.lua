--[[
################################################################################
# 
# Copyright (c) 2014-2017 Ultraschall (http://ultraschall.fm)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
################################################################################
]]
 

-- Print Message to console (debugging)
function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end


--Mastermind 1.2 for ultraschall
debug=false
function dbg(text)
    if debug then reaper.ShowConsoleMsg(tostring(text).."\n") end
end

function InitGFX()
  gfx.init("Ultramind",256,512)
  InitMatrix()
  InitColors()
  colorPicker=false
  OkButton=false
  GameWon=false
  RedrawBoard()
end

function drawColorPin(row, col, color)
  radius=14 row=10-row col=col-1
  gfx.set(color_r[color], color_g[color], color_b[color])

  if color>0 and color<7 then
    gfx.circle(15+21+col*42, 48+21+row*42,radius,true)
  end
  if color==0 then
    gfx.circle(15+21+col*42, 48+21+row*42,6,true)
    gfx.circle(15+21+col*42, 48+21+row*42,12,false)
  end
end

function drawColorPicker(row, col)
  ColorPicker_row=row ColorPicker_col=col
  r=26 row=10-row
  local arc=math.pi/3.0
  local cx,cy=15-21+col*42, 48+21+row*42
  for i=1,6 do
    gfx.set(color_r[i], color_g[i], color_b[i])
    gfx.circle(cx+r*math.cos((i+3)*arc), cy+r*math.sin((i+3)*arc),r/2,true,true)
    gfx.set(0)
    gfx.circle(cx+r*math.cos((i+3)*arc), cy+r*math.sin((i+3)*arc),r/2,false,true)
    gfx.circle(cx+r*math.cos((i+3)*arc), cy+r*math.sin((i+3)*arc),r/2-1,false,true)    
  end
  ColorPicker=true 
end

function drawSmallPin(row, pos, color)
  row=10-row
  if color==1 then gfx.set(1) end --white
  if color==2 then gfx.set(0) end --black
  
  if pos==1 then x=15+42*4+1+12+11 y=48+21+row*42-10 end
  if pos==2 then x=15+42*4+1+12+31 y=48+21+row*42-10 end
  if pos==3 then x=15+42*4+1+12+11 y=48+21+row*42+10 end
  if pos==4 then x=15+42*4+1+12+31 y=48+21+row*42+10 end
  
  if color> 0 then gfx.circle(x,y,8,true) end
  if color==0 then gfx.set(0) gfx.circle(x,y,2,true) gfx.circle(x,y,6,false) end
end

function RedrawBoard()
  gfx.set(0) gfx.rect(0,0,256,512,true) --clear screen
  WriteCenteredText("Ultramind", 1,"Arial bold",22,10)
  gfx.set(0.8,0.54,0.37) gfx.rect(10,42,241,460,true) -- brown background rect
  
  even_color=.5 odd_color=.6
  for row=1,10 do
    gfx.set(even_color)
    if row==Round then gfx.set(.9) end
    gfx.rect(15,48+42*(10-row),231,42,true)
    --gfx.rect(15,48+42*(10-row),231,42,false)
    --gfx.rect(15+1,48+42*(10-row)+1,231-2,42-2,false)
    
    even_color,odd_color=odd_color,even_color
    for col=1,4 do
      drawColorPin(row, col, Board[row][col])
    end
    
    for pos=1,4 do drawSmallPin(row,pos,SmallPins[row][pos]) end --draw small pins   
  end

  if not GameWon and not lost then WriteCenteredText("Let's go!", 0,"Arial",18,474) end
  if GameWon then WriteCenteredText("You won the game!!!", 0,"Arial",18,474) end
  if lost then WriteCenteredText("You lost :-(", 0,"Arial",18,474) end
end

function WriteCenteredText(text, color, font, size,y)
  gfx.set(color) gfx.setfont(1,font, size)
  w,h=gfx.measurestr(text)
  gfx.x=(256-w)/2 gfx.y=y 
  gfx.drawstr(text)
end

function InitMatrix()
  SmallPins = {}
  Board = {}          -- create the ColorPin Matrix
  for i=1,10 do
    Board[i] = {}     -- create a new row
    SmallPins[i] = {}
    for j=1,4 do
      Board[i][j] = 0
      SmallPins[i][j]=0
    end
  end
end

function InitColors()
  color_r={} color_g={} color_b={}
  color_r[0], color_g[0], color_b[0] = 0.0, 0.0 , 0.0 -- schwarz  
  color_r[1], color_g[1], color_b[1] = 1.0, 0.6,  0.0 -- orange
  color_r[2], color_g[2], color_b[2] = 0.0, 0.0 , 1.0 -- blau
  color_r[3], color_g[3], color_b[3] = 0.8, 0.8 , 0.0 -- gelb
  color_r[4], color_g[4], color_b[4] = 0.0, 0.8 , 0.0 -- grün
  color_r[5], color_g[5], color_b[5] = 0.8, 0.0 , 0.8 -- magenta
  color_r[6], color_g[6], color_b[6] = 0.0, 0.8 , 0.8 -- cyan
end

function GenerateCode()
  math.randomseed( os.time() )
  Code={math.random(1,6), math.random(1,6), math.random(1,6), math.random(1,6)}
  --Code={5,2,2,3}
end

function ShowOkButton(row)
  row=10-row
  gfx.set(0.8) gfx.rect(4*42+15+14,42*row+48,42,42,true)
  gfx.set(0) gfx.rect(4*42+15+14,42*row+48,42,42,false)
  gfx.x,gfx.y=4*42+15+14+6,42*row+48+10
  gfx.set(0.1) gfx.drawstr("OK")
  OkButton=true
end

-- *************************************************************************************

function MainLoop()
  MouseButtonLeftDown=gfx.mouse_cap&1==1
  if MouseButtonLeftDown==false then
    RedrawBoard()
  end
  mx,my=gfx.mouse_x,gfx.mouse_y
  mxn=mx-15 myn=my-52 -- nomalized coords
  local is_inside=(mxn <0 or myn<0 or mxn>4*42-1 or myn>10*42-1)==false
  local is_inside_Ok_Button=(mxn <183 or myn<0 or mxn>222 or myn>10*42-1)==false
  local changed=lastMouseButtonLeftDown~=MouseButtonLeftDown 
  local click_row=10-math.floor(myn/42) click_col=1+math.floor(mxn/42)  

  if ((GameWon or lost) and MouseButtonLeftDown and changed) then
    --restart game
    MouseButtonLeftDown,changed=false,false
    lastMouseButtonLeftDown=gfx.mouse_cap&1==1
    GameWon=false
    lost=false
    GenerateCode()
    Round=1
    InitGFX()
    RedrawBoard()
  end

  if (is_inside and MouseButtonLeftDown and changed and click_row==Round) then -- click on allowed Pin
    RedrawBoard()    
    drawColorPicker(click_row,click_col)
  end
  
  if (not MouseButtonLeftDown and changed and ColorPicker) then
    RedrawBoard()
    drawColorPicker(ColorPicker_row,ColorPicker_col)
    gfx.x=mx gfx.y=my
    mr,mg,mb=gfx.getpixel()

    for i=1,6 do
      if mr==color_r[i] and mg==color_g[i] and mb==color_b[i] then
        Board[ColorPicker_row][ColorPicker_col]=i
      end
    end
    
    RedrawBoard()
    ColorPicker=false
  end

  -- check if Round - Row is complete and show OK Button
  if Board[Round][1]>0 and Board[Round][2]>0 and Board[Round][3]>0 and Board[Round][4]>0 then
    RedrawBoard()
    if ColorPicker then drawColorPicker(ColorPicker_row,ColorPicker_col) end
    ShowOkButton(Round)
  else
    OkButton=false
  end

  if (OkButton and MouseButtonLeftDown and changed and is_inside_Ok_Button and click_row==Round ) then
    
    --check Tip and draw small Pins
    black_pins=0
    white_pins=0
    TestBoard={Board[Round][1],Board[Round][2],Board[Round][3],Board[Round][4]}
    TestCode= {Code[1],Code[2],Code[3],Code[4]}

    for i=1,4 do
      if TestBoard[i]==TestCode[i] and ((TestBoard[i]+TestCode[i]) >0) then
        black_pins=black_pins+1
        TestBoard[i],TestCode[i]=0,0
      end
    end  

    for i=1,4 do
      for ii=1,4 do
        if (TestBoard[i]==TestCode[ii]) and ((TestBoard[i]+TestCode[ii]) > 0) then
          white_pins=white_pins+1
          TestBoard[i],TestCode[ii]=0,0
        end
      end
    end
  

    if black_pins>0 then
      for i=1,black_pins do SmallPins[Round][i]=2 end
    end
    
    if white_pins>0 then
      for i=1+black_pins, white_pins+black_pins do SmallPins[Round][i]=1 end
    end
    
    if Round==10 and black_pins<4 then lost=true Round=0 end
    
    Round=Round+1
    OkButton=false
    RedrawBoard()  
  end
  
  if black_pins==4 then
    --WON!!!!!
    black_pins=0
    GameWon=true
    OkButton=false
    RedrawBoard()
  end
  
  if lost then
    black_pins=0
    GameWon=false
    OkButton=false
    RedrawBoard()
  end
    
  gfx.update()
  if gfx.getchar() >= 0 then
    lastMouseButtonLeftDown=MouseButtonLeftDown
    reaper.defer(MainLoop)
  end
end

InitGFX()
lastMouseButtonLeftDown=gfx.mouse_cap&1==1
GenerateCode()
Round=1
RedrawBoard()
MainLoop()

