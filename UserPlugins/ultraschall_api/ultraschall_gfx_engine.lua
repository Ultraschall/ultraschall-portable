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

--------------------------------------
--- ULTRASCHALL - API - GFX-Engine ---
--------------------------------------


if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "GFX-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  if string=="" then string=10000 
  else 
    string=tonumber(string) 
    string=string+1
  end
  if string2=="" then string2=10000 
  else 
    string2=tonumber(string2)
    string2=string2+1
  end
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "GFX-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
  local Retval, HWND=ultraschall.GFX_Init()
end

if ultraschall.GFX_WindowHWND==nil then ultraschall.GFX_WindowHWND="Please, use ultraschall.GFX_Init() for window-creation, not gfx.init(!), to retrieve the HWND of the gfx-window." end

function ultraschall.GFX_DrawThickRoundRect(x,y,w,h,thickness, roundness, antialias)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_DrawThickRoundRect</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GFX_DrawThickRoundRect(integer x, integer y, integer w, integer h, number thickness, number roundness, boolean antialias)</functioncall>
  <description>
    draws a round-rectangle with a custom thickness.
    
    You shouldn't redraw with it too often, as it eats many ressources
    
    returns false in case of an error
  </description>
  <parameters>
    integer x - the x position of the rectangle
    integer y - the y position of the rectangle
    integer w - the width of the rectangle
    integer h - the height of the rectangle
    number thickness - the thickness of the rectangle's edges
    number roundness - the angle of the rectangle's corners
    boolean antialias - true, draw antialiased; false, simply draw aliased
  </parameters>
  <retvals>
    boolean retval - true, drawing was successful; false, drawing wasn't successful
  </retvals>
  <chapter_context>
    Basic Shapes
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, gfx, draw, thickness, round rectangle</tags>
</US_DocBloc>
]]
  if gfx.getchar()==-1 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "", "no gfx-window opened", -1) return false end
  if ultraschall.type(x)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "x", "must be an integer", -2) return false end
  if ultraschall.type(y)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "y", "must be an integer", -3) return false end
  if ultraschall.type(w)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "w", "must be an integer", -4) return false end
  if ultraschall.type(h)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "h", "must be an integer", -5) return false end
  if type(thickness)~="number" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "thickness", "must be a number", -6) return false end
  if type(roundness)~="number" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "roundness", "must be a number", -12) return false end
  if x<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "x", "must be bigger than 0", -7) return false end
  if y<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "y", "must be bigger than 0", -8) return false end
  if w<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "w", "must be bigger than 0", -9) return false end
  if h<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "h", "must be bigger than 0", -10) return false end
  if thickness<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "thickness", "must be bigger than 0", -11) return false end
  if antialias==true then antialias=1 else antialias=0 end
  for i=1, thickness, 0.5 do
    gfx.roundrect(x+i,y+1+i,w-1-(i*2),h-(i*2),roundness, antialias)
    if thickness>1 then
      gfx.roundrect(x+1+i,y+i,w-1-(i*2),h-(i*2),roundness, antialias)
      gfx.roundrect(x+i,y+i,w+1-(i*2),h-(i*2),roundness, antialias)
      gfx.roundrect(x+i,y+i,w+1-(i*2),h-1-(i*2),roundness, antialias)
    end
  end
  return true
end
--gfx.init()
--A=ultraschall.GFX_DrawThickRoundRect(1,2,300,140,5,40,true)

function ultraschall.GFX_BlitFramebuffer(framebufferidx, showidx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_BlitFramebuffer</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GFX_BlitFramebuffer(integer framebufferidx, optional boolean showidx)</functioncall>
  <description>
    blits a framebuffer at position 0,0. If the gfx-window is smaller than the contents of the framebuffer, it will resize it before blitting to window size, retaining the correct aspect-ratio.
    
    Mostly intended for debugging-purposes, when you want to track, if a certain framebuffer contains, what you expect it to contain.
    
    returns false in case of an error
  </description>
  <parameters>
    integer framebufferidx - the indexnumber of the framebuffer to blit; 0 to 1023; -1 is the displaying framebuffer
    optional boolean showidx - true, displays the id-number of the framebuffer in the top-left corner; false, does not display framebuffer-idx
  </parameters>
  <retvals>
    boolean retval - true, drawing was successful; false, drawing wasn't successful
  </retvals>
  <chapter_context>
    Blitting
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, gfx, blit, framebuffer</tags>
</US_DocBloc>
]]
  if math.type(framebufferidx)~="integer" then ultraschall.AddErrorMessage("GFX_BlitFramebuffer", "framebufferidx", "must be an integer", -1) return false end
  if framebufferidx<-1 or framebufferidx>1023 then ultraschall.AddErrorMessage("GFX_BlitFramebuffer", "framebufferidx", "must be between -1 and 1023", -1) return false end
  if showidx~=nil and type(showidx)~="boolean" then ultraschall.AddErrorMessage("GFX_BlitFramebuffer", "showidx", "must be a boolean", -3) return false end
  local x,y=gfx.getimgdim(framebufferidx)
  local ratiox=((100/x)*gfx.w)/100
  local ratioy=((100/y)*gfx.h)/100
  if ratiox<ratioy then ratio=ratiox else ratio=ratioy end
  if x<gfx.w and y<gfx.h then ratio=1 end
  local oldx=gfx.x
  local oldy=gfx.y
  gfx.x=0
  gfx.y=0
  A1,B,C,D,E=gfx.blit(framebufferidx,ratio,0)
  if showidx==true then 
    gfx.x=-1
    gfx.y=0
    gfx.set(0)
    gfx.drawstr(framebufferidx) 
    gfx.x=1
    gfx.y=1
    gfx.set(0)
    gfx.drawstr(framebufferidx) 
    gfx.x=0
    gfx.y=0
    gfx.set(1)
    gfx.drawstr(framebufferidx) 
  end    
  gfx.x=oldx
  gfx.y=oldy
  return true
end

function ultraschall.AddVirtualFramebuffer(framebufferobj, fromframebuffer, from_x, from_y, from_w, from_h, to_x,to_y,to_w,to_h, repeat_x, repeat_y)
  local table2
  if type(framebufferobj)~="table" then table2={} table2["count"]=0 else table2=framebufferobj end
  table2["count"]=table2["count"]+1
  table2[table2["count"]]={}
  table2[table2["count"]]["framebuffer"]=fromframebuffer
  table2[table2["count"]]["fromx"]=from_x
  table2[table2["count"]]["fromy"]=from_y
  table2[table2["count"]]["fromw"]=from_w
  table2[table2["count"]]["fromh"]=from_h

  -- target position
  table2[table2["count"]]["tox"]=to_x
  table2[table2["count"]]["toy"]=to_y
  table2[table2["count"]]["tow"]=to_w
  table2[table2["count"]]["toh"]=to_h
  return table2
end

--gfx.loadimg(1, "c:\\us.png")
--A=ultraschall.AddVirtualFramebuffer(framebufferobj, 1, 20,20,100,100,190,190)
--A=ultraschall.AddVirtualFramebuffer(A, 1, 0,20,140,140)


function ultraschall.BlitFullVirtualFramebuffer(framebufferobj)
-- missing:   scaling
--            rotation
--            start drawing from gfx.x and gfx.y or from a parameter? And how to calculate the offsets?
--            blitting only partial virtualframebuffer
  for i=1, framebufferobj["count"] do
      if framebufferobj[i]["tox"]==nil then tox=gfx.x else tox=framebufferobj[i]["tox"] end
      if framebufferobj[i]["toy"]==nil then toy=gfx.y else toy=framebufferobj[i]["toy"] end
      framebuffer=framebufferobj[i]["framebuffer"]
      fromx=framebufferobj[i]["fromx"]
      fromy=framebufferobj[i]["fromy"]
      fromw=framebufferobj[i]["fromw"]
      fromh=framebufferobj[i]["fromh"]

    gfx.blit(framebuffer,1,0,fromx,fromy,fromw,fromh,tox,toy)
  end
end

--gfx.x=80
--gfx.y=80
--ultraschall.BlitFullVirtualFramebuffer(A)
--gfx.blit(1,1,0)
--gfx.update()


function ultraschall.GFX_CreateTextbuffer(inittext, singleline)
  count, split_string = ultraschall.SplitStringAtLineFeedToArray(inittext)
  local textbuffer={}
  if type(inittext)~="string" then inittext="" end
  textbuffer["text"]={}
  if count<2 or singleline==true then 
    inittext=string.gsub(inittext,"\n","")
    textbuffer["text"][1]=inittext
    count=1
  else
    for i=1, count do
      textbuffer["text"][i]=split_string[i]
    end
  end
--  textbuffer["xoffset"]
  textbuffer["yoffset"]=count
  textbuffer["xoffset"]=
      textbuffer["text"][textbuffer["yoffset"]]:len()
  textbuffer["maxlines"]=count
  if singleline==true then textbuffer["singlelinetext"]=true else textbuffer["singlelinetext"]=false end
  return textbuffer
end

function ultraschall.GFX_GetKey(textbuffer)
  local char=gfx.getchar()
  local alt, cmd, shift, altgr, win, _temp, character, maxlines, xoffs, yoffs, singletext
  local change=false
  if gfx.mouse_cap&4==4 and gfx.mouse_cap&16==0 then cmd=true else cmd=false end
  if gfx.mouse_cap&8==8 then shift=true else shift=false end
  if gfx.mouse_cap&16==16 and gfx.mouse_cap&4==0 then alt=true else alt=false end
  if gfx.mouse_cap&32==32 then win=true else win=false end
  if gfx.mouse_cap&16==16 and gfx.mouse_cap&4==4 then altgr=true else altgr=false end

  -- if textbuffer~=nil, then edit the text in textbuffer
  if textbuffer~=nil and char>0 then
    LL=reaper.time_precise()
    -- prepare variables
    yoffs=textbuffer["yoffset"]
    xoffs=textbuffer["xoffset"]
    maxlines=textbuffer["maxlines"]
    singletext=textbuffer["singlelinetext"]

    if char==8.0 then -- backspace
      if xoffs>0 then
        textstart=textbuffer["text"][yoffs]:sub(1,xoffs-1)
        textend=textbuffer["text"][yoffs]:sub(xoffs+1,-1)
        textbuffer["text"][yoffs]=textstart..textend
        xoffs=xoffs-1
      elseif xoffs==0 and yoffs>1 then
        xoffs=textbuffer["text"][yoffs-1]:len()
        textbuffer["text"][yoffs-1]=textbuffer["text"][yoffs-1]..textbuffer["text"][yoffs]
        table.remove(textbuffer["text"], yoffs)
        yoffs=yoffs-1
        maxlines=maxlines-1
      end
      change=true
    elseif char==6579564.0 then                         -- delete
      if xoffs<textbuffer["text"][yoffs]:len() then
        textstart=textbuffer["text"][yoffs]:sub(1,xoffs)
        textend=textbuffer["text"][yoffs]:sub(xoffs+2,-1)
        textbuffer["text"][yoffs]=textstart..textend
      elseif maxlines>1 and yoffs<maxlines then
        -- When at the end of the line and hitting Del, add next line to current line and remove next line
        textbuffer["text"][yoffs]=textbuffer["text"][yoffs]..textbuffer["text"][yoffs+1]
        table.remove(textbuffer["text"], yoffs+1)
        maxlines=maxlines-1
      end
      change=true
    elseif char==1818584692.0 then    -- left cursor key
      xoffs=xoffs-1
      if yoffs>1 and xoffs==-1 then
        yoffs=yoffs-1
        xoffs=textbuffer["text"][yoffs]:len()
      end
      change=true
    elseif char==1919379572.0 then    -- right cursor key
      xoffs=xoffs+1
      if yoffs<maxlines and xoffs==textbuffer["text"][yoffs]:len()+1 then
        yoffs=yoffs+1
        xoffs=0
      end
      change=true
    elseif char==30064.0      then yoffs=yoffs-1 change=true                 -- up cursor key
    elseif char==1685026670.0 then yoffs=yoffs+1 change=true                 -- down cursor key
    elseif char==1752132965.0 and cmd==false then xoffs=0 change=true        -- Home
    elseif char==1752132965.0 and cmd==true then xoffs=0 yoffs=1 change=true -- Cmd+Home: first line first position
    elseif char==6647396.0 and cmd==false then xoffs=textbuffer["text"][yoffs]:len() change=true -- End
    elseif char==6647396.0 and cmd==true  then xoffs=textbuffer["text"][maxlines]:len() yoffs=maxlines change=true -- Cmd+End: last line last position
    elseif char==22.0 then                              -- Insert From Clipboard Ctrl+V / Cmd+V
      if singletext==true then
        textstart=textbuffer["text"][yoffs]:sub(1,xoffs)
        textend=textbuffer["text"][yoffs]:sub(xoffs+1,-1)
        textinsert=ultraschall.GetStringFromClipboard_SWS()
        textinsert=string.gsub(textinsert,"\n","")
        textinsert=string.gsub(textinsert,"\t","    ")
        textbuffer["text"][yoffs]=textstart..textinsert..textend
        xoffs=xoffs+textinsert:len()
      else
        ACount, Split_string = ultraschall.SplitStringAtLineFeedToArray(ultraschall.GetStringFromClipboard_SWS())
        TextEnde=textbuffer["text"][yoffs]:sub(xoffs+1,-1)
        textbuffer["text"][yoffs]=textbuffer["text"][yoffs]:sub(1,xoffs)..Split_string[1]
        if ACount>1 then
          for i=2, ACount do
            yoffs=yoffs+1
            maxlines=maxlines+1
            table.insert(textbuffer["text"],yoffs, Split_string[i])
          end
        end
        textbuffer["text"][yoffs]=textbuffer["text"][yoffs]..TextEnde
        xoffs=textbuffer["text"][yoffs]:len()-TextEnde:len()
      end
      change=true
    elseif char==127 then textbuffer["text"][yoffs]="" xoffs=0 change=true-- DEBUG-CODE Ctrl+BackSp deletes line
    elseif char==27  then -- Escape-Key
    elseif char==9   then -- Tab-Key
      textstart=textbuffer["text"][yoffs]:sub(1,xoffs)
      textend=textbuffer["text"][yoffs]:sub(xoffs+1,-1)
      textbuffer["text"][yoffs]=textstart.."    "..textend
      xoffs=xoffs+4
      change=true
    elseif char==128 then 
      textstart=textbuffer["text"][yoffs]:sub(1,xoffs)
      textend=textbuffer["text"][yoffs]:sub(xoffs+1,-1)
      textbuffer["text"][yoffs]=textstart..string.char(128)..textend
      xoffs=xoffs+1
      change=true
    elseif char==13 then -- Enter-Key
      if singletext~=true then
        textstart=textbuffer["text"][yoffs]:sub(1,xoffs)
        textend=textbuffer["text"][yoffs]:sub(xoffs+1,-1)
        textbuffer["text"][yoffs]=textstart
        table.insert(textbuffer["text"], yoffs+1, textend)
        yoffs=yoffs+1
        maxlines=maxlines+1
        xoffs=0
        change=true
      end
    elseif char>31 and char<255 then -- add character to textfield
      textstart=textbuffer["text"][yoffs]:sub(1,xoffs)
      textend=textbuffer["text"][yoffs]:sub(xoffs+1,-1)
      textbuffer["text"][yoffs]=textstart..string.char(char)..textend
      xoffs=xoffs+1
      change=true
    end
    -- store current editingline into textbuffer
    if yoffs<1 then yoffs=1 end
    if yoffs>=maxlines then yoffs=maxlines end
    if xoffs<0 then xoffs=0 end
    if xoffs>textbuffer["text"][yoffs]:len() then 
      xoffs=textbuffer["text"][yoffs]:len() 
    end
    textbuffer["xoffset"]=xoffs
    textbuffer["yoffset"]=yoffs
    textbuffer["maxlines"]=maxlines
    elseif textbuffer~=nil then 
      yoffs=textbuffer["yoffset"]
      xoffs=textbuffer["xoffset"]
      maxlines=textbuffer["maxlines"]
      singletext=textbuffer["singlelinetext"]
    else
      change=nil
  end
  
  -- returning the found character + charactercode and textbuffer(if the latter exists)
  if char==13.0 then character="\\n"
  elseif char==9.0 then character="\\t"
  elseif char==8.0 then character="\\b"
  else _temp,character=ultraschall.GetIniFileExternalState("Codes", tostring(char), ultraschall.Api_Path.."/IniFiles/Reaper-Gfx.GetKey_Codes_and_their_associated_character.ini")
  end
  return character, char, change, textbuffer, maxlines, yoffs
end

function ultraschall.GFX_GetTextbuffer_Text(textbuffer, wantcursor, wantlinenumbers, startline, endline)
  local text=""
  local linenumbers=""
  local position=0
  if startline==nil or startline<1 then startline=1 end
  if endline==nil or endline>textbuffer["maxlines"] then endline=textbuffer["maxlines"] end
  for i=startline, endline do
    if wantlinenumbers==true then
      linenumbers=i
    end
    if textbuffer["yoffset"]==i and wantcursor==true then
      text=text..linenumbers.." "..textbuffer["text"][i]:sub(1,textbuffer["xoffset"]).."_"..textbuffer["text"][i]:sub(textbuffer["xoffset"]+1,-1).."\n"
    else
      text=text..linenumbers.." "..textbuffer["text"][i].."\n"
    end
    if textbuffer["yoffset"]>i then
      position=position+tostring(linenumbers):len()+textbuffer["text"][i]:len()+2
    elseif textbuffer["yoffset"]==i then
      position=position+tostring(linenumbers):len()+textbuffer["xoffset"]
    end
  end
  return text, textbuffer["maxlines"], position+1, text:len()
end

function ultraschall.GFX_GetCharacterFromTextbuffer_MouseCoords(textbuffer, xstartposition, yposition, fontidx)

end

function ultraschall.GFX_SetTextbuffer(textbuffer, yoffset)
  if textbuffer["maxlines"]<yoffset then yoffset=textbuffer["maxlines"] end
  textbuffer["yoffset"]=yoffset
  return textbuffer
end

-- simple editor.
-- Step 1: Create a textbuffer
--        array textbuffer = ultraschall.GFX_CreateTextbuffer(string inittext, boolean singleline)
--
--            parameters:   string inittext    - if you want to set it to a default text, pass some into this parameter. Newlines accepted.
--                          boolean singleline - true, if the textbuffer is a single-line only; false, if the textbuffer is a multiline-textbuffer
--


-- Step 2: put text into the textbuffer; works only with an opened gfx.init-window and using gfx.update before calling it
--                                       use this function only once per defer-cycle, otherwise it fails to run properly (due Reaper API-problems)
--
--              string Key, integer KeyCode, boolean change, array altered_textbuffer, integer MaxLines, integer CurrentEditingLine  = ultraschall.GFX_GetKey(array textbuffer)
--
--            parameter: array textbuffer          - the textbuffer, whose content you want to change; nil, if you just want the typed key
--            
--            retvals:   string Key                - the key that has been typed
--                       integer KeyCode           - the numerical representation of the typed key
--                       boolean change            - true, text or cursorposition has changed; false, text hasn't been changed
--                       array altered_textbuffer  - the altered textbuffer
--                       integer MaxLines          - the number of lines in the textbuffer
--                       integer CurrentEditingLine - the line, that is currently being edited in the textbuffer
--


-- Step 3: get the text from the textbuffer to display it or do other things with it
--          string text, integer maxlines, integer current_cursor_pos, integer length_of_text = ultraschall.GFX_GetTextbuffer_Text(array textbuffer, boolean wantcursor, boolean wantlinenumbers, integer startline, integer endline) 

--             parameters: array textbuffer        - the textbuffer, whose text we want
--                         boolean wantcursor      - true, show a cursor as _; false, just show the text without a cursor
--                         boolean wantlinenumbers - true, add linenumbers  at the beginning of each line; false, don't add linenumbers
--                         integer firstline       - the firstline to be returned, if omitted, it will be line 1
--                         integer lastline        - the lastline to be returned, if omitted, it will be the last line in the textbuffer
  
--             retvals:    string text             - the text stored in textbuffer, including newlines and everything
--                         integer maxlines        - the maximum lines in the textbuffer
--                         integer current_cursor_pos - the current position of the cursor in the string text. Can be used to
--                                                      draw an editcursor at the correct position yourself
--                         integer length_of_text  - the length of the text, includes newlines and, if wanted, the linenumbers


-- Step 4: repeat Steps 2 and 3
--

-- See main() for an example of how to work with it

function Editormain()
  -- The Editor code

  -- Let's get the new key and pass it over to textbuffer "buffer"
  Key, KeyCode, change, buffer, MaxLines, CurrentEditingLine = ultraschall.GFX_GetKey(buffer)
  
  -- now, let's check for some stuff to scroll the text
  if Key=="F1" then counter=counter-1 end               -- F1 scrolls one line up, leaving cursor at old position
  if Key=="F2" then counter=counter+1 end               -- F2 scrolls one line down, leaving cursor at old position
  if Key=="F3" then counter=1 end                       -- F3 scrolls to first line, leaving cursor at old position
  if Key=="F4" then counter=MaxLines-ShownLines end     -- F4 scrolls to last line, leaving cursor at old position
  
  if Key=="PgUp" then counter=counter-10 end            -- PgUp jumps textview ten lines backwards
  if Key=="PgDn" then counter=counter+10 end            -- PgDn jumps textview ten lines forewards
  
  if counter<1 then counter=1 end                       -- jump textview to the first line of the text
  if counter>MaxLines then counter=MaxLines end         -- jump textview to the last line of the text
  
  -- if text has changed, jump "textview" to text cursor
    -- if editingline is above current view, scroll editline to be first line
  if change==true and (CurrentEditingLine<counter) then counter=CurrentEditingLine end 
    -- if editingline is below current view, scroll editline to be last line
  if change==true and (CurrentEditingLine>counter+ShownLines) then counter=CurrentEditingLine-ShownLines end
  
  -- Now let's get the text from the textbuffer. 
  text, maxlines, current_cursor_pos, length_of_text = ultraschall.GFX_GetTextbuffer_Text(buffer, true, true, counter, counter+ShownLines)
  
  -- update textview only, when Text has changed and/or window-size has been changed
  if (text~=OldText) or gfx.h~=oldh or gfx.w~=oldw then
    gfx.x=1
    gfx.y=1
    gfx.drawstr(text)
  end
  
  -- store old text and old window-positions
  OldText=text
  oldh=gfx.h
  oldw=gfx.w
  
  -- update gfx-window and defer the whole stuff
  gfx.update()
  if KeyCode~=-1 then reaper.defer(Editormain) end
end


function ultraschall.GFX_Init(...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_Init</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.964
    Lua=5.3
  </requires>
  <functioncall>integer retval, HWND hwnd = ultraschall.GFX_Init(string "name", optional integer width, optional integer height, optional integer dockstate, optional integer xpos, optional integer ypos)</functioncall>
  <description>
    Opens a new graphics window and returns its HWND-windowhandler object.
  </description>
  <parameters>
    string "name" - the name of the window, which will be shown in the title of the window
    optional integer width -  the width of the window; minmum is 50
    optional integer height -  the height of the window; minimum is 16
    optional integer dockstate - &1=0, undocked; &1=1, docked
    optional integer xpos - x-position of the window in pixels; minimum is -80; nil, to center it horizontally
    optional integer ypos - y-position of the window in pixels; minimum is -15; nil, to center it vertically
  </parameters>
  <retvals>
    number retval  -  1.0, if window is opened
    HWND hwnd - the window-handler of the newly created window; can be used with JS_Window_xxx-functions of the JS-extension-plugin
  </retvals>
  <chapter_context>
    Window Handling
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, gfx, init, window, create, hwnd</tags>
</US_DocBloc>
]]
  local A=gfx.getchar(65536)
  local HWND, retval
  if A&4==0 then
    local parms={...}
    local temp=parms[1]
  
    -- check, if the given windowtitle is a valid one, 
    -- if that's not the case, use "" as name
    if temp==nil or type(temp)~="string" then temp="" end  
    if type(parms[1])~="string" then parms[1]="" 
    end
    
    -- check for a window-name not being used yet, which is 
    -- windowtitleX, where X is a number
    local freeslot=0
    for i=0, 65555 do
      if reaper.JS_Window_Find(parms[1]..i, true)==nil then freeslot=i break end
    end
    -- use that found, unused windowtitle as temporary windowtitle
    parms[1]=parms[1]..freeslot
    
    local A1,B,C,D=reaper.my_getViewport(0,0,0,0, 0,0,0,0, false)
    
    if parms[5]==nil then
      parms[5]=(C-parms[2])/2
    end
    if parms[6]==nil then
      parms[6]=(D-parms[3])/2
    end

    -- open window  
    retval=gfx.init(table.unpack(parms))
    
    -- find the window with the temporary windowtitle and get its HWND
    HWND=reaper.JS_Window_Find(parms[1], true)
    
    -- rename it to the original title
    if HWND~=nil then reaper.JS_Window_SetTitle(HWND, temp) end
    ultraschall.GFX_WindowHWND=HWND
  else 
    retval=0.0
  end
  return retval, ultraschall.GFX_WindowHWND
end



function ultraschall.GFX_GetWindowHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_GetWindowHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS_0.964
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GFX_GetWindowHWND()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the HWND of the currently opened gfx-window. You need to use [ultraschall.GFX_Init()](#GFX_Init), otherwise 
    it will contain the message "Please, use ultraschall.GFX_Init() for window-creation, not gfx.init(!), to retrieve the HWND of the gfx-window."
  </description>
  <retvals>
     HWND hwnd - the window-handler of the opened gfx-window; will contain a helpermessage, if you didn't use [ultraschall.GFX_Init()](#GFX_Init) for window creation.
  </retvals>
  <chapter_context>
    Window Handling
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, gfx, init, window, get, hwnd</tags>
</US_DocBloc>
]]
  return ultraschall.GFX_WindowHWND
end

--O=ultraschall.GFX_GetWindowHWND()

--A1,B1=reaper.JS_Window_Find("Tudel", true)
--A,B=ultraschall.GFX_Init("Hula")
--gfx.init("Tudelu")
--C,D=reaper.JS_Window_Find("Tudels", true)
--O2=ultraschall.GFX_GetWindowHWND()
--[[
-- Let's initialize some stuff
  gfx.init("TRET",720,420)    -- open a window
  gfx.setfont(1,"arial",15,0) -- set a font
  counter=1                   -- the currently shown line; used in the view-area of the texteditor
  ShownLines=20               -- the number of lines to be shown in the textarea
  SingleLine=false            -- set to true, if you want a single editing line only in textbuffer "buffer"

-- Let's create a new textbuffer. You can create multiple ones, if you want
  buffer=ultraschall.GFX_CreateTextbuffer("Simple Editor - by Meo Mespotine\nsupports characters, Arrow-keys, Home, Cmd+Home, End, Cmd+End, BackSpace, Del, Cmd+V\n\nHave fun with it :D", SingleLine)

-- run the main editor-code
  Editormain()
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
      integer mouse_hwheel - the mouse_horizontal-wheel-delta, since the last time calling this function
  </retvals>
  <chapter_context>
    Mouse Handling
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
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

--ultraschall.ShowLastErrorMessage()

  -- Usage: Font.set("Arial", 10, "bi")
function ultraschall.GFX_SetFont(fontindex, font, size, flagStr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_SetFont</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>ultraschall.GFX_SetFont(integer fontindex, string font, integer size, string flagStr)</functioncall>
  <description>
    Sets the font of the gfx-window.
    
    As Mac and Windows have different visible font-sizes for the same font-size, this function adapts the font-size correctly(unlike Reaper's own native gfx.setfont-function).
    
    returns false in case of an error
  </description>
  <parameters>
    integer fontindex - the font-id; idx=0 for default bitmapped font, no configuration is possible for this font. idx=1..16 for a configurable font
    string font - the name of the font
    integer size - the size of the font
    string flagStr - a string, which holds the desired font-styles. You can combine multiple ones, up to 4.
                   - The following are valid:
                   - B - bold
                   - i - italic
                   - o - white outline
                   - r - blurred
                   - s - sharpen
                   - u - underline
                   - v - inverse
  </parameters>
  <chapter_context>
    Font Handling
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, font, set, mac, windows</tags>
</US_DocBloc>
]]
  if type(font)~="string" then ultraschall.AddErrorMessage("GFX_SetFont", "font", "must be a string", -1) return false end
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("GFX_SetFont", "size", "must be an integer", -2) return false end
  if type(flagStr)~="string" then ultraschall.AddErrorMessage("GFX_SetFont", "flagStr", "must be a string", -3) return false end
  if flagStr:len()>4 then ultraschall.AddErrorMessage("GFX_SetFont", "flagStr", "You can only give up to maximum 4 attributes.", -4) return false end
  if math.type(fontindex)~="integer" then ultraschall.AddErrorMessage("GFX_SetFont", "size", "must be an integer", -5) return false end
  -- following code done by lokasenna with contributions by Justin and Schwa
  
  -- Different OSes use different font sizes, for some reason
  -- This should give a similar size on Mac/Linux as on Windows
  if not string.match( reaper.GetOS(), "Win") then
    size = math.floor(size * 0.8)
  end
    
  -- Cheers to Justin and Schwa for this
  local flags = 0
  if flagStr then
    for i = 1, flagStr:len() do
      flags = flags * 256 + string.byte(flagStr, i)
    end
  end

  gfx.setfont(fontindex, font, size, flags)
  return true
end
                        
--A=ultraschall.GFX_SetFont(1, "Arial", 20, "usijv")
--gfx.drawstr("huioh")

function ultraschall.GFX_BlitImageCentered(image, x, y, scale, rotate, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_BlitImageCentered</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.99
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GFX_BlitImageCentered(integer image, integer x, integer y, number scale, number rotate, optional number srcx, optional number srcy, optional number srcw, optional number srch, optional integer destx, optional integer desty, optional integer destw, optional integer desth, optional integer rotxoffs, optional integer rotyoffs)</functioncall>
  <description>
    Blits a centered image at the position given by parameter x and y. That means, the center of the image will be at x and y.
    
    All the rest basically works like the regular gfx.blit-function.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, blitting was successful; false, blitting was unsuccessful
  </retvals>
  <parameters>
    integer source - the source-image/framebuffer to blit; -1 to 1023; -1 for the currently displayed framebuffer.
    integer x - the x-position of the center of the image
    integer y - the y-position of the center of the image
    number scale - the scale-factor; 1, for normal size; smaller or bigger than 1 make image smaller or bigger
                    - has no effect, when destx, desty, destw, desth are given
    number rotation - the rotation-factor; 0 to 6.28; 3.14 for 180 degrees.
    optional number srcx - the x-coordinate-offset in the source-image
    optional number srcy - the y-coordinate-offset in the source-image
    optional number srcw - the width-offset in the source-image
    optional number srch - the height-offset in the source-image
    optional integer destx - the x-coordinate of the blitting destination
    optional integer desty - the y-coordinate of the blitting destination
    optional integer destw - the width of the blitting destination; may lead to stretched images
    optional integer desth - the height of the blitting destination; may lead to stretched images
    optional number rotxoffs - influences rotation
    optional number rotyoffs - influences rotation
  </parameters>
  <chapter_context>
    Blitting
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, blit, centered, rotate, scale</tags>
</US_DocBloc>
--]]
  if math.type(image)~="integer" then ultraschall.AddErrorMessage("GFX_BlitImageCentered", "image", "must be an integer", -1) return false end
  if image<-1 or image>1023 then ultraschall.AddErrorMessage("GFX_BlitImageCentered", "image", "must be between -1 and 1023", -2) return false end
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("GFX_BlitImageCentered", "x", "must be an integer", -3) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("GFX_BlitImageCentered", "y", "must be an integer", -4) return false end
  if type(scale)~="number" then ultraschall.AddErrorMessage("GFX_BlitImageCentered", "scale", "must be a number between 0 and higher", -5) return false end
  if type(rotate)~="number" then ultraschall.AddErrorMessage("GFX_BlitImageCentered", "rotate", "must be a number", -6) return false end
  local params={...}
  for i=1, #params do
    if type(params[i])~="number" then ultraschall.AddErrorMessage("GFX_BlitImageCentered", "parameter "..i+5, "must be a number or an integer", -7) return false end
  end
  local oldx=gfx.x
  local oldy=gfx.y
  local X,Y=gfx.getimgdim(image)
  gfx.x=x-((X*scale)/2)
  gfx.y=y-((Y*scale)/2)
  gfx.blit(image, scale, rotate, table.unpack(params))
  gfx.x=oldx
  gfx.y=oldy
  return true
end

function ultraschall.GFX_GetDropFile()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_GetDropFile</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean changed, integer num_dropped_files, array dropped_files, integer drop_mouseposition_x, integer drop_mouseposition_y = ultraschall.GFX_GetDropFile()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
	returns the files drag'n'dropped into a gfx-window, including the mouseposition within the gfx-window, where the files have been dropped.
	
	if changed==true, then the filelist is updated, otherwise this function returns the last dropped files again.
	Note: when the same files will be dropped, changed==true will also be dropped with only the mouse-position updated.
	That way, dropping the same files in differen places is recognised by this function.
	
	Call repeatedly in every defer-cycle to get the latest files and coordinates.
	
	Important: Don't use Reaper's own gfx.dropfile while using this, as this could intefere with this function.
  </description>
  <retvals>
	boolean changed - true, new files have been dropped since last time calling this function; false, no new files have been dropped
	integer num_dropped_files - the number of dropped files; -1, if no files have beend dropped at all
	array dropped_files - an array with all filenames+path of the dropped files
	integer drop_mouseposition_x - the x-mouseposition within the gfx-window, where the files have been dropped; -10000, if no files have been dropped yet
	integer drop_mouseposition_y - the y-mouseposition within the gfx-window, where the files have been dropped; -10000, if no files have been dropped yet
  </retvals>
  <chapter_context>
    Window Handling
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx</tags>
</US_DocBloc>
--]]
  if ultraschall.GetDropFile_List==nil then
    ultraschall.GetDropFile_List={}
    ultraschall.GetDropFile_List[1]=""
    ultraschall.GetDropFile_Filecount=-1
    ultraschall.GetDropFile_MouseX=-10000
    ultraschall.GetDropFile_MouseY=-10000
  end
  local A=1
  local filecount=0
  local changed
  local FileList={}
  while A~=0 do
    A,B=gfx.getdropfile(filecount)
    filecount=filecount+1
    FileList[filecount]=B
  end
  if filecount==1 then
    changed=false
  else
    changed=true
  end
  if changed==true then
    ultraschall.GetDropFile_List=FileList
    ultraschall.GetDropFile_Filecount=filecount
    ultraschall.GetDropFile_MouseX=gfx.mouse_x
    ultraschall.GetDropFile_MouseY=gfx.mouse_y
  end
  gfx.getdropfile(-1)
  return changed, ultraschall.GetDropFile_Filecount-1, ultraschall.GetDropFile_List, ultraschall.GetDropFile_MouseX, ultraschall.GetDropFile_MouseY
end

