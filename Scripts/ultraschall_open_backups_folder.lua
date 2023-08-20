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

-- little helpers
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- Get Path from file name
function GetPath(str,sep)
  return str:match("(.*"..sep..")")
end

function GetFileExtension(url)
  return url:match("^.+(%..+)$")
end

function GetFileName(url)
	return url:match("^.+/(.+)$")
end


--------------------
-- end of functions
--------------------

--------------------
-- check for saved project
--------------------


if reaper.GetProjectName(0, "") == "" then

  Message = "?;ExportContext;".."Save your project to use the consolidate backups feature."
  reaper.SetExtState("ultraschall_messages", "message_0", Message, false)
  reaper.SetExtState("ultraschall_messages", "message_count", "1", false)
	goto exit -- abort
end

commandid = reaper.NamedCommandLookup("_Ultraschall_Consolidate_Backups")
reaper.Main_OnCommand(commandid,0)

-------------------------------
-- Finde den Projektordnerpfad
-------------------------------

if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
  -- user_folder = buf --"C:\\Users\\[username]" -- need to be test
  separator = "\\"
else
  -- user_folder = "/USERS/[username]" -- Mac OS. Not tested on Linux.
  separator = "/"
end


retval, project_path_name = reaper.EnumProjects(-1, "")
if project_path_name ~= "" then

  dir = GetPath(project_path_name, separator)

end

if ultraschall.GetUSExternalState("ultraschall_gui", "donotopen_backupfolder") ~= "true" then
  ultraschall.OpenURL(dir.."backup")
else
  ultraschall.SetUSExternalState("ultraschall_gui", "donotopen_backupfolder", "false")
end

::exit::