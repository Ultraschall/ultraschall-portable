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

-- Meo Mespotine 2nd of September 2020
--
-- Ultraschall-API-helper-script for GetUserInputs, which will circumvent Reaper's limitation with
-- commas in the GetUserInputs-inputfields
-- so now, we have no need for csvs anymore

-- Issues: 
-- when GetUserInputs is run in a defer-script, Reaper does not allow background-scripts to be deferred and blocks them


if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

num_params, params, caller_script_identifier = ultraschall.GetScriptParameters()



--[[
Params are:

1 - Temp GetUserInputs-title
2 - New GetUserInputs-title
3 - (reserved)
4 - window x-position
5 - window y-position
6 - values-length
7 - caption-length
8 - (reserved)
9-24 - Captions
25-40 - Default Retvals
41 - (reserved)
--]]

--for i=1, num_params do
--    print(i.." "..params[i])
--end

function main2()
  
  -- Check, whether the window is still open and if yes, read all
  -- the titles(contents) of the inputfields and store them as
  -- an extstate, that will be read from the parent-script.
  -- If the window is closed, just quit the script.
  hwnd2=hwnd
  if hwnd2==nil then return end
    A=""
    for i=1, 16 do
      hwnd2=HWNDS_Def[i]
      if hwnd2~=nil then
        A=A..reaper.JS_Window_GetTitle(hwnd2).."\n"     
      else 
        oldcount=i-1
        break
      end
    end
    reaper.SetExtState(caller_script_identifier, "values", A, false)
    found=true
  if ultraschall.IsValidHWND(hwnd)==true then 
    --print(ultraschall.IsValidHWND(hwnd))
    reaper.defer(main2) 
  end
end

function main()
-- wait, until the GetUserInputs-window opens
  hwnd=reaper.JS_Window_Find(params[1], true)
  --print(params[1])
  if hwnd==nil then 
    reaper.defer(main)
  else    
    -- the GetUserInputs-window is open, so go into the main2-function    
    local retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(hwnd)
    reaper.JS_Window_SetTitle(hwnd, params[2])
    
    if params[4]~="keep" or params[5]~="keep" then
        if params[4]~="keep" then left=tonumber(params[4]) end
        if params[5]~="keep" then top=tonumber(params[5]) end

        reaper.JS_Window_Move(hwnd, left, top)
    end
    
    if params[6]=="keep" then params[6]=155 end
    caplength=tonumber(params[6])
    retlength=tonumber(params[7])
    GetUserInputsHWND = hwnd
    
    HWNDS_Capt={}
    HWNDS_Def ={}


    -- get HWNDs
    for i=1, 16 do
      HWNDS_Capt[i]=reaper.JS_Window_FindChild(GetUserInputsHWND, "A"..i, true)
      HWNDS_Def[i] =reaper.JS_Window_FindChild(GetUserInputsHWND, i, true)
    end

    -- set captions
    for i=1, 16 do 
      if HWNDS_Capt[i]==nil then break end
      reaper.JS_Window_SetTitle(HWNDS_Capt[i], params[i+caption_offset+5])
    end
    
    -- set retvals
    for i=1, 16 do 
      if HWNDS_Def[i]==nil then break end
      reaper.JS_Window_SetTitle(HWNDS_Def[i], params[i+caption_offset+21])
    end

    if ultraschall.IsOS_Mac()==false then    
    -- resize captions
      for i=1, 16 do
        if HWNDS_Capt[i]==nil then break end
        retval, left, top, right, bottom = reaper.JS_Window_GetRect(HWNDS_Capt[i])
        reaper.JS_Window_Resize(HWNDS_Capt[i], caplength, bottom-top)      
      end

      -- set retvals and resize them
      for i=1, 16 do
        if HWNDS_Def[i]==nil then break end
        retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(HWNDS_Def[i])
        reaper.JS_Window_Resize(HWNDS_Def[i], retlength, bottom-top)      
      end

      -- move retvals accordingly in relation to captions
      if caplength>155 then 
        for i=1, 16 do
          if HWNDS_Def[i]==nil then break end
          retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(HWNDS_Def[i])
          ultraschall.MoveChildWithinParentHWND(GetUserInputsHWND, HWNDS_Def[i], true, caplength-155, 0, retlength, 7)
        end
      end
       -- resize GetUserInputs-window
      caplength=caplength-155
      if caplength<0 then caplength=0 end
      retval, left, top, right, bottom = reaper.BR_Win32_GetWindowRect(GetUserInputsHWND)
      retval1, left1, top1, right1, bottom1 = reaper.BR_Win32_GetWindowRect(HWNDS_Def[1])
      reaper.JS_Window_SetPosition(GetUserInputsHWND, left, top, right1+13-left, bottom-top)
       -- reposition OK and Cancel-buttons
      OK=reaper.JS_Window_FindChild(GetUserInputsHWND, reaper.JS_Localize("OK", "common"), true)
      Cancel=reaper.JS_Window_FindChild(GetUserInputsHWND, reaper.JS_Localize("Cancel", "common"), true)
      retval, left , top , right , bottom  = reaper.BR_Win32_GetWindowRect(GetUserInputsHWND)
      retval, left2, top2, right2, bottom2 = reaper.BR_Win32_GetWindowRect(Cancel)
      ultraschall.MoveChildWithinParentHWND(GetUserInputsHWND, Cancel, true, right-right2-13, 1, 0, -2)
      ultraschall.MoveChildWithinParentHWND(GetUserInputsHWND, OK, true, right-right2-13, 0, 0, 0)
    end
    reaper.defer(main2)
  end
end

caption_offset=tonumber(params[3])

main()

