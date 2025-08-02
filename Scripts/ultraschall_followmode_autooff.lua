--[[
################################################################################
#
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

old_position=reaper.GetCursorPosition()
old_envelope=reaper.GetSelectedEnvelope(0)
if old_envelope~=nil then
  old_envelope_points=reaper.CountEnvelopePoints(old_envelope)
else
  old_envelope_points=0
end
old_marker_counter=ultraschall.GetMarkerUpdateCounter()

function main()
  position=reaper.GetCursorPosition()
  envelope=reaper.GetSelectedEnvelope(0)
  if envelope~=nil then
    envelope_points=reaper.CountEnvelopePoints(envelope)
  else
    envelope_points=0
  end
  
  if ultraschall.GetUSExternalState("ultraschall_settings_followmode_auto", "Value" ,"ultraschall-settings.ini") == "1" then
    -- when edit-cursor moves, turn follow off
    if old_position~=position and reaper.GetPlayState()~=0 and reaper.GetExtState("follow", "skip", "true", false)~="true" then
      if reaper.GetToggleCommandState(reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow"))==1 then
        ultraschall.RunCommand("_Ultraschall_Toggle_Follow")
      end
    end
    if envelope~=old_envelope then
      -- when selected envelope changes, turn follow off
      if reaper.GetToggleCommandState(reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow"))==1 then
        ultraschall.RunCommand("_Ultraschall_Toggle_Follow")
      end
    end
    if old_envelope_points~=envelope_points then
      -- when envelope-points are added/deleted, turn follow off
      if reaper.GetToggleCommandState(reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow"))==1 then
        ultraschall.RunCommand("_Ultraschall_Toggle_Follow")
      end
    end
    if old_marker_counter~=ultraschall.GetMarkerUpdateCounter() then
      -- when markers are moved/added/deleted, turn follow off
      if reaper.GetToggleCommandState(reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow"))==1 then
        ultraschall.RunCommand("_Ultraschall_Toggle_Follow")
      end
    end
    if reaper.GetExtState("Ultraschall", "AutoFollowOff")=="true" then
      if reaper.GetToggleCommandState(reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow"))==1 then
        ultraschall.RunCommand("_Ultraschall_Toggle_Follow")
      end
      reaper.SetExtState("Ultraschall", "AutoFollowOff", "", false)
    end
  end
  
  reaper.SetExtState("follow", "skip", "", false)
  old_position=position
  old_envelope=envelope
  old_envelope_points=envelope_points
  old_marker_counter=ultraschall.GetMarkerUpdateCounter()
  reaper.defer(main)
end

main()
