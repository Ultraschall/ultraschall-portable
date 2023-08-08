--[[
################################################################################
#
# Copyright (c) 2014-2023 Ultraschall (http://ultraschall.fm)
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
-- quickly renders the time-selection as flac into a folder in the project-folder called "RenderedSnippets/"
-- it renders the file as flac with the filename being the project-position and then a name.
--    01h23m34-name.flac

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function IsProjectSaved()
  -- OS BASED SEPARATOR
  if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
    -- user_folder = buf --"C:\\Users\\[username]" -- need to be test
    separator = "\\"
  else
    -- user_folder = "/USERS/[username]" -- Mac OS. Not tested on Linux.
    separator = "/"
  end

  retval, project_path_name = reaper.EnumProjects(-1, "")
  if project_path_name ~= "" then

    dir = project_path_name:match("(.*"..separator..")")
    --msg(name)
    name = string.sub(project_path_name, string.len(dir) + 1)
    name = string.sub(name, 1, -5)

    name = name:gsub(dir, "")

    --msg(name)
    project_saved = true
    return project_saved, dir
  else
    display = reaper.ShowMessageBox("You need to save the project to execute this script.", "Render Project", 0)
  end
  return false
end

retval, project_path_name=IsProjectSaved()
if retval~=true then return end

Start, Stop=reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
if Start==Stop then reaper.MB("You must set a time-selection first!", "Nothing to render", 0) return end

retvals, Title=reaper.GetUserInputs("Enter a name for the quick-render-file", 1, "Name, extrawidth=200", reaper.GetExtState("ultraschall_Quick_Render", "Last_FileName"))
if retvals==false then return end
if Title=="" then reaper.MB("You must enter a filename.", "Nothing to render", 0) return end
reaper.SetExtState("ultraschall_Quick_Render", "Last_FileName", Title, true)

RenderTable=ultraschall.CreateNewRenderTable()
RenderTable["RenderString"]=ultraschall.CreateRenderCFG_FLAC(0, 5)
RenderTable["Startposition"]=Start
RenderTable["Endposition"]=Stop
RenderTable["SilentlyIncrementFilename"]=false
Start_str=reaper.format_timestr_pos(Start, "", 5)
Stop_str=reaper.format_timestr_pos(Stop-Start, "", 5)
Hour, Minutes, Seconds = Stop_str:match("(.-):(.-):(.-):")
RenderTable["RenderPattern"]=Hour.."h"..Minutes.."m"..Seconds.."s".."-"..Title
RenderTable["Bounds"]=0
RenderTable["RenderFile"]=project_path_name.."/RenderedSnippets/"

oldstate_render_stats=ultraschall.GetRender_SaveRenderStats()
ultraschall.SetRender_SaveRenderStats(false)
ultraschall.RenderProject_RenderTable(nil, RenderTable, false, true, false, 1)

ultraschall.SetRender_SaveRenderStats(oldstate_render_stats)

reaper.defer()
