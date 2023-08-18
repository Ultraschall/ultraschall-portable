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
if retval==false then return end

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
