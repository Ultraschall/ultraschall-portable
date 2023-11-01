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
_,_,secID,cmdID = reaper.get_action_context()

obey_locked_toggle = ultraschall.GetUSExternalState("ultraschall_settings_ripplecut_obey_locked", "value","ultraschall-settings.ini")
if obey_locked_toggle=="1" then 
  ultraschall.SetUSExternalState("ultraschall_settings_ripplecut_obey_locked", "value", "0", "ultraschall-settings.ini") 
  reaper.SetToggleCommandState(secID, cmdID, 0)
else 
  ultraschall.SetUSExternalState("ultraschall_settings_ripplecut_obey_locked", "value", "1", "ultraschall-settings.ini") 
  reaper.SetToggleCommandState(secID, cmdID, 1)
end
