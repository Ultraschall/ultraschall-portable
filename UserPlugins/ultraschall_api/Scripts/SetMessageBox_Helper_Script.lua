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

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

num_params, params, caller_script_identifier = ultraschall.GetScriptParameters()

function main2()
    -- replaces the button-texts with own ones
    B, B2=ultraschall.ReturnAllChildHWND(hwnd)

    -- the following lines probably need a mac-derivate, to use the "topmost" insted of mostbottom
    mostbottom=0
    for i=1, B do
      retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(B2[i])
      if top>mostbottom then mostbottom=top end
    end
    -- end of line, who need mac-derivate

    count=0
    HWND_sort={}
    HWND_sort_names={}
    for i=B, 1, -1 do
      retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(B2[i])
      if top~=mostbottom then
         table.remove(B2, i)
         B=B-1
      end
    end

    for i=B, 1, -1 do
      retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(B2[i])
      HWND_sort[i]=left.." "..tostring(reaper.JS_Window_GetTitle(B2[i]))-- left
    end

    table.sort(HWND_sort)

    for i=1, #HWND_sort do
      hwnd2=reaper.JS_Window_FindChild(hwnd, HWND_sort[i]:match(" (.*)"), true)
      if params[i+3]~="" then reaper.JS_Window_SetTitle(hwnd2, params[i+3]) end
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

