dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

Export="<h3>Shownotes:</h3>  "

if ultraschall.CountShownoteMarkers()==0 and ultraschall.CountNormalMarkers()==0 then
  print2("Project has no Shownotes or chapters to export, sorry...")
  return
end

shownotes=0
for i=0, reaper.CountProjectMarkers(0)-1 do
  markertype = ultraschall.GetMarkerType(i)
  if markertype=="normal" then
    if shownotes>0 then Export=Export.."</ul>  " shownotes=0 end
    Export=Export:sub(1,-3)
    retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..i, "", false)
    index = ultraschall.GetNormalMarkerIDFromGuid(guid)
    A={ultraschall.EnumerateNormalMarkers(index)}
    if A[4]=="" then print2("You have chapter, that have no name,yet!") return end
    Export=Export.."\n\n<h4 class=\"ultraschall_chapter_header\">"..A[4].."</h4>\n  "
    _, retval=ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_description", "")
    if retval~="" then Export=Export.."<p class=\"ultraschall_chapter_description\">"..retval.."</p>\n  " end
  elseif markertype=="shownote" then
    retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..i, "", false)
    index = ultraschall.GetShownoteMarkerIDFromGuid(guid)
    A={ultraschall.EnumerateShownoteMarkers(index)}
    if A[4]=="" then print2("You have shownotes, that have no name,yet!") return end
    pos=reaper.format_timestr_pos(A[3], "", 5)
    pos=pos:match("(.*):")
    _, retval=ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url", "")
    _, archived_url=ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_archived_copy_of_original_url", "")
    if archived_url~="" then archived_url="<a class=\"ultraschall_shownote_archived_url\" href=\""..archived_url.."\">[archived url]</a>" end
    if shownotes==0 then Export=Export.."<ul class=\"ultraschall_shownotelist\">\n\t" end
    shownotes=shownotes+1
    if retval=="" then 
      Export=Export.."\t<li class=\"ultraschall_shownote_list_entry\">"..pos.." - "..A[4].."</li>\n  " 
    else
      Export=Export.."\t<li class=\"ultraschall_shownote_list_entry\">"..pos.." - "..A[4].."<a  class=\"ultraschall_shownote_url\" href=\""..retval.."\">[url]</a>"..archived_url.."</li>\n  "
    end
    
  end
end

--SFEM()
--SLEM()

--print3(Export)
local retval, project_path_name = reaper.EnumProjects(-1, "")
local dir = ultraschall.GetPath(project_path_name, separator)
ultraschall.WriteValueToFile(dir.."/Exported_Shownotes.html", Export)

print2("Exported to the project-folder as Exported_Shownotes.html")