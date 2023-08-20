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

-------------------------------------
-- Ultraschall Helper Functions
-------------------------------------

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

playstate=reaper.GetPlayState()
if playstate&4==4 then return end -- quit if recording


--reaper.MB(reaper.GetCursorContext(),"",0)
-- if reaper.GetCursorContext()==0 then reaper.SetCursorContext(1) end


-------------------------------------
reaper.Undo_BeginBlock() -- Beginning of the undo block. Leave it at the top of your main function.
-------------------------------------



init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)  -- get information wether or not a 
if (init_end_timesel ~= init_start_timesel) then    -- there is a time selection

  cut= reaper.NamedCommandLookup("_Ultraschall_Ripple_Cut") -- Start preview 
  reaper.Main_OnCommand(cut, 0)

else
  Length=reaper.GetProjectLength()
  reaper.Main_OnCommand(40697, 0) -- normal delete

  Length2=reaper.GetProjectLength()

  Diff=Length2-Length

  if Diff~=0 and reaper.GetPlayState()~=0 and reaper.GetCursorContext()==1 and reaper.GetToggleCommandState(40311)==1 then
    reaper.SetEditCurPos(reaper.GetPlayPosition()+Diff, false, true)
  end
end

-------------------------------------
reaper.Undo_EndBlock("Ultraschall Delete", -1) -- End of the undo block. Leave it at the bottom of your main function.
-------------------------------------
