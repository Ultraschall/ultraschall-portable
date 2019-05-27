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
ultraschall.hotfixdate="29_Apr_2019"

--ultraschall.ShowLastErrorMessage()


--[[
Changes:
  - GFX: GFX_GetMouseCap - interpreted modifier-keys as mouseclicks, when gfx.getkey had been used in script; mousewheel sometimes kept stuck at one value-> fixed
  - Helpers: Base64_Encoder - fixed bug that caused encoded strings to end with wrong letter
  - Helpers: GetReaperAppVersion - didn't return subversionnumber for pre-releases -> fixed now; returns pre-release-versions as well now
  - Projectmanagement: GetProject_NumberOfTracks - sped code up by magnitudes for huge projects; parameter ProjectStateChunk wasn't working due stupid typo -> fixed now
  - Projectmanagement: GetProject_RenderFilename - could produce Lua-error, when no Renderfilename was existing in the projectfile
  - Routing: GetTrackAUXSendReceives - recv_tracknumber is now 1-based, as it should be(thanks to woodslanding)
  - Routing: SetTrackAUXSendReceives - recv_tracknumber is now 1-based, as it should be(thanks to woodslanding)
  - Routing: AddTrackAUXSendReceives - had parameters tracknumber and recv_tracknumber accidentally reversed, when not working with StateChunks .. oops -> fixed (thanks to woodslanding)
--]]

function ultraschall.GFX_GetMouseCap(doubleclick_wait, drag_wait)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_GetMouseCap</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string clickstate, string specific_clickstate, integer mouse_cap, integer click_x, integer click_y, integer drag_x, integer drag_y, integer mouse_wheel, integer mouse_hwheel = ultraschall.GFX_GetMouseCap(optional integer doubleclick_wait, optional integer drag_wait)</functioncall>
  <description>
    Checks mouseclick/wheel-behavior, since last time calling this function and returns it's state.
    Allows you to get click, doubleclick, dragging, including the appropriate coordinates and mousewheel-states.

    Much more convenient, than fiddling around with gfx.mouse_cap
    
    Note: After doubleclicked, this will not return mouse-clicked-states, until the mouse-button is released. So any mouse-clicks during that can be only gotten from the retval mouse_cap.
          This is to prevent automatic mouse-dragging after double-clicks.
  </description>
  <parameters>
    optional integer doubleclick_wait - the timeframe, in which a second click is recognized as double-click, in defer-cycles. 30 is approximately 1 second; nil, will use 15(default)
    optional integer drag_wait - the timeframe, after which a mouseclick without moving the mouse is recognized as dragging, in defer-cycles. 30 is approximately 1 second; nil, will use 5(default)
  </parameters>
  <retvals>
      string clickstate - "", if not clicked, "CLK" for clicked and "FirstCLK", if the click is a first-click.
      string specific_clickstate - either "" for not clicked, "CLK" for clicked, "DBLCLK" for doubleclick or "DRAG" for dragging
      integer mouse_cap - the mouse_cap, a bitfield of mouse and keyboard modifier states
                        -   1: left mouse button
                        -   2: right mouse button
                        -   4: Control key
                        -   8: Shift key
                        -   16: Alt key
                        -   32: Windows key
                        -   64: middle mouse button
      integer click_x - the x position, when the mouse has been clicked the last time
      integer click_y - the y position, when the mouse has been clicked the last time
      integer drag_x  - the x-position of the mouse-dragging-coordinate; is like click_x for non-dragging mousestates
      integer drag_y  - the y-position of the mouse-dragging-coordinate; is like click_y for non-dragging mousestates
      integer mouse_wheel - the mouse_wheel-delta, since the last time calling this function
      integer mouse_hwheel - the mouse_wheel-delta, since the last time calling this function
  </retvals>
  <chapter_context>
    Mouse Handling
  </chapter_context>
  <target_document>USApiGfxReference</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, mouse, mouse cap, leftclick, rightclick, doubleclick, drag, wheel, mousewheel, horizontal mousewheel</tags>
</US_DocBloc>
]]
--HUITOO=reaper.time_precise()
  -- prepare variables
  if ultraschall.mouse_last_mousecap==nil then
    -- if mouse-function hasn't been used yet, initialize variables
    ultraschall.mouse_last_mousecap=0         -- last mousecap when last time this function got called, including 0
    ultraschall.mouse_last_clicked_mousecap=0 -- last mousecap, the last time a button was clicked
    ultraschall.mouse_dragcounter=0           -- the counter for click and wait, until drag is "activated"
    ultraschall.mouse_lastx=0                 -- last mouse-x position
    ultraschall.mouse_lasty=0                 -- last mouse-y position
    ultraschall.mouse_endx=0                  -- end-x-position, for dragging
    ultraschall.mouse_endy=0                  -- end-y-position, for dragging
    ultraschall.mouse_dblclick=0              -- double-click-counter; 1, if a possible doubleclick can happen
    ultraschall.mouse_dblclick_counter=0      -- double-click-waiting-counter; doubleclicks are only recognized, until this is "full"
    ultraschall.mouse_clickblock=false        -- blocks mouseclicks after double-click, until button-release
    ultraschall.mouse_last_hwheel=0           -- last horizontal mouse-wheel-state, the last time this function got called
    ultraschall.mouse_last_wheel=0            -- last mouse-wheel-state, the last time this function got called
  end
  if math.type(doubleclick_wait)~="integer" then doubleclick_wait=15 end
  if math.type(drag_wait)~="integer" then drag_wait=5 end
  
  -- if mousewheels have been changed, store the new values and reset the gfx-variables
  if ultraschall.mouse_last_hwheel~=gfx.mouse_hwheel or ultraschall.mouse_last_wheel~=gfx.mouse_wheel then
    ultraschall.mouse_last_hwheel=math.floor(gfx.mouse_hwheel)
    ultraschall.mouse_last_wheel=math.floor(gfx.mouse_wheel)
  end
  gfx.mouse_hwheel=0
  gfx.mouse_wheel=0
  
  local newmouse_cap=0
  if gfx.mouse_cap&1~=0 then newmouse_cap=newmouse_cap+1 end
  if gfx.mouse_cap&2~=0 then newmouse_cap=newmouse_cap+2 end
  if gfx.mouse_cap&64~=0 then newmouse_cap=newmouse_cap+64 end
  
  if newmouse_cap==0 then
  -- if no mouse_cap is set, reset all counting-variables and return just the basics
    ultraschall.mouse_last_mousecap=0
    ultraschall.mouse_dragcounter=0
    ultraschall.mouse_dblclick_counter=ultraschall.mouse_dblclick_counter+1
    if ultraschall.mouse_dblclick_counter>doubleclick_wait then
      -- if the doubleclick-timer is over, the next click will be recognized as normal click
      ultraschall.mouse_dblclick=0
      ultraschall.mouse_dblclick_counter=doubleclick_wait
    end
    ultraschall.mouse_clickblock=false
    return "", "", gfx.mouse_cap, gfx.mouse_x, gfx.mouse_y, gfx.mouse_x, gfx.mouse_y, ultraschall.mouse_last_wheel, ultraschall.mouse_last_hwheel
  end
  if ultraschall.mouse_clickblock==false then
    
    if newmouse_cap~=ultraschall.mouse_last_mousecap then
      -- first mouseclick
      if ultraschall.mouse_dblclick~=1 or (ultraschall.mouse_lastx==gfx.mouse_x and ultraschall.mouse_lasty==gfx.mouse_y) then

        -- double-click-checks
        if ultraschall.mouse_dblclick~=1 then
          -- the first click, activates the double-click-timer
          ultraschall.mouse_dblclick=1
          ultraschall.mouse_dblclick_counter=0
        elseif ultraschall.mouse_dblclick==1 and ultraschall.mouse_dblclick_counter<doubleclick_wait 
            and ultraschall.mouse_last_clicked_mousecap==newmouse_cap then
          -- when doubleclick occured, gfx.mousecap is still the same as the last clicked mousecap:
          -- block further mouseclick, until mousebutton is released and return doubleclick-values
          ultraschall.mouse_dblclick=2
          ultraschall.mouse_dblclick_counter=doubleclick_wait
          ultraschall.mouse_clickblock=true
          return "CLK", "DBLCLK", gfx.mouse_cap, ultraschall.mouse_lastx, ultraschall.mouse_lasty, ultraschall.mouse_lastx, ultraschall.mouse_lasty, ultraschall.mouse_last_wheel, ultraschall.mouse_last_hwheel
        elseif ultraschall.mouse_dblclick_counter==doubleclick_wait then
          -- when doubleclick-timer is full, reset mouse_dblclick to 0, so the next mouseclick is 
          -- recognized as normal mouseclick
          ultraschall.mouse_dblclick=0
          ultraschall.mouse_dblclick_counter=doubleclick_wait
        end
      end
      -- in every other case, this is a first-click, so set the appropriate variables and return 
      -- the first-click state and values
      ultraschall.mouse_last_mousecap=newmouse_cap
      ultraschall.mouse_last_clicked_mousecap=newmouse_cap
      ultraschall.mouse_lastx=gfx.mouse_x
      ultraschall.mouse_lasty=gfx.mouse_y
      return "CLK", "FirstCLK", gfx.mouse_cap, ultraschall.mouse_lastx, ultraschall.mouse_lasty, ultraschall.mouse_lastx, ultraschall.mouse_lasty, ultraschall.mouse_last_wheel, ultraschall.mouse_last_hwheel
    elseif newmouse_cap==ultraschall.mouse_last_mousecap and ultraschall.mouse_dragcounter<drag_wait
      and (gfx.mouse_x~=ultraschall.mouse_lastx or gfx.mouse_y~=ultraschall.mouse_lasty) then
      -- dragging when mouse moves, sets dragcounter to full waiting-period
      ultraschall.mouse_endx=gfx.mouse_x
      ultraschall.mouse_endy=gfx.mouse_y
      ultraschall.mouse_dragcounter=drag_wait
      ultraschall.mouse_dblclick=0
      return "CLK", "DRAG", gfx.mouse_cap, ultraschall.mouse_lastx, ultraschall.mouse_lasty, ultraschall.mouse_endx, ultraschall.mouse_endy, ultraschall.mouse_last_wheel, ultraschall.mouse_last_hwheel
    elseif newmouse_cap==ultraschall.mouse_last_mousecap and ultraschall.mouse_dragcounter<drag_wait then
      -- when clicked but mouse doesn't move, count up, until we reach the countlimit for
      -- activating dragging
      ultraschall.mouse_dragcounter=ultraschall.mouse_dragcounter+1
      return "CLK", "CLK", gfx.mouse_cap, ultraschall.mouse_lastx, ultraschall.mouse_lasty, ultraschall.mouse_endx, ultraschall.mouse_endy, ultraschall.mouse_last_wheel, ultraschall.mouse_last_hwheel
    elseif newmouse_cap==ultraschall.mouse_last_mousecap and ultraschall.mouse_dragcounter==drag_wait then
      -- dragging, after drag-counter is set to full waiting-period
      ultraschall.mouse_endx=gfx.mouse_x
      ultraschall.mouse_endy=gfx.mouse_y
      ultraschall.mouse_dblclick=0
      return "CLK", "DRAG", gfx.mouse_cap, ultraschall.mouse_lastx, ultraschall.mouse_lasty, ultraschall.mouse_endx, ultraschall.mouse_endy, ultraschall.mouse_last_wheel, ultraschall.mouse_last_hwheel
    end
  else
    return "", "", gfx.mouse_cap, gfx.mouse_x, gfx.mouse_y, gfx.mouse_x, gfx.mouse_y, ultraschall.mouse_last_wheel, ultraschall.mouse_last_hwheel
  end
end 

function ultraschall.Base64_Encoder(source_string, base64_type, remove_newlines, remove_tabs)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Base64_Encoder</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string encoded_string = ultraschall.Base64_Encoder(string source_string, optional integer base64_type, optional integer remove_newlines, optional integer remove_tabs)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Converts a string into a Base64-Encoded string. 
    Currently, only standard Base64-encoding is supported.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string encoded_string - the encoded string
  </retvals>
  <parameters>
    string source_string - the string that you want to convert into Base64
    optional integer base64_type - the Base64-decoding-style
                                 - nil or 0, for standard default Base64-encoding
    optional integer remove_newlines - 1, removes \n-newlines(including \r-carriage return) from the string
                                     - 2, replaces \n-newlines(including \r-carriage return) from the string with a single space
    optional integer remove_tabs     - 1, removes \t-tabs from the string
                                     - 2, replaces \t-tabs from the string with a single space
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, convert, encode, base64, string</tags>
</US_DocBloc>
]]
  -- Not to myself:
  -- When you do the decoder, you need to take care, that the bitorder must be changed first, before creating the final-decoded characters
  -- that means: reverse the process of the "tear apart the source-string into bits"-code-passage
  
  -- check parameters and prepare variables
  if type(source_string)~="string" then ultraschall.AddErrorMessage("Base64_Encoder", "source_string", "must be a string", -1) return nil end
  if remove_newlines~=nil and math.type(remove_newlines)~="integer" then ultraschall.AddErrorMessage("Base64_Encoder", "remove_newlines", "must be an integer", -2) return nil end
  if remove_tabs~=nil and math.type(remove_tabs)~="integer" then ultraschall.AddErrorMessage("Base64_Encoder", "remove_tabs", "must be an integer", -3) return nil end
  if base64_type~=nil and math.type(base64_type)~="integer" then ultraschall.AddErrorMessage("Base64_Encoder", "base64_type", "must be an integer", -4) return nil end
  
  local tempstring={}
  local a=1
  local temp
  
  -- this is probably the future space for more base64-encoding-schemes
  local base64_string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    
  -- if source_string is multiline, get rid of \r and replace \t and \n with a single whitespace
  if remove_newlines==1 then
    source_string=string.gsub(source_string, "\n", "")
    source_string=string.gsub(source_string, "\r", "")
  elseif remove_newlines==2 then
    source_string=string.gsub(source_string, "\n", " ")
    source_string=string.gsub(source_string, "\r", "")  
  end

  if remove_tabs==1 then
    source_string=string.gsub(source_string, "\t", "")
  elseif remove_tabs==2 then 
    source_string=string.gsub(source_string, "\t", " ")
  end
  
  
  -- tear apart the source-string into bits
  -- bitorder of bytes will be reversed for the later parts of the conversion!
  for i=1, source_string:len()-1 do
    temp=string.byte(source_string:sub(i,i))
    temp=temp
    if temp&1==0 then tempstring[a+7]=0 else tempstring[a+7]=1 end
    if temp&2==0 then tempstring[a+6]=0 else tempstring[a+6]=1 end
    if temp&4==0 then tempstring[a+5]=0 else tempstring[a+5]=1 end
    if temp&8==0 then tempstring[a+4]=0 else tempstring[a+4]=1 end
    if temp&16==0 then tempstring[a+3]=0 else tempstring[a+3]=1 end
    if temp&32==0 then tempstring[a+2]=0 else tempstring[a+2]=1 end
    if temp&64==0 then tempstring[a+1]=0 else tempstring[a+1]=1 end
    if temp&128==0 then tempstring[a]=0 else tempstring[a]=1 end
    a=a+8
  end
  
  -- now do the encoding
  local encoded_string=""
  local temp2=0
  
  -- take six bits and make a single integer-value off of it
  -- after that, use this integer to know, which place in the base64_string must
  -- be read and included into the final string "encoded_string"
  for i=0, a-2, 6 do
    temp2=0
    if tempstring[i+1]==1 then temp2=temp2+32 end
    if tempstring[i+2]==1 then temp2=temp2+16 end
    if tempstring[i+3]==1 then temp2=temp2+8 end
    if tempstring[i+4]==1 then temp2=temp2+4 end
    if tempstring[i+5]==1 then temp2=temp2+2 end
    if tempstring[i+6]==1 then temp2=temp2+1 end
    encoded_string=encoded_string..base64_string:sub(temp2+1,temp2+1)
  end

  -- if the number of characters in the encoded_string isn't exactly divideable 
  -- by 3, add = to fill up missing bytes
  if encoded_string:len()%3==2 then encoded_string=encoded_string.."=="
  elseif encoded_string:len()%3==1 then encoded_string=encoded_string.."="
  end
  
  return encoded_string
end


function ultraschall.GetReaperAppVersion()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperAppVersion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer majorversion, integer subversion, string bits, string operating_system, boolean portable, optional string betaversion = ultraschall.GetReaperAppVersion()</functioncall>
  <description>
    Returns operating system and if it's a 64bit/32bit-operating system.
  </description>
  <retvals>
    integer majorversion - the majorversion of Reaper. Can be used for comparisions like "if version<5 then ... end".
    integer subversion - the subversion of Reaper. Can be used for comparisions like "if subversion<96 then ... end".
    string bits - the number of bits of the reaper-app
    string operating_system - the operating system, either "Win", "OSX" or "Other"
    boolean portable - true, if it's a portable installation; false, if it isn't a portable installation
    optional string betaversion - if you use a pre-release of Reaper, this contains the beta-version, like "rc9" or "+dev0423" or "pre6"
  </retvals>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, appversion, reaper, version, bits, majorversion, subversion, operating system</tags>
</US_DocBloc>
--]]
  -- if exe-path and resource-path are the same, it is an portable-installation
  if reaper.GetExePath()==reaper.GetResourcePath() then portable=true else portable=false end
  -- separate the returned value from GetAppVersion
  local majvers=tonumber(reaper.GetAppVersion():match("(.-)%..-/"))
  local subvers=tonumber(reaper.GetAppVersion():match("%.(%d*)"))
  local bits=reaper.GetAppVersion():match("/(.*)")
  local OS=reaper.GetOS():match("(.-)%d")
  local beta=reaper.GetAppVersion():match("%.%d*(.-)/")
  return majvers, subvers, bits, OS, portable, beta
end


function ultraschall.GetProject_NumberOfTracks(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_NumberOfTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer number_of_tracks = ultraschall.GetProject_NumberOfTracks(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the number of tracks within an rpp-project-file or a GetProject_NumberOfTracks.
    Returns -1 in case of error.
    
    Note: Huge projectfiles with thousands of items may take some seconds to load.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer number_of_tracks - the number of tracks within an projectfile
  </retvals>
  <chapter_context>
    Project-Files
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, rpp, state, get, track, count</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_NumberOfTracks","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return -1 end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_NumberOfTracks","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return -1 end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_NumberOfTracks","projectfilename_with_path", "File does not exist!", -3) return -1
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_NumberOfTracks", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return -1 end
  end
  
  -- count tracks and return the number
  local count=0
  for w in string.gmatch(ProjectStateChunk, "<TRACK.-%c") do
      count=count+1
  end
  return count
end


function ultraschall.GetProject_RenderFilename(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderFilename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string render_filename = ultraschall.GetProject_RenderFilename(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the render-filename from an RPP-Projectfile or a ProjectStateChunk. If it contains only a path or nothing, you should check the Render_Pattern using <a href="#GetProject_RenderPattern">GetProject_RenderPattern</a>, as a render-pattern influences the rendering-filename as well.
    
    It's the entry RENDER_FILE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string render_filename - the filename for rendering, check also <a href="#GetProject_RenderPattern">GetProject_RenderPattern</a>
  </retvals>
  <chapter_context>
    Project-Files
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, rpp, state, get, recording, path, render filename, filename, render</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RenderFilename","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderFilename","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_RenderFilename","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderFilename", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the value and return it
  local temp=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_FILE%s(.-)%c.-<RENDER_CFG")
  if temp==nil then temp="" end
  if temp:sub(1,1)=="\"" then temp=temp:sub(2,-1) end
  if temp:sub(-1,-1)=="\"" then temp=temp:sub(1,-2) end
  return temp
end

function ultraschall.GetTrackAUXSendReceives(tracknumber, idx, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number pan_law, integer midichanflag, integer automation = ultraschall.GetTrackAUXSendReceives(integer tracknumber, integer idx, optional string TrackStateChunk)</functioncall>
  <description>
    Returns the settings of the Send/Receive, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber. There can be more than one, which you can choose with idx.
    Remember, if you want to get the sends of a track, you need to check the recv_tracknumber-returnvalues of the OTHER(!) tracks, as you can only get the receives. With the receives checked, you know, which track sends.
    
    It's the entry AUXRECV
    
    returns -1 in case of failure
  </description>
  <parameters markup_type="markdown" markup_version="1.0.1" indent="default">
    integer tracknumber - the number of the track, whose Send/Receive you want
    integer idx - the id-number of the Send/Receive, beginning with 1 for the first Send/Receive-Settings
    optional string TrackStateChunk - a TrackStateChunk, whose AUXRECV-entries you want to get
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    integer recv_tracknumber - Tracknumber, from where to receive the audio from
    integer post_pre_fader - 0-PostFader, 1-PreFX, 3-Pre-Fader
    number volume - Volume; see [MKVOL2DB](#MKVOL2DB) to convert it into a dB-value
    number pan - pan, as set in the Destination "Controls for Track"-dialogue; negative=left, positive=right, 0=center
    integer mute - Mute this send(1) or not(0)
    integer mono_stereo - Mono(1), Stereo(0)
    integer phase - Phase of this send on(1) or off(0)
    integer chan_src - Audio-Channel Source
    -                                        -1 - None
    -                                        0 - Stereo Source 1/2
    -                                        1 - Stereo Source 2/3
    -                                        2 - Stereo Source 3/4
    -                                        1024 - Mono Source 1
    -                                        1025 - Mono Source 2
    -                                        2048 - Multichannel Source 4 Channels 1-4
    integer snd_chan - send to channel
    -                                        0 - Stereo 1/2
    -                                        1 - Stereo 2/3
    -                                        2 - Stereo 3/4
    -                                        ...
    -                                        1024 - Mono Channel 1
    -                                        1025 - Mono Channel 2
    number pan_law - pan-law, as set in the dialog that opens, when you right-click on the pan-slider in the routing-settings-dialog; default is -1 for +0.0dB
    integer midichanflag -0 - All Midi Tracks
    -                                        1 to 16 - Midi Channel 1 to 16
    -                                        32 - send to Midi Channel 1
    -                                        64 - send to MIDI Channel 2
    -                                        96 - send to MIDI Channel 3
    -                                        ...
    -                                        512 - send to MIDI Channel 16
    -                                        4194304 - send to MIDI-Bus B1
    -                                        send to MIDI-Bus B1 + send to MIDI Channel nr = MIDIBus B1 1/nr:
    -                                        16384 - BusB1
    -                                        BusB1+1 to 16 - BusB1-Channel 1 to 16
    -                                        32768 - BusB2
    -                                        BusB2+1 to 16 - BusB2-Channel 1 to 16
    -                                        49152 - BusB3
    -                                        ...
    -                                        BusB3+1 to 16 - BusB3-Channel 1 to 16
    -                                        262144 - BusB16
    -                                        BusB16+1 to 16 - BusB16-Channel 1 to 16
    -
    -                                        1024 - Add that value to switch MIDI On
    -                                        4177951 - MIDI - None
    integer automation - Automation Mode
    -                                       -1 - Track Automation Mode
    -                                        0 - Trim/Read
    -                                        1 - Read
    -                                        2 - Touch
    -                                        3 - Write
    -                                        4 - Latch
    -                                        5 - Latch Preview
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>trackmanagement, track, get, send, receive, phase, source, mute, pan, volume, post, pre, fader, channel, automation, midi, trackstatechunk, pan-law</tags>
</US_DocBloc>
]]

  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "tracknumber", "must be an integer", -1) return -1 end
  if tracknumber~=-1 and (tracknumber<1 or tracknumber>reaper.CountTracks(0)) then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "tracknumber", "no such track", -2) return -1 end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "idx", "must be an integer", -3) return -1 end
  if idx<1 then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "idx", "no such index available", -4) return -1 end

  if tracknumber~=-1 then 
    local tr=reaper.GetTrack(0,tracknumber-1)
    if reaper.GetTrackNumSends(tr, -1)<idx then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "idx", "no such index available", -5) return -1 end
    local sendidx=idx
    return math.tointeger(reaper.GetMediaTrackInfo_Value(reaper.BR_GetMediaTrackSendInfo_Track(tr, -1, sendidx-1, 0), "IP_TRACKNUMBER")-1)+1, -- D1
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_SENDMODE")), -- D2
           reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "D_VOL"),  -- D3
           reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "D_PAN"),  -- D4
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "B_MUTE")), -- D5
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "B_MONO")), -- D6
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "B_PHASE")),-- D7
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_SRCCHAN")), -- D8
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_DSTCHAN")), -- D9
           reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "D_PANLAW"), -- D10
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_MIDIFLAGS")), -- D11
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_AUTOMODE")) -- D12  
  end
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "TrackStateChunk", "must be a valid TrackStateChunk", -6) return -1 end
  if ultraschall.CountTrackAUXSendReceives(-1, TrackStateChunk)<idx then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "idx", "no such entry", -7) return -1 end
  
  local count=1
  
  for k in string.gmatch(TrackStateChunk, "AUXRECV.-\n") do
    if count==idx then 
      local count2, individual_values = ultraschall.CSV2IndividualLinesAsArray(k:match(" (.*)".." "), " ")
      table.remove(individual_values, count2)
      for i=1, count2-1 do
        if tonumber(individual_values[i])~=nil then individual_values[i]=tonumber(individual_values[i]) end
      end
      individual_values[1]=individual_values[1]+1
      individual_values[10]=tonumber(individual_values[10]:sub(1,-3))
      return table.unpack(individual_values)
    end
    count=count+1
  end
end

function ultraschall.SetTrackAUXSendReceives(tracknumber, idx, recv_tracknumber, post_pre_fader, volume, pan, mute, mono_stereo, phase, chan_src, snd_chan, pan_law, midichanflag, automation, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string TrackStateChunk = ultraschall.SetTrackAUXSendReceives(integer tracknumber, integer idx, integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number pan_law, integer midichanflag, integer automation, optional string TrackStateChunk)</functioncall>
  <description>
    Alters a setting of Send/Receive, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber. There can be more than one, so choose the right one with idx.
    You can keep the old-setting by using nil as a parametervalue.
    Remember, if you want to set the sends of a track, you need to add it to the track, that shall receive, not the track that sends! Set recv_tracknumber in the track that receives with the tracknumber that sends, and you've set it successfully.
    
    Due to the complexity of send/receive-settings, this function does not check, whether the parameters are plausible. So check twice, whether the change sends/receives still appear, as they might disappear with faulty settings!
    returns false in case of failure
  </description>
  <parameters markup_type="markdown" markup_version="1.0.1" indent="default">
    integer tracknumber - the number of the track, whose Send/Receive you want
    integer idx - the send/receive-setting, you want to set
    integer recv_tracknumber - Tracknumber, from where to receive the audio from
    integer post_pre_fader - 0-PostFader, 1-PreFX, 3-Pre-Fader
    number volume - Volume; see [DB2MKVOL](#DB2MKVOL) to convert from a dB-value
    number pan - pan, as set in the Destination "Controls for Track"-dialogue; negative=left, positive=right, 0=center
    integer mute - Mute this send(1) or not(0)
    integer mono_stereo - Mono(1), Stereo(0)
    integer phase - Phase of this send on(1) or off(0)
    integer chan_src - Audio-Channel Source
    -                                        -1 - None
    -                                        0 - Stereo Source 1/2
    -                                        1 - Stereo Source 2/3
    -                                        2 - Stereo Source 3/4
    -                                        1024 - Mono Source 1
    -                                        1025 - Mono Source 2
    -                                        2048 - Multichannel Source 4 Channels 1-4
    integer snd_chan - send to channel
    -                                        0 - Stereo 1/2
    -                                        1 - Stereo 2/3
    -                                        2 - Stereo 3/4
    -                                        ...
    -                                        1024 - Mono Channel 1
    -                                        1025 - Mono Channel 2
    number pan_law - pan-law, as set in the dialog that opens, when you right-click on the pan-slider in the routing-settings-dialog; default is -1 for +0.0dB
    integer midichanflag -0 - All Midi Tracks
    -                                        1 to 16 - Midi Channel 1 to 16
    -                                        32 - send to Midi Channel 1
    -                                        64 - send to MIDI Channel 2
    -                                        96 - send to MIDI Channel 3
    -                                        ...
    -                                        512 - send to MIDI Channel 16
    -                                        4194304 - send to MIDI-Bus B1
    -                                        send to MIDI-Bus B1 + send to MIDI Channel nr = MIDIBus B1 1/nr:
    -                                        16384 - BusB1
    -                                        BusB1+1 to 16 - BusB1-Channel 1 to 16
    -                                        32768 - BusB2
    -                                        BusB2+1 to 16 - BusB2-Channel 1 to 16
    -                                        49152 - BusB3
    -                                        ...
    -                                        BusB3+1 to 16 - BusB3-Channel 1 to 16
    -                                        262144 - BusB16
    -                                        BusB16+1 to 16 - BusB16-Channel 1 to 16
    -
    -                                        1024 - Add that value to switch MIDI On
    -                                        4177951 - MIDI - None
    integer automation - Automation Mode
    -                                       -1 - Track Automation Mode
    -                                        0 - Trim/Read
    -                                        1 - Read
    -                                        2 - Touch
    -                                        3 - Write
    -                                        4 - Latch
    -                                        5 - Latch Preview
    optional string TrackStateChunk - a TrackStateChunk, whose AUXRECV-entries you want to set
  </parameters>
  <retvals>
    boolean retval - true if it worked, false if it didn't.
    optional string TrackStateChunk - an altered TrackStateChunk, whose AUXRECV-entries you've altered
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>trackmanagement, track, set, send, receive, phase, source, mute, pan, volume, post, pre, fader, channel, automation, midi, trackstatechunk, pan-law</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "tracknumber", "must be an integer", -1) return false end
  if tracknumber~=-1 and (tracknumber<1 or tracknumber>reaper.CountTracks(0)) then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "tracknumber", "no such track", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "idx", "must be an integer", -16) return false end
  if idx<1 then ultraschall.AddErrorMessage("SetTrackHWOut", "idx", "no such index", -20) return false end
  if math.type(recv_tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "recv_tracknumber", "must be an integer", -3) return false end
  if math.type(post_pre_fader)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "post_pre_fader", "must be an integer", -4) return false end
  if type(volume)~="number" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "volume", "must be a number", -5) return false end
  if type(pan)~="number" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "pan", "must be a number", -6) return false end
  if math.type(mute)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "mute", "must be an integer", -7) return false end
  if math.type(mono_stereo)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "mono_stereo", "must be an integer", -8) return false end
  if math.type(phase)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "phase", "must be an integer", -9) return false end
  if math.type(chan_src)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "chan_src", "must be a number", -10) return false end
  if math.type(snd_chan)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "snd_chan", "must be an integer", -11) return false end
  if type(pan_law)~="number" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "pan_law", "must be a number", -12) return false end
  if math.type(midichanflag)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "midichanflag", "must be an integer", -13) return false end
  if math.type(automation)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "automation", "must be an integer", -14) return false end
  
  local tr, temp, Track
  if tracknumber~=-1 then
    if tracknumber==0 then tr=reaper.GetMasterTrack(0)
    else tr=reaper.GetTrack(0,tracknumber-1) end
    if idx>reaper.GetTrackNumSends(tr, -1) then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "idx", "no such index", -17) return false end
    temp, TrackStateChunk=reaper.GetTrackStateChunk(tr, "", false)
  end  
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "TrackStateChunk", "must be a valid TrackStateChunk", -18) return false end
  if ultraschall.CountTrackAUXSendReceives(-1, TrackStateChunk)<idx then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "idx", "no such index", -19) return false end
  
  local Start, Offset=TrackStateChunk:match("(.-PERF.-\n)()")
  local Ende = TrackStateChunk:match(".*AUXRECV.-\n(.*)")
  local count=1
  local Middle="AUXRECV "..(recv_tracknumber-1).." "..post_pre_fader.." "..volume.." "..pan.." "..mute.." ".. mono_stereo.." "..phase.." "..chan_src.." "..snd_chan.." "..pan_law..":U "..midichanflag.." "..automation.." ''\n"
  local Middle1=""
  local Middle2=""
  
  for k in string.gmatch(TrackStateChunk, "AUXRECV.-\n") do
    if count<idx then Middle1=Middle1..k end
    if count>idx then Middle2=Middle2..k end
    count=count+1
  end
  
  TrackStateChunk=Start..Middle1..Middle..Middle2..Ende
  if tracknumber==-1 then
    return true, TrackStateChunk
  else
    reaper.SetTrackStateChunk(tr, TrackStateChunk, false)
  end
end

function ultraschall.AddTrackAUXSendReceives(tracknumber, recv_tracknumber, post_pre_fader, volume, pan, mute, mono_stereo, phase, chan_src, snd_chan, pan_law, midichanflag, automation, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddTrackAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string TrackStateChunk = ultraschall.AddTrackAUXSendReceives(integer tracknumber, integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number pan_law, integer midichanflag, integer automation, optional string TrackStateChunk)</functioncall>
  <description>
    Adds a setting of Send/Receive, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber. There can be more than one.
    Remember, if you want to set the sends of a track, you need to add it to the track, that shall receive, not the track that sends! Set recv_tracknumber in the track that receives with the tracknumber that sends, and you've set it successfully.
    
    Due to the complexity of send/receive-settings, this function does not check, whether the parameters are plausible. So check twice, whether the added sends/receives appear, as they might not appear!
    returns false in case of failure
  </description>
  <parameters markup_type="markdown" markup_version="1.0.1" indent="default">
    integer tracknumber - the number of the track, whose Send/Receive you want; -1, if you want to use the parameter TrackStateChunk
    integer recv_tracknumber - Tracknumber, from where to receive the audio from
    integer post_pre_fader - 0-PostFader, 1-PreFX, 3-Pre-Fader
    number volume - Volume, see [DB2MKVOL](#DB2MKVOL) to convert from a dB-value
    number pan - pan, as set in the Destination "Controls for Track"-dialogue; negative=left, positive=right, 0=center
    integer mute - Mute this send(1) or not(0)
    integer mono_stereo - Mono(1), Stereo(0)
    integer phase - Phase of this send on(1) or off(0)
    integer chan_src - Audio-Channel Source
    -                                       -1 - None
    -                                        0 - Stereo Source 1/2
    -                                        1 - Stereo Source 2/3
    -                                        2 - Stereo Source 3/4
    -                                        1024 - Mono Source 1
    -                                        1025 - Mono Source 2
    -                                        2048 - Multichannel Source 4 Channels 1-4
    integer snd_chan - send to channel
    -                                        0 - Stereo 1/2
    -                                        1 - Stereo 2/3
    -                                        2 - Stereo 3/4
    -                                        ...
    -                                        1024 - Mono Channel 1
    -                                        1025 - Mono Channel 2
    number pan_law - pan-law, as set in the dialog that opens, when you right-click on the pan-slider in the routing-settings-dialog; default is -1 for +0.0dB
    integer midichanflag -0 - All Midi Tracks
    -                                        1 to 16 - Midi Channel 1 to 16
    -                                        32 - send to Midi Channel 1
    -                                        64 - send to MIDI Channel 2
    -                                        96 - send to MIDI Channel 3
    -                                        ...
    -                                        512 - send to MIDI Channel 16    
    -                                        4194304 - send to MIDI-Bus B1
    -                                        send to MIDI-Bus B1 + send to MIDI Channel nr = MIDIBus B1 1/nr:
    -                                        16384 - BusB1
    -                                        BusB1+1 to 16 - BusB1-Channel 1 to 16
    -                                        32768 - BusB2
    -                                        BusB2+1 to 16 - BusB2-Channel 1 to 16
    -                                        49152 - BusB3
    -                                        ...
    -                                        BusB3+1 to 16 - BusB3-Channel 1 to 16
    -                                        262144 - BusB16
    -                                        BusB16+1 to 16 - BusB16-Channel 1 to 16
    -
    -                                        1024 - Add that value to switch MIDI On
    -                                        4177951 - MIDI - None
    integer automation - Automation Mode
    -                                       -1 - Track Automation Mode
    -                                        0 - Trim/Read
    -                                        1 - Read
    -                                        2 - Touch
    -                                        3 - Write
    -                                        4 - Latch
    -                                        5 - Latch Preview
    optional string TrackStateChunk - the TrackStateChunk, to which you want to add a new receive-routing
  </parameters>
  <retvals>
    boolean retval - true if it worked, false if it didn't.
    optional parameter TrackStateChunk - an altered TrackStateChunk into which you added a new receive/routing; only available, when tracknumber=-1
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>trackmanagement, track, add, send, receive, phase, source, mute, pan, volume, post, pre, fader, channel, automation, midi, pan-law, trackstatechunk</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "tracknumber", "no such track", -2) return false end
  if math.type(recv_tracknumber)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "recv_tracknumber", "must be an integer", -3) return false end
  if math.type(post_pre_fader)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "post_pre_fader", "must be an integer", -4) return false end
  if type(volume)~="number" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "volume", "must be a number", -5) return false end
  if type(pan)~="number" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "pan", "must be a number", -6) return false end
  if math.type(mute)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "mute", "must be an integer", -7) return false end
  if math.type(mono_stereo)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "mono_stereo", "must be an integer", -8) return false end
  if math.type(phase)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "phase", "must be an integer", -9) return false end
  if math.type(chan_src)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "chan_src", "must be a number", -10) return false end
  if math.type(snd_chan)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "snd_chan", "must be an integer", -11) return false end
  if type(pan_law)~="number" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "pan_law", "must be a number", -12) return false end
  if math.type(midichanflag)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "midichanflag", "must be an integer", -13) return false end
  if math.type(automation)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "automation", "must be an integer", -14) return false end

  if tracknumber>-1 then
    -- get track
    if tracknumber==0 then tr=reaper.GetMasterTrack(0)
    else tr=reaper.GetTrack(0,recv_tracknumber-1) end
    -- create new AUXRecv
    local sendidx=reaper.CreateTrackSend(tr, reaper.GetTrack(0,tracknumber-1))
    -- change it's settings
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_SENDMODE", post_pre_fader) -- D2
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "D_VOL", volume)  -- D3
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "D_PAN", pan)  -- D4
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "B_MUTE", mute) -- D5
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "B_MONO", mono_stereo) -- D6
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "B_PHASE", phase)-- D7
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_SRCCHAN", chan_src) -- D8
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_DSTCHAN", snd_chan) -- D9
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "D_PANLAW", pan_law) -- D10
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_MIDIFLAGS", midichanflag) -- D11
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_AUTOMODE", automation) -- D12  
    return true
  end
  
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "TrackStateChunk", "must be a valid TrackStateChunk", -16) return false end
  -- if dealing with a TrackStateChunk, then do the following
  local Startoffs=TrackStateChunk:match("PERF .-\n()")
  
  TrackStateChunk=TrackStateChunk:sub(1,Startoffs-1)..
                  "AUXRECV "..(recv_tracknumber-1).." "..post_pre_fader.." "..volume.." "..pan.." "..mute.." "..mono_stereo.." "..
                  phase.." "..chan_src.." "..snd_chan.." "..pan_law..":U "..midichanflag.." "..automation.." ''".."\n"..
                  TrackStateChunk:sub(Startoffs,-1)
                  
  return true, TrackStateChunk
end
