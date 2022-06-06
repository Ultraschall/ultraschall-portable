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

-------------------------------------
--- ULTRASCHALL - API - FUNCTIONS ---
-------------------------------------
---     BatchConverter Module     ---
-------------------------------------


function ultraschall.BatchConvertFiles(inputfilelist, outputfilelist, RenderTable, BWFStart, PadStart, PadEnd, FXStateChunk, MetaDataStateChunk, UseRCMetaData)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>BatchConvertFiles</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.32
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.BatchConvertFiles(table inputfilelist, table outputfilelist, table RenderTable, optional boolean BWFStart, optional integer PadStart, optional integer PadEnd, optional string FXStateChunk, optional boolean UseRCMetaData)</functioncall>
  <description>
    Converts files using Reaper's own BatchConverter.
    
    This function will open another instance of Reaper that runs the batchconverter, so it will still open the batch-converter-list for the time of conversion.
    Though as it is another instance, you can safely go back to the old instance of Reaper.
    
    This function will probably NOT finish before the batch-converter is finished with conversion, keep this in mind.
    
    Will take away the focus from the currently focused window, as Reaper puts keyboard-focus to the newly started Reaper-instance that does the batch-conversion.    
    
    returns nil in case of an error
  </description>
  <retvals>
    table inputfilelist - a table of filenames+path, that shall be converted
    table outputfilelist - a table of the target filenames+path, where the first filename is the target for the first inputfilename, etc
    table RenderTable - the settings for the conversion; just use the render-table-functions to create one
    optional boolean BWFStart - true, include BWF-start; false or nil, don't include BWF-start
    optional integer PadStart - the start of the padding in seconds; nil, to omit it
    optional integer PadEnd - the end of the padding in seconds; nil, to omit it
    optional string FXStateChunk - an FXChain as FXStateChunk; with that you can add fx on top of the to-convert-files.
    optional boolean UseRCMetaData - true, tries to retain the metadata from the sourcefile; false, doesn't try to retain metadata
  </retvals>
  <parameters>
    boolean retval - true, conversion was successfully started; false, conversion didn't start
  </parameters>
  <chapter_context>
    Batch Converter
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_BatchConverter.lua</source_document>
  <tags>batch converter, convert, files, rendertable, fxchain</tags>
</US_DocBloc>
--]]
  if type(inputfilelist)~="table" then ultraschall.AddErrorMessage("BatchConvertFiles", "inputfilelist", "must be a table of string", -1) return false end
  
  if #inputfilelist~=#outputfilelist then ultraschall.AddErrorMessage("BatchConvertFiles", "inputfilelist and outputfilelist", "both filelist-tables must have the same number of entries", -2) return false end
  for i=1, #inputfilelist do
    if type(inputfilelist[i])~="string" then ultraschall.AddErrorMessage("BatchConvertFiles", "inputfilelist", "all entries of the table must be strings", -3) return false end
    if reaper.file_exists(inputfilelist[i])==false then ultraschall.AddErrorMessage("BatchConvertFiles", "inputfilelist", "all entries of the table must be valid filenames", -4) return false end
  end

  if type(outputfilelist)~="table" then ultraschall.AddErrorMessage("BatchConvertFiles", "outputfilelist", "must be a table of string", -5) return false end
  for i=1, #inputfilelist do
    if type(inputfilelist[i])~="string" then ultraschall.AddErrorMessage("BatchConvertFiles", "inputfilelist", "all entries of the table must be strings", -6) return false end
  end
  
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("BatchConvertFiles", "RenderTable", "must be a valid RenderTable", -7) return false end
  
  -- temporary solution:
  if type(MetaDataStateChunk)~="string" then MetaDataStateChunk="" end  


  local BatchConvertData=""
  local ExeFile, filename, path
  if FXStateChunk~=nil and FXStateChunk~="" and ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("BatchConvertFiles", "FXStateChunk", "must be a valid FXStateChunk", -7) return false end
  if FXStateChunk==nil then FXStateChunk="" end
  if MetaDataStateChunk==nil then MetaDataStateChunk="" end
  if BWFStart==true then BWFStart="    USERCSTART 1\n" else BWFStart="" end
  if PadStart~=nil  then PadStart="    PAD_START "..PadStart.."\n" else PadStart="" end
  if PadEnd~=nil  then PadEnd="    PAD_END "..PadEnd.."\n" else PadEnd="" end
  if UseRCMetaData==true then UseRCMetaData="    USERCMETADATA 1\n" else UseRCMetaData="" end
  local i=1
  local outputfile
  while inputfilelist[i]~=nil do
    if ultraschall.type(inputfilelist[i])=="string" then
      if outputfilelist[i]==nil then outputfile="" else outputfile=outputfilelist[i] end
      BatchConvertData=BatchConvertData..inputfilelist[i].."\t"..outputfile.."\n"
    end
    i=i+1
  end
    
  BatchConvertData=BatchConvertData..[[
<CONFIG
    SRATE ]]..RenderTable["SampleRate"]..[[
    
    NCH ]]..RenderTable["Channels"]..[[
    
    RSMODE ]]..RenderTable["RenderResample"]..[[
    
    DITHER ]]..RenderTable["Dither"]..[[
    
]]..BWFStart..[[
]]..UseRCMetaData..[[
]]..PadStart..[[
]]..PadEnd..[[
    OUTPATH ]]..RenderTable["RenderFile"]..[[
    
    OUTPATTERN ']]..[['
  <OUTFMT 
    ]]      ..RenderTable["RenderString"]..[[

  >
  ]]..FXStateChunk..[[
  ]]..string.gsub(MetaDataStateChunk, "<RENDER_METADATA", "<METADATA")..[[

>
]]

  ultraschall.WriteValueToFile(ultraschall.API_TempPath.."/filelist.txt", BatchConvertData)

  local ExeFile, AAAA, AAAAAA
  if ultraschall.IsOS_Windows()==true then
    -- Batchconvert On Windows
    ExeFile=reaper.GetExePath().."\\reaper.exe"
    AAAA, AAAAAA=reaper.ExecProcess(ExeFile.." -batchconvert \""..string.gsub(ultraschall.API_TempPath, "/", "\\").."\\filelist.txt\"", -1)
  elseif ultraschall.IsOS_Mac()==true then
    -- Batchconvert On Mac
    ExeFile=reaper.GetExePath().."/Reaper64.app/Contents/MacOS/reaper"
    if reaper.file_exists(ExeFile)==false then
      ExeFile=reaper.GetExePath().."/Reaper.app/Contents/MacOS/reaper"
    end
    AAAA, AAAAAA=reaper.ExecProcess(ExeFile.." -batchconvert \""..string.gsub(ultraschall.API_TempPath, "\\\\", "/").."/filelist.txt\"", -1)
  else
    -- Batchconvert On Linux
    ExeFile=reaper.GetExePath().."/reaper"
    AAAA, AAAAAA=reaper.ExecProcess(ExeFile.." -batchconvert \""..string.gsub(ultraschall.API_TempPath, "\\\\", "/").."/filelist.txt\"", -1)
  end
  
  return true
end


function ultraschall.GetBatchConverter_NotifyWhenFinished()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetBatchConverter_NotifyWhenFinished</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.50
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetBatchConverter_NotifyWhenFinished()</functioncall>
  <description>
    Returns, the state of the "notify when finished"-checkbox in the BatchConverter.
  </description>
  <retvals>
    boolean retval - true, notify when finished; false, don't notify when finished
  </retvals>
  <chapter_context>
    Batch Converter
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_BatchConverter.lua</source_document>
  <tags>batchconverter, notify when finished, checkbox, get</tags>
</US_DocBloc>
]]
  local A,B=reaper.BR_Win32_GetPrivateProfileString("REAPER", "convertopts", "", reaper.get_ini_file())
  return tonumber(B)&1==0
end

function ultraschall.SetBatchConverter_NotifyWhenFinished(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetBatchConverter_NotifyWhenFinished</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.50
    SWS=2.10.0.1
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetBatchConverter_NotifyWhenFinished()</functioncall>
  <description>
    Sets, the state of the "notify when finished"-checkbox in the BatchConverter.
    
    Works also, with BatchConverter opened.
    
    return false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <chapter_context>
    Batch Converter
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_BatchConverter.lua</source_document>
  <tags>batchconverter, notify when finished, checkbox, get</tags>
</US_DocBloc>
]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("SetBatchConverter_NotifyWhenFinished", "state", "must be a boolean", -1) return false end
  local HWND = ultraschall.GetBatchFileItemConverterHWND()
  if HWND==nil then
    if state==true then state=0 else state=1 end
    local A,Old=reaper.BR_Win32_GetPrivateProfileString("REAPER", "convertopts", "", reaper.get_ini_file())
    Old=tonumber(Old)
    if Old&1==state then return true else
      if Old&1==1 and state==0 then 
        Old=Old-1
      elseif Old&1==0 and state==1 then
        Old=Old+1
      end
      reaper.BR_Win32_WritePrivateProfileString("REAPER", "convertopts", Old, reaper.get_ini_file())
    end
  else
    if state==true then state=1 else state=0 end
    local HWND2=reaper.JS_Window_FindChildByID(HWND, 1182)
    local Old=reaper.JS_WindowMessage_Send(HWND2, "BM_GETCHECK", 0,0,0,0)
    if (Old==0 and state==1) or (Old==1 and state==0) then 
--      reaper.JS_WindowMessage_Send(HWND2, "BM_SETCHECK", state,0,0,0)
      reaper.JS_WindowMessage_Send(HWND2, "WM_LBUTTONDOWN", 1,0,0,0)
      reaper.JS_WindowMessage_Post(HWND2, "WM_LBUTTONUP", 1,0,0,0)
    end
  end
  return true
end

--AAA=ultraschall.GetBatchConverter_NotifyWhenFinished()
--A=ultraschall.SetBatchConverter_NotifyWhenFinished(false)