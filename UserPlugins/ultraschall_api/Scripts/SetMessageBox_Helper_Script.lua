  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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
  --]]

-- Meo Mespotine 10th of May 2019
--
-- Ultraschall-API-helper-script for MessageBox, that allows replacing the standard-captions of the buttons
-- with your own texts

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

num_params, params, caller_script_identifier = ultraschall.GetScriptParameters()

function main2()
    -- replaces the button-texts with own ones
    if tonumber(params[3])==0 then
        if params[4]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,2), params[4]) end
    elseif tonumber(params[3])==1 then
        if params[4]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,1), params[4]) end
        if params[5]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,2), params[5]) end
    elseif tonumber(params[3])==2 then
        if params[4]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,3), params[4]) end
        if params[5]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,4), params[5]) end
        if params[6]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,5), params[6]) end
    elseif tonumber(params[3])==3 then
        if params[4]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,2), params[4]) end
        if params[5]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,6), params[5]) end
        if params[6]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,7), params[6]) end
    elseif tonumber(params[3])==4 then
        if params[4]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,6), params[4]) end
        if params[5]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,7), params[5]) end
    elseif tonumber(params[3])==5 then
        if params[4]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,2), params[5]) end
        if params[5]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,4), params[4]) end
    elseif tonumber(params[3])==6 then
        if params[4]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,2), params[4]) end
        if params[5]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,10), params[5]) end
        if params[6]~="" then reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,11), params[6]) end
    end
end

function main()
-- wait, until the MessageBox-window opens
  hwnd=reaper.JS_Window_Find(params[1], true)
  if hwnd==nil then 
    reaper.defer(main)
  else
    -- the MessageBox-window is open, so go into the main2-function
    reaper.JS_Window_SetTitle(hwnd, params[2])
    reaper.defer(main2)
  end
end

main()

