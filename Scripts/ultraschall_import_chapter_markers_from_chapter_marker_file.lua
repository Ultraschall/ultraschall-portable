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
retval, filename = reaper.GetUserFileNameForRead(reaper.GetExtState("Ultraschall_Import_Chapter_Markers", "ImportChapterMarkerFile_Path"), "Choose file(MP3, Wav, OPUS, etc) to import edit-markers from...", "*.*")
if retval==false then return end
filename=string.gsub(filename, "\\", "/")

-- store path to be used the next time this action is run as default path
path=filename:match("(.*/)")
if path~=reaper.GetExtState("Ultraschall_Import_Chapter_Markers", "ImportChapterMarkerFile_Path") then
  reaper.SetExtState("Ultraschall_Import_Chapter_Markers", "ImportChapterMarkerFile_Path", path, true)
end

filecontent=ultraschall.ReadFullFile(filename)

for k in string.gmatch(filecontent.."\n", "(.-)\n") do
  time, chapter = k:match("(.-) (.*)")
  if time==nil then break end
  time=reaper.parse_timestr(time)
  chapter_text, url=chapter:match("(.*) <(.*)>")
  if chapter_text~=nil then chapter=chapter_text end
  --print2(chapter, url)
  marker_number, guid, normal_marker_idx = ultraschall.AddNormalMarker(time, -1, chapter)
  if url~=nil then 
    retval, content = ultraschall.GetSetChapterMarker_Attributes(true, normal_marker_idx, "chap_url", url, false)
  end
end

reaper.UpdateArrange()
