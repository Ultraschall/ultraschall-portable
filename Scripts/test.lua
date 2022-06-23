dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

--reaper.SetExtState("ultraschall_api", "markermenu_debug_messages_markerinfo_in_menu", "1", false)

--ultraschall.MarkerMenu_Debug(0)
SLEM()
--reaper.DeleteExtState("ultraschall_api", "markermenu_debug_messages_markerinfo_in_menu", false)

--A=reaper.GetExtState("ultraschall_api", "markermenu_debug_messages_markerinfo_in_menu", "1", false)

retval, chap_description = ultraschall.GetSetChapterMarker_Attributes(true, 1, "chap_description", "huch")
retval2, chap_description2 = ultraschall.GetSetChapterMarker_Attributes(false, 1, "chap_description", "huch")
