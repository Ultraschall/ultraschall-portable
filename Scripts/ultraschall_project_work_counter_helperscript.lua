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

-- counts the work-time of a project, can be shown in the ultraclock
reaper.set_action_options(1)

function check_reaper_focus()
  if ultraschall.GetUSExternalState("ultraschall_settings_work_counter_when_reaperfocus", "Value", "ultraschall-settings.ini")=="1" then
    return true
  else
    if reaper.GetMainHwnd()==reaper.JS_Window_GetFocus() then
      return true
    elseif reaper.GetMainHwnd()==reaper.JS_Window_GetParent(reaper.JS_Window_GetFocus()) then
      return true
    elseif reaper.GetMainHwnd()==reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetFocus())) then
      return true
    elseif reaper.GetMainHwnd()==reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetFocus()))) then
      return true
    elseif reaper.GetMainHwnd()==reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetFocus())))) then
      return true
    elseif reaper.GetMainHwnd()==reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetFocus()))))) then
      return true
    else
      return false
    end
  end
end

timer=reaper.time_precise()

function main()
  if reaper.time_precise()-timer>1 then
    if check_reaper_focus()==true then
      if reaper.GetProjExtState(0, "ultraschall_project_work_counter", "counter")==0 then
        local proj, projname = reaper.EnumProjects(-1)
        if projname=="" then
          reaper.SetProjExtState(0, "ultraschall_project_work_counter", "counter", "0")
        end
      end
      timer=reaper.time_precise()
      retval, timer2 = reaper.GetProjExtState(0, "ultraschall_project_work_counter", "counter")
      if timer2~="" then
        timer2=tonumber(timer2)
        timer2=timer2+1
        reaper.SetProjExtState(0, "ultraschall_project_work_counter", "counter", timer2)
      end
    end
  end
  
  reaper.defer(main)
end

main()

