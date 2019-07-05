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

-- This is the file for hotfixes of buggy functions.

-- If you have found buggy functions, you can submit fixes within here.
--      a) copy the function you found buggy into ultraschall_hotfixes.lua
--      b) debug the function IN HERE(!)
--      c) comment, what you've changed(this is for me to find out, what you did)
--      d) add information to the <US_DocBloc>-bloc of the function. So if the information in the
--         <US_DocBloc> isn't correct anymore after your changes, rewrite it to fit better with your fixes
--      e) add as an additional comment in the function your name and a link to something you do(the latter, if you want), 
--         so I can credit you and your contribution properly
--      f) submit the file as PullRequest via Github: https://github.com/Ultraschall/Ultraschall-Api-for-Reaper.git (preferred !)
--         or send it via lspmp3@yahoo.de(only if you can't do it otherwise!)
--
-- As soon as these functions are in here, they can be used the usual way through the API. They overwrite the older buggy-ones.
--
-- These fixes, once I merged them into the master-branch, will become part of the current version of the Ultraschall-API, 
-- until the next version will be released. The next version will has them in the proper places added.
-- That way, you can help making it more stable without being dependent on me, while I'm busy working on new features.
--
-- If you have new functions to contribute, you can use this file as well. Keep in mind, that I will probably change them to work
-- with the error-messaging-system as well as adding information for the API-documentation.
ultraschall.hotfixdate="21_June_2019"

--ultraschall.ShowLastErrorMessage()

function ultraschall.GetUserInputs(title, caption_names, default_retvals, values_length, x_pos, y_pos)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetUserInputs</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer number_of_inputfields, table returnvalues = ultraschall.GetUserInputs(string title, table caption_names, table default_retvals, optional integer values_length)</functioncall>
  <description>
    Gets inputs from the user.
    
    The captions and the default-returnvalues must be passed as an integer-index table.
    e.g.
      caption_names[1]="first caption name"
      caption_names[2]="second caption name"
      caption_names[1]="*third caption name, which creates an inputfield for passwords, due the * at the beginning"
     
    returns false in case of an error.
  </description>
  <retvals>
    boolean retval - true, the user clicked ok on the userinput-window; false, the user clicked cancel or an error occured
    integer number_of_inputfields - the number of returned values; nil, in case of an error
    table returnvalues - the returnvalues input by the user as a table; nil, in case of an error
  </retvals>
  <parameters>
    string title - the title of the inputwindow
    table caption_names - a table with all inputfield-captions. All non-string-entries will be converted to string-entries. Begin an entry with a * for password-entry-fields.
                        - This dialog only allows limited caption-field-length, about 19-30 characters, depending on the size of the used characters.
    table default_retvals - a table with all default retvals. All non-string-entries will be converted to string-entries.
    optional integer values_length - the extralength of the values-inputfield. With that, you can enhance the length of the inputfields. 
                            - 1-500; 
                            - nil, for default length 10
  </parameters>
  <chapter_context>
    User Interface
    Dialogs
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>userinterface, dialog, get, user input</tags>
</US_DocBloc>
--]]
  local count33, autolength
  if type(title)~="string" then ultraschall.AddErrorMessage("GetUserInputs", "title", "must be a string", -1) return false end
  if type(caption_names)~="table" then ultraschall.AddErrorMessage("GetUserInputs", "caption_names", "must be a table", -2) return false end
  if type(default_retvals)~="table" then ultraschall.AddErrorMessage("GetUserInputs", "default_retvals", "must be a table", -3) return false end
  if values_length~=nil and math.type(values_length)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "values_length", "must be an integer", -4) return false end
  if values_length==nil then values_length=10 end
  if (values_length>500 or values_length<1) and values_length~=-1 then ultraschall.AddErrorMessage("GetUserInputs", "values_length", "must be between 1 and 500, or -1 for autolength", -5) return false end
  if values_length==-1 then values_length=1 autolength=true end
  local count = ultraschall.CountEntriesInTable_Main(caption_names)
  local count2 = ultraschall.CountEntriesInTable_Main(default_retvals)
  if count>16 then ultraschall.AddErrorMessage("GetUserInputs", "caption_names", "must be no more than 16 caption-names!", -5) return false end
  if count2>16 then ultraschall.AddErrorMessage("GetUserInputs", "default_retvals", "must be no more than 16 default-retvals!", -6) return false end
  if count2>count then count33=count2 else count33=count end
  values_length=(values_length*2)+18
    
  local captions=""
  local retvals=""  
  
  for i=1, count2 do
    if default_retvals[i]==nil then default_retvals[i]="" end
    retvals=retvals..tostring(default_retvals[i])..","
    if autolength==true and values_length<tostring(default_retvals[i]):len() then values_length=(tostring(default_retvals[i]):len()*6.6)+18 end
  end
  retvals=retvals:sub(1,-2)  
  
  for i=1, count do
    if caption_names[i]==nil then caption_names[i]="" end
    captions=captions..tostring(caption_names[i])..","
    --if autolength==true and length<tostring(caption_names[i]):len()+length then length=(tostring(caption_names[i]):len()*16.6)+18+length end
  end
  captions=captions:sub(1,-2)
  if count<count2 then
    for i=count, count2 do
      captions=captions..","
    end
  end
  captions=captions..",extrawidth="..values_length
  
  --print2(captions)
  -- fill up empty caption-names, so the passed parameters are 16 in count
  for i=1, 16 do
    if caption_names[i]==nil then
      caption_names[i]=""
    end
  end
  caption_names[17]=nil

  -- fill up empty default-values, so the passed parameters are 16 in count  
  for i=1, 16 do
    if default_retvals[i]==nil then
      default_retvals[i]=""
    end
  end
  default_retvals[17]=nil

  local numentries, concatenated_table = ultraschall.ConcatIntegerIndexedTables(caption_names, default_retvals)
  
  local temptitle="Tudelu"..reaper.genGuid()
  
  ultraschall.Main_OnCommandByFilename(ultraschall.Api_Path.."/Scripts/GetUserInputValues_Helper_Script.lua", temptitle, title, 0, "Tudelu", table.unpack(concatenated_table))

  local retval, retvalcsv = reaper.GetUserInputs(temptitle, count33, "", "")
  if retval==false then reaper.DeleteExtState(ultraschall.ScriptIdentifier, "values", false) return false end
  local Values=reaper.GetExtState(ultraschall.ScriptIdentifier, "values")
  --print2(Values)
  reaper.DeleteExtState(ultraschall.ScriptIdentifier, "values", false)
  local count2,Values=ultraschall.CSV2IndividualLinesAsArray(Values ,"\n")
  for i=count+1, 17 do
    Values[i]=nil
  end
  return retval, count33, Values
end

--A,B,C,D=ultraschall.GetUserInputs("I got you", {"ShalalalaOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOHAH"}, {"HHHAAAAHHHHHHHHHHHHHHHHHHHHHHHHAHHHHHHHA"}, -1)


function ultraschall.RenderProject_Regions(projectfilename_with_path, renderfilename_with_path, region, addregionname, overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg, addregionnameseparator)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject_Regions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer retval, integer renderfilecount, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProject_Regions(string projectfilename_with_path, string renderfilename_with_path, integer region, boolean addregionname, boolean overwrite_without_asking, boolean renderclosewhendone, boolean filenameincrease, string rendercfg, optional string addregionnameseparator)</functioncall>
  <description>
    Renders a region of a project, using a specific render-cfg-string.
    To get render-cfg-strings, see <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>
    
    Returns -1 in case of an error
  </description>
  <retvals>
    integer retval - -1, in case of error; 0, in case of success; -2, if you try to render the currently opened project without saving it first
    integer renderfilecount - the number of rendered files
    array MediaItemStateChunkArray - the MediaItemStateChunks of all rendered files, with the one in entry 1 being the rendered master-track(when rendering stems)
    array Filearray - the filenames of the rendered files, including their paths. The filename in entry 1 is the one of the mastered track(when rendering stems)
  </retvals>
  <parameters>
    string projectfilename_with_path - the project to render; nil, for the currently opened project
    string renderfilename_with_path - the filename of the output-file. 
                                    - You can use wildcards to some extend in the actual filename(not the path!); doesn't support $region yet
                                    - Will be seen as path only, when you set addregionname=true and addregionnameseparator="/"
    integer region - the number of the region in the Projectfile to render
    boolean addregionname - add the name of the region to the renderfilename; only works, when you don't add a file-extension to renderfilename_with_path
    boolean overwrite_without_asking - true, overwrite an existing renderfile; false, don't overwrite an existing renderfile
    boolean renderclosewhendone - true, automatically close the render-window after rendering; false, keep rendering window open after rendering; nil, use current settings
    boolean filenameincrease - true, silently increase filename, if it already exists; false, ask before overwriting an already existing outputfile; nil, use current settings
    string rendercfg         - the rendercfg-string, that contains all render-settings for an output-format
                             - To get render-cfg-strings, see CreateRenderCFG_xxx-functions, like: <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, <a href="#CreateRenderCFG_WAVPACK">CreateRenderCFG_WAVPACK</a>, <a href="#CreateRenderCFG_WebMVideo">CreateRenderCFG_WebMVideo</a>
                             - 
                             - If you want to render the current project, you can use a four-letter-version of the render-string; will use the default settings for that format. Not available with projectfiles!
                             - "evaw" for wave, "ffia" for aiff, " iso" for audio-cd, " pdd" for ddp, "calf" for flac, "l3pm" for mp3, "vggo" for ogg, "SggO" for Opus, "PMFF" for FFMpeg-video, "FVAX" for MP4Video/Audio on Mac, " FIG" for Gif, " FCL" for LCF, "kpvw" for wavepack 
    optional string addregionnameseparator - when addregionname==true, this parameter allows you to set a separator between renderfilename_with_path and regionname. 
                                           - Also allows / or \\ to use renderfilename_with_path as only path as folder, into which the files are stored having the regionnames only.
                                           - Default is an empty string.
  </parameters>
  <chapter_context>
    Rendering Projects
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, render, output, file, region</tags>
</US_DocBloc>
]]
  local retval
  local curProj=reaper.EnumProjects(-1,"")
  if math.type(region)~="integer" then ultraschall.AddErrorMessage("RenderProject_Regions", "region", "Must be an integer.", -1) return -1 end
  if region<1 then ultraschall.AddErrorMessage("RenderProject_Regions", "region", "Must be 1 or higher", -8) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("RenderProject_Regions", "projectfilename_with_path", "File does not exist.", -3) return -1 end
  if type(renderfilename_with_path)~="string" then ultraschall.AddErrorMessage("RenderProject_Regions", "renderfilename_with_path", "Must be a string.", -4) return -1 end  
  if rendercfg==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg)==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg)=="Unknown" then ultraschall.AddErrorMessage("RenderProject_Regions", "rendercfg", "No valid render_cfg-string.", -5) return -1 end
  if type(overwrite_without_asking)~="boolean" then ultraschall.AddErrorMessage("RenderProject_Regions", "overwrite_without_asking", "Must be boolean", -6) return -1 end
  if addregionnameseparator~=nil and type(addregionnameseparator)~="string" then ultraschall.AddErrorMessage("RenderProject_Regions", "addregionnameseparator", "Must be a string or nil", -9) return -1 end

  local countmarkers, nummarkers, numregions, markertable, markertable_temp, countregions
  markertable={}
  if projectfilename_with_path~=nil then 
    countmarkers, nummarkers, numregions, markertable = ultraschall.GetProject_MarkersAndRegions(projectfilename_with_path)
  else
    countmarkers, countregions = ultraschall.CountMarkersAndRegions()
    numregions, markertable_temp = ultraschall.GetAllRegions()

    for index=1, numregions do
      markertable[index]={}
      markertable[index][1]=true
      markertable[index][2]=markertable_temp[index][0]
      markertable[index][3]=markertable_temp[index][1]
      markertable[index][4]=markertable_temp[index][2]
      markertable[index][5]=markertable_temp[index][4]
      markertable[index][6]=markertable_temp[index][5]
    end    
  end
  if region>numregions then ultraschall.AddErrorMessage("RenderProject_Regions", "region", "No such region in the project.", -7) return -1 end
  local regioncount=0
  
  for i=1, countmarkers do
    if markertable[i][1]==true then 
      regioncount=regioncount+1
      if regioncount==region then region=i break end
    end
  end
  
  --print2("Häh?", renderfilename_with_path)

  if addregionname==true then 
    if addregionnameseparator==nil then addregionnameseparator="" end
    renderfilename_with_path=renderfilename_with_path..addregionnameseparator..markertable[region][4]
  end

  return ultraschall.RenderProject(projectfilename_with_path, renderfilename_with_path, tonumber(markertable[region][2]), tonumber(markertable[region][3]), overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg, RenderTable)
end