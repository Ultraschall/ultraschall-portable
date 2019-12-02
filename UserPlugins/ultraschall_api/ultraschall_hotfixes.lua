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
ultraschall.hotfixdate="01_December_2019"

--ultraschall.ShowLastErrorMessage()



function ultraschall.CountValuesByPattern(pattern, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountValuesByPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer number_of_keys, string sections_and_keys = ultraschall.CountValuesByPattern(string pattern, string ini_filename_with_path)</functioncall>
  <description>
    Counts the number of values within an ini-file, that fit a specific pattern.
    
    Uses "pattern"-string to determine, how often a value with a certain pattern exists. Good for values, that have a number in them, like value1, value2, value3
    Returns the number of values, that include that pattern as well as a string, that contains the [sections] and the keys= and values , the latter that contain the pattern, separated by a comma
     e.g. [section1], key1=, value, key4=, value, [section4], key2=, value
    
    Pattern can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
    
    Returns -1, in case of an error.
  </description>
  <retvals>
    integer number_of_values - the number of values, that fit the pattern
    string sections_keys_values - a string, like: [section1],key1=,value,key4=,value,[section4],key2=,value
  </retvals>
  <parameters>
    string pattern - the pattern itself. Case sensitive.
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>configurationmanagement, count, values, pattern, get, ini-files</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("CountValuesByPattern", "pattern", "must be a string", -1) return -1 end
  if ini_filename_with_path==nil then ultraschall.AddErrorMessage("CountValuesByPattern", "ini_filename_with_path", "must be a string", -2) return -1 end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("CountValuesByPattern", "ini_filename_with_path", "file does not exist", -3) return -1 end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("CountValuesByPattern", "pattern", "malformed pattern", -4) return -1 end
  
  local retpattern=""
  local count=0
  local tiff=0
  local temppattern=nil
  for line in io.lines(ini_filename_with_path) do
    if line:match("%[.-%]")~=nil then temppattern=line end
    if line:match(".-=")~=nil then
        local A,B=line:match("(.-)=(.*)")
        if B:match(pattern)~=nil then
            count=count+1
            retpattern=retpattern..","..temppattern..","..A.."=,"..B
        end
    end
  end

  return count, retpattern:sub(2,-1)
end

function ultraschall.MoveRegionsBy(startposition, endposition, moveby, cut_at_borders)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveRegionsBy</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.MoveRegionsBy(number startposition, number endposition, number moveby, boolean cut_at_borders)</functioncall>
  <description>
    Moves the regions between startposition and endposition by moveby.
    Will affect only regions, who start within start and endposition. It will not affect those, who end within start and endposition but start before startposition.
    
    Does NOT move markers and time-signature-markers!
    
    Returns -1 in case of failure.
  </description>
  <retvals>
    integer retval - -1 in case of failure
  </retvals>
  <parameters>
    number startposition - the startposition in seconds
    number endposition - the endposition in seconds
    number moveby - in seconds, negative values: move toward beginning of project, positive values: move toward the end of project
    boolean cut_at_borders - shortens or cuts markers, that leave the section between startposition and endposition
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>markermanagement, move, moveby, marker</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("MoveRegionsBy","startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("MoveRegionsBy","endposition", "must be a number", -2) return -1 end
  if startposition>endposition then ultraschall.AddErrorMessage("MoveRegionsBy","endposition", "must be bigger than startposition", -3) return -1 end
  if type(moveby)~="number" then ultraschall.AddErrorMessage("MoveRegionsBy","moveby", "must be a number", -4) return -1 end
  if type(cut_at_borders)~="boolean" then ultraschall.AddErrorMessage("MoveRegionsBy","cut_at_borders", "must be a boolean", -5) return -1 end
  if moveby==0 then return -1 end
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  
  local start, stop, step, boolean
  if moveby>0 then start=retval stop=0 step=-1     -- if moveby is positive, count through the markers backwards
  elseif moveby<0 then start=0 stop=retval step=1  -- if moveby is positive, count through the markers forward
  end
  local markerdeleter={}
  local count=0
  
  for i=start, stop, step do
    local sretval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    -- debug line
    --reaper.MB("Pos:"..pos.." - Start:"..startposition.."  End: "..endposition.." "..tostring(isrgn),"",0)
    
    if isrgn==true and (pos>=startposition and pos<=endposition) then
      -- only regions within start and endposition
      if cut_at_borders==true then
        -- if cutting at the borders=true, with borders determined by start and endposition 
        if pos+moveby>endposition and rgnend+moveby>endposition then
          -- when regions would move after endposition, put it into the markerdelete-array
          markerdeleter[count]=markrgnindexnumber
          count=count+1
          --reaper.MB("","0",0)
        elseif pos+moveby<startposition and rgnend+moveby<startposition then
          -- when regions would move before startposition, put it into the markerdelete-array
          markerdeleter[count]=markrgnindexnumber
          count=count+1
          --reaper.MB("","1",0)
        elseif pos+moveby<startposition and rgnend+moveby>=startposition and rgnend+moveby<=endposition then
          -- when start of the region is before startposition and end of the region is within start and endposition,
          -- set start of the region to startposition and only move regionend by moveby
          --reaper.MB("","2",0)
          boolean=reaper.SetProjectMarker(markrgnindexnumber, isrgn, startposition, rgnend+moveby, name)
--        elseif rgnend+moveby<endposition and pos+moveby>=startposition and pos+moveby<=endposition then
          -- when end of the region is BEFORE endposition and start of the region is within start and endposition,
          -- set end of the region to endposition and only move regionstart(pos) by moveby
        elseif rgnend+moveby>endposition and pos+moveby>=startposition and pos+moveby<=endposition then
          -- when end of the region is after endposition and start of the region is within start and endposition,
          -- set end of the region to endposition and only move regionstart(pos) by moveby
          --reaper.MB("","2",0)
          boolean=reaper.SetProjectMarker(markrgnindexnumber, isrgn, pos+moveby, endposition, name)
        else
          -- move the region by moveby
          boolean=reaper.SetProjectMarker(markrgnindexnumber, isrgn, pos+moveby, rgnend+moveby, name)
          --reaper.MB("","3",0)
        end
      else
        -- move the region by moveby
        boolean=reaper.SetProjectMarker(markrgnindexnumber, isrgn, pos+moveby, rgnend+moveby, name)
      end
    end
  end
  for i=0, count-1 do
    reaper.DeleteProjectMarker(0, markerdeleter[i], true)
  end
  return 1
end

function ultraschall.DeleteArrangeviewSnapshot(slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteArrangeviewSnapshot</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.DeleteArrangeviewSnapshot(integer slot)</functioncall>
  <description>
    Deletes an ArrangeviewSnapshot-slot.
    
    Returns -1 if the slot is unset or slot is an invalid value.
  </description>
  <parameters>
    integer slot - the slot for arrangeview-snapshot
  </parameters>            
  <retvals>
    integer retval - -1 in case of an error; 0 in case of success
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>userinterface, delete, arrangeview, snapshot, startposition, endposition, verticalzoom</tags>
</US_DocBloc>
--]]
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("DeleteArrangeviewSnapshot","slot", "Must be an integer!", -1) return -1 end

  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_start","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_end","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_description","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_hzoom","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll","","")
  return 1
end

function ultraschall.IsValidArrangeviewSnapshot(slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidArrangeviewSnapshot</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidArrangeviewSnapshot(integer slot)</functioncall>
  <description>
    Checks, if an Arrangeview-snapshot-slot is valid(means set).
    
    Returns false in case of error.
  </description>
  <parameters>
    integer slot - the slot for arrangeview-snapshot
  </parameters>
  <retvals>
    boolean retval - true, if Arrangeview-Snapshot is valid; false, if Arrangeview-Snapshot is not existing
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>userinterface, check, arrangeview, snapshot</tags>
</US_DocBloc>
--]]  
  -- check parameters
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("IsValidArrangeviewSnapshot","slot", "Must be an integer", -1) return false end
  if slot<0 then ultraschall.AddErrorMessage("IsValidArrangeviewSnapshot","slot", "Must be bigger than 0", -2) return false end
  
  -- prepare variable
  slot=tostring(slot)
  
  -- check, whether there is valid information to retrieve from the Arrange-view-snapshot-slot
  if reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_start")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_end")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_description")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_hzoom")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom")~=0 or
     reaper.GetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll")~=0 then
     return true
  else
    return false
  end
end

function ultraschall.RetrieveArrangeviewSnapshot(slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RetrieveArrangeviewSnapshot</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string description, number startposition, number endposition, integer vzoomfactor, number hzoomfactor, number vertical_scroll = ultraschall.RetrieveArrangeviewSnapshot(integer slot)</functioncall>
  <description>
    Retrieves an Arrangeview-snapshot and returns the startposition, endposition and vertical and horizontal zoom-factor as well as the number vertical-scroll-factor..
    
    Returns false in case of error.
  </description>
  <parameters>
    integer slot - the slot for arrangeview-snapshot
  </parameters>
  <retvals>
    boolean retval - false, in case of error; true, in case of success
    string description - a description for this arrangeview-snapshot
    number startposition - the startposition of the arrangeview
    number endposition - the endposition of the arrangeview
    integer vzoom - the vertical-zoomfactor(0-40)
    number hzoomfactor - the horizontal zoomfactor
    number vertical_scroll - the vertical scroll-value
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>userinterface, get, arrangeview, snapshot, startposition, endposition, verticalzoom, horizontal zoom, vertical scroll</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("RetrieveArrangeviewSnapshot","slot", "Must be an integer", -1) return false end
  if slot<0 then ultraschall.AddErrorMessage("RetrieveArrangeviewSnapshot","slot", "Must be bigger than 0", -2) return false end
  if ultraschall.IsValidArrangeviewSnapshot(slot)==false then ultraschall.AddErrorMessage("RetrieveArrangeviewSnapshot", "slot", "No such slot available", -3) return false end

  -- prepare variables
  slot=tostring(slot)
  local _l, start, ende, description, vzoom, hzoom, vscroll
  
  -- get information from arrangeview-snapshot-slot and return it, if existing
  if reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_start")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_end")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_description")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_hzoom")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom")~=0 or
     reaper.GetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll")~="" then
     
     _l, start=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_start")
     _l, ende=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_end")
     _l, description=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_description")
     _l, vzoom=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom")
     _l, hzoom=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_hzoom")
     _l, vscroll=reaper.GetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll")
     return true, description, tonumber(start), tonumber(ende), tonumber(vzoom), tonumber(hzoom), tonumber(vscroll)
  else
    return false
  end
end

