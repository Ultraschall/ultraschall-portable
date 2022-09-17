--[[
################################################################################
# 
# Copyright (c) 2014-2022 Ultraschall (http://ultraschall.fm)
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

-- written by Meo-Ada Mespotine mespotine.de 26th of March 2022
-- for the ultraschall.fm-project
-- MIT-licensed

-- monitors all marker/region guids in the ReaScript Console

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

function main()
  marker_update_counter = ultraschall.GetMarkerUpdateCounter()
  if marker_update_counter~=old_marker_update_counter then
    print_update("index\tisrgn\tguid\t\t\t\t\tname")
    for i=0, reaper.CountProjectMarkers()-1 do
      A={reaper.EnumProjectMarkers(i)}
      retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..i, "", false)
      print_alt(i.."\t"..tostring(A[2]).."\t"..guid.."\t"..A[5])
    end
  end
  old_marker_update_counter = marker_update_counter
  reaper.defer(main)
end

main()