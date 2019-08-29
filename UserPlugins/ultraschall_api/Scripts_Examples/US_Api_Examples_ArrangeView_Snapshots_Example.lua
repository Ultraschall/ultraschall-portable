-- Ultraschall-API demoscript by Meo Mespotine 30.11.2018
-- 
-- store and retrieve arrangeview-snapshots, who contain the zoom as well as the position of the arrangeview
-- vertical scrolling not(yet) supported

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- Initialize window, font and variables
gfx.init("Arrangeview-Snapshots - Demoscript", 500, 300, 0, 400, 300)
gfx.setfont(1,"Times",16)

retval, description, startposition, endposition, vzoomfactor, hzoomfactor="none", "none", "-", "-", "-", "-"

function main()
  -- Get currently typed character and check for F1 to F4 keys (with or without Cmd/Ctrl-key pressed)
  Key=gfx.getchar()
  if gfx.mouse_cap&4==0 and Key==26161.0 then retval, description, startposition, endposition, vzoomfactor, hzoomfactor = ultraschall.RestoreArrangeviewSnapshot(1, true, true) end --F1
  if gfx.mouse_cap&4==0 and Key==26162.0 then retval, description, startposition, endposition, vzoomfactor, hzoomfactor = ultraschall.RestoreArrangeviewSnapshot(2, true, true) end --F2
  if gfx.mouse_cap&4==0 and Key==26163.0 then retval, description, startposition, endposition, vzoomfactor, hzoomfactor = ultraschall.RestoreArrangeviewSnapshot(3, true, true) end --F3
  if gfx.mouse_cap&4==0 and Key==26164.0 then retval, description, startposition, endposition, vzoomfactor, hzoomfactor = ultraschall.RestoreArrangeviewSnapshot(4, true, true) end --F4
  if description==nil then description="" end
  if startposition==nil then startposition="" end
  if endposition==nil then endposition="" end
  if hzoomfactor==nil then hzoomfactor="" end

  -- when using Cmd/Ctrl+F1 to F4, store the accompanying arrangeview-snapshot
  -- let the user decide first, how to name the arrange-view-snapshot
  if gfx.mouse_cap&4==4 and Key>=26161 and Key<=26164 then
    retval, snapshotname=reaper.GetUserInputs("Give the slot a name", 1, "", "")
  end
  if gfx.mouse_cap&4==4 and Key==26161.0 then ultraschall.StoreArrangeviewSnapshot(1, snapshotname, true, true) end --F1
  if gfx.mouse_cap&4==4 and Key==26162.0 then ultraschall.StoreArrangeviewSnapshot(2, snapshotname, true, true) end --F2
  if gfx.mouse_cap&4==4 and Key==26163.0 then ultraschall.StoreArrangeviewSnapshot(3, snapshotname, true, true) end --F3
  if gfx.mouse_cap&4==4 and Key==26164.0 then ultraschall.StoreArrangeviewSnapshot(4, snapshotname, true, true) end --F4
  
  -- Display text and current arrange-view-variables
  gfx.x=0
  gfx.y=0
  gfx.drawstr("Store Arrangeview-Snapshots.\n\nuse Cmd/Ctrl+F1 to F4 to store one arrangeview-snapshot\n\nuse F1 to F4 to retrieve one\n\nIn this demo, the focus must be on this gfx-window to\nset/retrieve Arrangeview-Snapshots.\n\nThe snapshots will be stored in the project itself.")
  gfx.x=0
  gfx.drawstr("\n\nCurrently used slot: "..description.." \n\t          start: "..startposition.." \n           end: "..endposition.." \n       hzoom: "..tostring(hzoomfactor))
  
  gfx.update()
  if Key~=-1 then reaper.defer(main) end
end

main() 