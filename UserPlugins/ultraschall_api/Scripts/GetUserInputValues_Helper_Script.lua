-- Meo Mespotine 11th of June 2019
--
-- Ultraschall-API-helper-script for GetUserInputs, which will circumvent Reaper's limitation with
-- commas in the GetUserInputs-inputfields
-- so now, we have no need for csvs anymore

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

num_params, params, caller_script_identifier = ultraschall.GetScriptParameters()

function main2()
  -- Check, whether the window is still open and if yes, read all
  -- the titles(contents) of the inputfields and store them as
  -- an extstate, that will be read from the parent-script.
  -- If the window is closed, just quit the script.
  hwnd2=hwnd
  if hwnd2==nil then return end
    --reaper.ClearConsole()
    A=""
    for i=1000, 1015 do
      hwnd2=reaper.JS_Window_FindChildByID(hwnd,i)
      if hwnd2~=nil then
        A=A..reaper.JS_Window_GetTitle(hwnd2).."\n"
      end
    end
    reaper.SetExtState(caller_script_identifier, "values", A, false)
    found=true
  if ultraschall.IsValidHWND(hwnd2)==true then reaper.defer(main2) end
end

function main()
-- wait, until the GetUserInputs-window opens
  hwnd=reaper.JS_Window_Find(params[1], true)
  if hwnd==nil then 
    reaper.defer(main)
  else
    -- the GetUserInputs-window is open, so go into the main2-function
    
    local retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(hwnd)
    
    if params[4]~="keep" or params[5]~="keep" then
        if params[4]~="keep" then left=tonumber(params[4]) end
        if params[5]~="keep" then top=tonumber(params[5]) end

        reaper.JS_Window_Move(hwnd, left, top)
    end
    retval, left, top, right, bottom = reaper.JS_Window_GetRect(hwnd)
    if params[6]~="keep" then
        for i=1000, 1015 do
            ultraschall.MoveChildWithinParentHWND(hwnd, reaper.JS_Window_FindChildByID(hwnd, i), true, tonumber(params[6]), 0, 0, 0)
        end
        for i=2000, 2015 do
            ultraschall.MoveChildWithinParentHWND(hwnd, reaper.JS_Window_FindChildByID(hwnd, i), true, 0, 0, tonumber(params[6]), 0)
        end
        ultraschall.MoveChildWithinParentHWND(hwnd, reaper.JS_Window_FindChildByID(hwnd, 1), true, tonumber(params[6]), 0,0,0)
        ultraschall.MoveChildWithinParentHWND(hwnd, reaper.JS_Window_FindChildByID(hwnd, 2), true, tonumber(params[6]), 0,0,0)
        
        reaper.JS_Window_SetPosition(hwnd, left-math.floor(params[6]/2), top, right-left+params[6], bottom-top)
    end
    reaper.JS_Window_SetTitle(hwnd, params[2])
    for i=1, 16 do
        reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,1999+i), params[i+caption_offset+4])
    end
    for i=1, 16 do
        reaper.JS_Window_SetTitle(reaper.JS_Window_FindChildByID(hwnd,999+i), params[i+caption_offset+20])
    end
    
    
    
    reaper.defer(main2)
  end
end

caption_offset=tonumber(params[3])

main()

