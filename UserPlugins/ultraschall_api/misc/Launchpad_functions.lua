-- Set colors of Novation-LaunchPad-buttons
--
-- functionlibrary for Reaper by Meo-Ada Mespotine - licensed under MIT-license
-- version 1.0 - 26th of July 2020

-- to use this, you need to have your LaunchPad set enabled for MIDI-Output.
--
-- I have tested these functions successfully with Novation Launchpad NOVLPD01.
-- If they work woth any other LaunchPad-version I have no idea. Feel free to add support for them as well.

-- The following functions set button's colors 

function LaunchPad_GetMidiID()
  -- returns the number of present Launchpads currently available and their corresponding ids as a table
  local retval=true
  local nameout
  local MIDI_Devices={}
  local MIDI_Devices_num=0
  local count=-1
  for i=0, 2048 do
    retval, nameout = reaper.GetMIDIOutputName(i, "")
    if nameout~="" then print(nameout) end
    if retval==true and nameout:lower():match("launchpad")~=nil then MIDI_Devices_num=MIDI_Devices_num+1 MIDI_Devices[MIDI_Devices_num]=i end
  end
  return MIDI_Devices_num, MIDI_Devices
end


function LaunchPad_SetButton(MIDIDevice, ButtonX, ButtonY, Red, Green)
  -- MIDIDevice is the midi-input-device; see Preferences for the id of the LaunchPad
  -- ButtonX - the column of the button
  -- ButtonY - the row of the button
  -- Red - the red-part of the color(0, nothing to 3, maximum brightness)
  -- Green - the green-part of the color(0, nothing to 3, maximum brightness)
  --
  -- combine red and green for different shades of orange or yellow
  
  if ButtonX>8 then return false end
  if ButtonY>8 then return false end
  if Red>3 then return false end
  if Green>3 then return false end
  ButtonX=ButtonX-1
  ButtonY=ButtonY-1
  local ColorValue=Red+(Green<<4)
  local Button=ButtonX+((ButtonY)*15)+(ButtonY*1)
  reaper.StuffMIDIMessage(16+MIDIDevice, 144, Button, ColorValue)
end


function LaunchPad_ClearAllButtons(MIDIDevice)
  -- clear color of all buttons
  -- MIDIDevice is the midi-input-device; see Preferences for the id of the LaunchPad
  for i=0, 127 do
    reaper.StuffMIDIMessage(16+MIDIDevice, 144, i, 0)
  end
  reaper.StuffMIDIMessage(19, 176, 104, 0)
  reaper.StuffMIDIMessage(19, 176, 105, 0)
  reaper.StuffMIDIMessage(19, 176, 106, 0)
  reaper.StuffMIDIMessage(19, 176, 107, 0)
  reaper.StuffMIDIMessage(19, 176, 108, 0)
  reaper.StuffMIDIMessage(19, 176, 109, 0)
  reaper.StuffMIDIMessage(19, 176, 110, 0)
  reaper.StuffMIDIMessage(19, 176, 111, 0)
end

function LaunchPad_SetVolButton(MIDIDevice, ColorValue)
  -- set the color of the button Vol
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- ColorValue -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if ColorValue>3 or ColorValue<0 then return false end
  if     ColorValue==0 then ColorValue=0 -- button off
  elseif ColorValue==1 then ColorValue=1 -- red
  elseif ColorValue==2 then ColorValue=17 -- yellow
  elseif ColorValue==3 then ColorValue=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 144, 15, ColorValue)
end


function LaunchPad_SetPanButton(MIDIDevice, ColorValue)
  -- set the color of the button Pan
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- ColorValue -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if ColorValue>3 or ColorValue<0 then return false end
  if     ColorValue==0 then ColorValue=0 -- button off
  elseif ColorValue==1 then ColorValue=1 -- red
  elseif ColorValue==2 then ColorValue=17 -- yellow
  elseif ColorValue==3 then ColorValue=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 144, 31, ColorValue)
end


function LaunchPad_SetSndAButton(MIDIDevice, ColorValue)
  -- set the color of the button SndA
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- ColorValue -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if ColorValue>3 or ColorValue<0 then return false end
  if     ColorValue==0 then ColorValue=0 -- button off
  elseif ColorValue==1 then ColorValue=1 -- red
  elseif ColorValue==2 then ColorValue=17 -- yellow
  elseif ColorValue==3 then ColorValue=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 144, 47, ColorValue)
end


function LaunchPad_SetSndBButton(MIDIDevice, ColorValue)
  -- set the color of the button SndB
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- ColorValue -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if ColorValue>3 or ColorValue<0 then return false end
  if     ColorValue==0 then ColorValue=0 -- button off
  elseif ColorValue==1 then ColorValue=1 -- red
  elseif ColorValue==2 then ColorValue=17 -- yellow
  elseif ColorValue==3 then ColorValue=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 144, 63, ColorValue)
end


function LaunchPad_SetStopButton(MIDIDevice, ColorValue)
  -- set the color of the button Stop
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- ColorValue -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if ColorValue>3 or ColorValue<0 then return false end
  if     ColorValue==0 then ColorValue=0 -- button off
  elseif ColorValue==1 then ColorValue=1 -- red
  elseif ColorValue==2 then ColorValue=17 -- yellow
  elseif ColorValue==3 then ColorValue=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 144, 72, ColorValue)
end


function LaunchPad_SetTrkOnButton(MIDIDevice, ColorValue)
  -- set the color of the button TrkOn
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- ColorValue -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if ColorValue>3 or ColorValue<0 then return false end
  if     ColorValue==0 then ColorValue=0 -- button off
  elseif ColorValue==1 then ColorValue=1 -- red
  elseif ColorValue==2 then ColorValue=17 -- yellow
  elseif ColorValue==3 then ColorValue=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 144, 91, ColorValue)
end


function LaunchPad_SetSoloButton(MIDIDevice, ColorValue)
  -- set the color of the button Solo
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- ColorValue -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if ColorValue>3 or ColorValue<0 then return false end
  if     ColorValue==0 then ColorValue=0 -- button off
  elseif ColorValue==1 then ColorValue=1 -- red
  elseif ColorValue==2 then ColorValue=17 -- yellow
  elseif ColorValue==3 then ColorValue=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 144, 107, ColorValue)
end

function LaunchPad_SetArmButton(MIDIDevice, ColorValue)
  -- set the color of the button Arm
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- ColorValue -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if ColorValue>3 or ColorValue<0 then return false end
  if     ColorValue==0 then ColorValue=0 -- button off
  elseif ColorValue==1 then ColorValue=1 -- red
  elseif ColorValue==2 then ColorValue=17 -- yellow
  elseif ColorValue==3 then ColorValue=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 144, 127, ColorValue)
end

function LaunchPad_SetUpButton(MIDIDevice, Color)
  -- set the color of the button Up
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- Color      -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if     Color==0 then Color=0 -- button off
  elseif Color==1 then Color=1 -- red
  elseif Color==2 then Color=17 -- yellow
  elseif Color==3 then Color=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 176, 104, Color)
end


function LaunchPad_SetDownButton(MIDIDevice, Color)
  -- set the color of the button Down
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- Color      -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if     Color==0 then Color=0 -- button off
  elseif Color==1 then Color=1 -- red
  elseif Color==2 then Color=17 -- yellow
  elseif Color==3 then Color=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 176, 105, Color)
end


function LaunchPad_SetLeftButton(MIDIDevice, Color)
  -- set the color of the button Left
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- Color      -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if     Color==0 then Color=0 -- button off
  elseif Color==1 then Color=1 -- red
  elseif Color==2 then Color=17 -- yellow
  elseif Color==3 then Color=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 176, 106, Color)
end


function LaunchPad_SetRightButton(MIDIDevice, Color)
  -- set the color of the button Right
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- Color      -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if     Color==0 then Color=0 -- button off
  elseif Color==1 then Color=1 -- red
  elseif Color==2 then Color=17 -- yellow
  elseif Color==3 then Color=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 176, 107, Color)
end


function LaunchPad_SetSessionButton(MIDIDevice, Color)
  -- set the color of the button Session
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- Color      -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if     Color==0 then Color=0 -- button off
  elseif Color==1 then Color=1 -- red
  elseif Color==2 then Color=17 -- yellow
  elseif Color==3 then Color=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 176, 108, Color)
end

function LaunchPad_SetUser1Button(MIDIDevice, Color)
  -- set the color of the button User1
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- Color      -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if     Color==0 then Color=0 -- button off
  elseif Color==1 then Color=1 -- red
  elseif Color==2 then Color=17 -- yellow
  elseif Color==3 then Color=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 176, 109, Color)
end


function LaunchPad_SetUser2Button(MIDIDevice, Color)
  -- set the color of the button User2
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- Color      -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if     Color==0 then Color=0 -- button off
  elseif Color==1 then Color=1 -- red
  elseif Color==2 then Color=17 -- yellow
  elseif Color==3 then Color=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 176, 110, Color)
end


function LaunchPad_SetMixerButton(MIDIDevice, Color)
  -- set the color of the button Mixer
  -- MIDIDevice - is the midi-input-device; see Preferences for the id of the LaunchPad
  -- Color      -   0, off
  --                1, red
  --                2, yellow
  --                3, green 
  if     Color==0 then Color=0 -- button off
  elseif Color==1 then Color=1 -- red
  elseif Color==2 then Color=17 -- yellow
  elseif Color==3 then Color=16 -- green
  end
  reaper.StuffMIDIMessage(16+MIDIDevice, 176, 111, Color)
end



function LaunchPad_Show_Image_Demo()
  -- a small demo, which let's you choose an image and displays it + a scrolltext.
  -- now move the mouse above the image and it will show the 8x8-pixels from
  -- mousecursor towards down and right on the LaunchPad
  --
  -- it will display the image on the first enabled LaunchPad available
  
  local scrolloffset=gfx.w
  local A=0
  local retval, LaunchPadID = LaunchPad_GetMidiID()
  local LaunchPadID=LaunchPadID[1]
  gfx.setfont(1,"Arial", 13,0)
  local function main()
    A=A+1
    
    gfx.x=0
    gfx.y=0
    gfx.blit(1,1,0)
    scrolloffset=scrolloffset-0.1
    if scrolloffset<=-300 then scrolloffset=gfx.w end
    gfx.x=scrolloffset
    gfx.y=20
    gfx.blit(2,1,0)
      
    if gfx.mouse_cap&1==1 then
      retval, filename = reaper.GetUserFileNameForRead("", "Select Image", "")
      gfx.loadimg(1, filename)
    end
    if A==8 then
      A=0    
      gfx.update()
    
      for x=1, 8 do
        for y=1, 8 do
          gfx.x=gfx.mouse_x+x
          gfx.y=gfx.mouse_y+y
          local r,g,b=gfx.getpixel()
          local finr=math.floor(3*r)
          local fing=math.floor(3*g)
          LaunchPad_SetButton(LaunchPadID, x, y, finr, fing)
        end
      end
    end
    
    reaper.defer(main)
  end
  
  gfx.init()
  gfx.setimgdim(2,1000,40)
  gfx.dest=2
  gfx.x=0
  gfx.y=0
  gfx.drawstr("           No matter where we are, we still need a nice scrolltext...")
  gfx.dest=-1
  
  local retval, filename = reaper.GetUserFileNameForRead("", "Select Image", "")
  gfx.loadimg(1, filename)
  LaunchPad_ClearAllButtons(LaunchPadID)
  main()
end

LaunchPad_Show_Image_Demo()