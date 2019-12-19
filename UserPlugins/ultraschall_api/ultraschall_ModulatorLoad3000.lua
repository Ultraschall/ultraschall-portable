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
]]
-- This makes the incredible and magical automatic loading of functions-when-needed-feature possible

function ultraschall.LM(name)
  dofile(ultraschall.Api_Path.."/Modules/"..ultraschall.Modules_List[name])
end

ultraschall.Modules_List={"ultraschall_functions_AudioManagement_Module.lua",
"ultraschall_functions_AutomationItems_Module.lua",
"ultraschall_functions_Clipboard_Module.lua",
"ultraschall_functions_Color_Module.lua",
"ultraschall_functions_ConfigurationFiles_Module.lua",
"ultraschall_functions_ConfigurationSettings_Module.lua",
"ultraschall_functions_DeferManagement_Module.lua",
"ultraschall_functions_Envelope_Module.lua",
"ultraschall_functions_EventManager.lua",
"ultraschall_functions_FileManagement_Module.lua",
"ultraschall_functions_FXManagement_Module.lua",
"ultraschall_functions_HelperFunctions_Module.lua",
"ultraschall_functions_Localize_Module.lua",
"ultraschall_functions_Markers_Module.lua",
"ultraschall_functions_MediaItem_MediaItemStates_Module.lua",
"ultraschall_functions_MediaItem_Module.lua",
"ultraschall_functions_MetaData_Module.lua",
"ultraschall_functions_MIDIManagement_Module.lua",
"ultraschall_functions_Muting_Module.lua",
"ultraschall_functions_Navigation_Module.lua",
"ultraschall_functions_ProjectManagement_Module.lua",
"ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua",
"ultraschall_functions_ReaMote_Module.lua",
"ultraschall_functions_ReaperUserInterface_Module.lua",
"ultraschall_functions_Render_Module.lua",
"ultraschall_functions_TrackManagement_Module.lua",
"ultraschall_functions_TrackManagement_Routing_Module.lua",
"ultraschall_functions_TrackManagement_TrackStates_Module.lua",
"ultraschall_functions_Ultraschall_Module.lua"}

if ultraschall.US_BetaFunctions=="ON" then
  -- if beta-functions are available, load all functions from all modules
  local found_files=0
  local files_array2={}
  local filecount=0
  local file=""
  while file~=nil do
    local file=reaper.EnumerateFiles(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Modules/",filecount)
    if file==nil then break end
    file=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Modules/"..file
    found_files=filecount+1
    files_array2[filecount+1]=file
    filecount=filecount+1
  end
  for i=1, found_files do
    dofile(files_array2[i])
  end
else
  -- if beta-functions aren't available, load temporary functions, who load their accompanying module, when needed
  function ultraschall.GetHWInputs_Aliasnames(...)
    ultraschall.LM(1)
    return ultraschall.GetHWInputs_Aliasnames(table.unpack({...}))
  end
  function ultraschall.GetHWOutputs_Aliasnames(...)
    ultraschall.LM(1)
    return ultraschall.GetHWOutputs_Aliasnames(table.unpack({...}))
  end
  function ultraschall.GetProject_AutomationItemStateChunk(...)
    ultraschall.LM(2)
    return ultraschall.GetProject_AutomationItemStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_CountAutomationItems(...)
    ultraschall.LM(2)
    return ultraschall.GetProject_CountAutomationItems(table.unpack({...}))
  end
  function ultraschall.GetMediaItemsFromClipboard(...)
    ultraschall.LM(3)
    return ultraschall.GetMediaItemsFromClipboard(table.unpack({...}))
  end
  function ultraschall.GetStringFromClipboard_SWS(...)
    ultraschall.LM(3)
    return ultraschall.GetStringFromClipboard_SWS(table.unpack({...}))
  end
  function ultraschall.PutMediaItemsToClipboard_MediaItemArray(...)
    ultraschall.LM(3)
    return ultraschall.PutMediaItemsToClipboard_MediaItemArray(table.unpack({...}))
  end
  function ultraschall.ConvertColor(...)
    ultraschall.LM(4)
    return ultraschall.ConvertColor(table.unpack({...}))
  end
  function ultraschall.ConvertColorReverse(...)
    ultraschall.LM(4)
    return ultraschall.ConvertColorReverse(table.unpack({...}))
  end
  function ultraschall.RGB2Grayscale(...)
    ultraschall.LM(4)
    return ultraschall.RGB2Grayscale(table.unpack({...}))
  end
  function ultraschall.ConvertColorToGFX(...)
    ultraschall.LM(4)
    return ultraschall.ConvertColorToGFX(table.unpack({...}))
  end
  function ultraschall.ConvertGFXToColor(...)
    ultraschall.LM(4)
    return ultraschall.ConvertGFXToColor(table.unpack({...}))
  end
  function ultraschall.CreateColorTable(...)
    ultraschall.LM(4)
    return ultraschall.CreateColorTable(table.unpack({...}))
  end
  function ultraschall.CreateSonicRainboomColorTable(...)
    ultraschall.LM(4)
    return ultraschall.CreateSonicRainboomColorTable(table.unpack({...}))
  end
  function ultraschall.IsValidColorTable(...)
    ultraschall.LM(4)
    return ultraschall.IsValidColorTable(table.unpack({...}))
  end
  function ultraschall.ApplyColorTableToTrackColors(...)
    ultraschall.LM(4)
    return ultraschall.ApplyColorTableToTrackColors(table.unpack({...}))
  end
  function ultraschall.ApplyColorTableToItemColors(...)
    ultraschall.LM(4)
    return ultraschall.ApplyColorTableToItemColors(table.unpack({...}))
  end
  function ultraschall.ChangeColorBrightness(...)
    ultraschall.LM(4)
    return ultraschall.ChangeColorBrightness(table.unpack({...}))
  end
  function ultraschall.ChangeColorContrast(...)
    ultraschall.LM(4)
    return ultraschall.ChangeColorContrast(table.unpack({...}))
  end
  function ultraschall.ChangeColorSaturation(...)
    ultraschall.LM(4)
    return ultraschall.ChangeColorSaturation(table.unpack({...}))
  end
  function ultraschall.ConvertColorToMac(...)
    ultraschall.LM(4)
    return ultraschall.ConvertColorToMac(table.unpack({...}))
  end
  function ultraschall.ConvertColorToWin(...)
    ultraschall.LM(4)
    return ultraschall.ConvertColorToWin(table.unpack({...}))
  end
  function ultraschall.ConvertColorFromMac(...)
    ultraschall.LM(4)
    return ultraschall.ConvertColorFromMac(table.unpack({...}))
  end
  function ultraschall.ConvertColorFromWin(...)
    ultraschall.LM(4)
    return ultraschall.ConvertColorFromWin(table.unpack({...}))
  end
  function ultraschall.SetIniFileExternalState(...)
    ultraschall.LM(5)
    return ultraschall.SetIniFileExternalState(table.unpack({...}))
  end
  function ultraschall.GetIniFileExternalState(...)
    ultraschall.LM(5)
    return ultraschall.GetIniFileExternalState(table.unpack({...}))
  end
  function ultraschall.CountIniFileExternalState_sec(...)
    ultraschall.LM(5)
    return ultraschall.CountIniFileExternalState_sec(table.unpack({...}))
  end
  function ultraschall.CountIniFileExternalState_key(...)
    ultraschall.LM(5)
    return ultraschall.CountIniFileExternalState_key(table.unpack({...}))
  end
  function ultraschall.EnumerateIniFileExternalState_sec(...)
    ultraschall.LM(5)
    return ultraschall.EnumerateIniFileExternalState_sec(table.unpack({...}))
  end
  function ultraschall.EnumerateIniFileExternalState_key(...)
    ultraschall.LM(5)
    return ultraschall.EnumerateIniFileExternalState_key(table.unpack({...}))
  end
  function ultraschall.CountSectionsByPattern(...)
    ultraschall.LM(5)
    return ultraschall.CountSectionsByPattern(table.unpack({...}))
  end
  function ultraschall.CountKeysByPattern(...)
    ultraschall.LM(5)
    return ultraschall.CountKeysByPattern(table.unpack({...}))
  end
  function ultraschall.CountValuesByPattern(...)
    ultraschall.LM(5)
    return ultraschall.CountValuesByPattern(table.unpack({...}))
  end
  function ultraschall.EnumerateSectionsByPattern(...)
    ultraschall.LM(5)
    return ultraschall.EnumerateSectionsByPattern(table.unpack({...}))
  end
  function ultraschall.EnumerateKeysByPattern(...)
    ultraschall.LM(5)
    return ultraschall.EnumerateKeysByPattern(table.unpack({...}))
  end
  function ultraschall.EnumerateValuesByPattern(...)
    ultraschall.LM(5)
    return ultraschall.EnumerateValuesByPattern(table.unpack({...}))
  end
  function ultraschall.GetKBIniFilepath(...)
    ultraschall.LM(5)
    return ultraschall.GetKBIniFilepath(table.unpack({...}))
  end
  function ultraschall.CountKBIniActions(...)
    ultraschall.LM(5)
    return ultraschall.CountKBIniActions(table.unpack({...}))
  end
  function ultraschall.CountKBIniScripts(...)
    ultraschall.LM(5)
    return ultraschall.CountKBIniScripts(table.unpack({...}))
  end
  function ultraschall.CountKBIniKeys(...)
    ultraschall.LM(5)
    return ultraschall.CountKBIniKeys(table.unpack({...}))
  end
  function ultraschall.GetKBIniActions(...)
    ultraschall.LM(5)
    return ultraschall.GetKBIniActions(table.unpack({...}))
  end
  function ultraschall.GetKBIniScripts(...)
    ultraschall.LM(5)
    return ultraschall.GetKBIniScripts(table.unpack({...}))
  end
  function ultraschall.GetKBIniKeys(...)
    ultraschall.LM(5)
    return ultraschall.GetKBIniKeys(table.unpack({...}))
  end
  function ultraschall.GetKBIniActionsID_ByActionCommandID(...)
    ultraschall.LM(5)
    return ultraschall.GetKBIniActionsID_ByActionCommandID(table.unpack({...}))
  end
  function ultraschall.GetKBIniScripts_ByActionCommandID(...)
    ultraschall.LM(5)
    return ultraschall.GetKBIniScripts_ByActionCommandID(table.unpack({...}))
  end
  function ultraschall.GetKBIniKeys_ByActionCommandID(...)
    ultraschall.LM(5)
    return ultraschall.GetKBIniKeys_ByActionCommandID(table.unpack({...}))
  end
  function ultraschall.SetKBIniActions(...)
    ultraschall.LM(5)
    return ultraschall.SetKBIniActions(table.unpack({...}))
  end
  function ultraschall.SetKBIniScripts(...)
    ultraschall.LM(5)
    return ultraschall.SetKBIniScripts(table.unpack({...}))
  end
  function ultraschall.SetKBIniKeys(...)
    ultraschall.LM(5)
    return ultraschall.SetKBIniKeys(table.unpack({...}))
  end
  function ultraschall.DeleteKBIniActions(...)
    ultraschall.LM(5)
    return ultraschall.DeleteKBIniActions(table.unpack({...}))
  end
  function ultraschall.DeleteKBIniScripts(...)
    ultraschall.LM(5)
    return ultraschall.DeleteKBIniScripts(table.unpack({...}))
  end
  function ultraschall.DeleteKBIniKeys(...)
    ultraschall.LM(5)
    return ultraschall.DeleteKBIniKeys(table.unpack({...}))
  end
  function ultraschall.GetIniFileValue(...)
    ultraschall.LM(5)
    return ultraschall.GetIniFileValue(table.unpack({...}))
  end
  function ultraschall.SetIniFileValue(...)
    ultraschall.LM(5)
    return ultraschall.SetIniFileValue(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAcidImport(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAcidImport(table.unpack({...}))
  end
  function ultraschall.GetSetConfigActionMenu(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigActionMenu(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAdjRecLat(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAdjRecLat(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAdjRecManLat(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAdjRecManLat(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAfxCfg(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAfxCfg(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAllStereoPairs(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAllStereoPairs(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAlwaysAllowKB(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAlwaysAllowKB(table.unpack({...}))
  end
  function ultraschall.GetSetConfigApplyFXTail(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigApplyFXTail(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAdjRecManLatIn(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAdjRecManLatIn(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAudioPrShift(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAudioPrShift(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAudioCloseStop(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAudioCloseStop(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAudioThreadPr(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAudioThreadPr(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAudioCloseTrackWnds(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAudioCloseTrackWnds(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAutoMute(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAutoMute(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAutoMuteFlags(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAutoMuteFlags(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAutoSaveInt(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAutoSaveInt(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAutoSaveMode(...)
    ultraschall.LM(6)
    return ultraschall.GetSetConfigAutoSaveMode(table.unpack({...}))
  end
  function ultraschall.SetRender_OfflineOnlineMode(...)
    ultraschall.LM(6)
    return ultraschall.SetRender_OfflineOnlineMode(table.unpack({...}))
  end
  function ultraschall.GetRender_OfflineOnlineMode(...)
    ultraschall.LM(6)
    return ultraschall.GetRender_OfflineOnlineMode(table.unpack({...}))
  end
  function ultraschall.GetRender_ResampleMode(...)
    ultraschall.LM(6)
    return ultraschall.GetRender_ResampleMode(table.unpack({...}))
  end
  function ultraschall.SetRender_ResampleMode(...)
    ultraschall.LM(6)
    return ultraschall.SetRender_ResampleMode(table.unpack({...}))
  end
  function ultraschall.GetStartNewFileRecSizeState(...)
    ultraschall.LM(6)
    return ultraschall.GetStartNewFileRecSizeState(table.unpack({...}))
  end
  function ultraschall.SetStartNewFileRecSizeState(...)
    ultraschall.LM(6)
    return ultraschall.SetStartNewFileRecSizeState(table.unpack({...}))
  end
  function ultraschall.GetDeferIdentifier(...)
    ultraschall.LM(7)
    return ultraschall.GetDeferIdentifier(table.unpack({...}))
  end
  function ultraschall.GetDeferRunState(...)
    ultraschall.LM(7)
    return ultraschall.GetDeferRunState(table.unpack({...}))
  end
  function ultraschall.Defer1(...)
    ultraschall.LM(7)
    return ultraschall.Defer1(table.unpack({...}))
  end
  function ultraschall.StopDeferCycle(...)
    ultraschall.LM(7)
    return ultraschall.StopDeferCycle(table.unpack({...}))
  end
  function ultraschall.Defer2(...)
    ultraschall.LM(7)
    return ultraschall.Defer2(table.unpack({...}))
  end
  function ultraschall.Defer3(...)
    ultraschall.LM(7)
    return ultraschall.Defer3(table.unpack({...}))
  end
  function ultraschall.Defer4(...)
    ultraschall.LM(7)
    return ultraschall.Defer4(table.unpack({...}))
  end
  function ultraschall.Defer5(...)
    ultraschall.LM(7)
    return ultraschall.Defer5(table.unpack({...}))
  end
  function ultraschall.Defer6(...)
    ultraschall.LM(7)
    return ultraschall.Defer6(table.unpack({...}))
  end
  function ultraschall.Defer7(...)
    ultraschall.LM(7)
    return ultraschall.Defer7(table.unpack({...}))
  end
  function ultraschall.Defer8(...)
    ultraschall.LM(7)
    return ultraschall.Defer8(table.unpack({...}))
  end
  function ultraschall.Defer9(...)
    ultraschall.LM(7)
    return ultraschall.Defer9(table.unpack({...}))
  end
  function ultraschall.Defer10(...)
    ultraschall.LM(7)
    return ultraschall.Defer10(table.unpack({...}))
  end
  function ultraschall.Defer11(...)
    ultraschall.LM(7)
    return ultraschall.Defer11(table.unpack({...}))
  end
  function ultraschall.Defer12(...)
    ultraschall.LM(7)
    return ultraschall.Defer12(table.unpack({...}))
  end
  function ultraschall.Defer13(...)
    ultraschall.LM(7)
    return ultraschall.Defer13(table.unpack({...}))
  end
  function ultraschall.Defer14(...)
    ultraschall.LM(7)
    return ultraschall.Defer14(table.unpack({...}))
  end
  function ultraschall.Defer15(...)
    ultraschall.LM(7)
    return ultraschall.Defer15(table.unpack({...}))
  end
  function ultraschall.Defer16(...)
    ultraschall.LM(7)
    return ultraschall.Defer16(table.unpack({...}))
  end
  function ultraschall.Defer17(...)
    ultraschall.LM(7)
    return ultraschall.Defer17(table.unpack({...}))
  end
  function ultraschall.Defer18(...)
    ultraschall.LM(7)
    return ultraschall.Defer18(table.unpack({...}))
  end
  function ultraschall.Defer19(...)
    ultraschall.LM(7)
    return ultraschall.Defer19(table.unpack({...}))
  end
  function ultraschall.Defer20(...)
    ultraschall.LM(7)
    return ultraschall.Defer20(table.unpack({...}))
  end
  function ultraschall.Defer(...)
    ultraschall.LM(7)
    return ultraschall.Defer(table.unpack({...}))
  end
  function ultraschall.IsValidEnvStateChunk(...)
    ultraschall.LM(8)
    return ultraschall.IsValidEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.MoveTrackEnvelopePointsBy(...)
    ultraschall.LM(8)
    return ultraschall.MoveTrackEnvelopePointsBy(table.unpack({...}))
  end
  function ultraschall.GetEnvelopePoint(...)
    ultraschall.LM(8)
    return ultraschall.GetEnvelopePoint(table.unpack({...}))
  end
  function ultraschall.GetClosestEnvelopePointIDX_ByTime(...)
    ultraschall.LM(8)
    return ultraschall.GetClosestEnvelopePointIDX_ByTime(table.unpack({...}))
  end
  function ultraschall.GetEnvelopePointIDX_Between(...)
    ultraschall.LM(8)
    return ultraschall.GetEnvelopePointIDX_Between(table.unpack({...}))
  end
  function ultraschall.CheckEnvelopePointObject(...)
    ultraschall.LM(8)
    return ultraschall.CheckEnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.IsValidEnvelopePointObject(...)
    ultraschall.LM(8)
    return ultraschall.IsValidEnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.SetEnvelopePoints_EnvelopePointObject(...)
    ultraschall.LM(8)
    return ultraschall.SetEnvelopePoints_EnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.SetEnvelopePoints_EnvelopePointArray(...)
    ultraschall.LM(8)
    return ultraschall.SetEnvelopePoints_EnvelopePointArray(table.unpack({...}))
  end
  function ultraschall.DeleteEnvelopePoints_EnvelopePointObject(...)
    ultraschall.LM(8)
    return ultraschall.DeleteEnvelopePoints_EnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.DeleteEnvelopePoints_EnvelopePointArray(...)
    ultraschall.LM(8)
    return ultraschall.DeleteEnvelopePoints_EnvelopePointArray(table.unpack({...}))
  end
  function ultraschall.AddEnvelopePoints_EnvelopePointObject(...)
    ultraschall.LM(8)
    return ultraschall.AddEnvelopePoints_EnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.AddEnvelopePoints_EnvelopePointArray(...)
    ultraschall.LM(8)
    return ultraschall.AddEnvelopePoints_EnvelopePointArray(table.unpack({...}))
  end
  function ultraschall.CreateEnvelopePointObject(...)
    ultraschall.LM(8)
    return ultraschall.CreateEnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.CountEnvelopePoints(...)
    ultraschall.LM(8)
    return ultraschall.CountEnvelopePoints(table.unpack({...}))
  end
  function ultraschall.SetEnvelopeHeight(...)
    ultraschall.LM(8)
    return ultraschall.SetEnvelopeHeight(table.unpack({...}))
  end
  function ultraschall.GetAllTrackEnvelopes(...)
    ultraschall.LM(8)
    return ultraschall.GetAllTrackEnvelopes(table.unpack({...}))
  end
  function ultraschall.IsValidEnvelopePointArray(...)
    ultraschall.LM(8)
    return ultraschall.IsValidEnvelopePointArray(table.unpack({...}))
  end
  function ultraschall.GetLastEnvelopePoint_TrackEnvelope(...)
    ultraschall.LM(8)
    return ultraschall.GetLastEnvelopePoint_TrackEnvelope(table.unpack({...}))
  end
  function ultraschall.GetArmState_Envelope(...)
    ultraschall.LM(8)
    return ultraschall.GetArmState_Envelope(table.unpack({...}))
  end
  function ultraschall.SetArmState_Envelope(...)
    ultraschall.LM(8)
    return ultraschall.SetArmState_Envelope(table.unpack({...}))
  end
  function ultraschall.GetTrackEnvelope_ClickState(...)
    ultraschall.LM(8)
    return ultraschall.GetTrackEnvelope_ClickState(table.unpack({...}))
  end
  function ultraschall.EventManager_EnumerateStartupEvents(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_EnumerateStartupEvents(table.unpack({...}))
  end
  function ultraschall.EventManager_EnumerateStartupEvents2(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_EnumerateStartupEvents2(table.unpack({...}))
  end
  function ultraschall.EventManager_AddEvent(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_AddEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_IsValidEventIdentifier(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_IsValidEventIdentifier(table.unpack({...}))
  end
  function ultraschall.Eventmanager_RemoveEvent(...)
    ultraschall.LM(9)
    return ultraschall.Eventmanager_RemoveEvent(table.unpack({...}))
  end
  function ultraschall.Eventmanager_RemoveAllEvents_Script(...)
    ultraschall.LM(9)
    return ultraschall.Eventmanager_RemoveAllEvents_Script(table.unpack({...}))
  end
  function ultraschall.EventManager_SetEvent(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_SetEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_EnumerateEvents(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_EnumerateEvents(table.unpack({...}))
  end
  function ultraschall.EventManager_EnumerateEvents2(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_EnumerateEvents2(table.unpack({...}))
  end
  function ultraschall.EventManager_CountRegisteredEvents(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_CountRegisteredEvents(table.unpack({...}))
  end
  function ultraschall.EventManager_GetLastUpdateTime(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_GetLastUpdateTime(table.unpack({...}))
  end
  function ultraschall.EventManager_PauseEvent(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_PauseEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_ResumeEvent(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_ResumeEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_Start(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_Start(table.unpack({...}))
  end
  function ultraschall.EventManager_Stop(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_Stop(table.unpack({...}))
  end
  function ultraschall.EventManager_AddStartupEvent(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_AddStartupEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_RemoveStartupEvent2(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_RemoveStartupEvent2(table.unpack({...}))
  end
  function ultraschall.EventManager_RemoveStartupEvent(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_RemoveStartupEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_CountStartupEvents(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_CountStartupEvents(table.unpack({...}))
  end
  function ultraschall.EventManager_SetStartupEvent(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_SetStartupEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_GetPausedState2(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_GetPausedState2(table.unpack({...}))
  end
  function ultraschall.EventManager_GetPausedState(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_GetPausedState(table.unpack({...}))
  end
  function ultraschall.EventManager_GetEventIdentifier(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_GetEventIdentifier(table.unpack({...}))
  end
  function ultraschall.EventManager_GetLastCheckfunctionState(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_GetLastCheckfunctionState(table.unpack({...}))
  end
  function ultraschall.EventManager_GetRegisteredEventID(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_GetRegisteredEventID(table.unpack({...}))
  end
  function ultraschall.EventManager_GetLastCheckfunctionState2(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_GetLastCheckfunctionState2(table.unpack({...}))
  end
  function ultraschall.EventManager_DebugMode(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_DebugMode(table.unpack({...}))
  end
  function ultraschall.EventManager_DebugMode_UserSpace(...)
    ultraschall.LM(9)
    return ultraschall.EventManager_DebugMode_UserSpace(table.unpack({...}))
  end
  function ultraschall.ReadFullFile(...)
    ultraschall.LM(10)
    return ultraschall.ReadFullFile(table.unpack({...}))
  end
  function ultraschall.ReadValueFromFile(...)
    ultraschall.LM(10)
    return ultraschall.ReadValueFromFile(table.unpack({...}))
  end
  function ultraschall.ReadLinerangeFromFile(...)
    ultraschall.LM(10)
    return ultraschall.ReadLinerangeFromFile(table.unpack({...}))
  end
  function ultraschall.MakeCopyOfFile(...)
    ultraschall.LM(10)
    return ultraschall.MakeCopyOfFile(table.unpack({...}))
  end
  function ultraschall.MakeCopyOfFile_Binary(...)
    ultraschall.LM(10)
    return ultraschall.MakeCopyOfFile_Binary(table.unpack({...}))
  end
  function ultraschall.ReadBinaryFileUntilPattern(...)
    ultraschall.LM(10)
    return ultraschall.ReadBinaryFileUntilPattern(table.unpack({...}))
  end
  function ultraschall.ReadBinaryFileFromPattern(...)
    ultraschall.LM(10)
    return ultraschall.ReadBinaryFileFromPattern(table.unpack({...}))
  end
  function ultraschall.CountLinesInFile(...)
    ultraschall.LM(10)
    return ultraschall.CountLinesInFile(table.unpack({...}))
  end
  function ultraschall.ReadFileAsLines_Array(...)
    ultraschall.LM(10)
    return ultraschall.ReadFileAsLines_Array(table.unpack({...}))
  end
  function ultraschall.ReadBinaryFile_Offset(...)
    ultraschall.LM(10)
    return ultraschall.ReadBinaryFile_Offset(table.unpack({...}))
  end
  function ultraschall.GetLengthOfFile(...)
    ultraschall.LM(10)
    return ultraschall.GetLengthOfFile(table.unpack({...}))
  end
  function ultraschall.CountDirectoriesAndFilesInPath(...)
    ultraschall.LM(10)
    return ultraschall.CountDirectoriesAndFilesInPath(table.unpack({...}))
  end
  function ultraschall.GetAllFilenamesInPath(...)
    ultraschall.LM(10)
    return ultraschall.GetAllFilenamesInPath(table.unpack({...}))
  end
  function ultraschall.GetAllDirectoriesInPath(...)
    ultraschall.LM(10)
    return ultraschall.GetAllDirectoriesInPath(table.unpack({...}))
  end
  function ultraschall.CheckForValidFileFormats(...)
    ultraschall.LM(10)
    return ultraschall.CheckForValidFileFormats(table.unpack({...}))
  end
  function ultraschall.DirectoryExists(...)
    ultraschall.LM(10)
    return ultraschall.DirectoryExists(table.unpack({...}))
  end
  function ultraschall.OnlyFilesOfCertainType(...)
    ultraschall.LM(10)
    return ultraschall.OnlyFilesOfCertainType(table.unpack({...}))
  end
  function ultraschall.GetReaperWorkDir(...)
    ultraschall.LM(10)
    return ultraschall.GetReaperWorkDir(table.unpack({...}))
  end
  function ultraschall.DirectoryExists2(...)
    ultraschall.LM(10)
    return ultraschall.DirectoryExists2(table.unpack({...}))
  end
  function ultraschall.SetReaperWorkDir(...)
    ultraschall.LM(10)
    return ultraschall.SetReaperWorkDir(table.unpack({...}))
  end
  function ultraschall.GetPath(...)
    ultraschall.LM(10)
    return ultraschall.GetPath(table.unpack({...}))
  end
  function ultraschall.CreateValidTempFile(...)
    ultraschall.LM(10)
    return ultraschall.CreateValidTempFile(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile(...)
    ultraschall.LM(10)
    return ultraschall.WriteValueToFile(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile_Insert(...)
    ultraschall.LM(10)
    return ultraschall.WriteValueToFile_Insert(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile_Replace(...)
    ultraschall.LM(10)
    return ultraschall.WriteValueToFile_Replace(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile_InsertBinary(...)
    ultraschall.LM(10)
    return ultraschall.WriteValueToFile_InsertBinary(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile_ReplaceBinary(...)
    ultraschall.LM(10)
    return ultraschall.WriteValueToFile_ReplaceBinary(table.unpack({...}))
  end
  function ultraschall.GetAllRecursiveFilesAndSubdirectories(...)
    ultraschall.LM(10)
    return ultraschall.GetAllRecursiveFilesAndSubdirectories(table.unpack({...}))
  end
  function ultraschall.SaveSubtitles_SRT(...)
    ultraschall.LM(10)
    return ultraschall.SaveSubtitles_SRT(table.unpack({...}))
  end
  function ultraschall.ReadSubtitles_SRT(...)
    ultraschall.LM(10)
    return ultraschall.ReadSubtitles_SRT(table.unpack({...}))
  end
  function ultraschall.IsValidFXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.IsValidFXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetFXFromFXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.GetFXFromFXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.GetParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLearn_MediaItem(...)
    ultraschall.LM(11)
    return ultraschall.GetParmLearn_MediaItem(table.unpack({...}))
  end
  function ultraschall.GetParmLearn_MediaTrack(...)
    ultraschall.LM(11)
    return ultraschall.GetParmLearn_MediaTrack(table.unpack({...}))
  end
  function ultraschall.GetParmAlias_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.GetParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmAlias_MediaTrack(...)
    ultraschall.LM(11)
    return ultraschall.GetParmAlias_MediaTrack(table.unpack({...}))
  end
  function ultraschall.GetParmModulationChunk_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.GetParmModulationChunk_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.GetParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLFOLearn_MediaItem(...)
    ultraschall.LM(11)
    return ultraschall.GetParmLFOLearn_MediaItem(table.unpack({...}))
  end
  function ultraschall.GetParmLFOLearn_MediaTrack(...)
    ultraschall.LM(11)
    return ultraschall.GetParmLFOLearn_MediaTrack(table.unpack({...}))
  end
  function ultraschall.GetParmAudioControl_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.GetParmAudioControl_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLFO_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.GetParmLFO_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmMIDIPLink_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.GetParmMIDIPLink_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.ScanDXPlugins(...)
    ultraschall.LM(11)
    return ultraschall.ScanDXPlugins(table.unpack({...}))
  end
  function ultraschall.DeleteParmLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.DeleteParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.DeleteParmAlias_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.DeleteParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.DeleteParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.DeleteParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.SetParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetParmLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.SetParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetParmAlias_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.SetParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetFXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.SetFXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetFXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.GetFXStateChunk(table.unpack({...}))
  end
  function ultraschall.AddParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.AddParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.AddParmLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.AddParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.AddParmAlias_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.AddParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.CountParmAlias_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.CountParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.CountParmLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.CountParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.CountParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(11)
    return ultraschall.CountParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.ScanVSTPlugins(...)
    ultraschall.LM(11)
    return ultraschall.ScanVSTPlugins(table.unpack({...}))
  end
  function ultraschall.AutoDetectVSTPluginsFolder(...)
    ultraschall.LM(11)
    return ultraschall.AutoDetectVSTPluginsFolder(table.unpack({...}))
  end
  function ultraschall.SplitStringAtLineFeedToArray(...)
    ultraschall.LM(12)
    return ultraschall.SplitStringAtLineFeedToArray(table.unpack({...}))
  end
  function ultraschall.CountCharacterInString(...)
    ultraschall.LM(12)
    return ultraschall.CountCharacterInString(table.unpack({...}))
  end
  function ultraschall.IsValidMatchingPattern(...)
    ultraschall.LM(12)
    return ultraschall.IsValidMatchingPattern(table.unpack({...}))
  end
  function ultraschall.CSV2IndividualLinesAsArray(...)
    ultraschall.LM(12)
    return ultraschall.CSV2IndividualLinesAsArray(table.unpack({...}))
  end
  function ultraschall.RoundNumber(...)
    ultraschall.LM(12)
    return ultraschall.RoundNumber(table.unpack({...}))
  end
  function ultraschall.GetPartialString(...)
    ultraschall.LM(12)
    return ultraschall.GetPartialString(table.unpack({...}))
  end
  function ultraschall.Notes2CSV(...)
    ultraschall.LM(12)
    return ultraschall.Notes2CSV(table.unpack({...}))
  end
  function ultraschall.CSV2Line(...)
    ultraschall.LM(12)
    return ultraschall.CSV2Line(table.unpack({...}))
  end
  function ultraschall.IsItemInTrack(...)
    ultraschall.LM(12)
    return ultraschall.IsItemInTrack(table.unpack({...}))
  end
  function ultraschall.CheckActionCommandIDFormat(...)
    ultraschall.LM(12)
    return ultraschall.CheckActionCommandIDFormat(table.unpack({...}))
  end
  function ultraschall.CheckActionCommandIDFormat2(...)
    ultraschall.LM(12)
    return ultraschall.CheckActionCommandIDFormat2(table.unpack({...}))
  end
  function ultraschall.ToggleStateAction(...)
    ultraschall.LM(12)
    return ultraschall.ToggleStateAction(table.unpack({...}))
  end
  function ultraschall.RefreshToolbar_Action(...)
    ultraschall.LM(12)
    return ultraschall.RefreshToolbar_Action(table.unpack({...}))
  end
  function ultraschall.ToggleStateButton(...)
    ultraschall.LM(12)
    return ultraschall.ToggleStateButton(table.unpack({...}))
  end
  function ultraschall.SecondsToTime(...)
    ultraschall.LM(12)
    return ultraschall.SecondsToTime(table.unpack({...}))
  end
  function ultraschall.TimeToSeconds(...)
    ultraschall.LM(12)
    return ultraschall.TimeToSeconds(table.unpack({...}))
  end
  function ultraschall.SecondsToTimeString_hh_mm_ss_mss(...)
    ultraschall.LM(12)
    return ultraschall.SecondsToTimeString_hh_mm_ss_mss(table.unpack({...}))
  end
  function ultraschall.TimeStringToSeconds_hh_mm_ss_mss(...)
    ultraschall.LM(12)
    return ultraschall.TimeStringToSeconds_hh_mm_ss_mss(table.unpack({...}))
  end
  function ultraschall.CountPatternInString(...)
    ultraschall.LM(12)
    return ultraschall.CountPatternInString(table.unpack({...}))
  end
  function ultraschall.OpenURL(...)
    ultraschall.LM(12)
    return ultraschall.OpenURL(table.unpack({...}))
  end
  function ultraschall.CountEntriesInTable_Main(...)
    ultraschall.LM(12)
    return ultraschall.CountEntriesInTable_Main(table.unpack({...}))
  end
  function ultraschall.CompareArrays(...)
    ultraschall.LM(12)
    return ultraschall.CompareArrays(table.unpack({...}))
  end
  function ultraschall.GetOS(...)
    ultraschall.LM(12)
    return ultraschall.GetOS(table.unpack({...}))
  end
  function ultraschall.IsOS_Windows(...)
    ultraschall.LM(12)
    return ultraschall.IsOS_Windows(table.unpack({...}))
  end
  function ultraschall.IsOS_Mac(...)
    ultraschall.LM(12)
    return ultraschall.IsOS_Mac(table.unpack({...}))
  end
  function ultraschall.IsOS_Other(...)
    ultraschall.LM(12)
    return ultraschall.IsOS_Other(table.unpack({...}))
  end
  function ultraschall.GetReaperAppVersion(...)
    ultraschall.LM(12)
    return ultraschall.GetReaperAppVersion(table.unpack({...}))
  end
  function ultraschall.LimitFractionOfFloat(...)
    ultraschall.LM(12)
    return ultraschall.LimitFractionOfFloat(table.unpack({...}))
  end
  function ultraschall.GetAllEntriesFromTable(...)
    ultraschall.LM(12)
    return ultraschall.GetAllEntriesFromTable(table.unpack({...}))
  end
  function ultraschall.APIExists(...)
    ultraschall.LM(12)
    return ultraschall.APIExists(table.unpack({...}))
  end
  function ultraschall.IsValidGuid(...)
    ultraschall.LM(12)
    return ultraschall.IsValidGuid(table.unpack({...}))
  end
  function ultraschall.SetGuidExtState(...)
    ultraschall.LM(12)
    return ultraschall.SetGuidExtState(table.unpack({...}))
  end
  function ultraschall.SetBitfield(...)
    ultraschall.LM(12)
    return ultraschall.SetBitfield(table.unpack({...}))
  end
  function ultraschall.PreventCreatingUndoPoint(...)
    ultraschall.LM(12)
    return ultraschall.PreventCreatingUndoPoint(table.unpack({...}))
  end
  function ultraschall.SetIntConfigVar_Bitfield(...)
    ultraschall.LM(12)
    return ultraschall.SetIntConfigVar_Bitfield(table.unpack({...}))
  end
  function ultraschall.MakeCopyOfTable(...)
    ultraschall.LM(12)
    return ultraschall.MakeCopyOfTable(table.unpack({...}))
  end
  function ultraschall.ConvertStringToAscii_Array(...)
    ultraschall.LM(12)
    return ultraschall.ConvertStringToAscii_Array(table.unpack({...}))
  end
  function ultraschall.CompareStringWithAsciiValues(...)
    ultraschall.LM(12)
    return ultraschall.CompareStringWithAsciiValues(table.unpack({...}))
  end
  function ultraschall.ReturnsMinusOneInCaseOfError_Arzala(...)
    ultraschall.LM(12)
    return ultraschall.ReturnsMinusOneInCaseOfError_Arzala(table.unpack({...}))
  end
  function ultraschall.CountLinesInString(...)
    ultraschall.LM(12)
    return ultraschall.CountLinesInString(table.unpack({...}))
  end
  function ultraschall.ReturnTypeOfReaperObject(...)
    ultraschall.LM(12)
    return ultraschall.ReturnTypeOfReaperObject(table.unpack({...}))
  end
  function ultraschall.IsObjectValidReaperObject(...)
    ultraschall.LM(12)
    return ultraschall.IsObjectValidReaperObject(table.unpack({...}))
  end
  function ultraschall.KeepTableEntriesOfType(...)
    ultraschall.LM(12)
    return ultraschall.KeepTableEntriesOfType(table.unpack({...}))
  end
  function ultraschall.RemoveTableEntriesOfType(...)
    ultraschall.LM(12)
    return ultraschall.RemoveTableEntriesOfType(table.unpack({...}))
  end
  function ultraschall.IsItemInTrack3(...)
    ultraschall.LM(12)
    return ultraschall.IsItemInTrack3(table.unpack({...}))
  end
  function ultraschall.AddIntToChar(...)
    ultraschall.LM(12)
    return ultraschall.AddIntToChar(table.unpack({...}))
  end
  function ultraschall.MakeFunctionUndoable(...)
    ultraschall.LM(12)
    return ultraschall.MakeFunctionUndoable(table.unpack({...}))
  end
  function ultraschall.ReturnTableAsIndividualValues(...)
    ultraschall.LM(12)
    return ultraschall.ReturnTableAsIndividualValues(table.unpack({...}))
  end
  function ultraschall.type(...)
    ultraschall.LM(12)
    return ultraschall.type(table.unpack({...}))
  end
  function ultraschall.ConcatIntegerIndexedTables(...)
    ultraschall.LM(12)
    return ultraschall.ConcatIntegerIndexedTables(table.unpack({...}))
  end
  function ultraschall.ReverseTable(...)
    ultraschall.LM(12)
    return ultraschall.ReverseTable(table.unpack({...}))
  end
  function ultraschall.GetDuplicatesFromArrays(...)
    ultraschall.LM(12)
    return ultraschall.GetDuplicatesFromArrays(table.unpack({...}))
  end
  function ultraschall.GetScriptFilenameFromActionCommandID(...)
    ultraschall.LM(12)
    return ultraschall.GetScriptFilenameFromActionCommandID(table.unpack({...}))
  end
  function ultraschall.CombineBytesToInteger(...)
    ultraschall.LM(12)
    return ultraschall.CombineBytesToInteger(table.unpack({...}))
  end
  function ultraschall.SplitIntegerIntoBytes(...)
    ultraschall.LM(12)
    return ultraschall.SplitIntegerIntoBytes(table.unpack({...}))
  end
  function ultraschall.GetReaperScriptPath(...)
    ultraschall.LM(12)
    return ultraschall.GetReaperScriptPath(table.unpack({...}))
  end
  function ultraschall.GetReaperColorThemesPath(...)
    ultraschall.LM(12)
    return ultraschall.GetReaperColorThemesPath(table.unpack({...}))
  end
  function ultraschall.GetReaperJSFXPath(...)
    ultraschall.LM(12)
    return ultraschall.GetReaperJSFXPath(table.unpack({...}))
  end
  function ultraschall.GetReaperWebRCPath(...)
    ultraschall.LM(12)
    return ultraschall.GetReaperWebRCPath(table.unpack({...}))
  end
  function ultraschall.CycleTable(...)
    ultraschall.LM(12)
    return ultraschall.CycleTable(table.unpack({...}))
  end
  function ultraschall.SplitStringAtNULLBytes(...)
    ultraschall.LM(12)
    return ultraschall.SplitStringAtNULLBytes(table.unpack({...}))
  end
  function ultraschall.RunBackgroundHelperFeatures(...)
    ultraschall.LM(12)
    return ultraschall.RunBackgroundHelperFeatures(table.unpack({...}))
  end
  function ultraschall.Main_OnCommandByFilename(...)
    ultraschall.LM(12)
    return ultraschall.Main_OnCommandByFilename(table.unpack({...}))
  end
  function ultraschall.MIDI_OnCommandByFilename(...)
    ultraschall.LM(12)
    return ultraschall.MIDI_OnCommandByFilename(table.unpack({...}))
  end
  function ultraschall.GetScriptParameters(...)
    ultraschall.LM(12)
    return ultraschall.GetScriptParameters(table.unpack({...}))
  end
  function ultraschall.SetScriptParameters(...)
    ultraschall.LM(12)
    return ultraschall.SetScriptParameters(table.unpack({...}))
  end
  function ultraschall.GetScriptReturnvalues(...)
    ultraschall.LM(12)
    return ultraschall.GetScriptReturnvalues(table.unpack({...}))
  end
  function ultraschall.SetScriptReturnvalues(...)
    ultraschall.LM(12)
    return ultraschall.SetScriptReturnvalues(table.unpack({...}))
  end
  function ultraschall.GetScriptReturnvalues_Sender(...)
    ultraschall.LM(12)
    return ultraschall.GetScriptReturnvalues_Sender(table.unpack({...}))
  end
  function ultraschall.Base64_Encoder(...)
    ultraschall.LM(12)
    return ultraschall.Base64_Encoder(table.unpack({...}))
  end
  function ultraschall.Base64_Decoder(...)
    ultraschall.LM(12)
    return ultraschall.Base64_Decoder(table.unpack({...}))
  end
  function ultraschall.StateChunkLayouter(...)
    ultraschall.LM(12)
    return ultraschall.StateChunkLayouter(table.unpack({...}))
  end
  function ultraschall.ReverseEndianess_Byte(...)
    ultraschall.LM(12)
    return ultraschall.ReverseEndianess_Byte(table.unpack({...}))
  end
  function ultraschall.ConvertIntegerIntoString(...)
    ultraschall.LM(12)
    return ultraschall.ConvertIntegerIntoString(table.unpack({...}))
  end
  function ultraschall.ConvertIntegerToBits(...)
    ultraschall.LM(12)
    return ultraschall.ConvertIntegerToBits(table.unpack({...}))
  end
  function ultraschall.ConvertBitsToInteger(...)
    ultraschall.LM(12)
    return ultraschall.ConvertBitsToInteger(table.unpack({...}))
  end
  function ultraschall.GetSetIntConfigVar(...)
    ultraschall.LM(12)
    return ultraschall.GetSetIntConfigVar(table.unpack({...}))
  end
  function ultraschall.GetScriptIdentifier(...)
    ultraschall.LM(12)
    return ultraschall.GetScriptIdentifier(table.unpack({...}))
  end
  function ultraschall.ReplacePartOfString(...)
    ultraschall.LM(12)
    return ultraschall.ReplacePartOfString(table.unpack({...}))
  end
  function ultraschall.SearchStringInString(...)
    ultraschall.LM(12)
    return ultraschall.SearchStringInString(table.unpack({...}))
  end
  function ultraschall.MKVOL2DB(...)
    ultraschall.LM(12)
    return ultraschall.MKVOL2DB(table.unpack({...}))
  end
  function ultraschall.DB2MKVOL(...)
    ultraschall.LM(12)
    return ultraschall.DB2MKVOL(table.unpack({...}))
  end
  function ultraschall.ConvertIntegerIntoString2(...)
    ultraschall.LM(12)
    return ultraschall.ConvertIntegerIntoString2(table.unpack({...}))
  end
  function ultraschall.ConvertStringToIntegers(...)
    ultraschall.LM(12)
    return ultraschall.ConvertStringToIntegers(table.unpack({...}))
  end
  function ultraschall.SetScriptIdentifier_Description(...)
    ultraschall.LM(12)
    return ultraschall.SetScriptIdentifier_Description(table.unpack({...}))
  end
  function ultraschall.GetScriptIdentifier_Description(...)
    ultraschall.LM(12)
    return ultraschall.GetScriptIdentifier_Description(table.unpack({...}))
  end
  function ultraschall.SetScriptIdentifier_Title(...)
    ultraschall.LM(12)
    return ultraschall.SetScriptIdentifier_Title(table.unpack({...}))
  end
  function ultraschall.GetScriptIdentifier_Title(...)
    ultraschall.LM(12)
    return ultraschall.GetScriptIdentifier_Title(table.unpack({...}))
  end
  function ultraschall.ResetProgressBar(...)
    ultraschall.LM(12)
    return ultraschall.ResetProgressBar(table.unpack({...}))
  end
  function ultraschall.PrintProgressBar(...)
    ultraschall.LM(12)
    return ultraschall.PrintProgressBar(table.unpack({...}))
  end
  function ultraschall.StoreFunctionInExtState(...)
    ultraschall.LM(12)
    return ultraschall.StoreFunctionInExtState(table.unpack({...}))
  end
  function ultraschall.LoadFunctionFromExtState(...)
    ultraschall.LM(12)
    return ultraschall.LoadFunctionFromExtState(table.unpack({...}))
  end
  function ultraschall.ConvertHex2Ascii(...)
    ultraschall.LM(12)
    return ultraschall.ConvertHex2Ascii(table.unpack({...}))
  end
  function ultraschall.ConvertAscii2Hex(...)
    ultraschall.LM(12)
    return ultraschall.ConvertAscii2Hex(table.unpack({...}))
  end
  function ultraschall.get_action_context_MediaItemDiff(...)
    ultraschall.LM(12)
    return ultraschall.get_action_context_MediaItemDiff(table.unpack({...}))
  end
  function ultraschall.GetAllActions(...)
    ultraschall.LM(12)
    return ultraschall.GetAllActions(table.unpack({...}))
  end
  function ultraschall.IsWithinTimeRange(...)
    ultraschall.LM(12)
    return ultraschall.IsWithinTimeRange(table.unpack({...}))
  end
  function ultraschall.MediaExplorer_OnCommand(...)
    ultraschall.LM(12)
    return ultraschall.MediaExplorer_OnCommand(table.unpack({...}))
  end
  function ultraschall.UpdateMediaExplorer(...)
    ultraschall.LM(12)
    return ultraschall.UpdateMediaExplorer(table.unpack({...}))
  end
  function ultraschall.FindPatternsInString(...)
    ultraschall.LM(12)
    return ultraschall.FindPatternsInString(table.unpack({...}))
  end
  function ultraschall.RunLuaSourceCode(...)
    ultraschall.LM(12)
    return ultraschall.RunLuaSourceCode(table.unpack({...}))
  end
  function ultraschall.Main_OnCommand_LuaCode(...)
    ultraschall.LM(12)
    return ultraschall.Main_OnCommand_LuaCode(table.unpack({...}))
  end
  function ultraschall.ReplacePatternInString(...)
    ultraschall.LM(12)
    return ultraschall.ReplacePatternInString(table.unpack({...}))
  end
  function ultraschall.ConvertFunction_ToBase64String(...)
    ultraschall.LM(12)
    return ultraschall.ConvertFunction_ToBase64String(table.unpack({...}))
  end
  function ultraschall.ConvertFunction_FromBase64String(...)
    ultraschall.LM(12)
    return ultraschall.ConvertFunction_FromBase64String(table.unpack({...}))
  end
  function ultraschall.ConvertFunction_ToHexString(...)
    ultraschall.LM(12)
    return ultraschall.ConvertFunction_ToHexString(table.unpack({...}))
  end
  function ultraschall.ConvertFunction_FromHexString(...)
    ultraschall.LM(12)
    return ultraschall.ConvertFunction_FromHexString(table.unpack({...}))
  end
  function ultraschall.Localize_UseFile(...)
    ultraschall.LM(13)
    return ultraschall.Localize_UseFile(table.unpack({...}))
  end
  function ultraschall.Localize(...)
    ultraschall.LM(13)
    return ultraschall.Localize(table.unpack({...}))
  end
  function ultraschall.Localize_RefreshFile(...)
    ultraschall.LM(13)
    return ultraschall.Localize_RefreshFile(table.unpack({...}))
  end
  function ultraschall.AddNormalMarker(...)
    ultraschall.LM(14)
    return ultraschall.AddNormalMarker(table.unpack({...}))
  end
  function ultraschall.AddPodRangeRegion(...)
    ultraschall.LM(14)
    return ultraschall.AddPodRangeRegion(table.unpack({...}))
  end
  function ultraschall.GetMarkerByName(...)
    ultraschall.LM(14)
    return ultraschall.GetMarkerByName(table.unpack({...}))
  end
  function ultraschall.GetMarkerByName_Pattern(...)
    ultraschall.LM(14)
    return ultraschall.GetMarkerByName_Pattern(table.unpack({...}))
  end
  function ultraschall.GetMarkerAndRegionsByIndex(...)
    ultraschall.LM(14)
    return ultraschall.GetMarkerAndRegionsByIndex(table.unpack({...}))
  end
  function ultraschall.SetMarkerByIndex(...)
    ultraschall.LM(14)
    return ultraschall.SetMarkerByIndex(table.unpack({...}))
  end
  function ultraschall.AddEditMarker(...)
    ultraschall.LM(14)
    return ultraschall.AddEditMarker(table.unpack({...}))
  end
  function ultraschall.CountNormalMarkers(...)
    ultraschall.LM(14)
    return ultraschall.CountNormalMarkers(table.unpack({...}))
  end
  function ultraschall.CountEditMarkers(...)
    ultraschall.LM(14)
    return ultraschall.CountEditMarkers(table.unpack({...}))
  end
  function ultraschall.GetPodRangeRegion(...)
    ultraschall.LM(14)
    return ultraschall.GetPodRangeRegion(table.unpack({...}))
  end
  function ultraschall.EnumerateNormalMarkers(...)
    ultraschall.LM(14)
    return ultraschall.EnumerateNormalMarkers(table.unpack({...}))
  end
  function ultraschall.EnumerateEditMarkers(...)
    ultraschall.LM(14)
    return ultraschall.EnumerateEditMarkers(table.unpack({...}))
  end
  function ultraschall.GetAllEditMarkers(...)
    ultraschall.LM(14)
    return ultraschall.GetAllEditMarkers(table.unpack({...}))
  end
  function ultraschall.GetAllNormalMarkers(...)
    ultraschall.LM(14)
    return ultraschall.GetAllNormalMarkers(table.unpack({...}))
  end
  function ultraschall.GetAllMarkers(...)
    ultraschall.LM(14)
    return ultraschall.GetAllMarkers(table.unpack({...}))
  end
  function ultraschall.SetNormalMarker(...)
    ultraschall.LM(14)
    return ultraschall.SetNormalMarker(table.unpack({...}))
  end
  function ultraschall.SetEditMarker(...)
    ultraschall.LM(14)
    return ultraschall.SetEditMarker(table.unpack({...}))
  end
  function ultraschall.SetPodRangeRegion(...)
    ultraschall.LM(14)
    return ultraschall.SetPodRangeRegion(table.unpack({...}))
  end
  function ultraschall.DeletePodRangeRegion(...)
    ultraschall.LM(14)
    return ultraschall.DeletePodRangeRegion(table.unpack({...}))
  end
  function ultraschall.DeleteNormalMarker(...)
    ultraschall.LM(14)
    return ultraschall.DeleteNormalMarker(table.unpack({...}))
  end
  function ultraschall.DeleteEditMarker(...)
    ultraschall.LM(14)
    return ultraschall.DeleteEditMarker(table.unpack({...}))
  end
  function ultraschall.ExportEditMarkersToFile(...)
    ultraschall.LM(14)
    return ultraschall.ExportEditMarkersToFile(table.unpack({...}))
  end
  function ultraschall.ExportNormalMarkersToFile(...)
    ultraschall.LM(14)
    return ultraschall.ExportNormalMarkersToFile(table.unpack({...}))
  end
  function ultraschall.ImportEditFromFile(...)
    ultraschall.LM(14)
    return ultraschall.ImportEditFromFile(table.unpack({...}))
  end
  function ultraschall.ImportMarkersFromFile(...)
    ultraschall.LM(14)
    return ultraschall.ImportMarkersFromFile(table.unpack({...}))
  end
  function ultraschall.MarkerToEditMarker(...)
    ultraschall.LM(14)
    return ultraschall.MarkerToEditMarker(table.unpack({...}))
  end
  function ultraschall.EditToMarker(...)
    ultraschall.LM(14)
    return ultraschall.EditToMarker(table.unpack({...}))
  end
  function ultraschall.GetMarkerByScreenCoordinates(...)
    ultraschall.LM(14)
    return ultraschall.GetMarkerByScreenCoordinates(table.unpack({...}))
  end
  function ultraschall.GetMarkerByTime(...)
    ultraschall.LM(14)
    return ultraschall.GetMarkerByTime(table.unpack({...}))
  end
  function ultraschall.GetRegionByScreenCoordinates(...)
    ultraschall.LM(14)
    return ultraschall.GetRegionByScreenCoordinates(table.unpack({...}))
  end
  function ultraschall.GetRegionByTime(...)
    ultraschall.LM(14)
    return ultraschall.GetRegionByTime(table.unpack({...}))
  end
  function ultraschall.GetTimesignaturesByScreenCoordinates(...)
    ultraschall.LM(14)
    return ultraschall.GetTimesignaturesByScreenCoordinates(table.unpack({...}))
  end
  function ultraschall.GetTimeSignaturesByTime(...)
    ultraschall.LM(14)
    return ultraschall.GetTimeSignaturesByTime(table.unpack({...}))
  end
  function ultraschall.IsMarkerEdit(...)
    ultraschall.LM(14)
    return ultraschall.IsMarkerEdit(table.unpack({...}))
  end
  function ultraschall.IsMarkerNormal(...)
    ultraschall.LM(14)
    return ultraschall.IsMarkerNormal(table.unpack({...}))
  end
  function ultraschall.IsRegionPodrange(...)
    ultraschall.LM(14)
    return ultraschall.IsRegionPodrange(table.unpack({...}))
  end
  function ultraschall.IsRegionEditRegion(...)
    ultraschall.LM(14)
    return ultraschall.IsRegionEditRegion(table.unpack({...}))
  end
  function ultraschall.AddEditRegion(...)
    ultraschall.LM(14)
    return ultraschall.AddEditRegion(table.unpack({...}))
  end
  function ultraschall.SetEditRegion(...)
    ultraschall.LM(14)
    return ultraschall.SetEditRegion(table.unpack({...}))
  end
  function ultraschall.DeleteEditRegion(...)
    ultraschall.LM(14)
    return ultraschall.DeleteEditRegion(table.unpack({...}))
  end
  function ultraschall.EnumerateEditRegion(...)
    ultraschall.LM(14)
    return ultraschall.EnumerateEditRegion(table.unpack({...}))
  end
  function ultraschall.CountEditRegions(...)
    ultraschall.LM(14)
    return ultraschall.CountEditRegions(table.unpack({...}))
  end
  function ultraschall.GetAllMarkersBetween(...)
    ultraschall.LM(14)
    return ultraschall.GetAllMarkersBetween(table.unpack({...}))
  end
  function ultraschall.GetAllRegions(...)
    ultraschall.LM(14)
    return ultraschall.GetAllRegions(table.unpack({...}))
  end
  function ultraschall.GetAllRegionsBetween(...)
    ultraschall.LM(14)
    return ultraschall.GetAllRegionsBetween(table.unpack({...}))
  end
  function ultraschall.ParseMarkerString(...)
    ultraschall.LM(14)
    return ultraschall.ParseMarkerString(table.unpack({...}))
  end
  function ultraschall.RenumerateMarkers(...)
    ultraschall.LM(14)
    return ultraschall.RenumerateMarkers(table.unpack({...}))
  end
  function ultraschall.CountNormalMarkers_NumGap(...)
    ultraschall.LM(14)
    return ultraschall.CountNormalMarkers_NumGap(table.unpack({...}))
  end
  function ultraschall.IsMarkerAtPosition(...)
    ultraschall.LM(14)
    return ultraschall.IsMarkerAtPosition(table.unpack({...}))
  end
  function ultraschall.IsRegionAtPosition(...)
    ultraschall.LM(14)
    return ultraschall.IsRegionAtPosition(table.unpack({...}))
  end
  function ultraschall.CountMarkersAndRegions(...)
    ultraschall.LM(14)
    return ultraschall.CountMarkersAndRegions(table.unpack({...}))
  end
  function ultraschall.GetLastMarkerPosition(...)
    ultraschall.LM(14)
    return ultraschall.GetLastMarkerPosition(table.unpack({...}))
  end
  function ultraschall.GetLastRegion(...)
    ultraschall.LM(14)
    return ultraschall.GetLastRegion(table.unpack({...}))
  end
  function ultraschall.GetLastTimeSigMarkerPosition(...)
    ultraschall.LM(14)
    return ultraschall.GetLastTimeSigMarkerPosition(table.unpack({...}))
  end
  function ultraschall.GetMarkerUpdateCounter(...)
    ultraschall.LM(14)
    return ultraschall.GetMarkerUpdateCounter(table.unpack({...}))
  end
  function ultraschall.MoveTimeSigMarkersBy(...)
    ultraschall.LM(14)
    return ultraschall.MoveTimeSigMarkersBy(table.unpack({...}))
  end
  function ultraschall.GetAllTimeSigMarkers(...)
    ultraschall.LM(14)
    return ultraschall.GetAllTimeSigMarkers(table.unpack({...}))
  end
  function ultraschall.MoveMarkersBy(...)
    ultraschall.LM(14)
    return ultraschall.MoveMarkersBy(table.unpack({...}))
  end
  function ultraschall.MoveRegionsBy(...)
    ultraschall.LM(14)
    return ultraschall.MoveRegionsBy(table.unpack({...}))
  end
  function ultraschall.RippleCut_Regions(...)
    ultraschall.LM(14)
    return ultraschall.RippleCut_Regions(table.unpack({...}))
  end
  function ultraschall.GetAllCustomMarkers(...)
    ultraschall.LM(14)
    return ultraschall.GetAllCustomMarkers(table.unpack({...}))
  end
  function ultraschall.GetAllCustomRegions(...)
    ultraschall.LM(14)
    return ultraschall.GetAllCustomRegions(table.unpack({...}))
  end
  function ultraschall.CountAllCustomMarkers(...)
    ultraschall.LM(14)
    return ultraschall.CountAllCustomMarkers(table.unpack({...}))
  end
  function ultraschall.CountAllCustomRegions(...)
    ultraschall.LM(14)
    return ultraschall.CountAllCustomRegions(table.unpack({...}))
  end
  function ultraschall.EnumerateCustomMarkers(...)
    ultraschall.LM(14)
    return ultraschall.EnumerateCustomMarkers(table.unpack({...}))
  end
  function ultraschall.EnumerateCustomRegions(...)
    ultraschall.LM(14)
    return ultraschall.EnumerateCustomRegions(table.unpack({...}))
  end
  function ultraschall.DeleteCustomMarkers(...)
    ultraschall.LM(14)
    return ultraschall.DeleteCustomMarkers(table.unpack({...}))
  end
  function ultraschall.DeleteCustomRegions(...)
    ultraschall.LM(14)
    return ultraschall.DeleteCustomRegions(table.unpack({...}))
  end
  function ultraschall.AddCustomMarker(...)
    ultraschall.LM(14)
    return ultraschall.AddCustomMarker(table.unpack({...}))
  end
  function ultraschall.AddCustomRegion(...)
    ultraschall.LM(14)
    return ultraschall.AddCustomRegion(table.unpack({...}))
  end
  function ultraschall.SetCustomMarker(...)
    ultraschall.LM(14)
    return ultraschall.SetCustomMarker(table.unpack({...}))
  end
  function ultraschall.SetCustomRegion(...)
    ultraschall.LM(14)
    return ultraschall.SetCustomRegion(table.unpack({...}))
  end
  function ultraschall.GetNextFreeRegionIndex(...)
    ultraschall.LM(14)
    return ultraschall.GetNextFreeRegionIndex(table.unpack({...}))
  end
  function ultraschall.IsMarkerValidCustomMarker(...)
    ultraschall.LM(14)
    return ultraschall.IsMarkerValidCustomMarker(table.unpack({...}))
  end
  function ultraschall.IsRegionValidCustomRegion(...)
    ultraschall.LM(14)
    return ultraschall.IsRegionValidCustomRegion(table.unpack({...}))
  end
  function ultraschall.GetMarkerIDFromGuid(...)
    ultraschall.LM(14)
    return ultraschall.GetMarkerIDFromGuid(table.unpack({...}))
  end
  function ultraschall.GetGuidFromMarkerID(...)
    ultraschall.LM(14)
    return ultraschall.GetGuidFromMarkerID(table.unpack({...}))
  end
  function ultraschall.GetItemPosition(...)
    ultraschall.LM(15)
    return ultraschall.GetItemPosition(table.unpack({...}))
  end
  function ultraschall.GetItemLength(...)
    ultraschall.LM(15)
    return ultraschall.GetItemLength(table.unpack({...}))
  end
  function ultraschall.GetItemSnapOffset(...)
    ultraschall.LM(15)
    return ultraschall.GetItemSnapOffset(table.unpack({...}))
  end
  function ultraschall.GetItemLoop(...)
    ultraschall.LM(15)
    return ultraschall.GetItemLoop(table.unpack({...}))
  end
  function ultraschall.GetItemAllTakes(...)
    ultraschall.LM(15)
    return ultraschall.GetItemAllTakes(table.unpack({...}))
  end
  function ultraschall.GetItemFadeIn(...)
    ultraschall.LM(15)
    return ultraschall.GetItemFadeIn(table.unpack({...}))
  end
  function ultraschall.GetItemFadeOut(...)
    ultraschall.LM(15)
    return ultraschall.GetItemFadeOut(table.unpack({...}))
  end
  function ultraschall.GetItemMute(...)
    ultraschall.LM(15)
    return ultraschall.GetItemMute(table.unpack({...}))
  end
  function ultraschall.GetItemFadeFlag(...)
    ultraschall.LM(15)
    return ultraschall.GetItemFadeFlag(table.unpack({...}))
  end
  function ultraschall.GetItemLock(...)
    ultraschall.LM(15)
    return ultraschall.GetItemLock(table.unpack({...}))
  end
  function ultraschall.GetItemSelected(...)
    ultraschall.LM(15)
    return ultraschall.GetItemSelected(table.unpack({...}))
  end
  function ultraschall.GetItemGroup(...)
    ultraschall.LM(15)
    return ultraschall.GetItemGroup(table.unpack({...}))
  end
  function ultraschall.GetItemIGUID(...)
    ultraschall.LM(15)
    return ultraschall.GetItemIGUID(table.unpack({...}))
  end
  function ultraschall.GetItemIID(...)
    ultraschall.LM(15)
    return ultraschall.GetItemIID(table.unpack({...}))
  end
  function ultraschall.GetItemName(...)
    ultraschall.LM(15)
    return ultraschall.GetItemName(table.unpack({...}))
  end
  function ultraschall.GetItemVolPan(...)
    ultraschall.LM(15)
    return ultraschall.GetItemVolPan(table.unpack({...}))
  end
  function ultraschall.GetItemSampleOffset(...)
    ultraschall.LM(15)
    return ultraschall.GetItemSampleOffset(table.unpack({...}))
  end
  function ultraschall.GetItemPlayRate(...)
    ultraschall.LM(15)
    return ultraschall.GetItemPlayRate(table.unpack({...}))
  end
  function ultraschall.GetItemChanMode(...)
    ultraschall.LM(15)
    return ultraschall.GetItemChanMode(table.unpack({...}))
  end
  function ultraschall.GetItemGUID(...)
    ultraschall.LM(15)
    return ultraschall.GetItemGUID(table.unpack({...}))
  end
  function ultraschall.GetItemRecPass(...)
    ultraschall.LM(15)
    return ultraschall.GetItemRecPass(table.unpack({...}))
  end
  function ultraschall.GetItemBeat(...)
    ultraschall.LM(15)
    return ultraschall.GetItemBeat(table.unpack({...}))
  end
  function ultraschall.GetItemMixFlag(...)
    ultraschall.LM(15)
    return ultraschall.GetItemMixFlag(table.unpack({...}))
  end
  function ultraschall.GetItemUSTrackNumber_StateChunk(...)
    ultraschall.LM(15)
    return ultraschall.GetItemUSTrackNumber_StateChunk(table.unpack({...}))
  end
  function ultraschall.SetItemUSTrackNumber_StateChunk(...)
    ultraschall.LM(15)
    return ultraschall.SetItemUSTrackNumber_StateChunk(table.unpack({...}))
  end
  function ultraschall.SetItemPosition(...)
    ultraschall.LM(15)
    return ultraschall.SetItemPosition(table.unpack({...}))
  end
  function ultraschall.SetItemLength(...)
    ultraschall.LM(15)
    return ultraschall.SetItemLength(table.unpack({...}))
  end
  function ultraschall.GetItemStateChunk(...)
    ultraschall.LM(15)
    return ultraschall.GetItemStateChunk(table.unpack({...}))
  end
  function ultraschall.IsValidMediaItemStateChunk(...)
    ultraschall.LM(16)
    return ultraschall.IsValidMediaItemStateChunk(table.unpack({...}))
  end
  function ultraschall.CheckMediaItemArray(...)
    ultraschall.LM(16)
    return ultraschall.CheckMediaItemArray(table.unpack({...}))
  end
  function ultraschall.IsValidMediaItemArray(...)
    ultraschall.LM(16)
    return ultraschall.IsValidMediaItemArray(table.unpack({...}))
  end
  function ultraschall.CheckMediaItemStateChunkArray(...)
    ultraschall.LM(16)
    return ultraschall.CheckMediaItemStateChunkArray(table.unpack({...}))
  end
  function ultraschall.IsValidMediaItemStateChunkArray(...)
    ultraschall.LM(16)
    return ultraschall.IsValidMediaItemStateChunkArray(table.unpack({...}))
  end
  function ultraschall.GetMediaItemsAtPosition(...)
    ultraschall.LM(16)
    return ultraschall.GetMediaItemsAtPosition(table.unpack({...}))
  end
  function ultraschall.OnlyMediaItemsOfTracksInTrackstring(...)
    ultraschall.LM(16)
    return ultraschall.OnlyMediaItemsOfTracksInTrackstring(table.unpack({...}))
  end
  function ultraschall.SplitMediaItems_Position(...)
    ultraschall.LM(16)
    return ultraschall.SplitMediaItems_Position(table.unpack({...}))
  end
  function ultraschall.SplitItemsAtPositionFromArray(...)
    ultraschall.LM(16)
    return ultraschall.SplitItemsAtPositionFromArray(table.unpack({...}))
  end
  function ultraschall.DeleteMediaItem(...)
    ultraschall.LM(16)
    return ultraschall.DeleteMediaItem(table.unpack({...}))
  end
  function ultraschall.DeleteMediaItemsFromArray(...)
    ultraschall.LM(16)
    return ultraschall.DeleteMediaItemsFromArray(table.unpack({...}))
  end
  function ultraschall.DeleteMediaItems_Position(...)
    ultraschall.LM(16)
    return ultraschall.DeleteMediaItems_Position(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemsBetween(...)
    ultraschall.LM(16)
    return ultraschall.GetAllMediaItemsBetween(table.unpack({...}))
  end
  function ultraschall.MoveMediaItemsAfter_By(...)
    ultraschall.LM(16)
    return ultraschall.MoveMediaItemsAfter_By(table.unpack({...}))
  end
  function ultraschall.MoveMediaItemsBefore_By(...)
    ultraschall.LM(16)
    return ultraschall.MoveMediaItemsBefore_By(table.unpack({...}))
  end
  function ultraschall.MoveMediaItemsBetween_To(...)
    ultraschall.LM(16)
    return ultraschall.MoveMediaItemsBetween_To(table.unpack({...}))
  end
  function ultraschall.ChangeLengthOfMediaItems_FromArray(...)
    ultraschall.LM(16)
    return ultraschall.ChangeLengthOfMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(...)
    ultraschall.LM(16)
    return ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.ChangeOffsetOfMediaItems_FromArray(...)
    ultraschall.LM(16)
    return ultraschall.ChangeOffsetOfMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.ChangeDeltaOffsetOfMediaItems_FromArray(...)
    ultraschall.LM(16)
    return ultraschall.ChangeDeltaOffsetOfMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.SectionCut(...)
    ultraschall.LM(16)
    return ultraschall.SectionCut(table.unpack({...}))
  end
  function ultraschall.SectionCut_Inverse(...)
    ultraschall.LM(16)
    return ultraschall.SectionCut_Inverse(table.unpack({...}))
  end
  function ultraschall.RippleCut(...)
    ultraschall.LM(16)
    return ultraschall.RippleCut(table.unpack({...}))
  end
  function ultraschall.RippleCut_Reverse(...)
    ultraschall.LM(16)
    return ultraschall.RippleCut_Reverse(table.unpack({...}))
  end
  function ultraschall.InsertMediaItem_MediaItem(...)
    ultraschall.LM(16)
    return ultraschall.InsertMediaItem_MediaItem(table.unpack({...}))
  end
  function ultraschall.InsertMediaItem_MediaItemStateChunk(...)
    ultraschall.LM(16)
    return ultraschall.InsertMediaItem_MediaItemStateChunk(table.unpack({...}))
  end
  function ultraschall.InsertMediaItemArray(...)
    ultraschall.LM(16)
    return ultraschall.InsertMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetMediaItemStateChunksFromItems(...)
    ultraschall.LM(16)
    return ultraschall.GetMediaItemStateChunksFromItems(table.unpack({...}))
  end
  function ultraschall.RippleInsert(...)
    ultraschall.LM(16)
    return ultraschall.RippleInsert(table.unpack({...}))
  end
  function ultraschall.MoveMediaItems_FromArray(...)
    ultraschall.LM(16)
    return ultraschall.MoveMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.InsertMediaItemStateChunkArray(...)
    ultraschall.LM(16)
    return ultraschall.InsertMediaItemStateChunkArray(table.unpack({...}))
  end
  function ultraschall.OnlyMediaItemsOfTracksInTrackstring_StateChunk(...)
    ultraschall.LM(16)
    return ultraschall.OnlyMediaItemsOfTracksInTrackstring_StateChunk(table.unpack({...}))
  end
  function ultraschall.RippleInsert_MediaItemStateChunks(...)
    ultraschall.LM(16)
    return ultraschall.RippleInsert_MediaItemStateChunks(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemsFromTrack(...)
    ultraschall.LM(16)
    return ultraschall.GetAllMediaItemsFromTrack(table.unpack({...}))
  end
  function ultraschall.SetItemsLockState(...)
    ultraschall.LM(16)
    return ultraschall.SetItemsLockState(table.unpack({...}))
  end
  function ultraschall.AddLockStateToMediaItemStateChunk(...)
    ultraschall.LM(16)
    return ultraschall.AddLockStateToMediaItemStateChunk(table.unpack({...}))
  end
  function ultraschall.AddLockStateTo_MediaItemStateChunkArray(...)
    ultraschall.LM(16)
    return ultraschall.AddLockStateTo_MediaItemStateChunkArray(table.unpack({...}))
  end
  function ultraschall.ApplyStateChunkToItems(...)
    ultraschall.LM(16)
    return ultraschall.ApplyStateChunkToItems(table.unpack({...}))
  end
  function ultraschall.GetAllLockedItemsFromMediaItemArray(...)
    ultraschall.LM(16)
    return ultraschall.GetAllLockedItemsFromMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetMediaItemStateChunksFromMediaItemArray(...)
    ultraschall.LM(16)
    return ultraschall.GetMediaItemStateChunksFromMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetSelectedMediaItemsAtPosition(...)
    ultraschall.LM(16)
    return ultraschall.GetSelectedMediaItemsAtPosition(table.unpack({...}))
  end
  function ultraschall.GetSelectedMediaItemsBetween(...)
    ultraschall.LM(16)
    return ultraschall.GetSelectedMediaItemsBetween(table.unpack({...}))
  end
  function ultraschall.DeselectMediaItems_MediaItemArray(...)
    ultraschall.LM(16)
    return ultraschall.DeselectMediaItems_MediaItemArray(table.unpack({...}))
  end
  function ultraschall.SelectMediaItems_MediaItemArray(...)
    ultraschall.LM(16)
    return ultraschall.SelectMediaItems_MediaItemArray(table.unpack({...}))
  end
  function ultraschall.EnumerateMediaItemsInTrack(...)
    ultraschall.LM(16)
    return ultraschall.EnumerateMediaItemsInTrack(table.unpack({...}))
  end
  function ultraschall.GetMediaItemArrayLength(...)
    ultraschall.LM(16)
    return ultraschall.GetMediaItemArrayLength(table.unpack({...}))
  end
  function ultraschall.GetMediaItemStateChunkArrayLength(...)
    ultraschall.LM(16)
    return ultraschall.GetMediaItemStateChunkArrayLength(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemGUIDs(...)
    ultraschall.LM(16)
    return ultraschall.GetAllMediaItemGUIDs(table.unpack({...}))
  end
  function ultraschall.GetItemSpectralConfig(...)
    ultraschall.LM(16)
    return ultraschall.GetItemSpectralConfig(table.unpack({...}))
  end
  function ultraschall.SetItemSpectralConfig(...)
    ultraschall.LM(16)
    return ultraschall.SetItemSpectralConfig(table.unpack({...}))
  end
  function ultraschall.CountItemSpectralEdits(...)
    ultraschall.LM(16)
    return ultraschall.CountItemSpectralEdits(table.unpack({...}))
  end
  function ultraschall.GetItemSpectralEdit(...)
    ultraschall.LM(16)
    return ultraschall.GetItemSpectralEdit(table.unpack({...}))
  end
  function ultraschall.DeleteItemSpectralEdit(...)
    ultraschall.LM(16)
    return ultraschall.DeleteItemSpectralEdit(table.unpack({...}))
  end
  function ultraschall.SetItemSpectralVisibilityState(...)
    ultraschall.LM(16)
    return ultraschall.SetItemSpectralVisibilityState(table.unpack({...}))
  end
  function ultraschall.SetItemSpectralEdit(...)
    ultraschall.LM(16)
    return ultraschall.SetItemSpectralEdit(table.unpack({...}))
  end
  function ultraschall.GetItemSourceFile_Take(...)
    ultraschall.LM(16)
    return ultraschall.GetItemSourceFile_Take(table.unpack({...}))
  end
  function ultraschall.AddItemSpectralEdit(...)
    ultraschall.LM(16)
    return ultraschall.AddItemSpectralEdit(table.unpack({...}))
  end
  function ultraschall.GetItemSpectralVisibilityState(...)
    ultraschall.LM(16)
    return ultraschall.GetItemSpectralVisibilityState(table.unpack({...}))
  end
  function ultraschall.InsertImageFile(...)
    ultraschall.LM(16)
    return ultraschall.InsertImageFile(table.unpack({...}))
  end
  function ultraschall.GetAllSelectedMediaItems(...)
    ultraschall.LM(16)
    return ultraschall.GetAllSelectedMediaItems(table.unpack({...}))
  end
  function ultraschall.SetMediaItemsSelected_TimeSelection(...)
    ultraschall.LM(16)
    return ultraschall.SetMediaItemsSelected_TimeSelection(table.unpack({...}))
  end
  function ultraschall.GetParentTrack_MediaItem(...)
    ultraschall.LM(16)
    return ultraschall.GetParentTrack_MediaItem(table.unpack({...}))
  end
  function ultraschall.IsItemInTrack2(...)
    ultraschall.LM(16)
    return ultraschall.IsItemInTrack2(table.unpack({...}))
  end
  function ultraschall.IsItemInTimerange(...)
    ultraschall.LM(16)
    return ultraschall.IsItemInTimerange(table.unpack({...}))
  end
  function ultraschall.OnlyItemsInTracksAndTimerange(...)
    ultraschall.LM(16)
    return ultraschall.OnlyItemsInTracksAndTimerange(table.unpack({...}))
  end
  function ultraschall.ApplyActionToMediaItem(...)
    ultraschall.LM(16)
    return ultraschall.ApplyActionToMediaItem(table.unpack({...}))
  end
  function ultraschall.ApplyActionToMediaItemArray(...)
    ultraschall.LM(16)
    return ultraschall.ApplyActionToMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemsInTimeSelection(...)
    ultraschall.LM(16)
    return ultraschall.GetAllMediaItemsInTimeSelection(table.unpack({...}))
  end
  function ultraschall.NormalizeItems(...)
    ultraschall.LM(16)
    return ultraschall.NormalizeItems(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItems(...)
    ultraschall.LM(16)
    return ultraschall.GetAllMediaItems(table.unpack({...}))
  end
  function ultraschall.PreviewMediaItem(...)
    ultraschall.LM(16)
    return ultraschall.PreviewMediaItem(table.unpack({...}))
  end
  function ultraschall.StopAnyPreview(...)
    ultraschall.LM(16)
    return ultraschall.StopAnyPreview(table.unpack({...}))
  end
  function ultraschall.PreviewMediaFile(...)
    ultraschall.LM(16)
    return ultraschall.PreviewMediaFile(table.unpack({...}))
  end
  function ultraschall.GetMediaItemTake(...)
    ultraschall.LM(16)
    return ultraschall.GetMediaItemTake(table.unpack({...}))
  end
  function ultraschall.ApplyFunctionToMediaItemArray(...)
    ultraschall.LM(16)
    return ultraschall.ApplyFunctionToMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetGapsBetweenItems(...)
    ultraschall.LM(16)
    return ultraschall.GetGapsBetweenItems(table.unpack({...}))
  end
  function ultraschall.DeleteMediaItems_Position(...)
    ultraschall.LM(16)
    return ultraschall.DeleteMediaItems_Position(table.unpack({...}))
  end
  function ultraschall.ApplyActionToMediaItemArray2(...)
    ultraschall.LM(16)
    return ultraschall.ApplyActionToMediaItemArray2(table.unpack({...}))
  end
  function ultraschall.GetMediafileAttributes(...)
    ultraschall.LM(16)
    return ultraschall.GetMediafileAttributes(table.unpack({...}))
  end
  function ultraschall.InsertMediaItemFromFile(...)
    ultraschall.LM(16)
    return ultraschall.InsertMediaItemFromFile(table.unpack({...}))
  end
  function ultraschall.CopyMediaItemToDestinationTrack(...)
    ultraschall.LM(16)
    return ultraschall.CopyMediaItemToDestinationTrack(table.unpack({...}))
  end
  function ultraschall.IsSplitAtPosition(...)
    ultraschall.LM(16)
    return ultraschall.IsSplitAtPosition(table.unpack({...}))
  end
  function ultraschall.GetItem_Number(...)
    ultraschall.LM(16)
    return ultraschall.GetItem_Number(table.unpack({...}))
  end
  function ultraschall.GetItem_HighestRecCounter(...)
    ultraschall.LM(16)
    return ultraschall.GetItem_HighestRecCounter(table.unpack({...}))
  end
  function ultraschall.GetItem_ClickState(...)
    ultraschall.LM(16)
    return ultraschall.GetItem_ClickState(table.unpack({...}))
  end
  function ultraschall.DeleteProjExtState_Section(...)
    ultraschall.LM(17)
    return ultraschall.DeleteProjExtState_Section(table.unpack({...}))
  end
  function ultraschall.DeleteProjExtState_Key(...)
    ultraschall.LM(17)
    return ultraschall.DeleteProjExtState_Key(table.unpack({...}))
  end
  function ultraschall.GetProjExtState_AllKeyValues(...)
    ultraschall.LM(17)
    return ultraschall.GetProjExtState_AllKeyValues(table.unpack({...}))
  end
  function ultraschall.GetGuidExtState(...)
    ultraschall.LM(17)
    return ultraschall.GetGuidExtState(table.unpack({...}))
  end
  function ultraschall.SetMarkerExtState(...)
    ultraschall.LM(17)
    return ultraschall.SetMarkerExtState(table.unpack({...}))
  end
  function ultraschall.GetMarkerExtState(...)
    ultraschall.LM(17)
    return ultraschall.GetMarkerExtState(table.unpack({...}))
  end
  function ultraschall.ZoomVertical_MidiEditor(...)
    ultraschall.LM(18)
    return ultraschall.ZoomVertical_MidiEditor(table.unpack({...}))
  end
  function ultraschall.ZoomHorizontal_MidiEditor(...)
    ultraschall.LM(18)
    return ultraschall.ZoomHorizontal_MidiEditor(table.unpack({...}))
  end
  function ultraschall.OpenItemInMidiEditor(...)
    ultraschall.LM(18)
    return ultraschall.OpenItemInMidiEditor(table.unpack({...}))
  end
  function ultraschall.MIDI_SendMidiNote(...)
    ultraschall.LM(18)
    return ultraschall.MIDI_SendMidiNote(table.unpack({...}))
  end
  function ultraschall.MIDI_SendMidiCC(...)
    ultraschall.LM(18)
    return ultraschall.MIDI_SendMidiCC(table.unpack({...}))
  end
  function ultraschall.MIDI_SendMidiPC(...)
    ultraschall.LM(18)
    return ultraschall.MIDI_SendMidiPC(table.unpack({...}))
  end
  function ultraschall.MIDI_SendMidiPitch(...)
    ultraschall.LM(18)
    return ultraschall.MIDI_SendMidiPitch(table.unpack({...}))
  end
  function ultraschall.ToggleMute(...)
    ultraschall.LM(19)
    return ultraschall.ToggleMute(table.unpack({...}))
  end
  function ultraschall.ToggleMute_TrackObject(...)
    ultraschall.LM(19)
    return ultraschall.ToggleMute_TrackObject(table.unpack({...}))
  end
  function ultraschall.GetNextMuteState(...)
    ultraschall.LM(19)
    return ultraschall.GetNextMuteState(table.unpack({...}))
  end
  function ultraschall.GetPreviousMuteState(...)
    ultraschall.LM(19)
    return ultraschall.GetPreviousMuteState(table.unpack({...}))
  end
  function ultraschall.GetNextMuteState_TrackObject(...)
    ultraschall.LM(19)
    return ultraschall.GetNextMuteState_TrackObject(table.unpack({...}))
  end
  function ultraschall.GetPreviousMuteState_TrackObject(...)
    ultraschall.LM(19)
    return ultraschall.GetPreviousMuteState_TrackObject(table.unpack({...}))
  end
  function ultraschall.CountMuteEnvelopePoints(...)
    ultraschall.LM(19)
    return ultraschall.CountMuteEnvelopePoints(table.unpack({...}))
  end
  function ultraschall.DeleteMuteState(...)
    ultraschall.LM(19)
    return ultraschall.DeleteMuteState(table.unpack({...}))
  end
  function ultraschall.DeleteMuteState_TrackObject(...)
    ultraschall.LM(19)
    return ultraschall.DeleteMuteState_TrackObject(table.unpack({...}))
  end
  function ultraschall.IsMuteAtPosition(...)
    ultraschall.LM(19)
    return ultraschall.IsMuteAtPosition(table.unpack({...}))
  end
  function ultraschall.IsMuteAtPosition_TrackObject(...)
    ultraschall.LM(19)
    return ultraschall.IsMuteAtPosition_TrackObject(table.unpack({...}))
  end
  function ultraschall.ToggleScrollingDuringPlayback(...)
    ultraschall.LM(20)
    return ultraschall.ToggleScrollingDuringPlayback(table.unpack({...}))
  end
  function ultraschall.SetPlayCursor_WhenPlaying(...)
    ultraschall.LM(20)
    return ultraschall.SetPlayCursor_WhenPlaying(table.unpack({...}))
  end
  function ultraschall.SetPlayAndEditCursor_WhenPlaying(...)
    ultraschall.LM(20)
    return ultraschall.SetPlayAndEditCursor_WhenPlaying(table.unpack({...}))
  end
  function ultraschall.JumpForwardBy(...)
    ultraschall.LM(20)
    return ultraschall.JumpForwardBy(table.unpack({...}))
  end
  function ultraschall.JumpBackwardBy(...)
    ultraschall.LM(20)
    return ultraschall.JumpBackwardBy(table.unpack({...}))
  end
  function ultraschall.JumpForwardBy_Recording(...)
    ultraschall.LM(20)
    return ultraschall.JumpForwardBy_Recording(table.unpack({...}))
  end
  function ultraschall.JumpBackwardBy_Recording(...)
    ultraschall.LM(20)
    return ultraschall.JumpBackwardBy_Recording(table.unpack({...}))
  end
  function ultraschall.GetNextClosestItemEdge(...)
    ultraschall.LM(20)
    return ultraschall.GetNextClosestItemEdge(table.unpack({...}))
  end
  function ultraschall.GetPreviousClosestItemEdge(...)
    ultraschall.LM(20)
    return ultraschall.GetPreviousClosestItemEdge(table.unpack({...}))
  end
  function ultraschall.GetClosestNextMarker(...)
    ultraschall.LM(20)
    return ultraschall.GetClosestNextMarker(table.unpack({...}))
  end
  function ultraschall.GetClosestPreviousMarker(...)
    ultraschall.LM(20)
    return ultraschall.GetClosestPreviousMarker(table.unpack({...}))
  end
  function ultraschall.GetClosestNextRegionEdge(...)
    ultraschall.LM(20)
    return ultraschall.GetClosestNextRegionEdge(table.unpack({...}))
  end
  function ultraschall.GetClosestPreviousRegionEdge(...)
    ultraschall.LM(20)
    return ultraschall.GetClosestPreviousRegionEdge(table.unpack({...}))
  end
  function ultraschall.GetClosestGoToPoints(...)
    ultraschall.LM(20)
    return ultraschall.GetClosestGoToPoints(table.unpack({...}))
  end
  function ultraschall.CenterViewToCursor(...)
    ultraschall.LM(20)
    return ultraschall.CenterViewToCursor(table.unpack({...}))
  end
  function ultraschall.GetLastCursorPosition(...)
    ultraschall.LM(20)
    return ultraschall.GetLastCursorPosition(table.unpack({...}))
  end
  function ultraschall.GetLastPlayState(...)
    ultraschall.LM(20)
    return ultraschall.GetLastPlayState(table.unpack({...}))
  end
  function ultraschall.GetLastLoopState(...)
    ultraschall.LM(20)
    return ultraschall.GetLastLoopState(table.unpack({...}))
  end
  function ultraschall.GetLoopState(...)
    ultraschall.LM(20)
    return ultraschall.GetLoopState(table.unpack({...}))
  end
  function ultraschall.SetLoopState(...)
    ultraschall.LM(20)
    return ultraschall.SetLoopState(table.unpack({...}))
  end
  function ultraschall.Scrubbing_MoveCursor_GetToggleState(...)
    ultraschall.LM(20)
    return ultraschall.Scrubbing_MoveCursor_GetToggleState(table.unpack({...}))
  end
  function ultraschall.Scrubbing_MoveCursor_Toggle(...)
    ultraschall.LM(20)
    return ultraschall.Scrubbing_MoveCursor_Toggle(table.unpack({...}))
  end
  function ultraschall.GetProjectFilename(...)
    ultraschall.LM(21)
    return ultraschall.GetProjectFilename(table.unpack({...}))
  end
  function ultraschall.CheckForChangedProjectTabs(...)
    ultraschall.LM(21)
    return ultraschall.CheckForChangedProjectTabs(table.unpack({...}))
  end
  function ultraschall.IsValidProjectStateChunk(...)
    ultraschall.LM(21)
    return ultraschall.IsValidProjectStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProjectStateChunk(...)
    ultraschall.LM(21)
    return ultraschall.GetProjectStateChunk(table.unpack({...}))
  end
  function ultraschall.EnumProjects(...)
    ultraschall.LM(21)
    return ultraschall.EnumProjects(table.unpack({...}))
  end
  function ultraschall.GetProject_ReaperVersion(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_ReaperVersion(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderCFG(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderCFG(table.unpack({...}))
  end
  function ultraschall.GetProject_RippleState(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RippleState(table.unpack({...}))
  end
  function ultraschall.GetProject_GroupOverride(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_GroupOverride(table.unpack({...}))
  end
  function ultraschall.GetProject_AutoCrossFade(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_AutoCrossFade(table.unpack({...}))
  end
  function ultraschall.GetProject_EnvAttach(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_EnvAttach(table.unpack({...}))
  end
  function ultraschall.GetProject_MixerUIFlags(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MixerUIFlags(table.unpack({...}))
  end
  function ultraschall.GetProject_PeakGain(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_PeakGain(table.unpack({...}))
  end
  function ultraschall.GetProject_Feedback(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Feedback(table.unpack({...}))
  end
  function ultraschall.GetProject_PanLaw(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_PanLaw(table.unpack({...}))
  end
  function ultraschall.GetProject_ProjOffsets(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_ProjOffsets(table.unpack({...}))
  end
  function ultraschall.GetProject_MaxProjectLength(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MaxProjectLength(table.unpack({...}))
  end
  function ultraschall.GetProject_Grid(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Grid(table.unpack({...}))
  end
  function ultraschall.GetProject_Timemode(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Timemode(table.unpack({...}))
  end
  function ultraschall.GetProject_VideoConfig(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_VideoConfig(table.unpack({...}))
  end
  function ultraschall.GetProject_PanMode(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_PanMode(table.unpack({...}))
  end
  function ultraschall.GetProject_CursorPos(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_CursorPos(table.unpack({...}))
  end
  function ultraschall.GetProject_HorizontalZoom(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_HorizontalZoom(table.unpack({...}))
  end
  function ultraschall.GetProject_VerticalZoom(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_VerticalZoom(table.unpack({...}))
  end
  function ultraschall.GetProject_UseRecConfig(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_UseRecConfig(table.unpack({...}))
  end
  function ultraschall.GetProject_RecMode(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RecMode(table.unpack({...}))
  end
  function ultraschall.GetProject_SMPTESync(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_SMPTESync(table.unpack({...}))
  end
  function ultraschall.GetProject_Loop(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Loop(table.unpack({...}))
  end
  function ultraschall.GetProject_LoopGran(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_LoopGran(table.unpack({...}))
  end
  function ultraschall.GetProject_RecPath(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RecPath(table.unpack({...}))
  end
  function ultraschall.GetProject_RecordCFG(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RecordCFG(table.unpack({...}))
  end
  function ultraschall.GetProject_ApplyFXCFG(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_ApplyFXCFG(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderPattern(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderPattern(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderFreqNChans(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderFreqNChans(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderSpeed(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderSpeed(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderRange(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderRange(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderResample(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderResample(table.unpack({...}))
  end
  function ultraschall.GetProject_AddMediaToProjectAfterRender(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_AddMediaToProjectAfterRender(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderStems(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderStems(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderDitherState(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderDitherState(table.unpack({...}))
  end
  function ultraschall.GetProject_TimeBase(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_TimeBase(table.unpack({...}))
  end
  function ultraschall.GetProject_TempoTimeSignature(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_TempoTimeSignature(table.unpack({...}))
  end
  function ultraschall.GetProject_ItemMixBehavior(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_ItemMixBehavior(table.unpack({...}))
  end
  function ultraschall.GetProject_DefPitchMode(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_DefPitchMode(table.unpack({...}))
  end
  function ultraschall.GetProject_TakeLane(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_TakeLane(table.unpack({...}))
  end
  function ultraschall.GetProject_SampleRate(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_SampleRate(table.unpack({...}))
  end
  function ultraschall.GetProject_TrackMixingDepth(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_TrackMixingDepth(table.unpack({...}))
  end
  function ultraschall.GetProject_TrackStateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_NumberOfTracks(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_NumberOfTracks(table.unpack({...}))
  end
  function ultraschall.GetProject_Selection(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Selection(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderQueueDelay(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderQueueDelay(table.unpack({...}))
  end
  function ultraschall.GetProject_QRenderOriginalProject(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_QRenderOriginalProject(table.unpack({...}))
  end
  function ultraschall.GetProject_QRenderOutFiles(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_QRenderOutFiles(table.unpack({...}))
  end
  function ultraschall.SetProject_RippleState(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RippleState(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderQueueDelay(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderQueueDelay(table.unpack({...}))
  end
  function ultraschall.SetProject_Selection(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_Selection(table.unpack({...}))
  end
  function ultraschall.SetProject_GroupOverride(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_GroupOverride(table.unpack({...}))
  end
  function ultraschall.SetProject_AutoCrossFade(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_AutoCrossFade(table.unpack({...}))
  end
  function ultraschall.SetProject_EnvAttach(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_EnvAttach(table.unpack({...}))
  end
  function ultraschall.SetProject_MixerUIFlags(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MixerUIFlags(table.unpack({...}))
  end
  function ultraschall.SetProject_PeakGain(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_PeakGain(table.unpack({...}))
  end
  function ultraschall.SetProject_Feedback(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_Feedback(table.unpack({...}))
  end
  function ultraschall.SetProject_PanLaw(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_PanLaw(table.unpack({...}))
  end
  function ultraschall.SetProject_ProjOffsets(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_ProjOffsets(table.unpack({...}))
  end
  function ultraschall.SetProject_MaxProjectLength(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MaxProjectLength(table.unpack({...}))
  end
  function ultraschall.SetProject_Grid(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_Grid(table.unpack({...}))
  end
  function ultraschall.SetProject_Timemode(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_Timemode(table.unpack({...}))
  end
  function ultraschall.SetProject_VideoConfig(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_VideoConfig(table.unpack({...}))
  end
  function ultraschall.SetProject_PanMode(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_PanMode(table.unpack({...}))
  end
  function ultraschall.SetProject_CursorPos(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_CursorPos(table.unpack({...}))
  end
  function ultraschall.SetProject_HorizontalZoom(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_HorizontalZoom(table.unpack({...}))
  end
  function ultraschall.SetProject_VerticalZoom(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_VerticalZoom(table.unpack({...}))
  end
  function ultraschall.SetProject_UseRecConfig(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_UseRecConfig(table.unpack({...}))
  end
  function ultraschall.SetProject_RecMode(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RecMode(table.unpack({...}))
  end
  function ultraschall.SetProject_SMPTESync(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_SMPTESync(table.unpack({...}))
  end
  function ultraschall.SetProject_Loop(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_Loop(table.unpack({...}))
  end
  function ultraschall.SetProject_LoopGran(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_LoopGran(table.unpack({...}))
  end
  function ultraschall.SetProject_RecPath(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RecPath(table.unpack({...}))
  end
  function ultraschall.SetProject_RecordCFG(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RecordCFG(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderCFG(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderCFG(table.unpack({...}))
  end
  function ultraschall.SetProject_ApplyFXCFG(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_ApplyFXCFG(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderFilename(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderFilename(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderFreqNChans(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderFreqNChans(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderSpeed(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderSpeed(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderRange(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderRange(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderResample(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderResample(table.unpack({...}))
  end
  function ultraschall.SetProject_AddMediaToProjectAfterRender(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_AddMediaToProjectAfterRender(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderStems(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderStems(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderDitherState(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderDitherState(table.unpack({...}))
  end
  function ultraschall.SetProject_TimeBase(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_TimeBase(table.unpack({...}))
  end
  function ultraschall.SetProject_TempoTimeSignature(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_TempoTimeSignature(table.unpack({...}))
  end
  function ultraschall.SetProject_ItemMixBehavior(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_ItemMixBehavior(table.unpack({...}))
  end
  function ultraschall.SetProject_DefPitchMode(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_DefPitchMode(table.unpack({...}))
  end
  function ultraschall.SetProject_TakeLane(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_TakeLane(table.unpack({...}))
  end
  function ultraschall.SetProject_SampleRate(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_SampleRate(table.unpack({...}))
  end
  function ultraschall.SetProject_TrackMixingDepth(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_TrackMixingDepth(table.unpack({...}))
  end
  function ultraschall.GetProject_CountMarkersAndRegions(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_CountMarkersAndRegions(table.unpack({...}))
  end
  function ultraschall.GetProject_GetMarker(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_GetMarker(table.unpack({...}))
  end
  function ultraschall.GetProject_GetRegion(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_GetRegion(table.unpack({...}))
  end
  function ultraschall.GetProject_MarkersAndRegions(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MarkersAndRegions(table.unpack({...}))
  end
  function ultraschall.IsValidReaProject(...)
    ultraschall.LM(22)
    return ultraschall.IsValidReaProject(table.unpack({...}))
  end
  function ultraschall.NewProjectTab(...)
    ultraschall.LM(22)
    return ultraschall.NewProjectTab(table.unpack({...}))
  end
  function ultraschall.GetCurrentTimeLengthOfFrame(...)
    ultraschall.LM(22)
    return ultraschall.GetCurrentTimeLengthOfFrame(table.unpack({...}))
  end
  function ultraschall.GetLengthOfFrames(...)
    ultraschall.LM(22)
    return ultraschall.GetLengthOfFrames(table.unpack({...}))
  end
  function ultraschall.ConvertOldProjectToCurrentReaperVersion(...)
    ultraschall.LM(22)
    return ultraschall.ConvertOldProjectToCurrentReaperVersion(table.unpack({...}))
  end
  function ultraschall.GetProject_ProjectBay(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_ProjectBay(table.unpack({...}))
  end
  function ultraschall.GetProject_Metronome(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Metronome(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterPlayspeed(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterPlayspeed(table.unpack({...}))
  end
  function ultraschall.GetProject_TempoEnvEx(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_TempoEnvEx(table.unpack({...}))
  end
  function ultraschall.GetProject_Extensions(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Extensions(table.unpack({...}))
  end
  function ultraschall.GetProject_Lock(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Lock(table.unpack({...}))
  end
  function ultraschall.GetProject_GlobalAuto(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_GlobalAuto(table.unpack({...}))
  end
  function ultraschall.GetProject_Tempo(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Tempo(table.unpack({...}))
  end
  function ultraschall.GetProject_Playrate(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Playrate(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterAutomode(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterAutomode(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterSel(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterSel(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterFXByp(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterFXByp(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterMuteSolo(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterMuteSolo(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterNChans(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterNChans(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterTrackHeight(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterTrackHeight(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterTrackColor(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterTrackColor(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterTrackView(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterTrackView(table.unpack({...}))
  end
  function ultraschall.GetProject_CountMasterHWOuts(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_CountMasterHWOuts(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterHWOut(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterHWOut(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterVolume(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterVolume(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterPanMode(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterPanMode(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterWidth(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterWidth(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterGroupFlagsState(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterGroupFlagsState(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterGroupFlagsHighState(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterGroupFlagsHighState(table.unpack({...}))
  end
  function ultraschall.GetProject_GroupDisabled(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_GroupDisabled(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterHWVolEnvStateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterHWVolEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterFXListStateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterFXListStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterDualPanEnvStateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterDualPanEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterDualPanEnv2StateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterDualPanEnv2StateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterDualPanEnvLStateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterDualPanEnvLStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterDualPanEnvL2StateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterDualPanEnvL2StateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterVolEnvStateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterVolEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterVolEnv2StateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterVolEnv2StateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterVolEnv3StateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterVolEnv3StateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterHWPanEnvStateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterHWPanEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterPanMode_Ex(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_MasterPanMode_Ex(table.unpack({...}))
  end
  function ultraschall.GetProject_TempoEnv_ExStateChunk(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_TempoEnv_ExStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_Length(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Length(table.unpack({...}))
  end
  function ultraschall.CreateTemporaryFileOfProjectfile(...)
    ultraschall.LM(22)
    return ultraschall.CreateTemporaryFileOfProjectfile(table.unpack({...}))
  end
  function ultraschall.GetProject_Length(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_Length(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderPattern(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_RenderPattern(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderFilename(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_RenderFilename(table.unpack({...}))
  end
  function ultraschall.GetProject_GroupName(...)
    ultraschall.LM(22)
    return ultraschall.GetProject_GroupName(table.unpack({...}))
  end
  function ultraschall.SetProject_Lock(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_Lock(table.unpack({...}))
  end
  function ultraschall.SetProject_GlobalAuto(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_GlobalAuto(table.unpack({...}))
  end
  function ultraschall.SetProject_Tempo(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_Tempo(table.unpack({...}))
  end
  function ultraschall.SetProject_Playrate(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_Playrate(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterAutomode(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MasterAutomode(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterSel(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MasterSel(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterMuteSolo(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MasterMuteSolo(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterFXByp(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MasterFXByp(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterNChans(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MasterNChans(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterTrackHeight(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MasterTrackHeight(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterTrackColor(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MasterTrackColor(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterPanMode(...)
    ultraschall.LM(22)
    return ultraschall.SetProject_MasterPanMode(table.unpack({...}))
  end
  function ultraschall.AutoSearchReaMoteSlaves(...)
    ultraschall.LM(23)
    return ultraschall.AutoSearchReaMoteSlaves(table.unpack({...}))
  end
  function ultraschall.GetVerticalZoom(...)
    ultraschall.LM(24)
    return ultraschall.GetVerticalZoom(table.unpack({...}))
  end
  function ultraschall.SetVerticalZoom(...)
    ultraschall.LM(24)
    return ultraschall.SetVerticalZoom(table.unpack({...}))
  end
  function ultraschall.StoreArrangeviewSnapshot(...)
    ultraschall.LM(24)
    return ultraschall.StoreArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.IsValidArrangeviewSnapshot(...)
    ultraschall.LM(24)
    return ultraschall.IsValidArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.RetrieveArrangeviewSnapshot(...)
    ultraschall.LM(24)
    return ultraschall.RetrieveArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.RestoreArrangeviewSnapshot(...)
    ultraschall.LM(24)
    return ultraschall.RestoreArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.DeleteArrangeviewSnapshot(...)
    ultraschall.LM(24)
    return ultraschall.DeleteArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.SetIDEFontSize(...)
    ultraschall.LM(24)
    return ultraschall.SetIDEFontSize(table.unpack({...}))
  end
  function ultraschall.GetIDEFontSize(...)
    ultraschall.LM(24)
    return ultraschall.GetIDEFontSize(table.unpack({...}))
  end
  function ultraschall.GetPlayCursorWidth(...)
    ultraschall.LM(24)
    return ultraschall.GetPlayCursorWidth(table.unpack({...}))
  end
  function ultraschall.SetPlayCursorWidth(...)
    ultraschall.LM(24)
    return ultraschall.SetPlayCursorWidth(table.unpack({...}))
  end
  function ultraschall.GetScreenWidth(...)
    ultraschall.LM(24)
    return ultraschall.GetScreenWidth(table.unpack({...}))
  end
  function ultraschall.GetScreenHeight(...)
    ultraschall.LM(24)
    return ultraschall.GetScreenHeight(table.unpack({...}))
  end
  function ultraschall.ShowMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowMenu(table.unpack({...}))
  end
  function ultraschall.IsValidHWND(...)
    ultraschall.LM(24)
    return ultraschall.IsValidHWND(table.unpack({...}))
  end
  function ultraschall.BrowseForOpenFiles(...)
    ultraschall.LM(24)
    return ultraschall.BrowseForOpenFiles(table.unpack({...}))
  end
  function ultraschall.HasHWNDChildWindowNames(...)
    ultraschall.LM(24)
    return ultraschall.HasHWNDChildWindowNames(table.unpack({...}))
  end
  function ultraschall.CloseReaScriptConsole(...)
    ultraschall.LM(24)
    return ultraschall.CloseReaScriptConsole(table.unpack({...}))
  end
  function ultraschall.MB(...)
    ultraschall.LM(24)
    return ultraschall.MB(table.unpack({...}))
  end
  function ultraschall.GetTopmostHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetTopmostHWND(table.unpack({...}))
  end
  function ultraschall.GetReaperWindowAttributes(...)
    ultraschall.LM(24)
    return ultraschall.GetReaperWindowAttributes(table.unpack({...}))
  end
  function ultraschall.Windows_Find(...)
    ultraschall.LM(24)
    return ultraschall.Windows_Find(table.unpack({...}))
  end
  function ultraschall.GetAllReaScriptIDEWindows(...)
    ultraschall.LM(24)
    return ultraschall.GetAllReaScriptIDEWindows(table.unpack({...}))
  end
  function ultraschall.GetReaScriptConsoleWindow(...)
    ultraschall.LM(24)
    return ultraschall.GetReaScriptConsoleWindow(table.unpack({...}))
  end
  function ultraschall.GetHWND_ArrangeViewAndTimeLine(...)
    ultraschall.LM(24)
    return ultraschall.GetHWND_ArrangeViewAndTimeLine(table.unpack({...}))
  end
  function ultraschall.GetVerticalScroll(...)
    ultraschall.LM(24)
    return ultraschall.GetVerticalScroll(table.unpack({...}))
  end
  function ultraschall.SetVerticalScroll(...)
    ultraschall.LM(24)
    return ultraschall.SetVerticalScroll(table.unpack({...}))
  end
  function ultraschall.SetVerticalRelativeScroll(...)
    ultraschall.LM(24)
    return ultraschall.SetVerticalRelativeScroll(table.unpack({...}))
  end
  function ultraschall.GetUserInputs(...)
    ultraschall.LM(24)
    return ultraschall.GetUserInputs(table.unpack({...}))
  end
  function ultraschall.GetRenderToFileHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetRenderToFileHWND(table.unpack({...}))
  end
  function ultraschall.GetActionsHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetActionsHWND(table.unpack({...}))
  end
  function ultraschall.GetVideoHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetVideoHWND(table.unpack({...}))
  end
  function ultraschall.GetRenderQueueHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetRenderQueueHWND(table.unpack({...}))
  end
  function ultraschall.GetProjectSettingsHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetProjectSettingsHWND(table.unpack({...}))
  end
  function ultraschall.GetPreferencesHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetPreferencesHWND(table.unpack({...}))
  end
  function ultraschall.GetSaveLiveOutputToDiskHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetSaveLiveOutputToDiskHWND(table.unpack({...}))
  end
  function ultraschall.GetConsolidateTracksHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetConsolidateTracksHWND(table.unpack({...}))
  end
  function ultraschall.GetExportProjectMIDIHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetExportProjectMIDIHWND(table.unpack({...}))
  end
  function ultraschall.GetProjectDirectoryCleanupHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetProjectDirectoryCleanupHWND(table.unpack({...}))
  end
  function ultraschall.GetBatchFileItemConverterHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetBatchFileItemConverterHWND(table.unpack({...}))
  end
  function ultraschall.SetReaScriptConsole_FontStyle(...)
    ultraschall.LM(24)
    return ultraschall.SetReaScriptConsole_FontStyle(table.unpack({...}))
  end
  function ultraschall.MoveChildWithinParentHWND(...)
    ultraschall.LM(24)
    return ultraschall.MoveChildWithinParentHWND(table.unpack({...}))
  end
  function ultraschall.GetChildSizeWithinParentHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetChildSizeWithinParentHWND(table.unpack({...}))
  end
  function ultraschall.GetCheckboxState(...)
    ultraschall.LM(24)
    return ultraschall.GetCheckboxState(table.unpack({...}))
  end
  function ultraschall.SetCheckboxState(...)
    ultraschall.LM(24)
    return ultraschall.SetCheckboxState(table.unpack({...}))
  end
  function ultraschall.GetRenderingToFileHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetRenderingToFileHWND(table.unpack({...}))
  end
  function ultraschall.GetReaperWindowPosition_Left(...)
    ultraschall.LM(24)
    return ultraschall.GetReaperWindowPosition_Left(table.unpack({...}))
  end
  function ultraschall.GetReaperWindowPosition_Right(...)
    ultraschall.LM(24)
    return ultraschall.GetReaperWindowPosition_Right(table.unpack({...}))
  end
  function ultraschall.ConvertScreen2ClientXCoordinate_ReaperWindow(...)
    ultraschall.LM(24)
    return ultraschall.ConvertScreen2ClientXCoordinate_ReaperWindow(table.unpack({...}))
  end
  function ultraschall.ConvertClient2ScreenXCoordinate_ReaperWindow(...)
    ultraschall.LM(24)
    return ultraschall.ConvertClient2ScreenXCoordinate_ReaperWindow(table.unpack({...}))
  end
  function ultraschall.SetReaperWindowToSize(...)
    ultraschall.LM(24)
    return ultraschall.SetReaperWindowToSize(table.unpack({...}))
  end
  function ultraschall.ConvertYCoordsMac2Win(...)
    ultraschall.LM(24)
    return ultraschall.ConvertYCoordsMac2Win(table.unpack({...}))
  end
  function ultraschall.GetMediaExplorerHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetMediaExplorerHWND(table.unpack({...}))
  end
  function ultraschall.GetTimeByMouseXPosition(...)
    ultraschall.LM(24)
    return ultraschall.GetTimeByMouseXPosition(table.unpack({...}))
  end
  function ultraschall.ShowTrackInputMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowTrackInputMenu(table.unpack({...}))
  end
  function ultraschall.ShowTrackPanelMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowTrackPanelMenu(table.unpack({...}))
  end
  function ultraschall.ShowTrackAreaMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowTrackAreaMenu(table.unpack({...}))
  end
  function ultraschall.ShowTrackRoutingMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowTrackRoutingMenu(table.unpack({...}))
  end
  function ultraschall.ShowRulerMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowRulerMenu(table.unpack({...}))
  end
  function ultraschall.ShowMediaItemMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowMediaItemMenu(table.unpack({...}))
  end
  function ultraschall.ShowEnvelopeMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowEnvelopeMenu(table.unpack({...}))
  end
  function ultraschall.ShowEnvelopePointMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowEnvelopePointMenu(table.unpack({...}))
  end
  function ultraschall.ShowEnvelopePointMenu_AutomationItem(...)
    ultraschall.LM(24)
    return ultraschall.ShowEnvelopePointMenu_AutomationItem(table.unpack({...}))
  end
  function ultraschall.ShowAutomationItemMenu(...)
    ultraschall.LM(24)
    return ultraschall.ShowAutomationItemMenu(table.unpack({...}))
  end
  function ultraschall.GetSaveProjectAsHWND(...)
    ultraschall.LM(24)
    return ultraschall.GetSaveProjectAsHWND(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_FLAC(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_FLAC(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_AIFF(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_AIFF(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_AudioCD(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_AudioCD(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_MP3(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3MaxQuality(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_MP3MaxQuality(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3CBR(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_MP3CBR(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3VBR(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_MP3VBR(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3ABR(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_MP3ABR(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_OGG(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_OGG(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_OPUS(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_OPUS(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_GIF(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_GIF(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_LCF(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_LCF(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_WAV(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_WAV(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_WAVPACK(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_WAVPACK(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_WebMVideo(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_WebMVideo(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MKV_Video(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_MKV_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_AVI_Video(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_AVI_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_QTMOVMP4_Video(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_QTMOVMP4_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_DDP(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_DDP(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_GIF(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_GIF(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_LCF(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_LCF(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_WebMVideo(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_WebMVideo(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MKV_Video(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_MKV_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_QTMOVMP4_Video(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_QTMOVMP4_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_AVI_Video(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_AVI_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP4Mac_Video(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_MP4Mac_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MOVMac_Video(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_MOVMac_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_M4AMac(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderCFG_Settings_M4AMac(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP4MAC_Video(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_MP4MAC_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_M4AMAC(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_M4AMAC(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MOVMAC_Video(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_MOVMAC_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderTable_Project(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderTable_Project(table.unpack({...}))
  end
  function ultraschall.GetRenderTable_ProjectFile(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderTable_ProjectFile(table.unpack({...}))
  end
  function ultraschall.GetOutputFormat_RenderCfg(...)
    ultraschall.LM(25)
    return ultraschall.GetOutputFormat_RenderCfg(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_Opus(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_Opus(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_OGG(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_OGG(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_DDP(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_DDP(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_FLAC(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_FLAC(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_WAVPACK(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_WAVPACK(table.unpack({...}))
  end
  function ultraschall.IsValidRenderTable(...)
    ultraschall.LM(25)
    return ultraschall.IsValidRenderTable(table.unpack({...}))
  end
  function ultraschall.ApplyRenderTable_Project(...)
    ultraschall.LM(25)
    return ultraschall.ApplyRenderTable_Project(table.unpack({...}))
  end
  function ultraschall.ApplyRenderTable_ProjectFile(...)
    ultraschall.LM(25)
    return ultraschall.ApplyRenderTable_ProjectFile(table.unpack({...}))
  end
  function ultraschall.CreateNewRenderTable(...)
    ultraschall.LM(25)
    return ultraschall.CreateNewRenderTable(table.unpack({...}))
  end
  function ultraschall.GetRender_SaveCopyOfProject(...)
    ultraschall.LM(25)
    return ultraschall.GetRender_SaveCopyOfProject(table.unpack({...}))
  end
  function ultraschall.SetRender_SaveCopyOfProject(...)
    ultraschall.LM(25)
    return ultraschall.SetRender_SaveCopyOfProject(table.unpack({...}))
  end
  function ultraschall.SetRender_QueueDelay(...)
    ultraschall.LM(25)
    return ultraschall.SetRender_QueueDelay(table.unpack({...}))
  end
  function ultraschall.GetRender_QueueDelay(...)
    ultraschall.LM(25)
    return ultraschall.GetRender_QueueDelay(table.unpack({...}))
  end
  function ultraschall.SetRender_ProjectSampleRateForMix(...)
    ultraschall.LM(25)
    return ultraschall.SetRender_ProjectSampleRateForMix(table.unpack({...}))
  end
  function ultraschall.GetRender_ProjectSampleRateForMix(...)
    ultraschall.LM(25)
    return ultraschall.GetRender_ProjectSampleRateForMix(table.unpack({...}))
  end
  function ultraschall.SetRender_AutoIncrementFilename(...)
    ultraschall.LM(25)
    return ultraschall.SetRender_AutoIncrementFilename(table.unpack({...}))
  end
  function ultraschall.GetRender_AutoIncrementFilename(...)
    ultraschall.LM(25)
    return ultraschall.GetRender_AutoIncrementFilename(table.unpack({...}))
  end
  function ultraschall.GetRenderPreset_Names(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderPreset_Names(table.unpack({...}))
  end
  function ultraschall.GetRenderPreset_RenderTable(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderPreset_RenderTable(table.unpack({...}))
  end
  function ultraschall.DeleteRenderPreset_Bounds(...)
    ultraschall.LM(25)
    return ultraschall.DeleteRenderPreset_Bounds(table.unpack({...}))
  end
  function ultraschall.DeleteRenderPreset_FormatOptions(...)
    ultraschall.LM(25)
    return ultraschall.DeleteRenderPreset_FormatOptions(table.unpack({...}))
  end
  function ultraschall.AddRenderPreset(...)
    ultraschall.LM(25)
    return ultraschall.AddRenderPreset(table.unpack({...}))
  end
  function ultraschall.SetRenderPreset(...)
    ultraschall.LM(25)
    return ultraschall.SetRenderPreset(table.unpack({...}))
  end
  function ultraschall.RenderProject_RenderTable(...)
    ultraschall.LM(25)
    return ultraschall.RenderProject_RenderTable(table.unpack({...}))
  end
  function ultraschall.GetRenderQueuedProjects(...)
    ultraschall.LM(25)
    return ultraschall.GetRenderQueuedProjects(table.unpack({...}))
  end
  function ultraschall.AddProjectFileToRenderQueue(...)
    ultraschall.LM(25)
    return ultraschall.AddProjectFileToRenderQueue(table.unpack({...}))
  end
  function ultraschall.RenderProject_RenderQueue(...)
    ultraschall.LM(25)
    return ultraschall.RenderProject_RenderQueue(table.unpack({...}))
  end
  function ultraschall.RenderProject(...)
    ultraschall.LM(25)
    return ultraschall.RenderProject(table.unpack({...}))
  end
  function ultraschall.RenderProject_Regions(...)
    ultraschall.LM(25)
    return ultraschall.RenderProject_Regions(table.unpack({...}))
  end
  function ultraschall.AddSelectedItemsToRenderQueue(...)
    ultraschall.LM(25)
    return ultraschall.AddSelectedItemsToRenderQueue(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP3MaxQuality(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_MP3MaxQuality(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP3VBR(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_MP3VBR(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP3ABR(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_MP3ABR(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP3CBR(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_MP3CBR(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_WAV(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_WAV(table.unpack({...}))
  end
  function ultraschall.GetLastUsedRenderPatterns(...)
    ultraschall.LM(25)
    return ultraschall.GetLastUsedRenderPatterns(table.unpack({...}))
  end
  function ultraschall.GetLastRenderPaths(...)
    ultraschall.LM(25)
    return ultraschall.GetLastRenderPaths(table.unpack({...}))
  end
  function ultraschall.IsReaperRendering(...)
    ultraschall.LM(25)
    return ultraschall.IsReaperRendering(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_AIFF(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_AIFF(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_AudioCD(...)
    ultraschall.LM(25)
    return ultraschall.CreateRenderCFG_AudioCD(table.unpack({...}))
  end
  function ultraschall.IsValidTrackString(...)
    ultraschall.LM(26)
    return ultraschall.IsValidTrackString(table.unpack({...}))
  end
  function ultraschall.IsValidTrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.IsValidTrackStateChunk(table.unpack({...}))
  end
  function ultraschall.CreateTrackString(...)
    ultraschall.LM(26)
    return ultraschall.CreateTrackString(table.unpack({...}))
  end
  function ultraschall.CreateTrackString_SelectedTracks(...)
    ultraschall.LM(26)
    return ultraschall.CreateTrackString_SelectedTracks(table.unpack({...}))
  end
  function ultraschall.InsertTrack_TrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.InsertTrack_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveDuplicateTracksInTrackstring(...)
    ultraschall.LM(26)
    return ultraschall.RemoveDuplicateTracksInTrackstring(table.unpack({...}))
  end
  function ultraschall.IsTrackObjectTracknumber(...)
    ultraschall.LM(26)
    return ultraschall.IsTrackObjectTracknumber(table.unpack({...}))
  end
  function ultraschall.InverseTrackstring(...)
    ultraschall.LM(26)
    return ultraschall.InverseTrackstring(table.unpack({...}))
  end
  function ultraschall.CountItemsInTrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.CountItemsInTrackStateChunk(table.unpack({...}))
  end
  function ultraschall.GetItemStateChunkFromTrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.GetItemStateChunkFromTrackStateChunk(table.unpack({...}))
  end
  function ultraschall.AddMediaItemStateChunk_To_TrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.AddMediaItemStateChunk_To_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveMediaItem_TrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.RemoveMediaItem_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveMediaItemByIGUID_TrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.RemoveMediaItemByIGUID_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveMediaItemByGUID_TrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.RemoveMediaItemByGUID_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.OnlyTracksInBothTrackstrings(...)
    ultraschall.LM(26)
    return ultraschall.OnlyTracksInBothTrackstrings(table.unpack({...}))
  end
  function ultraschall.OnlyTracksInOneTrackstring(...)
    ultraschall.LM(26)
    return ultraschall.OnlyTracksInOneTrackstring(table.unpack({...}))
  end
  function ultraschall.SetMediaItemStateChunk_in_TrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.SetMediaItemStateChunk_in_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemsFromTrackStateChunk(...)
    ultraschall.LM(26)
    return ultraschall.GetAllMediaItemsFromTrackStateChunk(table.unpack({...}))
  end
  function ultraschall.CreateTrackString_AllTracks(...)
    ultraschall.LM(26)
    return ultraschall.CreateTrackString_AllTracks(table.unpack({...}))
  end
  function ultraschall.GetTrackLength(...)
    ultraschall.LM(26)
    return ultraschall.GetTrackLength(table.unpack({...}))
  end
  function ultraschall.GetLengthOfAllMediaItems_Track(...)
    ultraschall.LM(26)
    return ultraschall.GetLengthOfAllMediaItems_Track(table.unpack({...}))
  end
  function ultraschall.ApplyActionToTrack(...)
    ultraschall.LM(26)
    return ultraschall.ApplyActionToTrack(table.unpack({...}))
  end
  function ultraschall.InsertTrackAtIndex(...)
    ultraschall.LM(26)
    return ultraschall.InsertTrackAtIndex(table.unpack({...}))
  end
  function ultraschall.MoveTracks(...)
    ultraschall.LM(26)
    return ultraschall.MoveTracks(table.unpack({...}))
  end
  function ultraschall.CreateTrackString_ArmedTracks(...)
    ultraschall.LM(26)
    return ultraschall.CreateTrackString_ArmedTracks(table.unpack({...}))
  end
  function ultraschall.CreateTrackString_UnarmedTracks(...)
    ultraschall.LM(26)
    return ultraschall.CreateTrackString_UnarmedTracks(table.unpack({...}))
  end
  function ultraschall.CreateTrackStringByGUID(...)
    ultraschall.LM(26)
    return ultraschall.CreateTrackStringByGUID(table.unpack({...}))
  end
  function ultraschall.CreateTrackStringByTracknames(...)
    ultraschall.LM(26)
    return ultraschall.CreateTrackStringByTracknames(table.unpack({...}))
  end
  function ultraschall.CreateTrackStringByMediaTracks(...)
    ultraschall.LM(26)
    return ultraschall.CreateTrackStringByMediaTracks(table.unpack({...}))
  end
  function ultraschall.GetTracknumberByGuid(...)
    ultraschall.LM(26)
    return ultraschall.GetTracknumberByGuid(table.unpack({...}))
  end
  function ultraschall.DeleteTracks_TrackString(...)
    ultraschall.LM(26)
    return ultraschall.DeleteTracks_TrackString(table.unpack({...}))
  end
  function ultraschall.AnyTrackMute(...)
    ultraschall.LM(26)
    return ultraschall.AnyTrackMute(table.unpack({...}))
  end
  function ultraschall.AnyTrackRecarmed(...)
    ultraschall.LM(26)
    return ultraschall.AnyTrackRecarmed(table.unpack({...}))
  end
  function ultraschall.AnyTrackPhased(...)
    ultraschall.LM(26)
    return ultraschall.AnyTrackPhased(table.unpack({...}))
  end
  function ultraschall.AnyTrackRecMonitored(...)
    ultraschall.LM(26)
    return ultraschall.AnyTrackRecMonitored(table.unpack({...}))
  end
  function ultraschall.AnyTrackHiddenTCP(...)
    ultraschall.LM(26)
    return ultraschall.AnyTrackHiddenTCP(table.unpack({...}))
  end
  function ultraschall.AnyTrackHiddenMCP(...)
    ultraschall.LM(26)
    return ultraschall.AnyTrackHiddenMCP(table.unpack({...}))
  end
  function ultraschall.AnyTrackFreeItemPositioningMode(...)
    ultraschall.LM(26)
    return ultraschall.AnyTrackFreeItemPositioningMode(table.unpack({...}))
  end
  function ultraschall.AnyTrackFXBypass(...)
    ultraschall.LM(26)
    return ultraschall.AnyTrackFXBypass(table.unpack({...}))
  end
  function ultraschall.GetTrackHWOut(...)
    ultraschall.LM(27)
    return ultraschall.GetTrackHWOut(table.unpack({...}))
  end
  function ultraschall.GetTrackAUXSendReceives(...)
    ultraschall.LM(27)
    return ultraschall.GetTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.CountTrackHWOuts(...)
    ultraschall.LM(27)
    return ultraschall.CountTrackHWOuts(table.unpack({...}))
  end
  function ultraschall.CountTrackAUXSendReceives(...)
    ultraschall.LM(27)
    return ultraschall.CountTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.AddTrackHWOut(...)
    ultraschall.LM(27)
    return ultraschall.AddTrackHWOut(table.unpack({...}))
  end
  function ultraschall.AddTrackAUXSendReceives(...)
    ultraschall.LM(27)
    return ultraschall.AddTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.DeleteTrackHWOut(...)
    ultraschall.LM(27)
    return ultraschall.DeleteTrackHWOut(table.unpack({...}))
  end
  function ultraschall.DeleteTrackAUXSendReceives(...)
    ultraschall.LM(27)
    return ultraschall.DeleteTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.SetTrackHWOut(...)
    ultraschall.LM(27)
    return ultraschall.SetTrackHWOut(table.unpack({...}))
  end
  function ultraschall.SetTrackAUXSendReceives(...)
    ultraschall.LM(27)
    return ultraschall.SetTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.ClearRoutingMatrix(...)
    ultraschall.LM(27)
    return ultraschall.ClearRoutingMatrix(table.unpack({...}))
  end
  function ultraschall.ClearRoutingMatrix(...)
    ultraschall.LM(27)
    return ultraschall.ClearRoutingMatrix(table.unpack({...}))
  end
  function ultraschall.GetAllHWOuts(...)
    ultraschall.LM(27)
    return ultraschall.GetAllHWOuts(table.unpack({...}))
  end
  function ultraschall.ApplyAllHWOuts(...)
    ultraschall.LM(27)
    return ultraschall.ApplyAllHWOuts(table.unpack({...}))
  end
  function ultraschall.GetAllAUXSendReceives(...)
    ultraschall.LM(27)
    return ultraschall.GetAllAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.ApplyAllAUXSendReceives(...)
    ultraschall.LM(27)
    return ultraschall.ApplyAllAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.GetAllMainSendStates(...)
    ultraschall.LM(27)
    return ultraschall.GetAllMainSendStates(table.unpack({...}))
  end
  function ultraschall.ApplyAllMainSendStates(...)
    ultraschall.LM(27)
    return ultraschall.ApplyAllMainSendStates(table.unpack({...}))
  end
  function ultraschall.AreHWOutsTablesEqual(...)
    ultraschall.LM(27)
    return ultraschall.AreHWOutsTablesEqual(table.unpack({...}))
  end
  function ultraschall.AreMainSendsTablesEqual(...)
    ultraschall.LM(27)
    return ultraschall.AreMainSendsTablesEqual(table.unpack({...}))
  end
  function ultraschall.AreAUXSendReceivesTablesEqual(...)
    ultraschall.LM(27)
    return ultraschall.AreAUXSendReceivesTablesEqual(table.unpack({...}))
  end
  function ultraschall.GetTrackStateChunk_Tracknumber(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackStateChunk_Tracknumber(table.unpack({...}))
  end
  function ultraschall.GetTrackName(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackName(table.unpack({...}))
  end
  function ultraschall.GetTrackPeakColorState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackPeakColorState(table.unpack({...}))
  end
  function ultraschall.GetTrackBeatState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackBeatState(table.unpack({...}))
  end
  function ultraschall.GetTrackAutoRecArmState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackAutoRecArmState(table.unpack({...}))
  end
  function ultraschall.GetTrackMuteSoloState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackMuteSoloState(table.unpack({...}))
  end
  function ultraschall.GetTrackIPhaseState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackIPhaseState(table.unpack({...}))
  end
  function ultraschall.GetTrackIsBusState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackIsBusState(table.unpack({...}))
  end
  function ultraschall.GetTrackBusCompState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackBusCompState(table.unpack({...}))
  end
  function ultraschall.GetTrackShowInMixState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackShowInMixState(table.unpack({...}))
  end
  function ultraschall.GetTrackFreeModeState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackFreeModeState(table.unpack({...}))
  end
  function ultraschall.GetTrackRecState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackRecState(table.unpack({...}))
  end
  function ultraschall.GetTrackVUState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackVUState(table.unpack({...}))
  end
  function ultraschall.GetTrackHeightState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackHeightState(table.unpack({...}))
  end
  function ultraschall.GetTrackINQState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackINQState(table.unpack({...}))
  end
  function ultraschall.GetTrackNChansState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackNChansState(table.unpack({...}))
  end
  function ultraschall.GetTrackBypFXState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackBypFXState(table.unpack({...}))
  end
  function ultraschall.GetTrackPerfState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackPerfState(table.unpack({...}))
  end
  function ultraschall.GetTrackMIDIOutState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackMIDIOutState(table.unpack({...}))
  end
  function ultraschall.GetTrackMainSendState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackMainSendState(table.unpack({...}))
  end
  function ultraschall.GetTrackGroupFlagsState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackGroupFlagsState(table.unpack({...}))
  end
  function ultraschall.GetTrackGroupFlags_HighState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackGroupFlags_HighState(table.unpack({...}))
  end
  function ultraschall.GetTrackLockState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackLockState(table.unpack({...}))
  end
  function ultraschall.GetTrackLayoutNames(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackLayoutNames(table.unpack({...}))
  end
  function ultraschall.GetTrackAutomodeState(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackAutomodeState(table.unpack({...}))
  end
  function ultraschall.GetTrackIcon_Filename(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackIcon_Filename(table.unpack({...}))
  end
  function ultraschall.GetTrackRecCFG(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackRecCFG(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiInputChanMap(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackMidiInputChanMap(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiCTL(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackMidiCTL(table.unpack({...}))
  end
  function ultraschall.GetTrackWidth(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackWidth(table.unpack({...}))
  end
  function ultraschall.GetTrackPanMode(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackPanMode(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiColorMapFn(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackMidiColorMapFn(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiBankProgFn(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackMidiBankProgFn(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiTextStrFn(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackMidiTextStrFn(table.unpack({...}))
  end
  function ultraschall.GetTrackID(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackID(table.unpack({...}))
  end
  function ultraschall.GetTrackScore(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackScore(table.unpack({...}))
  end
  function ultraschall.GetTrackVolPan(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackVolPan(table.unpack({...}))
  end
  function ultraschall.SetTrackName(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackName(table.unpack({...}))
  end
  function ultraschall.SetTrackPeakColorState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackPeakColorState(table.unpack({...}))
  end
  function ultraschall.SetTrackBeatState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackBeatState(table.unpack({...}))
  end
  function ultraschall.SetTrackAutoRecArmState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackAutoRecArmState(table.unpack({...}))
  end
  function ultraschall.SetTrackMuteSoloState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackMuteSoloState(table.unpack({...}))
  end
  function ultraschall.SetTrackIPhaseState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackIPhaseState(table.unpack({...}))
  end
  function ultraschall.SetTrackIsBusState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackIsBusState(table.unpack({...}))
  end
  function ultraschall.SetTrackBusCompState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackBusCompState(table.unpack({...}))
  end
  function ultraschall.SetTrackShowInMixState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackShowInMixState(table.unpack({...}))
  end
  function ultraschall.SetTrackFreeModeState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackFreeModeState(table.unpack({...}))
  end
  function ultraschall.SetTrackRecState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackRecState(table.unpack({...}))
  end
  function ultraschall.SetTrackVUState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackVUState(table.unpack({...}))
  end
  function ultraschall.SetTrackHeightState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackHeightState(table.unpack({...}))
  end
  function ultraschall.SetTrackINQState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackINQState(table.unpack({...}))
  end
  function ultraschall.SetTrackNChansState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackNChansState(table.unpack({...}))
  end
  function ultraschall.SetTrackBypFXState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackBypFXState(table.unpack({...}))
  end
  function ultraschall.SetTrackPerfState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackPerfState(table.unpack({...}))
  end
  function ultraschall.SetTrackMIDIOutState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackMIDIOutState(table.unpack({...}))
  end
  function ultraschall.SetTrackMainSendState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackMainSendState(table.unpack({...}))
  end
  function ultraschall.SetTrackLockState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackLockState(table.unpack({...}))
  end
  function ultraschall.SetTrackLayoutNames(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackLayoutNames(table.unpack({...}))
  end
  function ultraschall.SetTrackAutomodeState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackAutomodeState(table.unpack({...}))
  end
  function ultraschall.SetTrackIcon_Filename(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackIcon_Filename(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiInputChanMap(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackMidiInputChanMap(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiCTL(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackMidiCTL(table.unpack({...}))
  end
  function ultraschall.SetTrackID(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackID(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiColorMapFn(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackMidiColorMapFn(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiBankProgFn(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackMidiBankProgFn(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiTextStrFn(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackMidiTextStrFn(table.unpack({...}))
  end
  function ultraschall.SetTrackPanMode(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackPanMode(table.unpack({...}))
  end
  function ultraschall.SetTrackWidth(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackWidth(table.unpack({...}))
  end
  function ultraschall.SetTrackScore(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackScore(table.unpack({...}))
  end
  function ultraschall.SetTrackVolPan(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackVolPan(table.unpack({...}))
  end
  function ultraschall.SetTrackRecCFG(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackRecCFG(table.unpack({...}))
  end
  function ultraschall.GetAllLockedTracks(...)
    ultraschall.LM(28)
    return ultraschall.GetAllLockedTracks(table.unpack({...}))
  end
  function ultraschall.GetAllSelectedTracks(...)
    ultraschall.LM(28)
    return ultraschall.GetAllSelectedTracks(table.unpack({...}))
  end
  function ultraschall.GetTrackSelection_TrackStateChunk(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackSelection_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.SetTrackSelection_TrackStateChunk(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackSelection_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.SetAllTracksSelected(...)
    ultraschall.LM(28)
    return ultraschall.SetAllTracksSelected(table.unpack({...}))
  end
  function ultraschall.SetTracksSelected(...)
    ultraschall.LM(28)
    return ultraschall.SetTracksSelected(table.unpack({...}))
  end
  function ultraschall.SetTracksToLocked(...)
    ultraschall.LM(28)
    return ultraschall.SetTracksToLocked(table.unpack({...}))
  end
  function ultraschall.SetTracksToUnlocked(...)
    ultraschall.LM(28)
    return ultraschall.SetTracksToUnlocked(table.unpack({...}))
  end
  function ultraschall.SetTrackStateChunk_Tracknumber(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackStateChunk_Tracknumber(table.unpack({...}))
  end
  function ultraschall.SetTrackGroupFlagsState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackGroupFlagsState(table.unpack({...}))
  end
  function ultraschall.SetTrackGroupFlags_HighState(...)
    ultraschall.LM(28)
    return ultraschall.SetTrackGroupFlags_HighState(table.unpack({...}))
  end
  function ultraschall.pause_follow_one_cycle(...)
    ultraschall.LM(29)
    return ultraschall.pause_follow_one_cycle(table.unpack({...}))
  end
  function ultraschall.IsTrackSoundboard(...)
    ultraschall.LM(29)
    return ultraschall.IsTrackSoundboard(table.unpack({...}))
  end
  function ultraschall.IsTrackStudioLink(...)
    ultraschall.LM(29)
    return ultraschall.IsTrackStudioLink(table.unpack({...}))
  end
  function ultraschall.IsTrackStudioLinkOnAir(...)
    ultraschall.LM(29)
    return ultraschall.IsTrackStudioLinkOnAir(table.unpack({...}))
  end
  function ultraschall.GetTypeOfTrack(...)
    ultraschall.LM(29)
    return ultraschall.GetTypeOfTrack(table.unpack({...}))
  end
  function ultraschall.GetAllAUXSendReceives2(...)
    ultraschall.LM(29)
    return ultraschall.GetAllAUXSendReceives2(table.unpack({...}))
  end
  function ultraschall.GetAllHWOuts2(...)
    ultraschall.LM(29)
    return ultraschall.GetAllHWOuts2(table.unpack({...}))
  end
  function ultraschall.GetAllMainSendStates2(...)
    ultraschall.LM(29)
    return ultraschall.GetAllMainSendStates2(table.unpack({...}))
  end
  function ultraschall.SetUSExternalState(...)
    ultraschall.LM(29)
    return ultraschall.SetUSExternalState(table.unpack({...}))
  end
  function ultraschall.GetUSExternalState(...)
    ultraschall.LM(29)
    return ultraschall.GetUSExternalState(table.unpack({...}))
  end
  function ultraschall.CountUSExternalState_sec(...)
    ultraschall.LM(29)
    return ultraschall.CountUSExternalState_sec(table.unpack({...}))
  end
  function ultraschall.CountUSExternalState_key(...)
    ultraschall.LM(29)
    return ultraschall.CountUSExternalState_key(table.unpack({...}))
  end
  function ultraschall.EnumerateUSExternalState_sec(...)
    ultraschall.LM(29)
    return ultraschall.EnumerateUSExternalState_sec(table.unpack({...}))
  end
  function ultraschall.EnumerateUSExternalState_key(...)
    ultraschall.LM(29)
    return ultraschall.EnumerateUSExternalState_key(table.unpack({...}))
  end
  function ultraschall.DeleteUSExternalState(...)
    ultraschall.LM(29)
    return ultraschall.DeleteUSExternalState(table.unpack({...}))
  end
  function ultraschall.SoundBoard_StopAllSounds(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_StopAllSounds(table.unpack({...}))
  end
  function ultraschall.SoundBoard_TogglePlayPause(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_TogglePlayPause(table.unpack({...}))
  end
  function ultraschall.SoundBoard_TogglePlayStop(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_TogglePlayStop(table.unpack({...}))
  end
  function ultraschall.SoundBoard_Play(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_Play(table.unpack({...}))
  end
  function ultraschall.SoundBoard_Stop(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_Stop(table.unpack({...}))
  end
  function ultraschall.SoundBoard_TogglePlay_FadeOutStop(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_TogglePlay_FadeOutStop(table.unpack({...}))
  end
  function ultraschall.SoundBoard_PlayList_CurrentIndex(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_PlayList_CurrentIndex(table.unpack({...}))
  end
  function ultraschall.SoundBoard_PlayList_SetIndex(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_PlayList_SetIndex(table.unpack({...}))
  end
  function ultraschall.SoundBoard_PlayList_Next(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_PlayList_Next(table.unpack({...}))
  end
  function ultraschall.SoundBoard_PlayList_Previous(...)
    ultraschall.LM(29)
    return ultraschall.SoundBoard_PlayList_Previous(table.unpack({...}))
  end
end
collectgarbage("collect")