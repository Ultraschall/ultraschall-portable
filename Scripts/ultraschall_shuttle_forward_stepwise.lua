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
# s
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

val=tonumber(ultraschall.GetUSExternalState("ultraschall_settings_shuttle_step_speed", "Value", "ultraschall-settings.ini"))
if val==nil then val=0.1 end

function ultraschall.Scrubbing_Toggle(toggle)
  if type(toggle)~="boolean" then ultraschall.AddErrorMessage("Scrubbing_Toggle", "toggle", "must be boolean", -1) return false end
  return ultraschall.GetSetIntConfigVar("scrubmode", true, toggle)
end


ultraschall.Scrubbing_Toggle(true)

reaper.MoveEditCursor(val, false)

ultraschall.Scrubbing_Toggle(true)

