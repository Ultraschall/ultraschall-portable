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
  local char, char_utf8=gfx.getchar()
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
      textbuffer["text"][yoffs]=textstart..utf8.char(char)..textend
      xoffs=xoffs+1
      change=true
    else
      textstart=textbuffer["text"][yoffs]:sub(1,xoffs)
      textend=textbuffer["text"][yoffs]:sub(xoffs+1,-1)
      textbuffer["text"][yoffs]=textstart..utf8.char(char_utf8)..textend
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
    if parms[2]==nil then parms[2]=640 end
    if parms[3]==nil then parms[3]=400 end
    if parms[4]==nil then parms[4]=0 end
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
  <description>
    Returns the HWND of the currently opened gfx-window. You need to use ultraschall.GFX_Init(), otherwise 
    it will contain the message "Please, use ultraschall.GFX_Init() for window-creation, not gfx.init(!), to retrieve the HWND of the gfx-window."
  </description>
  <retvals>
     HWND hwnd - the window-handler of the opened gfx-window; will contain a helpermessage, if you didn't use ultraschall.GFX_Init() for window creation.
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
    Checks clickstates and mouseclick/wheel-behavior, since last time calling this function and returns their states.
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
  if math.type(doubleclick_wait)~="integer" then doubleclick_wait=0 end
  if math.type(drag_wait)~="integer" then drag_wait=15 end
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
  <description>
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

function ultraschall.GFX_DrawEmbossedSquare(x, y, w, h, rbg, gbg, bbg, r, g, b)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_DrawEmbossedSquare</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GFX_DrawEmbossedSquare(integer x, integer y, integer w, integer h, optional integer rgb, optional integer gbg, optional integer bbg, optional integer r, optional integer g, optional integer b)</functioncall>
  <description>
    draws an embossed rectangle, optionally with a background-color
    
    returns false in case of an error
  </description>
  <parameters>
    integer x - the x position of the rectangle
    integer y - the y position of the rectangle
    integer w - the width of the rectangle
    integer h - the height of the rectangle
    optional integer rgb - the red-color of the background-rectangle; set to nil for no background-color
    optional integer gbg - the green-color of the background-rectangle; set to nil for no background-color/uses rbg if gbg and bbg are set to nil
    optional integer bbg - the blue-color of the background-rectangle; set to nil for no background-color/uses rbg if gbg and bbg are set to nil
    optional integer r - the red-color of the embossed-rectangle; nil, to use 1
    optional integer g - the green-color of the embossed-rectangle; nil, to use 1
    optional integer b - the blue-color of the embossed-rectangle; nil, to use 1
  </parameters>
  <retvals>
    boolean retval - true, drawing was successful; false, drawing wasn't successful
  </retvals>
  <chapter_context>
    Basic Shapes
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, gfx, draw, thickness, embossed rectangle</tags>
</US_DocBloc>
]]
  if gfx.getchar()==-1 then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "", "no gfx-window opened", -1) return false end
  if ultraschall.type(x)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "x", "must be an integer", -2) return false end
  if ultraschall.type(y)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "y", "must be an integer", -3) return false end
  if ultraschall.type(w)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "w", "must be an integer", -4) return false end
  if ultraschall.type(h)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "h", "must be an integer", -5) return false end
  
  if rbg~=nil and type(rbg)~="number" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "rbg", "must be a number or nil", -6) return false end
  if bbg~=nil and type(bbg)~="number" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "gbg", "must be a number or nil", -7) return false end
  if gbg~=nil and type(gbg)~="number" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "bbg", "must be a number or nil", -8) return false end
  
  if r~=nil and type(r)~="number" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "r", "must be a number or nil", -9) return false end
  if g~=nil and type(g)~="number" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "g", "must be a number or nil", -10) return false end
  if b~=nil and type(b)~="number" then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "b", "must be a number or nil", -11) return false end
  local offsetx=1
  local offsety=1
  
  
  if r~=nil and g==nil and b==nil then g=r b=r end
  if r==nil or g==nil or g==nil then r=1 g=1 b=1 end   
  if b==nil or g==nil then ultraschall.AddErrorMessage("GFX_DrawEmbossedSquare", "r, g and b", "either all three must be set or only one of them", -12) return false end 
  -- background
  if rbg~=nil and bbg==nil and gbg==nil then
    bbg=rbg
    gbg=rbg
  end
  if rbg~=nil and bbg~=nil and gbg~=nil then
    gfx.set(rbg,gbg,bbg)
    gfx.rect(x+1,y+1,w,h,1)
  end
  
  -- darker-edges
  gfx.set(0.5*r, 0.5*g, 0.5*b)
  gfx.line(x+offsetx  , y+offsety,   x+w+offsetx, y+offsety  )
  gfx.line(x+w+offsetx, y+offsety,   x+w+offsetx, y+h+offsety)
  gfx.line(x+w+offsetx, y+h+offsety, x+offsetx  , y+h+offsety)
  gfx.line(x+offsetx  , y+h+offsety, x+offsetx  , y+offsety  )

  -- brighter-edges
  gfx.set(r, g, b)
  gfx.line(x,   y,   x+w, y  )
  gfx.line(x+w, y,   x+w, y+h)
  gfx.line(x+w, y+h, x  , y+h)
  gfx.line(x  , y+h, x  , y  )
  return true
end 

function ultraschall.GFX_GetChar(character, manage_clipboard, to_clipboard, readable_characters)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_GetChar</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.42
    Lua=5.3
  </requires>
  <functioncall>integer first_typed_character, integer num_characters, table character_queue = ultraschall.GFX_GetChar(optional integer character, optional boolean manage_clipboard, optional string to_clipboard, optional boolean readable_characters)</functioncall>
  <description>
    gets all characters from the keyboard-queue of gfx.getchar as a handy table.
    
    the returned table character_queue is of the following format:
    
        character_queue[index]["Code"] - the character-code
        character_queue[index]["Ansi"] - the character-code converted into Ansi
        character_queue[index]["UTF8"] - the character-code converted into UTF8
      
    When readable_characters=true, the entries of the character_queue for Ansi and UTF8 will hold readable strings for non-printable characters, like:
      "ins ", "del ", "home", "F1  "-"F12 ", "tab ", "esc ", "pgup", "pgdn", "up  ", "down", "left", "rght", "bspc", "ente"
      
    You can optionally let this function manage clipboard. So hitting Ctrl+V will get put the content of the clipboard into the character_queue of Ansi/UTF8 in the specific position of the character-queue,
    while hitting Ctrl+C will put the contents of the parameter to_clipboard into the clipboard in this case.
    
    Retval first_typed_character behaves basically like the returned character of Reaper's native function gfx.getchar()
    
    returns -2 in case of an error
  </description>
  <parameters>
    optional integer character - a specific character-code to check for(will ignore all other keys)
                               - 65536 queries special flags, like: &amp;1 (supported in this script), &amp;2=window has focus, &amp;4=window is visible  
    optional boolean manage_clipboard - true, when user hits ctrl+v/cmd+v the character-queue will hold clipboard-contents in this position
                                      - false, treat ctrl+v/cmd+v as regular typed character
    optional string to_clipboard - if get_paste_from_clipboard=true and user hits ctrl+c/cmd+c, the contents of this variable will be put into the clipboard
    optional boolean readable_characters - true, make non-printable characters readable; false, keep them in original state
  </parameters>
  <retvals>
    integer first_typed_character - the character-code of the first character found
    integer num_characters - the number of characters in the queue
    table character_queue - the characters in the queue, within a table(see description for more details)
  </retvals>
  <chapter_context>
    Key-Management
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, gfx, getchar, character, clipboard</tags>
</US_DocBloc>
]]
  if character~=nil and math.type(character)~="integer" then ultraschall.AddErrorMessage("GFX_GetChar", "character", "must be an integer", -1) return -2 end
  if manage_clipboard~=nil and type(manage_clipboard)~="boolean" then ultraschall.AddErrorMessage("GFX_GetChar", "manage_clipboard", "must be either nil or boolean", -2) return -2 end
  if readable_characters~=nil and type(readable_characters)~="boolean" then ultraschall.AddErrorMessage("GFX_GetChar", "readable_characters", "must be either nil or boolean", -3) return -2 end
  to_clipboard=tostring(to_clipboard)
  
  local A=1
  local CharacterTable={}
  local CharacterCount=0
  local first=-2
  while A>0 do
    A=gfx.getchar(character)
    if first==-2 then first=math.tointeger(A) end
    if A>0 then
      CharacterCount=CharacterCount+1
      CharacterTable[CharacterCount]={}
      CharacterTable[CharacterCount]["Code"]=A
      if manage_clipboard==true and A==3 then
        ToClip(to_clipboard)
      elseif manage_clipboard==true and A==22 and gfx.mouse_cap&4==4 then
        CharacterTable[CharacterCount]["Ansi"]=FromClip()
      else
        if A>-1 and A<255 then
          CharacterTable[CharacterCount]["Ansi"]=string.char(A)
        else
          CharacterTable[CharacterCount]["Ansi"]=""
        end
        if A>-1 and A<1114112 then
          CharacterTable[CharacterCount]["UTF8"]=utf8.char(A)
        else
          CharacterTable[CharacterCount]["UTF8"]=""
        end
        if readable_characters==false then
          if A>1114112 then
            CharacterTable[CharacterCount]["UTF8"] = ultraschall.ConvertIntegerIntoString2(4, math.tointeger(A)):reverse()
            CharacterTable[CharacterCount]["Ansi"] = CharacterTable[CharacterCount]["UTF8"]
          end
    
          if A==6647396.0 then -- end-key
            CharacterTable[CharacterCount]["Ansi"] = "end " 
            CharacterTable[CharacterCount]["UTF8"] = "end "
          end
          if A==6909555.0 then -- insert key
            CharacterTable[CharacterCount]["Ansi"] = "ins " 
            CharacterTable[CharacterCount]["UTF8"] = "ins "
          end
          if A==6579564.0 then -- del key
            CharacterTable[CharacterCount]["Ansi"] = "del " 
            CharacterTable[CharacterCount]["UTF8"] = "del "
          end
          if A>26160.0 and A<26170.0 then -- F1 through F9
            CharacterTable[CharacterCount]["Ansi"] = "F"..(math.tointeger(A)-26160).."  "
            CharacterTable[CharacterCount]["UTF8"] = "F"..(math.tointeger(A)-26160).."  "
          end
          if A>=6697264.0 and A<=6697266.0 then -- F10 and higher
            CharacterTable[CharacterCount]["Ansi"] = "F"..(math.tointeger(A)-6697254).." "
            CharacterTable[CharacterCount]["UTF8"] = "F"..(math.tointeger(A)-6697254).." "
          end
          if A==8 then -- backspace
            CharacterTable[CharacterCount]["Ansi"] = "bspc"
            CharacterTable[CharacterCount]["UTF8"] = "bspc"
          end
          if A==9 then -- backspace
            CharacterTable[CharacterCount]["Ansi"] = "tab "
            CharacterTable[CharacterCount]["UTF8"] = "tab "
          end
          if A==13 then -- enter
            CharacterTable[CharacterCount]["Ansi"] = "ente"
            CharacterTable[CharacterCount]["UTF8"] = "ente"
          end
          if A==27 then -- escape
            CharacterTable[CharacterCount]["Ansi"] = "esc "
            CharacterTable[CharacterCount]["UTF8"] = "esc "
          end
          if A==30064.0 then -- upkey, others are treated with A>1114112
            CharacterTable[CharacterCount]["Ansi"] = "up  "
            CharacterTable[CharacterCount]["UTF8"] = "up  "
          end

        end
      end    
    else
      break
    end
  end

  --  local B=""
  --  local C=""
  --  for i=1, CharacterCount do
  --    B=B..CharacterTable[i]["UTF"]
  --    C=C..CharacterTable[i]["Ansi"]
  --  end
  return first, CharacterCount, CharacterTable--, B, C
end



function ultraschall.GFX_GetTextLayout(bold, italic, underline, outline, nonaliased, inverse, rotate, rotate2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_GetTextLayout</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer font_layout = ultraschall.GFX_GetTextLayout(optional boolean bold, optional boolean italic, optional boolean underline, optional boolean outline, optional boolean nonaliased, optional boolean inverse, optional boolean rotate, optional boolean rotate2)</functioncall>
  <description>
    Returns a font_layout-value that can be used for the parameter flags for the function gfx.drawstr.
    
    Note: as per limitation of Reaper, you can only have up to 4 font_layout-parameters at the same time.
    
    Some combinations do not work together, so you need to experiment.
  </description>
  <parameters>
    optional boolean bold - true, sets the font_layout to bold; false, no boldness
    optional boolean italic - true, sets the font_layout to italic; false, no italic
    optional boolean underline - true, sets the font_layout to underline; false, no underlining
    optional boolean outline - true, sets the font_layout to outline; false, no outline
    optional boolean nonaliased - true, sets the font_layout to aliased; false, keep it antialiased
    optional boolean inverse - true, sets the font_layout to inverse; false, not inversed
    optional boolean rotate - true, sets the font_layout to rotate the font clockwise; false, don't rotate
    optional boolean rotate2 - true, sets the font_layout to rotate the font counterclockwise; false, don't rotate
  </parameters>
  <retvals>
    integer font_layout - the returned value you can use for gfx.drawstr for its flags-parameter
  </retvals>
  <chapter_context>
    Blitting
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, get, text layout</tags>
</US_DocBloc>
]]
  local Bold=66
  local Italic=73
  local Underline=85
  local Outline=79
  local NonAliased=77
  local Inverse=86
  local Rotated=89
  local Rotated2=90
  

  local Layout=0
  if bold==true then Layout=Bold Layout=Layout<<8 end
  if italic==true then Layout=Layout+Italic Layout=Layout<<8 end
  if underline==true then Layout=Layout+Underline Layout=Layout<<8 end
  if outline==true then Layout=Layout+Outline Layout=Layout<<8 end
  if nonaliased==true then Layout=Layout+NonAliased Layout=Layout<<8 end
  if inverse==true then Layout=Layout+Inverse Layout=Layout<<8 end
  
  if rotate==true then Layout=Layout+Rotated Layout=Layout<<8 end
  if rotate2==true then Layout=Layout+Rotated2 Layout=Layout<<8 end
  
  return Layout
end


function ultraschall.GFX_ResizeImageKeepAspectRatio(image, neww, newh, bg_r, bg_g, bg_b)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_ResizeImageKeepAspectRatio</slug>
  <requires>
    Ultraschall=4.75
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GFX_ResizeImageKeepAspectRatio(integer image, integer neww, integer newh, optional number r, optional number g, optional number b)</functioncall>
  <description>
    Resizes an image, keeping its aspect-ratio. You can set a background-color for non rectangular-images.
    
    Resizing upwards will probably cause artifacts!
    
    Note: this uses image 1023 as temporary buffer so don't use image 1023, when using this function!
  </description>
  <parameters>
    integer image - an image between 0 and 1022, that you want to resize
    integer neww - the new width of the image
    integer newh - the new height of the image
    optional number r - the red-value of the background-color
    optional number g - the green-value of the background-color
    optional number b - the blue-value of the background-color
  </parameters>
  <retvals>
    boolean retval - true, blitting was successful; false, blitting was unsuccessful
  </retvals>
  <chapter_context>
    Blitting
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, resize, image</tags>
</US_DocBloc>
]]
  if math.type(image)~="integer" then ultraschall.AddErrorMessage("GFX_ResizeImageKeepAspectRatio", "image", "must be an integer", -1) return false end
  if math.type(neww)~="integer" then ultraschall.AddErrorMessage("GFX_ResizeImageKeepAspectRatio", "neww", "must be an integer", -2) return false end
  if math.type(newh)~="integer" then ultraschall.AddErrorMessage("GFX_ResizeImageKeepAspectRatio", "newh", "must be an integer", -3) return false end
  
  if bg_r~=nil and type(bg_r)~="number" then ultraschall.AddErrorMessage("GFX_ResizeImageKeepAspectRatio", "bg_r", "must be a number", -4) return false end
  if bg_r==nil then bg_r=0 end
  if bg_g~=nil and type(bg_g)~="number" then ultraschall.AddErrorMessage("GFX_ResizeImageKeepAspectRatio", "bg_g", "must be a number", -5) return false end
  if bg_g==nil then bg_g=0 end
  if bg_b~=nil and type(bg_b)~="number" then ultraschall.AddErrorMessage("GFX_ResizeImageKeepAspectRatio", "bg_b", "must be a number", -6) return false end
  if bg_b==nil then bg_b=0 end
  
  if image<0 or image>1022 then ultraschall.AddErrorMessage("GFX_ResizeImageKeepAspectRatio", "image", "must be between 0 and 1022", -7) return false end
  if neww<0 or neww>8192 then ultraschall.AddErrorMessage("GFX_ResizeImageKeepAspectRatio", "neww", "must be between 0 and 8192", -8) return false end
  if newh<0 or newh>8192 then ultraschall.AddErrorMessage("GFX_ResizeImageKeepAspectRatio", "newh", "must be between 0 and 8192", -9) return false end
  
  local old_r, old_g, old_g=gfx.r, gfx.g, gfx.b  
  local old_dest=gfx.dest
  local oldx, oldy = gfx.x, gfx.y
  
  local x,y=gfx.getimgdim(image)
  local ratiox=((100/x)*neww)/100
  local ratioy=((100/y)*newh)/100
  local ratio
  if ratiox<ratioy then ratio=ratiox else ratio=ratioy end
  gfx.setimgdim(1023, neww, newh)
  gfx.dest=1023
  gfx.set(bg_r, bg_g, bg_b)
  gfx.rect(0,0,8192,8192,1)
  gfx.x=0
  gfx.y=0
  gfx.blit(image, ratio, 0)

  gfx.setimgdim(image, neww, newh)
  gfx.dest=image
  if bg_r~=nil then gfx.r=bg_r end
  if bg_g~=nil then gfx.g=bg_g end
  if bg_b~=nil then gfx.b=bg_b end
  x,y=gfx.getimgdim(image)
  gfx.rect(-1,-1,x+1,y+1,1)
  gfx.set(old_r, old_g, old_g)
  gfx.blit(1023, 1, 0)
  gfx.dest=old_dest
  gfx.x, gfx.y = oldx, oldy
  return true
end

function ultraschall.GFX_BlitText_AdaptLineLength(text, x, y, width, height, align)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_BlitText_AdaptLineLength</slug>
  <requires>
    Ultraschall=4.75
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GFX_ResizeImageKeepAspectRatio(string text, integer x, integer y, integer width, optional integer height, optional integer align)</functioncall>
  <description>
    This draws text to x and y and adapts the line-lengths to fit into width and height.
  </description>
  <parameters>
    string text - the text to be shown
    integer x - the x-position of the text
    integer y - the y-position of the text
    integer width - the maximum width of a line in pixels; text after this will be put into the next line
    optional integer height - the maximum height the text shall be shown in pixels; everything after this will be truncated
    optional integer align - 0 or nil, left aligned text; 1, center text
  </parameters>
  <retvals>
    boolean retval - true, text-blitting was successful; false, text-blitting was unsuccessful
  </retvals>
  <chapter_context>
    Text
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, blit, text, line breaks, adapt line length</tags>
</US_DocBloc>
]]
  if type(text)~="string" then ultraschall.AddErrorMessage("GFX_BlitText_AdaptLineLength", "text", "must be a string", -1) return false end
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("GFX_BlitText_AdaptLineLength", "x", "must be an integer", -2) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("GFX_BlitText_AdaptLineLength", "y", "must be an integer", -3) return false end
  if type(width)~="number" then ultraschall.AddErrorMessage("GFX_BlitText_AdaptLineLength", "width", "must be an integer", -4) return false end
  if height~=nil and type(height)~="number" then ultraschall.AddErrorMessage("GFX_BlitText_AdaptLineLength", "height", "must be an integer", -5) return false end
  if align~=nil and math.type(align)~="integer" then ultraschall.AddErrorMessage("GFX_BlitText_AdaptLineLength", "align", "must be an integer", -6) return false end
  local l=gfx.measurestr("A")
  if width<gfx.measurestr("A") then ultraschall.AddErrorMessage("GFX_BlitText_AdaptLineLength", "width", "must be at least "..l.." pixels for this font.", -7) return false end

  if align==nil or align==0 then center=0 
  elseif align==1 then center=1 
  end
  local newtext=""

  for a=0, 100 do
    newtext=newtext..text:sub(a,a)
    local nwidth, nheight = gfx.measurestr(newtext)
    if nwidth>width then
      newtext=newtext:sub(1,a-1).."\n"..text:sub(a,a)
    end
    if height~=nil and nheight>=height then newtext=newtext:sub(1,-3) break end
  end
  old_x, old_y=gfx.x, gfx.y
  gfx.x=x
  gfx.y=y
  local xwidth, xheight = gfx.measurestr(newtext)
  gfx.drawstr(newtext.."\n  ", center, xwidth+3, xheight)
  gfx.x=old_x
  gfx.y=old_y
  return true
end