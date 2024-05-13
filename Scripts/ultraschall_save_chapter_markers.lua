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

---[[ Some Helper Functions ]]

-- Get Path from file name
function GetPath(str,sep)
    return str:match("(.*"..sep..")")
end

if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
  -- user_folder = buf --"C:\\Users\\[username]" -- need to be test
  separator = "\\"
else
  -- user_folder = "/USERS/[username]" -- Mac OS. Not tested on Linux.
  separator = "/"
end



if ultraschall.CountNormalMarkers()==0 then reaper.MB("Sorry, no chapter-markers available for export...", "No chapter markers", 0) return end

retval, project_path_name = reaper.EnumProjects(-1, "")
if project_path_name ~= "" then
  dir = GetPath(project_path_name, separator)
else
  dir = ""
end

retval, filename = reaper.JS_Dialog_BrowseForSaveFile("Save chapters into...", dir, "chapters.txt", "")
if retval==0 then return end

Chapters={}

for i=1, ultraschall.CountNormalMarkers() do
  retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(i)
  retval, url= ultraschall.GetSetChapterMarker_Attributes(false, i, "chap_url", 2, false)
  if url~="" then url=" <"..url..">" end
  Chapters[i]={}
  Chapters[i]["name"]=markertitle
  Chapters[i]["url"]=url
  if markertitle=="" then Chapters[i]["error"]=" has no title." error_found=true end
  if markertitle:match("<") or markertitle:match(">") then Chapters[i]["error"]=" has < or > in its title; could cause problems with Podlove-Publisher." error_found=true end

  timestring_end=reaper.format_timestr_pos(position, "", 0):match(".*(%..*)")
  timestring=reaper.format_timestr_pos(position, "", 5):match("(.*):")
  Chapters[i]["position"]=timestring..timestring_end
end

if error_found==true then
  local FoundErrors=""
  for i=1, #Chapters do
    if Chapters[i]["error"]~=nil then
      FoundErrors=FoundErrors.."Marker at "..Chapters[i]["position"]..": "..Chapters[i]["error"].."\n\n"
    end
  end
  retval = reaper.MB("Do you want to continue with the errors in the following markers? \n\n"..FoundErrors, "Errors", 4)
  if retval==7 then return end
end

Exportfile=""
for i=1, #Chapters do  
  Exportfile=Exportfile..Chapters[i]["position"].." "..Chapters[i]["name"]..Chapters[i]["url"].."\n"
end


retval = ultraschall.WriteValueToFile(filename, Exportfile, false)
if retval==-1 then reaper.MB("Couldn't write the file. Can the file/folder be accessed?", "Error", 0) end
