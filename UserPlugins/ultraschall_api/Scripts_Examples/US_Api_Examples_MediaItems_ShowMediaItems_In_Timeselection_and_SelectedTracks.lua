  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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
  --]]

-- Ultraschall-API demoscript by Meo Mespotine 30.11.2018
-- 
-- shows the MediaItems within time-selection and within selected tracks
-- also shows the number of found items
-- if no time-selection exists, it will display the found items at editcursorposition in selected tracks


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function main()
  -- get selected tracks and time-selection(loop)
  selected_trackstring = ultraschall.CreateTrackString_SelectedTracks()
  loopstart, loopend = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  if loopstart==0 and loopend==0 then loopstart=reaper.GetCursorPosition() loopend=reaper.GetCursorPosition() end
  
  -- get the MediaItems within selected tracks and time-selection
  count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(loopstart, loopend, selected_trackstring, false)
  
  -- if the selection has changed, show the currently found items in the ReaConsole-window
  if oldcount~=count or oldloopstart~=loopstart or oldloopend~=loopend or oldselected_trackstring~=selected_trackstring then
    reaper.ClearConsole()
    reaper.ShowConsoleMsg("Found Items: "..count.."\n\nList of Items:\n")
    for i=1, count do
      reaper.ShowConsoleMsg(tostring(MediaItemArray[i]).."\n")
    end
  end
  
  -- keep the old values to check next defer-cycle, whether anything has changed
  oldcount=count
  oldloopstart=loopstart
  oldloopend=loopend
  oldselected_trackstring=selected_trackstring
  
  -- start the next defer-cycle
  reaper.defer(main)
end

main()