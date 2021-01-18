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
-- Grab all of the functions and classes from our GUI library
local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

if ultraschall.AnyTrackRecarmed()==false then reaper.MB("There is no track armed for recording", "No Recarmed track", 0) return end

operationSystem = reaper.GetOS()
if string.match(operationSystem, "OS") then

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



function main()

    Playposition=reaper.GetCursorPosition() -- get current editcursor-position, from where the previewing will start
    gfx.quit() -- close gfx-window
    if Recposition<Playposition then
      -- if playposition is bigger than recposition, then show error-message, clean up and exit
      reaper.SNM_SetIntConfigVar("preroll", Preroll_Settings)
      reaper.MB("The recording-position must be after the preview-play-position!", "Ooops" ,0)
      reaper.SetExtState("ultraschall_PreviewRecording", "Dialog", "0", false)
      reaper.DeleteExtState("ultraschall_PreviewRecording", "RecPosition", false) -- lösche Eintrag für Preroll
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

  -- gfx.update()
  if tudelu~=false then reaper.defer(main) end
end


---- Window settings and user functions ----

reaper.SetExtState("ultraschall_PreviewRecording", "Dialog", "1", false)

GUI.name = "Ultraschall 5 - Preroll Recording"
GUI.w, GUI.h = 350, 80

------------------------------------------------------
-- position always in the center of the screen
------------------------------------------------------

l, t, r, b = 0, 0, GUI.w, GUI.h
__, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2

GUI.elms = { }

-- Inhalt des Fensters - Text und Button

ok_button = GUI.Btn:new(240, 27, 90, 30,   " OK", main, "")
table.insert(GUI.elms, ok_button)

label = GUI.Lbl:new( 20 , 20,              "Place Editcursor to \nStart of Preview-Playposition \nand click OK", 0)
table.insert(GUI.elms, label)

GUI.Init()
GUI.Main()

function atexit()

  reaper.SetExtState("Ultraschall_Windows", GUI.name, 0, false)
  reaper.SNM_SetIntConfigVar("preroll", Preroll_Settings)
  reaper.SetExtState("ultraschall_PreviewRecording", "Dialog", "0", false) -- lösche Eintrag für Preroll Dialog
  -- reaper.DeleteExtState("ultraschall_PreviewRecording", "RecPosition", false) -- lösche Eintrag für Preroll

end

reaper.atexit(atexit)
