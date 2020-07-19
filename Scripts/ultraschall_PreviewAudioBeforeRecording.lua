--[[
################################################################################
#
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

-- Ultraschall Toolbox
-- Preview Audio Before Recording beta 3 (10th of July 2020) - by Meo Mespotine mespotine.de
--
-- 1. Set Editcursor to position, where you want to start recording
-- 2. Start script; a window with an OK-button will pop up
-- 3. Set Editcursor to the position, from where you want to "preview-playback". You can
--       playback until you find the right position
-- 4. When you've found the right position, click "OK" in the opened window
-- 5. You will hear a playback of your audio until you reach your desired recording-position, where
--       recording will start
--       Everything from the recposition until the end of the project will be deleted, before recording starts.
--       That way, you don't need to manually edit wrong stuff out by yourself.
--
-- Good for audioplays, where you want to give the speaker/voice-actor a preview of their last performance or
-- their last sentence they acted, more easily than with usual pre-roll, as you can set the exact spot to restart.
-- Maybe helpful for other things as well?
--
-- Help us making good scripts, donate to our team at: ultraschall.fm/danke
--
-- Cheers

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

if ultraschall.AnyTrackRecarmed()==false then reaper.MB("There is no track armed for recording", "No Recarmed track", 0) return end

if reaper.GetOS()=="OSX32" or reaper.GetOS()=="OSX64" then
  font_size = 14
  font_face = "Helvetica"
else
  font_size = 16
  font_face = "Arial"
end

--retval, measures, cml, fullbeats, cdenom = reaper.TimeMap2_timeToBeats(0, 10)

Preroll_Settings=reaper.SNM_GetIntConfigVar("preroll", -99)
Preroll_Settings_new=6
reaper.SNM_SetIntConfigVar("preroll", Preroll_Settings_new)

OldTime=reaper.SNM_GetDoubleConfigVar("prerollmeas", -99)


if reaper.GetPlayState()~=0 then
  Recposition=reaper.GetPlayPosition()
else
  Recposition=reaper.GetCursorPosition()
end

if reaper.GetPlayState()&4==4 then reaper.CSurf_OnStop() return end

function roundrect(x, y, w, h, r, antialias, fill)
  local aa = antialias or 1
  fill = fill or 0

  if fill == 0 or false then
    gfx.roundrect(x, y, w, h, r, aa)
  elseif h >= 2 * r then
    -- Corners
    gfx.circle(x + r, y + r, r, 1, aa)      -- top-left
    gfx.circle(x + w - r, y + r, r, 1, aa)    -- top-right
    gfx.circle(x + w - r, y + h - r, r , 1, aa)  -- bottom-right
    gfx.circle(x + r, y + h - r, r, 1, aa)    -- bottom-left

    -- Ends
    gfx.rect(x, y + r, r, h - r * 2)
    gfx.rect(x + w - r, y + r, r + 1, h - r * 2)

    -- Body + sides
    gfx.rect(x + r, y, w - r * 2, h + 1)

  else
    r = h / 2 - 1

    -- Ends
    gfx.circle(x + r, y + r, r, 1, aa)
    gfx.circle(x + w - r, y + r, r, 1, aa)

    -- Body
    gfx.rect(x + r, y, w - r * 2, h)
  end
end



function drawgfx()
  buttonx=0
  buttony=5
  -- draws OK-Button and the text
  gfx.set(0.15, 0.15, 0.15)
  gfx.rect(0,0,gfx.w,gfx.h,1)
  gfx.set(0.2)

  for i = 1, 1 do
    gfx.set(0,0,0,0.6)
    roundrect(220-i+buttonx, 30-i+buttony, 70, 40, 8, 1, 1)
    roundrect(220+i+buttonx, 30+i+buttony, 70, 40, 8, 1, 1)
  end
  gfx.set(0,0,0,0.6)
  roundrect(220+buttonx, 30-2+buttony, 70, 40, 8, 1, 1)
  gfx.set(0.392156862745098)
  roundrect(220+buttonx, 30-1+buttony, 70, 40, 8, 1, 1)

  gfx.set(0.2745098039215686)
  roundrect(220+buttonx, 30+buttony, 70, 40, 8, 1, 1)

  gfx.set(1)
  gfx.x=16 gfx.y=28
  gfx.setfont(1,font_face , font_size, 66)
  gfx.drawstr("Place Editcursor to \nStart of Preview-Playposition \nand click OK")
  gfx.x=245+buttonx gfx.y=42+buttony
  gfx.setfont(1,font_face , font_size, 66)
  gfx.drawstr("OK")
end

function main()
  -- let's do the magic

  -- if the window-size is changed, redraw window-content
  if height~=gfx.h or width~=gfx.w then
    height=gfx.h
    width=gfx.w
    drawgfx()
  end

  -- let's check for user-input
  local A=gfx.getchar()

  -- if window is closed or user hits ESC-key, quit the script
  if A==-1 or A==27 then tudelu=false gfx.quit() reaper.SNM_SetIntConfigVar("preroll", Preroll_Settings) end

  -- if user hits the OK,Button:
  if A==13 or A==32 or gfx.mouse_cap&1==1 and gfx.mouse_x>=230 and gfx.mouse_x<=290 and gfx.mouse_y>=30 and gfx.mouse_y<=90 then
    Playposition=reaper.GetCursorPosition() -- get current editcursor-position, from where the previewing will start
    gfx.quit() -- close gfx-window
    if Recposition<Playposition then
      -- if playposition is bigger than recposition, then show error-message, clean up and exit
      reaper.SNM_SetIntConfigVar("preroll", Preroll_Settings)
      reaper.MB("The recording-position must be after the preview-play-position!", "Ooops" ,0)
      return
    else
      -- in all other cases, set the correct pre-roll-measure-settings, start recording(with preroll activated), clean up and exit
    trackstringarmed = ultraschall.CreateTrackString_ArmedTracks()
    if trackstringarmed=="" then
      return
    end
    if reaper.GetPlayState()~=0 then reaper.CSurf_OnStop() end
    reaper.Undo_BeginBlock()
    ultraschall.SectionCut(Recposition, reaper.GetProjectLength()+Recposition, trackstringarmed, false)
    reaper.SetExtState("ultraschall_PreviewRecording", "RecPosition", Recposition, false)

    -- Stelle das MagicRouting so um, dass im preroll auf jeden Fall was zu hören ist:
    reaper.SetProjExtState(0, "ultraschall_magicrouting", "step", "editing")
    reaper.SetProjExtState(0, "ultraschall_magicrouting", "override", "on")

    reaper.MoveEditCursor(Recposition-Playposition, false)
    local Gap=Recposition-Playposition
    local NewTime=ultraschall.TimeToMeasures(0, Gap)

    reaper.SNM_SetDoubleConfigVar("prerollmeas", NewTime)
    reaper.CSurf_OnRecord()
    reaper.SNM_SetIntConfigVar("preroll", Preroll_Settings)
    reaper.SNM_SetDoubleConfigVar("prerollmeas", OldTime)
    reaper.Undo_EndBlock("PreviewRecording", -1)
      tudelu=false
    end
  end
  gfx.update()
  if tudelu~=false then reaper.defer(main) end
end

-- main program
gfx.init("Place Edit-Cursor", 320,120,0,100,300) -- open window

-- let's get initial window height and width(for checking later, if we need to redraw the window contents due window-size-changes)
height=gfx.h
width=gfx.w

-- draw gfx
drawgfx()


-- start the magic
main()
