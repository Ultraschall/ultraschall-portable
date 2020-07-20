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

-- Ultraschall Toolbox - Preview-recording, using an ultraschall.ini-setting
--
-- Good for audioplays, where you want to give the speaker/voice-actor a preview of their last performance or
-- their last sentence they acted, more easily than with usual pre-roll, as you can set the exact spot to restart.
-- Maybe helpful for other things as well?
--
-- Help us making good scripts, donate to our team at: ultraschall.fm/danke
--
-- Cheers

--
-- ultraschall.ini -> "[Ultraschall_PreviewRecording]" -> "PreRollTime" - in seconds; negative values will be seen as positive values

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

if ultraschall.AnyTrackRecarmed()==false then reaper.MB("There is no track armed for recording", "No Recarmed track", 0) return end
Playposition=tonumber(ultraschall.GetUSExternalState("ultraschall_settings_preroll_recording", "Value","ultraschall-settings.ini"))

if Playposition==nil then Playposition=-4 end
if Playposition>0 then Playposition=-Playposition end

-- prepare pre-roll for the magic
Preroll_Settings=reaper.SNM_GetIntConfigVar("preroll", -99)
Preroll_Settings_new=6
reaper.SNM_SetIntConfigVar("preroll", Preroll_Settings_new)

-- get old pre-roll-setting to reset it later on
OldTime=reaper.SNM_GetDoubleConfigVar("prerollmeas", -99)

-- get the editcursor-position, from which we'll start recording
Recposition=reaper.GetCursorPosition()

-- stop any recording, if running
if reaper.GetPlayState()&4==4 then
  reaper.CSurf_OnStop()
  return
end


function main()
  -- let's do the magic
  -- in all other cases, set the correct pre-roll-measure-settings, start recording(with preroll activated), clean up and exit
    trackstringarmed = ultraschall.CreateTrackString_ArmedTracks()
    if trackstringarmed=="" then
      return
    end
    if reaper.GetPlayState()~=0 then reaper.CSurf_OnStop() end
    ultraschall.SectionCut(Recposition, reaper.GetProjectLength()+Recposition, trackstringarmed, false)
    reaper.SetExtState("ultraschall_PreviewRecording", "RecPosition", Recposition, false)

    -- Stelle das MagicRouting so um, dass im preroll auf jeden Fall was zu hören ist:
    reaper.SetProjExtState(0, "ultraschall_magicrouting", "step", "editing")
		reaper.SetProjExtState(0, "ultraschall_magicrouting", "override", "on")

    NewTime=ultraschall.TimeToMeasures(0, -Playposition)
    reaper.SNM_SetDoubleConfigVar("prerollmeas", NewTime)
    reaper.CSurf_OnRecord()
    reaper.SNM_SetIntConfigVar("preroll", Preroll_Settings)
    reaper.SNM_SetDoubleConfigVar("prerollmeas", OldTime)

  reaper.UpdateArrange()
end


-- start the magic
main()
