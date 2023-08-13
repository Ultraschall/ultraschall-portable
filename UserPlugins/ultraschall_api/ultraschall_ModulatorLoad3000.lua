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

ultraschall.Modules_List={"VideoProcessor-Presets.RPL",
"ultraschall_functions_AudioManagement_Module.lua",
"ultraschall_functions_AutomationItems_Module.lua",
"ultraschall_functions_BatchConverter.lua",
"ultraschall_functions_Clipboard_Module.lua",
"ultraschall_functions_Color_Module.lua",
"ultraschall_functions_ConfigurationFiles_Module.lua",
"ultraschall_functions_ConfigurationSettings_Module.lua",
"ultraschall_functions_DeferManagement_Module.lua",
"ultraschall_functions_Envelope_Module.lua",
"ultraschall_functions_EventManager.lua",
"ultraschall_functions_FXManagement_Module.lua",
"ultraschall_functions_FileManagement_Module.lua",
"ultraschall_functions_HelperFunctions_Module.lua",
"ultraschall_functions_Imagefile_Module.lua",
"ultraschall_functions_Localize_Module.lua",
"ultraschall_functions_MIDIManagement_Module.lua",
"ultraschall_functions_Markers_Module.lua",
"ultraschall_functions_MediaItem_MediaItemStates_Module.lua",
"ultraschall_functions_MediaItem_Module.lua",
"ultraschall_functions_MetaData_Module.lua",
"ultraschall_functions_Muting_Module.lua",
"ultraschall_functions_Navigation_Module.lua",
"ultraschall_functions_ProjectManagement_Module.lua",
"ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua",
"ultraschall_functions_RazorEdit_Module.lua",
"ultraschall_functions_ReaMote_Module.lua",
"ultraschall_functions_ReaperUserInterface_Module.lua",
"ultraschall_functions_Render_Module.lua",
"ultraschall_functions_Themeing_Module.lua",
"ultraschall_functions_TrackManagement_Module.lua",
"ultraschall_functions_TrackManagement_Routing_Module.lua",
"ultraschall_functions_TrackManagement_TrackStates_Module.lua",
"ultraschall_functions_TrackManager_Module.lua",
"ultraschall_functions_Ultraschall_Module.lua",
"ultraschall_functions_WebInterface_Module.lua"}

if ultraschall.US_BetaFunctions==true then
  -- if beta-functions are available, load all functions from all modules
  local found_files=0
  local files_array2={}
  local filecount=0
  local file=""
  while file~=nil do
    local file=reaper.EnumerateFiles(ultraschall.Api_Path.."/Modules/",filecount)
    if file==nil then break end
    file=ultraschall.Api_Path.."/Modules/"..file
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
    ultraschall.LM(2)
    return ultraschall.GetHWInputs_Aliasnames(table.unpack({...}))
  end
  function ultraschall.GetHWOutputs_Aliasnames(...)
    ultraschall.LM(2)
    return ultraschall.GetHWOutputs_Aliasnames(table.unpack({...}))
  end
  function ultraschall.GetProject_AutomationItemStateChunk(...)
    ultraschall.LM(3)
    return ultraschall.GetProject_AutomationItemStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_CountAutomationItems(...)
    ultraschall.LM(3)
    return ultraschall.GetProject_CountAutomationItems(table.unpack({...}))
  end
  function ultraschall.AutomationItems_GetAll(...)
    ultraschall.LM(3)
    return ultraschall.AutomationItems_GetAll(table.unpack({...}))
  end
  function ultraschall.AutomationItem_Delete(...)
    ultraschall.LM(3)
    return ultraschall.AutomationItem_Delete(table.unpack({...}))
  end
  function ultraschall.AutomationItems_GetByTime(...)
    ultraschall.LM(3)
    return ultraschall.AutomationItems_GetByTime(table.unpack({...}))
  end
  function ultraschall.AutomationItem_Split(...)
    ultraschall.LM(3)
    return ultraschall.AutomationItem_Split(table.unpack({...}))
  end
  function ultraschall.AutomationItem_DeselectAllInTrack(...)
    ultraschall.LM(3)
    return ultraschall.AutomationItem_DeselectAllInTrack(table.unpack({...}))
  end
  function ultraschall.AutomationItem_GetSelectStates(...)
    ultraschall.LM(3)
    return ultraschall.AutomationItem_GetSelectStates(table.unpack({...}))
  end
  function ultraschall.AutomationItem_SelectMultiple(...)
    ultraschall.LM(3)
    return ultraschall.AutomationItem_SelectMultiple(table.unpack({...}))
  end
  function ultraschall.AutomationItem_GetAllSelectStates(...)
    ultraschall.LM(3)
    return ultraschall.AutomationItem_GetAllSelectStates(table.unpack({...}))
  end
  function ultraschall.AutomationItem_DeselectAllSelectStates(...)
    ultraschall.LM(3)
    return ultraschall.AutomationItem_DeselectAllSelectStates(table.unpack({...}))
  end
  function ultraschall.BatchConvertFiles(...)
    ultraschall.LM(4)
    return ultraschall.BatchConvertFiles(table.unpack({...}))
  end
  function ultraschall.GetBatchConverter_NotifyWhenFinished(...)
    ultraschall.LM(4)
    return ultraschall.GetBatchConverter_NotifyWhenFinished(table.unpack({...}))
  end
  function ultraschall.SetBatchConverter_NotifyWhenFinished(...)
    ultraschall.LM(4)
    return ultraschall.SetBatchConverter_NotifyWhenFinished(table.unpack({...}))
  end
  function ultraschall.GetMediaItemsFromClipboard(...)
    ultraschall.LM(5)
    return ultraschall.GetMediaItemsFromClipboard(table.unpack({...}))
  end
  function ultraschall.GetStringFromClipboard_SWS(...)
    ultraschall.LM(5)
    return ultraschall.GetStringFromClipboard_SWS(table.unpack({...}))
  end
  function ultraschall.PutMediaItemsToClipboard_MediaItemArray(...)
    ultraschall.LM(5)
    return ultraschall.PutMediaItemsToClipboard_MediaItemArray(table.unpack({...}))
  end
  function ultraschall.ConvertColor(...)
    ultraschall.LM(6)
    return ultraschall.ConvertColor(table.unpack({...}))
  end
  function ultraschall.ConvertColorReverse(...)
    ultraschall.LM(6)
    return ultraschall.ConvertColorReverse(table.unpack({...}))
  end
  function ultraschall.RGB2Grayscale(...)
    ultraschall.LM(6)
    return ultraschall.RGB2Grayscale(table.unpack({...}))
  end
  function ultraschall.ConvertColorToGFX(...)
    ultraschall.LM(6)
    return ultraschall.ConvertColorToGFX(table.unpack({...}))
  end
  function ultraschall.ConvertGFXToColor(...)
    ultraschall.LM(6)
    return ultraschall.ConvertGFXToColor(table.unpack({...}))
  end
  function ultraschall.CreateColorTable(...)
    ultraschall.LM(6)
    return ultraschall.CreateColorTable(table.unpack({...}))
  end
  function ultraschall.CreateSonicRainboomColorTable(...)
    ultraschall.LM(6)
    return ultraschall.CreateSonicRainboomColorTable(table.unpack({...}))
  end
  function ultraschall.IsValidColorTable(...)
    ultraschall.LM(6)
    return ultraschall.IsValidColorTable(table.unpack({...}))
  end
  function ultraschall.ApplyColorTableToTrackColors(...)
    ultraschall.LM(6)
    return ultraschall.ApplyColorTableToTrackColors(table.unpack({...}))
  end
  function ultraschall.ApplyColorTableToItemColors(...)
    ultraschall.LM(6)
    return ultraschall.ApplyColorTableToItemColors(table.unpack({...}))
  end
  function ultraschall.ChangeColorBrightness(...)
    ultraschall.LM(6)
    return ultraschall.ChangeColorBrightness(table.unpack({...}))
  end
  function ultraschall.ChangeColorContrast(...)
    ultraschall.LM(6)
    return ultraschall.ChangeColorContrast(table.unpack({...}))
  end
  function ultraschall.ChangeColorSaturation(...)
    ultraschall.LM(6)
    return ultraschall.ChangeColorSaturation(table.unpack({...}))
  end
  function ultraschall.ConvertColorToMac(...)
    ultraschall.LM(6)
    return ultraschall.ConvertColorToMac(table.unpack({...}))
  end
  function ultraschall.ConvertColorToWin(...)
    ultraschall.LM(6)
    return ultraschall.ConvertColorToWin(table.unpack({...}))
  end
  function ultraschall.ConvertColorFromMac(...)
    ultraschall.LM(6)
    return ultraschall.ConvertColorFromMac(table.unpack({...}))
  end
  function ultraschall.ConvertColorFromWin(...)
    ultraschall.LM(6)
    return ultraschall.ConvertColorFromWin(table.unpack({...}))
  end
  function ultraschall.SetIniFileExternalState(...)
    ultraschall.LM(7)
    return ultraschall.SetIniFileExternalState(table.unpack({...}))
  end
  function ultraschall.GetIniFileExternalState(...)
    ultraschall.LM(7)
    return ultraschall.GetIniFileExternalState(table.unpack({...}))
  end
  function ultraschall.CountIniFileExternalState_sec(...)
    ultraschall.LM(7)
    return ultraschall.CountIniFileExternalState_sec(table.unpack({...}))
  end
  function ultraschall.CountIniFileExternalState_key(...)
    ultraschall.LM(7)
    return ultraschall.CountIniFileExternalState_key(table.unpack({...}))
  end
  function ultraschall.EnumerateIniFileExternalState_sec(...)
    ultraschall.LM(7)
    return ultraschall.EnumerateIniFileExternalState_sec(table.unpack({...}))
  end
  function ultraschall.EnumerateIniFileExternalState_key(...)
    ultraschall.LM(7)
    return ultraschall.EnumerateIniFileExternalState_key(table.unpack({...}))
  end
  function ultraschall.CountSectionsByPattern(...)
    ultraschall.LM(7)
    return ultraschall.CountSectionsByPattern(table.unpack({...}))
  end
  function ultraschall.CountKeysByPattern(...)
    ultraschall.LM(7)
    return ultraschall.CountKeysByPattern(table.unpack({...}))
  end
  function ultraschall.CountValuesByPattern(...)
    ultraschall.LM(7)
    return ultraschall.CountValuesByPattern(table.unpack({...}))
  end
  function ultraschall.EnumerateSectionsByPattern(...)
    ultraschall.LM(7)
    return ultraschall.EnumerateSectionsByPattern(table.unpack({...}))
  end
  function ultraschall.EnumerateKeysByPattern(...)
    ultraschall.LM(7)
    return ultraschall.EnumerateKeysByPattern(table.unpack({...}))
  end
  function ultraschall.EnumerateValuesByPattern(...)
    ultraschall.LM(7)
    return ultraschall.EnumerateValuesByPattern(table.unpack({...}))
  end
  function ultraschall.GetKBIniFilepath(...)
    ultraschall.LM(7)
    return ultraschall.GetKBIniFilepath(table.unpack({...}))
  end
  function ultraschall.CountKBIniActions(...)
    ultraschall.LM(7)
    return ultraschall.CountKBIniActions(table.unpack({...}))
  end
  function ultraschall.CountKBIniScripts(...)
    ultraschall.LM(7)
    return ultraschall.CountKBIniScripts(table.unpack({...}))
  end
  function ultraschall.CountKBIniKeys(...)
    ultraschall.LM(7)
    return ultraschall.CountKBIniKeys(table.unpack({...}))
  end
  function ultraschall.GetKBIniActions(...)
    ultraschall.LM(7)
    return ultraschall.GetKBIniActions(table.unpack({...}))
  end
  function ultraschall.GetKBIniScripts(...)
    ultraschall.LM(7)
    return ultraschall.GetKBIniScripts(table.unpack({...}))
  end
  function ultraschall.GetKBIniKeys(...)
    ultraschall.LM(7)
    return ultraschall.GetKBIniKeys(table.unpack({...}))
  end
  function ultraschall.GetKBIniActionsID_ByActionCommandID(...)
    ultraschall.LM(7)
    return ultraschall.GetKBIniActionsID_ByActionCommandID(table.unpack({...}))
  end
  function ultraschall.GetKBIniScripts_ByActionCommandID(...)
    ultraschall.LM(7)
    return ultraschall.GetKBIniScripts_ByActionCommandID(table.unpack({...}))
  end
  function ultraschall.GetKBIniKeys_ByActionCommandID(...)
    ultraschall.LM(7)
    return ultraschall.GetKBIniKeys_ByActionCommandID(table.unpack({...}))
  end
  function ultraschall.SetKBIniActions(...)
    ultraschall.LM(7)
    return ultraschall.SetKBIniActions(table.unpack({...}))
  end
  function ultraschall.SetKBIniScripts(...)
    ultraschall.LM(7)
    return ultraschall.SetKBIniScripts(table.unpack({...}))
  end
  function ultraschall.SetKBIniKeys(...)
    ultraschall.LM(7)
    return ultraschall.SetKBIniKeys(table.unpack({...}))
  end
  function ultraschall.DeleteKBIniActions(...)
    ultraschall.LM(7)
    return ultraschall.DeleteKBIniActions(table.unpack({...}))
  end
  function ultraschall.DeleteKBIniScripts(...)
    ultraschall.LM(7)
    return ultraschall.DeleteKBIniScripts(table.unpack({...}))
  end
  function ultraschall.DeleteKBIniKeys(...)
    ultraschall.LM(7)
    return ultraschall.DeleteKBIniKeys(table.unpack({...}))
  end
  function ultraschall.GetIniFileValue(...)
    ultraschall.LM(7)
    return ultraschall.GetIniFileValue(table.unpack({...}))
  end
  function ultraschall.SetIniFileValue(...)
    ultraschall.LM(7)
    return ultraschall.SetIniFileValue(table.unpack({...}))
  end
  function ultraschall.QueryKeyboardShortcutByKeyID(...)
    ultraschall.LM(7)
    return ultraschall.QueryKeyboardShortcutByKeyID(table.unpack({...}))
  end
  function ultraschall.CharacterCodes_ReverseLookup(...)
    ultraschall.LM(7)
    return ultraschall.CharacterCodes_ReverseLookup(table.unpack({...}))
  end
  function ultraschall.CharacterCodes_ReverseLookup_KBIni(...)
    ultraschall.LM(7)
    return ultraschall.CharacterCodes_ReverseLookup_KBIni(table.unpack({...}))
  end
  function ultraschall.KBIniGetAllShortcuts(...)
    ultraschall.LM(7)
    return ultraschall.KBIniGetAllShortcuts(table.unpack({...}))
  end
  function ultraschall.GetActionCommandIDByFilename(...)
    ultraschall.LM(7)
    return ultraschall.GetActionCommandIDByFilename(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAcidImport(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAcidImport(table.unpack({...}))
  end
  function ultraschall.GetSetConfigActionMenu(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigActionMenu(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAdjRecLat(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAdjRecLat(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAdjRecManLat(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAdjRecManLat(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAfxCfg(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAfxCfg(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAllStereoPairs(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAllStereoPairs(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAlwaysAllowKB(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAlwaysAllowKB(table.unpack({...}))
  end
  function ultraschall.GetSetConfigApplyFXTail(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigApplyFXTail(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAdjRecManLatIn(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAdjRecManLatIn(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAudioPrShift(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAudioPrShift(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAudioCloseStop(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAudioCloseStop(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAudioThreadPr(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAudioThreadPr(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAudioCloseTrackWnds(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAudioCloseTrackWnds(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAutoMute(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAutoMute(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAutoMuteFlags(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAutoMuteFlags(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAutoSaveInt(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAutoSaveInt(table.unpack({...}))
  end
  function ultraschall.GetSetConfigAutoSaveMode(...)
    ultraschall.LM(8)
    return ultraschall.GetSetConfigAutoSaveMode(table.unpack({...}))
  end
  function ultraschall.GetStartNewFileRecSizeState(...)
    ultraschall.LM(8)
    return ultraschall.GetStartNewFileRecSizeState(table.unpack({...}))
  end
  function ultraschall.SetStartNewFileRecSizeState(...)
    ultraschall.LM(8)
    return ultraschall.SetStartNewFileRecSizeState(table.unpack({...}))
  end
  function ultraschall.GetDeferRunState(...)
    ultraschall.LM(9)
    return ultraschall.GetDeferRunState(table.unpack({...}))
  end
  function ultraschall.StopDeferCycle(...)
    ultraschall.LM(9)
    return ultraschall.StopDeferCycle(table.unpack({...}))
  end
  function ultraschall.Defer(...)
    ultraschall.LM(9)
    return ultraschall.Defer(table.unpack({...}))
  end
  function ultraschall.SetDeferCycleSettings(...)
    ultraschall.LM(9)
    return ultraschall.SetDeferCycleSettings(table.unpack({...}))
  end
  function ultraschall.GetDeferCycleSettings(...)
    ultraschall.LM(9)
    return ultraschall.GetDeferCycleSettings(table.unpack({...}))
  end
  function ultraschall.IsValidEnvStateChunk(...)
    ultraschall.LM(10)
    return ultraschall.IsValidEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.MoveTrackEnvelopePointsBy(...)
    ultraschall.LM(10)
    return ultraschall.MoveTrackEnvelopePointsBy(table.unpack({...}))
  end
  function ultraschall.GetEnvelopePoint(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopePoint(table.unpack({...}))
  end
  function ultraschall.GetClosestEnvelopePointIDX_ByTime(...)
    ultraschall.LM(10)
    return ultraschall.GetClosestEnvelopePointIDX_ByTime(table.unpack({...}))
  end
  function ultraschall.GetEnvelopePointIDX_Between(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopePointIDX_Between(table.unpack({...}))
  end
  function ultraschall.CheckEnvelopePointObject(...)
    ultraschall.LM(10)
    return ultraschall.CheckEnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.IsValidEnvelopePointObject(...)
    ultraschall.LM(10)
    return ultraschall.IsValidEnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.SetEnvelopePoints_EnvelopePointObject(...)
    ultraschall.LM(10)
    return ultraschall.SetEnvelopePoints_EnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.SetEnvelopePoints_EnvelopePointArray(...)
    ultraschall.LM(10)
    return ultraschall.SetEnvelopePoints_EnvelopePointArray(table.unpack({...}))
  end
  function ultraschall.DeleteEnvelopePoints_EnvelopePointObject(...)
    ultraschall.LM(10)
    return ultraschall.DeleteEnvelopePoints_EnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.DeleteEnvelopePoints_EnvelopePointArray(...)
    ultraschall.LM(10)
    return ultraschall.DeleteEnvelopePoints_EnvelopePointArray(table.unpack({...}))
  end
  function ultraschall.AddEnvelopePoints_EnvelopePointObject(...)
    ultraschall.LM(10)
    return ultraschall.AddEnvelopePoints_EnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.AddEnvelopePoints_EnvelopePointArray(...)
    ultraschall.LM(10)
    return ultraschall.AddEnvelopePoints_EnvelopePointArray(table.unpack({...}))
  end
  function ultraschall.CreateEnvelopePointObject(...)
    ultraschall.LM(10)
    return ultraschall.CreateEnvelopePointObject(table.unpack({...}))
  end
  function ultraschall.CountEnvelopePoints(...)
    ultraschall.LM(10)
    return ultraschall.CountEnvelopePoints(table.unpack({...}))
  end
  function ultraschall.SetEnvelopeHeight(...)
    ultraschall.LM(10)
    return ultraschall.SetEnvelopeHeight(table.unpack({...}))
  end
  function ultraschall.GetAllTrackEnvelopes(...)
    ultraschall.LM(10)
    return ultraschall.GetAllTrackEnvelopes(table.unpack({...}))
  end
  function ultraschall.IsValidEnvelopePointArray(...)
    ultraschall.LM(10)
    return ultraschall.IsValidEnvelopePointArray(table.unpack({...}))
  end
  function ultraschall.GetLastEnvelopePoint_TrackEnvelope(...)
    ultraschall.LM(10)
    return ultraschall.GetLastEnvelopePoint_TrackEnvelope(table.unpack({...}))
  end
  function ultraschall.GetArmState_Envelope(...)
    ultraschall.LM(10)
    return ultraschall.GetArmState_Envelope(table.unpack({...}))
  end
  function ultraschall.SetArmState_Envelope(...)
    ultraschall.LM(10)
    return ultraschall.SetArmState_Envelope(table.unpack({...}))
  end
  function ultraschall.GetTrackEnvelope_ClickState(...)
    ultraschall.LM(10)
    return ultraschall.GetTrackEnvelope_ClickState(table.unpack({...}))
  end
  function ultraschall.GetEnvelopeState_NumbersOnly(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopeState_NumbersOnly(table.unpack({...}))
  end
  function ultraschall.GetEnvelopeState_Act(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopeState_Act(table.unpack({...}))
  end
  function ultraschall.GetEnvelopeState_Vis(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopeState_Vis(table.unpack({...}))
  end
  function ultraschall.GetEnvelopeState_LaneHeight(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopeState_LaneHeight(table.unpack({...}))
  end
  function ultraschall.GetEnvelopeState_DefShape(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopeState_DefShape(table.unpack({...}))
  end
  function ultraschall.GetEnvelopeState_Voltype(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopeState_Voltype(table.unpack({...}))
  end
  function ultraschall.GetEnvelopeState_PooledEnvInstance(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopeState_PooledEnvInstance(table.unpack({...}))
  end
  function ultraschall.GetEnvelopeState_PT(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopeState_PT(table.unpack({...}))
  end
  function ultraschall.GetEnvelopeState_EnvName(...)
    ultraschall.LM(10)
    return ultraschall.GetEnvelopeState_EnvName(table.unpack({...}))
  end
  function ultraschall.GetAllTrackEnvelopes(...)
    ultraschall.LM(10)
    return ultraschall.GetAllTrackEnvelopes(table.unpack({...}))
  end
  function ultraschall.GetAllTakeEnvelopes(...)
    ultraschall.LM(10)
    return ultraschall.GetAllTakeEnvelopes(table.unpack({...}))
  end
  function ultraschall.SetEnvelopeState_Vis(...)
    ultraschall.LM(10)
    return ultraschall.SetEnvelopeState_Vis(table.unpack({...}))
  end
  function ultraschall.SetEnvelopeState_Act(...)
    ultraschall.LM(10)
    return ultraschall.SetEnvelopeState_Act(table.unpack({...}))
  end
  function ultraschall.SetEnvelopeState_DefShape(...)
    ultraschall.LM(10)
    return ultraschall.SetEnvelopeState_DefShape(table.unpack({...}))
  end
  function ultraschall.SetEnvelopeState_LaneHeight(...)
    ultraschall.LM(10)
    return ultraschall.SetEnvelopeState_LaneHeight(table.unpack({...}))
  end
  function ultraschall.ActivateEnvelope(...)
    ultraschall.LM(10)
    return ultraschall.ActivateEnvelope(table.unpack({...}))
  end
  function ultraschall.ActivateTrackVolumeEnv(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackVolumeEnv(table.unpack({...}))
  end
  function ultraschall.ActivateTrackVolumeEnv_TrackObject(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackVolumeEnv_TrackObject(table.unpack({...}))
  end
  function ultraschall.ActivateTrackPanEnv(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackPanEnv(table.unpack({...}))
  end
  function ultraschall.ActivateTrackPanEnv_TrackObject(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackPanEnv_TrackObject(table.unpack({...}))
  end
  function ultraschall.ActivateTrackPreFXPanEnv(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackPreFXPanEnv(table.unpack({...}))
  end
  function ultraschall.ActivateTrackPreFXPanEnv_TrackObject(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackPreFXPanEnv_TrackObject(table.unpack({...}))
  end
  function ultraschall.ActivateTrackPreFXVolumeEnv(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackPreFXVolumeEnv(table.unpack({...}))
  end
  function ultraschall.ActivateTrackPreFXVolumeEnv_TrackObject(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackPreFXVolumeEnv_TrackObject(table.unpack({...}))
  end
  function ultraschall.ActivateTrackTrimVolumeEnv(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackTrimVolumeEnv(table.unpack({...}))
  end
  function ultraschall.ActivateTrackTrimVolumeEnv_TrackObject(...)
    ultraschall.LM(10)
    return ultraschall.ActivateTrackTrimVolumeEnv_TrackObject(table.unpack({...}))
  end
  function ultraschall.GetTakeEnvelopeUnderMouseCursor(...)
    ultraschall.LM(10)
    return ultraschall.GetTakeEnvelopeUnderMouseCursor(table.unpack({...}))
  end
  function ultraschall.IsAnyMuteEnvelopeVisible(...)
    ultraschall.LM(10)
    return ultraschall.IsAnyMuteEnvelopeVisible(table.unpack({...}))
  end
  function ultraschall.IsEnvelope_Track(...)
    ultraschall.LM(10)
    return ultraschall.IsEnvelope_Track(table.unpack({...}))
  end
  function ultraschall.IsTrackEnvelopeVisible_ArrangeView(...)
    ultraschall.LM(10)
    return ultraschall.IsTrackEnvelopeVisible_ArrangeView(table.unpack({...}))
  end
  function ultraschall.GetAllActiveEnvelopes_Track(...)
    ultraschall.LM(10)
    return ultraschall.GetAllActiveEnvelopes_Track(table.unpack({...}))
  end
  function ultraschall.GetAllActiveEnvelopes_Take(...)
    ultraschall.LM(10)
    return ultraschall.GetAllActiveEnvelopes_Take(table.unpack({...}))
  end
  function ultraschall.GetTrackEnvelopeFromPoint(...)
    ultraschall.LM(10)
    return ultraschall.GetTrackEnvelopeFromPoint(table.unpack({...}))
  end
  function ultraschall.GetTakeEnvelopeFromPoint(...)
    ultraschall.LM(10)
    return ultraschall.GetTakeEnvelopeFromPoint(table.unpack({...}))
  end
  function ultraschall.IsEnvelopeTrackEnvelope(...)
    ultraschall.LM(10)
    return ultraschall.IsEnvelopeTrackEnvelope(table.unpack({...}))
  end
  function ultraschall.DeleteTrackEnvelopePointsBetween(...)
    ultraschall.LM(10)
    return ultraschall.DeleteTrackEnvelopePointsBetween(table.unpack({...}))
  end
  function ultraschall.EventManager_EnumerateStartupEvents(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_EnumerateStartupEvents(table.unpack({...}))
  end
  function ultraschall.EventManager_EnumerateStartupEvents2(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_EnumerateStartupEvents2(table.unpack({...}))
  end
  function ultraschall.EventManager_AddEvent(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_AddEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_IsValidEventIdentifier(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_IsValidEventIdentifier(table.unpack({...}))
  end
  function ultraschall.EventManager_RemoveEvent(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_RemoveEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_RemoveAllEvents_Script(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_RemoveAllEvents_Script(table.unpack({...}))
  end
  function ultraschall.EventManager_SetEvent(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_SetEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_EnumerateEvents(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_EnumerateEvents(table.unpack({...}))
  end
  function ultraschall.EventManager_EnumerateEvents2(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_EnumerateEvents2(table.unpack({...}))
  end
  function ultraschall.EventManager_CountRegisteredEvents(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_CountRegisteredEvents(table.unpack({...}))
  end
  function ultraschall.EventManager_GetLastUpdateTime(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetLastUpdateTime(table.unpack({...}))
  end
  function ultraschall.EventManager_PauseEvent(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_PauseEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_ResumeEvent(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_ResumeEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_Start(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_Start(table.unpack({...}))
  end
  function ultraschall.EventManager_Stop(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_Stop(table.unpack({...}))
  end
  function ultraschall.EventManager_AddStartupEvent(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_AddStartupEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_RemoveStartupEvent2(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_RemoveStartupEvent2(table.unpack({...}))
  end
  function ultraschall.EventManager_RemoveStartupEvent(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_RemoveStartupEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_CountStartupEvents(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_CountStartupEvents(table.unpack({...}))
  end
  function ultraschall.EventManager_SetStartupEvent(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_SetStartupEvent(table.unpack({...}))
  end
  function ultraschall.EventManager_GetPausedState2(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetPausedState2(table.unpack({...}))
  end
  function ultraschall.EventManager_GetPausedState(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetPausedState(table.unpack({...}))
  end
  function ultraschall.EventManager_GetEventIdentifier(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetEventIdentifier(table.unpack({...}))
  end
  function ultraschall.EventManager_GetLastCheckfunctionState(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetLastCheckfunctionState(table.unpack({...}))
  end
  function ultraschall.EventManager_GetRegisteredEventID(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetRegisteredEventID(table.unpack({...}))
  end
  function ultraschall.EventManager_GetLastCheckfunctionState2(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetLastCheckfunctionState2(table.unpack({...}))
  end
  function ultraschall.EventManager_DebugMode(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_DebugMode(table.unpack({...}))
  end
  function ultraschall.EventManager_DebugMode_UserSpace(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_DebugMode_UserSpace(table.unpack({...}))
  end
  function ultraschall.EventManager_Debug_GetExecutionTime(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_Debug_GetExecutionTime(table.unpack({...}))
  end
  function ultraschall.EventManager_GetAllEventIdentifier(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetAllEventIdentifier(table.unpack({...}))
  end
  function ultraschall.EventManager_GetAllEventNames(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetAllEventNames(table.unpack({...}))
  end
  function ultraschall.EventManager_Debug_GetAllActionRunStates(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_Debug_GetAllActionRunStates(table.unpack({...}))
  end
  function ultraschall.EventManager_GetAllEventIdentifier(...)
    ultraschall.LM(11)
    return ultraschall.EventManager_GetAllEventIdentifier(table.unpack({...}))
  end
  function ultraschall.IsValidFXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.IsValidFXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetFXFromFXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetFXFromFXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLearn_MediaItem(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLearn_MediaItem(table.unpack({...}))
  end
  function ultraschall.GetParmLearn_MediaTrack(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLearn_MediaTrack(table.unpack({...}))
  end
  function ultraschall.GetParmAlias_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmAlias_MediaTrack(...)
    ultraschall.LM(12)
    return ultraschall.GetParmAlias_MediaTrack(table.unpack({...}))
  end
  function ultraschall.GetParmModulationChunk_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetParmModulationChunk_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLFOLearn_MediaItem(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLFOLearn_MediaItem(table.unpack({...}))
  end
  function ultraschall.GetParmLFOLearn_MediaTrack(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLFOLearn_MediaTrack(table.unpack({...}))
  end
  function ultraschall.ScanDXPlugins(...)
    ultraschall.LM(12)
    return ultraschall.ScanDXPlugins(table.unpack({...}))
  end
  function ultraschall.DeleteParmLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.DeleteParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.DeleteParmAlias_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.DeleteParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.DeleteParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.DeleteParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetParmLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetParmAlias_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetParmAlias2_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetParmAlias2_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetFXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetFXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetFXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetFXStateChunk(table.unpack({...}))
  end
  function ultraschall.AddParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.AddParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.AddParmLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.AddParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.AddParmAlias_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.AddParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.CountParmAlias_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.CountParmAlias_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.CountParmLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.CountParmLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.CountParmLFOLearn_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.CountParmLFOLearn_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.ScanVSTPlugins(...)
    ultraschall.LM(12)
    return ultraschall.ScanVSTPlugins(table.unpack({...}))
  end
  function ultraschall.AutoDetectVSTPluginsFolder(...)
    ultraschall.LM(12)
    return ultraschall.AutoDetectVSTPluginsFolder(table.unpack({...}))
  end
  function ultraschall.CountFXStateChunksInStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.CountFXStateChunksInStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveFXStateChunkFromTrackStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.RemoveFXStateChunkFromTrackStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveFXStateChunkFromItemStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.RemoveFXStateChunkFromItemStateChunk(table.unpack({...}))
  end
  function ultraschall.LoadFXStateChunkFromRFXChainFile(...)
    ultraschall.LM(12)
    return ultraschall.LoadFXStateChunkFromRFXChainFile(table.unpack({...}))
  end
  function ultraschall.SaveFXStateChunkAsRFXChainfile(...)
    ultraschall.LM(12)
    return ultraschall.SaveFXStateChunkAsRFXChainfile(table.unpack({...}))
  end
  function ultraschall.GetAllRFXChainfilenames(...)
    ultraschall.LM(12)
    return ultraschall.GetAllRFXChainfilenames(table.unpack({...}))
  end
  function ultraschall.GetRecentFX(...)
    ultraschall.LM(12)
    return ultraschall.GetRecentFX(table.unpack({...}))
  end
  function ultraschall.GetTrackFX_AlternativeName(...)
    ultraschall.LM(12)
    return ultraschall.GetTrackFX_AlternativeName(table.unpack({...}))
  end
  function ultraschall.GetTakeFX_AlternativeName(...)
    ultraschall.LM(12)
    return ultraschall.GetTakeFX_AlternativeName(table.unpack({...}))
  end
  function ultraschall.SetTrackFX_AlternativeName(...)
    ultraschall.LM(12)
    return ultraschall.SetTrackFX_AlternativeName(table.unpack({...}))
  end
  function ultraschall.SetTakeFX_AlternativeName(...)
    ultraschall.LM(12)
    return ultraschall.SetTakeFX_AlternativeName(table.unpack({...}))
  end
  function ultraschall.GetFXSettingsString_FXLines(...)
    ultraschall.LM(12)
    return ultraschall.GetFXSettingsString_FXLines(table.unpack({...}))
  end
  function ultraschall.GetParmModTable_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetParmModTable_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.CreateDefaultParmModTable(...)
    ultraschall.LM(12)
    return ultraschall.CreateDefaultParmModTable(table.unpack({...}))
  end
  function ultraschall.IsValidParmModTable(...)
    ultraschall.LM(12)
    return ultraschall.IsValidParmModTable(table.unpack({...}))
  end
  function ultraschall.AddParmMod_ParmModTable(...)
    ultraschall.LM(12)
    return ultraschall.AddParmMod_ParmModTable(table.unpack({...}))
  end
  function ultraschall.SetParmMod_ParmModTable(...)
    ultraschall.LM(12)
    return ultraschall.SetParmMod_ParmModTable(table.unpack({...}))
  end
  function ultraschall.DeleteParmModFromFXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.DeleteParmModFromFXStateChunk(table.unpack({...}))
  end
  function ultraschall.CountParmModFromFXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.CountParmModFromFXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetAllParmAliasNames_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetAllParmAliasNames_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.DeleteParmAlias2_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.DeleteParmAlias2_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmAlias2_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetParmAlias2_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.InputFX_AddByName(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_AddByName(table.unpack({...}))
  end
  function ultraschall.InputFX_QueryFirstFXIndex(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_QueryFirstFXIndex(table.unpack({...}))
  end
  function ultraschall.InputFX_MoveFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_MoveFX(table.unpack({...}))
  end
  function ultraschall.InputFX_CopyFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_CopyFX(table.unpack({...}))
  end
  function ultraschall.InputFX_CopyFXFromTrackFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_CopyFXFromTrackFX(table.unpack({...}))
  end
  function ultraschall.InputFX_CopyFXToTrackFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_CopyFXToTrackFX(table.unpack({...}))
  end
  function ultraschall.InputFX_MoveFXFromTrackFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_MoveFXFromTrackFX(table.unpack({...}))
  end
  function ultraschall.InputFX_MoveFXToTrackFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_MoveFXToTrackFX(table.unpack({...}))
  end
  function ultraschall.InputFX_Delete(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_Delete(table.unpack({...}))
  end
  function ultraschall.InputFX_EndParamEdit(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_EndParamEdit(table.unpack({...}))
  end
  function ultraschall.InputFX_GetCount(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetCount(table.unpack({...}))
  end
  function ultraschall.InputFX_GetChainVisible(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetChainVisible(table.unpack({...}))
  end
  function ultraschall.InputFX_GetEnabled(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetEnabled(table.unpack({...}))
  end
  function ultraschall.InputFX_GetFloatingWindow(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetFloatingWindow(table.unpack({...}))
  end
  function ultraschall.InputFX_GetFXGUID(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetFXGUID(table.unpack({...}))
  end
  function ultraschall.InputFX_GetFXName(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetFXName(table.unpack({...}))
  end
  function ultraschall.InputFX_GetNumParams(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetNumParams(table.unpack({...}))
  end
  function ultraschall.InputFX_GetOffline(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetOffline(table.unpack({...}))
  end
  function ultraschall.InputFX_GetOpen(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetOpen(table.unpack({...}))
  end
  function ultraschall.InputFX_GetPreset(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetPreset(table.unpack({...}))
  end
  function ultraschall.InputFX_GetPresetIndex(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetPresetIndex(table.unpack({...}))
  end
  function ultraschall.InputFX_GetUserPresetFilename(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetUserPresetFilename(table.unpack({...}))
  end
  function ultraschall.InputFX_NavigatePresets(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_NavigatePresets(table.unpack({...}))
  end
  function ultraschall.InputFX_SetEnabled(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetEnabled(table.unpack({...}))
  end
  function ultraschall.InputFX_SetOffline(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetOffline(table.unpack({...}))
  end
  function ultraschall.InputFX_SetOpen(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetOpen(table.unpack({...}))
  end
  function ultraschall.InputFX_SetPreset(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetPreset(table.unpack({...}))
  end
  function ultraschall.InputFX_SetPresetByIndex(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetPresetByIndex(table.unpack({...}))
  end
  function ultraschall.InputFX_Show(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_Show(table.unpack({...}))
  end
  function ultraschall.InputFX_CopyFXToTakeFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_CopyFXToTakeFX(table.unpack({...}))
  end
  function ultraschall.InputFX_CopyFXFromTakeFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_CopyFXFromTakeFX(table.unpack({...}))
  end
  function ultraschall.InputFX_MoveFXFromTakeFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_MoveFXFromTakeFX(table.unpack({...}))
  end
  function ultraschall.InputFX_MoveFXToTakeFX(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_MoveFXToTakeFX(table.unpack({...}))
  end
  function ultraschall.InputFX_GetFXChain(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetFXChain(table.unpack({...}))
  end
  function ultraschall.InputFX_SetFXChain(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetFXChain(table.unpack({...}))
  end
  function ultraschall.InputFX_FormatParamValue(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_FormatParamValue(table.unpack({...}))
  end
  function ultraschall.InputFX_FormatParamValueNormalized(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_FormatParamValueNormalized(table.unpack({...}))
  end
  function ultraschall.InputFX_GetEQ(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetEQ(table.unpack({...}))
  end
  function ultraschall.InputFX_GetFormattedParamValue(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetFormattedParamValue(table.unpack({...}))
  end
  function ultraschall.InputFX_GetIOSize(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetIOSize(table.unpack({...}))
  end
  function ultraschall.InputFX_GetNamedConfigParm(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetNamedConfigParm(table.unpack({...}))
  end
  function ultraschall.InputFX_GetParam(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetParam(table.unpack({...}))
  end
  function ultraschall.InputFX_GetParameterStepSizes(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetParameterStepSizes(table.unpack({...}))
  end
  function ultraschall.InputFX_GetParamEx(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetParamEx(table.unpack({...}))
  end
  function ultraschall.InputFX_GetParamName(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetParamName(table.unpack({...}))
  end
  function ultraschall.InputFX_GetParamNormalized(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetParamNormalized(table.unpack({...}))
  end
  function ultraschall.InputFX_GetPinMappings(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetPinMappings(table.unpack({...}))
  end
  function ultraschall.InputFX_SetEQBandEnabled(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetEQBandEnabled(table.unpack({...}))
  end
  function ultraschall.InputFX_SetEQParam(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetEQParam(table.unpack({...}))
  end
  function ultraschall.InputFX_SetParam(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetParam(table.unpack({...}))
  end
  function ultraschall.InputFX_SetParamNormalized(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetParamNormalized(table.unpack({...}))
  end
  function ultraschall.InputFX_SetPinMappings(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_SetPinMappings(table.unpack({...}))
  end
  function ultraschall.InputFX_GetEQBandEnabled(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetEQBandEnabled(table.unpack({...}))
  end
  function ultraschall.InputFX_GetEQParam(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetEQParam(table.unpack({...}))
  end
  function ultraschall.GetFocusedFX(...)
    ultraschall.LM(12)
    return ultraschall.GetFocusedFX(table.unpack({...}))
  end
  function ultraschall.GetLastTouchedFX(...)
    ultraschall.LM(12)
    return ultraschall.GetLastTouchedFX(table.unpack({...}))
  end
  function ultraschall.GetFXComment_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetFXComment_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetFXComment_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetFXComment_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.CountFXFromFXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.CountFXFromFXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetTrackFXComment(...)
    ultraschall.LM(12)
    return ultraschall.GetTrackFXComment(table.unpack({...}))
  end
  function ultraschall.GetTakeFXComment(...)
    ultraschall.LM(12)
    return ultraschall.GetTakeFXComment(table.unpack({...}))
  end
  function ultraschall.InputFX_GetComment(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_GetComment(table.unpack({...}))
  end
  function ultraschall.SetTrackFXComment(...)
    ultraschall.LM(12)
    return ultraschall.SetTrackFXComment(table.unpack({...}))
  end
  function ultraschall.SetTakeFXComment(...)
    ultraschall.LM(12)
    return ultraschall.SetTakeFXComment(table.unpack({...}))
  end
  function ultraschall.GetFXWak_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetFXWak_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetFXMidiPreset_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetFXMidiPreset_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetFXWak_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetFXWak_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetFXMidiPreset_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetFXMidiPreset_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetFXBypass_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetFXBypass_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetFXFloatPos_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetFXFloatPos_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetFXGuid_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetFXGuid_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetWndRect_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetWndRect_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetShow_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetShow_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetLastSel_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetLastSel_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetDocked_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetDocked_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetFXBypass_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetFXBypass_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetShow_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetShow_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetWndRect_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetWndRect_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetDocked_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetDocked_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetLastSel_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetLastSel_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetFXGuid_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetFXGuid_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetFXFloatPos_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetFXFloatPos_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.AddParmLearn_FXStateChunk2(...)
    ultraschall.LM(12)
    return ultraschall.AddParmLearn_FXStateChunk2(table.unpack({...}))
  end
  function ultraschall.SetParmLearn_FXStateChunk2(...)
    ultraschall.LM(12)
    return ultraschall.SetParmLearn_FXStateChunk2(table.unpack({...}))
  end
  function ultraschall.GetParmLearn_FXStateChunk2(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLearn_FXStateChunk2(table.unpack({...}))
  end
  function ultraschall.GetParmLearnID_by_FXParam_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLearnID_by_FXParam_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmAliasID_by_FXParam_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetParmAliasID_by_FXParam_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLFOLearnID_by_FXParam_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLFOLearnID_by_FXParam_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetParmLearn_Default(...)
    ultraschall.LM(12)
    return ultraschall.GetParmLearn_Default(table.unpack({...}))
  end
  function ultraschall.SetParmLearn_Default(...)
    ultraschall.LM(12)
    return ultraschall.SetParmLearn_Default(table.unpack({...}))
  end
  function ultraschall.GetBatchConverter_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetBatchConverter_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.GetBatchConverter_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetBatchConverter_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.TrackFX_JSFX_Reload(...)
    ultraschall.LM(12)
    return ultraschall.TrackFX_JSFX_Reload(table.unpack({...}))
  end
  function ultraschall.TakeFX_JSFX_Reload(...)
    ultraschall.LM(12)
    return ultraschall.TakeFX_JSFX_Reload(table.unpack({...}))
  end
  function ultraschall.InputFX_JSFX_Reload(...)
    ultraschall.LM(12)
    return ultraschall.InputFX_JSFX_Reload(table.unpack({...}))
  end
  function ultraschall.GetGuidFromCustomMarkerID(...)
    ultraschall.LM(12)
    return ultraschall.GetGuidFromCustomMarkerID(table.unpack({...}))
  end
  function ultraschall.GetGuidFromCustomRegionID(...)
    ultraschall.LM(12)
    return ultraschall.GetGuidFromCustomRegionID(table.unpack({...}))
  end
  function ultraschall.GetCustomMarkerIDFromGuid(...)
    ultraschall.LM(12)
    return ultraschall.GetCustomMarkerIDFromGuid(table.unpack({...}))
  end
  function ultraschall.GetCustomRegionIDFromGuid(...)
    ultraschall.LM(12)
    return ultraschall.GetCustomRegionIDFromGuid(table.unpack({...}))
  end
  function ultraschall.TakeFX_GetAllGuidsFromAllTakes(...)
    ultraschall.LM(12)
    return ultraschall.TakeFX_GetAllGuidsFromAllTakes(table.unpack({...}))
  end
  function ultraschall.TrackFX_GetAllGuidsFromAllTracks(...)
    ultraschall.LM(12)
    return ultraschall.TrackFX_GetAllGuidsFromAllTracks(table.unpack({...}))
  end
  function ultraschall.GetFXByGuid(...)
    ultraschall.LM(12)
    return ultraschall.GetFXByGuid(table.unpack({...}))
  end
  function ultraschall.SetFXAutoBypassSettings(...)
    ultraschall.LM(12)
    return ultraschall.SetFXAutoBypassSettings(table.unpack({...}))
  end
  function ultraschall.GetFXAutoBypassSettings(...)
    ultraschall.LM(12)
    return ultraschall.GetFXAutoBypassSettings(table.unpack({...}))
  end
  function ultraschall.GetFXAutoBypass_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.GetFXAutoBypass_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.SetFXAutoBypass_FXStateChunk(...)
    ultraschall.LM(12)
    return ultraschall.SetFXAutoBypass_FXStateChunk(table.unpack({...}))
  end
  function ultraschall.ReadFullFile(...)
    ultraschall.LM(13)
    return ultraschall.ReadFullFile(table.unpack({...}))
  end
  function ultraschall.ReadValueFromFile(...)
    ultraschall.LM(13)
    return ultraschall.ReadValueFromFile(table.unpack({...}))
  end
  function ultraschall.ReadLinerangeFromFile(...)
    ultraschall.LM(13)
    return ultraschall.ReadLinerangeFromFile(table.unpack({...}))
  end
  function ultraschall.MakeCopyOfFile(...)
    ultraschall.LM(13)
    return ultraschall.MakeCopyOfFile(table.unpack({...}))
  end
  function ultraschall.MakeCopyOfFile_Binary(...)
    ultraschall.LM(13)
    return ultraschall.MakeCopyOfFile_Binary(table.unpack({...}))
  end
  function ultraschall.ReadBinaryFileUntilPattern(...)
    ultraschall.LM(13)
    return ultraschall.ReadBinaryFileUntilPattern(table.unpack({...}))
  end
  function ultraschall.ReadBinaryFileFromPattern(...)
    ultraschall.LM(13)
    return ultraschall.ReadBinaryFileFromPattern(table.unpack({...}))
  end
  function ultraschall.CountLinesInFile(...)
    ultraschall.LM(13)
    return ultraschall.CountLinesInFile(table.unpack({...}))
  end
  function ultraschall.ReadFileAsLines_Array(...)
    ultraschall.LM(13)
    return ultraschall.ReadFileAsLines_Array(table.unpack({...}))
  end
  function ultraschall.ReadBinaryFile_Offset(...)
    ultraschall.LM(13)
    return ultraschall.ReadBinaryFile_Offset(table.unpack({...}))
  end
  function ultraschall.GetLengthOfFile(...)
    ultraschall.LM(13)
    return ultraschall.GetLengthOfFile(table.unpack({...}))
  end
  function ultraschall.CountDirectoriesAndFilesInPath(...)
    ultraschall.LM(13)
    return ultraschall.CountDirectoriesAndFilesInPath(table.unpack({...}))
  end
  function ultraschall.GetAllFilenamesInPath(...)
    ultraschall.LM(13)
    return ultraschall.GetAllFilenamesInPath(table.unpack({...}))
  end
  function ultraschall.GetAllDirectoriesInPath(...)
    ultraschall.LM(13)
    return ultraschall.GetAllDirectoriesInPath(table.unpack({...}))
  end
  function ultraschall.CheckForValidFileFormats(...)
    ultraschall.LM(13)
    return ultraschall.CheckForValidFileFormats(table.unpack({...}))
  end
  function ultraschall.DirectoryExists(...)
    ultraschall.LM(13)
    return ultraschall.DirectoryExists(table.unpack({...}))
  end
  function ultraschall.OnlyFilesOfCertainType(...)
    ultraschall.LM(13)
    return ultraschall.OnlyFilesOfCertainType(table.unpack({...}))
  end
  function ultraschall.GetReaperWorkDir(...)
    ultraschall.LM(13)
    return ultraschall.GetReaperWorkDir(table.unpack({...}))
  end
  function ultraschall.DirectoryExists2(...)
    ultraschall.LM(13)
    return ultraschall.DirectoryExists2(table.unpack({...}))
  end
  function ultraschall.SetReaperWorkDir(...)
    ultraschall.LM(13)
    return ultraschall.SetReaperWorkDir(table.unpack({...}))
  end
  function ultraschall.GetPath(...)
    ultraschall.LM(13)
    return ultraschall.GetPath(table.unpack({...}))
  end
  function ultraschall.CreateValidTempFile(...)
    ultraschall.LM(13)
    return ultraschall.CreateValidTempFile(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile(...)
    ultraschall.LM(13)
    return ultraschall.WriteValueToFile(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile_Insert(...)
    ultraschall.LM(13)
    return ultraschall.WriteValueToFile_Insert(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile_Replace(...)
    ultraschall.LM(13)
    return ultraschall.WriteValueToFile_Replace(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile_InsertBinary(...)
    ultraschall.LM(13)
    return ultraschall.WriteValueToFile_InsertBinary(table.unpack({...}))
  end
  function ultraschall.WriteValueToFile_ReplaceBinary(...)
    ultraschall.LM(13)
    return ultraschall.WriteValueToFile_ReplaceBinary(table.unpack({...}))
  end
  function ultraschall.GetAllRecursiveFilesAndSubdirectories(...)
    ultraschall.LM(13)
    return ultraschall.GetAllRecursiveFilesAndSubdirectories(table.unpack({...}))
  end
  function ultraschall.SaveSubtitles_SRT(...)
    ultraschall.LM(13)
    return ultraschall.SaveSubtitles_SRT(table.unpack({...}))
  end
  function ultraschall.ReadSubtitles_SRT(...)
    ultraschall.LM(13)
    return ultraschall.ReadSubtitles_SRT(table.unpack({...}))
  end
  function ultraschall.MoveFileOrFolder(...)
    ultraschall.LM(13)
    return ultraschall.MoveFileOrFolder(table.unpack({...}))
  end
  function ultraschall.CopyFile_StartCopying(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_StartCopying(table.unpack({...}))
  end
  function ultraschall.CopyFile_IsCurrentlyCopying(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_IsCurrentlyCopying(table.unpack({...}))
  end
  function ultraschall.CopyFile_GetCurrentlyRunningCopyInstances(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_GetCurrentlyRunningCopyInstances(table.unpack({...}))
  end
  function ultraschall.CopyFile_GetCurrentlyCopiedFile(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_GetCurrentlyCopiedFile(table.unpack({...}))
  end
  function ultraschall.CopyFile_SetBufferSize(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_SetBufferSize(table.unpack({...}))
  end
  function ultraschall.CopyFile_GetBufferSize(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_GetBufferSize(table.unpack({...}))
  end
  function ultraschall.CopyFile_AddFileToQueue(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_AddFileToQueue(table.unpack({...}))
  end
  function ultraschall.CopyFile_GetCopiedStatus(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_GetCopiedStatus(table.unpack({...}))
  end
  function ultraschall.CopyFile_FlushCopiedFiles(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_FlushCopiedFiles(table.unpack({...}))
  end
  function ultraschall.CopyFile_StopCopying(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_StopCopying(table.unpack({...}))
  end
  function ultraschall.CopyFile_Pause(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_Pause(table.unpack({...}))
  end
  function ultraschall.CopyFile_GetPausedState(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_GetPausedState(table.unpack({...}))
  end
  function ultraschall.CopyFile_GetRemainingFilesToCopy(...)
    ultraschall.LM(13)
    return ultraschall.CopyFile_GetRemainingFilesToCopy(table.unpack({...}))
  end
  function ultraschall.SplitStringAtLineFeedToArray(...)
    ultraschall.LM(14)
    return ultraschall.SplitStringAtLineFeedToArray(table.unpack({...}))
  end
  function ultraschall.CountCharacterInString(...)
    ultraschall.LM(14)
    return ultraschall.CountCharacterInString(table.unpack({...}))
  end
  function ultraschall.IsValidMatchingPattern(...)
    ultraschall.LM(14)
    return ultraschall.IsValidMatchingPattern(table.unpack({...}))
  end
  function ultraschall.CSV2IndividualLinesAsArray(...)
    ultraschall.LM(14)
    return ultraschall.CSV2IndividualLinesAsArray(table.unpack({...}))
  end
  function ultraschall.RoundNumber(...)
    ultraschall.LM(14)
    return ultraschall.RoundNumber(table.unpack({...}))
  end
  function ultraschall.GetPartialString(...)
    ultraschall.LM(14)
    return ultraschall.GetPartialString(table.unpack({...}))
  end
  function ultraschall.Notes2CSV(...)
    ultraschall.LM(14)
    return ultraschall.Notes2CSV(table.unpack({...}))
  end
  function ultraschall.CSV2Line(...)
    ultraschall.LM(14)
    return ultraschall.CSV2Line(table.unpack({...}))
  end
  function ultraschall.IsItemInTrack(...)
    ultraschall.LM(14)
    return ultraschall.IsItemInTrack(table.unpack({...}))
  end
  function ultraschall.CheckActionCommandIDFormat(...)
    ultraschall.LM(14)
    return ultraschall.CheckActionCommandIDFormat(table.unpack({...}))
  end
  function ultraschall.CheckActionCommandIDFormat2(...)
    ultraschall.LM(14)
    return ultraschall.CheckActionCommandIDFormat2(table.unpack({...}))
  end
  function ultraschall.ToggleStateAction(...)
    ultraschall.LM(14)
    return ultraschall.ToggleStateAction(table.unpack({...}))
  end
  function ultraschall.RefreshToolbar_Action(...)
    ultraschall.LM(14)
    return ultraschall.RefreshToolbar_Action(table.unpack({...}))
  end
  function ultraschall.ToggleStateButton(...)
    ultraschall.LM(14)
    return ultraschall.ToggleStateButton(table.unpack({...}))
  end
  function ultraschall.SecondsToTime(...)
    ultraschall.LM(14)
    return ultraschall.SecondsToTime(table.unpack({...}))
  end
  function ultraschall.TimeToSeconds(...)
    ultraschall.LM(14)
    return ultraschall.TimeToSeconds(table.unpack({...}))
  end
  function ultraschall.SecondsToTimeString_hh_mm_ss_mss(...)
    ultraschall.LM(14)
    return ultraschall.SecondsToTimeString_hh_mm_ss_mss(table.unpack({...}))
  end
  function ultraschall.TimeStringToSeconds_hh_mm_ss_mss(...)
    ultraschall.LM(14)
    return ultraschall.TimeStringToSeconds_hh_mm_ss_mss(table.unpack({...}))
  end
  function ultraschall.CountPatternInString(...)
    ultraschall.LM(14)
    return ultraschall.CountPatternInString(table.unpack({...}))
  end
  function ultraschall.OpenURL(...)
    ultraschall.LM(14)
    return ultraschall.OpenURL(table.unpack({...}))
  end
  function ultraschall.CountEntriesInTable_Main(...)
    ultraschall.LM(14)
    return ultraschall.CountEntriesInTable_Main(table.unpack({...}))
  end
  function ultraschall.CompareArrays(...)
    ultraschall.LM(14)
    return ultraschall.CompareArrays(table.unpack({...}))
  end
  function ultraschall.GetOS(...)
    ultraschall.LM(14)
    return ultraschall.GetOS(table.unpack({...}))
  end
  function ultraschall.IsOS_Windows(...)
    ultraschall.LM(14)
    return ultraschall.IsOS_Windows(table.unpack({...}))
  end
  function ultraschall.IsOS_Mac(...)
    ultraschall.LM(14)
    return ultraschall.IsOS_Mac(table.unpack({...}))
  end
  function ultraschall.IsOS_Other(...)
    ultraschall.LM(14)
    return ultraschall.IsOS_Other(table.unpack({...}))
  end
  function ultraschall.GetReaperAppVersion(...)
    ultraschall.LM(14)
    return ultraschall.GetReaperAppVersion(table.unpack({...}))
  end
  function ultraschall.GetReaperAppVersion(...)
    ultraschall.LM(14)
    return ultraschall.GetReaperAppVersion(table.unpack({...}))
  end
  function ultraschall.LimitFractionOfFloat(...)
    ultraschall.LM(14)
    return ultraschall.LimitFractionOfFloat(table.unpack({...}))
  end
  function ultraschall.GetAllEntriesFromTable(...)
    ultraschall.LM(14)
    return ultraschall.GetAllEntriesFromTable(table.unpack({...}))
  end
  function ultraschall.APIExists(...)
    ultraschall.LM(14)
    return ultraschall.APIExists(table.unpack({...}))
  end
  function ultraschall.IsValidGuid(...)
    ultraschall.LM(14)
    return ultraschall.IsValidGuid(table.unpack({...}))
  end
  function ultraschall.SetBitfield(...)
    ultraschall.LM(14)
    return ultraschall.SetBitfield(table.unpack({...}))
  end
  function ultraschall.PreventCreatingUndoPoint(...)
    ultraschall.LM(14)
    return ultraschall.PreventCreatingUndoPoint(table.unpack({...}))
  end
  function ultraschall.SetIntConfigVar_Bitfield(...)
    ultraschall.LM(14)
    return ultraschall.SetIntConfigVar_Bitfield(table.unpack({...}))
  end
  function ultraschall.MakeCopyOfTable(...)
    ultraschall.LM(14)
    return ultraschall.MakeCopyOfTable(table.unpack({...}))
  end
  function ultraschall.ConvertStringToAscii_Array(...)
    ultraschall.LM(14)
    return ultraschall.ConvertStringToAscii_Array(table.unpack({...}))
  end
  function ultraschall.CompareStringWithAsciiValues(...)
    ultraschall.LM(14)
    return ultraschall.CompareStringWithAsciiValues(table.unpack({...}))
  end
  function ultraschall.ReturnsMinusOneInCaseOfError_Arzala(...)
    ultraschall.LM(14)
    return ultraschall.ReturnsMinusOneInCaseOfError_Arzala(table.unpack({...}))
  end
  function ultraschall.CountLinesInString(...)
    ultraschall.LM(14)
    return ultraschall.CountLinesInString(table.unpack({...}))
  end
  function ultraschall.ReturnTypeOfReaperObject(...)
    ultraschall.LM(14)
    return ultraschall.ReturnTypeOfReaperObject(table.unpack({...}))
  end
  function ultraschall.IsObjectValidReaperObject(...)
    ultraschall.LM(14)
    return ultraschall.IsObjectValidReaperObject(table.unpack({...}))
  end
  function ultraschall.KeepTableEntriesOfType(...)
    ultraschall.LM(14)
    return ultraschall.KeepTableEntriesOfType(table.unpack({...}))
  end
  function ultraschall.RemoveTableEntriesOfType(...)
    ultraschall.LM(14)
    return ultraschall.RemoveTableEntriesOfType(table.unpack({...}))
  end
  function ultraschall.IsItemInTrack3(...)
    ultraschall.LM(14)
    return ultraschall.IsItemInTrack3(table.unpack({...}))
  end
  function ultraschall.AddIntToChar(...)
    ultraschall.LM(14)
    return ultraschall.AddIntToChar(table.unpack({...}))
  end
  function ultraschall.MakeFunctionUndoable(...)
    ultraschall.LM(14)
    return ultraschall.MakeFunctionUndoable(table.unpack({...}))
  end
  function ultraschall.ReturnTableAsIndividualValues(...)
    ultraschall.LM(14)
    return ultraschall.ReturnTableAsIndividualValues(table.unpack({...}))
  end
  function ultraschall.type(...)
    ultraschall.LM(14)
    return ultraschall.type(table.unpack({...}))
  end
  function ultraschall.ConcatIntegerIndexedTables(...)
    ultraschall.LM(14)
    return ultraschall.ConcatIntegerIndexedTables(table.unpack({...}))
  end
  function ultraschall.ReverseTable(...)
    ultraschall.LM(14)
    return ultraschall.ReverseTable(table.unpack({...}))
  end
  function ultraschall.GetDuplicatesFromArrays(...)
    ultraschall.LM(14)
    return ultraschall.GetDuplicatesFromArrays(table.unpack({...}))
  end
  function ultraschall.GetScriptFilenameFromActionCommandID(...)
    ultraschall.LM(14)
    return ultraschall.GetScriptFilenameFromActionCommandID(table.unpack({...}))
  end
  function ultraschall.CombineBytesToInteger(...)
    ultraschall.LM(14)
    return ultraschall.CombineBytesToInteger(table.unpack({...}))
  end
  function ultraschall.SplitIntegerIntoBytes(...)
    ultraschall.LM(14)
    return ultraschall.SplitIntegerIntoBytes(table.unpack({...}))
  end
  function ultraschall.GetReaperScriptPath(...)
    ultraschall.LM(14)
    return ultraschall.GetReaperScriptPath(table.unpack({...}))
  end
  function ultraschall.GetReaperColorThemesPath(...)
    ultraschall.LM(14)
    return ultraschall.GetReaperColorThemesPath(table.unpack({...}))
  end
  function ultraschall.GetReaperJSFXPath(...)
    ultraschall.LM(14)
    return ultraschall.GetReaperJSFXPath(table.unpack({...}))
  end
  function ultraschall.GetReaperWebRCPath(...)
    ultraschall.LM(14)
    return ultraschall.GetReaperWebRCPath(table.unpack({...}))
  end
  function ultraschall.CycleTable(...)
    ultraschall.LM(14)
    return ultraschall.CycleTable(table.unpack({...}))
  end
  function ultraschall.SplitStringAtNULLBytes(...)
    ultraschall.LM(14)
    return ultraschall.SplitStringAtNULLBytes(table.unpack({...}))
  end
  function ultraschall.RunBackgroundHelperFeatures(...)
    ultraschall.LM(14)
    return ultraschall.RunBackgroundHelperFeatures(table.unpack({...}))
  end
  function ultraschall.Main_OnCommandByFilename(...)
    ultraschall.LM(14)
    return ultraschall.Main_OnCommandByFilename(table.unpack({...}))
  end
  function ultraschall.MIDI_OnCommandByFilename(...)
    ultraschall.LM(14)
    return ultraschall.MIDI_OnCommandByFilename(table.unpack({...}))
  end
  function ultraschall.GetScriptParameters(...)
    ultraschall.LM(14)
    return ultraschall.GetScriptParameters(table.unpack({...}))
  end
  function ultraschall.SetScriptParameters(...)
    ultraschall.LM(14)
    return ultraschall.SetScriptParameters(table.unpack({...}))
  end
  function ultraschall.GetScriptReturnvalues(...)
    ultraschall.LM(14)
    return ultraschall.GetScriptReturnvalues(table.unpack({...}))
  end
  function ultraschall.SetScriptReturnvalues(...)
    ultraschall.LM(14)
    return ultraschall.SetScriptReturnvalues(table.unpack({...}))
  end
  function ultraschall.GetScriptReturnvalues_Sender(...)
    ultraschall.LM(14)
    return ultraschall.GetScriptReturnvalues_Sender(table.unpack({...}))
  end
  function ultraschall.Base64_Encoder(...)
    ultraschall.LM(14)
    return ultraschall.Base64_Encoder(table.unpack({...}))
  end
  function ultraschall.Base64_Decoder(...)
    ultraschall.LM(14)
    return ultraschall.Base64_Decoder(table.unpack({...}))
  end
  function ultraschall.StateChunkLayouter(...)
    ultraschall.LM(14)
    return ultraschall.StateChunkLayouter(table.unpack({...}))
  end
  function ultraschall.ReverseEndianess_Byte(...)
    ultraschall.LM(14)
    return ultraschall.ReverseEndianess_Byte(table.unpack({...}))
  end
  function ultraschall.ConvertIntegerIntoString(...)
    ultraschall.LM(14)
    return ultraschall.ConvertIntegerIntoString(table.unpack({...}))
  end
  function ultraschall.ConvertIntegerToBits(...)
    ultraschall.LM(14)
    return ultraschall.ConvertIntegerToBits(table.unpack({...}))
  end
  function ultraschall.ConvertBitsToInteger(...)
    ultraschall.LM(14)
    return ultraschall.ConvertBitsToInteger(table.unpack({...}))
  end
  function ultraschall.GetSetIntConfigVar(...)
    ultraschall.LM(14)
    return ultraschall.GetSetIntConfigVar(table.unpack({...}))
  end
  function ultraschall.GetScriptIdentifier(...)
    ultraschall.LM(14)
    return ultraschall.GetScriptIdentifier(table.unpack({...}))
  end
  function ultraschall.ReplacePartOfString(...)
    ultraschall.LM(14)
    return ultraschall.ReplacePartOfString(table.unpack({...}))
  end
  function ultraschall.SearchStringInString(...)
    ultraschall.LM(14)
    return ultraschall.SearchStringInString(table.unpack({...}))
  end
  function ultraschall.MKVOL2DB(...)
    ultraschall.LM(14)
    return ultraschall.MKVOL2DB(table.unpack({...}))
  end
  function ultraschall.DB2MKVOL(...)
    ultraschall.LM(14)
    return ultraschall.DB2MKVOL(table.unpack({...}))
  end
  function ultraschall.ConvertIntegerIntoString2(...)
    ultraschall.LM(14)
    return ultraschall.ConvertIntegerIntoString2(table.unpack({...}))
  end
  function ultraschall.ConvertStringToIntegers(...)
    ultraschall.LM(14)
    return ultraschall.ConvertStringToIntegers(table.unpack({...}))
  end
  function ultraschall.SetScriptIdentifier_Description(...)
    ultraschall.LM(14)
    return ultraschall.SetScriptIdentifier_Description(table.unpack({...}))
  end
  function ultraschall.GetScriptIdentifier_Description(...)
    ultraschall.LM(14)
    return ultraschall.GetScriptIdentifier_Description(table.unpack({...}))
  end
  function ultraschall.SetScriptIdentifier_Title(...)
    ultraschall.LM(14)
    return ultraschall.SetScriptIdentifier_Title(table.unpack({...}))
  end
  function ultraschall.GetScriptIdentifier_Title(...)
    ultraschall.LM(14)
    return ultraschall.GetScriptIdentifier_Title(table.unpack({...}))
  end
  function ultraschall.ResetProgressBar(...)
    ultraschall.LM(14)
    return ultraschall.ResetProgressBar(table.unpack({...}))
  end
  function ultraschall.PrintProgressBar(...)
    ultraschall.LM(14)
    return ultraschall.PrintProgressBar(table.unpack({...}))
  end
  function ultraschall.StoreFunctionInExtState(...)
    ultraschall.LM(14)
    return ultraschall.StoreFunctionInExtState(table.unpack({...}))
  end
  function ultraschall.LoadFunctionFromExtState(...)
    ultraschall.LM(14)
    return ultraschall.LoadFunctionFromExtState(table.unpack({...}))
  end
  function ultraschall.ConvertHex2Ascii(...)
    ultraschall.LM(14)
    return ultraschall.ConvertHex2Ascii(table.unpack({...}))
  end
  function ultraschall.ConvertAscii2Hex(...)
    ultraschall.LM(14)
    return ultraschall.ConvertAscii2Hex(table.unpack({...}))
  end
  function ultraschall.get_action_context_MediaItemDiff(...)
    ultraschall.LM(14)
    return ultraschall.get_action_context_MediaItemDiff(table.unpack({...}))
  end
  function ultraschall.GetAllActions(...)
    ultraschall.LM(14)
    return ultraschall.GetAllActions(table.unpack({...}))
  end
  function ultraschall.IsWithinTimeRange(...)
    ultraschall.LM(14)
    return ultraschall.IsWithinTimeRange(table.unpack({...}))
  end
  function ultraschall.MediaExplorer_OnCommand(...)
    ultraschall.LM(14)
    return ultraschall.MediaExplorer_OnCommand(table.unpack({...}))
  end
  function ultraschall.UpdateMediaExplorer(...)
    ultraschall.LM(14)
    return ultraschall.UpdateMediaExplorer(table.unpack({...}))
  end
  function ultraschall.FindPatternsInString(...)
    ultraschall.LM(14)
    return ultraschall.FindPatternsInString(table.unpack({...}))
  end
  function ultraschall.RunLuaSourceCode(...)
    ultraschall.LM(14)
    return ultraschall.RunLuaSourceCode(table.unpack({...}))
  end
  function ultraschall.Main_OnCommand_LuaCode(...)
    ultraschall.LM(14)
    return ultraschall.Main_OnCommand_LuaCode(table.unpack({...}))
  end
  function ultraschall.ReplacePatternInString(...)
    ultraschall.LM(14)
    return ultraschall.ReplacePatternInString(table.unpack({...}))
  end
  function ultraschall.ConvertFunction_ToBase64String(...)
    ultraschall.LM(14)
    return ultraschall.ConvertFunction_ToBase64String(table.unpack({...}))
  end
  function ultraschall.ConvertFunction_FromBase64String(...)
    ultraschall.LM(14)
    return ultraschall.ConvertFunction_FromBase64String(table.unpack({...}))
  end
  function ultraschall.ConvertFunction_ToHexString(...)
    ultraschall.LM(14)
    return ultraschall.ConvertFunction_ToHexString(table.unpack({...}))
  end
  function ultraschall.ConvertFunction_FromHexString(...)
    ultraschall.LM(14)
    return ultraschall.ConvertFunction_FromHexString(table.unpack({...}))
  end
  function ultraschall.Benchmark_GetStartTime(...)
    ultraschall.LM(14)
    return ultraschall.Benchmark_GetStartTime(table.unpack({...}))
  end
  function ultraschall.Benchmark_GetAllStartTimesAndSlots(...)
    ultraschall.LM(14)
    return ultraschall.Benchmark_GetAllStartTimesAndSlots(table.unpack({...}))
  end
  function ultraschall.Benchmark_MeasureTime(...)
    ultraschall.LM(14)
    return ultraschall.Benchmark_MeasureTime(table.unpack({...}))
  end
  function ultraschall.TimeToMeasures(...)
    ultraschall.LM(14)
    return ultraschall.TimeToMeasures(table.unpack({...}))
  end
  function ultraschall.Create2DTable(...)
    ultraschall.LM(14)
    return ultraschall.Create2DTable(table.unpack({...}))
  end
  function ultraschall.Create3DTable(...)
    ultraschall.LM(14)
    return ultraschall.Create3DTable(table.unpack({...}))
  end
  function ultraschall.CreateMultiDimTable(...)
    ultraschall.LM(14)
    return ultraschall.CreateMultiDimTable(table.unpack({...}))
  end
  function ultraschall.GMem_Read_ValueRange(...)
    ultraschall.LM(14)
    return ultraschall.GMem_Read_ValueRange(table.unpack({...}))
  end
  function ultraschall.GMem_GetValues_VideoSamplePeeker(...)
    ultraschall.LM(14)
    return ultraschall.GMem_GetValues_VideoSamplePeeker(table.unpack({...}))
  end
  function ultraschall.ReturnReaperExeFile_With_Path(...)
    ultraschall.LM(14)
    return ultraschall.ReturnReaperExeFile_With_Path(table.unpack({...}))
  end
  function ultraschall.MediaExplorer_SetDeviceOutput(...)
    ultraschall.LM(14)
    return ultraschall.MediaExplorer_SetDeviceOutput(table.unpack({...}))
  end
  function ultraschall.MediaExplorer_SetAutoplay(...)
    ultraschall.LM(14)
    return ultraschall.MediaExplorer_SetAutoplay(table.unpack({...}))
  end
  function ultraschall.MediaExplorer_SetRate(...)
    ultraschall.LM(14)
    return ultraschall.MediaExplorer_SetRate(table.unpack({...}))
  end
  function ultraschall.MediaExplorer_SetStartOnBar(...)
    ultraschall.LM(14)
    return ultraschall.MediaExplorer_SetStartOnBar(table.unpack({...}))
  end
  function ultraschall.MediaExplorer_SetPitch(...)
    ultraschall.LM(14)
    return ultraschall.MediaExplorer_SetPitch(table.unpack({...}))
  end
  function ultraschall.MediaExplorer_SetVolume(...)
    ultraschall.LM(14)
    return ultraschall.MediaExplorer_SetVolume(table.unpack({...}))
  end
  function ultraschall.IsValidReaProject(...)
    ultraschall.LM(14)
    return ultraschall.IsValidReaProject(table.unpack({...}))
  end
  function ultraschall.GetSetIDEAutocompleteSuggestions(...)
    ultraschall.LM(14)
    return ultraschall.GetSetIDEAutocompleteSuggestions(table.unpack({...}))
  end
  function ultraschall.GetRandomString(...)
    ultraschall.LM(14)
    return ultraschall.GetRandomString(table.unpack({...}))
  end
  function ultraschall.ResizePNG(...)
    ultraschall.LM(15)
    return ultraschall.ResizePNG(table.unpack({...}))
  end
  function ultraschall.CaptureScreenAreaAsPNG(...)
    ultraschall.LM(15)
    return ultraschall.CaptureScreenAreaAsPNG(table.unpack({...}))
  end
  function ultraschall.CaptureWindowAsPNG(...)
    ultraschall.LM(15)
    return ultraschall.CaptureWindowAsPNG(table.unpack({...}))
  end
  function ultraschall.ResizeJPG(...)
    ultraschall.LM(15)
    return ultraschall.ResizeJPG(table.unpack({...}))
  end
  function ultraschall.ConvertPNG2JPG(...)
    ultraschall.LM(15)
    return ultraschall.ConvertPNG2JPG(table.unpack({...}))
  end
  function ultraschall.ConvertJPG2PNG(...)
    ultraschall.LM(15)
    return ultraschall.ConvertJPG2PNG(table.unpack({...}))
  end
  function ultraschall.Localize_UseFile(...)
    ultraschall.LM(16)
    return ultraschall.Localize_UseFile(table.unpack({...}))
  end
  function ultraschall.Localize(...)
    ultraschall.LM(16)
    return ultraschall.Localize(table.unpack({...}))
  end
  function ultraschall.Localize_RefreshFile(...)
    ultraschall.LM(16)
    return ultraschall.Localize_RefreshFile(table.unpack({...}))
  end
  function ultraschall.ZoomVertical_MidiEditor(...)
    ultraschall.LM(17)
    return ultraschall.ZoomVertical_MidiEditor(table.unpack({...}))
  end
  function ultraschall.ZoomHorizontal_MidiEditor(...)
    ultraschall.LM(17)
    return ultraschall.ZoomHorizontal_MidiEditor(table.unpack({...}))
  end
  function ultraschall.OpenItemInMidiEditor(...)
    ultraschall.LM(17)
    return ultraschall.OpenItemInMidiEditor(table.unpack({...}))
  end
  function ultraschall.MIDI_SendMidiNote(...)
    ultraschall.LM(17)
    return ultraschall.MIDI_SendMidiNote(table.unpack({...}))
  end
  function ultraschall.MIDI_SendMidiCC(...)
    ultraschall.LM(17)
    return ultraschall.MIDI_SendMidiCC(table.unpack({...}))
  end
  function ultraschall.MIDI_SendMidiPC(...)
    ultraschall.LM(17)
    return ultraschall.MIDI_SendMidiPC(table.unpack({...}))
  end
  function ultraschall.MIDI_SendMidiPitch(...)
    ultraschall.LM(17)
    return ultraschall.MIDI_SendMidiPitch(table.unpack({...}))
  end
  function ultraschall.QueryMIDIMessageNameByID(...)
    ultraschall.LM(17)
    return ultraschall.QueryMIDIMessageNameByID(table.unpack({...}))
  end
  function ultraschall.MidiEditor_SetFixOverlapState(...)
    ultraschall.LM(17)
    return ultraschall.MidiEditor_SetFixOverlapState(table.unpack({...}))
  end
  function ultraschall.MidiEditor_GetFixOverlapState(...)
    ultraschall.LM(17)
    return ultraschall.MidiEditor_GetFixOverlapState(table.unpack({...}))
  end
  function ultraschall.AddNormalMarker(...)
    ultraschall.LM(18)
    return ultraschall.AddNormalMarker(table.unpack({...}))
  end
  function ultraschall.AddPodRangeRegion(...)
    ultraschall.LM(18)
    return ultraschall.AddPodRangeRegion(table.unpack({...}))
  end
  function ultraschall.GetMarkerByName(...)
    ultraschall.LM(18)
    return ultraschall.GetMarkerByName(table.unpack({...}))
  end
  function ultraschall.GetMarkerByName_Pattern(...)
    ultraschall.LM(18)
    return ultraschall.GetMarkerByName_Pattern(table.unpack({...}))
  end
  function ultraschall.GetMarkerAndRegionsByIndex(...)
    ultraschall.LM(18)
    return ultraschall.GetMarkerAndRegionsByIndex(table.unpack({...}))
  end
  function ultraschall.SetMarkerByIndex(...)
    ultraschall.LM(18)
    return ultraschall.SetMarkerByIndex(table.unpack({...}))
  end
  function ultraschall.AddEditMarker(...)
    ultraschall.LM(18)
    return ultraschall.AddEditMarker(table.unpack({...}))
  end
  function ultraschall.CountNormalMarkers(...)
    ultraschall.LM(18)
    return ultraschall.CountNormalMarkers(table.unpack({...}))
  end
  function ultraschall.CountEditMarkers(...)
    ultraschall.LM(18)
    return ultraschall.CountEditMarkers(table.unpack({...}))
  end
  function ultraschall.GetPodRangeRegion(...)
    ultraschall.LM(18)
    return ultraschall.GetPodRangeRegion(table.unpack({...}))
  end
  function ultraschall.EnumerateNormalMarkers(...)
    ultraschall.LM(18)
    return ultraschall.EnumerateNormalMarkers(table.unpack({...}))
  end
  function ultraschall.EnumerateEditMarkers(...)
    ultraschall.LM(18)
    return ultraschall.EnumerateEditMarkers(table.unpack({...}))
  end
  function ultraschall.GetAllEditMarkers(...)
    ultraschall.LM(18)
    return ultraschall.GetAllEditMarkers(table.unpack({...}))
  end
  function ultraschall.GetAllNormalMarkers(...)
    ultraschall.LM(18)
    return ultraschall.GetAllNormalMarkers(table.unpack({...}))
  end
  function ultraschall.GetAllMarkers(...)
    ultraschall.LM(18)
    return ultraschall.GetAllMarkers(table.unpack({...}))
  end
  function ultraschall.SetNormalMarker(...)
    ultraschall.LM(18)
    return ultraschall.SetNormalMarker(table.unpack({...}))
  end
  function ultraschall.SetEditMarker(...)
    ultraschall.LM(18)
    return ultraschall.SetEditMarker(table.unpack({...}))
  end
  function ultraschall.SetPodRangeRegion(...)
    ultraschall.LM(18)
    return ultraschall.SetPodRangeRegion(table.unpack({...}))
  end
  function ultraschall.DeletePodRangeRegion(...)
    ultraschall.LM(18)
    return ultraschall.DeletePodRangeRegion(table.unpack({...}))
  end
  function ultraschall.DeleteNormalMarker(...)
    ultraschall.LM(18)
    return ultraschall.DeleteNormalMarker(table.unpack({...}))
  end
  function ultraschall.DeleteEditMarker(...)
    ultraschall.LM(18)
    return ultraschall.DeleteEditMarker(table.unpack({...}))
  end
  function ultraschall.ExportEditMarkersToFile(...)
    ultraschall.LM(18)
    return ultraschall.ExportEditMarkersToFile(table.unpack({...}))
  end
  function ultraschall.ExportNormalMarkersToFile(...)
    ultraschall.LM(18)
    return ultraschall.ExportNormalMarkersToFile(table.unpack({...}))
  end
  function ultraschall.ImportEditFromFile(...)
    ultraschall.LM(18)
    return ultraschall.ImportEditFromFile(table.unpack({...}))
  end
  function ultraschall.ImportMarkersFromFile(...)
    ultraschall.LM(18)
    return ultraschall.ImportMarkersFromFile(table.unpack({...}))
  end
  function ultraschall.MarkerToEditMarker(...)
    ultraschall.LM(18)
    return ultraschall.MarkerToEditMarker(table.unpack({...}))
  end
  function ultraschall.EditToMarker(...)
    ultraschall.LM(18)
    return ultraschall.EditToMarker(table.unpack({...}))
  end
  function ultraschall.GetMarkerByScreenCoordinates(...)
    ultraschall.LM(18)
    return ultraschall.GetMarkerByScreenCoordinates(table.unpack({...}))
  end
  function ultraschall.GetMarkerByTime(...)
    ultraschall.LM(18)
    return ultraschall.GetMarkerByTime(table.unpack({...}))
  end
  function ultraschall.GetRegionByScreenCoordinates(...)
    ultraschall.LM(18)
    return ultraschall.GetRegionByScreenCoordinates(table.unpack({...}))
  end
  function ultraschall.GetRegionByTime(...)
    ultraschall.LM(18)
    return ultraschall.GetRegionByTime(table.unpack({...}))
  end
  function ultraschall.GetTimeSignaturesByScreenCoordinates(...)
    ultraschall.LM(18)
    return ultraschall.GetTimeSignaturesByScreenCoordinates(table.unpack({...}))
  end
  function ultraschall.GetTimeSignaturesByTime(...)
    ultraschall.LM(18)
    return ultraschall.GetTimeSignaturesByTime(table.unpack({...}))
  end
  function ultraschall.IsMarkerEdit(...)
    ultraschall.LM(18)
    return ultraschall.IsMarkerEdit(table.unpack({...}))
  end
  function ultraschall.IsMarkerNormal(...)
    ultraschall.LM(18)
    return ultraschall.IsMarkerNormal(table.unpack({...}))
  end
  function ultraschall.IsRegionPodrange(...)
    ultraschall.LM(18)
    return ultraschall.IsRegionPodrange(table.unpack({...}))
  end
  function ultraschall.AddEditRegion(...)
    ultraschall.LM(18)
    return ultraschall.AddEditRegion(table.unpack({...}))
  end
  function ultraschall.SetEditRegion(...)
    ultraschall.LM(18)
    return ultraschall.SetEditRegion(table.unpack({...}))
  end
  function ultraschall.DeleteEditRegion(...)
    ultraschall.LM(18)
    return ultraschall.DeleteEditRegion(table.unpack({...}))
  end
  function ultraschall.EnumerateEditRegion(...)
    ultraschall.LM(18)
    return ultraschall.EnumerateEditRegion(table.unpack({...}))
  end
  function ultraschall.CountEditRegions(...)
    ultraschall.LM(18)
    return ultraschall.CountEditRegions(table.unpack({...}))
  end
  function ultraschall.GetAllMarkersBetween(...)
    ultraschall.LM(18)
    return ultraschall.GetAllMarkersBetween(table.unpack({...}))
  end
  function ultraschall.GetAllRegions(...)
    ultraschall.LM(18)
    return ultraschall.GetAllRegions(table.unpack({...}))
  end
  function ultraschall.GetAllRegionsBetween(...)
    ultraschall.LM(18)
    return ultraschall.GetAllRegionsBetween(table.unpack({...}))
  end
  function ultraschall.ParseMarkerString(...)
    ultraschall.LM(18)
    return ultraschall.ParseMarkerString(table.unpack({...}))
  end
  function ultraschall.RenumerateMarkers(...)
    ultraschall.LM(18)
    return ultraschall.RenumerateMarkers(table.unpack({...}))
  end
  function ultraschall.CountNormalMarkers_NumGap(...)
    ultraschall.LM(18)
    return ultraschall.CountNormalMarkers_NumGap(table.unpack({...}))
  end
  function ultraschall.IsMarkerAtPosition(...)
    ultraschall.LM(18)
    return ultraschall.IsMarkerAtPosition(table.unpack({...}))
  end
  function ultraschall.IsRegionAtPosition(...)
    ultraschall.LM(18)
    return ultraschall.IsRegionAtPosition(table.unpack({...}))
  end
  function ultraschall.CountMarkersAndRegions(...)
    ultraschall.LM(18)
    return ultraschall.CountMarkersAndRegions(table.unpack({...}))
  end
  function ultraschall.GetLastMarkerPosition(...)
    ultraschall.LM(18)
    return ultraschall.GetLastMarkerPosition(table.unpack({...}))
  end
  function ultraschall.GetLastRegion(...)
    ultraschall.LM(18)
    return ultraschall.GetLastRegion(table.unpack({...}))
  end
  function ultraschall.GetLastTimeSigMarkerPosition(...)
    ultraschall.LM(18)
    return ultraschall.GetLastTimeSigMarkerPosition(table.unpack({...}))
  end
  function ultraschall.GetMarkerUpdateCounter(...)
    ultraschall.LM(18)
    return ultraschall.GetMarkerUpdateCounter(table.unpack({...}))
  end
  function ultraschall.MoveTimeSigMarkersBy(...)
    ultraschall.LM(18)
    return ultraschall.MoveTimeSigMarkersBy(table.unpack({...}))
  end
  function ultraschall.GetAllTimeSigMarkers(...)
    ultraschall.LM(18)
    return ultraschall.GetAllTimeSigMarkers(table.unpack({...}))
  end
  function ultraschall.MoveMarkersBy(...)
    ultraschall.LM(18)
    return ultraschall.MoveMarkersBy(table.unpack({...}))
  end
  function ultraschall.MoveRegionsBy(...)
    ultraschall.LM(18)
    return ultraschall.MoveRegionsBy(table.unpack({...}))
  end
  function ultraschall.RippleCut_Regions(...)
    ultraschall.LM(18)
    return ultraschall.RippleCut_Regions(table.unpack({...}))
  end
  function ultraschall.GetAllCustomMarkers(...)
    ultraschall.LM(18)
    return ultraschall.GetAllCustomMarkers(table.unpack({...}))
  end
  function ultraschall.GetAllCustomRegions(...)
    ultraschall.LM(18)
    return ultraschall.GetAllCustomRegions(table.unpack({...}))
  end
  function ultraschall.CountAllCustomMarkers(...)
    ultraschall.LM(18)
    return ultraschall.CountAllCustomMarkers(table.unpack({...}))
  end
  function ultraschall.CountAllCustomRegions(...)
    ultraschall.LM(18)
    return ultraschall.CountAllCustomRegions(table.unpack({...}))
  end
  function ultraschall.EnumerateCustomMarkers(...)
    ultraschall.LM(18)
    return ultraschall.EnumerateCustomMarkers(table.unpack({...}))
  end
  function ultraschall.EnumerateCustomRegions(...)
    ultraschall.LM(18)
    return ultraschall.EnumerateCustomRegions(table.unpack({...}))
  end
  function ultraschall.DeleteCustomMarkers(...)
    ultraschall.LM(18)
    return ultraschall.DeleteCustomMarkers(table.unpack({...}))
  end
  function ultraschall.DeleteCustomRegions(...)
    ultraschall.LM(18)
    return ultraschall.DeleteCustomRegions(table.unpack({...}))
  end
  function ultraschall.AddCustomMarker(...)
    ultraschall.LM(18)
    return ultraschall.AddCustomMarker(table.unpack({...}))
  end
  function ultraschall.AddCustomRegion(...)
    ultraschall.LM(18)
    return ultraschall.AddCustomRegion(table.unpack({...}))
  end
  function ultraschall.SetCustomMarker(...)
    ultraschall.LM(18)
    return ultraschall.SetCustomMarker(table.unpack({...}))
  end
  function ultraschall.SetCustomRegion(...)
    ultraschall.LM(18)
    return ultraschall.SetCustomRegion(table.unpack({...}))
  end
  function ultraschall.GetNextFreeRegionIndex(...)
    ultraschall.LM(18)
    return ultraschall.GetNextFreeRegionIndex(table.unpack({...}))
  end
  function ultraschall.IsMarkerValidCustomMarker(...)
    ultraschall.LM(18)
    return ultraschall.IsMarkerValidCustomMarker(table.unpack({...}))
  end
  function ultraschall.IsRegionValidCustomRegion(...)
    ultraschall.LM(18)
    return ultraschall.IsRegionValidCustomRegion(table.unpack({...}))
  end
  function ultraschall.GetMarkerIDFromGuid(...)
    ultraschall.LM(18)
    return ultraschall.GetMarkerIDFromGuid(table.unpack({...}))
  end
  function ultraschall.GetGuidFromMarkerID(...)
    ultraschall.LM(18)
    return ultraschall.GetGuidFromMarkerID(table.unpack({...}))
  end
  function ultraschall.IsTimeSigmarkerAtPosition(...)
    ultraschall.LM(18)
    return ultraschall.IsTimeSigmarkerAtPosition(table.unpack({...}))
  end
  function ultraschall.GetAllCustomMarkerNames(...)
    ultraschall.LM(18)
    return ultraschall.GetAllCustomMarkerNames(table.unpack({...}))
  end
  function ultraschall.GetAllCustomRegionNames(...)
    ultraschall.LM(18)
    return ultraschall.GetAllCustomRegionNames(table.unpack({...}))
  end
  function ultraschall.GetGuidFromNormalMarkerID(...)
    ultraschall.LM(18)
    return ultraschall.GetGuidFromNormalMarkerID(table.unpack({...}))
  end
  function ultraschall.GetNormalMarkerIDFromGuid(...)
    ultraschall.LM(18)
    return ultraschall.GetNormalMarkerIDFromGuid(table.unpack({...}))
  end
  function ultraschall.AddProjectMarker(...)
    ultraschall.LM(18)
    return ultraschall.AddProjectMarker(table.unpack({...}))
  end
  function ultraschall.GetEditMarkerIDFromGuid(...)
    ultraschall.LM(18)
    return ultraschall.GetEditMarkerIDFromGuid(table.unpack({...}))
  end
  function ultraschall.GetGuidFromEditMarkerID(...)
    ultraschall.LM(18)
    return ultraschall.GetGuidFromEditMarkerID(table.unpack({...}))
  end
  function ultraschall.GetEditRegionIDFromGuid(...)
    ultraschall.LM(18)
    return ultraschall.GetEditRegionIDFromGuid(table.unpack({...}))
  end
  function ultraschall.GetGuidFromEditRegionID(...)
    ultraschall.LM(18)
    return ultraschall.GetGuidFromEditRegionID(table.unpack({...}))
  end
  function ultraschall.StoreTemporaryMarker(...)
    ultraschall.LM(18)
    return ultraschall.StoreTemporaryMarker(table.unpack({...}))
  end
  function ultraschall.GetTemporaryMarker(...)
    ultraschall.LM(18)
    return ultraschall.GetTemporaryMarker(table.unpack({...}))
  end
  function ultraschall.AddShownoteMarker(...)
    ultraschall.LM(18)
    return ultraschall.AddShownoteMarker(table.unpack({...}))
  end
  function ultraschall.SetShownoteMarker(...)
    ultraschall.LM(18)
    return ultraschall.SetShownoteMarker(table.unpack({...}))
  end
  function ultraschall.EnumerateShownoteMarkers(...)
    ultraschall.LM(18)
    return ultraschall.EnumerateShownoteMarkers(table.unpack({...}))
  end
  function ultraschall.CountShownoteMarkers(...)
    ultraschall.LM(18)
    return ultraschall.CountShownoteMarkers(table.unpack({...}))
  end
  function ultraschall.DeleteShownoteMarker(...)
    ultraschall.LM(18)
    return ultraschall.DeleteShownoteMarker(table.unpack({...}))
  end
  function ultraschall.PrepareChapterMarkers4ReaperExport(...)
    ultraschall.LM(18)
    return ultraschall.PrepareChapterMarkers4ReaperExport(table.unpack({...}))
  end
  function ultraschall.RestoreChapterMarkersAfterReaperExport(...)
    ultraschall.LM(18)
    return ultraschall.RestoreChapterMarkersAfterReaperExport(table.unpack({...}))
  end
  function ultraschall.GetGuidFromShownoteMarkerID(...)
    ultraschall.LM(18)
    return ultraschall.GetGuidFromShownoteMarkerID(table.unpack({...}))
  end
  function ultraschall.GetShownoteMarkerIDFromGuid(...)
    ultraschall.LM(18)
    return ultraschall.GetShownoteMarkerIDFromGuid(table.unpack({...}))
  end
  function ultraschall.IsMarkerShownote(...)
    ultraschall.LM(18)
    return ultraschall.IsMarkerShownote(table.unpack({...}))
  end
  function ultraschall.RenumerateNormalMarkers(...)
    ultraschall.LM(18)
    return ultraschall.RenumerateNormalMarkers(table.unpack({...}))
  end
  function ultraschall.RenumerateShownoteMarkers(...)
    ultraschall.LM(18)
    return ultraschall.RenumerateShownoteMarkers(table.unpack({...}))
  end
  function ultraschall.GetMarkerType(...)
    ultraschall.LM(18)
    return ultraschall.GetMarkerType(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_Start(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_Start(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_Stop(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_Stop(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_Debug(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_Debug(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_GetEntry(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_GetEntry(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_SetEntry(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_SetEntry(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_GetAvailableTypes(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_GetAvailableTypes(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_GetEntry_DefaultMarkers(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_GetEntry_DefaultMarkers(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_SetEntry_DefaultMarkers(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_SetEntry_DefaultMarkers(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_RemoveEntry(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_RemoveEntry(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_RemoveEntry_DefaultMarkers(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_RemoveEntry_DefaultMarkers(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_GetLastClickedMenuEntry(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_GetLastClickedMenuEntry(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_CountEntries(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_CountEntries(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_CountEntries_DefaultMarkers(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_CountEntries_DefaultMarkers(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_InsertEntry(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_InsertEntry(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_InsertEntry_DefaultMarkers(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_InsertEntry_DefaultMarkers(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_SetStartupAction(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_SetStartupAction(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_SetStartupAction_DefaultMarkers(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_SetStartupAction_DefaultMarkers(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_RemoveSubMenu(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_RemoveSubMenu(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_RemoveSubMenu_DefaultMarkers(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_RemoveSubMenu_DefaultMarkers(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_GetLastTouchedMarkerRegion(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_GetLastTouchedMarkerRegion(table.unpack({...}))
  end
  function ultraschall.MarkerMenu_GetLastClickState(...)
    ultraschall.LM(18)
    return ultraschall.MarkerMenu_GetLastClickState(table.unpack({...}))
  end
  function ultraschall.GetSetChapterMarker_Attributes(...)
    ultraschall.LM(18)
    return ultraschall.GetSetChapterMarker_Attributes(table.unpack({...}))
  end
  function ultraschall.GetSetPodcast_Attributes(...)
    ultraschall.LM(18)
    return ultraschall.GetSetPodcast_Attributes(table.unpack({...}))
  end
  function ultraschall.GetSetPodcastEpisode_Attributes(...)
    ultraschall.LM(18)
    return ultraschall.GetSetPodcastEpisode_Attributes(table.unpack({...}))
  end
  function ultraschall.GetSetShownoteMarker_Attributes(...)
    ultraschall.LM(18)
    return ultraschall.GetSetShownoteMarker_Attributes(table.unpack({...}))
  end
  function ultraschall.GetPodcastAttributesAsJSON(...)
    ultraschall.LM(18)
    return ultraschall.GetPodcastAttributesAsJSON(table.unpack({...}))
  end
  function ultraschall.PodcastMetaData_ExportWebsiteAsJSON(...)
    ultraschall.LM(18)
    return ultraschall.PodcastMetaData_ExportWebsiteAsJSON(table.unpack({...}))
  end
  function ultraschall.GetEpisodeAttributesAsJSON(...)
    ultraschall.LM(18)
    return ultraschall.GetEpisodeAttributesAsJSON(table.unpack({...}))
  end
  function ultraschall.GetChapterAttributesAsJSON(...)
    ultraschall.LM(18)
    return ultraschall.GetChapterAttributesAsJSON(table.unpack({...}))
  end
  function ultraschall.GetShownoteAttributesAsJSON(...)
    ultraschall.LM(18)
    return ultraschall.GetShownoteAttributesAsJSON(table.unpack({...}))
  end
  function ultraschall.PodcastMetadata_CreateJSON_Entry(...)
    ultraschall.LM(18)
    return ultraschall.PodcastMetadata_CreateJSON_Entry(table.unpack({...}))
  end
  function ultraschall.GetSetPodcastWebsite(...)
    ultraschall.LM(18)
    return ultraschall.GetSetPodcastWebsite(table.unpack({...}))
  end
  function ultraschall.GetSetContributor_Attributes(...)
    ultraschall.LM(18)
    return ultraschall.GetSetContributor_Attributes(table.unpack({...}))
  end
  function ultraschall.GetPodcastAttributePresetSlotByName(...)
    ultraschall.LM(18)
    return ultraschall.GetPodcastAttributePresetSlotByName(table.unpack({...}))
  end
  function ultraschall.GetEpisodeAttributePresetSlotByName(...)
    ultraschall.LM(18)
    return ultraschall.GetEpisodeAttributePresetSlotByName(table.unpack({...}))
  end
  function ultraschall.GetPodcastContributorAttributesAsJSON(...)
    ultraschall.LM(18)
    return ultraschall.GetPodcastContributorAttributesAsJSON(table.unpack({...}))
  end
  function ultraschall.CountContributors(...)
    ultraschall.LM(18)
    return ultraschall.CountContributors(table.unpack({...}))
  end
  function ultraschall.SetPodcastAttributesPreset_Name(...)
    ultraschall.LM(18)
    return ultraschall.SetPodcastAttributesPreset_Name(table.unpack({...}))
  end
  function ultraschall.GetPodcastAttributesPreset_Name(...)
    ultraschall.LM(18)
    return ultraschall.GetPodcastAttributesPreset_Name(table.unpack({...}))
  end
  function ultraschall.SetPodcastEpisodeAttributesPreset_Name(...)
    ultraschall.LM(18)
    return ultraschall.SetPodcastEpisodeAttributesPreset_Name(table.unpack({...}))
  end
  function ultraschall.GetPodcastEpisodeAttributesPreset_Name(...)
    ultraschall.LM(18)
    return ultraschall.GetPodcastEpisodeAttributesPreset_Name(table.unpack({...}))
  end
  function ultraschall.GetItemPosition(...)
    ultraschall.LM(19)
    return ultraschall.GetItemPosition(table.unpack({...}))
  end
  function ultraschall.GetItemLength(...)
    ultraschall.LM(19)
    return ultraschall.GetItemLength(table.unpack({...}))
  end
  function ultraschall.GetItemSnapOffset(...)
    ultraschall.LM(19)
    return ultraschall.GetItemSnapOffset(table.unpack({...}))
  end
  function ultraschall.GetItemLoop(...)
    ultraschall.LM(19)
    return ultraschall.GetItemLoop(table.unpack({...}))
  end
  function ultraschall.GetItemAllTakes(...)
    ultraschall.LM(19)
    return ultraschall.GetItemAllTakes(table.unpack({...}))
  end
  function ultraschall.GetItemFadeIn(...)
    ultraschall.LM(19)
    return ultraschall.GetItemFadeIn(table.unpack({...}))
  end
  function ultraschall.GetItemFadeOut(...)
    ultraschall.LM(19)
    return ultraschall.GetItemFadeOut(table.unpack({...}))
  end
  function ultraschall.GetItemMute(...)
    ultraschall.LM(19)
    return ultraschall.GetItemMute(table.unpack({...}))
  end
  function ultraschall.GetItemFadeFlag(...)
    ultraschall.LM(19)
    return ultraschall.GetItemFadeFlag(table.unpack({...}))
  end
  function ultraschall.GetItemLock(...)
    ultraschall.LM(19)
    return ultraschall.GetItemLock(table.unpack({...}))
  end
  function ultraschall.GetItemSelected(...)
    ultraschall.LM(19)
    return ultraschall.GetItemSelected(table.unpack({...}))
  end
  function ultraschall.GetItemGroup(...)
    ultraschall.LM(19)
    return ultraschall.GetItemGroup(table.unpack({...}))
  end
  function ultraschall.GetItemIGUID(...)
    ultraschall.LM(19)
    return ultraschall.GetItemIGUID(table.unpack({...}))
  end
  function ultraschall.GetItemIID(...)
    ultraschall.LM(19)
    return ultraschall.GetItemIID(table.unpack({...}))
  end
  function ultraschall.GetItemName(...)
    ultraschall.LM(19)
    return ultraschall.GetItemName(table.unpack({...}))
  end
  function ultraschall.GetItemVolPan(...)
    ultraschall.LM(19)
    return ultraschall.GetItemVolPan(table.unpack({...}))
  end
  function ultraschall.GetItemSampleOffset(...)
    ultraschall.LM(19)
    return ultraschall.GetItemSampleOffset(table.unpack({...}))
  end
  function ultraschall.GetItemPlayRate(...)
    ultraschall.LM(19)
    return ultraschall.GetItemPlayRate(table.unpack({...}))
  end
  function ultraschall.GetItemChanMode(...)
    ultraschall.LM(19)
    return ultraschall.GetItemChanMode(table.unpack({...}))
  end
  function ultraschall.GetItemGUID(...)
    ultraschall.LM(19)
    return ultraschall.GetItemGUID(table.unpack({...}))
  end
  function ultraschall.GetItemRecPass(...)
    ultraschall.LM(19)
    return ultraschall.GetItemRecPass(table.unpack({...}))
  end
  function ultraschall.GetItemBeat(...)
    ultraschall.LM(19)
    return ultraschall.GetItemBeat(table.unpack({...}))
  end
  function ultraschall.GetItemMixFlag(...)
    ultraschall.LM(19)
    return ultraschall.GetItemMixFlag(table.unpack({...}))
  end
  function ultraschall.GetItemUSTrackNumber_StateChunk(...)
    ultraschall.LM(19)
    return ultraschall.GetItemUSTrackNumber_StateChunk(table.unpack({...}))
  end
  function ultraschall.SetItemUSTrackNumber_StateChunk(...)
    ultraschall.LM(19)
    return ultraschall.SetItemUSTrackNumber_StateChunk(table.unpack({...}))
  end
  function ultraschall.SetItemPosition(...)
    ultraschall.LM(19)
    return ultraschall.SetItemPosition(table.unpack({...}))
  end
  function ultraschall.SetItemLength(...)
    ultraschall.LM(19)
    return ultraschall.SetItemLength(table.unpack({...}))
  end
  function ultraschall.GetItemStateChunk(...)
    ultraschall.LM(19)
    return ultraschall.GetItemStateChunk(table.unpack({...}))
  end
  function ultraschall.GetItem_Video_IgnoreAudio(...)
    ultraschall.LM(19)
    return ultraschall.GetItem_Video_IgnoreAudio(table.unpack({...}))
  end
  function ultraschall.SetItem_Video_IgnoreAudio(...)
    ultraschall.LM(19)
    return ultraschall.SetItem_Video_IgnoreAudio(table.unpack({...}))
  end
  function ultraschall.GetItemImage(...)
    ultraschall.LM(19)
    return ultraschall.GetItemImage(table.unpack({...}))
  end
  function ultraschall.SetItemImage(...)
    ultraschall.LM(19)
    return ultraschall.SetItemImage(table.unpack({...}))
  end
  function ultraschall.SetItemAllTakes(...)
    ultraschall.LM(19)
    return ultraschall.SetItemAllTakes(table.unpack({...}))
  end
  function ultraschall.SetItemChanMode(...)
    ultraschall.LM(19)
    return ultraschall.SetItemChanMode(table.unpack({...}))
  end
  function ultraschall.SetItemLoop(...)
    ultraschall.LM(19)
    return ultraschall.SetItemLoop(table.unpack({...}))
  end
  function ultraschall.SetItemName(...)
    ultraschall.LM(19)
    return ultraschall.SetItemName(table.unpack({...}))
  end
  function ultraschall.SetItemSelected(...)
    ultraschall.LM(19)
    return ultraschall.SetItemSelected(table.unpack({...}))
  end
  function ultraschall.SetItemGUID(...)
    ultraschall.LM(19)
    return ultraschall.SetItemGUID(table.unpack({...}))
  end
  function ultraschall.SetItemGUID(...)
    ultraschall.LM(19)
    return ultraschall.SetItemGUID(table.unpack({...}))
  end
  function ultraschall.SetItemIID(...)
    ultraschall.LM(19)
    return ultraschall.SetItemIID(table.unpack({...}))
  end
  function ultraschall.SetItemMute(...)
    ultraschall.LM(19)
    return ultraschall.SetItemMute(table.unpack({...}))
  end
  function ultraschall.SetItemSampleOffset(...)
    ultraschall.LM(19)
    return ultraschall.SetItemSampleOffset(table.unpack({...}))
  end
  function ultraschall.SetItemVolPan(...)
    ultraschall.LM(19)
    return ultraschall.SetItemVolPan(table.unpack({...}))
  end
  function ultraschall.SetItemFadeIn(...)
    ultraschall.LM(19)
    return ultraschall.SetItemFadeIn(table.unpack({...}))
  end
  function ultraschall.SetItemFadeOut(...)
    ultraschall.LM(19)
    return ultraschall.SetItemFadeOut(table.unpack({...}))
  end
  function ultraschall.SetItemPlayRate(...)
    ultraschall.LM(19)
    return ultraschall.SetItemPlayRate(table.unpack({...}))
  end
  function ultraschall.IsValidMediaItemStateChunk(...)
    ultraschall.LM(20)
    return ultraschall.IsValidMediaItemStateChunk(table.unpack({...}))
  end
  function ultraschall.CheckMediaItemArray(...)
    ultraschall.LM(20)
    return ultraschall.CheckMediaItemArray(table.unpack({...}))
  end
  function ultraschall.IsValidMediaItemArray(...)
    ultraschall.LM(20)
    return ultraschall.IsValidMediaItemArray(table.unpack({...}))
  end
  function ultraschall.CheckMediaItemStateChunkArray(...)
    ultraschall.LM(20)
    return ultraschall.CheckMediaItemStateChunkArray(table.unpack({...}))
  end
  function ultraschall.IsValidMediaItemStateChunkArray(...)
    ultraschall.LM(20)
    return ultraschall.IsValidMediaItemStateChunkArray(table.unpack({...}))
  end
  function ultraschall.GetMediaItemsAtPosition(...)
    ultraschall.LM(20)
    return ultraschall.GetMediaItemsAtPosition(table.unpack({...}))
  end
  function ultraschall.OnlyMediaItemsOfTracksInTrackstring(...)
    ultraschall.LM(20)
    return ultraschall.OnlyMediaItemsOfTracksInTrackstring(table.unpack({...}))
  end
  function ultraschall.SplitMediaItems_Position(...)
    ultraschall.LM(20)
    return ultraschall.SplitMediaItems_Position(table.unpack({...}))
  end
  function ultraschall.SplitItemsAtPositionFromArray(...)
    ultraschall.LM(20)
    return ultraschall.SplitItemsAtPositionFromArray(table.unpack({...}))
  end
  function ultraschall.DeleteMediaItem(...)
    ultraschall.LM(20)
    return ultraschall.DeleteMediaItem(table.unpack({...}))
  end
  function ultraschall.DeleteMediaItemsFromArray(...)
    ultraschall.LM(20)
    return ultraschall.DeleteMediaItemsFromArray(table.unpack({...}))
  end
  function ultraschall.DeleteMediaItems_Position(...)
    ultraschall.LM(20)
    return ultraschall.DeleteMediaItems_Position(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemsBetween(...)
    ultraschall.LM(20)
    return ultraschall.GetAllMediaItemsBetween(table.unpack({...}))
  end
  function ultraschall.MoveMediaItemsAfter_By(...)
    ultraschall.LM(20)
    return ultraschall.MoveMediaItemsAfter_By(table.unpack({...}))
  end
  function ultraschall.MoveMediaItemsBefore_By(...)
    ultraschall.LM(20)
    return ultraschall.MoveMediaItemsBefore_By(table.unpack({...}))
  end
  function ultraschall.MoveMediaItemsBetween_To(...)
    ultraschall.LM(20)
    return ultraschall.MoveMediaItemsBetween_To(table.unpack({...}))
  end
  function ultraschall.ChangeLengthOfMediaItems_FromArray(...)
    ultraschall.LM(20)
    return ultraschall.ChangeLengthOfMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(...)
    ultraschall.LM(20)
    return ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.ChangeOffsetOfMediaItems_FromArray(...)
    ultraschall.LM(20)
    return ultraschall.ChangeOffsetOfMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.ChangeDeltaOffsetOfMediaItems_FromArray(...)
    ultraschall.LM(20)
    return ultraschall.ChangeDeltaOffsetOfMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.SectionCut(...)
    ultraschall.LM(20)
    return ultraschall.SectionCut(table.unpack({...}))
  end
  function ultraschall.SectionCut_Inverse(...)
    ultraschall.LM(20)
    return ultraschall.SectionCut_Inverse(table.unpack({...}))
  end
  function ultraschall.RippleCut(...)
    ultraschall.LM(20)
    return ultraschall.RippleCut(table.unpack({...}))
  end
  function ultraschall.RippleCut_Reverse(...)
    ultraschall.LM(20)
    return ultraschall.RippleCut_Reverse(table.unpack({...}))
  end
  function ultraschall.InsertMediaItem_MediaItem(...)
    ultraschall.LM(20)
    return ultraschall.InsertMediaItem_MediaItem(table.unpack({...}))
  end
  function ultraschall.InsertMediaItem_MediaItemStateChunk(...)
    ultraschall.LM(20)
    return ultraschall.InsertMediaItem_MediaItemStateChunk(table.unpack({...}))
  end
  function ultraschall.InsertMediaItemArray(...)
    ultraschall.LM(20)
    return ultraschall.InsertMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetMediaItemStateChunksFromItems(...)
    ultraschall.LM(20)
    return ultraschall.GetMediaItemStateChunksFromItems(table.unpack({...}))
  end
  function ultraschall.RippleInsert(...)
    ultraschall.LM(20)
    return ultraschall.RippleInsert(table.unpack({...}))
  end
  function ultraschall.MoveMediaItems_FromArray(...)
    ultraschall.LM(20)
    return ultraschall.MoveMediaItems_FromArray(table.unpack({...}))
  end
  function ultraschall.InsertMediaItemStateChunkArray(...)
    ultraschall.LM(20)
    return ultraschall.InsertMediaItemStateChunkArray(table.unpack({...}))
  end
  function ultraschall.OnlyMediaItemsOfTracksInTrackstring_StateChunk(...)
    ultraschall.LM(20)
    return ultraschall.OnlyMediaItemsOfTracksInTrackstring_StateChunk(table.unpack({...}))
  end
  function ultraschall.RippleInsert_MediaItemStateChunks(...)
    ultraschall.LM(20)
    return ultraschall.RippleInsert_MediaItemStateChunks(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemsFromTrack(...)
    ultraschall.LM(20)
    return ultraschall.GetAllMediaItemsFromTrack(table.unpack({...}))
  end
  function ultraschall.SetItemsLockState(...)
    ultraschall.LM(20)
    return ultraschall.SetItemsLockState(table.unpack({...}))
  end
  function ultraschall.AddLockStateToMediaItemStateChunk(...)
    ultraschall.LM(20)
    return ultraschall.AddLockStateToMediaItemStateChunk(table.unpack({...}))
  end
  function ultraschall.AddLockStateTo_MediaItemStateChunkArray(...)
    ultraschall.LM(20)
    return ultraschall.AddLockStateTo_MediaItemStateChunkArray(table.unpack({...}))
  end
  function ultraschall.ApplyStateChunkToItems(...)
    ultraschall.LM(20)
    return ultraschall.ApplyStateChunkToItems(table.unpack({...}))
  end
  function ultraschall.GetAllLockedItemsFromMediaItemArray(...)
    ultraschall.LM(20)
    return ultraschall.GetAllLockedItemsFromMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetMediaItemStateChunksFromMediaItemArray(...)
    ultraschall.LM(20)
    return ultraschall.GetMediaItemStateChunksFromMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetSelectedMediaItemsAtPosition(...)
    ultraschall.LM(20)
    return ultraschall.GetSelectedMediaItemsAtPosition(table.unpack({...}))
  end
  function ultraschall.GetSelectedMediaItemsBetween(...)
    ultraschall.LM(20)
    return ultraschall.GetSelectedMediaItemsBetween(table.unpack({...}))
  end
  function ultraschall.DeselectMediaItems_MediaItemArray(...)
    ultraschall.LM(20)
    return ultraschall.DeselectMediaItems_MediaItemArray(table.unpack({...}))
  end
  function ultraschall.SelectMediaItems_MediaItemArray(...)
    ultraschall.LM(20)
    return ultraschall.SelectMediaItems_MediaItemArray(table.unpack({...}))
  end
  function ultraschall.EnumerateMediaItemsInTrack(...)
    ultraschall.LM(20)
    return ultraschall.EnumerateMediaItemsInTrack(table.unpack({...}))
  end
  function ultraschall.GetMediaItemArrayLength(...)
    ultraschall.LM(20)
    return ultraschall.GetMediaItemArrayLength(table.unpack({...}))
  end
  function ultraschall.GetMediaItemStateChunkArrayLength(...)
    ultraschall.LM(20)
    return ultraschall.GetMediaItemStateChunkArrayLength(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemGUIDs(...)
    ultraschall.LM(20)
    return ultraschall.GetAllMediaItemGUIDs(table.unpack({...}))
  end
  function ultraschall.GetItemSpectralConfig(...)
    ultraschall.LM(20)
    return ultraschall.GetItemSpectralConfig(table.unpack({...}))
  end
  function ultraschall.SetItemSpectralConfig(...)
    ultraschall.LM(20)
    return ultraschall.SetItemSpectralConfig(table.unpack({...}))
  end
  function ultraschall.CountItemSpectralEdits(...)
    ultraschall.LM(20)
    return ultraschall.CountItemSpectralEdits(table.unpack({...}))
  end
  function ultraschall.GetItemSpectralEdit(...)
    ultraschall.LM(20)
    return ultraschall.GetItemSpectralEdit(table.unpack({...}))
  end
  function ultraschall.DeleteItemSpectralEdit(...)
    ultraschall.LM(20)
    return ultraschall.DeleteItemSpectralEdit(table.unpack({...}))
  end
  function ultraschall.SetItemSpectralVisibilityState(...)
    ultraschall.LM(20)
    return ultraschall.SetItemSpectralVisibilityState(table.unpack({...}))
  end
  function ultraschall.SetItemSpectralEdit(...)
    ultraschall.LM(20)
    return ultraschall.SetItemSpectralEdit(table.unpack({...}))
  end
  function ultraschall.GetItemSourceFile_Take(...)
    ultraschall.LM(20)
    return ultraschall.GetItemSourceFile_Take(table.unpack({...}))
  end
  function ultraschall.AddItemSpectralEdit(...)
    ultraschall.LM(20)
    return ultraschall.AddItemSpectralEdit(table.unpack({...}))
  end
  function ultraschall.GetItemSpectralVisibilityState(...)
    ultraschall.LM(20)
    return ultraschall.GetItemSpectralVisibilityState(table.unpack({...}))
  end
  function ultraschall.InsertImageFile(...)
    ultraschall.LM(20)
    return ultraschall.InsertImageFile(table.unpack({...}))
  end
  function ultraschall.GetAllSelectedMediaItems(...)
    ultraschall.LM(20)
    return ultraschall.GetAllSelectedMediaItems(table.unpack({...}))
  end
  function ultraschall.SetMediaItemsSelected_TimeSelection(...)
    ultraschall.LM(20)
    return ultraschall.SetMediaItemsSelected_TimeSelection(table.unpack({...}))
  end
  function ultraschall.GetParentTrack_MediaItem(...)
    ultraschall.LM(20)
    return ultraschall.GetParentTrack_MediaItem(table.unpack({...}))
  end
  function ultraschall.IsItemInTrack2(...)
    ultraschall.LM(20)
    return ultraschall.IsItemInTrack2(table.unpack({...}))
  end
  function ultraschall.IsItemInTimerange(...)
    ultraschall.LM(20)
    return ultraschall.IsItemInTimerange(table.unpack({...}))
  end
  function ultraschall.OnlyItemsInTracksAndTimerange(...)
    ultraschall.LM(20)
    return ultraschall.OnlyItemsInTracksAndTimerange(table.unpack({...}))
  end
  function ultraschall.ApplyActionToMediaItem(...)
    ultraschall.LM(20)
    return ultraschall.ApplyActionToMediaItem(table.unpack({...}))
  end
  function ultraschall.ApplyActionToMediaItemArray(...)
    ultraschall.LM(20)
    return ultraschall.ApplyActionToMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemsInTimeSelection(...)
    ultraschall.LM(20)
    return ultraschall.GetAllMediaItemsInTimeSelection(table.unpack({...}))
  end
  function ultraschall.NormalizeItems(...)
    ultraschall.LM(20)
    return ultraschall.NormalizeItems(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItems(...)
    ultraschall.LM(20)
    return ultraschall.GetAllMediaItems(table.unpack({...}))
  end
  function ultraschall.PreviewMediaItem(...)
    ultraschall.LM(20)
    return ultraschall.PreviewMediaItem(table.unpack({...}))
  end
  function ultraschall.StopAnyPreview(...)
    ultraschall.LM(20)
    return ultraschall.StopAnyPreview(table.unpack({...}))
  end
  function ultraschall.PreviewMediaFile(...)
    ultraschall.LM(20)
    return ultraschall.PreviewMediaFile(table.unpack({...}))
  end
  function ultraschall.GetMediaItemTake(...)
    ultraschall.LM(20)
    return ultraschall.GetMediaItemTake(table.unpack({...}))
  end
  function ultraschall.ApplyFunctionToMediaItemArray(...)
    ultraschall.LM(20)
    return ultraschall.ApplyFunctionToMediaItemArray(table.unpack({...}))
  end
  function ultraschall.GetGapsBetweenItems(...)
    ultraschall.LM(20)
    return ultraschall.GetGapsBetweenItems(table.unpack({...}))
  end
  function ultraschall.DeleteMediaItems_Position(...)
    ultraschall.LM(20)
    return ultraschall.DeleteMediaItems_Position(table.unpack({...}))
  end
  function ultraschall.ApplyActionToMediaItemArray2(...)
    ultraschall.LM(20)
    return ultraschall.ApplyActionToMediaItemArray2(table.unpack({...}))
  end
  function ultraschall.GetMediafileAttributes(...)
    ultraschall.LM(20)
    return ultraschall.GetMediafileAttributes(table.unpack({...}))
  end
  function ultraschall.InsertMediaItemFromFile(...)
    ultraschall.LM(20)
    return ultraschall.InsertMediaItemFromFile(table.unpack({...}))
  end
  function ultraschall.CopyMediaItemToDestinationTrack(...)
    ultraschall.LM(20)
    return ultraschall.CopyMediaItemToDestinationTrack(table.unpack({...}))
  end
  function ultraschall.IsSplitAtPosition(...)
    ultraschall.LM(20)
    return ultraschall.IsSplitAtPosition(table.unpack({...}))
  end
  function ultraschall.GetItem_Number(...)
    ultraschall.LM(20)
    return ultraschall.GetItem_Number(table.unpack({...}))
  end
  function ultraschall.GetItem_HighestRecCounter(...)
    ultraschall.LM(20)
    return ultraschall.GetItem_HighestRecCounter(table.unpack({...}))
  end
  function ultraschall.GetItem_ClickState(...)
    ultraschall.LM(20)
    return ultraschall.GetItem_ClickState(table.unpack({...}))
  end
  function ultraschall.GetEndOfItem(...)
    ultraschall.LM(20)
    return ultraschall.GetEndOfItem(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemAttributes_Table(...)
    ultraschall.LM(20)
    return ultraschall.GetAllMediaItemAttributes_Table(table.unpack({...}))
  end
  function ultraschall.SetAllMediaItemAttributes_Table(...)
    ultraschall.LM(20)
    return ultraschall.SetAllMediaItemAttributes_Table(table.unpack({...}))
  end
  function ultraschall.GetAllSelectedMediaItemsBetween(...)
    ultraschall.LM(20)
    return ultraschall.GetAllSelectedMediaItemsBetween(table.unpack({...}))
  end
  function ultraschall.MediaItems_Outtakes_AddSelectedItems(...)
    ultraschall.LM(20)
    return ultraschall.MediaItems_Outtakes_AddSelectedItems(table.unpack({...}))
  end
  function ultraschall.MediaItems_Outtakes_GetAllItems(...)
    ultraschall.LM(20)
    return ultraschall.MediaItems_Outtakes_GetAllItems(table.unpack({...}))
  end
  function ultraschall.MediaItems_Outtakes_InsertAllItems(...)
    ultraschall.LM(20)
    return ultraschall.MediaItems_Outtakes_InsertAllItems(table.unpack({...}))
  end
  function ultraschall.GetTake_ReverseState(...)
    ultraschall.LM(20)
    return ultraschall.GetTake_ReverseState(table.unpack({...}))
  end
  function ultraschall.IsItemVisible(...)
    ultraschall.LM(20)
    return ultraschall.IsItemVisible(table.unpack({...}))
  end
  function ultraschall.ApplyActionToMediaItemTake(...)
    ultraschall.LM(20)
    return ultraschall.ApplyActionToMediaItemTake(table.unpack({...}))
  end
  function ultraschall.CountMediaItemTake_StateChunk(...)
    ultraschall.LM(20)
    return ultraschall.CountMediaItemTake_StateChunk(table.unpack({...}))
  end
  function ultraschall.GetMediaItemTake_StateChunk(...)
    ultraschall.LM(20)
    return ultraschall.GetMediaItemTake_StateChunk(table.unpack({...}))
  end
  function ultraschall.GetItemSpectralConfig2(...)
    ultraschall.LM(20)
    return ultraschall.GetItemSpectralConfig2(table.unpack({...}))
  end
  function ultraschall.GetItemSpectralEdit2(...)
    ultraschall.LM(20)
    return ultraschall.GetItemSpectralEdit2(table.unpack({...}))
  end
  function ultraschall.GetItemSpectralConfig2(...)
    ultraschall.LM(20)
    return ultraschall.GetItemSpectralConfig2(table.unpack({...}))
  end
  function ultraschall.SpectralPeak_GetMinColor(...)
    ultraschall.LM(20)
    return ultraschall.SpectralPeak_GetMinColor(table.unpack({...}))
  end
  function ultraschall.SpectralPeak_SetMinColor(...)
    ultraschall.LM(20)
    return ultraschall.SpectralPeak_SetMinColor(table.unpack({...}))
  end
  function ultraschall.SpectralPeak_GetMaxColor(...)
    ultraschall.LM(20)
    return ultraschall.SpectralPeak_GetMaxColor(table.unpack({...}))
  end
  function ultraschall.SpectralPeak_SetMaxColor(...)
    ultraschall.LM(20)
    return ultraschall.SpectralPeak_SetMaxColor(table.unpack({...}))
  end
  function ultraschall.SpectralPeak_SetMaxColor_Relative(...)
    ultraschall.LM(20)
    return ultraschall.SpectralPeak_SetMaxColor_Relative(table.unpack({...}))
  end
  function ultraschall.SpectralPeak_SetColorAttributes(...)
    ultraschall.LM(20)
    return ultraschall.SpectralPeak_SetColorAttributes(table.unpack({...}))
  end
  function ultraschall.SpectralPeak_GetColorAttributes(...)
    ultraschall.LM(20)
    return ultraschall.SpectralPeak_GetColorAttributes(table.unpack({...}))
  end
  function ultraschall.ToggleCrossfadeStateForSplits(...)
    ultraschall.LM(20)
    return ultraschall.ToggleCrossfadeStateForSplits(table.unpack({...}))
  end
  function ultraschall.DeleteProjExtState_Section(...)
    ultraschall.LM(21)
    return ultraschall.DeleteProjExtState_Section(table.unpack({...}))
  end
  function ultraschall.DeleteProjExtState_Key(...)
    ultraschall.LM(21)
    return ultraschall.DeleteProjExtState_Key(table.unpack({...}))
  end
  function ultraschall.GetProjExtState_AllKeyValues(...)
    ultraschall.LM(21)
    return ultraschall.GetProjExtState_AllKeyValues(table.unpack({...}))
  end
  function ultraschall.GetGuidExtState(...)
    ultraschall.LM(21)
    return ultraschall.GetGuidExtState(table.unpack({...}))
  end
  function ultraschall.SetGuidExtState(...)
    ultraschall.LM(21)
    return ultraschall.SetGuidExtState(table.unpack({...}))
  end
  function ultraschall.SetMarkerExtState(...)
    ultraschall.LM(21)
    return ultraschall.SetMarkerExtState(table.unpack({...}))
  end
  function ultraschall.GetMarkerExtState(...)
    ultraschall.LM(21)
    return ultraschall.GetMarkerExtState(table.unpack({...}))
  end
  function ultraschall.ProjExtState_CountAllKeys(...)
    ultraschall.LM(21)
    return ultraschall.ProjExtState_CountAllKeys(table.unpack({...}))
  end
  function ultraschall.Metadata_ID3_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_ID3_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_BWF_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_BWF_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_IXML_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_IXML_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_INFO_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_INFO_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_CART_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_CART_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_AIFF_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_AIFF_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_XMP_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_XMP_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_VORBIS_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_VORBIS_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_CUE_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_CUE_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_APE_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_APE_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_ASWG_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_ASWG_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_AXML_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_AXML_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_CAFINFO_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_CAFINFO_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_FLACPIC_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_FLACPIC_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_IFF_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_IFF_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_WAVEXT_GetSet(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_WAVEXT_GetSet(table.unpack({...}))
  end
  function ultraschall.Metadata_GetMetaDataTable_Presets(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_GetMetaDataTable_Presets(table.unpack({...}))
  end
  function ultraschall.Metadata_GetAllPresetNames(...)
    ultraschall.LM(21)
    return ultraschall.Metadata_GetAllPresetNames(table.unpack({...}))
  end
  function ultraschall.MetaDataTable_Create(...)
    ultraschall.LM(21)
    return ultraschall.MetaDataTable_Create(table.unpack({...}))
  end
  function ultraschall.MetaDataTable_GetProject(...)
    ultraschall.LM(21)
    return ultraschall.MetaDataTable_GetProject(table.unpack({...}))
  end
  function ultraschall.ToggleMute(...)
    ultraschall.LM(22)
    return ultraschall.ToggleMute(table.unpack({...}))
  end
  function ultraschall.ToggleMute_TrackObject(...)
    ultraschall.LM(22)
    return ultraschall.ToggleMute_TrackObject(table.unpack({...}))
  end
  function ultraschall.GetNextMuteState(...)
    ultraschall.LM(22)
    return ultraschall.GetNextMuteState(table.unpack({...}))
  end
  function ultraschall.GetPreviousMuteState(...)
    ultraschall.LM(22)
    return ultraschall.GetPreviousMuteState(table.unpack({...}))
  end
  function ultraschall.GetNextMuteState_TrackObject(...)
    ultraschall.LM(22)
    return ultraschall.GetNextMuteState_TrackObject(table.unpack({...}))
  end
  function ultraschall.GetPreviousMuteState_TrackObject(...)
    ultraschall.LM(22)
    return ultraschall.GetPreviousMuteState_TrackObject(table.unpack({...}))
  end
  function ultraschall.CountMuteEnvelopePoints(...)
    ultraschall.LM(22)
    return ultraschall.CountMuteEnvelopePoints(table.unpack({...}))
  end
  function ultraschall.DeleteMuteState(...)
    ultraschall.LM(22)
    return ultraschall.DeleteMuteState(table.unpack({...}))
  end
  function ultraschall.DeleteMuteState_TrackObject(...)
    ultraschall.LM(22)
    return ultraschall.DeleteMuteState_TrackObject(table.unpack({...}))
  end
  function ultraschall.IsMuteAtPosition(...)
    ultraschall.LM(22)
    return ultraschall.IsMuteAtPosition(table.unpack({...}))
  end
  function ultraschall.IsMuteAtPosition_TrackObject(...)
    ultraschall.LM(22)
    return ultraschall.IsMuteAtPosition_TrackObject(table.unpack({...}))
  end
  function ultraschall.ActivateMute(...)
    ultraschall.LM(22)
    return ultraschall.ActivateMute(table.unpack({...}))
  end
  function ultraschall.DeactivateMute(...)
    ultraschall.LM(22)
    return ultraschall.DeactivateMute(table.unpack({...}))
  end
  function ultraschall.ActivateMute_TrackObject(...)
    ultraschall.LM(22)
    return ultraschall.ActivateMute_TrackObject(table.unpack({...}))
  end
  function ultraschall.DeactivateMute_TrackObject(...)
    ultraschall.LM(22)
    return ultraschall.DeactivateMute_TrackObject(table.unpack({...}))
  end
  function ultraschall.ToggleScrollingDuringPlayback(...)
    ultraschall.LM(23)
    return ultraschall.ToggleScrollingDuringPlayback(table.unpack({...}))
  end
  function ultraschall.SetPlayCursor_WhenPlaying(...)
    ultraschall.LM(23)
    return ultraschall.SetPlayCursor_WhenPlaying(table.unpack({...}))
  end
  function ultraschall.SetPlayAndEditCursor_WhenPlaying(...)
    ultraschall.LM(23)
    return ultraschall.SetPlayAndEditCursor_WhenPlaying(table.unpack({...}))
  end
  function ultraschall.JumpForwardBy(...)
    ultraschall.LM(23)
    return ultraschall.JumpForwardBy(table.unpack({...}))
  end
  function ultraschall.JumpBackwardBy(...)
    ultraschall.LM(23)
    return ultraschall.JumpBackwardBy(table.unpack({...}))
  end
  function ultraschall.JumpForwardBy_Recording(...)
    ultraschall.LM(23)
    return ultraschall.JumpForwardBy_Recording(table.unpack({...}))
  end
  function ultraschall.JumpBackwardBy_Recording(...)
    ultraschall.LM(23)
    return ultraschall.JumpBackwardBy_Recording(table.unpack({...}))
  end
  function ultraschall.GetNextClosestItemEdge(...)
    ultraschall.LM(23)
    return ultraschall.GetNextClosestItemEdge(table.unpack({...}))
  end
  function ultraschall.GetPreviousClosestItemEdge(...)
    ultraschall.LM(23)
    return ultraschall.GetPreviousClosestItemEdge(table.unpack({...}))
  end
  function ultraschall.GetClosestNextMarker(...)
    ultraschall.LM(23)
    return ultraschall.GetClosestNextMarker(table.unpack({...}))
  end
  function ultraschall.GetClosestPreviousMarker(...)
    ultraschall.LM(23)
    return ultraschall.GetClosestPreviousMarker(table.unpack({...}))
  end
  function ultraschall.GetClosestNextRegionEdge(...)
    ultraschall.LM(23)
    return ultraschall.GetClosestNextRegionEdge(table.unpack({...}))
  end
  function ultraschall.GetClosestPreviousRegionEdge(...)
    ultraschall.LM(23)
    return ultraschall.GetClosestPreviousRegionEdge(table.unpack({...}))
  end
  function ultraschall.GetClosestGoToPoints(...)
    ultraschall.LM(23)
    return ultraschall.GetClosestGoToPoints(table.unpack({...}))
  end
  function ultraschall.CenterViewToCursor(...)
    ultraschall.LM(23)
    return ultraschall.CenterViewToCursor(table.unpack({...}))
  end
  function ultraschall.GetLastCursorPosition(...)
    ultraschall.LM(23)
    return ultraschall.GetLastCursorPosition(table.unpack({...}))
  end
  function ultraschall.GetLastPlayState(...)
    ultraschall.LM(23)
    return ultraschall.GetLastPlayState(table.unpack({...}))
  end
  function ultraschall.GetLastLoopState(...)
    ultraschall.LM(23)
    return ultraschall.GetLastLoopState(table.unpack({...}))
  end
  function ultraschall.GetLoopState(...)
    ultraschall.LM(23)
    return ultraschall.GetLoopState(table.unpack({...}))
  end
  function ultraschall.SetLoopState(...)
    ultraschall.LM(23)
    return ultraschall.SetLoopState(table.unpack({...}))
  end
  function ultraschall.Scrubbing_MoveCursor_GetToggleState(...)
    ultraschall.LM(23)
    return ultraschall.Scrubbing_MoveCursor_GetToggleState(table.unpack({...}))
  end
  function ultraschall.Scrubbing_MoveCursor_Toggle(...)
    ultraschall.LM(23)
    return ultraschall.Scrubbing_MoveCursor_Toggle(table.unpack({...}))
  end
  function ultraschall.GetNextClosestItemStart(...)
    ultraschall.LM(23)
    return ultraschall.GetNextClosestItemStart(table.unpack({...}))
  end
  function ultraschall.GetPreviousClosestItemStart(...)
    ultraschall.LM(23)
    return ultraschall.GetPreviousClosestItemStart(table.unpack({...}))
  end
  function ultraschall.GetPreviousClosestItemEnd(...)
    ultraschall.LM(23)
    return ultraschall.GetPreviousClosestItemEnd(table.unpack({...}))
  end
  function ultraschall.GetNextClosestItemEnd(...)
    ultraschall.LM(23)
    return ultraschall.GetNextClosestItemEnd(table.unpack({...}))
  end
  function ultraschall.GetProjectFilename(...)
    ultraschall.LM(24)
    return ultraschall.GetProjectFilename(table.unpack({...}))
  end
  function ultraschall.CheckForChangedProjectTabs(...)
    ultraschall.LM(24)
    return ultraschall.CheckForChangedProjectTabs(table.unpack({...}))
  end
  function ultraschall.IsValidProjectStateChunk(...)
    ultraschall.LM(24)
    return ultraschall.IsValidProjectStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProjectStateChunk(...)
    ultraschall.LM(24)
    return ultraschall.GetProjectStateChunk(table.unpack({...}))
  end
  function ultraschall.EnumProjects(...)
    ultraschall.LM(24)
    return ultraschall.EnumProjects(table.unpack({...}))
  end
  function ultraschall.GetProjectLength(...)
    ultraschall.LM(24)
    return ultraschall.GetProjectLength(table.unpack({...}))
  end
  function ultraschall.GetRecentProjects(...)
    ultraschall.LM(24)
    return ultraschall.GetRecentProjects(table.unpack({...}))
  end
  function ultraschall.IsValidProjectBayStateChunk(...)
    ultraschall.LM(24)
    return ultraschall.IsValidProjectBayStateChunk(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItems_FromProjectBayStateChunk(...)
    ultraschall.LM(24)
    return ultraschall.GetAllMediaItems_FromProjectBayStateChunk(table.unpack({...}))
  end
  function ultraschall.IsTimeSelectionActive(...)
    ultraschall.LM(24)
    return ultraschall.IsTimeSelectionActive(table.unpack({...}))
  end
  function ultraschall.GetProject_Author(...)
    ultraschall.LM(24)
    return ultraschall.GetProject_Author(table.unpack({...}))
  end
  function ultraschall.AutoSave_SetMinutes(...)
    ultraschall.LM(24)
    return ultraschall.AutoSave_SetMinutes(table.unpack({...}))
  end
  function ultraschall.AutoSave_GetMinutes(...)
    ultraschall.LM(24)
    return ultraschall.AutoSave_GetMinutes(table.unpack({...}))
  end
  function ultraschall.AutoSave_SetOptions(...)
    ultraschall.LM(24)
    return ultraschall.AutoSave_SetOptions(table.unpack({...}))
  end
  function ultraschall.AutoSave_GetOptions(...)
    ultraschall.LM(24)
    return ultraschall.AutoSave_GetOptions(table.unpack({...}))
  end
  function ultraschall.Main_SaveProject(...)
    ultraschall.LM(24)
    return ultraschall.Main_SaveProject(table.unpack({...}))
  end
  function ultraschall.GetProjectState_NumbersOnly(...)
    ultraschall.LM(25)
    return ultraschall.GetProjectState_NumbersOnly(table.unpack({...}))
  end
  function ultraschall.GetProject_ReaperVersion(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_ReaperVersion(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderCFG(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderCFG(table.unpack({...}))
  end
  function ultraschall.GetProject_RippleState(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RippleState(table.unpack({...}))
  end
  function ultraschall.GetProject_GroupOverride(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_GroupOverride(table.unpack({...}))
  end
  function ultraschall.GetProject_AutoCrossFade(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_AutoCrossFade(table.unpack({...}))
  end
  function ultraschall.GetProject_EnvAttach(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_EnvAttach(table.unpack({...}))
  end
  function ultraschall.GetProject_PooledEnvAttach(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_PooledEnvAttach(table.unpack({...}))
  end
  function ultraschall.GetProject_MixerUIFlags(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MixerUIFlags(table.unpack({...}))
  end
  function ultraschall.GetProject_PeakGain(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_PeakGain(table.unpack({...}))
  end
  function ultraschall.GetProject_Feedback(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Feedback(table.unpack({...}))
  end
  function ultraschall.GetProject_PanLaw(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_PanLaw(table.unpack({...}))
  end
  function ultraschall.GetProject_ProjOffsets(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_ProjOffsets(table.unpack({...}))
  end
  function ultraschall.GetProject_MaxProjectLength(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MaxProjectLength(table.unpack({...}))
  end
  function ultraschall.GetProject_Grid(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Grid(table.unpack({...}))
  end
  function ultraschall.GetProject_Timemode(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Timemode(table.unpack({...}))
  end
  function ultraschall.GetProject_VideoConfig(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_VideoConfig(table.unpack({...}))
  end
  function ultraschall.GetProject_PanMode(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_PanMode(table.unpack({...}))
  end
  function ultraschall.GetProject_CursorPos(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_CursorPos(table.unpack({...}))
  end
  function ultraschall.GetProject_HorizontalZoom(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_HorizontalZoom(table.unpack({...}))
  end
  function ultraschall.GetProject_VerticalZoom(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_VerticalZoom(table.unpack({...}))
  end
  function ultraschall.GetProject_UseRecConfig(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_UseRecConfig(table.unpack({...}))
  end
  function ultraschall.GetProject_RecMode(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RecMode(table.unpack({...}))
  end
  function ultraschall.GetProject_SMPTESync(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_SMPTESync(table.unpack({...}))
  end
  function ultraschall.GetProject_Loop(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Loop(table.unpack({...}))
  end
  function ultraschall.GetProject_LoopGran(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_LoopGran(table.unpack({...}))
  end
  function ultraschall.GetProject_RecPath(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RecPath(table.unpack({...}))
  end
  function ultraschall.GetProject_RecordCFG(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RecordCFG(table.unpack({...}))
  end
  function ultraschall.GetProject_ApplyFXCFG(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_ApplyFXCFG(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderPattern(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderPattern(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderFreqNChans(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderFreqNChans(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderSpeed(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderSpeed(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderRange(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderRange(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderResample(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderResample(table.unpack({...}))
  end
  function ultraschall.GetProject_AddMediaToProjectAfterRender(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_AddMediaToProjectAfterRender(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderStems(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderStems(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderDitherState(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderDitherState(table.unpack({...}))
  end
  function ultraschall.GetProject_TimeBase(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_TimeBase(table.unpack({...}))
  end
  function ultraschall.GetProject_TempoTimeSignature(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_TempoTimeSignature(table.unpack({...}))
  end
  function ultraschall.GetProject_ItemMixBehavior(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_ItemMixBehavior(table.unpack({...}))
  end
  function ultraschall.GetProject_DefPitchMode(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_DefPitchMode(table.unpack({...}))
  end
  function ultraschall.GetProject_TakeLane(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_TakeLane(table.unpack({...}))
  end
  function ultraschall.GetProject_SampleRate(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_SampleRate(table.unpack({...}))
  end
  function ultraschall.GetProject_TrackMixingDepth(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_TrackMixingDepth(table.unpack({...}))
  end
  function ultraschall.GetProject_TrackStateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_NumberOfTracks(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_NumberOfTracks(table.unpack({...}))
  end
  function ultraschall.GetProject_Selection(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Selection(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderQueueDelay(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderQueueDelay(table.unpack({...}))
  end
  function ultraschall.GetProject_QRenderOriginalProject(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_QRenderOriginalProject(table.unpack({...}))
  end
  function ultraschall.GetProject_QRenderOutFiles(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_QRenderOutFiles(table.unpack({...}))
  end
  function ultraschall.GetProject_MetaDataStateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MetaDataStateChunk(table.unpack({...}))
  end
  function ultraschall.SetProject_RippleState(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RippleState(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderQueueDelay(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderQueueDelay(table.unpack({...}))
  end
  function ultraschall.SetProject_Selection(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_Selection(table.unpack({...}))
  end
  function ultraschall.SetProject_GroupOverride(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_GroupOverride(table.unpack({...}))
  end
  function ultraschall.SetProject_AutoCrossFade(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_AutoCrossFade(table.unpack({...}))
  end
  function ultraschall.SetProject_EnvAttach(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_EnvAttach(table.unpack({...}))
  end
  function ultraschall.SetProject_MixerUIFlags(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MixerUIFlags(table.unpack({...}))
  end
  function ultraschall.SetProject_PeakGain(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_PeakGain(table.unpack({...}))
  end
  function ultraschall.SetProject_Feedback(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_Feedback(table.unpack({...}))
  end
  function ultraschall.SetProject_PanLaw(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_PanLaw(table.unpack({...}))
  end
  function ultraschall.SetProject_ProjOffsets(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_ProjOffsets(table.unpack({...}))
  end
  function ultraschall.SetProject_MaxProjectLength(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MaxProjectLength(table.unpack({...}))
  end
  function ultraschall.SetProject_Grid(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_Grid(table.unpack({...}))
  end
  function ultraschall.SetProject_Timemode(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_Timemode(table.unpack({...}))
  end
  function ultraschall.SetProject_VideoConfig(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_VideoConfig(table.unpack({...}))
  end
  function ultraschall.SetProject_PanMode(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_PanMode(table.unpack({...}))
  end
  function ultraschall.SetProject_CursorPos(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_CursorPos(table.unpack({...}))
  end
  function ultraschall.SetProject_HorizontalZoom(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_HorizontalZoom(table.unpack({...}))
  end
  function ultraschall.SetProject_VerticalZoom(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_VerticalZoom(table.unpack({...}))
  end
  function ultraschall.SetProject_UseRecConfig(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_UseRecConfig(table.unpack({...}))
  end
  function ultraschall.SetProject_RecMode(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RecMode(table.unpack({...}))
  end
  function ultraschall.SetProject_SMPTESync(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_SMPTESync(table.unpack({...}))
  end
  function ultraschall.SetProject_Loop(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_Loop(table.unpack({...}))
  end
  function ultraschall.SetProject_LoopGran(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_LoopGran(table.unpack({...}))
  end
  function ultraschall.SetProject_RecPath(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RecPath(table.unpack({...}))
  end
  function ultraschall.SetProject_RecordCFG(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RecordCFG(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderCFG(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderCFG(table.unpack({...}))
  end
  function ultraschall.SetProject_ApplyFXCFG(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_ApplyFXCFG(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderFilename(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderFilename(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderFreqNChans(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderFreqNChans(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderSpeed(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderSpeed(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderRange(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderRange(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderResample(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderResample(table.unpack({...}))
  end
  function ultraschall.SetProject_AddMediaToProjectAfterRender(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_AddMediaToProjectAfterRender(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderStems(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderStems(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderDitherState(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderDitherState(table.unpack({...}))
  end
  function ultraschall.SetProject_TimeBase(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_TimeBase(table.unpack({...}))
  end
  function ultraschall.SetProject_TempoTimeSignature(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_TempoTimeSignature(table.unpack({...}))
  end
  function ultraschall.SetProject_ItemMixBehavior(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_ItemMixBehavior(table.unpack({...}))
  end
  function ultraschall.SetProject_DefPitchMode(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_DefPitchMode(table.unpack({...}))
  end
  function ultraschall.SetProject_TakeLane(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_TakeLane(table.unpack({...}))
  end
  function ultraschall.SetProject_SampleRate(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_SampleRate(table.unpack({...}))
  end
  function ultraschall.SetProject_TrackMixingDepth(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_TrackMixingDepth(table.unpack({...}))
  end
  function ultraschall.GetProject_CountMarkersAndRegions(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_CountMarkersAndRegions(table.unpack({...}))
  end
  function ultraschall.GetProject_GetMarker(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_GetMarker(table.unpack({...}))
  end
  function ultraschall.GetProject_GetRegion(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_GetRegion(table.unpack({...}))
  end
  function ultraschall.GetProject_MarkersAndRegions(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MarkersAndRegions(table.unpack({...}))
  end
  function ultraschall.NewProjectTab(...)
    ultraschall.LM(25)
    return ultraschall.NewProjectTab(table.unpack({...}))
  end
  function ultraschall.GetCurrentTimeLengthOfFrame(...)
    ultraschall.LM(25)
    return ultraschall.GetCurrentTimeLengthOfFrame(table.unpack({...}))
  end
  function ultraschall.GetLengthOfFrames(...)
    ultraschall.LM(25)
    return ultraschall.GetLengthOfFrames(table.unpack({...}))
  end
  function ultraschall.ConvertOldProjectToCurrentReaperVersion(...)
    ultraschall.LM(25)
    return ultraschall.ConvertOldProjectToCurrentReaperVersion(table.unpack({...}))
  end
  function ultraschall.GetProject_ProjectBay(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_ProjectBay(table.unpack({...}))
  end
  function ultraschall.GetProject_Metronome(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Metronome(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterPlayspeed(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterPlayspeed(table.unpack({...}))
  end
  function ultraschall.GetProject_TempoEnvEx(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_TempoEnvEx(table.unpack({...}))
  end
  function ultraschall.GetProject_Extensions(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Extensions(table.unpack({...}))
  end
  function ultraschall.GetProject_Lock(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Lock(table.unpack({...}))
  end
  function ultraschall.GetProject_GlobalAuto(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_GlobalAuto(table.unpack({...}))
  end
  function ultraschall.GetProject_Tempo(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Tempo(table.unpack({...}))
  end
  function ultraschall.GetProject_Playrate(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Playrate(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterAutomode(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterAutomode(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterSel(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterSel(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterFXByp(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterFXByp(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterMuteSolo(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterMuteSolo(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterNChans(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterNChans(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterTrackHeight(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterTrackHeight(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterTrackColor(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterTrackColor(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterTrackView(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterTrackView(table.unpack({...}))
  end
  function ultraschall.GetProject_CountMasterHWOuts(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_CountMasterHWOuts(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterHWOut(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterHWOut(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterVolume(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterVolume(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterPanMode(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterPanMode(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterWidth(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterWidth(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterGroupFlagsState(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterGroupFlagsState(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterGroupFlagsHighState(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterGroupFlagsHighState(table.unpack({...}))
  end
  function ultraschall.GetProject_GroupDisabled(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_GroupDisabled(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterHWVolEnvStateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterHWVolEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterFXListStateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterFXListStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterDualPanEnvStateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterDualPanEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterDualPanEnv2StateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterDualPanEnv2StateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterDualPanEnvLStateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterDualPanEnvLStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterDualPanEnvL2StateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterDualPanEnvL2StateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterVolEnvStateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterVolEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterVolEnv2StateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterVolEnv2StateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterVolEnv3StateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterVolEnv3StateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterHWPanEnvStateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterHWPanEnvStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_MasterPanMode_Ex(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_MasterPanMode_Ex(table.unpack({...}))
  end
  function ultraschall.GetProject_TempoEnv_ExStateChunk(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_TempoEnv_ExStateChunk(table.unpack({...}))
  end
  function ultraschall.GetProject_Length(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Length(table.unpack({...}))
  end
  function ultraschall.CreateTemporaryFileOfProjectfile(...)
    ultraschall.LM(25)
    return ultraschall.CreateTemporaryFileOfProjectfile(table.unpack({...}))
  end
  function ultraschall.GetProject_Length(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Length(table.unpack({...}))
  end
  function ultraschall.SetProject_RenderPattern(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_RenderPattern(table.unpack({...}))
  end
  function ultraschall.GetProject_RenderFilename(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_RenderFilename(table.unpack({...}))
  end
  function ultraschall.GetProject_GroupName(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_GroupName(table.unpack({...}))
  end
  function ultraschall.SetProject_Lock(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_Lock(table.unpack({...}))
  end
  function ultraschall.SetProject_GlobalAuto(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_GlobalAuto(table.unpack({...}))
  end
  function ultraschall.SetProject_Tempo(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_Tempo(table.unpack({...}))
  end
  function ultraschall.SetProject_Playrate(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_Playrate(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterAutomode(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MasterAutomode(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterSel(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MasterSel(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterMuteSolo(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MasterMuteSolo(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterFXByp(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MasterFXByp(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterNChans(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MasterNChans(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterTrackHeight(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MasterTrackHeight(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterTrackColor(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MasterTrackColor(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterPanMode(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MasterPanMode(table.unpack({...}))
  end
  function ultraschall.SetProject_MasterTrackView(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_MasterTrackView(table.unpack({...}))
  end
  function ultraschall.GetProject_Render_Normalize(...)
    ultraschall.LM(25)
    return ultraschall.GetProject_Render_Normalize(table.unpack({...}))
  end
  function ultraschall.SetProject_Render_Normalize(...)
    ultraschall.LM(25)
    return ultraschall.SetProject_Render_Normalize(table.unpack({...}))
  end
  function ultraschall.RazorEdit_ProjectHasRazorEdit(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_ProjectHasRazorEdit(table.unpack({...}))
  end
  function ultraschall.RazorEdit_GetAllRazorEdits(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_GetAllRazorEdits(table.unpack({...}))
  end
  function ultraschall.RazorEdit_GetRazorEdits_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_GetRazorEdits_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Nudge_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Nudge_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Nudge_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Nudge_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_RemoveAllFromTrack(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_RemoveAllFromTrack(table.unpack({...}))
  end
  function ultraschall.RazorEdit_RemoveAllFromEnvelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_RemoveAllFromEnvelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_RemoveAllFromTrackAndEnvelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_RemoveAllFromTrackAndEnvelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Add_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Add_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Add_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Add_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Remove_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Remove_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Remove_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Remove_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_CountAreas_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_CountAreas_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_CountAreas_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_CountAreas_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Remove(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Remove(table.unpack({...}))
  end
  function ultraschall.RazorEdit_GetFromPoint(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_GetFromPoint(table.unpack({...}))
  end
  function ultraschall.RazorEdit_RemoveByIndex_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_RemoveByIndex_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_RemoveByIndex_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_RemoveByIndex_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_IsAtPosition_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_IsAtPosition_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_IsAtPosition_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_IsAtPosition_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_CheckForPossibleOverlap_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_CheckForPossibleOverlap_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_CheckForPossibleOverlap_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_CheckForPossibleOverlap_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Set_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Set_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Set_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Set_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Resize_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Resize_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_Resize_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_Resize_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_ResizeByFactor_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_ResizeByFactor_Track(table.unpack({...}))
  end
  function ultraschall.RazorEdit_ResizeByFactor_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_ResizeByFactor_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_GetBetween_Envelope(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_GetBetween_Envelope(table.unpack({...}))
  end
  function ultraschall.RazorEdit_GetBetween_Track(...)
    ultraschall.LM(26)
    return ultraschall.RazorEdit_GetBetween_Track(table.unpack({...}))
  end
  function ultraschall.AutoSearchReaMoteClients(...)
    ultraschall.LM(27)
    return ultraschall.AutoSearchReaMoteClients(table.unpack({...}))
  end
  function ultraschall.GetVerticalZoom(...)
    ultraschall.LM(28)
    return ultraschall.GetVerticalZoom(table.unpack({...}))
  end
  function ultraschall.SetVerticalZoom(...)
    ultraschall.LM(28)
    return ultraschall.SetVerticalZoom(table.unpack({...}))
  end
  function ultraschall.StoreArrangeviewSnapshot(...)
    ultraschall.LM(28)
    return ultraschall.StoreArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.IsValidArrangeviewSnapshot(...)
    ultraschall.LM(28)
    return ultraschall.IsValidArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.RetrieveArrangeviewSnapshot(...)
    ultraschall.LM(28)
    return ultraschall.RetrieveArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.RestoreArrangeviewSnapshot(...)
    ultraschall.LM(28)
    return ultraschall.RestoreArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.DeleteArrangeviewSnapshot(...)
    ultraschall.LM(28)
    return ultraschall.DeleteArrangeviewSnapshot(table.unpack({...}))
  end
  function ultraschall.SetIDEFontSize(...)
    ultraschall.LM(28)
    return ultraschall.SetIDEFontSize(table.unpack({...}))
  end
  function ultraschall.GetIDEFontSize(...)
    ultraschall.LM(28)
    return ultraschall.GetIDEFontSize(table.unpack({...}))
  end
  function ultraschall.GetPlayCursorWidth(...)
    ultraschall.LM(28)
    return ultraschall.GetPlayCursorWidth(table.unpack({...}))
  end
  function ultraschall.SetPlayCursorWidth(...)
    ultraschall.LM(28)
    return ultraschall.SetPlayCursorWidth(table.unpack({...}))
  end
  function ultraschall.GetScreenWidth(...)
    ultraschall.LM(28)
    return ultraschall.GetScreenWidth(table.unpack({...}))
  end
  function ultraschall.GetScreenHeight(...)
    ultraschall.LM(28)
    return ultraschall.GetScreenHeight(table.unpack({...}))
  end
  function ultraschall.ShowMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowMenu(table.unpack({...}))
  end
  function ultraschall.IsValidHWND(...)
    ultraschall.LM(28)
    return ultraschall.IsValidHWND(table.unpack({...}))
  end
  function ultraschall.BrowseForOpenFiles(...)
    ultraschall.LM(28)
    return ultraschall.BrowseForOpenFiles(table.unpack({...}))
  end
  function ultraschall.HasHWNDChildWindowNames(...)
    ultraschall.LM(28)
    return ultraschall.HasHWNDChildWindowNames(table.unpack({...}))
  end
  function ultraschall.CloseReaScriptConsole(...)
    ultraschall.LM(28)
    return ultraschall.CloseReaScriptConsole(table.unpack({...}))
  end
  function ultraschall.MB(...)
    ultraschall.LM(28)
    return ultraschall.MB(table.unpack({...}))
  end
  function ultraschall.GetTopmostHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetTopmostHWND(table.unpack({...}))
  end
  function ultraschall.GetReaperWindowAttributes(...)
    ultraschall.LM(28)
    return ultraschall.GetReaperWindowAttributes(table.unpack({...}))
  end
  function ultraschall.Windows_Find(...)
    ultraschall.LM(28)
    return ultraschall.Windows_Find(table.unpack({...}))
  end
  function ultraschall.GetAllReaScriptIDEWindows(...)
    ultraschall.LM(28)
    return ultraschall.GetAllReaScriptIDEWindows(table.unpack({...}))
  end
  function ultraschall.GetReaScriptConsoleWindow(...)
    ultraschall.LM(28)
    return ultraschall.GetReaScriptConsoleWindow(table.unpack({...}))
  end
  function ultraschall.GetHWND_ArrangeViewAndTimeLine(...)
    ultraschall.LM(28)
    return ultraschall.GetHWND_ArrangeViewAndTimeLine(table.unpack({...}))
  end
  function ultraschall.GetVerticalScroll(...)
    ultraschall.LM(28)
    return ultraschall.GetVerticalScroll(table.unpack({...}))
  end
  function ultraschall.SetVerticalScroll(...)
    ultraschall.LM(28)
    return ultraschall.SetVerticalScroll(table.unpack({...}))
  end
  function ultraschall.SetVerticalRelativeScroll(...)
    ultraschall.LM(28)
    return ultraschall.SetVerticalRelativeScroll(table.unpack({...}))
  end
  function ultraschall.GetUserInputs(...)
    ultraschall.LM(28)
    return ultraschall.GetUserInputs(table.unpack({...}))
  end
  function ultraschall.GetRenderToFileHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetRenderToFileHWND(table.unpack({...}))
  end
  function ultraschall.GetActionsHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetActionsHWND(table.unpack({...}))
  end
  function ultraschall.GetVideoHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetVideoHWND(table.unpack({...}))
  end
  function ultraschall.GetRenderQueueHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetRenderQueueHWND(table.unpack({...}))
  end
  function ultraschall.GetProjectSettingsHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetProjectSettingsHWND(table.unpack({...}))
  end
  function ultraschall.GetPreferencesHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetPreferencesHWND(table.unpack({...}))
  end
  function ultraschall.GetSaveLiveOutputToDiskHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetSaveLiveOutputToDiskHWND(table.unpack({...}))
  end
  function ultraschall.GetConsolidateTracksHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetConsolidateTracksHWND(table.unpack({...}))
  end
  function ultraschall.GetExportProjectMIDIHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetExportProjectMIDIHWND(table.unpack({...}))
  end
  function ultraschall.GetProjectDirectoryCleanupHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetProjectDirectoryCleanupHWND(table.unpack({...}))
  end
  function ultraschall.GetBatchFileItemConverterHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetBatchFileItemConverterHWND(table.unpack({...}))
  end
  function ultraschall.SetReaScriptConsole_FontStyle(...)
    ultraschall.LM(28)
    return ultraschall.SetReaScriptConsole_FontStyle(table.unpack({...}))
  end
  function ultraschall.MoveChildWithinParentHWND(...)
    ultraschall.LM(28)
    return ultraschall.MoveChildWithinParentHWND(table.unpack({...}))
  end
  function ultraschall.GetChildSizeWithinParentHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetChildSizeWithinParentHWND(table.unpack({...}))
  end
  function ultraschall.GetCheckboxState(...)
    ultraschall.LM(28)
    return ultraschall.GetCheckboxState(table.unpack({...}))
  end
  function ultraschall.SetCheckboxState(...)
    ultraschall.LM(28)
    return ultraschall.SetCheckboxState(table.unpack({...}))
  end
  function ultraschall.GetRenderingToFileHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetRenderingToFileHWND(table.unpack({...}))
  end
  function ultraschall.ConvertScreen2ClientXCoordinate_ReaperWindow(...)
    ultraschall.LM(28)
    return ultraschall.ConvertScreen2ClientXCoordinate_ReaperWindow(table.unpack({...}))
  end
  function ultraschall.ConvertClient2ScreenXCoordinate_ReaperWindow(...)
    ultraschall.LM(28)
    return ultraschall.ConvertClient2ScreenXCoordinate_ReaperWindow(table.unpack({...}))
  end
  function ultraschall.SetReaperWindowToSize(...)
    ultraschall.LM(28)
    return ultraschall.SetReaperWindowToSize(table.unpack({...}))
  end
  function ultraschall.ConvertYCoordsMac2Win(...)
    ultraschall.LM(28)
    return ultraschall.ConvertYCoordsMac2Win(table.unpack({...}))
  end
  function ultraschall.GetMediaExplorerHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetMediaExplorerHWND(table.unpack({...}))
  end
  function ultraschall.GetTimeByMouseXPosition(...)
    ultraschall.LM(28)
    return ultraschall.GetTimeByMouseXPosition(table.unpack({...}))
  end
  function ultraschall.ShowTrackInputMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowTrackInputMenu(table.unpack({...}))
  end
  function ultraschall.ShowTrackPanelMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowTrackPanelMenu(table.unpack({...}))
  end
  function ultraschall.ShowTrackAreaMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowTrackAreaMenu(table.unpack({...}))
  end
  function ultraschall.ShowTrackRoutingMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowTrackRoutingMenu(table.unpack({...}))
  end
  function ultraschall.ShowRulerMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowRulerMenu(table.unpack({...}))
  end
  function ultraschall.ShowMediaItemMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowMediaItemMenu(table.unpack({...}))
  end
  function ultraschall.ShowEnvelopeMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowEnvelopeMenu(table.unpack({...}))
  end
  function ultraschall.ShowEnvelopePointMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowEnvelopePointMenu(table.unpack({...}))
  end
  function ultraschall.ShowEnvelopePointMenu_AutomationItem(...)
    ultraschall.LM(28)
    return ultraschall.ShowEnvelopePointMenu_AutomationItem(table.unpack({...}))
  end
  function ultraschall.ShowAutomationItemMenu(...)
    ultraschall.LM(28)
    return ultraschall.ShowAutomationItemMenu(table.unpack({...}))
  end
  function ultraschall.GetSaveProjectAsHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetSaveProjectAsHWND(table.unpack({...}))
  end
  function ultraschall.SetHelpDisplayMode(...)
    ultraschall.LM(28)
    return ultraschall.SetHelpDisplayMode(table.unpack({...}))
  end
  function ultraschall.GetHelpDisplayMode(...)
    ultraschall.LM(28)
    return ultraschall.GetHelpDisplayMode(table.unpack({...}))
  end
  function ultraschall.WiringDiagram_SetOptions(...)
    ultraschall.LM(28)
    return ultraschall.WiringDiagram_SetOptions(table.unpack({...}))
  end
  function ultraschall.WiringDiagram_GetOptions(...)
    ultraschall.LM(28)
    return ultraschall.WiringDiagram_GetOptions(table.unpack({...}))
  end
  function ultraschall.GetTCPWidth(...)
    ultraschall.LM(28)
    return ultraschall.GetTCPWidth(table.unpack({...}))
  end
  function ultraschall.VideoWindow_FullScreenToggle(...)
    ultraschall.LM(28)
    return ultraschall.VideoWindow_FullScreenToggle(table.unpack({...}))
  end
  function ultraschall.PreventUIRefresh(...)
    ultraschall.LM(28)
    return ultraschall.PreventUIRefresh(table.unpack({...}))
  end
  function ultraschall.RestoreUIRefresh(...)
    ultraschall.LM(28)
    return ultraschall.RestoreUIRefresh(table.unpack({...}))
  end
  function ultraschall.GetPreventUIRefreshCount(...)
    ultraschall.LM(28)
    return ultraschall.GetPreventUIRefreshCount(table.unpack({...}))
  end
  function ultraschall.SetItemButtonsVisible(...)
    ultraschall.LM(28)
    return ultraschall.SetItemButtonsVisible(table.unpack({...}))
  end
  function ultraschall.GetItemButtonsVisible(...)
    ultraschall.LM(28)
    return ultraschall.GetItemButtonsVisible(table.unpack({...}))
  end
  function ultraschall.TCP_SetWidth(...)
    ultraschall.LM(28)
    return ultraschall.TCP_SetWidth(table.unpack({...}))
  end
  function ultraschall.GetTrackManagerHWND(...)
    ultraschall.LM(28)
    return ultraschall.GetTrackManagerHWND(table.unpack({...}))
  end
  function ultraschall.SetTimeUnit(...)
    ultraschall.LM(28)
    return ultraschall.SetTimeUnit(table.unpack({...}))
  end
  function ultraschall.ReturnAllChildHWND(...)
    ultraschall.LM(28)
    return ultraschall.ReturnAllChildHWND(table.unpack({...}))
  end
  function ultraschall.SetUIScale(...)
    ultraschall.LM(28)
    return ultraschall.SetUIScale(table.unpack({...}))
  end
  function ultraschall.GetUIScale(...)
    ultraschall.LM(28)
    return ultraschall.GetUIScale(table.unpack({...}))
  end
  function ultraschall.GetHWND_Transport(...)
    ultraschall.LM(28)
    return ultraschall.GetHWND_Transport(table.unpack({...}))
  end
  function ultraschall.GetHWND_TCP(...)
    ultraschall.LM(28)
    return ultraschall.GetHWND_TCP(table.unpack({...}))
  end
  function ultraschall.GetHWND_ArrangeView(...)
    ultraschall.LM(28)
    return ultraschall.GetHWND_ArrangeView(table.unpack({...}))
  end
  function ultraschall.GetScaleRangeFromDpi(...)
    ultraschall.LM(28)
    return ultraschall.GetScaleRangeFromDpi(table.unpack({...}))
  end
  function ultraschall.GetDpiFromScale(...)
    ultraschall.LM(28)
    return ultraschall.GetDpiFromScale(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_FLAC(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_FLAC(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_AIFF(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_AIFF(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_AudioCD(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_AudioCD(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MP3(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3MaxQuality(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MP3MaxQuality(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3CBR(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MP3CBR(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3VBR(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MP3VBR(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP3ABR(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MP3ABR(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_OGG(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_OGG(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_OPUS(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_OPUS(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_GIF(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_GIF(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_LCF(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_LCF(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_WAV(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_WAV(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_WAVPACK(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_WAVPACK(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_WebM_Video(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_WebM_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MKV_Video(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MKV_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_AVI_Video(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_AVI_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_QTMOVMP4_Video(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_QTMOVMP4_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_DDP(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_DDP(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_GIF(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_GIF(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_LCF(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_LCF(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_WebM_Video(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_WebM_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MKV_Video(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_MKV_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_QTMOVMP4_Video(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_QTMOVMP4_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_AVI_Video(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_AVI_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MP4Mac_Video(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MP4Mac_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MOVMac_Video(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MOVMac_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_M4AMac(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_M4AMac(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP4MAC_Video(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_MP4MAC_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_M4AMAC(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_M4AMAC(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MOVMAC_Video(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_MOVMAC_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderTable_Project(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderTable_Project(table.unpack({...}))
  end
  function ultraschall.GetRenderTable_ProjectFile(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderTable_ProjectFile(table.unpack({...}))
  end
  function ultraschall.GetOutputFormat_RenderCfg(...)
    ultraschall.LM(29)
    return ultraschall.GetOutputFormat_RenderCfg(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_Opus(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_Opus(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_OGG(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_OGG(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_DDP(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_DDP(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_FLAC(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_FLAC(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_WAVPACK(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_WAVPACK(table.unpack({...}))
  end
  function ultraschall.IsValidRenderTable(...)
    ultraschall.LM(29)
    return ultraschall.IsValidRenderTable(table.unpack({...}))
  end
  function ultraschall.ApplyRenderTable_Project(...)
    ultraschall.LM(29)
    return ultraschall.ApplyRenderTable_Project(table.unpack({...}))
  end
  function ultraschall.ApplyRenderTable_ProjectFile(...)
    ultraschall.LM(29)
    return ultraschall.ApplyRenderTable_ProjectFile(table.unpack({...}))
  end
  function ultraschall.CreateNewRenderTable(...)
    ultraschall.LM(29)
    return ultraschall.CreateNewRenderTable(table.unpack({...}))
  end
  function ultraschall.GetRender_SaveCopyOfProject(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_SaveCopyOfProject(table.unpack({...}))
  end
  function ultraschall.SetRender_QueueDelay(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_QueueDelay(table.unpack({...}))
  end
  function ultraschall.SetRender_SaveCopyOfProject(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_SaveCopyOfProject(table.unpack({...}))
  end
  function ultraschall.GetRender_QueueDelay(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_QueueDelay(table.unpack({...}))
  end
  function ultraschall.SetRender_ProjectSampleRateForMix(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_ProjectSampleRateForMix(table.unpack({...}))
  end
  function ultraschall.GetRender_ProjectSampleRateForMix(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_ProjectSampleRateForMix(table.unpack({...}))
  end
  function ultraschall.SetRender_AutoIncrementFilename(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_AutoIncrementFilename(table.unpack({...}))
  end
  function ultraschall.GetRender_AutoIncrementFilename(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_AutoIncrementFilename(table.unpack({...}))
  end
  function ultraschall.GetRenderPreset_Names(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderPreset_Names(table.unpack({...}))
  end
  function ultraschall.GetRenderPreset_RenderTable(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderPreset_RenderTable(table.unpack({...}))
  end
  function ultraschall.DeleteRenderPreset_Bounds(...)
    ultraschall.LM(29)
    return ultraschall.DeleteRenderPreset_Bounds(table.unpack({...}))
  end
  function ultraschall.DeleteRenderPreset_FormatOptions(...)
    ultraschall.LM(29)
    return ultraschall.DeleteRenderPreset_FormatOptions(table.unpack({...}))
  end
  function ultraschall.AddRenderPreset(...)
    ultraschall.LM(29)
    return ultraschall.AddRenderPreset(table.unpack({...}))
  end
  function ultraschall.SetRenderPreset(...)
    ultraschall.LM(29)
    return ultraschall.SetRenderPreset(table.unpack({...}))
  end
  function ultraschall.RenderProject_RenderTable(...)
    ultraschall.LM(29)
    return ultraschall.RenderProject_RenderTable(table.unpack({...}))
  end
  function ultraschall.GetRenderQueuedProjects(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderQueuedProjects(table.unpack({...}))
  end
  function ultraschall.AddProjectFileToRenderQueue(...)
    ultraschall.LM(29)
    return ultraschall.AddProjectFileToRenderQueue(table.unpack({...}))
  end
  function ultraschall.RenderProject_RenderQueue(...)
    ultraschall.LM(29)
    return ultraschall.RenderProject_RenderQueue(table.unpack({...}))
  end
  function ultraschall.RenderProject(...)
    ultraschall.LM(29)
    return ultraschall.RenderProject(table.unpack({...}))
  end
  function ultraschall.RenderProject_Regions(...)
    ultraschall.LM(29)
    return ultraschall.RenderProject_Regions(table.unpack({...}))
  end
  function ultraschall.AddSelectedItemsToRenderQueue(...)
    ultraschall.LM(29)
    return ultraschall.AddSelectedItemsToRenderQueue(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP3MaxQuality(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_MP3MaxQuality(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP3VBR(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_MP3VBR(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP3ABR(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_MP3ABR(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MP3CBR(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_MP3CBR(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_WAV(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_WAV(table.unpack({...}))
  end
  function ultraschall.GetLastUsedRenderPatterns(...)
    ultraschall.LM(29)
    return ultraschall.GetLastUsedRenderPatterns(table.unpack({...}))
  end
  function ultraschall.GetLastRenderPaths(...)
    ultraschall.LM(29)
    return ultraschall.GetLastRenderPaths(table.unpack({...}))
  end
  function ultraschall.IsReaperRendering(...)
    ultraschall.LM(29)
    return ultraschall.IsReaperRendering(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_AIFF(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_AIFF(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_AudioCD(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_AudioCD(table.unpack({...}))
  end
  function ultraschall.GetRender_EmbedStretchMarkers(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_EmbedStretchMarkers(table.unpack({...}))
  end
  function ultraschall.SetRender_EmbedStretchMarkers(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_EmbedStretchMarkers(table.unpack({...}))
  end
  function ultraschall.Render_Loop(...)
    ultraschall.LM(29)
    return ultraschall.Render_Loop(table.unpack({...}))
  end
  function ultraschall.GetRender_EmbedMetaData(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_EmbedMetaData(table.unpack({...}))
  end
  function ultraschall.SetRender_EmbedMetaData(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_EmbedMetaData(table.unpack({...}))
  end
  function ultraschall.SetRender_OfflineOnlineMode(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_OfflineOnlineMode(table.unpack({...}))
  end
  function ultraschall.GetRender_OfflineOnlineMode(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_OfflineOnlineMode(table.unpack({...}))
  end
  function ultraschall.GetRender_ResampleMode(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_ResampleMode(table.unpack({...}))
  end
  function ultraschall.SetRender_ResampleMode(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_ResampleMode(table.unpack({...}))
  end
  function ultraschall.GetRender_NoSilentFiles(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_NoSilentFiles(table.unpack({...}))
  end
  function ultraschall.SetRender_NoSilentFiles(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_NoSilentFiles(table.unpack({...}))
  end
  function ultraschall.GetRender_AddRenderedFilesToProject(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_AddRenderedFilesToProject(table.unpack({...}))
  end
  function ultraschall.SetRender_AddRenderedFilesToProject(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_AddRenderedFilesToProject(table.unpack({...}))
  end
  function ultraschall.GetRender_TailLength(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_TailLength(table.unpack({...}))
  end
  function ultraschall.SetRender_TailLength(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_TailLength(table.unpack({...}))
  end
  function ultraschall.AreRenderTablesEqual(...)
    ultraschall.LM(29)
    return ultraschall.AreRenderTablesEqual(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_CAF(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_CAF(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_CAF(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_CAF(table.unpack({...}))
  end
  function ultraschall.GetRenderTargetFiles(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderTargetFiles(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MPEG1_Video(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MPEG1_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_MPEG2_Video(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_MPEG2_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_FLV_Video(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_FLV_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MPEG1_Video(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_MPEG1_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_MPEG2_Video(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_MPEG2_Video(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_FLV_Video(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_FLV_Video(table.unpack({...}))
  end
  function ultraschall.GetRenderTable_ProjectDefaults(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderTable_ProjectDefaults(table.unpack({...}))
  end
  function ultraschall.GetSetRenderBlocksize(...)
    ultraschall.LM(29)
    return ultraschall.GetSetRenderBlocksize(table.unpack({...}))
  end
  function ultraschall.GetRenderCFG_Settings_WMF(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderCFG_Settings_WMF(table.unpack({...}))
  end
  function ultraschall.CreateRenderCFG_WMF(...)
    ultraschall.LM(29)
    return ultraschall.CreateRenderCFG_WMF(table.unpack({...}))
  end
  function ultraschall.ResolvePresetName(...)
    ultraschall.LM(29)
    return ultraschall.ResolvePresetName(table.unpack({...}))
  end
  function ultraschall.SetRender_SaveRenderStats(...)
    ultraschall.LM(29)
    return ultraschall.SetRender_SaveRenderStats(table.unpack({...}))
  end
  function ultraschall.GetRender_SaveRenderStats(...)
    ultraschall.LM(29)
    return ultraschall.GetRender_SaveRenderStats(table.unpack({...}))
  end
  function ultraschall.StoreRenderTable_ProjExtState(...)
    ultraschall.LM(29)
    return ultraschall.StoreRenderTable_ProjExtState(table.unpack({...}))
  end
  function ultraschall.GetRenderTable_ProjExtState(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderTable_ProjExtState(table.unpack({...}))
  end
  function ultraschall.StoreRenderTable_ExtState(...)
    ultraschall.LM(29)
    return ultraschall.StoreRenderTable_ExtState(table.unpack({...}))
  end
  function ultraschall.GetRenderTable_ExtState(...)
    ultraschall.LM(29)
    return ultraschall.GetRenderTable_ExtState(table.unpack({...}))
  end
  function ultraschall.GetAllThemeLayoutNames(...)
    ultraschall.LM(30)
    return ultraschall.GetAllThemeLayoutNames(table.unpack({...}))
  end
  function ultraschall.GetAllThemeLayoutParameters(...)
    ultraschall.LM(30)
    return ultraschall.GetAllThemeLayoutParameters(table.unpack({...}))
  end
  function ultraschall.ApplyAllThemeLayoutParameters(...)
    ultraschall.LM(30)
    return ultraschall.ApplyAllThemeLayoutParameters(table.unpack({...}))
  end
  function ultraschall.GetThemeParameterIndexByName(...)
    ultraschall.LM(30)
    return ultraschall.GetThemeParameterIndexByName(table.unpack({...}))
  end
  function ultraschall.SetThemeParameterIndexByName(...)
    ultraschall.LM(30)
    return ultraschall.SetThemeParameterIndexByName(table.unpack({...}))
  end
  function ultraschall.GetThemeParameterIndexByDescription(...)
    ultraschall.LM(30)
    return ultraschall.GetThemeParameterIndexByDescription(table.unpack({...}))
  end
  function ultraschall.SetThemeParameterIndexByDescription(...)
    ultraschall.LM(30)
    return ultraschall.SetThemeParameterIndexByDescription(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetHideTCPElement(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetHideTCPElement(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetHideTCPElement(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetHideTCPElement(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTCPNameSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTCPNameSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTCPNameSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTCPNameSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTCPVolumeSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTCPVolumeSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTCPVolumeSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTCPVolumeSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTCPInputSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTCPInputSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTCPInputSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTCPInputSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTCPMeterSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTCPMeterSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTCPMeterSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTCPMeterSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTCPMeterLocation(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTCPMeterLocation(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTCPMeterLocation(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTCPMeterLocation(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTCPFolderIndent(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTCPFolderIndent(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTCPFolderIndent(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTCPFolderIndent(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTCPAlignControls(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTCPAlignControls(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTCPAlignControls(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTCPAlignControls(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetMCPAlignControls(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetMCPAlignControls(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetMCPAlignControls(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetMCPAlignControls(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTransSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTransSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTransSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTransSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTransPlayRateSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTransPlayRateSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTransPlayRateSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTransPlayRateSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetEnvNameSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetEnvNameSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetEnvNameSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetEnvNameSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetEnvFaderSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetEnvFaderSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetEnvFaderSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetEnvFaderSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetEnvFolderIndent(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetEnvFolderIndent(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetEnvFolderIndent(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetEnvFolderIndent(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetEnvSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetEnvSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetEnvSize(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetEnvSize(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetMCPFolderIndent(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetMCPFolderIndent(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetMCPFolderIndent(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetMCPFolderIndent(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetStyleMCPElement(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetStyleMCPElement(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetStyleMCPElement(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetStyleMCPElement(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetMCPBorderStyle(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetMCPBorderStyle(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetMCPBorderStyle(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetMCPBorderStyle(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetMCPMeterExpansion(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetMCPMeterExpansion(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetMCPMeterExpansion(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetMCPMeterExpansion(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetMCPSizeAndLayout(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetMCPSizeAndLayout(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_SetTCPSizeAndLayout(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_SetTCPSizeAndLayout(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetTCPSizeAndLayout(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetTCPSizeAndLayout(table.unpack({...}))
  end
  function ultraschall.Theme_Defaultv6_GetMCPSizeAndLayout(...)
    ultraschall.LM(30)
    return ultraschall.Theme_Defaultv6_GetMCPSizeAndLayout(table.unpack({...}))
  end
  function ultraschall.GetTrack_ThemeElementPositions(...)
    ultraschall.LM(30)
    return ultraschall.GetTrack_ThemeElementPositions(table.unpack({...}))
  end
  function ultraschall.GetAllThemeElements(...)
    ultraschall.LM(30)
    return ultraschall.GetAllThemeElements(table.unpack({...}))
  end
  function ultraschall.IsValidTrackString(...)
    ultraschall.LM(31)
    return ultraschall.IsValidTrackString(table.unpack({...}))
  end
  function ultraschall.IsValidTrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.IsValidTrackStateChunk(table.unpack({...}))
  end
  function ultraschall.CreateTrackString(...)
    ultraschall.LM(31)
    return ultraschall.CreateTrackString(table.unpack({...}))
  end
  function ultraschall.CreateTrackString_SelectedTracks(...)
    ultraschall.LM(31)
    return ultraschall.CreateTrackString_SelectedTracks(table.unpack({...}))
  end
  function ultraschall.InsertTrack_TrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.InsertTrack_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveDuplicateTracksInTrackstring(...)
    ultraschall.LM(31)
    return ultraschall.RemoveDuplicateTracksInTrackstring(table.unpack({...}))
  end
  function ultraschall.IsTrackObjectTracknumber(...)
    ultraschall.LM(31)
    return ultraschall.IsTrackObjectTracknumber(table.unpack({...}))
  end
  function ultraschall.InverseTrackstring(...)
    ultraschall.LM(31)
    return ultraschall.InverseTrackstring(table.unpack({...}))
  end
  function ultraschall.CountItemsInTrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.CountItemsInTrackStateChunk(table.unpack({...}))
  end
  function ultraschall.GetItemStateChunkFromTrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.GetItemStateChunkFromTrackStateChunk(table.unpack({...}))
  end
  function ultraschall.AddMediaItemStateChunk_To_TrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.AddMediaItemStateChunk_To_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveMediaItem_TrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.RemoveMediaItem_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveMediaItemByIGUID_TrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.RemoveMediaItemByIGUID_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.RemoveMediaItemByGUID_TrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.RemoveMediaItemByGUID_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.OnlyTracksInBothTrackstrings(...)
    ultraschall.LM(31)
    return ultraschall.OnlyTracksInBothTrackstrings(table.unpack({...}))
  end
  function ultraschall.OnlyTracksInOneTrackstring(...)
    ultraschall.LM(31)
    return ultraschall.OnlyTracksInOneTrackstring(table.unpack({...}))
  end
  function ultraschall.SetMediaItemStateChunk_in_TrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.SetMediaItemStateChunk_in_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.GetAllMediaItemsFromTrackStateChunk(...)
    ultraschall.LM(31)
    return ultraschall.GetAllMediaItemsFromTrackStateChunk(table.unpack({...}))
  end
  function ultraschall.CreateTrackString_AllTracks(...)
    ultraschall.LM(31)
    return ultraschall.CreateTrackString_AllTracks(table.unpack({...}))
  end
  function ultraschall.GetTrackLength(...)
    ultraschall.LM(31)
    return ultraschall.GetTrackLength(table.unpack({...}))
  end
  function ultraschall.GetLengthOfAllMediaItems_Track(...)
    ultraschall.LM(31)
    return ultraschall.GetLengthOfAllMediaItems_Track(table.unpack({...}))
  end
  function ultraschall.ApplyActionToTrack(...)
    ultraschall.LM(31)
    return ultraschall.ApplyActionToTrack(table.unpack({...}))
  end
  function ultraschall.InsertTrackAtIndex(...)
    ultraschall.LM(31)
    return ultraschall.InsertTrackAtIndex(table.unpack({...}))
  end
  function ultraschall.MoveTracks(...)
    ultraschall.LM(31)
    return ultraschall.MoveTracks(table.unpack({...}))
  end
  function ultraschall.CreateTrackString_ArmedTracks(...)
    ultraschall.LM(31)
    return ultraschall.CreateTrackString_ArmedTracks(table.unpack({...}))
  end
  function ultraschall.CreateTrackString_UnarmedTracks(...)
    ultraschall.LM(31)
    return ultraschall.CreateTrackString_UnarmedTracks(table.unpack({...}))
  end
  function ultraschall.CreateTrackStringByGUID(...)
    ultraschall.LM(31)
    return ultraschall.CreateTrackStringByGUID(table.unpack({...}))
  end
  function ultraschall.CreateTrackStringByTracknames(...)
    ultraschall.LM(31)
    return ultraschall.CreateTrackStringByTracknames(table.unpack({...}))
  end
  function ultraschall.CreateTrackStringByMediaTracks(...)
    ultraschall.LM(31)
    return ultraschall.CreateTrackStringByMediaTracks(table.unpack({...}))
  end
  function ultraschall.GetTracknumberByGuid(...)
    ultraschall.LM(31)
    return ultraschall.GetTracknumberByGuid(table.unpack({...}))
  end
  function ultraschall.DeleteTracks_TrackString(...)
    ultraschall.LM(31)
    return ultraschall.DeleteTracks_TrackString(table.unpack({...}))
  end
  function ultraschall.AnyTrackMute(...)
    ultraschall.LM(31)
    return ultraschall.AnyTrackMute(table.unpack({...}))
  end
  function ultraschall.AnyTrackRecarmed(...)
    ultraschall.LM(31)
    return ultraschall.AnyTrackRecarmed(table.unpack({...}))
  end
  function ultraschall.AnyTrackPhased(...)
    ultraschall.LM(31)
    return ultraschall.AnyTrackPhased(table.unpack({...}))
  end
  function ultraschall.AnyTrackRecMonitored(...)
    ultraschall.LM(31)
    return ultraschall.AnyTrackRecMonitored(table.unpack({...}))
  end
  function ultraschall.AnyTrackHiddenTCP(...)
    ultraschall.LM(31)
    return ultraschall.AnyTrackHiddenTCP(table.unpack({...}))
  end
  function ultraschall.AnyTrackHiddenMCP(...)
    ultraschall.LM(31)
    return ultraschall.AnyTrackHiddenMCP(table.unpack({...}))
  end
  function ultraschall.AnyTrackFreeItemPositioningMode(...)
    ultraschall.LM(31)
    return ultraschall.AnyTrackFreeItemPositioningMode(table.unpack({...}))
  end
  function ultraschall.AnyTrackFXBypass(...)
    ultraschall.LM(31)
    return ultraschall.AnyTrackFXBypass(table.unpack({...}))
  end
  function ultraschall.SetTrack_LastTouched(...)
    ultraschall.LM(31)
    return ultraschall.SetTrack_LastTouched(table.unpack({...}))
  end
  function ultraschall.GetTrackByTrackName(...)
    ultraschall.LM(31)
    return ultraschall.GetTrackByTrackName(table.unpack({...}))
  end
  function ultraschall.CollapseTrackHeight(...)
    ultraschall.LM(31)
    return ultraschall.CollapseTrackHeight(table.unpack({...}))
  end
  function ultraschall.SetTrack_Trackheight_Force(...)
    ultraschall.LM(31)
    return ultraschall.SetTrack_Trackheight_Force(table.unpack({...}))
  end
  function ultraschall.GetAllVisibleTracks_Arrange(...)
    ultraschall.LM(31)
    return ultraschall.GetAllVisibleTracks_Arrange(table.unpack({...}))
  end
  function ultraschall.IsTrackVisible(...)
    ultraschall.LM(31)
    return ultraschall.IsTrackVisible(table.unpack({...}))
  end
  function ultraschall.GetTrackHWOut(...)
    ultraschall.LM(32)
    return ultraschall.GetTrackHWOut(table.unpack({...}))
  end
  function ultraschall.GetTrackAUXSendReceives(...)
    ultraschall.LM(32)
    return ultraschall.GetTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.CountTrackHWOuts(...)
    ultraschall.LM(32)
    return ultraschall.CountTrackHWOuts(table.unpack({...}))
  end
  function ultraschall.CountTrackAUXSendReceives(...)
    ultraschall.LM(32)
    return ultraschall.CountTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.AddTrackHWOut(...)
    ultraschall.LM(32)
    return ultraschall.AddTrackHWOut(table.unpack({...}))
  end
  function ultraschall.AddTrackAUXSendReceives(...)
    ultraschall.LM(32)
    return ultraschall.AddTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.DeleteTrackHWOut(...)
    ultraschall.LM(32)
    return ultraschall.DeleteTrackHWOut(table.unpack({...}))
  end
  function ultraschall.DeleteTrackAUXSendReceives(...)
    ultraschall.LM(32)
    return ultraschall.DeleteTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.SetTrackHWOut(...)
    ultraschall.LM(32)
    return ultraschall.SetTrackHWOut(table.unpack({...}))
  end
  function ultraschall.SetTrackAUXSendReceives(...)
    ultraschall.LM(32)
    return ultraschall.SetTrackAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.ClearRoutingMatrix(...)
    ultraschall.LM(32)
    return ultraschall.ClearRoutingMatrix(table.unpack({...}))
  end
  function ultraschall.ClearRoutingMatrix(...)
    ultraschall.LM(32)
    return ultraschall.ClearRoutingMatrix(table.unpack({...}))
  end
  function ultraschall.GetAllHWOuts(...)
    ultraschall.LM(32)
    return ultraschall.GetAllHWOuts(table.unpack({...}))
  end
  function ultraschall.ApplyAllHWOuts(...)
    ultraschall.LM(32)
    return ultraschall.ApplyAllHWOuts(table.unpack({...}))
  end
  function ultraschall.GetAllAUXSendReceives(...)
    ultraschall.LM(32)
    return ultraschall.GetAllAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.ApplyAllAUXSendReceives(...)
    ultraschall.LM(32)
    return ultraschall.ApplyAllAUXSendReceives(table.unpack({...}))
  end
  function ultraschall.GetAllMainSendStates(...)
    ultraschall.LM(32)
    return ultraschall.GetAllMainSendStates(table.unpack({...}))
  end
  function ultraschall.ApplyAllMainSendStates(...)
    ultraschall.LM(32)
    return ultraschall.ApplyAllMainSendStates(table.unpack({...}))
  end
  function ultraschall.AreHWOutsTablesEqual(...)
    ultraschall.LM(32)
    return ultraschall.AreHWOutsTablesEqual(table.unpack({...}))
  end
  function ultraschall.AreMainSendsTablesEqual(...)
    ultraschall.LM(32)
    return ultraschall.AreMainSendsTablesEqual(table.unpack({...}))
  end
  function ultraschall.AreAUXSendReceivesTablesEqual(...)
    ultraschall.LM(32)
    return ultraschall.AreAUXSendReceivesTablesEqual(table.unpack({...}))
  end
  function ultraschall.GetTrackStateChunk_Tracknumber(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackStateChunk_Tracknumber(table.unpack({...}))
  end
  function ultraschall.GetTrackState_NumbersOnly(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackState_NumbersOnly(table.unpack({...}))
  end
  function ultraschall.GetTrackName(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackName(table.unpack({...}))
  end
  function ultraschall.GetTrackPeakColorState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackPeakColorState(table.unpack({...}))
  end
  function ultraschall.GetTrackBeatState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackBeatState(table.unpack({...}))
  end
  function ultraschall.GetTrackAutoRecArmState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackAutoRecArmState(table.unpack({...}))
  end
  function ultraschall.GetTrackMuteSoloState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackMuteSoloState(table.unpack({...}))
  end
  function ultraschall.GetTrackIPhaseState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackIPhaseState(table.unpack({...}))
  end
  function ultraschall.GetTrackIsBusState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackIsBusState(table.unpack({...}))
  end
  function ultraschall.GetTrackBusCompState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackBusCompState(table.unpack({...}))
  end
  function ultraschall.GetTrackShowInMixState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackShowInMixState(table.unpack({...}))
  end
  function ultraschall.GetTrackFreeModeState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackFreeModeState(table.unpack({...}))
  end
  function ultraschall.GetTrackRecState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackRecState(table.unpack({...}))
  end
  function ultraschall.GetTrackVUState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackVUState(table.unpack({...}))
  end
  function ultraschall.GetTrackHeightState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackHeightState(table.unpack({...}))
  end
  function ultraschall.GetTrackINQState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackINQState(table.unpack({...}))
  end
  function ultraschall.GetTrackNChansState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackNChansState(table.unpack({...}))
  end
  function ultraschall.GetTrackBypFXState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackBypFXState(table.unpack({...}))
  end
  function ultraschall.GetTrackPerfState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackPerfState(table.unpack({...}))
  end
  function ultraschall.GetTrackMIDIOutState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackMIDIOutState(table.unpack({...}))
  end
  function ultraschall.GetTrackMainSendState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackMainSendState(table.unpack({...}))
  end
  function ultraschall.GetTrackGroupFlagsState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackGroupFlagsState(table.unpack({...}))
  end
  function ultraschall.GetTrackGroupFlags_HighState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackGroupFlags_HighState(table.unpack({...}))
  end
  function ultraschall.GetTrackLockState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackLockState(table.unpack({...}))
  end
  function ultraschall.GetTrackLayoutNames(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackLayoutNames(table.unpack({...}))
  end
  function ultraschall.GetTrackAutomodeState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackAutomodeState(table.unpack({...}))
  end
  function ultraschall.GetTrackIcon_Filename(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackIcon_Filename(table.unpack({...}))
  end
  function ultraschall.GetTrackRecCFG(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackRecCFG(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiInputChanMap(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackMidiInputChanMap(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiCTL(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackMidiCTL(table.unpack({...}))
  end
  function ultraschall.GetTrackWidth(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackWidth(table.unpack({...}))
  end
  function ultraschall.GetTrackPanMode(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackPanMode(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiColorMapFn(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackMidiColorMapFn(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiBankProgFn(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackMidiBankProgFn(table.unpack({...}))
  end
  function ultraschall.GetTrackMidiTextStrFn(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackMidiTextStrFn(table.unpack({...}))
  end
  function ultraschall.GetTrackID(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackID(table.unpack({...}))
  end
  function ultraschall.GetTrackScore(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackScore(table.unpack({...}))
  end
  function ultraschall.GetTrackVolPan(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackVolPan(table.unpack({...}))
  end
  function ultraschall.SetTrackName(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackName(table.unpack({...}))
  end
  function ultraschall.SetTrackPeakColorState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackPeakColorState(table.unpack({...}))
  end
  function ultraschall.SetTrackBeatState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackBeatState(table.unpack({...}))
  end
  function ultraschall.SetTrackAutoRecArmState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackAutoRecArmState(table.unpack({...}))
  end
  function ultraschall.SetTrackMuteSoloState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackMuteSoloState(table.unpack({...}))
  end
  function ultraschall.SetTrackIPhaseState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackIPhaseState(table.unpack({...}))
  end
  function ultraschall.SetTrackIsBusState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackIsBusState(table.unpack({...}))
  end
  function ultraschall.SetTrackBusCompState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackBusCompState(table.unpack({...}))
  end
  function ultraschall.SetTrackShowInMixState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackShowInMixState(table.unpack({...}))
  end
  function ultraschall.SetTrackFreeModeState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackFreeModeState(table.unpack({...}))
  end
  function ultraschall.SetTrackRecState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackRecState(table.unpack({...}))
  end
  function ultraschall.SetTrackVUState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackVUState(table.unpack({...}))
  end
  function ultraschall.SetTrackHeightState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackHeightState(table.unpack({...}))
  end
  function ultraschall.SetTrackINQState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackINQState(table.unpack({...}))
  end
  function ultraschall.SetTrackNChansState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackNChansState(table.unpack({...}))
  end
  function ultraschall.SetTrackBypFXState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackBypFXState(table.unpack({...}))
  end
  function ultraschall.SetTrackPerfState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackPerfState(table.unpack({...}))
  end
  function ultraschall.SetTrackMIDIOutState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackMIDIOutState(table.unpack({...}))
  end
  function ultraschall.SetTrackMainSendState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackMainSendState(table.unpack({...}))
  end
  function ultraschall.SetTrackLockState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackLockState(table.unpack({...}))
  end
  function ultraschall.SetTrackLayoutNames(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackLayoutNames(table.unpack({...}))
  end
  function ultraschall.SetTrackAutomodeState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackAutomodeState(table.unpack({...}))
  end
  function ultraschall.SetTrackIcon_Filename(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackIcon_Filename(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiInputChanMap(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackMidiInputChanMap(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiCTL(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackMidiCTL(table.unpack({...}))
  end
  function ultraschall.SetTrackID(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackID(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiColorMapFn(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackMidiColorMapFn(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiBankProgFn(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackMidiBankProgFn(table.unpack({...}))
  end
  function ultraschall.SetTrackMidiTextStrFn(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackMidiTextStrFn(table.unpack({...}))
  end
  function ultraschall.SetTrackPanMode(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackPanMode(table.unpack({...}))
  end
  function ultraschall.SetTrackWidth(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackWidth(table.unpack({...}))
  end
  function ultraschall.SetTrackScore(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackScore(table.unpack({...}))
  end
  function ultraschall.SetTrackVolPan(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackVolPan(table.unpack({...}))
  end
  function ultraschall.SetTrackRecCFG(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackRecCFG(table.unpack({...}))
  end
  function ultraschall.GetAllLockedTracks(...)
    ultraschall.LM(33)
    return ultraschall.GetAllLockedTracks(table.unpack({...}))
  end
  function ultraschall.GetAllSelectedTracks(...)
    ultraschall.LM(33)
    return ultraschall.GetAllSelectedTracks(table.unpack({...}))
  end
  function ultraschall.GetTrackSelection_TrackStateChunk(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackSelection_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.SetTrackSelection_TrackStateChunk(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackSelection_TrackStateChunk(table.unpack({...}))
  end
  function ultraschall.SetAllTracksSelected(...)
    ultraschall.LM(33)
    return ultraschall.SetAllTracksSelected(table.unpack({...}))
  end
  function ultraschall.SetTracksSelected(...)
    ultraschall.LM(33)
    return ultraschall.SetTracksSelected(table.unpack({...}))
  end
  function ultraschall.SetTracksToLocked(...)
    ultraschall.LM(33)
    return ultraschall.SetTracksToLocked(table.unpack({...}))
  end
  function ultraschall.SetTracksToUnlocked(...)
    ultraschall.LM(33)
    return ultraschall.SetTracksToUnlocked(table.unpack({...}))
  end
  function ultraschall.SetTrackStateChunk_Tracknumber(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackStateChunk_Tracknumber(table.unpack({...}))
  end
  function ultraschall.SetTrackGroupFlagsState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackGroupFlagsState(table.unpack({...}))
  end
  function ultraschall.SetTrackGroupFlags_HighState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackGroupFlags_HighState(table.unpack({...}))
  end
  function ultraschall.ConvertTrackstringToArray(...)
    ultraschall.LM(33)
    return ultraschall.ConvertTrackstringToArray(table.unpack({...}))
  end
  function ultraschall.GetTrackPlayOffsState(...)
    ultraschall.LM(33)
    return ultraschall.GetTrackPlayOffsState(table.unpack({...}))
  end
  function ultraschall.SetTrackPlayOffsState(...)
    ultraschall.LM(33)
    return ultraschall.SetTrackPlayOffsState(table.unpack({...}))
  end
  function ultraschall.TrackManager_ClearFilter(...)
    ultraschall.LM(34)
    return ultraschall.TrackManager_ClearFilter(table.unpack({...}))
  end
  function ultraschall.TrackManager_ShowAll(...)
    ultraschall.LM(34)
    return ultraschall.TrackManager_ShowAll(table.unpack({...}))
  end
  function ultraschall.TrackManager_SelectionFromProject(...)
    ultraschall.LM(34)
    return ultraschall.TrackManager_SelectionFromProject(table.unpack({...}))
  end
  function ultraschall.TrackManager_SelectionFromList(...)
    ultraschall.LM(34)
    return ultraschall.TrackManager_SelectionFromList(table.unpack({...}))
  end
  function ultraschall.TrackManager_SetFilter(...)
    ultraschall.LM(34)
    return ultraschall.TrackManager_SetFilter(table.unpack({...}))
  end
  function ultraschall.TrackManager_OpenClose(...)
    ultraschall.LM(34)
    return ultraschall.TrackManager_OpenClose(table.unpack({...}))
  end
  function ultraschall.pause_follow_one_cycle(...)
    ultraschall.LM(35)
    return ultraschall.pause_follow_one_cycle(table.unpack({...}))
  end
  function ultraschall.IsTrackSoundboard(...)
    ultraschall.LM(35)
    return ultraschall.IsTrackSoundboard(table.unpack({...}))
  end
  function ultraschall.IsTrackStudioLink(...)
    ultraschall.LM(35)
    return ultraschall.IsTrackStudioLink(table.unpack({...}))
  end
  function ultraschall.IsTrackStudioLinkOnAir(...)
    ultraschall.LM(35)
    return ultraschall.IsTrackStudioLinkOnAir(table.unpack({...}))
  end
  function ultraschall.GetTypeOfTrack(...)
    ultraschall.LM(35)
    return ultraschall.GetTypeOfTrack(table.unpack({...}))
  end
  function ultraschall.GetAllAUXSendReceives2(...)
    ultraschall.LM(35)
    return ultraschall.GetAllAUXSendReceives2(table.unpack({...}))
  end
  function ultraschall.GetAllHWOuts2(...)
    ultraschall.LM(35)
    return ultraschall.GetAllHWOuts2(table.unpack({...}))
  end
  function ultraschall.GetAllMainSendStates2(...)
    ultraschall.LM(35)
    return ultraschall.GetAllMainSendStates2(table.unpack({...}))
  end
  function ultraschall.SetUSExternalState(...)
    ultraschall.LM(35)
    return ultraschall.SetUSExternalState(table.unpack({...}))
  end
  function ultraschall.GetUSExternalState(...)
    ultraschall.LM(35)
    return ultraschall.GetUSExternalState(table.unpack({...}))
  end
  function ultraschall.CountUSExternalState_sec(...)
    ultraschall.LM(35)
    return ultraschall.CountUSExternalState_sec(table.unpack({...}))
  end
  function ultraschall.CountUSExternalState_key(...)
    ultraschall.LM(35)
    return ultraschall.CountUSExternalState_key(table.unpack({...}))
  end
  function ultraschall.EnumerateUSExternalState_sec(...)
    ultraschall.LM(35)
    return ultraschall.EnumerateUSExternalState_sec(table.unpack({...}))
  end
  function ultraschall.EnumerateUSExternalState_key(...)
    ultraschall.LM(35)
    return ultraschall.EnumerateUSExternalState_key(table.unpack({...}))
  end
  function ultraschall.DeleteUSExternalState(...)
    ultraschall.LM(35)
    return ultraschall.DeleteUSExternalState(table.unpack({...}))
  end
  function ultraschall.SoundBoard_StopAllSounds(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_StopAllSounds(table.unpack({...}))
  end
  function ultraschall.SoundBoard_TogglePlayPause(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_TogglePlayPause(table.unpack({...}))
  end
  function ultraschall.SoundBoard_TogglePlayStop(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_TogglePlayStop(table.unpack({...}))
  end
  function ultraschall.SoundBoard_Play(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_Play(table.unpack({...}))
  end
  function ultraschall.SoundBoard_Stop(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_Stop(table.unpack({...}))
  end
  function ultraschall.SoundBoard_TogglePlay_FadeOutStop(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_TogglePlay_FadeOutStop(table.unpack({...}))
  end
  function ultraschall.SoundBoard_PlayList_CurrentIndex(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_PlayList_CurrentIndex(table.unpack({...}))
  end
  function ultraschall.SoundBoard_PlayList_SetIndex(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_PlayList_SetIndex(table.unpack({...}))
  end
  function ultraschall.SoundBoard_PlayList_Next(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_PlayList_Next(table.unpack({...}))
  end
  function ultraschall.SoundBoard_PlayList_Previous(...)
    ultraschall.LM(35)
    return ultraschall.SoundBoard_PlayList_Previous(table.unpack({...}))
  end
  function ultraschall.Soundboard_PlayFadeIn(...)
    ultraschall.LM(35)
    return ultraschall.Soundboard_PlayFadeIn(table.unpack({...}))
  end
  function ultraschall.LUFS_Metering_MatchGain(...)
    ultraschall.LM(35)
    return ultraschall.LUFS_Metering_MatchGain(table.unpack({...}))
  end
  function ultraschall.LUFS_Metering_Reset(...)
    ultraschall.LM(35)
    return ultraschall.LUFS_Metering_Reset(table.unpack({...}))
  end
  function ultraschall.LUFS_Metering_GetValues(...)
    ultraschall.LM(35)
    return ultraschall.LUFS_Metering_GetValues(table.unpack({...}))
  end
  function ultraschall.LUFS_Metering_SetValues(...)
    ultraschall.LM(35)
    return ultraschall.LUFS_Metering_SetValues(table.unpack({...}))
  end
  function ultraschall.LUFS_Metering_AddEffect(...)
    ultraschall.LM(35)
    return ultraschall.LUFS_Metering_AddEffect(table.unpack({...}))
  end
  function ultraschall.LUFS_Metering_ShowEffect(...)
    ultraschall.LM(35)
    return ultraschall.LUFS_Metering_ShowEffect(table.unpack({...}))
  end
  function ultraschall.WebInterface_GetInstalledInterfaces(...)
    ultraschall.LM(36)
    return ultraschall.WebInterface_GetInstalledInterfaces(table.unpack({...}))
  end
end
collectgarbage("collect")