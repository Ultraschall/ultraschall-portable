-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

USDOCBLOCS = ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/DocsSourcefiles/Reaper_Api_Documentation.USDocML")
found_usdocblocs, all_found_usdocblocs = ultraschall.Docs_GetAllUSDocBlocsFromString(USDOCBLOCS)
table.sort(all_found_usdocblocs)

--ultraschall.Docs_LoadUltraschallAPIDocBlocs()

function ChangelogDoer(tellme, where, what)
  if where==nil then where="Reaper_Api_Documentation.html" end
  CHANGELOG_FINAL=CHANGELOG_FINAL..[[<hr width="80%">
  
  <div style="width:80%; padding-left:14%;">
  <h3><a id="]]..string.gsub(what, " ", "_")..[[_Changes">]]..what..[[ Changes</a><br></h3>
  ]]
  
  REAPER_CHLOGS2={}
  
  for k, v in pairs(REAPER_CHLOGS) do
    if k:match(tellme) then
      REAPER_CHLOGS2[#REAPER_CHLOGS2+1]=k
    end
  end
  
  table.sort(REAPER_CHLOGS2)
  for i=#REAPER_CHLOGS2, 1, -1 do
    CHANGELOG_FINAL=CHANGELOG_FINAL.."\n\n\t<h4><a id=\""..REAPER_CHLOGS2[i].."\"></a><a href=\"#"..REAPER_CHLOGS2[i].."\">^ "..REAPER_CHLOGS2[i]..":</a></h4>\n\t<table style=\"padding-left:4%; margin-top:-1.5%;\" width=\"100%\" border=\"0\">"
    for a=1, #REAPER_CHLOGS[REAPER_CHLOGS2[i]] do
      slug, func, chlog=string.gsub(REAPER_CHLOGS[REAPER_CHLOGS2[i]][a],"\n","\n\t\t\t<br>"):match("(.-):(.-):(.*)")
      func=""..func..""
      chlog=""..chlog..""
      CHANGELOG_FINAL=CHANGELOG_FINAL.."\n\t\t<tr><td width=\"25%\" style=\"vertical-align:top;\"><a href=\""..where.."#"..slug.."\">"..func.."</a></td><td>"..chlog.."</td></tr>"
    end
    CHANGELOG_FINAL=CHANGELOG_FINAL.."\n\t</table>"
  end
  CHANGELOG_FINAL=CHANGELOG_FINAL.."</div>\n"
end

REAPER_CHLOGS={}

for i=1, found_usdocblocs do
  print(all_found_usdocblocs[i])
  changelogscount, changelogs = ultraschall.Docs_GetUSDocBloc_Changelog(all_found_usdocblocs[i], true, 1)
  title = ultraschall.Docs_GetUSDocBloc_Title(all_found_usdocblocs[i], 1)
  slug = ultraschall.Docs_GetUSDocBloc_Slug(all_found_usdocblocs[i])
  if changelogscount>0 then 
    for a=1, changelogscount do
      --print_alt("AAA",slug, changelogs[a][1], changelogs[a][2])
      if REAPER_CHLOGS[changelogs[a][1]]==nil then
        REAPER_CHLOGS[changelogs[a][1]]={}
      end
      REAPER_CHLOGS[changelogs[a][1]][#REAPER_CHLOGS[changelogs[a][1]]+1]=slug..":"..title..": "..changelogs[a][2]
    end
  end
end


for k, v in pairs(REAPER_CHLOGS) do
  table.sort(v)
end

CHANGELOG_FINAL=[[<html>
  <head>
    <title>
      Ultraschall API Changelog
    </title>

    <link href="style.css" rel="stylesheet">
    <link href="custom.css" rel="stylesheet">

  </head>
    <body>    
        <a class="anch" id="This-is-the-TopOfTheWorld"></a>
        <div style="position: sticky; top:0; padding-left:4%; z-index:100;">
            <div style="background-color:#282828; width:95%; font-family:tahoma; font-size:16;">
                <a href="US_Api_Functions.html"><img style="position: absolute; left:4.2%; width:11%;" src="gfx/US_Button_Un.png" alt="Ultraschall Internals Documentation"></a>  
                <a href="Reaper_Api_Documentation.html"><img style="position: absolute; left:15.2%; width:8.7%;" src="gfx/Reaper_Button_Un.png" alt="Reaper Internals Documentation"></a>
                <a href="ReaGirl_Functions.html"><img style="position: absolute; left:23.95%; width:8.7%;" src="gfx/ReaGirl_Button_Un.png" alt="ReaGirl Documentation"></a>
                <a href="Downloads.html"><img style="position:absolute; left:66.1%; width:6.9%;" src="gfx/Downloads_Un.png" alt="Downloads"></a>
                <a href="API_ChangeLog.html"><img style="position:absolute; left:73%; width:8.3%;" src="gfx/API_Changelog.png" alt="Changelog of API"></a>
                <a href="ChangeLog.html"><img style="position:absolute; left:81.3%; width:6.9%;" src="gfx/Changelog_Un.png" alt="Changelog of documentation"></a>
                <a href="Impressum.html"><img style="position:absolute; left:88.2%; width:6.9%;" src="gfx/Impressum_Un.png" alt="Impressum and Contact"></a>
                <div style="padding-top:2.5%">
                    <table border="0" style="color:#aaaaaa; width:101%;">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                    </table><hr color="#444444">
                    <div style="position:absolute; right:6%; top:60%;"><a style="color:#CCCCCC;" href="#This-is-the-TopOfTheWorld">Jump to Top</a></div>
                </div>
            </div>
        </div>

<div style="width:75%; padding-left:14%;">
<h3>Introduction</h3>
This page lists all changes made in the API of Reaper and various extensions available. This should make it easier for you to spot, whether your script needs updates or changes as well as knowing, what has changed so new opportunities arrive in your scripting endeavours.<br>
The Reaper/Extension-version itself is also an anchor, that works as a link. So forum's-linking to the specific changelog of a Reaper/Extension-version is possible as well.<p>

  <a href="#Reaper_API_Changes">Reaper API Changes</a><br>
  <a href="#Reaper_Config_Variables_Changes">Reaper Config Variables Changes</a><br>
  <br>
  <a href="#SWS_API_Changes">SWS API Changes</a><br>
  <a href="#JS_Extension_API_Changes">JS Extension API Changes</a><br>
  <a href="#ReaPack_API_Changes">ReaPack API Changes</a><br>
  <a href="#ReaImGui_API_Changes">ReaImGui API Changes</a><br>
  <a href="#Osara_API_Changes">Osara API Changes</a><br>
  <a href="#ReaBlink_API_Changes">ReaBlink API Changes</a><br>
  <a href="#ReaLLM_API_Changes">ReaLLM API Changes</a><br>
  <a href="#ReaFab_API_Changes">ReaFab API Changes</a><br>
  <a href="#ReaMCULive_API_Changes">ReaMCULive API Changes</a><br>
  <a href="#PeloReaper_API_Changes">PeloReaper API Changes</a><br>
  <br>
  <a href="#ReaGirl_API_Changes">ReaGirl API Changes</a><br>
</div>
]]
--]]

ChangelogDoer("Reaper", nil, "Reaper_API")

USDOCBLOCS = ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/DocsSourcefiles/Reaper_Config_Variables.USDocML")
found_usdocblocs, all_found_usdocblocs = ultraschall.Docs_GetAllUSDocBlocsFromString(USDOCBLOCS)
table.sort(all_found_usdocblocs)

REAPER_CHLOGS={}

for i=1, found_usdocblocs do
  print(all_found_usdocblocs[i])
  changelogscount, changelogs = ultraschall.Docs_GetUSDocBloc_Changelog(all_found_usdocblocs[i], true, 1)
  title = ultraschall.Docs_GetUSDocBloc_Title(all_found_usdocblocs[i], 1)
  slug = ultraschall.Docs_GetUSDocBloc_Slug(all_found_usdocblocs[i])
  if changelogscount>0 then 
    for a=1, changelogscount do
      --print_alt("AAA",slug, changelogs[a][1], changelogs[a][2])
      if REAPER_CHLOGS[changelogs[a][1]]==nil then
        REAPER_CHLOGS[changelogs[a][1]]={}
      end
      REAPER_CHLOGS[changelogs[a][1]][#REAPER_CHLOGS[changelogs[a][1]]+1]=slug..":"..title..": "..changelogs[a][2]
    end
  end
end

ChangelogDoer("Reaper", "Reaper_Config_Variables.html", "Reaper Config Variables")

for k, v in pairs(REAPER_CHLOGS) do
  table.sort(v)
end

USDOCBLOCS = ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/DocsSourcefiles/Reaper_Api_Documentation.USDocML")
found_usdocblocs, all_found_usdocblocs = ultraschall.Docs_GetAllUSDocBlocsFromString(USDOCBLOCS)
table.sort(all_found_usdocblocs)

REAPER_CHLOGS={}

for i=1, found_usdocblocs do
  print(all_found_usdocblocs[i])
  changelogscount, changelogs = ultraschall.Docs_GetUSDocBloc_Changelog(all_found_usdocblocs[i], true, 1)
  title = ultraschall.Docs_GetUSDocBloc_Title(all_found_usdocblocs[i], 1)
  slug = ultraschall.Docs_GetUSDocBloc_Slug(all_found_usdocblocs[i])
  if changelogscount>0 then 
    for a=1, changelogscount do
      --print_alt("AAA",slug, changelogs[a][1], changelogs[a][2])
      if REAPER_CHLOGS[changelogs[a][1]]==nil then
        REAPER_CHLOGS[changelogs[a][1]]={}
      end
      REAPER_CHLOGS[changelogs[a][1]][#REAPER_CHLOGS[changelogs[a][1]]+1]=slug..":"..title..": "..changelogs[a][2]
    end
  end
end


for k, v in pairs(REAPER_CHLOGS) do
  table.sort(v)
end



ChangelogDoer("SWS", nil, "SWS API")
ChangelogDoer("JS", nil, "JS Extension API")
ChangelogDoer("ReaPack", nil, "ReaPack API")
ChangelogDoer("ReaImGui", nil, "ReaImGui API")
ChangelogDoer("Osara", nil, "Osara API")
ChangelogDoer("ReaBlink", nil, "ReaBlink API")
ChangelogDoer("ReaLLM", nil, "ReaLLM API")
ChangelogDoer("ReaFab", nil, "ReaFab API")
ChangelogDoer("ReaMCULive", nil, "ReaMCULive API")
ChangelogDoer("PeloReaper", nil, "PeloReaper API")
--]]

USDOCBLOCS = ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
found_usdocblocs, all_found_usdocblocs = ultraschall.Docs_GetAllUSDocBlocsFromString(USDOCBLOCS)
table.sort(all_found_usdocblocs)

REAPER_CHLOGS={}

for i=1, found_usdocblocs do
  print(all_found_usdocblocs[i])
  changelogscount, changelogs = ultraschall.Docs_GetUSDocBloc_Changelog(all_found_usdocblocs[i], true, 1)
  title = ultraschall.Docs_GetUSDocBloc_Title(all_found_usdocblocs[i], 1)
  slug = ultraschall.Docs_GetUSDocBloc_Slug(all_found_usdocblocs[i])
  if changelogscount>0 then 
    for a=1, changelogscount do
      --print_alt("AAA",slug, changelogs[a][1], changelogs[a][2])
      if REAPER_CHLOGS[changelogs[a][1]]==nil then
        REAPER_CHLOGS[changelogs[a][1]]={}
      end
      if title==nil then title=slug end
      REAPER_CHLOGS[changelogs[a][1]][#REAPER_CHLOGS[changelogs[a][1]]+1]=slug..":"..title..": "..changelogs[a][2]
    end
  end
end

ChangelogDoer("ReaGirl", "ReaGirl_Functions.html", "ReaGirl API")


CHANGELOG_FINAL=CHANGELOG_FINAL.."<hr width=\"80%\"></body></html>"

ultraschall.WriteValueToFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Documentation/API_Changelog.html", CHANGELOG_FINAL)

--reaper.CF_ShellExecute(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Documentation/API_Changelog.html")
