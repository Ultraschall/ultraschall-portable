dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
--[[
TODO: 
  - Dpi2Scale-conversion must be included(currently using Ultraschall-API in OpenWindow)
  - when no ui-elements are present, the osara init-message is not said
--]]
--XX,YY=reaper.GetMousePosition()
--gfx.ext_retina = 0
reagirl={}
reagirl.Elements={}
reagirl.MoveItAllUp=0
reagirl.MoveItAllRight=0
reagirl.MoveItAllRight_Delta=0
reagirl.MoveItAllUp_Delta=0

reagirl.Font_Size=18

function reagirl.RoundRect(x, y, w, h, r, antialias, fill)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RoundRect</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>boolean retval = reagirl.RoundRect(integer x, integer y, integer w, integer h, number r, number antialias, number fill)</functioncall>
  <description>
    This draws a rectangle with rounded corners to x and y
  </description>
  <parameters>
    integer x - the x-position of the rectangle
    integer y - the y-position of the rectangle
    integer w - the width of the rectangle
    number r - the radius of the corners of the rectangle
    number antialias - 1, antialias; 0, no antialias
    number fill - 1, filled; 0, not filled
  </parameters>
  <retvals>
    boolean retval - true, text-blitting was successful; false, text-blitting was unsuccessful
  </retvals>
  <chapter_context>
    Misc
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, blit, text, line breaks, adapt line length</tags>
</US_DocBloc>
]]
  if type(x)~="number" then error("RoundRect: param #1 - must be a number", 2) end
  if type(y)~="number" then error("RoundRect: param #2 - must be a number", 2) end
  if type(w)~="number" then error("RoundRect: param #3 - must be a number", 2) end
  if type(h)~="number" then error("RoundRect: param #4 - must be a number", 2) end
  if type(r)~="number" then error("RoundRect: param #5 - must be a number", 2) end
  if type(antialias)~="number" then error("RoundRect: param #6 - must be a number", 2) end
  if type(fill)~="number" then error("RoundRect: param #7 - must be a number", 2) end
    local aa = antialias or 1
    fill = fill or 0

    if fill == 0 or false then
      gfx.roundrect(x, y, w, h, r, aa)
    else
      if h >= 2 * r then
        -- Corners
        gfx.circle(x + r, y + r, r, 1, aa)        -- top-left
        gfx.circle(x + w - r, y + r, r, 1, aa)    -- top-right
        gfx.circle(x + w - r, y + h - r, r , 1, aa)  -- bottom-right
        gfx.circle(x + r, y + h - r, r, 1, aa)    -- bottom-left
  
        -- Ends
        gfx.rect(x, y + r, r, h - r * 2)
        gfx.rect(x + w - r, y + r, r + 1, h - r * 2)
  
        -- Body + sides
        gfx.rect(x + r, y, w - r * 2, h + 1)
      else
        r = (h / 2 - 1)
        -- Ends
        gfx.circle(x + r, y + r, r, 1, aa)
        gfx.circle(x + w - r, y + r, r, 1, aa)
        -- Body
        gfx.rect(x + r, y, w - (r * 2), h)
    end
  end
end


function reagirl.BlitText_AdaptLineLength(text, x, y, width, height, align)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>BlitText_AdaptLineLength</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>boolean retval = reagirl.BlitText_AdaptLineLength(string text, integer x, integer y, integer width, optional integer height, optional integer align)</functioncall>
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
    Misc
  </chapter_context>
  <target_document>US_Api_GFX</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, blit, text, line breaks, adapt line length</tags>
</US_DocBloc>
]]
  if type(text)~="string" then error("GFX_BlitText_AdaptLineLength: #1 - must be a string", 2) end
  if math.type(x)~="integer" then error("GFX_BlitText_AdaptLineLength: #2 - must be an integer", 2) end
  if math.type(y)~="integer" then error("GFX_BlitText_AdaptLineLength: #3 - must be an integer", 2) end
  if type(width)~="number" then error("GFX_BlitText_AdaptLineLength: #4 - must be an integer", 2) end
  if height~=nil and type(height)~="number" then error("GFX_BlitText_AdaptLineLength: #5 - must be an integer", 2) end
  if align~=nil and math.type(align)~="integer" then error("GFX_BlitText_AdaptLineLength: 6 - must be an integer", 2) end
  local l=gfx.measurestr("A")
  if width<gfx.measurestr("A") then error("GFX_BlitText_AdaptLineLength: #4 - must be at least "..l.." pixels for this font.", -7) end

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
  local old_x, old_y=gfx.x, gfx.y
  gfx.x=x
  gfx.y=y
  local xwidth, xheight = gfx.measurestr(newtext)
  gfx.drawstr(newtext.."\n  ", center)--xwidth+3+x, xheight)
  gfx.x=old_x
  gfx.y=old_y
  return true
end

function reagirl.ResizeImageKeepAspectRatio(image, neww, newh, bg_r, bg_g, bg_b)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ResizeImageKeepAspectRatio</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>boolean retval = reagirl.ResizeImageKeepAspectRatio(integer image, integer neww, integer newh, optional number r, optional number g, optional number b)</functioncall>
  <description>
    Resizes an image, keeping its aspect-ratio. You can set a background-color for non rectangular-images.
    
    Resizing upwards will probably cause artifacts!
    
    Note: this uses image 1023 as temporary buffer so don't use image 1023, when using this function!
  </description>
  <parameters>
    integer image - an image between 0 and 1022, that you want to resize
    integer neww - the new width of the image
    integer newh - the new height of the image
    optional number r - the red-value of the background-color; nil, = 0
    optional number g - the green-value of the background-color; nil, = 0
    optional number b - the blue-value of the background-color; nil, = 0
  </parameters>
  <retvals>
    boolean retval - true, blitting was successful; false, blitting was unsuccessful
  </retvals>
  <chapter_context>
    Misc
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, resize, image</tags>
</US_DocBloc>
]]
  if math.type(image)~="integer" then error("ResizeImageKeepAspectRatio: #1 - must be an integer", 2) end
  if math.type(neww)~="integer" then error("ResizeImageKeepAspectRatio: #2 - must be an integer", 2) end
  if math.type(newh)~="integer" then error("ResizeImageKeepAspectRatio: #3 - must be an integer", 2) end
  
  if bg_r~=nil and type(bg_r)~="number" then error("ResizeImageKeepAspectRatio: #4 - must be a number", 2) end
  if bg_r==nil then bg_r=0 end
  if bg_g~=nil and type(bg_g)~="number" then error("ResizeImageKeepAspectRatio: #5 - must be a number", 2) end
  if bg_g==nil then bg_g=0 end
  if bg_b~=nil and type(bg_b)~="number" then error("ResizeImageKeepAspectRatio: #6 - must be a number", 2) end
  if bg_b==nil then bg_b=0 end
  
  if image<0 or image>1022 then error("ResizeImageKeepAspectRatio: #1 - must be between 0 and 1022", 2) end
  if neww<0 or neww>8192 then error("ResizeImageKeepAspectRatio: #2 - must be between 0 and 8192", 2) end
  if newh<0 or newh>8192 then error("ResizeImageKeepAspectRatio: #3 - must be between 0 and 8192", 2) end
  
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

--reagirl.ResizeImageKeepAspectRatio(1, 1, 1, 1, 1, 1)

function reagirl.Window_Open(...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Window_Open</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    JS=0.964
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional HWND hwnd = reagirl.Window_Open(string title, optional integer width, optional integer height, optional integer dockstate, optional integer xpos, optional integer ypos)</functioncall>
  <description>
    Opens a new graphics window and returns its HWND-windowhandler object.
  </description>
  <parameters>
    string title - the name of the window, which will be shown in the title of the window
    optional integer width -  the width of the window; minmum is 50
    optional integer height -  the height of the window; minimum is 16
    optional integer dockstate - &1=0, undocked; &1=1, docked
    optional integer xpos - x-position of the window in pixels; minimum is -80; nil, to center it horizontally
    optional integer ypos - y-position of the window in pixels; minimum is -15; nil, to center it vertically
  </parameters>
  <retvals>
    number retval - 1.0, if window is opened
    optional HWND hwnd - when JS-extension is installed, the window-handler of the newly created window; can be used with JS_Window_xxx-functions of the JS-extension-plugin
  </retvals>
  <chapter_context>
    Window
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, gfx, init, window, create, hwnd</tags>
</US_DocBloc>
]]
  local parms={...}
  if type(parms[1])~="string" then error("Window_Open: #1 - must be a string", 2) end
  if parms[2]~=nil and type(parms[2])~="number" then error("Window_Open: #2 - must be an integer", 2) end
  if parms[3]~=nil and type(parms[3])~="number" then error("Window_Open: #3 - must be an integer", 2) end
  if parms[4]~=nil and type(parms[4])~="number" then error("Window_Open: #4 - must be an integer", 2) end
  if parms[5]~=nil and type(parms[5])~="number" then error("Window_Open: #5 - must be an integer", 2) end
  if parms[6]~=nil and type(parms[6])~="number" then error("Window_Open: #6 - must be an integer", 2) end
  
  local AAA, AAA2=reaper.ThemeLayout_GetLayout("tcp", -3)
  local minimum_scale_for_dpi, maximum_scale_for_dpi = 1,1--ultraschall.GetScaleRangeFromDpi(tonumber(AAA2))
  maximum_scale_for_dpi = math.floor(maximum_scale_for_dpi)
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
    
    local A1,B,C,D=reaper.my_getViewport(0,0,0,0, 0,0,0,0, false)
    parms[2]=parms[2]*minimum_scale_for_dpi
    parms[3]=parms[3]*minimum_scale_for_dpi
    if parms[5]==nil then
      parms[5]=(C-parms[2])/2
    end
    if parms[6]==nil then
      parms[6]=(D-parms[3])/2
    end

    if reaper.JS_Window_SetTitle==nil then return gfx.init(table.unpack(parms)) end
    
    -- check for a window-name not being used yet, which is 
    -- windowtitleX, where X is a number
    local freeslot=0
    for i=0, 65555 do
      if reaper.JS_Window_Find(parms[1]..i, true)==nil then freeslot=i break end
    end
    -- use that found, unused windowtitle as temporary windowtitle
    parms[1]=parms[1]..freeslot
    

    -- open window  
    retval=gfx.init(table.unpack(parms))
    
    -- find the window with the temporary windowtitle and get its HWND
    HWND=reaper.JS_Window_Find(parms[1], true)
    
    -- rename it to the original title
    if HWND~=nil then reaper.JS_Window_SetTitle(HWND, temp) end
    reagirl.GFX_WindowHWND=HWND
  else 
    retval=0.0
  end
  return retval, reagirl.GFX_WindowHWND
end

function reagirl.Mouse_GetCap(doubleclick_wait, drag_wait)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Mouse_GetCap</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>string clickstate, string specific_clickstate, integer mouse_cap, integer click_x, integer click_y, integer drag_x, integer drag_y, integer mouse_wheel, integer mouse_hwheel = reagirl.Mouse_GetCap(optional integer doubleclick_wait, optional integer drag_wait)</functioncall>
  <description>
    Checks clickstate and mouseclick/wheel-behavior, since last time calling this function and returns their states.
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
    Misc
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, mouse, mouse cap, leftclick, rightclick, doubleclick, drag, wheel, mousewheel, horizontal mousewheel</tags>
</US_DocBloc>
]]
  if doubleclick_wait~=nil and math.type(doubleclick_wait)~="integer" then error("Mouse_GetCap: #1 - must be an integer", 2) end
  if drag_wait~=nil and math.type(drag_wait)~="integer" then error("Mouse_GetCap: #2 - must be an integer", 2) end
--HUITOO=reaper.time_precise()
  -- prepare variables
  if reagirl.MouseCap==nil then
    -- if mouse-function hasn't been used yet, initialize variables
    reagirl.MouseCap={}
    reagirl.MouseCap.mouse_last_mousecap=0         -- last mousecap when last time this function got called, including 0
    reagirl.MouseCap.mouse_last_clicked_mousecap=0 -- last mousecap, the last time a button was clicked
    reagirl.MouseCap.mouse_dragcounter=0           -- the counter for click and wait, until drag is "activated"
    reagirl.MouseCap.mouse_lastx=0                 -- last mouse-x position
    reagirl.MouseCap.mouse_lasty=0                 -- last mouse-y position
    reagirl.MouseCap.mouse_endx=0                  -- end-x-position, for dragging
    reagirl.MouseCap.mouse_endy=0                  -- end-y-position, for dragging
    reagirl.MouseCap.mouse_dblclick=0              -- double-click-counter; 1, if a possible doubleclick can happen
    reagirl.MouseCap.mouse_dblclick_counter=0      -- double-click-waiting-counter; doubleclicks are only recognized, until this is "full"
    reagirl.MouseCap.mouse_clickblock=false        -- blocks mouseclicks after double-click, until button-release
    reagirl.MouseCap.mouse_last_hwheel=0           -- last horizontal mouse-wheel-state, the last time this function got called
    reagirl.MouseCap.mouse_last_wheel=0            -- last mouse-wheel-state, the last time this function got called
  end
  if math.type(doubleclick_wait)~="integer" then doubleclick_wait=0 end
  if math.type(drag_wait)~="integer" then drag_wait=15 end
  -- if mousewheels have been changed, store the new values and reset the gfx-variables
  if reagirl.MouseCap.mouse_last_hwheel~=gfx.mouse_hwheel or reagirl.MouseCap.mouse_last_wheel~=gfx.mouse_wheel then
    reagirl.MouseCap.mouse_last_hwheel=math.floor(gfx.mouse_hwheel)
    reagirl.MouseCap.mouse_last_wheel=math.floor(gfx.mouse_wheel)
  end
  gfx.mouse_hwheel=0
  gfx.mouse_wheel=0
  
  local newmouse_cap=0
  if gfx.mouse_cap&1~=0 then newmouse_cap=newmouse_cap+1 end
  if gfx.mouse_cap&2~=0 then newmouse_cap=newmouse_cap+2 end
  if gfx.mouse_cap&64~=0 then newmouse_cap=newmouse_cap+64 end
  
  if newmouse_cap==0 then
  -- if no mouse_cap is set, reset all counting-variables and return just the basics
    reagirl.MouseCap.mouse_last_mousecap=0
    reagirl.MouseCap.mouse_dragcounter=0
    reagirl.MouseCap.mouse_dblclick_counter=reagirl.MouseCap.mouse_dblclick_counter+1
    if reagirl.MouseCap.mouse_dblclick_counter>doubleclick_wait then
      -- if the doubleclick-timer is over, the next click will be recognized as normal click
      reagirl.MouseCap.mouse_dblclick=0
      reagirl.MouseCap.mouse_dblclick_counter=doubleclick_wait
    end
    reagirl.MouseCap.mouse_clickblock=false
    return "", "", gfx.mouse_cap, gfx.mouse_x, gfx.mouse_y, gfx.mouse_x, gfx.mouse_y, reagirl.MouseCap.mouse_last_wheel, reagirl.MouseCap.mouse_last_hwheel
  end
  if reagirl.MouseCap.mouse_clickblock==false then
    
    if newmouse_cap~=reagirl.MouseCap.mouse_last_mousecap then
      -- first mouseclick
      if reagirl.MouseCap.mouse_dblclick~=1 or (reagirl.MouseCap.mouse_lastx==gfx.mouse_x and reagirl.MouseCap.mouse_lasty==gfx.mouse_y) then

        -- double-click-checks
        if reagirl.MouseCap.mouse_dblclick~=1 then
          -- the first click, activates the double-click-timer
          reagirl.MouseCap.mouse_dblclick=1
          reagirl.MouseCap.mouse_dblclick_counter=0
        elseif reagirl.MouseCap.mouse_dblclick==1 and reagirl.MouseCap.mouse_dblclick_counter<doubleclick_wait 
            and reagirl.MouseCap.mouse_last_clicked_mousecap==newmouse_cap then
          -- when doubleclick occured, gfx.mousecap is still the same as the last clicked mousecap:
          -- block further mouseclick, until mousebutton is released and return doubleclick-values
          reagirl.MouseCap.mouse_dblclick=2
          reagirl.MouseCap.mouse_dblclick_counter=doubleclick_wait
          reagirl.MouseCap.mouse_clickblock=true
          return "CLK", "DBLCLK", gfx.mouse_cap, reagirl.MouseCap.mouse_lastx, reagirl.MouseCap.mouse_lasty, reagirl.MouseCap.mouse_lastx, reagirl.MouseCap.mouse_lasty, reagirl.MouseCap.mouse_last_wheel, reagirl.MouseCap.mouse_last_hwheel
        elseif reagirl.MouseCap.mouse_dblclick_counter==doubleclick_wait then
          -- when doubleclick-timer is full, reset mouse_dblclick to 0, so the next mouseclick is 
          -- recognized as normal mouseclick
          reagirl.MouseCap.mouse_dblclick=0
          reagirl.MouseCap.mouse_dblclick_counter=doubleclick_wait
        end
      end
      -- in every other case, this is a first-click, so set the appropriate variables and return 
      -- the first-click state and values
      reagirl.MouseCap.mouse_last_mousecap=newmouse_cap
      reagirl.MouseCap.mouse_last_clicked_mousecap=newmouse_cap
      reagirl.MouseCap.mouse_lastx=gfx.mouse_x
      reagirl.MouseCap.mouse_lasty=gfx.mouse_y
      return "CLK", "FirstCLK", gfx.mouse_cap, reagirl.MouseCap.mouse_lastx, reagirl.MouseCap.mouse_lasty, reagirl.MouseCap.mouse_lastx, reagirl.MouseCap.mouse_lasty, reagirl.MouseCap.mouse_last_wheel, reagirl.MouseCap.mouse_last_hwheel
    elseif newmouse_cap==reagirl.MouseCap.mouse_last_mousecap and reagirl.MouseCap.mouse_dragcounter<drag_wait
      and (gfx.mouse_x~=reagirl.MouseCap.mouse_lastx or gfx.mouse_y~=reagirl.MouseCap.mouse_lasty) then
      -- dragging when mouse moves, sets dragcounter to full waiting-period
      reagirl.MouseCap.mouse_endx=gfx.mouse_x
      reagirl.MouseCap.mouse_endy=gfx.mouse_y
      reagirl.MouseCap.mouse_dragcounter=drag_wait
      reagirl.MouseCap.mouse_dblclick=0
      return "CLK", "DRAG", gfx.mouse_cap, reagirl.MouseCap.mouse_lastx, reagirl.MouseCap.mouse_lasty, reagirl.MouseCap.mouse_endx, reagirl.MouseCap.mouse_endy, reagirl.MouseCap.mouse_last_wheel, reagirl.MouseCap.mouse_last_hwheel
    elseif newmouse_cap==reagirl.MouseCap.mouse_last_mousecap and reagirl.MouseCap.mouse_dragcounter<drag_wait then
      -- when clicked but mouse doesn't move, count up, until we reach the countlimit for
      -- activating dragging
      reagirl.MouseCap.mouse_dragcounter=reagirl.MouseCap.mouse_dragcounter+1
      return "CLK", "CLK", gfx.mouse_cap, reagirl.MouseCap.mouse_lastx, reagirl.MouseCap.mouse_lasty, reagirl.MouseCap.mouse_endx, reagirl.MouseCap.mouse_endy, reagirl.MouseCap.mouse_last_wheel, reagirl.MouseCap.mouse_last_hwheel
    elseif newmouse_cap==reagirl.MouseCap.mouse_last_mousecap and reagirl.MouseCap.mouse_dragcounter==drag_wait then
      -- dragging, after drag-counter is set to full waiting-period
      reagirl.MouseCap.mouse_endx=gfx.mouse_x
      reagirl.MouseCap.mouse_endy=gfx.mouse_y
      reagirl.MouseCap.mouse_dblclick=0
      return "CLK", "DRAG", gfx.mouse_cap, reagirl.MouseCap.mouse_lastx, reagirl.MouseCap.mouse_lasty, reagirl.MouseCap.mouse_endx, reagirl.MouseCap.mouse_endy, reagirl.MouseCap.mouse_last_wheel, reagirl.MouseCap.mouse_last_hwheel
    end
  else
    return "", "", gfx.mouse_cap, gfx.mouse_x, gfx.mouse_y, gfx.mouse_x, gfx.mouse_y, reagirl.MouseCap.mouse_last_wheel, reagirl.MouseCap.mouse_last_hwheel
  end
end

function reagirl.Gui_New()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Gui_New</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>reagirl.Gui_New()</functioncall>
  <description>
    Creates a new gui by removing all currently(if available) ui-elements.
  </description>
  <chapter_context>
    Gui
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, new, gui</tags>
</US_DocBloc>
]]
  reagirl.SetFont(1, "Arial", reagirl.Font_Size, 0)
  reagirl.MaxImage=1
  gfx.set(reagirl["WindowBackgroundColorR"], reagirl["WindowBackgroundColorG"], reagirl["WindowBackgroundColorB"])
  gfx.rect(0,0,gfx.w,gfx.h,1)
  gfx.x=0
  gfx.y=0
  reagirl.Elements={}
  reagirl.Elements["FocusedElement"]=nil
  reagirl.ScrollButton_Left_Add() 
  reagirl.ScrollButton_Right_Add()
  reagirl.ScrollButton_Up_Add()
  reagirl.ScrollButton_Down_Add()
end


function reagirl.SetFont(idx, fontface, size, flags)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFont</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>reagirl.Gui_New(integer idx, string fontface, integer size, integer flags)</functioncall>
  <description>
    Creates a new gui by removing all currently(if available) ui-elements.
  </description>
  <chapter_context>
    Misc
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, font</tags>
</US_DocBloc>
]]
  if math.type(idx)~="integer" then error("Mouse_GetCap: #1 - must be an integer", 2) end
  if type(fontface)~="string" then error("Mouse_GetCap: #2 - must be an integer", 2) end
  if math.type(size)~="integer" then error("Mouse_GetCap: #3 - must be an integer", 2) end
  if math.type(flags)~="integer" then error("Mouse_GetCap: #4 - must be an integer", 2) end
  if size~=nil then size=size* reagirl.dpi_scale end
  local font_size = size * (1+reagirl.dpi_scale)*0.5
  if reaper.GetOS():match("OS")~=nil then size=math.floor(size*0.8) end
  gfx.setfont(idx, fontface, size, flags)
end

function reagirl.Gui_Open(title, description, w, h, dock, x, y)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Gui_Open</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>integer window_open, optional hwnd window_handler = reagirl.Gui_Open(string title, string description, optional integer w, optional integer h, optional integer dock, optional integer x, optional integer y)</functioncall>
  <description>
    Opens a gui-window. If x and/or y are not given, it will be opened centered.
  </description>
  <retvals>
    number retval - 1.0, if window is opened
    optional hwnd window_handler - a hwnd-window-handler for this window; only returned, with JS-extension installed!
  </retvals>
  <parameters>
    string title - the title of the window
    string description - a description of what this dialog does, for blind users
    optional integer w - the width of the window; nil=640
    optional integer h - the height of the window; nil=400
    optional integer dock - the dockstate of the window; 0, undocked; 1, docked; nil=undocked
    optional integer x - the x-position of the window; nil=x-centered
    optional integer y - the y-position of the window; nil=y-centered
  </parameters>
  <chapter_context>
    Gui
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, open, gui</tags>
</US_DocBloc>
]]
  if type(title)~="string" then error("Gui_Open: #1 - must be an integer", 2) end
  if type(description)~="string" then error("Gui_Open: #2 - must be an integer", 2) end
  if w~=nil and math.type(w)~="integer" then error("Gui_Open: #3 - must be an integer", 2) end
  if h~=nil and math.type(h)~="integer" then error("Gui_Open: #4 - must be an integer", 2) end
  if dock~=nil and math.type(dock)~="integer" then error("Gui_Open: #5 - must be an integer", 2) end
  if x~=nil and math.type(x)~="integer" then error("Gui_Open: #6 - must be an integer", 2) end
  if y~=nil and math.type(y)~="integer" then error("Gui_Open: #7 - must be an integer", 2) end
  local retval
  retval, reagirl.dpi = reaper.ThemeLayout_GetLayout("tcp", -3)
  if reagirl.dpi == "512" then
    reagirl.dpi_scale = 1
    --gfx.ext_retina = 1
  else
    reagirl.dpi_scale = 0
  end
  
  reagirl.IsWindowOpen_attribute=true
  reagirl.Gui_ForceRefresh(1)
  ALL=reaper.time_precise()
  reagirl.Window_Title=title
  reagirl.Window_Description=description
  reagirl.Window_x=x
  reagirl.Window_y=y
  reagirl.Window_w=w
  reagirl.Window_h=h
  reagirl.Window_dock=dock
  
  if reagirl.Window_ForceMinSize_Toggle==nil then reagirl.Window_ForceMinSize_Toggle=false end
  reagirl.osara_init_message=false
  
  return reagirl.Window_Open(title, w, h, dock, x, y)
end

function reagirl.Gui_IsOpen()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Gui_IsOpen</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>boolean retval = reagirl.Gui_IsOpen()</functioncall>
  <description>
    Checks, whether the gui-window is open.
  </description>
  <retvals>
    boolean retval - true, Gui is open; false, Gui is not open
  </retvals>
  <chapter_context>
    Gui
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, is open, gui</tags>
</US_DocBloc>
]]
  return reagirl.IsWindowOpen_attribute
end

function reagirl.Gui_Close()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Gui_Close</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>reagirl.Gui_Close()</functioncall>
  <description>
    Closes the gui-window.
  </description>
  <chapter_context>
    Gui
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, close, gui</tags>
</US_DocBloc>
]]
  gfx.quit()
  reagirl.IsWindowOpen_attribute=false
end


--up 30064.0
--down 1685026670.0

function reagirl.Gui_Manage()
  reagirl.UI_Elements_Boundaries()
  -- manages the gui, including tts, mouse and keyboard-management and ui-focused-management
  
  -- initialize focus of first element, if not done already
  if reagirl.Elements["FocusedElement"]==nil then reagirl.Elements["FocusedElement"]=reagirl.UI_Element_GetNext(0) end
  
  local init_message=""
  local helptext=""
  if reagirl.osara_init_message==false then
    if reagirl.Elements["FocusedElement"]~=-1 then
      if reagirl.Elements[1]~=nil then
        reagirl.osara_init_message=reagirl.Window_Title.. "-dialog, ".. reagirl.Window_Description..". ".. reagirl.Elements[reagirl.Elements["FocusedElement"]]["Name"].." ".. reagirl.Elements[reagirl.Elements["FocusedElement"]]["GUI_Element_Type"]
        helptext=reagirl.Elements[reagirl.Elements["FocusedElement"]]["Description"]..", "..reagirl.Elements[reagirl.Elements["FocusedElement"]]["AccHint"]
      else
        reagirl.osara_init_message=reagirl.Window_Title.."-dialog, "..reagirl.Window_Description..". "
      end
    end
  end
  reagirl.UI_Element_MinX=gfx.w
  reagirl.UI_Element_MinY=gfx.h
  reagirl.UI_Element_MaxW=0
  reagirl.UI_Element_MaxH=0
  local x2, y2
  
  reagirl.FileDropZone_CheckForDroppedFiles()
  reagirl.ContextMenuZone_ManageMenu(gfx.mouse_cap)
  --if reagirl.Elements==nil or #reagirl.Elements==0 then return end
  for i=1, #reagirl.Elements do reagirl.Elements[i]["clicked"]=false end
  local Key, Key_utf=gfx.getchar()
  --if Key~=0 then reaper.CF_SetClipboard(Key) end
  local Screenstate=gfx.getchar(65536) -- currently unused
  if Key==-1 then reagirl.IsWindowOpen_attribute=false return end
  
  --Debug Code - move ui-elements via arrow keys, including stopping when end of ui-elements has been reached.
  -- This can be used to build more extensive scrollcode, including smooth scroll and scrollbars
  -- see reagirl.UI_Elements_Boundaries() for the calculation of it and more information
  
  if gfx.mouse_hwheel~=0 then reagirl.UI_Element_ScrollX(-gfx.mouse_hwheel/50) end
  if gfx.mouse_wheel~=0 then reagirl.UI_Element_ScrollY(gfx.mouse_wheel/50) end
  if reagirl.Elements["FocusedElement"]~=-1 and reagirl.Elements[reagirl.Elements["FocusedElement"]].GUI_Element_Type~="Edit" and reagirl.Elements[reagirl.Elements["FocusedElement"]].GUI_Element_Type~="Edit Multiline" then
  -- scroll via keys
    if gfx.mouse_cap&8==0 and Key==30064 then reagirl.UI_Element_ScrollY(2) end -- up
    if gfx.mouse_cap&8==0 and Key==1685026670 then reagirl.UI_Element_ScrollY(-2) end --down
    if Key==1818584692.0 then reagirl.UI_Element_ScrollX(-2) end -- left
    if Key==1919379572.0 then reagirl.UI_Element_ScrollX(2) end -- right
    if Key==1885828464.0 then reagirl.UI_Element_ScrollY(20) end -- pgdown
    if Key==1885824110.0 then reagirl.UI_Element_ScrollY(-20) end -- pgup
    if gfx.mouse_cap&8==8 and Key==1818584692.0 then reagirl.UI_Element_ScrollX(20) end -- Shift+left  - pgleft
    if gfx.mouse_cap&8==8 and Key==1919379572.0 then reagirl.UI_Element_ScrollX(-20) end --Shift+right - pgright
    if Key==1752132965.0 then reagirl.MoveItAllUp=0 reagirl.Gui_ForceRefresh(64.789) end -- home
    if Key==6647396.0 then MoveItAllUp_Delta=0 reagirl.MoveItAllUp=gfx.h-reagirl.BoundaryY_Max reagirl.Gui_ForceRefresh(64.1) end -- end
    --if Key~=0 then print3(Key) end
  end
  reagirl.UI_Element_SmoothScroll(1)
  -- End of Debug
  
  if Key==27 then reagirl.Gui_Close() else reagirl.Window_ForceMinSize() reagirl.Window_ForceMaxSize() end
  if Key==26161 and reaper.osara_outputMessage~=nil then reaper.osara_outputMessage(reagirl.Elements[reagirl.Elements["FocusedElement"]]["Description"]) end
  if reagirl.OldMouseX==gfx.mouse_x and reagirl.OldMouseY==gfx.mouse_y then
    reagirl.TooltipWaitCounter=reagirl.TooltipWaitCounter+1
  else
    reagirl.TooltipWaitCounter=0
  end
  reagirl.OldMouseX=gfx.mouse_x
  reagirl.OldMouseY=gfx.mouse_y
  if reagirl.Windows_OldH~=gfx.h then reagirl.Windows_OldH=gfx.h reagirl.Gui_ForceRefresh(2) end
  if reagirl.Windows_OldW~=gfx.w then reagirl.Windows_OldW=gfx.w reagirl.Gui_ForceRefresh(3) end
  
  if gfx.mouse_cap&8==0 and Key==9 then 
    reagirl.Elements["FocusedElement"]=reagirl.UI_Element_GetNext(reagirl.Elements["FocusedElement"])
    --reagirl.Elements["FocusedElement"]=reagirl.Elements["FocusedElement"]+1 
    if reagirl.Elements["FocusedElement"]~=-1 then
      if reagirl.Elements["FocusedElement"]>#reagirl.Elements then reagirl.Elements["FocusedElement"]=1 end 
      init_message=reagirl.Elements[reagirl.Elements["FocusedElement"]]["Name"].." "..reagirl.Elements[reagirl.Elements["FocusedElement"]]["GUI_Element_Type"].." "
      helptext=reagirl.Elements[reagirl.Elements["FocusedElement"]]["Description"]..", "..reagirl.Elements[reagirl.Elements["FocusedElement"]]["AccHint"]
      if reagirl.Elements["FocusedElement"]<=#reagirl.Elements-4 then
        reagirl.UI_Element_ScrollToUIElement(reagirl.Elements[reagirl.Elements["FocusedElement"]].Guid) -- buggy, should scroll to ui-element...
      end
      reagirl.UI_Element_SetFocusRect()
      reagirl.old_osara_message=""
      reagirl.Gui_ForceRefresh(4) 
    end
  end
  
  if reagirl.Elements["FocusedElement"]>#reagirl.Elements then reagirl.Elements["FocusedElement"]=1 end
  if gfx.mouse_cap&8==8 and Key==9 then 
    reagirl.Elements["FocusedElement"]=reagirl.UI_Element_GetPrevious(reagirl.Elements["FocusedElement"])
    --reagirl.Elements["FocusedElement"]=reagirl.Elements["FocusedElement"]-1 
    if reagirl.Elements["FocusedElement"]~=-1 then
      if reagirl.Elements["FocusedElement"]<1 then reagirl.Elements["FocusedElement"]=#reagirl.Elements end
      init_message=reagirl.Elements[reagirl.Elements["FocusedElement"]]["Name"].." "..
      reagirl.Elements[reagirl.Elements["FocusedElement"]]["GUI_Element_Type"]
      helptext=reagirl.Elements[reagirl.Elements["FocusedElement"]]["Description"]..", "..reagirl.Elements[reagirl.Elements["FocusedElement"]]["AccHint"]
      reagirl.old_osara_message=""
      if reagirl.Elements["FocusedElement"]<=#reagirl.Elements-4 then
        reagirl.UI_Element_ScrollToUIElement(reagirl.Elements[reagirl.Elements["FocusedElement"]].Guid) -- buggy, should scroll to ui-element...
      end
      reagirl.UI_Element_SetFocusRect()
      reagirl.Gui_ForceRefresh(5) 
    end
  end
  if reagirl.Elements["FocusedElement"]<1 then reagirl.Elements["FocusedElement"]=#reagirl.Elements end
  if Key==32 then reagirl.Elements[reagirl.Elements["FocusedElement"]]["clicked"]=true end
  
  local clickstate, specific_clickstate, mouse_cap, click_x, click_y, drag_x, drag_y, mouse_wheel, mouse_hwheel = reagirl.Mouse_GetCap(2, 5)
  for i=#reagirl.Elements, 1, -1 do
    local x2, y2, w2, h2
    if reagirl.Elements[i]["x"]<0 then x2=gfx.w+reagirl.Elements[i]["x"] else x2=reagirl.Elements[i]["x"] end
    if reagirl.Elements[i]["y"]<0 then y2=gfx.h+reagirl.Elements[i]["y"] else y2=reagirl.Elements[i]["y"] end
    if reagirl.Elements[i]["w"]<0 then w2=gfx.w-x2+reagirl.Elements[i]["w"] else w2=reagirl.Elements[i]["w"] end
    if reagirl.Elements[i]["h"]<0 then h2=gfx.h-y2+reagirl.Elements[i]["h"] else h2=reagirl.Elements[i]["h"] end
    if reagirl.Elements[i]["GUI_Element_Type"]=="DropDownMenu" then
      if w2<20 then w2=20 end
    end
    
    -- is any gui-element outside of the window
    local MoveItAllUp=reagirl.MoveItAllUp  
    local MoveItAllRight=reagirl.MoveItAllRight
    if reagirl.Elements[i]["sticky_y"]==true then MoveItAllUp=0 end
    if reagirl.Elements[i]["sticky_x"]==true then MoveItAllRight=0 end
    
    
    if x2+MoveItAllRight<reagirl.UI_Element_MinX then reagirl.UI_Element_MinX=x2+MoveItAllRight end
    if y2<reagirl.UI_Element_MinY+MoveItAllUp then reagirl.UI_Element_MinY=y2+MoveItAllUp end
    
    if x2+MoveItAllRight+w2>reagirl.UI_Element_MaxW then reagirl.UI_Element_MaxW=x2+MoveItAllRight+w2 end
    if y2+MoveItAllUp+h2>reagirl.UI_Element_MaxH then reagirl.UI_Element_MaxH=y2+h2+MoveItAllUp end
    --]]
    
    if gfx.mouse_x>=x2+MoveItAllRight and
       gfx.mouse_x<=x2+MoveItAllRight+w2 and
       gfx.mouse_y>=y2+MoveItAllUp and
       gfx.mouse_y<=y2+MoveItAllUp+h2 then
       if reagirl.TooltipWaitCounter==14 then
      
        XX,YY=reaper.GetMousePosition()
        reaper.TrackCtl_SetToolTip(reagirl.Elements[i]["Description"], XX+15, YY+10, true)
        --reaper.JS_Mouse_SetPosition(XX+3,YY+3)
        --reaper.TrackCtl_SetToolTip(reagirl.Elements[i]["Description"], x+15, y+10, false)
        if reaper.osara_outputMessage~=nil then reaper.osara_outputMessage(reagirl.Elements[i]["Text"]:utf8_sub(1,20)) end
       end
       if (specific_clickstate=="FirstCLK") and reagirl.Elements[i]["IsDecorative"]==false then
         if i~=reagirl.Elements["FocusedElement"] then
           init_message=reagirl.Elements[i]["Name"].." "..reagirl.Elements[i]["GUI_Element_Type"].." "
           helptext=reagirl.Elements[i]["Description"]..", "..reagirl.Elements[i]["AccHint"]
         end
         reagirl.Elements["FocusedElement"]=i
         reagirl.Elements[i]["clicked"]=true
         reagirl.UI_Element_SetFocusRect()
         reagirl.Gui_ForceRefresh(6) 
       end
       break
    end
  end
  for i=#reagirl.Elements, 1, -1 do
    local x2, y2, w2, h2
    if reagirl.Elements[i]["x"]<0 then x2=gfx.w+reagirl.Elements[i]["x"] else x2=reagirl.Elements[i]["x"] end
    if reagirl.Elements[i]["y"]<0 then y2=gfx.h+reagirl.Elements[i]["y"] else y2=reagirl.Elements[i]["y"] end
    if reagirl.Elements[i]["w"]<0 then w2=gfx.w-x2+reagirl.Elements[i]["w"] else w2=reagirl.Elements[i]["w"] end
    if reagirl.Elements[i]["h"]<0 then h2=gfx.h-y2+reagirl.Elements[i]["h"] else h2=reagirl.Elements[i]["h"] end
    
    local MoveItAllUp=reagirl.MoveItAllUp   
    local MoveItAllRight=reagirl.MoveItAllRight
    if reagirl.Elements[i]["sticky_y"]==true then MoveItAllUp=0 end
    if reagirl.Elements[i]["sticky_x"]==true then MoveItAllRight=0 end
    --if (x2+MoveItAllRight>=0 and x2+MoveItAllRight<=gfx.w) or (y2+MoveItAllUp>=0 and y2+MoveItAllUp<=gfx.h) or (x2+MoveItAllRight+w2>=0 and x2+MoveItAllRight+w2<=gfx.w) or (y2+MoveItAllUp+h2>=0 and y2+MoveItAllUp+h2<=gfx.h) then
    -- uncommented code: might improve performance by running only manage-functions of UI-elements, who are visible(though might be buggy)
    --                   but seems to work without it as well
      local message, refresh=reagirl.Elements[i]["func_manage"](i, reagirl.Elements["FocusedElement"]==i,
        specific_clickstate,
        gfx.mouse_cap,
        {click_x, click_y, drag_x, drag_y, mouse_wheel, mouse_hwheel},
        reagirl.Elements[i]["Name"],
        reagirl.Elements[i]["Description"], 
        x2+MoveItAllRight,
        y2+MoveItAllUp,
        w2,
        h2,
        Key,
        Key_utf,
        reagirl.Elements[i]
      )
    --end
    if reagirl.Elements["FocusedElement"]==i and reagirl.Elements[reagirl.Elements["FocusedElement"]]["IsDecorative"]==false and reagirl.old_osara_message~=message and reaper.osara_outputMessage~=nil then
      --reaper.osara_outputMessage(reagirl.osara_init_message..message)
      if message==nil then message="" end
      reaper.osara_outputMessage(reagirl.osara_init_message..init_message.." "..message..", "..helptext)
      reagirl.old_osara_message=message
      reagirl.osara_init_message=""
    end
    if refresh==true then reagirl.Gui_ForceRefresh(7) end
  end
  reagirl.Gui_Draw(Key, Key_utf, clickstate, specific_clickstate, mouse_cap, click_x, click_y, drag_x, drag_y, mouse_wheel, mouse_hwheel)
end

function reagirl.Dummy()

end

function reagirl.UI_Element_SetFocusRect(x, y, w, h)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_SetFocusRect</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>reagirl.UI_Element_SetFocusRect(integer x, integer y, integer w, integer h)</functioncall>
  <description>
    sets the rectangle for focused ui-element. Can be used for custom ui-element, who need to control the focus-rectangle due some of their own ui-elements incorporated, like options in radio-buttons, etc.
  </description>
  <parameters>
    integer x - the x-position of the focus-rectangle; negative, dock to the right windowborder
    integer y - the y-position of the focus-rectangle; negative, dock to the bottom windowborder
    integer w - the width of the focus-rectangle; negative, dock to the right windowborder
    integer h - the height of the focus-rectangle; negative, dock to the bottom windowborder
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, focus rectangle, ui-elements</tags>
</US_DocBloc>
]]
  if x~=nil and math.type(x)~="integer" then error("UI_Element_SetFocusRect: #1 - must be an integer", 2) end
  if y~=nil and math.type(y)~="integer" then error("UI_Element_SetFocusRect: #2 - must be an integer", 2) end
  if w~=nil and math.type(w)~="integer" then error("UI_Element_SetFocusRect: #3 - must be an integer", 2) end
  if h~=nil and math.type(h)~="integer" then error("UI_Element_SetFocusRect: #4 - must be an integer", 2) end
  
  if x==nil then 
    if reagirl.Elements[reagirl.Elements["FocusedElement"]]==nil then error("UI_Element_SetFocusRect: - no ui-elements existing", 2) end
    x=reagirl.Elements[reagirl.Elements["FocusedElement"]]["x"]
    y=reagirl.Elements[reagirl.Elements["FocusedElement"]]["y"]
    w=reagirl.Elements[reagirl.Elements["FocusedElement"]]["w"]
    h=reagirl.Elements[reagirl.Elements["FocusedElement"]]["h"]
  end
  reagirl.Elements["Focused_x"]=x
  reagirl.Elements["Focused_y"]=y
  reagirl.Elements["Focused_w"]=w
  reagirl.Elements["Focused_h"]=h
end



function reagirl.UI_Element_GetFocusRect()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetFocusRect</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>integer x, integer y, integer w, integer h, integer x2, integer y2, integer w2, integer h2 = reagirl.UI_Element_GetFocusRect()</functioncall>
  <description>
    gets the rectangle for focused ui-element. Can be used for custom ui-element, who need to control the focus-rectangle due some of their own ui-elements incorporated, like options in radio-buttons, etc.
    
    the first four retvals give the set-position(including possible negative values), the second four retvals give the actual window-coordinates.
  </description>
  <parameters>
    integer x - the x-position of the focus-rectangle; negative, dock to the right windowborder
    integer y - the y-position of the focus-rectangle; negative, dock to the bottom windowborder
    integer w - the width of the focus-rectangle; negative, dock to the right windowborder
    integer h - the height of the focus-rectangle; negative, dock to the bottom windowborder
    integer x2 - the actual x-position of the focus-rectangle
    integer y2 - the actual y-position of the focus-rectangle
    integer w2 - the actual width of the focus-rectangle
    integer h2 - the actual height of the focus-rectangle
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, get, focus rectangle, ui-elements</tags>
</US_DocBloc>
]]
  if reagirl.Elements["Focused_x"]==nil then 
    if reagirl.Elements[reagirl.Elements["FocusedElement"]]~=nil then 
      local x,y,w,h
      x=reagirl.Elements[reagirl.Elements["FocusedElement"]]["x"]
      y=reagirl.Elements[reagirl.Elements["FocusedElement"]]["y"]
      w=reagirl.Elements[reagirl.Elements["FocusedElement"]]["w"]
      h=reagirl.Elements[reagirl.Elements["FocusedElement"]]["h"]
      --print(x,y,w,h)
      reagirl.UI_Element_SetFocusRect(x, y, w, h)
    else
      reagirl.UI_Element_SetFocusRect(0,0,0,0)
    end
  end
  
  local x,y,w,h,x2,y2,w2,h2
  x=reagirl.Elements["Focused_x"]
  y=reagirl.Elements["Focused_y"]
  w=reagirl.Elements["Focused_w"]
  h=reagirl.Elements["Focused_h"]
  
  if x<0 then x2=gfx.w+x else x2=x end
  if y<0 then y2=gfx.h+y else y2=y end
  if w<0 then w2=gfx.w-x2+w else w2=w end
  if h<0 then h2=gfx.h-y2+h else h2=h end
  
  return x,y,w,h,x2,y2,w2,h2
end

function reagirl.UI_Elements_OutsideWindow()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Elements_OutsideWindow</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>integer horz_outside, integer vert_outside = reagirl.UI_Elements_OutsideWindow()</functioncall>
  <description>
    returns, if any of the gui-elements are outside of the window and by how much.
    
    Good for management of resizing window or scrollbars.
  </description>
  <retvals>
    integer horz_outside - the number of horizontal-pixels the ui-elements are outside of the window
    integer vert_outside - the number of vertical-pixels the ui-elements are outside of the window
  </retvals>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, is outside window, ui-elements</tags>
</US_DocBloc>
]]
  local vert=0
  local horz=0
  
  if reagirl.UI_Element_MinX<0 then vert=reagirl.UI_Element_MaxW-gfx.w
  elseif reagirl.UI_Element_MaxW>gfx.w then vert=reagirl.UI_Element_MaxW-gfx.w end
  
  if reagirl.UI_Element_MinY<0 then horz=gfx.h-reagirl.UI_Element_MaxH horz=-horz
  elseif reagirl.UI_Element_MaxH>gfx.h then horz=gfx.h-reagirl.UI_Element_MaxH horz=-horz end
  return horz, vert
end

function reagirl.UI_Element_GetNextOfType(ui_type, startoffset)
  -- will return the ui-element of a specific type next to the startoffset
  -- will "overflow", if the next element has a lower index
  local count=startoffset
  for i=1, #reagirl.Elements do
    count=count+1
    if count>#reagirl.Elements then count=1 end
    if reagirl.Elements[count].GUI_Element_Type==ui_type then return count, reagirl.Elements[count].Guid end
  end
  return -1, ""
end

function reagirl.UI_Element_GetPreviousOfType(ui_type, startoffset)
  -- will return the ui-element of a specific type next to the startoffset
  -- will "overflow", if the next element has a lower index
  local count=startoffset
  for i=1, #reagirl.Elements do
    count=count-1
    if count<1 then count=#reagirl.Elements end
    if reagirl.Elements[count].GUI_Element_Type==ui_type then return count, reagirl.Elements[count].Guid end
  end
  return -1, ""
end

function reagirl.UI_Element_GetNext(startoffset)
  -- will return the ui-element of a specific type next to the startoffset
  -- will "overflow", if the next element has a lower index
  local count=startoffset
  
  for i=1, #reagirl.Elements do
    count=count+1
    if count>#reagirl.Elements then count=1 end
    if reagirl.Elements[count]~=nil and reagirl.Elements[count].IsDecorative==false then 
      return count, reagirl.Elements[count].Guid 
    end
  end
  return -1, ""
end


function reagirl.UI_Element_GetPrevious(startoffset)
  -- will return the ui-element of a specific type next to the startoffset
  -- will "overflow", if the next element has a lower index
  local count=startoffset
  for i=1, #reagirl.Elements do
    count=count-1
    if count<1 then count=#reagirl.Elements end
    if reagirl.Elements[count].IsDecorative==false then return count, reagirl.Elements[count].Guid end
  end
  return -1, ""
end

function reagirl.UI_Elements_GetScrollRect()
  local min_x=8192
  local max_x=0
  local min_y=8192
  local max_y=0
  
  for i=1, #reagirl.Elements do
    local w2, h2, x2, y2
    if reagirl.Elements[i]["x"]<0 then x2=gfx.w+reagirl.Elements[i]["x"] else x2=reagirl.Elements[i]["x"] end
    if reagirl.Elements[i]["y"]<0 then y2=gfx.h+reagirl.Elements[i]["y"] else y2=reagirl.Elements[i]["y"] end
    if reagirl.Elements[i]["w"]<0 then w2=gfx.w-x2+reagirl.Elements[i]["w"] else w2=reagirl.Elements[i]["w"] end
    if reagirl.Elements[i]["h"]<0 then h2=gfx.h-y2+reagirl.Elements[i]["h"] else h2=reagirl.Elements[i]["h"] end
    
    if reagirl.Elements[i].sticky_x==false then
      if x2+reagirl.MoveItAllRight<=min_x then min_x=x2+reagirl.MoveItAllRight end
      if x2+w2+reagirl.MoveItAllRight>=max_x then max_x=x2+w2+reagirl.MoveItAllRight end
    end
    if reagirl.Elements[i].sticky_y==false then
      if y2+reagirl.MoveItAllUp<=min_y then min_y=y2+reagirl.MoveItAllUp end
      if y2+h2+reagirl.MoveItAllUp>=max_y then max_y=y2+h2+reagirl.MoveItAllUp end
    end
  end
  return min_x, max_x, min_y, max_y
end

function reagirl.UI_Element_GetType(element_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetType</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>string ui_type = reagirl.UI_Element_GetType(string element_id)</functioncall>
  <description>
    returns the type of the ui-element
  </description>
  <retvals>
    string ui_type - the type of the ui-element, like "Button", "Image", "Checkbox", "DropDownMenu", etc
  </retvals>
  <parameters>
    string element_id - the id of the element, whose type you want to get
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, get, type, ui-elements</tags>
</US_DocBloc>
]]
  if type(element_id)~="string" then error("UI_Element_GetType: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_GetType: #1 - no such ui-element", 2) end
  if reagirl.Elements[element_id]==nil then error("UI_Element_GetType: #1 - no such ui-element", 2) end
  if reagirl.Elements[element_id]~=nil then
    return reagirl.Elements[element_id]["GUI_Element_Type"]
  end
end

function reagirl.UI_Element_GetSetDescription(element_id, is_set, description)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetSetDescription</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>string ui_type = reagirl.UI_Element_GetSetDescription(string element_id, boolean is_set, string description)</functioncall>
  <description>
    gets/sets the description of the ui-element
  </description>
  <retvals>
    string description - the description of the ui-element
  </retvals>
  <parameters>
    string element_id - the id of the element, whose description you want to get/set
    boolean is_set - true, set the description; false, don't set the description
    string description - the description of the ui-element
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, get, description, ui-elements</tags>
</US_DocBloc>
]]
  if type(element_id)~="string" then error("UI_Element_GetSetDescription: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_GetSetDescription: #1 - no such ui-element", 2) end
  if reagirl.Elements[element_id]==nil then error("UI_Element_GetSetDescription: #1 - no such ui-element", 2) end
  if type(is_set)~="boolean" then error("UI_Element_GetSetDescription: #2 - must be a boolean", 2) end
  if is_set==true and type(description)~="string" then error("UI_Element_GetSetDescription: #3 - must be a string when #2==true", 2) end
  
  if is_set==true then
    reagirl.Elements[element_id]["Description"]=description
  end
  return reagirl.Elements[element_id]["Description"]
end

function reagirl.UI_Element_GetSetName(element_id, is_set, name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetSetName</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>string name = reagirl.UI_Element_GetSetName(string element_id, boolean is_set, string name)</functioncall>
  <description>
    gets/sets the name of the ui-element
  </description>
  <retvals>
    string name - the name of the ui-element
  </retvals>
  <parameters>
    string element_id - the id of the element, whose name you want to get/set
    boolean is_set - true, set the name; false, don't set the name
    string name - the name of the ui-element
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, get, name, ui-elements</tags>
</US_DocBloc>
]]
  if type(element_id)~="string" then error("UI_Element_GetSetName: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_GetSetName: #1 - no such ui-element", 2) end
  if reagirl.Elements[element_id]==nil then error("UI_Element_GetSetName: #1 - no such ui-element", 2) end
  if type(is_set)~="boolean" then error("UI_Element_GetSetName: #2 - must be a boolean", 2) end
  if is_set==true and type(name)~="string" then error("UI_Element_GetSetName: #3 - must be a string when #2==true", 2) end
  
  if is_set==true then
    reagirl.Elements[element_id]["Name"]=name
  end
  return reagirl.Elements[element_id]["Name"]
end

function reagirl.UI_Element_GetSetSticky(element_id, is_set, sticky_x, sticky_y)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetSetSticky</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>boolean sticky_x, boolean sticky_y = reagirl.UI_Element_GetSetSticky(string element_id, boolean is_set, boolean sticky_x, boolean sticky_y)</functioncall>
  <description>
    gets/sets the stickyness of the ui-element.
    
    Sticky-elements will not be moved by the global scrollbar-scrolling.
  </description>
  <retvals>
    boolean sticky_x - true, x-movement is sticky; false, x-movement isn't sticky
    boolean sticky_y - true, y-movement is sticky; false, y-movement isn't sticky
  </retvals>
  <parameters>
    string element_id - the id of the element, whose stickiness you want to get/set
    boolean is_set - true, set the name; false, don't set the stickiness
    boolean sticky_x - true, x-movement is sticky; false, x-movement isn't sticky
    boolean sticky_y - true, y-movement is sticky; false, y-movement isn't sticky
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, get, sticky, ui-elements</tags>
</US_DocBloc>
]]
  if type(element_id)~="string" then error("UI_Element_GetSetSticky: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_GetSetSticky: #1 - no such ui-element", 2) end
  if reagirl.Elements[element_id]==nil then error("UI_Element_GetSetSticky: #1 - no such ui-element", 2) end
  if type(is_set)~="boolean" then error("UI_Element_GetSetSticky: #2 - must be a boolean", 2) end
  if type(sticky_x)~="boolean" then error("UI_Element_GetSetSticky: #3 - must be a boolean", 2) end
  if type(sticky_y)~="boolean" then error("UI_Element_GetSetSticky: #4 - must be a boolean", 2) end
  
  if is_set==true then
    reagirl.Elements[element_id]["sticky_x"]=sticky_x
    reagirl.Elements[element_id]["sticky_y"]=sticky_y
  end
  return reagirl.Elements[element_id]["sticky_x"], reagirl.Elements[element_id]["sticky_y"]
end

function reagirl.UI_Element_GetSetAccessibilityHint(element_id, is_set, accessibility_hint)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetSetAccessibilityHint</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>string accessibility_hint = reagirl.UI_Element_GetSetAccessibilityHint(string element_id, boolean is_set, string accessibility_hint)</functioncall>
  <description>
    gets/sets the accessibility_hint of the ui-element, which will describe, how to use the ui-element to blind persons.
  </description>
  <retvals>
    string accessibility_hint - the accessibility_hint of the ui-element
  </retvals>
  <parameters>
    string element_id - the id of the element, whose accessibility_hint you want to get/set
    boolean is_set - true, set the accessibility_hint; false, don't set the accessibility-hint
    string accessibility_hint - the accessibility_hint of the ui-element
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, get, accessibility_hint, ui-elements</tags>
</US_DocBloc>
]]
  if type(element_id)~="string" then error("UI_Element_GetSetAccessibilityHint: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_GetSetAccessibilityHint: #1 - no such ui-element", 2) end
  if reagirl.Elements[element_id]==nil then error("UI_Element_GetSetAccessibilityHint: #1 - no such ui-element", 2) end
  if type(is_set)~="boolean" then error("UI_Element_GetSetAccessibilityHint: #2 - must be a boolean", 2) end
  if is_set==true and type(accessibility_hint)~="string" then error("UI_Element_GetSetAccessibilityHint: #3 - must be a string when #2==true", 2) end
  
  if is_set==true then
    reagirl.Elements[element_id]["AccHint"]=accessibility_hint
  end
  return reagirl.Elements[element_id]["AccHint"]
end

function reagirl.UI_Element_GetSetPosition(element_id, is_set, x, y)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetSetPosition</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>integer x, integer y, integer true_x, integer true_y = reagirl.UI_Element_GetSetPosition(string element_id, boolean is_set, integer x, integer y)</functioncall>
  <description>
    gets/sets the position of the ui-element
  </description>
  <retvals>
    integer x - the x-position of the ui-element
    integer y - the y-position of the ui-element
    integer true_x - the true current x-position resolved to the anchor-position
    integer true_y - the true current y-position resolved to the anchor-position
  </retvals>
  <parameters>
    string element_id - the id of the element, whose position you want to get/set
    boolean is_set - true, set the position; false, don't set the position
    integer x - the x-position of the ui-element
    integer y - the y-position of the ui-element
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, get, position, ui-elements</tags>
</US_DocBloc>
]]
  if type(element_id)~="string" then error("UI_Element_GetSetPosition: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_GetSetPosition: #1 - no such ui-element", 2) end
  if reagirl.Elements[element_id]==nil then error("UI_Element_GetSetPosition: #1 - no such ui-element", 2) end
  if type(is_set)~="boolean" then error("UI_Element_GetSetPosition: #2 - must be a boolean", 2) end
  if is_set==true and math.type(x)~="integer" then error("UI_Element_GetSetPosition: #3 - must be an integer when is_set==true", 2) end
  if is_set==true and math.type(y)~="integer" then error("UI_Element_GetSetPosition: #4 - must be an integer when is_set==true", 2) end
  
  if is_set==true then
    reagirl.Elements[element_id]["x"]=x
    reagirl.Elements[element_id]["y"]=y
  end
  local x2, y2
  if reagirl.Elements[element_id]["x"]<0 then x2=gfx.w+reagirl.Elements[element_id]["x"] else x2=reagirl.Elements[element_id]["x"] end
  if reagirl.Elements[element_id]["y"]<0 then y2=gfx.h+reagirl.Elements[element_id]["y"] else y2=reagirl.Elements[element_id]["y"] end
  
  return reagirl.Elements[element_id]["x"], reagirl.Elements[element_id]["y"], x2, y2
end

function reagirl.UI_Element_GetSetDimension(element_id, is_set, w, h)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetSetDimension</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>integer w, integer h, integer true_w, integer true_h = reagirl.UI_Element_GetSetDimension(string element_id, boolean is_set, integer w, integer h)</functioncall>
  <description>
    gets/sets the position of the ui-element
  </description>
  <retvals>
    integer w - the w-size of the ui-element
    integer h - the h-size of the ui-element
    integer true_w - the true current w-size resolved to the anchor-position
    integer true_h - the true current h-size resolved to the anchor-position
  </retvals>
  <parameters>
    string element_id - the id of the element, whose dimension you want to get/set
    boolean is_set - true, set the dimension; false, don't set the dimension
    integer w - the w-size of the ui-element
    integer h - the h-size of the ui-element
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, get, dimension, ui-elements</tags>
</US_DocBloc>
]]
  if type(element_id)~="string" then error("UI_Element_GetSetDimension: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_GetSetDimension: #1 - no such ui-element", 2) end
  if reagirl.Elements[element_id]==nil then error("UI_Element_GetSetDimension: #1 - no such ui-element", 2) end
  if type(is_set)~="boolean" then error("UI_Element_GetSetDimension: #2 - must be a boolean", 2) end
  if is_set==true and math.type(w)~="integer" then error("UI_Element_GetSetDimension: #3 - must be an integer when is_set==true", 2) end
  if is_set==true and math.type(h)~="integer" then error("UI_Element_GetSetDimension: #4 - must be an integer when is_set==true", 2) end
  
  local w2, h2, x2, y2
  if reagirl.Elements[element_id]["x"]<0 then x2=gfx.w+reagirl.Elements[element_id]["x"] else x2=reagirl.Elements[element_id]["x"] end
  if reagirl.Elements[element_id]["y"]<0 then y2=gfx.h+reagirl.Elements[element_id]["y"] else y2=reagirl.Elements[element_id]["y"] end
  if reagirl.Elements[element_id]["w"]<0 then w2=gfx.w-x2+reagirl.Elements[element_id]["w"] else w2=w end
  if reagirl.Elements[element_id]["h"]<0 then h2=gfx.h-y2+reagirl.Elements[element_id]["h"] else h2=h end
  
  if is_set==true then
    reagirl.Elements[element_id]["w"]=w
    reagirl.Elements[element_id]["h"]=h
  end
          
  return reagirl.Elements[element_id]["w"], reagirl.Elements[element_id]["h"], w2, h2
end


function reagirl.UI_Element_GetSetAllHorizontalOffset(is_set, x_offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetSetAllHorizontalOffset</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>integer x_offset = reagirl.UI_Element_GetSetAllHorizontalOffset(boolean is_set, integer x_offset)</functioncall>
  <description>
    gets/sets the horizontal offset of all non-sticky ui-elements
  </description>
  <retvals>
    integer x_offset - the current horizontal offset of all ui-elements
  </retvals>
  <parameters>
    boolean is_set - true, set the horizontal-offset; false, don't set the horizontal-offset
    integer x_offset - the x-offset of all ui-elements
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, get, horizontal offset, ui-elements</tags>
</US_DocBloc>
]]
  if type(is_set)~="boolean" then error("UI_Element_GetSetAllHorizontalOffset: #2 - must be a boolean", 2) end
  if is_set==true and math.type(x_offset)~="integer" then error("UI_Element_GetSetAllHorizontalOffset: #3 - must be an integer when is_set==true", 2) end
  
  if is_set==true then reagirl.MoveItAllRight=x_offset end
  return reagirl.MoveItAllRight
end

function reagirl.UI_Element_GetSetAllVerticalOffset(is_set, y_offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetSetAllVerticalOffset</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>integer y_offset = reagirl.UI_Element_GetSetAllVerticalOffset(boolean is_set, integer y_offset)</functioncall>
  <description>
    gets/sets the vertical offset of all ui-elements
  </description>
  <retvals>
    integer y_offset - the current vertical offset of all non-sticky ui-elements
  </retvals>
  <parameters>
    boolean is_set - true, set the vertical-offset; false, don't set the vertical-offset
    integer y_offset - the y-offset of all ui-elements
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, get, vertical offset, ui-elements</tags>
</US_DocBloc>
]]
  if type(is_set)~="boolean" then error("UI_Element_GetSetAllVerticalOffset: #2 - must be a boolean", 2) end
  if is_set==true and math.type(y_offset)~="integer" then error("UI_Element_GetSetAllVerticalOffset: #3 - must be an integer when is_set==true", 2) end
  
  if is_set==true then reagirl.MoveItAllUp=y_offset end
  return reagirl.MoveItAllUp
end

function reagirl.UI_Element_GetSetRunFunction(element_id, is_set, run_function)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UI_Element_GetSetRunFunction</slug>
  <requires>
    ReaGirl=1.0
    Reaper=6.75
    Lua=5.3
  </requires>
  <functioncall>func run_function = reagirl.UI_Element_GetSetRunFunction(string element_id, boolean is_set, func run_function)</functioncall>
  <description>
    gets/sets the run_function of the ui-element, which will be run, when the ui-element is toggled
  </description>
  <retvals>
    func run_function - the run_function of the ui-element
  </retvals>
  <parameters>
    string element_id - the id of the element, whose run_function you want to get/set
    boolean is_set - true, set the run_function; false, don't set the name
    func run_function - the run function of the ui-element
  </parameters>
  <chapter_context>
    UI Elements
  </chapter_context>
  <target_document>ReaGirl_Docs</target_document>
  <source_document>reagirl_GuiEngine.lua</source_document>
  <tags>gfx, functions, set, get, run function, ui-elements</tags>
</US_DocBloc>
]]
  if type(element_id)~="string" then error("UI_Element_GetSetRunFunction: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_GetSetRunFunction: #1 - no such ui-element", 2) end
  if reagirl.Elements[element_id]==nil then error("UI_Element_GetSetRunFunction: #1 - no such ui-element", 2) end
  if type(is_set)~="boolean" then error("UI_Element_GetSetRunFunction: #2 - must be a boolean", 2) end
  if is_set==true and type(run_function)~="function" then error("UI_Element_GetSetRunFunction: #3 - must be a function, when #2==true", 2) end
  
  if is_set==true then
    reagirl.Elements[element_id]["run_function"]=run_function
  end
  return reagirl.Elements[element_id]["run_function"]
end

function reagirl.UI_Element_Move(element_id, x, y, w, h)
  if type(element_id)~="string" then error("UI_Element_Move: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_Move: #1 - no such ui-element", 2) end
  if x~=nil and math.type(x)~="integer" then error("UI_Element_Move: param #2 - must be an integer", 2) end
  if y~=nil and math.type(y)~="integer" then error("UI_Element_Move: param #3 - must be an integer", 2) end
  if w~=nil and math.type(w)~="integer" then error("UI_Element_Move: param #4 - must be an integer", 2) end
  if h~=nil and math.type(h)~="integer" then error("UI_Element_Move: param #5 - must be an integer", 2) end
  if element_id<1 or element_id>#reagirl.Elements then error("UI_Element_Move: param #1 - no such UI-element", 2) end
  if x~=nil then reagirl.Elements[element_id]["x"]=x end
  if y~=nil then reagirl.Elements[element_id]["y"]=y end
  if w~=nil then reagirl.Elements[element_id]["w"]=w end
  if h~=nil then reagirl.Elements[element_id]["h"]=h end
  if element_id==reagirl.Elements["FocusedElement"] then
    reagirl.oldselection=-1
  end
  reagirl.Gui_ForceRefresh(8)
end

function reagirl.UI_Element_SetSelected(element_id)
  if type(element_id)~="string" then error("UI_Element_SetSelected: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_SetSelected: #1 - no such ui-element", 2) end
  
  reagirl.Elements["FocusedElement"]=element_id
  reagirl.Gui_ForceRefresh(9)
end

function reagirl.UI_Element_Remove(element_id)
  if type(element_id)~="string" then error("UI_Element_SetSelected: #1 - must be a guid as string", 2) end
  element_id=reagirl.UI_Element_GetIDFromGuid(element_id)
  if element_id==nil then error("UI_Element_SetSelected: #1 - no such ui-element", 2) end
  table.remove(reagirl.Elements, element_id)
  if element_id<=reagirl.Elements["FocusedElement"] then
    reagirl.Elements["FocusedElement"]=reagirl.Elements["FocusedElement"]-1
  end
  if reagirl.Elements["FocusedElement"]>#reagirl.Elements then
    reagirl.Elements["FocusedElement"]=#reagirl.Elements
  end
  if reagirl.Elements["FocusedElement"]>0 then 
    reagirl.UI_Element_SetFocusRect(reagirl.Elements[reagirl.Elements["FocusedElement"]]["x"], 
                                    reagirl.Elements[reagirl.Elements["FocusedElement"]]["y"], 
                                    reagirl.Elements[reagirl.Elements["FocusedElement"]]["w"], 
                                    reagirl.Elements[reagirl.Elements["FocusedElement"]]["h"]
                                    )
  end
  reagirl.Gui_ForceRefresh(10)
end

function reagirl.UI_Element_GetIDFromGuid(guid)
  for i=1, #reagirl.Elements do
    if guid==reagirl.Elements[i]["Guid"] then return i end
  end
end

function reagirl.UI_Element_GetGuidFromID(id)
  return reagirl.Elements[id]["Guid"]
end

function reagirl.Gui_Draw(Key, Key_utf, clickstate, specific_clickstate, mouse_cap, click_x, click_y, drag_x, drag_y, mouse_wheel, mouse_hwheel)
  -- no docs in API-docs
  local selected, x2, y2
  
  
  if reagirl.Gui_ForceRefreshState==true then
    gfx.set(reagirl["WindowBackgroundColorR"],reagirl["WindowBackgroundColorG"],reagirl["WindowBackgroundColorB"])
    gfx.rect(0,0,gfx.w,gfx.h,1)
    reagirl.Background_DrawImage()

    for i=1, #reagirl.Elements, 1 do
      local x2, y2, w2, h2
      if reagirl.Elements[i]["x"]<0 then x2=gfx.w+reagirl.Elements[i]["x"] else x2=reagirl.Elements[i]["x"] end
      if reagirl.Elements[i]["y"]<0 then y2=gfx.h+reagirl.Elements[i]["y"] else y2=reagirl.Elements[i]["y"] end
      if reagirl.Elements[i]["w"]<0 then w2=gfx.w-x2+reagirl.Elements[i]["w"] else w2=reagirl.Elements[i]["w"] end
      if reagirl.Elements[i]["h"]<0 then h2=gfx.h-y2+reagirl.Elements[i]["h"] else h2=reagirl.Elements[i]["h"] end

      local MoveItAllUp=reagirl.MoveItAllUp  
      local MoveItAllRight=reagirl.MoveItAllRight
      if reagirl.Elements[i]["sticky_y"]==true then MoveItAllUp=0 end
      if reagirl.Elements[i]["sticky_x"]==true then MoveItAllRight=0 end
      
      if (x2+MoveItAllRight>=0 and x2+MoveItAllRight<=gfx.w) or (y2+MoveItAllUp>=0 and y2+MoveItAllUp<=gfx.h) or (x2+MoveItAllRight+w2>=0 and x2+MoveItAllRight+w2<=gfx.w) or (y2+MoveItAllUp+h2>=0 and y2+MoveItAllUp+h2<=gfx.h) then
        local message=reagirl.Elements[i]["func_draw"](i, reagirl.Elements["FocusedElement"]==i,
          specific_clickstate,
          gfx.mouse_cap,
          {click_x, click_y, drag_x, drag_y, mouse_wheel, mouse_hwheel},
          reagirl.Elements[i]["Name"],
          reagirl.Elements[i]["Description"], 
          x2+MoveItAllRight,
          y2+MoveItAllUp,
          w2,
          h2,
          Key,
          Key_utf,
          reagirl.Elements[i]
        )
      end
      if reagirl.Elements["FocusedElement"]==i then
        if reagirl.Elements[i]["GUI_Element_Type"]=="DropDownMenu" then
        --  if w2<20 then w2=20 end
        end
        local r,g,b,a=gfx.r,gfx.g,gfx.b,gfx.a
        local dest=gfx.dest
        gfx.dest=-1
        gfx.set(0.7,0.7,0.7,0.8)
        local _,_,_,_,x,y,w,h=reagirl.UI_Element_GetFocusRect()
        gfx.rect(x+MoveItAllRight-2,y+MoveItAllUp-2,w+4,h+3,0)
        gfx.set(r,g,b,a)
        gfx.dest=dest
        if reaper.osara_outputMessage~=nil and reagirl.oldselection~=i then
        
          reagirl.oldselection=i
          if reaper.JS_Mouse_SetPosition~=nil then 
            --reagirl.UI_Element_ScrollToUIElement(reagirl.Elements[reagirl.Elements["FocusedElement"]].Guid) -- buggy, should scroll to ui-element...
            reaper.JS_Mouse_SetPosition(gfx.clienttoscreen(x2+MoveItAllRight+4,y2+MoveItAllUp+4)) 
          end
        end
      end
    end
  end
  reagirl.Gui_ForceRefreshState=false
  
end

function reagirl.AddDummyElement()  
  reagirl.Elements[#reagirl.Elements+1]={}
  reagirl.Elements[#reagirl.Elements]["Guid"]=reaper.genGuid("")
  reagirl.Elements[#reagirl.Elements]["GUI_Element_Type"]="Dummy"
  reagirl.Elements[#reagirl.Elements]["Name"]="Dummy"
  reagirl.Elements[#reagirl.Elements]["Text"]="Dummy"
  reagirl.Elements[#reagirl.Elements]["Description"]="Description"
  reagirl.Elements[#reagirl.Elements]["AccHint"]="Dummy Dummy Dummy, it's so flummy. In a rich mans world."
  reagirl.Elements[#reagirl.Elements]["x"]=math.random(140)
  reagirl.Elements[#reagirl.Elements]["y"]=math.random(140)
  reagirl.Elements[#reagirl.Elements]["w"]=math.random(40)
  reagirl.Elements[#reagirl.Elements]["h"]=math.random(40)
  reagirl.Elements[#reagirl.Elements]["func_manage"]=reagirl.ManageDummyElement
  reagirl.Elements[#reagirl.Elements]["func_draw"]=reagirl.DrawDummyElement
  
  return #reagirl.Elements
end

function reagirl.ManageDummyElement(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF)
    if selected==true then
      if Key==1919379572.0 then
        --print2("")
        local x,y,w,h
        x,y,w,h=reagirl.UI_Element_GetFocusRect()
        reagirl.UI_Element_SetFocusRect(x+10,y,-10,-10)
      elseif Key==1818584692.0 then
        local x,y,w,h
        x,y,w,h=reagirl.UI_Element_GetFocusRect()
        reagirl.UI_Element_SetFocusRect(x-10,y,-10,-10)
      end
    end
  return "", true
end

function reagirl.DrawDummyElement(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF)
  -- no docs in API-docs
  local message
  gfx.set(1)
  --gfx.rect(x,y,w,h,1)
  
  if selected==true then
    gfx.set(0.5)
    --gfx.rect(x,y,w,h,0)
    --reagirl.UI_Element_SetFocusRect(10, 10, 20, 50)
    if selected==true then
      message="Dummy Element "..description.." focused"..element_id
      C=clicked
    else
      --message=""
    end
    if mouse_cap==1 and clicked==true then
      message="Dummy Element "..description.." clicked"..element_id
      
    elseif mouse_cap==2 and clicked==true then
      gfx.showmenu("Huch|Tuch|Much")
      --message=""
    end
  end
  
  if Key~=0 then message=Key_Utf end

  gfx.x=x
  gfx.y=y
  gfx.set(0)
  gfx.drawstr(element_id)
  
  return "HUCH", true
end

function reagirl.CheckBox_Add(x, y, Name, MeaningOfUI_Element, default, run_function)
  local tx,ty=gfx.measurestr(Name)
  local slot=reagirl.UI_Element_GetNextFreeSlot()
  table.insert(reagirl.Elements, slot, {})
  reagirl.Elements[slot]["Guid"]=reaper.genGuid("")
  reagirl.Elements[slot]["GUI_Element_Type"]="Checkbox"
  reagirl.Elements[slot]["Name"]=Name
  reagirl.Elements[slot]["Text"]=Name
  reagirl.Elements[slot]["IsDecorative"]=false
  reagirl.Elements[slot]["Description"]=MeaningOfUI_Element
  reagirl.Elements[slot]["AccHint"]="Change checkstate with space or left mouse-click."
  reagirl.Elements[slot]["x"]=x
  reagirl.Elements[slot]["y"]=y
  reagirl.Elements[slot]["w"]=math.tointeger(gfx.texth+tx+4)
  reagirl.Elements[slot]["h"]=math.tointeger(gfx.texth)
  reagirl.Elements[slot]["sticky_x"]=false
  reagirl.Elements[slot]["sticky_y"]=false
  reagirl.Elements[slot]["checked"]=default
  reagirl.Elements[slot]["func_manage"]=reagirl.Checkbox_Manage
  reagirl.Elements[slot]["func_draw"]=reagirl.CheckBox_Draw
  reagirl.Elements[slot]["run_function"]=run_function
  reagirl.Elements[slot]["userspace"]={}
  return  reagirl.Elements[slot]["Guid"]
end

function reagirl.Checkbox_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  local refresh=false

  if selected==true and ((clicked=="FirstCLK" and mouse_cap&1==1) or Key==32) then 
    if (gfx.mouse_x>=x 
      and gfx.mouse_x<=x+w 
      and gfx.mouse_y>=y 
      and gfx.mouse_y<=y+h) 
      or Key==32 then
      if reagirl.Elements[element_id]["checked"]==true then 
        reagirl.Elements[element_id]["checked"]=false 
        element_storage["run_function"](element_id, reagirl.Elements[element_id]["checked"])
        refresh=true
      else 
        reagirl.Elements[element_id]["checked"]=true 
        element_storage["run_function"](element_id, reagirl.Elements[element_id]["checked"])
        refresh=true
      end
    end
  end
  if reagirl.Elements[element_id]["checked"]==true then
    return "checked. ", refresh
  else
    return " unchecked. ", refresh
  end
end

function reagirl.CheckBox_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  gfx.x=x
  gfx.y=y
  gfx.set(0.39)
  gfx.rect(x+1,y+1,h,h,0)
  gfx.set(0.784)
  gfx.rect(x,y,h,h,0)
  
  if reagirl.Elements[element_id]["checked"]==true then
    gfx.set(0.4843137254901961, 0.5156862745098039, 0)
    gfx.rect(x+2,y+2,h-3,h-3,1)
    
    gfx.set(0.9843137254901961, 0.8156862745098039, 0)
    gfx.rect(x+2,y+2,h-4,h-4,1)
  end
  gfx.set(0.3)
  gfx.x=x+h+3+3
  gfx.y=y+1
  gfx.drawstr(name)
  gfx.set(1)
  gfx.x=x+h+2+3
  gfx.y=y
  gfx.drawstr(name)
end


function reagirl.Button_Add(x, y, w_margin, h_margin, Caption, MeaningOfUI_Element, run_function)
  local tx,ty=gfx.measurestr(Caption)
  local slot=reagirl.UI_Element_GetNextFreeSlot()
  table.insert(reagirl.Elements, slot, {})
  reagirl.Elements[slot]["Guid"]=reaper.genGuid("")
  reagirl.Elements[slot]["GUI_Element_Type"]="Button"
  reagirl.Elements[slot]["Name"]=Caption
  reagirl.Elements[slot]["Text"]=Caption
  reagirl.Elements[slot]["IsDecorative"]=false
  reagirl.Elements[slot]["sticky_x"]=false
  reagirl.Elements[slot]["sticky_y"]=false
  reagirl.Elements[slot]["Description"]=MeaningOfUI_Element
  reagirl.Elements[slot]["AccHint"]="click with space or left mouseclick"
  reagirl.Elements[slot]["x"]=x
  reagirl.Elements[slot]["y"]=y
  reagirl.Elements[slot]["w"]=math.tointeger(tx+20+w_margin)
  reagirl.Elements[slot]["h"]=math.tointeger(ty+10+h_margin)
  reagirl.Elements[slot]["func_manage"]=reagirl.Button_Manage
  reagirl.Elements[slot]["func_draw"]=reagirl.Button_Draw
  reagirl.Elements[slot]["run_function"]=run_function
  reagirl.Elements[slot]["userspace"]={}
  return reagirl.Elements[slot]["Guid"]
end

function reagirl.Button_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  local message=" "
  if element_storage["old_selected"]~=true and selected==true then 
    message=" "
  end
  element_storage["old_selected"]=selected
  local refresh=false
  local oldpressed=element_storage["pressed"]

  if selected==true and Key==32 then 
    element_storage["pressed"]=true
    message=" pressed"
  elseif selected==true and mouse_cap&1~=0 and gfx.mouse_x>x and gfx.mouse_y>y and gfx.mouse_x<x+w and gfx.mouse_y<y+h then
    element_storage["pressed"]=true
    message=" pressed"
  else
    element_storage["pressed"]=false
  end
  if oldpressed==true and element_storage["pressed"]==false and (mouse_cap&1==0 and Key~=32) then
    element_storage["run_function"](element_storage["Guid"])
  end

  return message, oldpressed~=element_storage["pressed"]
end

function reagirl.Button_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  x=x+1
  y=y+1
  gfx.x=x
  gfx.y=y
  w=w-5
  h=h-5
  local dpi_scale, state
  local sw,sh=gfx.measurestr(element_storage["Name"])
  if reagirl.Elements[element_id]["pressed"]==true then
    state=1
    dpi_scale=1
    gfx.set(0.06) -- background 1
    for i = 1, 1 do
      reagirl.RoundRect(x - i, y - i, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
      reagirl.RoundRect(x + i, y + i, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
    end
    reagirl.RoundRect(x , y - 2 * dpi_scale, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
    
    gfx.set(0.39) -- background 2
    reagirl.RoundRect(x , y - 1 * dpi_scale, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
    
    gfx.set(0.274) -- button-area
    reagirl.RoundRect(x + 1 * state, y + 1 * state, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
    
    gfx.x=x+(w-sw)/2+1
    local offset=0
    if reaper.GetOS():match("OS")~=nil then offset=1 end
    gfx.y=y+(h-sh)/2+1+offset
    gfx.set(0.784)
    gfx.drawstr(element_storage["Name"])
  else
    state=0
    dpi_scale=1
    gfx.set(0.06) -- background 1
    for i = 1, 1 do
      reagirl.RoundRect(x - i, y - i, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
      reagirl.RoundRect(x + i, y + i, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
    end
    reagirl.RoundRect(x , y - 2 * dpi_scale, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
    
    gfx.set(0.39) -- background 2
    reagirl.RoundRect(x , y - 1 * dpi_scale, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
    
    gfx.set(0.274) -- button-area
    reagirl.RoundRect(x + 1 * state, y + 1 * state, w, h, 4 * dpi_scale, 1 * dpi_scale, 1 * dpi_scale)
    
    gfx.x=x+(w-sw)/2
    local offset=0
    if reaper.GetOS():match("OS")~=nil then offset=1 end
    gfx.y=y+(h-sh)/2+offset
    gfx.set(0.784)
    gfx.drawstr(element_storage["Name"])
  end
  gfx.set(0.3)
  gfx.x=x+h+3
  gfx.y=y+1
  --gfx.drawstr(name)
  gfx.set(1)
  gfx.x=x+h+2
  gfx.y=y
  --gfx.drawstr(name)
end
--gfx.setfont(



function reagirl.InputBox_Add(x, y, w, Name, MeaningOfUI_Element, Default, run_function_enter, run_function_type)
  local tx,ty=gfx.measurestr(Name)
  local slot=reagirl.UI_Element_GetNextFreeSlot()
  table.insert(reagirl.Elements, slot, {})
  reagirl.Elements[slot]["Guid"]=reaper.genGuid("")
  reagirl.Elements[slot]["GUI_Element_Type"]="Edit"
  reagirl.Elements[slot]["Name"]=""
  reagirl.Elements[slot]["Label"]=Name
  reagirl.Elements[slot]["Description"]=MeaningOfUI_Element
  reagirl.Elements[slot]["IsDecorative"]=false
  reagirl.Elements[slot]["AccHint"]="Hit Enter to type text."
  reagirl.Elements[slot]["x"]=x
  reagirl.Elements[slot]["y"]=y
  reagirl.Elements[slot]["w"]=w
  reagirl.Elements[slot]["h"]=math.tointeger(gfx.texth)
  reagirl.Elements[slot]["sticky_x"]=false
  reagirl.Elements[slot]["sticky_y"]=false
  reagirl.Elements[slot]["Text"]=Default
  reagirl.Elements[slot]["draw_range_max"]=10
  reagirl.Elements[slot]["draw_offset"]=0
  reagirl.Elements[slot]["cursor_offset"]=0
  reagirl.Elements[slot]["selection_start"]=1
  reagirl.Elements[slot]["selection_end"]=1
  
  reagirl.Elements[slot]["func_manage"]=reagirl.InputBox_Manage
  reagirl.Elements[slot]["func_draw"]=reagirl.InputBox_Draw
  reagirl.Elements[slot]["run_function"]=run_function_enter
  reagirl.Elements[slot]["run_function_type"]=run_function_type
  reagirl.Elements[slot]["userspace"]={}
  return reagirl.Elements[slot]["Guid"]
end

function reagirl.InputBox_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if (selected==true and Key==13) or (gfx.mouse_x>=x and gfx.mouse_x<=x+w and gfx.mouse_y>=y and gfx.mouse_y<=y+h and clicked=="FirstCLK") then
    retval, text = reaper.GetUserInputs(element_storage["Name"].." Enter new value", 1, "", element_storage["Text"])
    if retval==true then element_storage["Text"]=text end
    reagirl.Gui_ForceRefresh(11)
  end
  return element_storage["Text"]
end

function reagirl.InputBox_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  -- Testcode
  --gfx.setfont(1,"Calibri", 20)
  --gfx.setfont(1,"Consolas", 20)
  reagirl.SetFont(2, "Consolas", reagirl.Font_Size, 0)
  --reagirl.Elements[element_id]["Text"]
  local cursor_offset=element_storage["cursor_offset"]
  local draw_offset=element_storage["draw_offset"]
  local draw_range_max=element_storage["draw_range_max"]
  local selection_start=element_storage["selection_start"]
  local selection_end=element_storage["selection_end"]
  gfx.x=x
  gfx.y=y
  --
  -- rectangle-stuff
  gfx.set(0.2)
  gfx.rect(x-2,y-3,gfx.measurechar(65)*(element_storage["draw_range_max"]+1)+4, gfx.texth+6, 1)
  gfx.set(0.6)
  gfx.rect(x-2,y-3,gfx.measurechar(65)*(element_storage["draw_range_max"]+1)+4, gfx.texth+6, 0)
  gfx.set(1)
  gfx.rect(x-1,y-2,gfx.measurechar(65)*(element_storage["draw_range_max"]+1)+4, gfx.texth+6, 0)
  --]]
  
  if draw_offset+1<0 then draw_offset=1 end
  if cursor_offset==draw_offset then
    --gfx.line(gfx.x, gfx.y, gfx.x, gfx.y+gfx.texth)
  end
  
  --CAPO=0
  if draw_offset<=0 then draw_offset=0 end
  for i=draw_offset, draw_range_max+draw_offset+2 do
  --CAPO=CAPO+1
    --print(element_storage["Text"]:utf8_sub(i,i))
    if i>=selection_start+1 and i<=selection_end then
      --gfx.setfont(1, "Consolas", 20, 86) 
      reagirl.SetFont(2, "Consolas", reagirl.Font_Size, 86)
    elseif selection_start~=selection_end and i==selection_end+1 then 
      --gfx.setfont(1, "Consolas", 20, 0) 
      reagirl.SetFont(2, "Consolas", reagirl.Font_Size, 0)
    end
    gfx.drawstr(element_storage["Text"]:utf8_sub(i,i))
    --CAP_STRING=CAP_STRING..element_storage["Text"]:utf8_sub(i,i)
    if cursor_offset==i then
      gfx.set(0.6)
      gfx.line(gfx.x, gfx.y, gfx.x, gfx.y+gfx.texth)
      if reaper.osara_outputMessage==nil then
        gfx.set(1)
        gfx.line(gfx.x+1, gfx.y+1, gfx.x+1, gfx.y+1+gfx.texth)
      end
    end
  end
  --reagirl.SetFont(1, "Arial", 16, 0)
  reagirl.SetFont(1, "Arial", reagirl.Font_Size, 0)
end

function reagirl.DropDownMenu_Add(x, y, w, Name, MeaningOfUI_Element, default, MenuEntries, run_function)
  local tx,ty=gfx.measurestr(Name)
  local slot=reagirl.UI_Element_GetNextFreeSlot()
  table.insert(reagirl.Elements, slot, {})
  reagirl.Elements[slot]["Guid"]=reaper.genGuid("")
  reagirl.Elements[slot]["GUI_Element_Type"]="DropDownMenu"
  reagirl.Elements[slot]["Name"]=Name
  reagirl.Elements[slot]["Text"]=MenuEntries[default]
  reagirl.Elements[slot]["Description"]=MeaningOfUI_Element
  reagirl.Elements[slot]["IsDecorative"]=false
  reagirl.Elements[slot]["AccHint"]="Select via arrow-keys."
  reagirl.Elements[slot]["x"]=x
  reagirl.Elements[slot]["y"]=y
  reagirl.Elements[slot]["w"]=w
  reagirl.Elements[slot]["h"]=math.tointeger(gfx.texth)
  reagirl.Elements[slot]["sticky_x"]=false
  reagirl.Elements[slot]["sticky_y"]=false
  reagirl.Elements[slot]["MenuDefault"]=default
  reagirl.Elements[slot]["MenuEntries"]=MenuEntries
  reagirl.Elements[slot]["func_manage"]=reagirl.DropDownMenu_Manage
  reagirl.Elements[slot]["func_draw"]=reagirl.DropDownMenu_Draw
  reagirl.Elements[slot]["run_function"]=run_function
  reagirl.Elements[slot]["userspace"]={}
  return  reagirl.Elements[slot]["Guid"]
end


function reagirl.DropDownMenu_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  local Entries=""
  local Default, insert
  local refresh=false
  for i=1, #element_storage["MenuEntries"] do
    if i==element_storage["MenuDefault"] then insert="!" else insert="" end
    Entries=Entries..insert..element_storage["MenuEntries"][i].."|"
  end
  
  if w<20 then w=20 end
  if selected==true and ((clicked=="FirstCLK" and mouse_cap&1==1) or Key==1685026670 or Key==30064) then 
    if (gfx.mouse_x>=x and gfx.mouse_x<=x+w and gfx.mouse_y>=y and gfx.mouse_y<=y+h) or Key==32 then
      gfx.x=x
      gfx.y=y+gfx.texth
      local selection=gfx.showmenu(Entries:sub(1,-2))
      if selection>0 then
        reagirl.Elements[element_id]["MenuDefault"]=selection
        reagirl.Elements[element_id]["run_function"](element_id, selection, element_storage["MenuEntries"][selection])
        reagirl.Elements[element_id]["Text"]=element_storage["MenuEntries"][selection]
        refresh=true
      end
    end
  end
  return element_storage["MenuEntries"][element_storage["MenuDefault"]]..". collapsed ", refresh
end

function reagirl.DropDownMenu_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  local offset=gfx.measurestr(name.." ")
  gfx.x=x
  gfx.y=y
  gfx.set(0.1)
  gfx.rect(x+1,y+1,w,h+1,0)
  gfx.set(1)
  gfx.rect(x,y,w,h+1,0)
  

  --gfx.triangle(x+w-gfx.texth, y, x+w+gfx.texth, y, x+w-1+gfx.texth/2+2, y+gfx.texth)
  --[[gfx.triangle(x+w,     y,
               x+w+41,   y,
               x+10, y+gfx.texth )
      --]]
  --gfx.x=x+w
  --gfx.y=y
  --gfx.setpixel(1,1,1)
  
  --gfx.x=x+w-gfx.texth
  --gfx.y=y
  --gfx.setpixel(1,0,1)
  
  --gfx.x=x+w-(gfx.texth/2)
  --gfx.y=y+gfx.texth
  --gfx.setpixel(1,0,1)
  
  gfx.triangle(x+w-4, y+4, x+w-gfx.texth+4, y+4, x+w-(gfx.texth/2), y+gfx.texth-4)
  gfx.line(x+w-gfx.texth+1, y, x+w-gfx.texth+1, y+gfx.texth)
  
  
      --gfx.line(x+gfx.texth+1, y+1, x+gfx.texth/2+1, y+1+gfx.texth)
  gfx.set(0.7)
  gfx.set(0.7)
      --gfx.line(x, y, x+gfx.texth/2, y+gfx.texth)
  --]]
  
  gfx.set(0.3)
  gfx.x=x+1+2+2
  gfx.y=y
  gfx.drawstr(element_storage["MenuEntries"][element_storage["MenuDefault"]],0,gfx.x+w-gfx.texth-5, gfx.y+gfx.texth)
  
  gfx.set(1)
  --gfx.line(x+gfx.texth,y,x+gfx.texth,y+gfx.texth)
  gfx.x=x+2+2
  gfx.y=y-1
  gfx.drawstr(element_storage["MenuEntries"][element_storage["MenuDefault"]],0,gfx.x+w-gfx.texth-5, gfx.y+gfx.texth)
  
end

function reagirl.Label_Add(label, x, y, align, MeaningOfUI_Element)
  --label=string.gsub(label, "\n", "")
  --label=string.gsub(label, "\r", "")
  
  local slot=reagirl.UI_Element_GetNextFreeSlot()
  table.insert(reagirl.Elements, slot, {})
  local w,h=gfx.measurestr(label)
  reagirl.Elements[slot]["Guid"]=reaper.genGuid("")
  reagirl.Elements[slot]["GUI_Element_Type"]="Label"
  reagirl.Elements[slot]["Name"]=label
  reagirl.Elements[slot]["Text"]=""
  reagirl.Elements[slot]["Description"]=MeaningOfUI_Element
  reagirl.Elements[slot]["IsDecorative"]=false
  reagirl.Elements[slot]["AccHint"]="Ctrl+C to copy text into clipboard"
  reagirl.Elements[slot]["x"]=x
  reagirl.Elements[slot]["y"]=y
  reagirl.Elements[slot]["w"]=math.tointeger(w)
  reagirl.Elements[slot]["sticky_x"]=false
  reagirl.Elements[slot]["sticky_y"]=false
  reagirl.Elements[slot]["h"]=math.tointeger(h)--math.tointeger(gfx.texth)
  reagirl.Elements[slot]["align"]=align
  reagirl.Elements[slot]["func_draw"]=reagirl.Label_Draw
  reagirl.Elements[slot]["run_function"]=reagirl.Dummy
  reagirl.Elements[slot]["func_manage"]=reagirl.Label_Manage
  
  return reagirl.Elements[slot]["Guid"]
end

function reagirl.Label_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if Key==3 then reaper.CF_SetClipboard(name) end
  if gfx.mouse_cap&2==2 and selected==true and gfx.mouse_x>=x and gfx.mouse_x<=x+w and gfx.mouse_y>=y and gfx.mouse_y<=y+h then
    local oldx, oldy=gfx.x, gfx.y
    gfx.x=gfx.mouse_x
    gfx.y=gfx.mouse_y
    --local selection=gfx.showmenu("Copy Text to Clipboard")
    gfx.x=oldx
    gfx.y=oldy
    if selection==1 then reaper.CF_SetClipboard(name) end
  end
  return " ", false
end

function reagirl.Label_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  -- BUG: with multiline-texts, when they scroll outside the top of the window, they disappear when the first line is outside of the window
  gfx.set(0.1)
  reagirl.BlitText_AdaptLineLength(name, 
                                   math.floor(x)+1, 
                                   math.floor(y)+2, 
                                   gfx.w,
                                   gfx.h,--gfx.texth,
                                   element_storage["align"])
  
  gfx.set(1,1,1)
  reagirl.BlitText_AdaptLineLength(name, 
                                   math.floor(x), 
                                   math.floor(y)+1, 
                                   gfx.w,
                                   gfx.h,--gfx.texth,
                                   element_storage["align"])
end

function reagirl.Rect_Add(x,y,w,h,r,g,b,a,filled)
  local slot=reagirl.UI_Element_GetNextFreeSlot()
  table.insert(reagirl.Elements, slot, {})
  reagirl.Elements[slot]["Guid"]=reaper.genGuid("")
  reagirl.Elements[slot]["GUI_Element_Type"]="Rectangle"
  reagirl.Elements[slot]["IsDecorative"]=true
  reagirl.Elements[slot]["AccHint"]=""
  reagirl.Elements[slot]["Description"]=""
  reagirl.Elements[slot]["Text"]=""
  reagirl.Elements[slot]["Name"]=""
  reagirl.Elements[slot]["x"]=x
  reagirl.Elements[slot]["y"]=y
  reagirl.Elements[slot]["w"]=w
  reagirl.Elements[slot]["h"]=h
  reagirl.Elements[slot]["r"]=r
  reagirl.Elements[slot]["g"]=g
  reagirl.Elements[slot]["b"]=b
  reagirl.Elements[slot]["a"]=a
  reagirl.Elements[slot]["sticky_x"]=false
  reagirl.Elements[slot]["sticky_y"]=false
  reagirl.Elements[slot]["filled"]=filled
  reagirl.Elements[slot]["func_draw"]=reagirl.Rect_Draw
  reagirl.Elements[slot]["run_function"]=reagirl.Dummy
  reagirl.Elements[slot]["func_manage"]=reagirl.Dummy
  return reagirl.Elements[slot]["Guid"]
end

function reagirl.Rect_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  gfx.set(element_storage["r"], element_storage["g"], element_storage["b"], element_storage["a"])
  gfx.rect(x,y,w,h, element_storage["filled"])
end


function reagirl.Line_Add(x,y,x2,y2,r,g,b,a)
  local slot=reagirl.UI_Element_GetNextFreeSlot()
  table.insert(reagirl.Elements, slot, {})
  reagirl.Elements[slot]["Guid"]=reaper.genGuid("")
  reagirl.Elements[slot]["GUI_Element_Type"]="Line"
  reagirl.Elements[slot]["IsDecorative"]=true
  reagirl.Elements[slot]["AccHint"]=""
  reagirl.Elements[slot]["Description"]=""
  reagirl.Elements[slot]["Text"]=""
  reagirl.Elements[slot]["Name"]=""
  reagirl.Elements[slot]["x"]=x
  reagirl.Elements[slot]["y"]=y
  reagirl.Elements[slot]["x2"]=x2
  reagirl.Elements[slot]["y2"]=y2
  reagirl.Elements[slot]["w"]=x2
  reagirl.Elements[slot]["h"]=y2
  reagirl.Elements[slot]["r"]=r
  reagirl.Elements[slot]["g"]=g
  reagirl.Elements[slot]["b"]=b
  reagirl.Elements[slot]["a"]=a
  reagirl.Elements[slot]["sticky_x"]=false
  reagirl.Elements[slot]["sticky_y"]=false
  reagirl.Elements[slot]["filled"]=filled
  reagirl.Elements[slot]["func_draw"]=reagirl.Line_Draw
  reagirl.Elements[slot]["run_function"]=reagirl.Dummy
  reagirl.Elements[slot]["func_manage"]=reagirl.Label_Manage
  return reagirl.Elements[slot]["Guid"]
end

function reagirl.Line_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  --element_id=reagirl.Decorative_Element_GetIDFromGuid(element_id)
  local x2, y2, w2, h2
  gfx.set(element_storage["r"], element_storage["g"], element_storage["b"], element_storage["a"])
  MoveItAllRight=reagirl.MoveItAllRight
  local MoveItAllUp=reagirl.MoveItAllUp
  if element_storage.sticky_x==true then MoveItAllRight=0 end
  if element_storage.sticky_y==true then MoveItAllUp=0 end
  
  
  if element_storage["x2"]<0 then x2=gfx.w+element_storage["x2"] else x2=element_storage["x2"] end
  if element_storage["y2"]<0 then y2=gfx.h+element_storage["y2"] else y2=element_storage["y2"] end
  
  MoveIt={x,y,x2,y2, w2, h2}
  gfx.line(x, y, x2+MoveItAllRight, y2+MoveItAllUp)
end


function reagirl.Image_Add(image_file, x, y, w, h, resize, Name, MeaningOfUI_Element, run_function, func_params)
  local slot=reagirl.UI_Element_GetNextFreeSlot()
  table.insert(reagirl.Elements, slot, {})
  reagirl.Elements[slot]["Guid"]=reaper.genGuid("")
  reagirl.Elements[slot]["GUI_Element_Type"]="Image"
  reagirl.Elements[slot]["Description"]=MeaningOfUI_Element
  reagirl.Elements[slot]["Name"]=Name
  reagirl.Elements[slot]["Text"]=Name
  reagirl.Elements[slot]["IsDecorative"]=false
  reagirl.Elements[slot]["AccHint"]="Use Space or left mouse-click to select it."
  reagirl.Elements[slot]["x"]=x
  reagirl.Elements[slot]["y"]=y
  reagirl.Elements[slot]["w"]=w
  reagirl.Elements[slot]["h"]=h
  reagirl.Elements[slot]["sticky_x"]=false
  reagirl.Elements[slot]["sticky_y"]=false
  reagirl.Elements[slot]["func_manage"]=reagirl.Image_Manage
  reagirl.Elements[slot]["func_draw"]=reagirl.Image_Draw
  reagirl.Elements[slot]["run_function"]=run_function
  reagirl.Elements[slot]["func_params"]=func_params
  
  reagirl.Elements[slot]["Image_Storage"]=reagirl.MaxImage
  reagirl.Elements[slot]["Image_File"]=image_file
  gfx.dest=reagirl.Elements[slot]["Image_Storage"]
  local r,g,b,a=gfx.r,gfx.g,gfx.b,gfx.a
  gfx.set(0)
  gfx.rect(0,0,8192,8192)
  gfx.set(r,g,b,a)
  local AImage=gfx.loadimg(reagirl.Elements[slot]["Image_Storage"], image_file)
  if resize==true then
    local retval = reagirl.ResizeImageKeepAspectRatio(reagirl.Elements[slot]["Image_Storage"], w, h, 0, 0, 0)
  else
    reagirl.Elements[slot]["w"], reagirl.Elements[slot]["h"] = gfx.getimgdim(AImage)
  end
  gfx.dest=-1
  return reagirl.Elements[slot]["Guid"]
end


function reagirl.Image_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if selected==true and 
    (Key==32 or mouse_cap==1) and 
    (gfx.mouse_x>=x and gfx.mouse_x<=x+w and gfx.mouse_y>=y and gfx.mouse_y<=y+h) and
    element_storage["run_function"]~=nil then 
      element_storage["run_function"](element_id, table.unpack(element_storage["func_params"])) 
  end
  if selected==true then
    message=" "
  end
  return message
end

function reagirl.Image_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  -- no docs in API-docs
  
  -- store changes
  local olddest, r, g, b, a, oldmode, oldx, oldy
  olddest=gfx.dest
  r=gfx.r
  g=gfx.g
  b=gfx.b
  a=gfx.a
  oldmode=gfx.mode
  oldx,oldy=gfx.x, gfx.y
  
  -- blit the image
  gfx.set(0)
  gfx.x=x
  gfx.y=y
  gfx.dest=-1
  gfx.blit(element_storage["Image_Storage"], 1, 0)
  
  -- revert changes
  gfx.r,gfx.g,gfx.b,gfx.a=r,g,b,a
  gfx.mode=oldmode
  gfx.x=oldx
  gfx.y=oldy
  gfx.dest=olddest
end

function reagirl.Image_Update(element_id, image_file)
  gfx.dest=reagirl.Elements[element_id]["Image_Storage"]
  reagirl.Elements[element_id]["Image_File"]=image_file
  local r,g,b,a=gfx.r,gfx.g,gfx.b,gfx.a
  gfx.set(1)
  gfx.rect(0,0,8192,8192)
  gfx.set(r,g,b,a)
  gfx.dest=-1
  AImage=gfx.loadimg(reagirl.Elements[element_id]["Image_Storage"], image_file)
  retval = reagirl.ResizeImageKeepAspectRatio(reagirl.Elements[element_id]["Image_Storage"], reagirl.Elements[element_id]["w"], reagirl.Elements[element_id]["h"], 0, 0, 0)
  reagirl.Gui_ForceRefresh(12)
end

function reagirl.ReserveImageBuffer()
  -- reserves an image buffer for custom UI elements
  -- returns -1 if no buffer can be reserved anymore
  if reagirl.MaxImage==nil then reagirl.MaxImage=1 end
  if reagirl.MaxImage>=1000 then return -1 end
  reagirl.MaxImage=reagirl.MaxImage+1
  return reagirl.MaxImage
end


function reagirl.Background_GetSetColor(is_set, r, g, b)
  if type(is_set)~="boolean" then error("GetSetBackgroundColor: param #1 - must be a boolean", 2) end
  if math.type(r)~="integer" then error("GetSetBackgroundColor: param #2 - must be an integer", 2) end
  if g~=nil and math.type(g)~="integer" then error("GetSetBackgroundColor: param #3 - must be an integer", 2) end
  if b~=nil and math.type(b)~="integer" then error("GetSetBackgroundColor: param #4 - must be an integer", 2) end
  if g==nil then g=r end
  if b==nil then b=r end
  if reagirl.Elements==nil then reagirl.Elements={} end
  if is_set==true then
    reagirl["WindowBackgroundColorR"],reagirl["WindowBackgroundColorG"],reagirl["WindowBackgroundColorB"]=r/255, g/255, b/255
  else
    return math.floor(reagirl["WindowBackgroundColorR"]*255), math.floor(reagirl["WindowBackgroundColorG"]*255), math.floor(reagirl["WindowBackgroundColorB"]*255)
  end
end


function reagirl.Background_GetSetImage(filename, x, y, scaled, fixed_x, fixed_y)
  if type(filename)~="string" then error("Background_GetSetImage: param #1 - must be a boolean", 2) end
  if math.type(x)~="integer" then error("Background_GetSetImage: param #2 - must be an integer", 2) end
  if math.type(y)~="integer" then error("Background_GetSetImage: param #3 - must be an integer", 2) end
  if type(scaled)~="boolean" then error("Background_GetSetImage: param #4 - must be a boolean", 2) end
  if type(fixed_x)~="boolean" then error("Background_GetSetImage: param #5 - must be an boolean", 2) end
  if type(fixed_y)~="boolean" then error("Background_GetSetImage: param #6 - must be an boolean", 2) end
  if reagirl.MaxImage==nil then reagirl.MaxImage=1 end
  reagirl.Background_FixedX=fixed_x
  reagirl.Background_FixedY=fixed_y
  reagirl.MaxImage=reagirl.MaxImage+1
  gfx.loadimg(reagirl.MaxImage, filename)
  local se={reaper.my_getViewport(0,0,0,0, 0,0,0,0, false)}
  reagirl.ResizeImageKeepAspectRatio(reagirl.MaxImage, se[3], se[4], bg_r, bg_g, bg_b)
  if reagirl.DecorativeImages==nil then
    reagirl.DecorativeImages={}
    reagirl.DecorativeImages["Background"]=reagirl.MaxImage
    reagirl.DecorativeImages["Background_Scaled"]=scaled
    reagirl.DecorativeImages["Background_Centered"]=centered
    reagirl.DecorativeImages["Background_x"]=x
    reagirl.DecorativeImages["Background_y"]=y
  end
end

function reagirl.GetHoveredUIElement()
  for i=#reagirl.Elements, 1, -1 do
    local x2, y2, w2, h2
    if reagirl.Elements[i]["x"]<0 then x2=gfx.w+reagirl.Elements[i]["x"] else x2=reagirl.Elements[i]["x"] end
    if reagirl.Elements[i]["y"]<0 then y2=gfx.h+reagirl.Elements[i]["y"] else y2=reagirl.Elements[i]["y"] end
    if reagirl.Elements[i]["w"]<0 then w2=gfx.w-x2+reagirl.Elements[i]["w"] else w2=reagirl.Elements[i]["w"] end
    if reagirl.Elements[i]["h"]<0 then h2=gfx.h-h2+reagirl.Elements[i]["h"] else h2=reagirl.Elements[i]["h"] end
    
    if gfx.mouse_x>=x2 and gfx.mouse_y>=y2 and
       gfx.mouse_x<=x2+w2 and gfx.mouse_y<=y2+h2 then
      if i~=reagirl.Elements["old_hovered_element"] then
        --reaper.osara_outputMessage(""..reagirl.Elements[i]["Name"].." ")
        reagirl.Elements["old_hovered_element"]=i
        return i
      end
    end
  end
  
  return reagirl.Elements["old_hovered_element"]
end

function reagirl.Background_DrawImage()
  if reagirl.DecorativeImages==nil then return end
  local xoffset=0
  local yoffset=0
  if reagirl.Background_FixedX==false then xoffset=reagirl.MoveItAllRight end
  if reagirl.Background_FixedY==false then yoffset=reagirl.MoveItAllUp end
  gfx.dest=-1
  local scale=1
  local x,y=gfx.getimgdim(reagirl.DecorativeImages["Background"])
  local ratiox=((100/x)*gfx.w)/100
  local ratioy=((100/y)*gfx.h)/100
  if reagirl.DecorativeImages["Background_Scaled"]==true then
    if ratiox<ratioy then scale=ratiox else scale=ratioy end
    if x<gfx.w and y<gfx.h then scale=1 end
  end
  gfx.x=reagirl.DecorativeImages["Background_x"]+xoffset
  gfx.y=reagirl.DecorativeImages["Background_y"]+yoffset
  gfx.blit(reagirl.DecorativeImages["Background"], scale, 0)
end

function reagirl.FileDropZone_CheckForDroppedFiles()
  local x, y, w, h
  local i=1
  if reagirl.DropZone~=nil then
    for i=1, #reagirl.DropZone do
      if reagirl.DropZone[i]["DropZoneX"]<0 then x=gfx.w+reagirl.DropZone[i]["DropZoneX"]+reagirl.MoveItAllRight else x=reagirl.DropZone[i]["DropZoneX"]+reagirl.MoveItAllRight end
      if reagirl.DropZone[i]["DropZoneY"]<0 then y=gfx.h+reagirl.DropZone[i]["DropZoneY"]+reagirl.MoveItAllUp else y=reagirl.DropZone[i]["DropZoneY"]+reagirl.MoveItAllUp end
      if reagirl.DropZone[i]["DropZoneW"]<0 then w=gfx.w-x+reagirl.DropZone[i]["DropZoneW"] else w=reagirl.DropZone[i]["DropZoneW"] end
      if reagirl.DropZone[i]["DropZoneH"]<0 then h=gfx.h-y+reagirl.DropZone[i]["DropZoneH"] else h=reagirl.DropZone[i]["DropZoneH"] end
      -- debug dropzone-rectangle, for checking, if it works
      --[[  gfx.set(1)
        gfx.rect(x, y, w, h, 0)
      --]]
      local files={}
      local retval
      if gfx.mouse_x>=x and
         gfx.mouse_y>=y and
         gfx.mouse_x<=x+w and
         gfx.mouse_y<=y+h then
         for i=0, 65555 do
           retval, files[i+1]=gfx.getdropfile(i)
           if retval==false then break end
         end
         if #files>0 then
          reagirl.DropZone[i]["DropZoneFunc"](i, files)
          reagirl.Gui_ForceRefresh(14)
         end
      end
    end
    gfx.getdropfile(-1)
  end
end

function reagirl.FileDropZone_Add(x,y,w,h,func)
  if reagirl.DropZone==nil then reagirl.DropZone={} end
  reagirl.DropZone[#reagirl.DropZone+1]={}
  reagirl.DropZone[#reagirl.DropZone]["Guid"]=reaper.genGuid("")
  reagirl.DropZone[#reagirl.DropZone]["DropZoneFunc"]=func
  reagirl.DropZone[#reagirl.DropZone]["DropZoneX"]=x
  reagirl.DropZone[#reagirl.DropZone]["DropZoneY"]=y
  reagirl.DropZone[#reagirl.DropZone]["DropZoneW"]=w
  reagirl.DropZone[#reagirl.DropZone]["DropZoneH"]=h
  reagirl.DropZone[#reagirl.DropZone]["sticky_x"]=false
  reagirl.DropZone[#reagirl.DropZone]["sticky_y"]=false
  return reagirl.DropZone[#reagirl.DropZone]["Guid"]
end

function reagirl.FileDropZone_Remove(dropzone_id)
  if type(dropzone_id)~="string" then error("FileDropZone_Remove: #1 - must be a guid as string", 2) end

  for i=1, #reagirl.DropZone do
    if reagirl.DropZone[i]["Guid"]==dropzone_id then table.remove(reagirl.DropZone[i], i) return true end
  end
  
  return false
end

function reagirl.ContextMenuZone_ManageMenu(mouse_cap)
  local x, y, w, h 
  local i=1
  if mouse_cap&2==0 then return end
  if reagirl.ContextMenu~=nil then
    for i=1, #reagirl.ContextMenu do
      if reagirl.ContextMenu[i]["ContextMenuX"]<0 then x=gfx.w+reagirl.ContextMenu[i]["ContextMenuX"]+reagirl.MoveItAllRight else x=reagirl.ContextMenu[i]["ContextMenuX"]+reagirl.MoveItAllRight end
      if reagirl.ContextMenu[i]["ContextMenuY"]<0 then y=gfx.h+reagirl.ContextMenu[i]["ContextMenuY"]+reagirl.MoveItAllUp else y=reagirl.ContextMenu[i]["ContextMenuY"]+reagirl.MoveItAllUp end
      if reagirl.ContextMenu[i]["ContextMenuW"]<0 then w=gfx.w-x+reagirl.ContextMenu[i]["ContextMenuW"] else w=reagirl.ContextMenu[i]["ContextMenuW"] end
      if reagirl.ContextMenu[i]["ContextMenuH"]<0 then h=gfx.h-y+reagirl.ContextMenu[i]["ContextMenuH"] else h=reagirl.ContextMenu[i]["ContextMenuH"] end
      -- debug dropzone-rectangle, for checking, if it works
      --[[
        gfx.set(1)
        gfx.rect(x, y, w, h, 1)
      --]]
      local files={}
      local retval
      if gfx.mouse_x>=x and
         gfx.mouse_y>=y and
         gfx.mouse_x<=x+w and
         gfx.mouse_y<=y+h then
         local oldx=gfx.x
         local oldy=gfx.y
         gfx.x=gfx.mouse_x
         gfx.y=gfx.mouse_y
        local retval=gfx.showmenu(reagirl.ContextMenu[i]["ContextMenu"])
        if retval>0 then
          reagirl.ContextMenu[i]["ContextMenuFunc"](i, retval)
        end
        gfx.x=oldx
        gfx.y=oldy
      end
      reagirl.Gui_ForceRefresh(15)
    end
  end
end

function reagirl.ContextMenuZone_Add(x,y,w,h,menu, func)
  if reagirl.ContextMenu==nil then reagirl.ContextMenu={} end
  reagirl.ContextMenu[#reagirl.ContextMenu+1]={}
  reagirl.ContextMenu[#reagirl.ContextMenu]["Guid"]=reaper.genGuid()
  reagirl.ContextMenu[#reagirl.ContextMenu]["ContextMenuFunc"]=func
  reagirl.ContextMenu[#reagirl.ContextMenu]["ContextMenuX"]=x
  reagirl.ContextMenu[#reagirl.ContextMenu]["ContextMenuY"]=y
  reagirl.ContextMenu[#reagirl.ContextMenu]["ContextMenuW"]=w
  reagirl.ContextMenu[#reagirl.ContextMenu]["ContextMenuH"]=h
  reagirl.ContextMenu[#reagirl.ContextMenu]["sticky_x"]=false
  reagirl.ContectMenu[#reagirl.ContextMenu]["sticky_y"]=false
  reagirl.ContextMenu[#reagirl.ContextMenu]["ContextMenu"]=menu
  
  return reagirl.ContextMenu[#reagirl.ContextMenu]["Guid"]
end

function reagirl.ContextMenuZone_Remove(context_menuzone_id)
  if type(context_menuzone_id)~="string" then error("ContextMenuZone_Remove: #1 - must be a guid as string", 2) end
  for i=1, #reagirl.ContextMenu do
    if reagirl.ContextMenu[i]["Guid"]==context_menuzone_id then table.remove(reagirl.ContextMenu[i], i) return true end
  end
  return false
end

function reagirl.Window_ForceMinSize()
  if reagirl.Window_ForceMinSize_Toggle~=true then return end
  local h,w
  if gfx.w<reagirl.Window_MinW-1 then w=reagirl.Window_MinW else w=gfx.w end
  if gfx.h<reagirl.Window_MinH-1 then h=reagirl.Window_MinH else h=gfx.h end
  
  if gfx.w==w and gfx.h==h then return end
  gfx.init("", w, h)
  reagirl.Gui_ForceRefresh(16)
end

function reagirl.Window_ForceMaxSize()
  if reagirl.Window_ForceMaxSize_Toggle~=true then return end
  local h,w
  if gfx.w>reagirl.Window_MaxW then w=reagirl.Window_MaxW else w=gfx.w end
  if gfx.h>reagirl.Window_MaxH then h=reagirl.Window_MaxH else h=gfx.h end
  
  if gfx.w==w and gfx.h==h then return end
  gfx.init("", w, h)
  reagirl.Gui_ForceRefresh(16)
end

function reagirl.Gui_ForceRefresh(place)
  reagirl.Gui_ForceRefreshState=true
  reagirl.Gui_ForceRefresh_place=place
  reagirl.Gui_ForceRefresh_time=reaper.time_precise()
end

function reagirl.Window_ForceSize_Minimum(MinW, MinH)
  reagirl.Window_ForceMinSize_Toggle=true
  reagirl.Window_MinW=MinW
  reagirl.Window_MinH=MinH
end

function reagirl.Window_ForceSize_Maximum(MaxW, MaxH)
  reagirl.Window_ForceMaxSize_Toggle=true
  reagirl.Window_MaxW=MaxW
  reagirl.Window_MaxH=MaxH
end

--- End of ReaGirl-functions


function DropDownList(element_id, check, name)
  print2(element_id, check, name)
end







function UpdateImage2(element_id)
  reagirl.Gui_ForceRefreshState=true
  if gfx.mouse_cap==1 then
    retval, filename = reaper.GetUserFileNameForRead("", "", "")
    if retval==true then
      reagirl.Image_Update(element_id, filename)
    end
  end
  --]]
end

function GetFileList(element_id, filelist)
  print2(element_id)
  reagirl.Image_Update(1, filelist[1])
  AFile=filelist
  list=""
  for i=1, 1000 do
    if filelist[i]~=nil then 
      list=list..i..": "..filelist[i].."\n"
    end
  end
 -- print2(list)
end

function GetFileList2(filelist)
  list=""
  for i=1, 1000 do
    if filelist[i]==nil then break end
    list=list..filelist[i].."\n"
  end
  print2("Zwo:"..list)
end

function CheckMe(tudelu)
--  print2(tudelu)
end


local count=0
local count2=0

function reagirl.UI_Element_ScrollX(deltapx_x)
  if deltapx_x>0 and reagirl.MoveItAllRight_Delta<0 then reagirl.MoveItAllRight_Delta=0 end
  if deltapx_x<0 and reagirl.MoveItAllRight_Delta>0 then reagirl.MoveItAllRight_Delta=0 end
  reagirl.MoveItAllRight_Delta=reagirl.MoveItAllRight_Delta+deltapx_x
end

function reagirl.UI_Element_ScrollY(deltapx_y)
  if deltapx_y>0 and reagirl.MoveItAllUp_Delta<0 then reagirl.MoveItAllUp_Delta=0 end
  if deltapx_y<0 and reagirl.MoveItAllUp_Delta>0 then reagirl.MoveItAllUp_Delta=0 end
  reagirl.MoveItAllUp_Delta=reagirl.MoveItAllUp_Delta+deltapx_y
end

function reagirl.UI_Element_SmoothScroll(Smoothscroll)
  reagirl.SmoothScroll=Smoothscroll
  if reagirl.BoundaryY_Max>gfx.h then
    if reagirl.MoveItAllUp_Delta<0 and reagirl.BoundaryY_Max+reagirl.MoveItAllUp-gfx.h<=0 then reagirl.MoveItAllUp_Delta=0 reagirl.MoveItAllUp=gfx.h-reagirl.BoundaryY_Max reagirl.Gui_ForceRefresh(64) end
    if reagirl.MoveItAllUp_Delta>0 and reagirl.BoundaryY_Min+reagirl.MoveItAllUp>=0 then reagirl.MoveItAllUp_Delta=0 reagirl.MoveItAllUp=0 reagirl.Gui_ForceRefresh(65) end
    if reagirl.MoveItAllUp_Delta>0 then 
      reagirl.MoveItAllUp_Delta=reagirl.MoveItAllUp_Delta-1
      if reagirl.MoveItAllUp_Delta<0 then reagirl.MoveItAllUp_Delta=0 end
    elseif reagirl.MoveItAllUp_Delta<0 then 
      reagirl.MoveItAllUp_Delta=reagirl.MoveItAllUp_Delta+1
      if reagirl.MoveItAllUp_Delta>0 then reagirl.MoveItAllUp_Delta=0 end
    end
    if reagirl.BoundaryY_Max>gfx.h then
      reagirl.MoveItAllUp=reagirl.MoveItAllUp+reagirl.MoveItAllUp_Delta
    end
  end
  
  if reagirl.BoundaryX_Max>gfx.w then
    if reagirl.MoveItAllRight_Delta<0 and reagirl.BoundaryX_Max+reagirl.MoveItAllRight-gfx.w<=0 then reagirl.MoveItAllRight_Delta=0 reagirl.MoveItAllRight=gfx.w-reagirl.BoundaryX_Max reagirl.Gui_ForceRefresh(66) end
    if reagirl.MoveItAllRight_Delta>0 and reagirl.BoundaryX_Min+reagirl.MoveItAllRight>=0 then reagirl.MoveItAllRight_Delta=0 reagirl.MoveItAllRight=0 reagirl.Gui_ForceRefresh(67) end
    if reagirl.BoundaryX_Max>gfx.w and reagirl.MoveItAllRight_Delta>0 then 
      reagirl.MoveItAllRight_Delta=reagirl.MoveItAllRight_Delta-1
      if reagirl.MoveItAllRight_Delta<0 then reagirl.MoveItAllRight_Delta=0 end
    elseif reagirl.BoundaryX_Max>gfx.w and reagirl.MoveItAllRight_Delta<0 then 
      reagirl.MoveItAllRight_Delta=reagirl.MoveItAllRight_Delta+1
      if reagirl.MoveItAllRight_Delta>0 then reagirl.MoveItAllRight_Delta=0 end
    end
    if reagirl.BoundaryX_Max>gfx.w then
      reagirl.MoveItAllRight=reagirl.MoveItAllRight+reagirl.MoveItAllRight_Delta
    end
  end
  
  if reagirl.MoveItAllRight_Delta~=0 or reagirl.MoveItAllUp_Delta~=0 then reagirl.Gui_ForceRefresh(68) end
end

function reagirl.UI_Elements_Boundaries()
  -- sets the boundaries of the maximum scope of all ui-elements into reagirl.Boundary[X|Y]_[Min|Max]-variables.
  -- these can be used to calculate scrolling including stopping at the minimum, maximum position of the ui-elements,
  -- so you don't scroll forever.
  -- This function only calculates non-locked ui-element-directions
  
  --[[
  -- Democode for Gui_Manage, that scrolls via arrow-keys including "scroll lock" when reaching end of ui-elements.
  if Key==30064 then 
    -- Up
    if reagirl.BoundaryY_Max+reagirl.MoveItAllUp>gfx.h then 
      reagirl.MoveItAllUp=reagirl.MoveItAllUp-10 
      reagirl.Gui_ForceRefresh() 
    end
  end
  if Key==1685026670 then 
    -- Down
    if reagirl.BoundaryY_Min+reagirl.MoveItAllUp<0 then 
      reagirl.MoveItAllUp=reagirl.MoveItAllUp+10 
      reagirl.Gui_ForceRefresh()   
    end
  end
  if Key==1818584692.0 then 
    -- left
    if reagirl.BoundaryX_Min+reagirl.MoveItAllRight<0 then 
      reagirl.MoveItAllRight=reagirl.MoveItAllRight+10 
      reagirl.Gui_ForceRefresh() 
    end
  end
  if Key==1919379572.0 then 
    if reagirl.BoundaryX_Max+reagirl.MoveItAllRight>gfx.w then 
      reagirl.MoveItAllRight=reagirl.MoveItAllRight-10 
      reagirl.Gui_ForceRefresh() 
    end
  end
  --]]
  --[[
  local x2, y2, w2, h2
  if reagirl.Elements[i]["x"]<0 then x2=gfx.w+reagirl.Elements[i]["x"] else x2=reagirl.Elements[i]["x"] end
  if reagirl.Elements[i]["y"]<0 then y2=gfx.h+reagirl.Elements[i]["y"] else y2=reagirl.Elements[i]["y"] end
  if reagirl.Elements[i]["w"]<0 then w2=gfx.w-x2+reagirl.Elements[i]["w"] else w2=reagirl.Elements[i]["w"] end
  if reagirl.Elements[i]["h"]<0 then h2=gfx.h-y2+reagirl.Elements[i]["h"] else h2=reagirl.Elements[i]["h"] end
  if reagirl.Elements[i]["GUI_Element_Type"]=="DropDownMenu" then
    if w2<20 then w2=20 end
  end
  --]]
  local minx, miny, maxx, maxy = 2147483648, 2147483648, -2147483648, -2147483648
  -- first the x position
  for i=1, #reagirl.Elements do
    if reagirl.Elements[i].sticky_x==false then
      local x2, y2, w2, h2
      if reagirl.Elements[i]["x"]<0 then x2=gfx.w+reagirl.Elements[i]["x"] else x2=reagirl.Elements[i]["x"] end
      if reagirl.Elements[i]["y"]<0 then y2=gfx.h+reagirl.Elements[i]["y"] else y2=reagirl.Elements[i]["y"] end
      if reagirl.Elements[i]["w"]<0 then w2=gfx.w-x2+reagirl.Elements[i]["w"] else w2=reagirl.Elements[i]["w"] end
      if reagirl.Elements[i]["GUI_Element_Type"]=="DropDownMenu" then if w2<20 then w2=20 end end
      if reagirl.Elements[i]["h"]<0 then h2=gfx.h-y2+reagirl.Elements[i]["h"] else h2=reagirl.Elements[i]["h"] end
      if x2<minx then minx=x2 end
      if w2+x2>maxx then maxx=w2+x2 MaxW=w2 end
      
      if y2<miny then miny=y2 end
      if h2+y2>maxy then maxy=h2+y2 MAXH=h2 end
      MINY=miny
      MAXY=maxy
    end
  end
  --gfx.line(minx+reagirl.MoveItAllRight,miny+reagirl.MoveItAllUp, maxx+reagirl.MoveItAllRight, maxy+reagirl.MoveItAllUp, 1)
  --gfx.line(minx+reagirl.MoveItAllRight,miny+reagirl.MoveItAllUp, minx+reagirl.MoveItAllRight, maxy+reagirl.MoveItAllUp)
  
  reagirl.BoundaryX_Min=0--minx
  reagirl.BoundaryX_Max=maxx
  reagirl.BoundaryY_Min=0--miny
  reagirl.BoundaryY_Max=maxy
  --gfx.rect(reagirl.BoundaryX_Min, reagirl.BoundaryY_Min+reagirl.MoveItAllUp, 10, 10, 1)
  --gfx.drawstr(reagirl.MoveItAllUp.." "..reagirl.BoundaryY_Min)
end

function reagirl.DockState_Update(name)
  -- sets the dockstate into extstates
  local dockstate=tonumber(reaper.GetExtState("ReaGirl_"..name, "dockstate"))--gfx.dock
  if dockstate==nil then dockstate=0 end
  if dockstate~=gfx.dock(-1) then
    reaper.SetExtState("ReaGirl_"..name, "dockstate", gfx.dock(-1), true)
  end
end

function reagirl.DockState_Retrieve(name)
  -- retrieves the dockstate from the extstate and sets it
  local dockstate=tonumber(reaper.GetExtState("ReaGirl_"..name, "dockstate"))--gfx.dock
  if dockstate==nil then dockstate=0 end
  return math.tointeger(dockstate)
end

function reagirl.DockState_Update_Project(name)
  -- sets the dockstate into project extstates
  local dockstate=tonumber(reaper.GetProjExtState(0, "ReaGirl_"..name, "dockstate"))--gfx.dock
  if dockstate==nil then dockstate=0 end
  if dockstate~=gfx.dock(-1) then
    reaper.SetProjExtState(0, "ReaGirl_"..name, "dockstate", gfx.dock(-1), true)
  end
end

function reagirl.DockState_RetrieveAndSet_Project(name)
  -- retrieves the dockstate from the project extstate and sets it
  local dockstate=tonumber(reaper.GetProjExtState(0, "ReaGirl_"..name, "dockstate"))--gfx.dock
  gfx.dock(dockstate)
end

function reagirl.ScrollButton_Right_Add()
  reagirl.Elements[#reagirl.Elements+1]={}
  reagirl.Elements[#reagirl.Elements]["Guid"]=reaper.genGuid("")
  reagirl.Elements[#reagirl.Elements]["GUI_Element_Type"]="Scroll button"
  reagirl.Elements[#reagirl.Elements]["Name"]="Scroll right"
  reagirl.Elements[#reagirl.Elements]["Text"]=""
  reagirl.Elements[#reagirl.Elements]["IsDecorative"]=false
  reagirl.Elements[#reagirl.Elements]["Description"]="Scroll Right"
  reagirl.Elements[#reagirl.Elements]["AccHint"]="Scrolls the user interface to the right"
  reagirl.Elements[#reagirl.Elements]["x"]=-30
  reagirl.Elements[#reagirl.Elements]["y"]=-15
  reagirl.Elements[#reagirl.Elements]["w"]=15
  reagirl.Elements[#reagirl.Elements]["h"]=15
  reagirl.Elements[#reagirl.Elements]["sticky_x"]=true
  reagirl.Elements[#reagirl.Elements]["sticky_y"]=true
  reagirl.Elements[#reagirl.Elements]["func_manage"]=reagirl.ScrollButton_Right_Manage
  reagirl.Elements[#reagirl.Elements]["func_draw"]=reagirl.ScrollButton_Right_Draw
  reagirl.Elements[#reagirl.Elements]["userspace"]={}
  reagirl.Elements[#reagirl.Elements]["a"]=0
  return reagirl.Elements[#reagirl.Elements]["Guid"]
end

function reagirl.ScrollButton_Right_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if element_storage.IsDecorative==false and element_storage.a<=1 then element_storage.a=element_storage.a+.1 reagirl.Gui_ForceRefresh(99.3) end
  if mouse_cap&1==1 and selected==true and gfx.mouse_x>=x and gfx.mouse_x<=x+w and gfx.mouse_y>=y and gfx.mouse_y<=y+h then
    reagirl.UI_Element_ScrollX(-2)
  elseif selected==true and Key==32 then
    reagirl.UI_Element_ScrollX(-15)
  end
  return ""
end

function reagirl.ScrollButton_Right_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  local x_offset=-15
  if reagirl.BoundaryX_Max>gfx.w then
    element_storage.IsDecorative=false
  else
    element_storage.a=0 
    if element_storage.IsDecorative==false then
      reagirl.UI_Element_SetNothingFocused()
      element_storage.IsDecorative=true
    end
  end
  local oldr, oldg, oldb, olda = gfx.r, gfx.g, gfx.b, gfx.a
  gfx.set(reagirl["WindowBackgroundColorR"], reagirl["WindowBackgroundColorG"], reagirl["WindowBackgroundColorB"], 1)
  gfx.rect(gfx.w-15+x_offset, gfx.h-15, 15, 15, 1)
  gfx.set(0.39, 0.39, 0.39, element_storage.a)
  gfx.rect(gfx.w-15+x_offset, gfx.h-15, 15, 15, 0)
  gfx.triangle(gfx.w-10+x_offset, gfx.h-3,
               gfx.w-10+x_offset, gfx.h-13,
               gfx.w-5+x_offset, gfx.h-8)
  gfx.set(oldr, oldg, oldb, olda)
end

function reagirl.ScrollButton_Left_Add()
  reagirl.Elements[#reagirl.Elements+1]={}
  reagirl.Elements[#reagirl.Elements]["Guid"]=reaper.genGuid("")
  reagirl.Elements[#reagirl.Elements]["GUI_Element_Type"]="Scroll button"
  reagirl.Elements[#reagirl.Elements]["Name"]="Scroll left"
  reagirl.Elements[#reagirl.Elements]["Text"]=""
  reagirl.Elements[#reagirl.Elements]["IsDecorative"]=false
  reagirl.Elements[#reagirl.Elements]["Description"]="Scroll left"
  reagirl.Elements[#reagirl.Elements]["AccHint"]="Scrolls the user interface to the left"
  reagirl.Elements[#reagirl.Elements]["x"]=1
  reagirl.Elements[#reagirl.Elements]["y"]=-15
  reagirl.Elements[#reagirl.Elements]["w"]=15
  reagirl.Elements[#reagirl.Elements]["h"]=15
  reagirl.Elements[#reagirl.Elements]["sticky_x"]=true
  reagirl.Elements[#reagirl.Elements]["sticky_y"]=true
  reagirl.Elements[#reagirl.Elements]["func_manage"]=reagirl.ScrollButton_Left_Manage
  reagirl.Elements[#reagirl.Elements]["func_draw"]=reagirl.ScrollButton_Left_Draw
  reagirl.Elements[#reagirl.Elements]["userspace"]={}
  reagirl.Elements[#reagirl.Elements]["a"]=0
  return reagirl.Elements[#reagirl.Elements]["Guid"]
end

function reagirl.ScrollButton_Left_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if element_storage.IsDecorative==false and element_storage.a<=1 then element_storage.a=element_storage.a+.1 reagirl.Gui_ForceRefresh(99.2) end
  if mouse_cap&1==1 and selected==true and gfx.mouse_x>=x and gfx.mouse_x<=x+w and gfx.mouse_y>=y and gfx.mouse_y<=y+h then
    reagirl.UI_Element_ScrollX(2)
  elseif selected==true and Key==32 then
    reagirl.UI_Element_ScrollX(15)
  end
  return ""
end

function reagirl.ScrollButton_Left_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if reagirl.BoundaryX_Max>gfx.w then
    element_storage.IsDecorative=false
  else
    element_storage.a=0 
    --reagirl.Gui_ForceRefresh(99.2) 
    if element_storage.IsDecorative==false then
      reagirl.UI_Element_SetNothingFocused()
      element_storage.IsDecorative=true
    end
  end
  local oldr, oldg, oldb, olda = gfx.r, gfx.g, gfx.b, gfx.a
  gfx.set(reagirl["WindowBackgroundColorR"], reagirl["WindowBackgroundColorG"], reagirl["WindowBackgroundColorB"], 1)
  gfx.rect(0, gfx.h-15, 15, 15, 1)
  gfx.set(0.39, 0.39, 0.39, element_storage.a)
  gfx.rect(0, gfx.h-15, 15, 15, 0)
  gfx.triangle(8, gfx.h-3,
               8, gfx.h-13,
               3, gfx.h-8)
  gfx.set(oldr, oldg, oldb, olda)
end

function reagirl.ScrollButton_Up_Add()
  reagirl.Elements[#reagirl.Elements+1]={}
  reagirl.Elements[#reagirl.Elements]["Guid"]=reaper.genGuid("")
  reagirl.Elements[#reagirl.Elements]["GUI_Element_Type"]="Scroll button"
  reagirl.Elements[#reagirl.Elements]["Name"]="Scroll Up"
  reagirl.Elements[#reagirl.Elements]["Text"]=""
  reagirl.Elements[#reagirl.Elements]["IsDecorative"]=false
  reagirl.Elements[#reagirl.Elements]["Description"]="Scroll up"
  reagirl.Elements[#reagirl.Elements]["AccHint"]="Scrolls the user interface upwards"
  reagirl.Elements[#reagirl.Elements]["x"]=-15
  reagirl.Elements[#reagirl.Elements]["y"]=0
  reagirl.Elements[#reagirl.Elements]["w"]=15
  reagirl.Elements[#reagirl.Elements]["h"]=15
  reagirl.Elements[#reagirl.Elements]["sticky_x"]=true
  reagirl.Elements[#reagirl.Elements]["sticky_y"]=true
  reagirl.Elements[#reagirl.Elements]["func_manage"]=reagirl.ScrollButton_Up_Manage
  reagirl.Elements[#reagirl.Elements]["func_draw"]=reagirl.ScrollButton_Up_Draw
  reagirl.Elements[#reagirl.Elements]["userspace"]={}
  reagirl.Elements[#reagirl.Elements]["a"]=0
  return reagirl.Elements[#reagirl.Elements]["Guid"]
end

function reagirl.ScrollButton_Up_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if element_storage.IsDecorative==false and element_storage.a<=1 then element_storage.a=element_storage.a+.1 reagirl.Gui_ForceRefresh(99.5) end
  if mouse_cap&1==1 and selected==true and gfx.mouse_x>=x and gfx.mouse_x<=x+w and gfx.mouse_y>=y and gfx.mouse_y<=y+h then
    reagirl.UI_Element_ScrollY(2)
  elseif selected==true and Key==32 then
    reagirl.UI_Element_ScrollY(15)
  end
  return ""
end

function reagirl.ScrollButton_Up_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if reagirl.BoundaryY_Max>gfx.h then
    element_storage.IsDecorative=false
  else
    element_storage.a=0 
    --reagirl.Gui_ForceRefresh(99.2) 
    if element_storage.IsDecorative==false then
      reagirl.UI_Element_SetNothingFocused()
      element_storage.IsDecorative=true
    end
  end
  local oldr, oldg, oldb, olda = gfx.r, gfx.g, gfx.b, gfx.a
  gfx.set(reagirl["WindowBackgroundColorR"], reagirl["WindowBackgroundColorG"], reagirl["WindowBackgroundColorB"], 1)
  gfx.rect(gfx.w-15, 0, 15, 15, 1)
  gfx.set(0.39, 0.39, 0.39, element_storage.a)
  gfx.rect(gfx.w-15, 0, 15, 15, 0)
  gfx.triangle(gfx.w-8, 4,
               gfx.w-3, 9,
               gfx.w-13, 9)
  gfx.set(oldr, oldg, oldb, olda)
end

function reagirl.ScrollButton_Down_Add()
  reagirl.Elements[#reagirl.Elements+1]={}
  reagirl.Elements[#reagirl.Elements]["Guid"]=reaper.genGuid("")
  reagirl.Elements[#reagirl.Elements]["GUI_Element_Type"]="Scroll button"
  reagirl.Elements[#reagirl.Elements]["Name"]="Scroll Down"
  reagirl.Elements[#reagirl.Elements]["Text"]=""
  reagirl.Elements[#reagirl.Elements]["IsDecorative"]=false
  reagirl.Elements[#reagirl.Elements]["Description"]="Scroll Down"
  reagirl.Elements[#reagirl.Elements]["AccHint"]="Scrolls the user interface downwards"
  reagirl.Elements[#reagirl.Elements]["x"]=-15
  reagirl.Elements[#reagirl.Elements]["y"]=-30
  reagirl.Elements[#reagirl.Elements]["w"]=15
  reagirl.Elements[#reagirl.Elements]["h"]=15
  reagirl.Elements[#reagirl.Elements]["sticky_x"]=true
  reagirl.Elements[#reagirl.Elements]["sticky_y"]=true
  reagirl.Elements[#reagirl.Elements]["func_manage"]=reagirl.ScrollButton_Down_Manage
  reagirl.Elements[#reagirl.Elements]["func_draw"]=reagirl.ScrollButton_Down_Draw
  reagirl.Elements[#reagirl.Elements]["userspace"]={}
  reagirl.Elements[#reagirl.Elements]["a"]=0
  return reagirl.Elements[#reagirl.Elements]["Guid"]
end

function reagirl.ScrollButton_Down_Manage(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if element_storage.IsDecorative==false and element_storage.a<=1 then element_storage.a=element_storage.a+.1 reagirl.Gui_ForceRefresh(99.5) end
  refresh_1=clicked
  if mouse_cap&1==1 and selected==true and gfx.mouse_x>=x and gfx.mouse_x<=x+w and gfx.mouse_y>=y and gfx.mouse_y<=y+h then
    reagirl.UI_Element_ScrollY(-2)
  elseif selected==true and Key==32 then
    reagirl.UI_Element_ScrollY(-15)
  end
  return ""
end

function reagirl.ScrollButton_Down_Draw(element_id, selected, clicked, mouse_cap, mouse_attributes, name, description, x, y, w, h, Key, Key_UTF, element_storage)
  if reagirl.BoundaryY_Max>gfx.h then
    element_storage.IsDecorative=false
  else
    element_storage.a=0 
    --reagirl.Gui_ForceRefresh(99.2) 
    if element_storage.IsDecorative==false then
      reagirl.UI_Element_SetNothingFocused()
      element_storage.IsDecorative=true
    end
  end
  local oldr, oldg, oldb, olda = gfx.r, gfx.g, gfx.b, gfx.a
  gfx.set(reagirl["WindowBackgroundColorR"], reagirl["WindowBackgroundColorG"], reagirl["WindowBackgroundColorB"], 1)
  gfx.rect(gfx.w-15, gfx.h-30, 15, 15, 1)
  gfx.set(0.39, 0.39, 0.39, element_storage.a)
  gfx.rect(gfx.w-15, gfx.h-30, 15, 15, 0)
  gfx.triangle(gfx.w-8, gfx.h-20,
               gfx.w-3, gfx.h-25,
               gfx.w-13, gfx.h-25)
  gfx.set(oldr, oldg, oldb, olda)
end

function reagirl.UI_Element_GetNextFreeSlot()
  return #reagirl.Elements-3
end

function reagirl.UI_Element_ScrollToUIElement(element_id, x_offset, y_offset)
  if x_offset==nil then x_offset=10 end
  if y_offset==nil then y_offset=10 end
  local found=-1
  local x2,y2,w2,h2
  for i=1, #reagirl.Elements do
    if element_id==reagirl.Elements[i].Guid then
      if reagirl.Elements[i]["x"]<0 then x2=gfx.w+reagirl.Elements[i]["x"] else x2=reagirl.Elements[i]["x"] end
      if reagirl.Elements[i]["y"]<0 then y2=gfx.h+reagirl.Elements[i]["y"] else y2=reagirl.Elements[i]["y"] end
      if reagirl.Elements[i]["w"]<0 then w2=gfx.w-x2+reagirl.Elements[i]["w"] else w2=reagirl.Elements[i]["w"] end
      if reagirl.Elements[i]["h"]<0 then h2=gfx.h-y2+reagirl.Elements[i]["h"] else h2=reagirl.Elements[i]["h"] end
      
      if x2+reagirl.MoveItAllRight<0 or x2+reagirl.MoveItAllRight>gfx.w or y2+reagirl.MoveItAllUp<0 or y2+reagirl.MoveItAllUp>gfx.h or
         x2+w2+reagirl.MoveItAllRight<0 or x2+w2+reagirl.MoveItAllRight>gfx.w or y2+h2+reagirl.MoveItAllUp<0 or y2+h2+reagirl.MoveItAllUp>gfx.h 
      then
        --print2()
        reagirl.MoveItAllRight=-x2+x_offset
        reagirl.MoveItAllUp=-y2+y_offset
        reagirl.Gui_ForceRefresh(999)
      end
    end
  end
end

function reagirl.UI_Element_SetNothingFocused()
  reagirl.Elements.FocusedElement=-1
end

function main()
  reagirl.Gui_Manage()
  reagirl.DockState_Update("Stonehenge")

  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end

function Dummy()
end

function click_button(test)
  --print(os.date())
  print2(test)
  print2(reagirl.UI_Element_GetSetName(test, false))
  if test==BT1 then
    reaper.Main_OnCommand(40015, 0)
    reagirl.UI_Element_ScrollToUIElement(BT1)
  elseif test==BT2 then
    reagirl.Gui_Close()
  --reagirl.UI_Element_Remove(EID)
  end
end

function CMenu(A,B)
  print2(A,B)
end

function input1(text)
  print2(text)
end

function input2()

end


function UpdateUI()
  reagirl.Gui_New()
  reagirl.Background_GetSetColor(true, 44,44,44)
  --reagirl.Background_GetSetImage("c:\\m.png", 1, 0, true, false, false)
  if update==true then
    retval, filename = reaper.GetUserFileNameForRead("", "", "")
    if retval==true then
      Images[1]=filename
    end
  end
  --reagirl.AddDummyElement()  
  reagirl.Label_Add("Export Podcast as:", -100, 88, 100, 100)
  --A= reagirl.CheckBox_Add(-280, 90, "MP3", "Export file as MP3", true, CheckMe)
  A1=reagirl.CheckBox_Add(-280, 110, "AAC", "Export file as AAC", true, CheckMe)
  --A2=reagirl.CheckBox_Add(-280, 130, "OPUS", "Export file as OPUS", true, CheckMe)

  --reagirl.FileDropZone_Add(-230,175,100,100, GetFileList)

  B=reagirl.Image_Add(Images[3], 100, 80, 100, 100, true, "Mespotine", "Mespotine: A Podcast Empress", UpdateImage2, {1})
  --reagirl.FileDropZone_Add(100,100,100,100, GetFileList)
  
--  reagirl.Label_Add("Stonehenge\nWhere the demons dwell\nwhere the banshees live\nand they do live well:", 31, 15, 0, "everything under control")
  reagirl.InputBox_Add(10,10,100,"Inputbox Deloxe", "Se descrizzione", "TExt", input1, input2)
--  E=reagirl.DropDownMenu_Add(80, -70, 100, "DropDownMenu:", "Desc of DDM", 5, {"The", "Death", "Of", "A", "Party                  Hardy Hard Scooter Hyper Hyper How Much Is The Fish",2,3,4,5}, DropDownList)
  reagirl.Line_Add(10,250,120, 200,1,1,0,1)

  
  --D=reagirl.Image_Add(reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/export_logo.png", 1, 1, 79, 79, false, "Logo", "Logo 2")  
  --D1=reagirl.Image_Add(reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/headertxt_export.png", 70, 10, 79, 79, false, "Headtertext", "See internet for more details")  
  
  
  --C=reagirl.Image_Add(Images[2], -230, 175, 100, 100, true, "Contrapoints", "Contrapoints: A Youtube-Channel")
  reagirl.Rect_Add(-400,-200,-10,120,0.5,0.5,0.5,0.5,1)
  --reagirl.Line_Add(0,43,-1,43,1,1,1,0.7)
  

--  BT1=reagirl.Button_Add(920, 400, 0, 0, "Export Podcast", "Will open the Render to File-dialog, which allows you to export the file as MP3", click_button)
  
--  BT2=reagirl.Button_Add(85, 50, 0, 0, "Close Gui", "Description of the button", click_button)
--  BT2=reagirl.Button_Add(285, 50, 0, 0, "✏", "Edit Marker", click_button)
  
  for i=1, 5 do
    reagirl.Button_Add(85+1*i, 30+50*i, 0, 0, i.." HUCH", "Description of the button", click_button)
  end
  --reagirl.ContextMenuZone_Add(10,10,120,120,"Hula|Hoop", CMenu)
  --reagirl.ContextMenuZone_Add(-120,-120,120,120,"Menu|Two|>And a|half", CMenu)
  --]]
  
end

Images={reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/soundcheck_logo.png","c:\\f.png","c:\\m.png"}
reagirl.Gui_Open("Faily", "A Failstate Manager", nil,100,reagirl.DockState_Retrieve("Stonehenge"),nil,nil)
UpdateUI()
--reagirl.Window_ForceSize_Minimum(320, 20)
--reagirl.Window_ForceSize_Maximum(640, 77)
--reagirl.Gui_ForceRefreshState=true
--main()

local reagirl=reagirl
main()


--Element1={reagirl.UI_Element_GetSetRunFunction(4, true, print2)}
--Element1={reagirl.UI_Element_GetSetAllVerticalOffset(true, 100)}
--print2("Pudeldu")

--reagirl.UI_Element_GetFocusedRect()

