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

-- Tim's Ping Feature
--
-- Meo Mespotine, 5. October 2019
--
-- plays a sound, if the playposition hits a marker, when playstate==play


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

Filename_ok = reaper.GetResourcePath().."/Scripts/Ultraschall_Sounds/ok.flac"
Filename_edit = reaper.GetResourcePath().."/Scripts/Ultraschall_Sounds/edit.flac"
Filename_empty = reaper.GetResourcePath().."/Scripts/Ultraschall_Sounds/empty.flac"

logscale = {

  0.02,
  0.05,
  0.11,
  0.18,
  0.27,
  0.35,
  0.42,
  0.52,
  0.7,
  1}


oldPosition=reaper.GetPlayPosition()
curproject=reaper.EnumProjects(-1)

function main()

  if curproject~=reaper.EnumProjects(-1) then 
    curproject=reaper.EnumProjects(-1)
    oldPosition=reaper.GetPlayPosition()
    reaper.defer(main)
  else
    A=reaper.time_precise()
    newPosition=reaper.GetPlayPosition()
    isRendering = ultraschall.IsReaperRendering()
    if reaper.GetPlayState()==1 and isRendering ~= true then -- Play
      if newPosition<oldPosition then
        oldPosition=newPosition-0.2
        if oldPosition<0 then oldPosition=0 end
      end
      number_of_all_markers, allmarkersarray = ultraschall.GetAllMarkersBetween(oldPosition, newPosition)
      if number_of_all_markers>0 then
  
        if ultraschall.IsMarkerNormal(allmarkersarray[1][2]) == true then
          if allmarkersarray[1][1] == "" then Filename = Filename_empty else Filename = Filename_ok end
        else 
          Filename = Filename_edit 
        end
        volume = tonumber(ultraschall.GetUSExternalState("ultraschall_settings_tims_chapter_ping_volume", "Value" ,"ultraschall-settings.ini"))
        volume = volume * 10
        volume = logscale[volume]
  
        if volume == nil then
          volume = 0
        end
  
        --ultraschall.PreviewMediaFile(Filename, 1, false)
        PCM_Source=reaper.PCM_Source_CreateFromFile(Filename)
        P=reaper.Xen_StartSourcePreview(PCM_Source, volume, false)
      end
  
    else
      newPosition=reaper.GetCursorPosition()
    end
  
    oldPosition=newPosition
  
    if ultraschall.GetUSExternalState("ultraschall_settings_tims_chapter_ping", "Value" ,"ultraschall-settings.ini") == "0" then
      return
    else
      reaper.defer(main)
    end
  end
end

main()
