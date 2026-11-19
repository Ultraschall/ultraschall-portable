function CheckForDependencies(ReaImGui, js_ReaScript, US_API, SWS, Osara)
  if US_API==true or js_ReaScript==true or ReaImGui==true or SWS==true or Osara==true then
    if US_API==true and reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==false then
      US_API="Ultraschall API" -- "Ultraschall API" or ""
    else
      US_API=""
    end
    
    if reaper.JS_ReaScriptAPI_Version==nil and js_ReaScript==true then
      js_ReaScript="js_ReaScript" -- "js_ReaScript" or ""
    else
      js_ReaScript=""
    end
    
    if reaper.ImGui_GetVersion==nil and ReaImGui==true then
      ReaImGui="ReaImGui" -- "ReaImGui" or ""
    else
      ReaImGui=""
    end
    
    if reaper.CF_GetSWSVersion==nil and SWS==true then
      SWS="SWS" -- "ReaImGui" or ""
    else
      SWS=""
    end
    
    if reaper.osara_outputMessage==nil and Osara==true then
      Osara="Osara" -- "ReaImGui" or ""
    else
      Osara=""
    end
    
    if Osara=="" and SWS=="" and js_ReaScript=="" and ReaImGui=="" and US_API=="" then return true end
    local state=reaper.MB("This script needs additionally \n\n"..ReaImGui.."\n"..js_ReaScript.."\n"..US_API.."\n"..SWS.."\n"..Osara.."\n\ninstalled to work. Do you want to install them?", "Dependencies required", 4) 
    if state==7 then return false end
    if SWS~="" then
      reaper.MB("SWS can be downloaded from sws-extension.org/download/pre-release/", "SWS missing", 0)
    end
    
    if Osara~="" then
      reaper.MB("Osara can be downloaded from https://osara.reaperaccessibility.com/", "Osara missing", 0)
    end
    
    if reaper.ReaPack_BrowsePackages==nil and (US_API~="" or ReaImGui~="" or js_ReaScript~="") then
      reaper.MB("Some uninstalled dependencies need ReaPack to be installed. Can be downloaded from https://reapack.com/", "ReaPack missing", 0)
      return false
    else
      
      if US_API=="Ultraschall API" then
        reaper.ReaPack_AddSetRepository("Ultraschall API", "https://github.com/Ultraschall/ultraschall-lua-api-for-reaper/raw/master/ultraschall_api_index.xml", true, 2)
        reaper.ReaPack_ProcessQueue(true)
      end
      
      if US_API~="" or ReaImGui~="" or js_ReaScript~="" then 
        reaper.ReaPack_BrowsePackages(js_ReaScript.." OR "..ReaImGui.." OR "..US_API)
      end
    end
  end
  return true
end

state=CheckForDependencies(false, true, false, true, false)
if state==false then reaper.MB("Can't start script due to missing dependencies", "Error", 0) return end
if reaper.JS_ReaScriptAPI_Version==nil then return end
  
  dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
  
  function Image_RunFunction(clicked_image_id)
    -- this function is run, when the image is clicked
    
    -- get the filename of the currently loaded image-file
    filename = reagirl.Image_GetImageFilename(clicked_image_id)
  end
  
  function Image_DropZone_RunFunction(element_id, dropped_filenames_table)
    -- this function will be called everytime a file is dropped onto the image
    
    -- load the first file dropped as new image and show it
    reagirl.Image_Load(element_id, dropped_filenames_table[1])
  end
  
  function Image_ContextMenu_RunFunction(element_id, menu_entry_selection)
    -- this function will be called when the user opens up 
    -- the context-menu of the image and makes a choice
    if menu_entry_selection==1 then
      -- if user chose the first menu-entry, clear the image to black
      reagirl.Image_ClearToColor(element_id, 0, 0, 0)
    elseif menu_entry_selection==2 then
      -- if user chose the second menu-entry, allow to load an image using a file requester
      retval, filename = 
              reaper.GetUserFileNameForRead(reaper.GetResourcePath().."/Data/track_icons/", 
                                            "Choose an image to load", 
                                            "*.png;*.jpg")
      if retval==true then
        reagirl.Image_Load(element_id, filename)  
      end
    end
  end
  
  -- create new gui
  reagirl.Gui_New()
  
  -- add the image of a bass guitar to this gui
  image_id = reagirl.Image_Add(10, 10, 100, 100, reaper.GetResourcePath().."/Data/track_icons/bass.png", "An image", "A user selectable image.", Image_RunFunction)
  -- add a dropzone for dropped files for this image
  reagirl.UI_Element_GetSet_DropZoneFunction(image_id, true, Image_DropZone_RunFunction)
  -- add a context-menu to this image
  reagirl.UI_Element_GetSet_ContextMenu(image_id, true, "Clear Image|Select a file", Image_ContextMenu_RunFunction)
  -- keep the aspect ratio of the image properly
  reagirl.Image_KeepAspectRatio(image_id, true)
  
  -- open the new gui
  reagirl.Gui_Open("My Dialog Name", false, "Image Viewer", "This is a demo image viewer.", 120, 120)

  -- make the background grey
  reagirl.Background_GetSetColor(true, 55, 55, 55)

  function main()
    -- a function that runs the gui-manage function in the background, so the gui is updated correctly
    reagirl.Gui_Manage()
    
    -- if the gui-window hasn't been closed, keep the script alive.
    if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
  end

  main()
