--[[
################################################################################
# 
# Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
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
-- dofile(reaper.GetResourcePath().."/Scripts/ser.lua")

-- local serialize = require (reaper.GetResourcePath().."/Scripts/ser")


function buildRoutingMatrix ()

	local AllMainSends, number_of_tracks = ultraschall.GetAllMainSendStates()
  local AllAUXSendReceives, number_of_tracks = ultraschall.GetAllAUXSendReceives()

--	 print(serialize(AllMainSends))

  for i=1, number_of_tracks do
  	
  	tracktype = ultraschall.GetTypeOfTrack(i)

    if tracktype == "StudioLink" then	-- Behandlung der StudioLink Spuren

    	retval = ultraschall.AddTrackHWOut(i, 0, 0, 1, 0, 0, 0, 0, -1, 0, false) -- StudioLink-Spuren gehen immer auf den MainHardwareOut Zurück

    	for j=1, number_of_tracks do
    		if ultraschall.GetTypeOfTrack(j) ~= "StudioLink" then

					-- boolean retval = ultraschall.AddTrackAUXSendReceives(integer tracknumber, integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number unknown, integer midichanflag, integer automation, boolean undo)

    			setstate = ultraschall.AddTrackAUXSendReceives(i, j, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, false)
    			-- print(i.j)
    		end
    	end
    elseif tracktype == "SoundBoard" then	-- Behandlung der Soundboard Spuren

			AllMainSends[i]["MainSendOn"] = 1 -- Bei der Preshow sendet nur das Soundboard auf den Main
      retval = ultraschall.AddTrackHWOut(i, 0, 0, 0.5, 0, 0, 0, 0, -1, 0, false) -- Soundboard-Spuren gehen immer auf den MainHardwareOut Zurück

    	for j=1, number_of_tracks do
    		if ultraschall.GetTypeOfTrack(j) ~= "SoundBoard" then -- jeder Track der nicht Soundboard ist schickt sein Signal auf den 3/4 Kanal des Soundboards

					-- boolean retval = ultraschall.AddTrackAUXSendReceives(integer tracknumber, integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number unknown, integer midichanflag, integer automation, boolean undo)

    			setstate = ultraschall.AddTrackAUXSendReceives(i, j, 0, 1, 0, 0, 0, 0, 0, 2, -1, 0, 0, false)
    			-- print(i.j)
    		end
    	end
    end
  end	

  retval = ultraschall.ApplyAllMainSendStates(AllMainSends)	-- setze alle Sends zum Master

end


retval = ultraschall.ClearRoutingMatrix(true, true, true, true, false)
buildRoutingMatrix ()


