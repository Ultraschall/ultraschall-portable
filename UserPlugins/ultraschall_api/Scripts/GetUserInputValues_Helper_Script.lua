-- Meo Mespotine 9th of April 2019
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
  --hwnd2=reaper.JS_Window_FindChildByID(hwnd, 1)
  hwnd2=reaper.JS_Window_Find(params[2].."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "..params[1], true)
  if hwnd2==nil then return end
    A=""
    for i=1000, 1015 do
      hwnd2=reaper.JS_Window_FindChildByID(hwnd,i)
      if hwnd2~=nil then
        A=A..reaper.JS_Window_GetTitle(hwnd2).."\n"
      end
    end
    reaper.SetExtState(caller_script_identifier, "values", A, false)
    found=true
  reaper.defer(main2)
end

function main()
-- wait, until the GetUserInputs-window opens
  hwnd=reaper.JS_Window_Find(params[1], true)
  if hwnd==nil then 
    reaper.defer(main)
  else
    -- the GetUserInputs-window is open, so go into the main2-function
    reaper.JS_Window_SetTitle(hwnd, params[2].."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "..params[1])
    reaper.defer(main2)
  end
end

main()

