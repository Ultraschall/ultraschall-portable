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
]]

-- Tim's Ping Feature
--
-- Meo Mespotine, 5. October 2019
--
-- plays a sound, if the playposition hits a marker, when playstate==play


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

Filename=ultraschall.GetUSExternalState("ultraschall_Tims_Ping_Feature", "pingfilename")

if reaper.file_exists(Filename)==false then
  Filename=reaper.GetResourcePath().."/Scripts/Ultraschall_Sounds/Tims-Default-Ping2.flac"
end

volume=tonumber(ultraschall.GetUSExternalState("ultraschall_Tims_Ping_Feature", "volume"))

if volume==nil then
  volume=1
end

oldPosition=reaper.GetPlayPosition()

function main()
  newPosition=reaper.GetPlayPosition()
  if reaper.GetPlayState()==1 then
    if newPosition<oldPosition then
      oldPosition=newPosition-1
      if oldPosition<0 then
        oldPosition=0
      end
    end
    number_of_all_markers, allmarkersarray = ultraschall.GetAllMarkersBetween(oldPosition, newPosition)
    if number_of_all_markers>0 then
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

main()
