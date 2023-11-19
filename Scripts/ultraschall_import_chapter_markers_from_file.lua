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

-- get filename and source
retval, filename = reaper.GetUserFileNameForRead(reaper.GetExtState("Ultraschall_Import_Chapter_Markers", "MP3_Path"), "Choose file(MP3, Wav, OPUS, etc) to import chapters from...", "*.*")
if retval==false then return end
filename=string.gsub(filename, "\\", "/")
src=reaper.PCM_Source_CreateFromFile(filename)

-- store path to be used the next time this action is run as default path
path=filename:match("(.*/)")
if path~=reaper.GetExtState("Ultraschall_Import_Chapter_Markers", "MP3_Path") then
  reaper.SetExtState("Ultraschall_Import_Chapter_Markers", "MP3_Path", path, true)
end


-- read all chapters available from file 
local i=0 -- count variable
local retval
Chaps={} -- table to get all chapternames, and their positions
for i=0, 65500 do
  Chaps[i]={reaper.CF_EnumMediaSourceCues(src,  i)}
  if Chaps[i][4]==false then Chaps[i]=nil break end
end

-- when no chapters, show error-message
if #Chaps==0 then reaper.MB("No Chapter markers available.", "No chapter markers", 0) return end

-- insert chapters and renumerate the marker-numbers
for i=0, #Chaps do
  marker_number, guid, normal_marker_idx = ultraschall.AddNormalMarker(Chaps[i][3], 0, Chaps[i][5])
end
ultraschall.RenumerateNormalMarkers()

reaper.UpdateArrange()
