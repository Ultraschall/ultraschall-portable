--[[
################################################################################
# 
# Copyright (c) 2014-2016 Ultraschall (http://ultraschall.fm)
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


 -- Select all StudioLink tracks
function selectStudiolinkTracks() -- local (tracks_count, i, j, track, fx_name, count_fx)

	tracks_count = reaper.CountTracks(0)

	if tracks_count > 0 then										
		for i = 0, tracks_count-1 do 								-- LOOP TRHOUGH TRACKS
			track = reaper.GetTrack(0, i) 							-- Get selected track i
			count_fx = reaper.TrackFX_GetCount(track)
			for j = 0, count_fx - 1 do				
				fx_name_retval, fx_name = reaper.TrackFX_GetFXName(track, j, "")
				if ((fx_name) == "AU: ITSR: StudioLink") or ((fx_name) == "VST: StudioLink (IT-Service Sebastian Reimers)") then	-- this is a track with StudioLink Plugin
					-- reaper.SetTrackSelected(track, true)         	--select track
					reaper.SNM_MoveOrRemoveTrackFX(track, j, 0)  --remove StudioLink Effect
				end
			end	
		end 														-- ENDLOOP through tracks
	end
end 																-- end selectStudiolinkTracks()


function main()
	reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

	selectStudiolinkTracks()

	reaper.Undo_EndBlock("Select all StudioLink tracks", -1) -- End of the undo block. Leave it at the bottom of your main function.
end -- end main()



--msg_start() -- Display characters in the console to show you the begining of the script execution.

-- reaper.PreventUIRefresh(1)-- Prevent UI refreshing. Uncomment it only if the script works.

main() -- Execute your main function

-- reaper.PreventUIRefresh(-1) -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)

--msg_end() -- Display characters in the console to show you the end of the script execution.