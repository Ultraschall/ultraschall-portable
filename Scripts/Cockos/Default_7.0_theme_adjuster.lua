-- Copyright (C) 2015 and onward Cockos Inc
-- LICENSE: LGPL v2 or later - http://www.gnu.org/licenses/lgpl.html

sTitle = 'Default 7.0 Theme Adjuster'
scriptVersion = 240503
reaper.ClearConsole()

OS = reaper.GetOS()
script_path = ({reaper.get_action_context()})[2]:match('^.*[/\\]'):sub(1,-2)
themes_path = reaper.GetResourcePath() .. "/ColorThemes"
activePage = reaper.GetExtState(sTitle,'activePage') 
chosenPalette = reaper.GetExtState(sTitle,'chosenPalette') 
if not chosenPalette or chosenPalette == "" then chosenPalette = "REAPER" end

gfx.ext_retina = 1
temporary_framebuffer = 9

gfx.init(sTitle,
tonumber(reaper.GetExtState(sTitle,"wndw")) or 900,
tonumber(reaper.GetExtState(sTitle,"wndh")) or 600,
tonumber(reaper.GetExtState(sTitle,"dock")) or 0,
tonumber(reaper.GetExtState(sTitle,"wndx")) or 100,
tonumber(reaper.GetExtState(sTitle,"wndy")) or 50)

  ---------- COLOURS -----------
  
function setCol(col)
  if col[1] and col[2] and col[3] then
    local r = col[1] / 255
    local g = col[2] / 255
    local b = col[3] / 255
    local a = 1
    if col[4] ~= nil then a = col[4] / 255 end
    gfx.set(r,g,b,a)
  else
    gfx.a = 1
  end
end

function fromRgbCol(c)
  local r,g,b,a = c[1]/255, c[2]/255, c[3]/255, 1
  if c[4] ~= nil then a = c[4] / 255 end
  return {r,g,b,a}
end

function getProjectCustCols()
  projectCustCols = {}
  for i=0, reaper.CountTracks(0)-1 do
    local c = reaper.GetTrackColor(reaper.GetTrack(0, i))
    if c ~= 0 then
      local r,g,b = reaper.ColorFromNative(c)
      table.insert(projectCustCols,{r,g,b})
    end
  end
end

function compositeCols(c1, c2, s) 
  -- composite c2 over c1 with strength s (0-1). Ignores opacity in c1, c2.
  local r = (1-s)*c1[1] + s*c2[1]
  local g = (1-s)*c1[2] + s*c2[2]
  local b = (1-s)*c1[3] + s*c2[3]
  return {r,g,b}
end

function getCustCol(track)
  local c = reaper.GetTrackColor(reaper.GetTrack(0, track))
  if c == 0 then return nil end
  return reaper.ColorFromNative(c)
end

function setCustCol(track, r,g,b)
  reaper.SetTrackColor(reaper.GetTrack(0, track),reaper.ColorToNative(r,g,b))
end

function applyCustCol(col)
  if type(col) ~= "table" or #col < 3 then return end
  reaper.Undo_BeginBlock()
  for i=0, reaper.CountTracks(0)-1 do
    if reaper.IsTrackSelected(reaper.GetTrack(0, i)) then
      setCustCol(i, table.unpack(col))
    end
  end
  reaper.Undo_EndBlock('custom color changes',-1)
end

function addRandPalette(pal, curpal)
  local pass = math.floor(#pal/#curpal)
  local offs, adj, wadj = #pal, math.floor((pass+2)/3), 1 + (pass%3)
  for i = 1, #curpal do
    local a = { table.unpack(curpal[i]) }
    if a[wadj] > 128 then a[wadj] = math.max(a[wadj] - adj,0) else a[wadj] = math.min(a[wadj] + adj,255) end
    pal[#pal+1] = a
  end
  for i = #curpal, 2, -1 do
    local j = math.random(i)+offs
    pal[offs+i], pal[j] = pal[j], pal[offs+i]
  end
end

function applyPalette() 
  local curpal = palette[chosenPalette]
  local randpal = {}

  reaper.Undo_BeginBlock()
  local cnt, colmap = 1, {}
  for i = 0, reaper.CountTracks(0)-1 do
    local r, g, b = getCustCol(i)
    if b ~= nil then
      local colkey = (r<<16)|(g<<8)|b
      if colmap[colkey] == nil then
        if cnt > #randpal then
          addRandPalette(randpal,curpal)
        end
        colmap[colkey] = cnt
        cnt = cnt + 1
      end
      local wc=colmap[colkey]
      setCustCol(i, table.unpack(randpal[wc]))
    end
  end
  reaper.Undo_EndBlock('Recolor using palette',-1)
end

c_ReadoutGreen = {0,128,85,255}
c_GreenUnlit = {38,102,76,255}
c_GreenLit = {0,254,149,255}
c_CyanGrey = {129,137,137,255}
c_Grey10 = {26,26,26,255}
c_Grey15 = {38,38,38,255}
c_Grey20 = {51,51,51,255}
c_Grey25 = {64,64,64,255}
c_Grey33 = {84,84,84,255}
c_Grey50 = {128,128,128,255}
c_Grey60 = {153,153,153,255}
c_Grey66 = {168,168,168,255}
c_Grey70 = {179,179,179,255} 
c_Grey80 = {204,204,204,255} 

labelColMO, labelColMA, readoutColMO, readoutColMA = c_Grey80, c_Grey60, {0,204,136,255}, c_Grey20

palette = {
  REAPER = {{84,84,84},{105,137,137},{129,137,137},{168,168,168},{19,189,153},{51,152,135},{184,143,63},{187,156,148},{134,94,82},{130,59,42}},
  PRIDE = {{84,84,84},{138,138,138},{155,55,55},{155,129,55},{105,155,55},{55,155,81},{55,155,155},{55,81,155},{105,55,155},{155,55,129}},
  WARM = {{128,67,64},{184,82,46},{239,169,81},{230,204,143},{231,185,159},{208,193,180},{176,177,161},{108,120,116},{128,114,98},{97,87,74}},
  COOL = {{35,75,84},{58,79,128},{95,88,128},{92,102,112},{67,104,128},{91,125,134},{95,92,85},{131,135,97},{55,118,94},{75,99,32}},
  VICE = {{255,0,111},{255,89,147},{254,152,117},{255,202,193},{249,255,168},{122,242,178},{87,255,255},{51,146,255},{168,117,255},{99,77,196}},
  EEEK = {{255,0,0},{255,111,0},{255,221,0},{179,255,0},{0,255,123},{0,213,255},{0,102,255},{93,0,255},{204,0,255},{255,0,153}},
  CASABLANCA = {{166,42,0},{252,65,0},{252,114,28},{130,42,42},{156,81,50},{255,197,90},{148,134,108},{32,87,145},{65,91,128},{0,33,92}},
  CHAUFFEUR = {{239,185,38},{153,91,0},{66,66,65},{119,120,120},{69,92,94},{59,77,92},{51,65,91},{41,49,97},{35,38,102},{97,45,74}},
  SPLIT = {{255,0,64},{156,1,79},{129,22,74},{113,34,71},{96,47,68},{67,51,99},{49,49,104},{29,46,109},{0,39,107},{0,85,255}}
}


  ---------- TEXT -----------

textPadding = 6

if OS:find("Win") ~= nil then

  gfx.setfont(1, "Calibri", 13)
  gfx.setfont(2, "Calibri", 15)
  gfx.setfont(3, "Calibri", 18)
  gfx.setfont(4, "Calibri", 22)
  
  gfx.setfont(5, "Calibri", 19)
  gfx.setfont(6, "Calibri", 22)
  gfx.setfont(7, "Calibri", 27)
  gfx.setfont(8, "Calibri", 33)
  
  gfx.setfont(9, "Calibri", 26)
  gfx.setfont(10, "Calibri", 30)
  gfx.setfont(11, "Calibri", 36)
  gfx.setfont(12, "Calibri", 44)
  
  baselineShift = {}

elseif OS == 'Other' then

  gfx.setfont(1, "Ubuntu", 10)
  gfx.setfont(2, "Ubuntu", 12)
  gfx.setfont(3, "Ubuntu", 14)
  gfx.setfont(4, "Ubuntu", 17)
  
  gfx.setfont(5, "Ubuntu", 13)
  gfx.setfont(6, "Ubuntu", 15)
  gfx.setfont(7, "Ubuntu", 20)
  gfx.setfont(8, "Ubuntu", 24)
  
  gfx.setfont(9, "Ubuntu", 19)
  gfx.setfont(10, "Ubuntu", 23)
  gfx.setfont(11, "Ubuntu", 28)
  gfx.setfont(12, "Ubuntu", 32)
  
  baselineShift = {}

else

  gfx.setfont(1, "Helvetica", 9)
  gfx.setfont(2, "Helvetica", 11)
  gfx.setfont(3, "Helvetica", 14)
  gfx.setfont(4, "Helvetica", 16)
  
  gfx.setfont(5, "Helvetica", 13)
  gfx.setfont(6, "Helvetica", 15)
  gfx.setfont(7, "Helvetica", 18)
  gfx.setfont(8, "Helvetica", 22)
  
  gfx.setfont(9, "Helvetica", 18)
  gfx.setfont(10, "Helvetica", 20)
  gfx.setfont(11, "Helvetica", 26)
  gfx.setfont(12, "Helvetica", 30)
  
  baselineShift = {2,2,2,3,
                   1,3,4,4,
                   3,2,3,3}
  
end

function translate(str)
  if type(str) == "string" and str ~= "" then
    local sec = "Default_7.0_Theme_Adjuster"
    if false then -- mode to dump localization strings
      if not __locdumper then
        local tab, lpage = { }, ""
        __locdumper = function(str)
          if not tab[str] and utf8.len(str)>1 then
            if next(tab) == nil then reaper.ShowConsoleMsg("[" .. sec .. "]\n") end
            if activePage ~= lpage then
              lpage = activePage
              reaper.ShowConsoleMsg("\n# " .. lpage .. "\n")
            end
            tab[str] = 1
            function fnv64(str)
              local h,l = 0xCBF29CE4, 0x84222325
              local c32 = function(a) assert(a < (1<<51)) return a&0xffffffff end
              for i=1,str:len()+1 do
                h = c32(c32(h*0x1B3) + c32(l*0x100) + c32((l*0x1B3)>>32))
                l = c32(l*0x1B3) ~ (i <= str:len() and str:byte(i) or 0)
              end
              return string.format("%08X%08X",h,l)
            end
            reaper.ShowConsoleMsg(";" .. fnv64(str) .. "=" ..
              str:gsub("\"","\\\""):gsub("\n","\\n"):gsub("\t","\\t"):gsub("\r","\\r") ..
                "\n")
          end
        end
      end
      __locdumper(str)
    end
    str = reaper.LocalizeString(str,sec)
  end
  return str
end

function text(str,x,y,w,h,align,col,style,lineSpacing,vCenter,wrap)
  local lineSpace = (lineSpacing or 11)*scaleMult
  setCol(col or {255,255,255})
  gfx.setfont(style or 1)
  str = translate(str)
  local lines = nil
  if wrap == true then lines = textWrap(str,w)
  else
    lines = {}
    for s in string.gmatch(str or '', "([^#]+)") do
      table.insert(lines, s)
    end
  end
  if vCenter ~= false and #lines > 1 then y = y - lineSpace/2 end
  for k,v in ipairs(lines) do
    gfx.x, gfx.y = x,y
    gfx.drawstr(v,align or 0,x+(w or 0),y+(h or 0))
    y = y + lineSpace
  end
end

function textWrap(str,w) -- returns array of lines
  local lines,curlen,curline,last_sspace = {}, 0, "", false
  -- already translated text
  -- enumerate words
  for s in str:gmatch("([^%s-/]*[-/]* ?)") do
    local sspace = false -- set if space was the delimiter
    if s:match(' $') then
      sspace = true
      s = s:sub(1,-2)
    end
    local measure_s = s
    if curlen ~= 0 and last_sspace == true then
      measure_s = " " .. measure_s
    end
    last_sspace = sspace

    local length = gfx.measurestr(measure_s)
    if length > w then
      if curline ~= "" then
        table.insert(lines,curline)
        curline = ""
      end
      curlen = 0
      while w>0 and  length>w do -- split up a long word, decimating measure_s as we go
        local wlen = string.len(measure_s) - 1
        while wlen > 0 do
          local sstr = string.format("%s%s",measure_s:sub(1,wlen), wlen>1 and "-" or "")
          local slen = gfx.measurestr(sstr)
          if slen <= w or wlen == 1 then
            table.insert(lines,sstr)
            measure_s = measure_s:sub(wlen+1)
            length = gfx.measurestr(measure_s)
            break
          end
          wlen = wlen - 1
        end
      end
    end
    if measure_s ~= "" then
      if curlen == 0 or curlen + length <= w then
        curline = curline .. measure_s
        curlen = curlen + length
      else -- word would not fit, add without leading space and remeasure
        table.insert(lines,curline)
        curline = s
        curlen = gfx.measurestr(s)
      end
    end
  end
  if curline ~= "" then
    table.insert(lines,curline)
  end
  return lines
end





  --------- IMAGES ----------
  
imgBufferOffset = 500  

function loadImage(idx, name)

  local i = idx 
  if i then
    local str = script_path.."/Default_7.0_theme_adjuster_images/"..name..".png"
    if OS:find("Win") ~= nil then str = str:gsub("/","\\") end
    if gfx.loadimg(i, str) == -1 then 
      --reaper.ShowConsoleMsg(str.." not found\n")
      logError(str..' not found', 'red') 
    end
  end
  
  -- look for pink
    gfx.dest = idx
    gfx.x,gfx.y = 0,0
    if isPixelPink(gfx.getpixel()) then --top left is pink
      local bufW,bufH = gfx.getimgdim(idx)
      gfx.x,gfx.y = bufW-1,bufH-1
      if isPixelPink(gfx.getpixel()) then --bottom right also pink
        local tx, ly, bx, ry = 0,0,0,0
        
        gfx.x,gfx.y = 0,0 
        while isPixelPink(gfx.getpixel()) do
          tx = math.floor(gfx.x+1)
          gfx.x = gfx.x+1
        end
        
        gfx.x,gfx.y = 0,0
        while isPixelPink(gfx.getpixel()) do
          ly = math.floor(gfx.y+1)
          gfx.y = gfx.y+1
        end
        
        gfx.x,gfx.y = bufW-1,bufH-1 
        while isPixelPink(gfx.getpixel()) do
          bx = math.floor(bufW - gfx.x)
          gfx.x = gfx.x-1
        end
        
        gfx.x,gfx.y = bufW-1,bufH-1 
        while isPixelPink(gfx.getpixel()) do
          ry = math.floor(bufH - gfx.y)
          gfx.y = gfx.y-1
        end
        
        --reaper.ShowConsoleMsg(name..' top x pink = '..tx..', left y pink = '..ly..', bottom x pink = '..bx..', right y pink = '..ry..'\n')
        bufferPinkValues[idx] = {tx=tx, ly=ly, bx=bx, ry=ry} -- apparently lua understands this, nice
        
      end
    end
  
end

function isPixelPink(r,g,b) 
  if (r==1 and g==0 and b==1) or (r==1 and g==1 and b==0) then -- yellow is also pink. The world's a weird place.
    return true 
  else return false 
  end 
end

function getImage(img)
  if imageIndex == nil then imageIndex = {} end
  for i,v in pairs(imageIndex) do
    if i==img then return v end
  end
  
  --not already in a buffer, make a new one
  local buf = nil
  local i = imgBufferOffset
  while buf == nil do -- find the next empty buffer and assign
    local h,w = gfx.getimgdim(i)
    if h==0 and w==0 then buf=i end
    i = i+1
  end
  imageIndex[img] = buf
  --reaper.ShowConsoleMsg('image: '..img..' to '..buf..'\n')
  loadImage(buf, img)  
  return buf
end

function pinkBlit(img, srcx, srcy, destx, desty, tx, ly, bx, ry, unstretchedC2W, unstretchedR2H, stretchedC2W, stretchedR2H)
  gfx.blit(img, 1, 0, srcx +1, srcy +1, tx-1, ly-1, destx, desty, tx-1, ly-1)
  gfx.blit(img, 1, 0, srcx +tx, srcy +1, unstretchedC2W, ly-1, destx+tx-1, desty, stretchedC2W, ly-1)
  gfx.blit(img, 1, 0, srcx +tx +unstretchedC2W, srcy +1, bx-1, ly-1, destx+tx-1+stretchedC2W, desty, bx-1, ly-1)
  
  gfx.blit(img, 1, 0, srcx+1, ly, tx-1, unstretchedR2H, destx, desty+ly-1, tx-1, stretchedR2H)
  gfx.blit(img, 1, 0, srcx +tx, ly, unstretchedC2W, unstretchedR2H, destx+tx-1, desty+ly-1, stretchedC2W, stretchedR2H)
  gfx.blit(img, 1, 0, srcx +tx +unstretchedC2W, ly, bx-1, unstretchedR2H, destx+tx-1+stretchedC2W, desty+ly-1, bx-1, stretchedR2H)
  
  gfx.blit(img, 1, 0, srcx+1, ly +unstretchedR2H, tx-1, ry-1, destx, desty+ly-1+stretchedR2H, tx-1, ry-1)
  gfx.blit(img, 1, 0, srcx +tx, ly +unstretchedR2H, unstretchedC2W, ry-1, destx+tx-1, desty+ly-1+stretchedR2H, stretchedC2W, ry-1)
  gfx.blit(img, 1, 0, srcx +tx +unstretchedC2W, ly +unstretchedR2H, bx-1, ry-1, destx+tx-1+stretchedC2W, desty+ly-1+stretchedR2H, bx-1, ry-1)
end

function reloadImgs()
  for b in ipairs(els) do -- iterate blocks 
    for z in ipairs(els[b]) do -- iterate z
      if els[b][z] ~= nil then
        for j,k in pairs(els[b][z]) do
          k:reloadImg()
        end
      end
    end
    doArrange = true
  end
end

function imageOnOffSuffix(img, suffix)
  local imageRoot = string.sub(img, 1, #img - string.find(string.reverse(img), "_"))
  --reaper.ShowConsoleMsg('suffix: '..suffix..' to image root : '..imageRoot..' \n')
  return imageRoot..suffix
end





  --------- OBJECTS ----------

needing_updates = { }
needing_fps = { }
function addNeedUpdate(d, noUserEdit) -- if not in response to a user-edit, noUserEdit should be true
  if noUserEdit ~= true and d.onValueEdited then
    d:onValueEdited()
  end
  if d.onUpdate then
    needing_updates[d] = 1
  end
end

els = {}
function AddEl(o)
  if o.x == nil and o.y == nil and o.updateOn == nil and o.action == nil then --just a proto
  else
    if o.parent then  adoptChild(o.parent, o) end
    if belongsToPage ~= nil then o.belongsToPage = belongsToPage end
    if o.block == nil then if o.parent and o.parent.block then o.block = o.parent.block  end end-- no block specified, inherit from parent
    if o.z == nil then if o.parent and o.parent.z then o.z = o.parent.z  end end -- no z specified, inherit from parent
    if els[o.block] == nil then els[o.block] = {} end
    if els[o.block][o.z] == nil then els[o.block][o.z] = {o}
    else els[o.block][o.z][#els[o.block][o.z]+1] = o
    end
  end
end

El = {}
function El:new(o)
  local o = o or {}
  if o.interactive == nil then o.interactive = true end
  if belongsToPage ~= nil then o.belongsToPage = belongsToPage end
  self.__index = self
  AddEl(o)
  setmetatable(o, self)
  return o
end

Block = {}
function Block:new(o)
  local o = o or {}
  if els == nil then els = {} end
  els[#els+1] = o
  self.__index = self
  setmetatable(o, self)
  return o
end

function doVerticalScroll(block, prevy, yo)
  local tc = els[block]

  local elx, ely = (tc.drawX or 0),  (tc.drawY or 0)
  local elw, elh = (tc.drawW or 0),  (tc.drawH or 0)

  gfx.set(0,0,0,1,2,temporary_framebuffer)
  gfx.blit(-1,1,0, elx, ely, elw, elh, 0,0, elw,elh) -- copy existing view to temp buffer
  gfx.dest = -1

  local dy = yo - prevy
  local xo = tc.scrollX or 0
  if dy > 0 and dy < elh then
    -- scrolling down, can reuse some pixels, and render new pixels at the top
    -- dy is height of the slice at the top that will need rerender
    gfx.blit(temporary_framebuffer, 1,0,  0, dy, elw, elh - dy, elx, ely, elw, elh - dy)
    includeInDirtyZone(block,xo,yo + elh - dy,elw,dy)
  elseif dy < 0 and dy > -elh then
    -- scrolling up, can reuse some pixels, and render some new pixels at the bottom
    dy = -dy  -- dy is the height of slice along the bottom that will need rerender
    gfx.blit(temporary_framebuffer, 1,0,  0, 0, elw, elh - dy, elx, ely + dy, elw, elh - dy)
    includeInDirtyZone(block,xo,yo,elw,dy)
  elseif dy ~= 0 then
    -- redraw everything
    includeInDirtyZone(block,xo,yo,elw,elh)
  end
end

ScrollbarV = El:new{} 
function ScrollbarV:new(o)
  o.col = {40,40,40}
  o.w = 16 * scaleMult
  o.interactive=false
  self.__index = self
  AddEl(o)

  o.children = { El:new({parent=o, z=2, x=1, y=0, w=14, h=0, mouseOverCursor='tcp_resize',
    img='scrollbar_v', iType = 3,
    
    onNewValue = function(k)
      local blockH = els[o.scrollbarOfBlock].h * scaleMult
      els[o.block][2][1].y = math.floor((els[o.scrollbarOfBlock].scrollY or 0) *
        (blockH / ((els[o.scrollbarOfBlock].scrollableH or 1) * scaleMult)))
      doArrange = true
    end,
    
    onArrange = function()
      local blockH = els[o.scrollbarOfBlock].h * scaleMult
      if els[o.scrollbarOfBlock].scrollableH and els[o.scrollbarOfBlock].scrollableH > blockH then
        o.children[1].h = math.floor(blockH * (blockH / (els[o.scrollbarOfBlock].scrollableH * scaleMult)))
      else o.children[1].h = 0
      end
      els[o.block][2][1]:onNewValue()
    end,
    onDrag = function(dX, dY)
      local blockH = els[o.scrollbarOfBlock].h * scaleMult
      local dX, dY = scaleMult*dX, scaleMult*dY
      if els[o.scrollbarOfBlock].scrollY and dY == 0 then 
        els[o.scrollbarOfBlock].initScrollY = els[o.scrollbarOfBlock].scrollY 
      end
      --  drag pixels as a % of scrollbar height, multiplied by total scrollable height, plus initial scrollY
      local scrollVal = (dY/blockH)*els[o.scrollbarOfBlock].scrollableH + (els[o.scrollbarOfBlock].initScrollY or 0)
      
      if scrollVal > (els[o.scrollbarOfBlock].scrollableH - blockH) then
        scrollVal = els[o.scrollbarOfBlock].scrollableH - blockH
      end
      scrollVal = math.floor(math.max(scrollVal,0))
      local prevVal = els[o.scrollbarOfBlock].scrollY
      if prevVal ~= scrollVal then
        els[o.scrollbarOfBlock].scrollY = scrollVal
        els[o.block][2][1]:onNewValue()
        doVerticalScroll(o.scrollbarOfBlock, prevVal, scrollVal)
      end
    end,
    
    onMouseWheel = function(wheel_amt_unscaled)
      local wheel_amt = wheel_amt_unscaled * scaleMult * 2
      local blockH = els[o.scrollbarOfBlock].h * scaleMult
      local scrollVal = els[o.scrollbarOfBlock].scrollY - (wheel_amt*5)
      if scrollVal > (els[o.scrollbarOfBlock].scrollableH - blockH) then
        scrollVal = els[o.scrollbarOfBlock].scrollableH - blockH
      end
      scrollVal = math.floor(math.max(scrollVal,0))
      local prevVal = els[o.scrollbarOfBlock].scrollY
      if prevVal ~= scrollVal then
        els[o.scrollbarOfBlock].scrollY = scrollVal
        els[o.block][2][1]:onNewValue()
        doVerticalScroll(o.scrollbarOfBlock, prevVal, scrollVal)
      end
    end,
    
    onGfxResize = function() 
      o.h = gfx.h
      addNeedUpdate(o, true)
      o:addToDirtyZone()
    end
    
    }) }
    
  setmetatable(o, self)
  return o
end

MiscAgent = El:new{} 
function MiscAgent:new(o)
  self.__index = self
  if o.target then addAgent(o) end
  o.onMouseOver = function()
    if target and target.onMouseOver then target:onMouseOver() end
  end
  o.onMouseAway = function()
    if target and target.onMouseAway then target:onMouseAway() end
  end
  AddEl(o)
  setmetatable(o, self)
  return o
end


Button = El:new{} 
function Button:new(o)
  self.__index = self
  local target = o.target or o.parent
  o.parent = o.parent or o.target.parent
  if o.target then addAgent(o) end
  
  if o.onMouseOver then o:onMouseOver() else
    o.onMouseOver = function()
      if target.onMouseOver then target:onMouseOver() end
    end
  end
  if o.onMouseAway then o:onMouseAway() else
    o.onMouseAway = function()
      if target.onMouseAway then target:onMouseAway() end
    end
  end
  
  if o.text and o.img == nil and o.imgOff == nil and col == nil and o.children == nil then           -- then its a text button
    if target.buttonOffStyle then 
      o.col, o. mouseOverCol, o.text.col = target.buttonOffStyle.col, target.buttonOffStyle.mouseOverCol, target.buttonOffStyle.textCol or {150,255,150} 
    end
    if o.text then o.text.style, o.text.align = o.text.style or 2, o.text.align or 5 end
    if o.w == nil then
      gfx.setfont(o.text.style)
      o.w = gfx.measurestr(translate(o.text.str)) + textPadding + textPadding
    end
  end
  
  o.onNewValue=function(k)
    if o.imgOn and o.target.paramV then
      if o.imgOff==nil then o.imgOff = o.img end
      if (o.target.paramV==1 and o.img~=o.imgOn) or (o.target.paramV==0 and o.img~=o.imgOff) or o.target.paramError then
        if o.target.paramV==1 then o.img = o.imgOn else o.img=o.imgOff end
        if o.target.paramError then o.col={255,0,0} end
        o.imgIdx = nil
        o.isDirty = true
        doArrange = true
      end
      if (o.value and o.target.paramV==o.value and o.img~=o.imgOn) or (o.value and o.target.paramV~=o.value and o.img~=o.imgOff) then 
        if o.target.paramV==o.value then o.img = o.imgOn else o.img=o.imgOff end
        o.imgIdx = nil
        o.isDirty = true
        doArrange = true
      end
    end
    
    if o.children then for i,v in pairs(o.children) do
        if v.onNewValue then v:onNewValue() end
    end end
    
  end
  
  if not o.onClick then
    o.onClick = function()
      if target.controlType == 'themeParam' then
        if o.action then
          local v = 0
          if o.action == 'increment' then v = target.paramV + 1 end
          if o.action == 'decrement' then v = target.paramV - 1 end
          target.paramV = math.Clamp(v,target.paramVMin,target.paramVMax)
        else
          local v = target.paramV or 0
          if v==0 then target.paramV = 1    
          else target.paramV = 0 
          end
        end
        --reaper.ShowConsoleMsg(o.parent.paramDesc..', image: :'..o.img..',   value is now:'..o.parent.paramV..'\n')
        addNeedUpdate(target)
        o:addToDirtyZone()
      end
      
      if target.onClick then target.onClick(o) end -- need to let the target know which button was clicked
      
      if target.scriptAction then target.scriptAction(o) end
      
      if type(target.param) == 'table' and type(target.param[1]) == 'boolean' then
        target.param[1] = not target.param[1]
        addNeedUpdate(target)
      end
      
      if target.controlType == 'reaperActionToggle' then
        reaper.Main_OnCommand(target.param, 0)
        addNeedUpdate(target)
      end
      
      o.imgIdx = nil
      doArrange = true
    end
    
  end
  o.z = o.z or 2
  AddEl(o)
  o.iType= 3
  setmetatable(o, self)
  return o
end





Knob = El:new{} 
function Knob:new(o)
  self.__index = self
  o.z = o.z or 2
  AddEl(o)
  local target = o.target or o.parent
  if o.target then addAgent(o) end
  o.onMouseOver = function()
    if target.onMouseOver then target:onMouseOver() end
  end
  o.onMouseAway = function()
    if target.onMouseAway then target:onMouseAway() end
  end
  o.onMouseWheel = function(wheel_amt)
    if target.paramV then 
      target.paramV = target.paramV + wheel_amt 
      if target.paramVMax and target.paramVMin then
        if target.paramV > target.paramVMax then target.paramV = target.paramVMax end
        if target.paramV < target.paramVMin then target.paramV = target.paramVMin end
      end
    end
    addNeedUpdate(target)
    target:addToDirtyZone()
  end
  
  if o.img then o.iType='stack' end
  o.paramV, o.paramVMin, o.paramVMax = o.paramV or 0, target.remapToMin or o.paramVMin or target.paramVMin or 0, target.remapToMax or o.paramVMax or target.paramVMax or 0
  o.onDrag = function(dX, dY)
    local scrollVal = dX - dY 
    if scrollVal == 0 then o.initDragParamV = target.paramV end
    o.paramV = math.floor(math.Clamp((o.initDragParamV or 0) + scrollVal, o.paramVMin, o.paramVMax))
    target.paramV = o.paramV
    addNeedUpdate(target)
    o:addToDirtyZone()
  end
  o.onDoubleClick = function()
    target.paramV =remapParam(target.paramVDef, target.paramVMin, target.paramVMax, target.remapToMin or target.paramVMin, target.remapToMax or target.paramVMax)
    addNeedUpdate(target)
    o:addToDirtyZone()
  end
  o.onNewValue=function(k)
    if o.img then
      local vMin, vMax = target. remapToMin or target.paramVMin, target. remapToMax or target.paramVMax
      o.iFrame = math.floor((target.paramV - vMin) / (vMax - vMin) * ((o.iFrameC or 1)-1))
      o:addToDirtyZone()
    end
  end
  setmetatable(o, self)
  return o
end


Stalk = El:new{} 
function Stalk:new(o)
  self.__index = self
  o.z = o.z or 2
  AddEl(o)
  local target = o.target or o.parent
  if o.target then addAgent(o) end
  
  MiscAgent:new({parent=o, target=o.target, x=0, y=0, w=42, h=42, interactive = false,
    onNewValue = function(k)
      local v = (k.target.paramV - k.target.paramVMin)/(k.target.paramVMax - k.target.paramVMin) * 1.5*math.pi + 0.25*math.pi  -- remapParam with the niceties removed
      local v1 = v%(math.pi/2)
      local segs = math.floor(v/(math.pi/2))
      local v2 = math.pi - (math.pi/4) - v1
      local varC = 16*sqrt2 * (math.sin(v1) / math.sin(v2))
      k.children[1].col, k.children[2].col, k.children[3].col, k.children[4].col = c_GreenUnlit, c_GreenUnlit, c_GreenUnlit, c_GreenUnlit
      if segs == 0 then 
        k.children[5].coords[2], k.children[5].coords[3] = {-16,16}, {-16, 16-varC} 
      end
      if segs>=1 then
        k.children[1].col = c_GreenLit
        k.children[5].coords[2], k.children[5].coords[3] = {-16,-16}, {-16+varC, -16} 
      end
      if segs>=2 then
        k.children[2].col = c_GreenLit
        k.children[5].coords[2], k.children[5].coords[3] = {16,-16}, {16,-16+varC} 
      end
      if segs>=3 then 
        k.children[3].col = c_GreenLit
        k.children[5].coords[2], k.children[5].coords[3] = {16,16}, {16-varC,16} 
      end
      k.isDirty=true
    end
    })
    
  El:new({parent=o.children[1], x=26, y=16, w=42, h=42, shape='poly', coords={{0,0}, {-16,16}, {-16,-16} }, interactive=false }) 
  El:new({parent=o.children[1], x=26, y=16, w=42, h=42, shape='poly', coords={{0,0}, {-16,-16}, {16,-16} }, interactive=false })
  El:new({parent=o.children[1], x=26, y=16, w=42, h=42, shape='poly', coords={{0,0}, {16,-16}, {16,16} }, interactive=false })
  El:new({parent=o.children[1], x=26, y=16, w=42, h=42, shape='poly', coords={{0,0}, {16,16}, {-16,16} }, interactive=false }) 
  El:new({parent=o.children[1], x=26, y=16, w=42, h=42, shape='poly', coords={{0,0}, {-16,16}, {-16,-16} }, col=c_GreenLit, interactive=false }) 
  
  MiscAgent:new({parent=o, x=0, y=0, img='arcStalk_closed',target=o.target, iType=1, 
    doOnMouseOver = function(k)
      k.img='arcStalk'
      k:reloadImg()
      k.isDirty = true
    end,
    doOnMouseAway = function(k)
      k.img='arcStalk_closed'
      k:reloadImg()
      k.isDirty = true
    end })  
  Knob:new({parent=o, target=o.target, x=10, y=0, w=32, h=32})
  
  o.label = Label:new({parent=o, x=50, y=-2, z=2, w=60, h=20, target=o.target, 
    text={str=o.target.desc, style=2, align=0, col=labelColMA, padding=0, resizeToFit=true, mouseOverCol=labelColMO, mouseAwayCol=labelColMA } })
  
  MiscAgent:new({parent=o, target=o.target, x=34, y=16, w=0, r={toEdge, o.label, 'right'}, h=1, col=c_Grey33, interactive = false,  
    doOnMouseOver = function(k)
      k.x=50
      k.col=c_Grey50
      k.isDirty = true
      doArrange = true
    end,
    doOnMouseAway = function(k)
      k.x=34
      k.col=c_Grey33
      k.isDirty = true
      doArrange = true
    end })
  
  Readout:new({parent=o, x=50, y=-2, z=2, w=60, h=20, flow=true, target=o.target, col={255,0,0,0},
    text={str='0.00', style=4, align=0, col=readoutColMA, padding=0, resizeToFit=true},  
    doOnMouseOver = function(k)
      k.text.col=readoutColMO
      k:addToDirtyZone()
    end,
    doOnMouseAway = function(k)
      k.text.col=readoutColMA
      k:addToDirtyZone()
    end
    })
    
  MiscAgent:new({parent=o, x=1, y=0, w=60, h=20, z=2, flow=true, col={150,255,0,0}, target=o.target, text={str=o.target.units, style=1, align=8, col=readoutColMA, padding=0, resizeToFit=true},
    doOnMouseOver = function(k)
      k.text.col=readoutColMO
      k:addToDirtyZone()
    end,
    doOnMouseAway = function(k)
      k.text.col=readoutColMA
      k:addToDirtyZone()
    end,
    onNewValue = function(k)
      local p = nil
      if k.target.valueAlias then
        if k.target.valueAlias[k.target.paramV] then p = '' end -- aliased values (e.g. 'knob') are assumed to have no unit
      end
      k.text.str = p or k.target.units
      gfx.setfont(k.text.style)
      k.w=gfx.measurestr(translate(k.text.str))
      k:addToDirtyZone()
    end })
  
  setmetatable(o, self)
  return o
end


ToggleButton = El:new{} 
function ToggleButton:new(o)
  self.__index = self
  o.z = o.z or 2
  o.h = 26
  AddEl(o)
  --o.col= {255,0,150,100}
  local controller = o.target or Controller:new({parent=o, x=0, y=0, w=0, h=0, controlType=o.controlType, param=o.param or nil, 
      paramDesc = o.paramDesc or nil, units = o.units or nil, desc=o.desc or nil })
  Button:new({parent=o, x=6, y=2, flow=true, style='button', target=controller, img='button_off', imgOn='button_on', iType=3 })
  Label:new({parent=o, x=4, y=4, w=60, h=20, flow=true, target=controller, 
    text={str=controller.desc or '', style=2, align=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO } })
  setmetatable(o, self)
  return o
end


tcpVisFlagRow = El:new{} 
function tcpVisFlagRow:new(o)
  self.__index = self
  AddEl(o)
  local target = o.target or o.parent
  if o.target then addAgent(o) end
  o.x, o.y, o.w, o.h = 89, o.y or 0, 410, 28
  
  if o.rowStyle == 'odd' then o.buttonOffStyle, o.buttonOnStyle = tcpVisflagTableOddRowStyle.buttonOffStyle, tcpVisflagTableOddRowStyle.buttonOnStyle end
  if o.rowStyle == 'even' then o.buttonOffStyle, o.buttonOnStyle = tcpVisflagTableEvenRowStyle.buttonOffStyle, tcpVisflagTableEvenRowStyle.buttonOnStyle end
  
  if target.rowControllers == nil then target.rowControllers = {} end
  target.rowControllers[o.paramDesc] = Controller:new({parent=o.parent, x=0, y=0, w=1, h=0, paramDesc = o.paramDesc, values={0,0,0,0}, 
    buttonOffStyle=o.buttonOffStyle, buttonOnStyle=o.buttonOnStyle,
      onUpdate = function(k)
        local flagMults = {1,2,4,8}
        local retval, desc, value, defValue, minValue, maxValue = reaper.ThemeLayout_GetParameter(paramIdxGet(o.paramDesc))
        for t, flag in pairs(flagMults) do
          if value & flag ~= 0 then k.values[t] = -1 -- bit is on
          else k.values[t] = 0 -- bit is off
          end
        end
        for i,b in pairs(k.agents) do
          b:onNewValue()
        end
      end
      })
  for i=1,4 do 
    local b = Button:new({parent = o, x=2, y=0, w=100, h=28, flow=true, controlType = 'visFlag', valIdx = i, target=target.rowControllers[o.paramDesc], text={str=''},
        onClick = function(k)
          local flagMults = {1,2,4,8}
          k.target.values[k.valIdx] = ~ k.target.values[k.valIdx];
          local pVal = 0
          for l,m in pairs(k.target.agents) do
            if k.target.values[l]~=0 then
              pVal = pVal + flagMults[l]
            end
          end
          paramSet(paramIdxGet(o.paramDesc),pVal)
          for i,b in pairs(k.target.agents) do
            b:onNewValue()
          end
        end
    })
      
      -- you are 1-3 and hidden and 4 is not hidden : HIDE
      -- you are 1-3 and not hidden and 4 is not hidden : SHOW
      -- you are 1-3 and 4 is hidden : ALWAYS HIDE
      -- you are 4 and not hidden : ALWAYS HIDE
      -- you are 4 and hidden : HIDE
      
      El:new({parent = b, x=24, y=9, w=18, img='hide', imgOn='show', iType=1, interactive=false,
        onNewValue = function(v)
          local val = v.parent.target.values[v.parent.valIdx]
          local redrawChanges = false 
          if i<4 and val~=0 and v.parent.target.values[4]==0 and v.img~='hide' then v.x, v.img, redrawChanges = 24, 'hide', true  end
          if i<4 and val==0 and v.parent.target.values[4]==0 and v.img~='show' then v.x, v.img, redrawChanges = 39, 'show', true end 
          if i<4 and v.parent.target.values[4]~=0 and v.img~='always_hide_on' then v.x, v.img, redrawChanges = 39, 'always_hide_on', true end 
          if i==4 and val==0 and v.img~='always_hide' then v.x, v.img, redrawChanges = 39, 'always_hide', true end 
          if i==4 and val~=0 and v.img~='always_hide_on' then v.x, v.img, redrawChanges = 24, 'always_hide_on', true end 
          if redrawChanges==true then v.imgIdx, v.isDirty, doArrange = nil, true, true end 
          if v.parent.target.paramError then v.w, v.isDirty, doArrange = 0, nil, true, true end -- param error
        end })
        
      El:new({parent = b, x=0, y=-4, w=50, h=20, flow=true, text={style=2, align=4, str='HIDE', col=o.buttonOnStyle.textCol}, col={255,0,0,0}, interactive=false,
        onNewValue = function(v)
          local val = v.parent.target.values[v.parent.valIdx] 
          local redrawChanges = false 
          if i<4 and val~=0 and v.parent.target.values[4]==0 and v.text.str~='HIDE' then v.text.str, redrawChanges = 'HIDE', true end 
          if i<4 and val==0 and v.parent.target.values[4]==0 and v.text.str~='' then v.text.str, redrawChanges = '', true end 
          if i<4 and v.parent.target.values[4]~=0 and v.text.str~='' then v.text.str, redrawChanges = '', true end 
          if i==4 and val==0 and v.text.str~='' then v.text.str, redrawChanges = '', true end 
          if i==4 and val~=0 and v.text.str~='HIDE' then v.text.str, redrawChanges = 'HIDE', true end 
          if v.parent.target.paramError then v.x, v.text.str, v.text.col, redrawChanges = -12, 'ERROR', {255,0,0}, true end
          if redrawChanges==true then v.isDirty, doArrange = true, true end -- param error
        end })
        
  end
  
  setmetatable(o, self)
  return o
end


Fader = El:new{} 
function Fader:new(o)
  self.__index = self
  o.z=2
  AddEl(o)
  o.img = o.img or 'slider'
  o.iType = '3_manual'
  --o.col = {255,0,0,100}
  local target = o.target or o.parent
  local faderW = o.faderW or target.w -- W of the fader area
  local faderX = o.faderX or 0 -- X of the fader area
  if o.faderW and o.faderW == '1:1' then
    faderW = (target.paramVMax or 0) - (target.paramVMin or 0) + (o.thumbW or 20) -- 20 is width of standard faderThumb
    faderX = faderX + (target.paramVMin or 0)
    --reaper.ShowConsoleMsg('1:1 faderW is '..faderW..', faderX is '..faderX..'\n')
  end
  if o.target then addAgent(o) end
  o.onMouseOver = function()
    if target.onMouseOver then target:onMouseOver() end
  end
  o.onMouseAway = function()
    if target.onMouseAway then target:onMouseAway() end
  end
  o.doOnMouseOver = function()
    o.iFrame = 1
    o:addToDirtyZone()
  end
  o.doOnMouseAway = function()
    o.iFrame = 0
    o:addToDirtyZone()
  end
  o.onDrag = function(dX, dY)
    local scrollVal = dX
    if scrollVal == 0 then o.initDragX = o.x end
    --reaper.ShowConsoleMsg('scrollVal: '..scrollVal..'\n')
    local vMin, vMax = o.remapToMin or target.paramVMin, o.remapToMax or target.paramVMax
    target.paramV = math.floor(0.5 + vMin + (vMax - vMin) * math.Clamp(
                                (o.initDragX+dX-o.faderX)/(faderW-o.drawW/scaleMult),0,1))
    addNeedUpdate(target)
    o.isDirty=true
  end
  o.onDoubleClick = function()
    target.paramV = target.paramVDef
    addNeedUpdate(target)
  end
  if not o.onMouseWheel then
    o.onMouseWheel = function(wheel_amt)
      if target.paramV then target.paramV = math.Clamp(target.paramV+wheel_amt , target.remapToMin or target.paramVMin, target.remapToMax or target.paramVMax) end
      addNeedUpdate(target)
      target:addToDirtyZone()
    end
  end
  
  o.onNewValue = function(k)
    local vMin, vMax = o.remapToMin or target.paramVMin, o.remapToMax or target.paramVMax
    if target.paramError then o.w=0 
    else o.x = math.floor(o.faderX + 0.5 + 
                          (((target.paramV or 0) - vMin) / (vMax - vMin)) * (faderW - (o.drawW or 0)/scaleMult))
    end
    doArrange = true
  end
  setmetatable(o, self)
  return o
end

FaderBoundary = El:new{} 
function FaderBoundary:new(o)
  self.__index = self
  o.z = o.z or 1
  AddEl(o)
  --o.col= {255,0,150,50}
  local target = o.target or o.parent
  o.onMouseWheel = function(wheel_amt)
    if target.paramV then target.paramV = math.Clamp(target.paramV+wheel_amt , target.remapToMin or target.paramVMin, target.remapToMax or target.paramVMax) end
    addNeedUpdate(target)
    target:addToDirtyZone()
  end
  setmetatable(o, self)
  return o
end


CapsuleFader = El:new{} 
function CapsuleFader:new(o)
  self.__index = self
  o.z = o.z or 1
  o.h = 24
  AddEl(o)
  local target = o.target or o.parent
  if o.target then addAgent(o) end
  if o.colA and o.colB then -- then gradient capsule
    El:new({parent=o, x=0, y=0, w=24, h=24, col=o.colA, shape='evenCircle', interactive = false })
    El:new({parent=o, x=o.w-24, y=0, w=24, h=24, col=o.colB, shape='evenCircle', interactive = false })
    El:new({parent=o, x=12, y=0, w=o.w-24, h=24, col={0}, shape='gradient', colA=o.colA, colB=o.colB, deg=0, interactive = false }) 
  else -- solid capsule
    El:new({parent=o, x=0, y=0, w=o.w, h=24, col=o.capsuleCol or c_Grey33, shape='capsule', interactive = false })
  end
  if o.faderTrack~=false then El:new({parent=o, x=10, y=10, w=o.w-20, h=4, col=o.trackCol or c_Grey15, shape='capsule', interactive = false }) end
  local boundEl = FaderBoundary:new({parent=o, target=o.target, x=0, y=0, w=o.w, h=o.h })
  Fader:new({parent=o, target=o.target, faderW=o.w-4, faderX=2, x=0, y=-2, z=2, boundaryElement=boundEl}) 
  setmetatable(o, self)
  return o
end


SpinnerH = El:new{} 
function SpinnerH:new(o)
  self.__index = self
  o.z = o.z or 2 
  AddEl(o)
  local target = o.target or o.parent
  o.incButton = Button:new({parent=o, x=0, y=2, z=o.z, img='spinner_left', action = 'decrement'})
  o.decButton = Button:new({parent=o, x=19, y=2, z=o.z, img='spinner_left', iFlip=true, action = 'increment'})

  if o.target then addAgent(o) end
  o.onMouseOver = function()
    if target.onMouseOver then target:onMouseOver() end
  end
  o.onMouseAway = function()
    if target.onMouseAway then target:onMouseAway() end
  end
  
  o.onClick = function(k)
    if k.action then -- buttons can have a string that says what the button does. 
      local v = 0
      if k.action == 'increment' then v = target.paramV + 1 end
      if k.action == 'decrement' then v = target.paramV - 1 end
      target.paramV = math.Clamp(v,target.paramVMin,target.paramVMax)
      addNeedUpdate(target)
    end
  end
  
  setmetatable(o, self)
  return o
end

pageMenuButton = El:new{} 
function pageMenuButton:new(o)
  self.__index = self
  AddEl(o)
  
  local agent = MiscAgent:new({parent=o.parent, target=pageController, x=12, y=0, z=2, w=148, h=66, flow=true, col={35,35,35}, value=o.value, interactive = false,
    onNewValue = function(k)
      if k.value == k.target.paramV then k.col = {35,35,35} else k.col = c_Grey20 end
      k.isDirty=true
    end
    })
    El:new({parent=agent, x=58, y=10, z=2, img=o.buttonImg, iType=1, interactive = false  })
    El:new({parent=agent, x=0, y=42, z=2, w=148, h=24, interactive = false, text={str=o.textStr, style=2, align=5, col=o.textCol or c_Grey70}  })  
    Button:new({parent=agent, x=0, y=0, w=148, h=66, style='button', target = pageController, mouseOverCol={255,255,255,10}, value=o.value,
      img='page_ol_off', imgOn='page_ol_on', iType=3,
      onClick = function(k)
        k.target.paramV = o.value
        addNeedUpdate(k.target)
      end
      })
      
  setmetatable(o, self)
  return o
end

paletteChoice = El:new{} 
function paletteChoice:new(o)
  self.__index = self
  AddEl(o)
  
  local agent = MiscAgent:new({parent=o.parent, target=chosenPaletteController, x=0, y=0, z=2, w=220, h=32, border=20, flow=true, col={255,35,35}, interactive = false, value='REAPER' })
    
    for i,v in pairs(palette.REAPER) do 
      El:new({parent=agent, x=0, y=0, z=2, w=22, h=agent.h, flow=true, col=v, interactive = false  })
    end
    El:new({parent=agent, x=0, y=20, z=2, w=220, h=12, col={}, shape='gradient', 
      colA={c_Grey10[1],c_Grey10[2],c_Grey10[3],120}, colB={c_Grey10[1],c_Grey10[2],c_Grey10[3],255}, interactive = false  })
   El:new({parent=agent, x=0, y=22, w=220, h=20, interactive = false, text={str='-', style=2, align=10, padding=0, col=c_Grey70 }    })
   Button:new({parent=agent, x=0, y=0, w=220, h=20, style='button', target = chosenPaletteController, mouseOverCol={255,255,255,50}, 
     onClick = function(k)
       k.target.value = k.value
       addNeedUpdate(k.target)
     end
     })
      
  setmetatable(o, self)
  return o
end

Readout = El:new{} 
function Readout:new(o)
  self.__index = self
  o.z = o.z or 1
  AddEl(o)
  local target = o.target or o.parent
  
  if o.target then addAgent(o) end
  o.onMouseOver = function()
    if target.onMouseOver then target:onMouseOver() end
  end
  o.onMouseAway = function()
    if target.onMouseAway then target:onMouseAway() end
  end
  
  o.x,o.y,o.w,o.h = o.x or 0, o.y or 0, o.w or nil, o.h or 16
  --o.col = o.col or c_grey20
  o.text = {str=o.text.str or '', style=o.text.style or 2, align=o.text.align or 4, padding =o.text.padding or nil, resizeToFit=o.text.resizeToFit or nil, col=o.text.col or c_Grey70}
  if o.units and not o.paramTitles then
    local unitStrLength = gfx.measurestr(translate(o.units)) + textPadding
    o.parent.units = El:new({parent=o.parent, x=0, y=0, w=unitStrLength, h=o.h or 16, flow=true, text={str=o.units, style=2, align=4, padding=0, col=c_Grey50} })
  end
  o.onDoubleClick = function()
    local r, v = reaper.GetUserInputs(target.paramDesc or target.desc or '', 1, (target.remapToMin or target.paramVMin)..(o.units or target.units or '')..' - '..(target.remapToMax or target.paramVMax)..(o.units or target.units or ''), target.paramV)
    if r == true and tonumber(v) then
      target.paramV = math.Clamp(tonumber(v), target.remapToMin or target.paramVMin, target.remapToMax or target.paramVMax)
      addNeedUpdate(target)
      target:addToDirtyZone()
    end
  end
  o.onMouseWheel = function(wheel_amt)
    if target.paramV then target.paramV = math.Clamp(target.paramV+wheel_amt , target.remapToMin or target.paramVMin, target.remapToMax or target.paramVMax) end
    addNeedUpdate(target)
    target:addToDirtyZone()
  end
  o.onNewValue = function(k)
    local p = nil
    if target.valueAlias then
      if target.valueAlias[target.paramV] then
        p = target.valueAlias[target.paramV]
      end
    end
    if o.target.paramError then
      o.text.str, o.text.style = 'ERROR', 2
    end
    o.text.str = p or target.paramV
    if o.target.paramError then o.text.str, o.text.style, o.text.align, o.text.col = 'ERROR', 2, 8, {255,0,0} end
    gfx.setfont(o.text.style)
    o.w=gfx.measurestr(translate(o.text.str))
    o:addToDirtyZone()
    doArrange = true
  end
  
  setmetatable(o, self)
  return o
end

Label = El:new{} 
function Label:new(o)
  self.__index = self
  o.z = o.z or 1
  AddEl(o)
  local target = o.target or o.parent
  if o.text.col == nil and o.text.mouseAwayCol then o.text.col = o.text.mouseAwayCol end
  if o.target then addAgent(o) end
  o.onMouseOver = function()
    if target.onMouseOver then target:onMouseOver() end
  end
  o.onMouseAway = function()
    if target.onMouseAway then target:onMouseAway() end
  end
  o.onDoubleClick = function()
    if target.paramVDef then target.paramV = target.paramVDef end
    addNeedUpdate(target)
  end
  
  o.doOnMouseOver = function(k)
    if o.text.mouseOverCol then 
      if o.text.mouseAwayCol==nil then o.text.mouseAwayCol = o.text.col end
      o.text.col=o.text.mouseOverCol 
      o.isDirty, doArrange = true, true
    end
  end
  o.doOnMouseAway = function(k)
    if o.text.mouseAwayCol then 
      o.text.col=o.text.mouseAwayCol 
      o.isDirty, doArrange = true, true
    end
  end
  
  setmetatable(o, self)
  return o
end

function clearAllParamV()
  for b in ipairs(els) do -- iterate blocks
    for z in ipairs(els[b]) do -- iterate z
      if els[b][z] ~= nil then
        for j,k in pairs(els[b][z]) do
          k.paramV = nil
          addNeedUpdate(k, true)
        end
      end
    end
  end
end

TitleBar = El:new{} 
function TitleBar:new(o)
  self.__index = self
  AddEl(o)
  o.w, o.h, o.r = 0, 26, o.r or {toEdge, o.parent, 'right'}
  o.col, o.text.style, o.text.align, o.text.col  = o.col or c_Grey10, 3, 4, c_Grey50
  
  if o.layouts == nil then
    MiscAgent:new({parent=o, target=activeLayoutController, x=-184, y=0, w=120, h=26, l={toEdge, o, 'right'}, interactive = false, 
      text={str='LAYOUT '..activeLayout, style=3, align=6, padding=0, col={200,200,200}},
      onNewValue = function(k)
        if activeLayout == 'A' then k.text.str, k.text.col = 'LAYOUT A', {204,160,0} end
        if activeLayout == 'B' then k.text.str, k.text.col = 'LAYOUT B', {200,0,255} end
        if activeLayout == 'C' then k.text.str, k.text.col = 'LAYOUT C', {0,161,255} end
        k:addToDirtyZone()
      end
      })
    MiscAgent:new({parent=o, x=-56, y=5, h=16, l={toEdge, o, 'right'},  target=activeLayoutController, img='layoutA_off', imgOn='layoutA_on', iType=3, 
      onClick = function(k)
        activeLayout = 'A'
        clearAllParamV()
        k.target:onUpdate()
      end,
      onNewValue = function(k)
        if k.imgOff==nil then k.imgOff = k.img end
        if activeLayout=='A' then k.img = k.imgOn else k.img=k.imgOff end
        k.imgIdx = nil
        k:addToDirtyZone()
        doArrange = true
      end
      })
    MiscAgent:new({parent=o, x=1, y=0, h=16, flow=true, target=activeLayoutController, img='layoutB_off', imgOn='layoutB_on', iType=3, 
      onClick = function(k)
        activeLayout = 'B'
        clearAllParamV()
        k.target:onUpdate()
      end,
      onNewValue = function(k)
        if k.imgOff==nil then k.imgOff = k.img end
        if activeLayout=='B' then k.img = k.imgOn else k.img=k.imgOff end
        k.imgIdx = nil
        k:addToDirtyZone()
        doArrange = true
      end
      })
    MiscAgent:new({parent=o, x=1, y=0, h=16, flow=true, target=activeLayoutController, img='layoutC_off', imgOn='layoutC_on', iType=3, 
      onClick = function(k)
        activeLayout = 'C'
        clearAllParamV()
        k.target:onUpdate()
      end,
      onNewValue = function(k)
        if k.imgOff==nil then k.imgOff = k.img end
        if activeLayout=='C' then k.img = k.imgOn else k.img=k.imgOff end
        k.imgIdx = nil
        k:addToDirtyZone()
        doArrange = true
      end
      })
      
    elseif o.layouts == 'all' then
      El:new({parent=o, target=activeLayoutController, x=-184, y=0, l={toEdge, o, 'right'}, w=120, h=26, interactive = false, 
        text={str='ALL LAYOUTS', style=3, align=6, padding=0, col=c_Grey50}   })
      El:new({parent=o, x=-56, y=5, h=16, l={toEdge, o, 'right'}, target=activeLayoutController, img='layoutA_on', iType=3, interactive = false  })
      El:new({parent=o, x=1, y=0, h=16, flow=true, target=activeLayoutController, img='layoutB_on', iType=3, interactive = false  })
      El:new({parent=o, x=1, y=0, h=16, flow=true, target=activeLayoutController, img='layoutC_on', iType=3, interactive = false  })
    end
  setmetatable(o, self)
  return o
end

fontControl = El:new{} 
function fontControl:new(o)
  self.__index = self
  AddEl(o)

  local labelColMO, labelColMA, readoutColMO, readoutColMA = labelColMO, labelColMA, {0,204,136,255}, {0,204,136,106}
  if o.colMatch and o.colMatch == 'c_CyanGrey' then 
    labelColMO, labelColMA, readoutColMO, readoutColMA = c_Grey80, c_Grey10, {0,255,170,255}, {32,64,53,255}
  end
  
  Button:new({parent=o, target=o.target, x=0, y=2, img='spinner_left', action='decrement'})
  MiscAgent:new({parent=o, target=o.target, x=22, y=4, img='font_size_stack', iType='stack', iFrameH=16, iFrame=1, 
    onNewValue = function(k)
      local wfm = 0
      if scaleMult==1.5 then wfm = 5 else if scaleMult==2 then wfm = 10 end end
      k.toolTip="WALTER font "..(k.target.paramV or '')+wfm
      k.iFrame = k.target.paramV-1
      if k.target.paramError then k.toolTip, k.col='ERROR',{255,0,0} end
      k:addToDirtyZone()
      doArrange = true
    end,
    onMouseWheel = function(wheel_amt,k)
      k.target.paramV = math.Clamp(k.target.paramV+wheel_amt , k.target.remapToMin or k.target.paramVMin, k.target.remapToMax or k.target.paramVMax)
      addNeedUpdate(k.target)
      k.target:addToDirtyZone()
    end
    })
  Button:new({parent=o, target=o.target, x=86, y=2, img='spinner_left', iFlip=true, action='increment'})
  Label:new({parent=o, x=110, y=2, w=60, h=22, target=o.target, 
    text={str=o.target.desc, style=2, align=4, col=labelColMA, padding=0, resizeToFit=true, mouseOverCol=labelColMO, mouseAwayCol=labelColMA }
    })
  
  setmetatable(o, self)
  return o
end  

ccControls = El:new{} 
function ccControls:new(o)
  self.__index = self
  AddEl(o)
  o.w=0
  o.r={toEdge, o.parent, 'right'}
  
  local labelColMO, labelColMA, readoutColMO, readoutColMA, readoutUnitCol = labelColMO, labelColMA, o.readoutColMO or {0,204,136,255}, o.readoutColMA or {0,204,136,106}, o.readoutUnitCol or {0,204,136,142}
  if o.colMatch and o.colMatch == 'c_CyanGrey' then 
    labelColMO, labelColMA, readoutColMO, readoutColMA, readoutUnitCol = c_Grey80, c_Grey10, o.readoutColMO or {0,255,170,255}, o.readoutColMA or {32,64,53,255}, readoutUnitCol or {32,64,53,255} 
  end
  
  if o.label~=false then Label:new({parent=o, x=0, y=2, z=2, w=60, h=20, target=o.target, 
    text={str=o.target.desc, style=2, align=0, col=labelColMA, padding=0, resizeToFit=true, mouseOverCol=labelColMO } }) end
  local readoutY = 0
  if o.spinner ~= false then 
    SpinnerH:new({parent=o, x=4, y=-4, z=2, h=20, w=36, col={0,100,100,0}, flow=true, target=o.target}) 
  else readoutY = -4
  end
  Readout:new({parent=o, x=6, y=readoutY, z=2, w=60, h=20, flow=true, target=o.target, 
    text={str='0.00', style=4, align=0, col=readoutColMA, padding=0, resizeToFit=true},  
    doOnMouseOver = function(k)
      k.text.col=readoutColMO
      k:addToDirtyZone()
    end,
    doOnMouseAway = function(k)
      k.text.col=readoutColMA
      k:addToDirtyZone()
    end
    })
    
  MiscAgent:new({parent=o, x=1, y=0, w=60, h=20, z=2, flow=true, target=o.target, text={str=o.target.units, style=1, align=8, col=readoutUnitCol, padding=0, resizeToFit=true},
    onNewValue = function(k)
      local p = nil
      if k.target.valueAlias then
        if k.target.valueAlias[k.target.paramV] then p = '' end -- aliased values (e.g. 'knob') are assumed to have no unit
      end
      if k.target.paramError then p='' end
      k.text.str = p or k.target.units
      gfx.setfont(k.text.style)
      k.w=gfx.measurestr(translate(k.text.str))
      k:addToDirtyZone()
      doArrange = true
    end })
  
  setmetatable(o, self)
  return o
end

TapeMeasure = El:new{} 
function TapeMeasure:new(o)
  self.__index = self
  AddEl(o)

  local tapeColMO, tapeColMA, tapeStripColMO, tapeStripColMA = c_Grey70, c_Grey50, {0,204,136,255}, c_Grey33
  if o.tape.colMatch and o.tape.colMatch == 'c_CyanGrey' then 
    tapeColMO, tapeColMA, tapeStripColMO, tapeStripColMA = c_Grey80, c_Grey70, {0,255,170}, c_Grey20
  end
  MiscAgent:new({parent=o, target=o, x=0, y=0, w=20, h=20, col=tapeColMA, shape='evenCircle', interactive = false, -- circle bg
    doOnMouseOver = function(k)
      k.col=tapeColMO
      k:addToDirtyZone()
    end,
    doOnMouseAway = function(k)
      k.col=tapeColMA
      k:addToDirtyZone()
    end
    })
  MiscAgent:new({parent=o, target=o, x=10, y=0, w=10, h=10, col=tapeColMA, interactive = false, -- corner bg
    doOnMouseOver = function(k)
      k.col=tapeColMO
      k:addToDirtyZone()
    end,
    doOnMouseAway = function(k)
      k.col=tapeColMA
      k:addToDirtyZone()
    end })
  Knob:new({parent=o, target=o.target, x=0, y=0, w=20, h=20, img='knobStack_20px_dark', iFrameH=20, iFrame=20 })
  MiscAgent:new({parent=o, target=o.target, x=22, y=0, w=100, h=1, col=tapeStripColMA, lengthOffs=(o.tape.lengthOffs or 0),
    shape='horizDash', dash={w=8, gap=2, direction='reverse'}, interactive = false,
    onNewValue = function(k)
      local displayVW = k.target.paramV
      if displayVW==o.tape.zeroAtV or not displayVW then k.w=0
      else k.w = displayVW - 22 + k.lengthOffs
      end
      k.r = nil
      if (k.parent.x + k.x + k.w) > k.parent.parent.w + k.parent.parent.x - 20 then 
        k.w=-20
        k.r={toEdge, k.parent.parent, 'right'}
      end
      k:addToDirtyZone()
      doArrange = true
    end,
    doOnMouseOver = function(k)
      k.col=tapeStripColMO
      k:addToDirtyZone()
    end,
    doOnMouseAway = function(k)
      k.col=tapeStripColMA
      k:addToDirtyZone()
    end
    }) 
  setmetatable(o, self)
  return o
end

secWidthDiag = El:new{} 
function secWidthDiag:new(o)
  self.__index = self
  AddEl(o)
  o.h, o.w, o.border = 44 + o.sec.imgH, 480, 10
  El:new({parent=o, x=0, y=0, w=230, h=0, b={toEdge, o, 'bottom'}, col=c_Grey10 }) 
  local maxBg = El:new({parent=o, x=10, y=10, w=100, h=o.sec.imgH, img=o.sec.img, iType=1, interactive=false }) 
  local minBg = El:new({parent=o, x=10, y=10, w=100, h=o.sec.imgH, img=o.sec.img, iType=1, col=c_Grey10, interactive=false })
  El:new({parent=minBg, x = o.sec.labelX or 0, y=0, w = o.sec.labelW or 0, r={toEdge, minBg, 'right'}, h=o.sec.labelH, col={120,60,190,0}, 
      text={str=o.sec.str, style=1, align=4, col=o.sec.labelCol or c_Grey15} })
  El:new({parent=o, x=0, y=0, l={toEdge, minBg, 'right'}, w=100, h=34, r={toEdge, maxBg, 'right'}, w=-1, h=34, 
     col={255,0,0,100}, shape='gradient', colA=c_Grey10, colB={c_Grey10[1],c_Grey10[2],c_Grey10[3],0}, deg=0 }) 
  
  ccControls:new({parent=o, x=244, y=o.h-48, target=o.sec.targetMin})
  ccControls:new({parent=o, x=244, y=o.h-28, target=o.sec.targetMax})
  
  o.sec.targetMin.onNewValue = function(k) -- modify the target controller
    o.children[3].w = k.paramV or 0 -- bg image w
    if o.sec.targetMin.paramV and o.sec.targetMax.paramV and o.sec.targetMin.paramV>o.sec.targetMax.paramV then 
       o.sec.targetMax.paramV = o.sec.targetMin.paramV
       o.sec.targetMax:onUpdate()
    end
  end
  
  o.sec.targetMax.onNewValue = function(k) -- modify the target controller
    o.children[2].w = k.paramV or 0 -- bg image w
    if o.sec.targetMin.paramV and o.sec.targetMax.paramV and o.sec.targetMax.paramV<o.sec.targetMin.paramV then 
       o.sec.targetMin.paramV = o.sec.targetMax.paramV
       o.sec.targetMin:onUpdate()
    end
  end
    
  Fader:new({parent=o, target=o.sec.targetMin, img='vEdge_resize', thumbW=29, faderW='1:1', faderX=o.x-4+o.sec.targetMin.paramVMin, x=0, y=16+o.sec.imgH})
  Fader:new({parent=o, target=o.sec.targetMax, img='vEdge_resize', thumbW=29, faderW='1:1', faderX=o.x-4+o.sec.targetMin.paramVMin, x=0, y=16+o.sec.imgH})
  
  if o.sec.str~='Parameter Name' then
    El:new({parent=o, x=6, y=6, img='roundBox_white25', col={0,0,0,180}, iType=1, w=0, h=-6, b={toEdge, o, 'bottom'}, 
      text={str='ASSIGNED TO SHARE THE PARAMETERS SECTION', style=3, align=7, col={255,255,255,150} } })
  end
  
  setmetatable(o, self)
  return o
end

tcpBalanceButton = El:new{} 
function tcpBalanceButton:new(o)
  self.__index = self
  AddEl(o)
  o.target = tcpBalanceController
  addAgent(o)
  o.w, o.h = 112,56
  MiscAgent:new({parent=o, x=0, y=0, w=o.w, h=o.h, col=c_Grey15, interactive = false })
  MiscAgent:new({parent=o, x=10, y=10, w=92, h=34, img=o.tcpBalanceImg, interactive = false })
  Button:new({parent=o, x=0, y=0, w=o.w, h=o.h, mouseOverCol={255,255,255,10},
    onClick = function(k)
      k.parent.target.paramV = k.parent.param
      addNeedUpdate(k.parent.target)
    end })
  setmetatable(o, self)
  return o
end 

DropTarget = El:new{} 
function DropTarget:new(o)
  self.__index = self
  AddEl(o)
  o.col = o.col or nil 
  if o.origCol==nil and o.col~=nil then o.origCol = o.col end
  if showDropHelpers == true then 
    o.col = {math.random(255),math.random(255),math.random(255),180}
    o.mouseOverCol={255,255,255,180}
  end
  o.x, o.y, o.w, o.h = o.x or 0, o.y or 0, o.w or 20, o.h or 20
  o.interactive = o.interactive or false
  local target = o.target or o.parent
  
  if target.DropTargets==nil then target.DropTargets = {} end
  table.insert(target.DropTargets, o)
  if o.alsoAgentOf ~= nil then
    for i,v in ipairs(o.alsoAgentOf) do
      if v.DropTargets==nil then v.DropTargets = {} end
      table.insert(v.DropTargets, o)
    end 
  end
  
  o.onDragHover = function()
    if target ~= tcpOrderControl then
      o.dragHovering = true -- to indicate this will need cancelling
      o.col = o.hoverCol or nil
      if o.text then o.text.col = c_Grey70 end
      o:addToDirtyZone()
    end
  end
  
  o.onDragAway = function()
    o.col = o.origCol or nil
    if o.text then o.text.col = c_Grey50 end
    o:addToDirtyZone()
  end
  
  o.mouseAway = function() o.onDragAway() end
  
  setmetatable(o, self)
  return o
end

DragNDrop = El:new{} 
function DragNDrop:new(o)
  self.__index = self
  o.z, o.x, o.y, o.w, o.h = o.z or 2, o.x or 0, o.y or 0, o.w or 20, o.h or 20
  o.border = o.border or 0
  if o.flow~=false then o.flow = o.flow or true end
  --o.col = {0,255,255,200}
  AddEl(o)
  local target = o.target or o.parent
  if target.dragNDropCursor then o.mouseOverCursor = target.dragNDropCursor end

  o.onDrag = function(dX, dY)
    
    local scrollVal = dX+dY
    if scrollVal == 0 then o.initDragX, o.initDragY = o.x + (0.5*o.w) , o.y + (0.5*o.h) end 
    local dropV = nil
    local b = 2 -- assuming block 2 for now
    local thisBlockX = els[b].drawX or els[b].x 
    local scrollXOffs = els[b].scrollX or 0 
    local scrollYOffs = els[b].scrollY or 0 
    
    for i, v in ipairs(target.DropTargets) do

      local x, y, w, h = (v.drawX or v.x or 0) + thisBlockX, v.drawY or v.y or 0, v.drawW or v.w or 0, v.drawH or v.h or 0
      if (gfx.mouse_x-scrollXOffs) > x and (gfx.mouse_x-scrollXOffs) < x+w and (gfx.mouse_y+scrollYOffs) > y and (gfx.mouse_y+scrollYOffs) < y+h ~= false then

        if v.onDragHover then v.onDragHover() end
                
        if target==tcpOrderControl then --paramV is the tcp reorder, a table of locations and indeces 
          for j, k in ipairs(target.paramV) do 
            if k == o.param and j~=i then 
              table.remove(target.paramV, j) 
              table.insert(target.paramV, i, o.param)
            end
          end
          addNeedUpdate(target)
          doArrange = true
        elseif target==mcpStripOrderControl then --paramV is the mcp strip reorder, a table of locations and indeces 
          for j, k in ipairs(target.paramV) do 
            if k == o.param and j~=i then 
              table.remove(target.paramV, j) 
              table.insert(target.paramV, i, o.param)
            end
          end
          addNeedUpdate(target)
          doArrange = true
        else
          --reaper.ShowConsoleMsg('setting dropV to '..v.param..', o.param = '..o.param..'\n')
          dropV = v.param 
        end

      else -- else not over drop target v
        if v.dragHovering == true and v.onDragAway then v.onDragAway() end
      end
      
      if target~=tcpOrderControl and target~=mcpStripOrderControl and o.parent and o.parent.children then
        for j,k in ipairs(o.parent.children) do
          if o==k then 
            if o.parent.children[j+1] then o.parent.children[j+1].flow = true end -- fix the flow of the child that follows you, 'true' will cause recalculation
            table.remove(o.parent.children,j) -- then remove yourself from the children list
          end
        end
      end
      
      if target~=tcpOrderControl and target~=mcpStripOrderControl then
        -- set this DragNDrop's parent to be the DragWagon, it will be assigned a new parent when its new value is read back
        o.parent, o.z, o.x, o.y = DragWagon, 2, 0 ,0
        o.flow = nil
        DragWagon.x, DragWagon.y = (gfx.mouse_x/scaleMult)-sidebarBox.w+scrollXOffs , (gfx.mouse_y/scaleMult)+scrollYOffs
        DragWagon.w, DragWagon.h = o.w, o.h
        DragWagon:addToDirtyZone()
      end
      doArrange = true  
      
    end
    
    o.onMouseUp = function()
      --reaper.ShowConsoleMsg('onMouseUp, dropV = '..dropV..'\n')
      if dropV ~= nil then 

        if o.param=='fxParam' and target.paramV.tcpFxparmVisflag1==1 then 
          target.paramV.insert = target.paramV[o.param]-- put insert where it apears to be, but now in its own right
          target.paramV.tcpFxparmVisflag1 = -1 -- clear the flag
          end
        if o.param=='fxParam' and target.paramV.tcpFxparmVisflag2==1 then 
          target.paramV.send = target.paramV[o.param]-- put send where it apears to be, but now in its own right
          target.paramV.tcpFxparmVisflag2 = -1 -- clear the flag
        end
        if o.param=='insert' and dropV=='none' then target.paramV.tcpFxparmVisflag1 = -1 end -- clear the flag, you're none for real
        if o.param=='send' and dropV=='none' then target.paramV.tcpFxparmVisflag2 = -1 end -- clear the flag, you're none for real

        --reaper.ShowConsoleMsg('set '..o.param..' to dropV = '..dropV..'\n')
        target.paramV[o.param] = dropV
        
        dropV = nil
        addNeedUpdate(target)
        target:onNewValue()
      else
        --reaper.ShowConsoleMsg('dropped somewhere invalid\n')
        addNeedUpdate(target)
      end
      DragWagon.h = 0
      draggingEl = nil
      doArrange = true
    end
   
  end
 
  setmetatable(o, self)
  return o
end

ColourChooseAgent = El:new{} 
function ColourChooseAgent:new(o)
  self.__index = self
  if o.target then addAgent(o) end
  AddEl(o)
  o.paramDesc = o.target.paramDesc
  El:new({parent=o, x=0, y=0, w=196, h=52, col=o.col, interactive=false }) 
  ColChooser:new({parent=o, target=o.target, x=0, y=0})
  ColPreset:new({parent=o, target=o.target, x=60, y=18})
  ColPreset:new({parent=o, target=o.target, x=92, y=18, colPreset={38,38,38}})
  ColPreset:new({parent=o, target=o.target, x=124, y=18, colPreset={100,100,100}})
  ColPreset:new({parent=o, target=o.target, x=156, y=18, colPreset={51,51,51}})
  El:new({parent=o, x=46, y=-6, w=o.w, h=24, text={str=o.target.labelStr or o.target.paramDesc or 'label', style=3, align=4, col=c_Grey70} })
  setmetatable(o, self)
  return o
end

ColChooser = El:new{} 
function ColChooser:new(o)
  self.__index = self
  AddEl(o)
  local target = o.target or o.parent
  if o.target then addAgent(o) end
  --o.col = {129,137,137}
  o.w, o.h = 78, 52
  El:new({parent=o, x=-1, y=-1, w=78, h=52, shape='poly', coords={{2,26}, {26,2}, {77,52}, {28,52}}, interactive=false  })
  El:new({parent=o, x=0, y=0, w=78, h=52, img='col_chooser', iType=3, 
    onClick = function()
      local retval, col = reaper.GR_SelectColor()
      if retval==1 then
        local r, g, b = reaper.ColorFromNative(col)
        target.paramV = {r,g,b}
        addNeedUpdate(target)
      end
    end })
  o.onNewValue = function(k)
    --reaper.ShowConsoleMsg('ColChooser onNewValue '..target.paramV[1]..' '..target.paramV[2]..' '..target.paramV[3]..'\n')
    o.children[1].col = target.paramV
    if target.paramError then o.children[1].col = {255,0,0} end
    o:addToDirtyZone()
  end
  
  setmetatable(o, self)
  return o
end


ColPreset = El:new{} 
function ColPreset:new(o)
  self.__index = self
  AddEl(o)
  local target = o.target or o.parent
  if o.target then addAgent(o) end
  o.x, o.y, o.w, o.h = o.x or 0, o.y or 0, o.w or 28, o.h or 28
  o.colPreset = o.colPreset or {129,137,137}
  El:new({parent=o, x=4, y=4, w=28, h=28, col=o.colPreset, interactive=false  })
  El:new({parent=o, x=0, y=0, w=36, h=36, img='swatch', iType=3, 
    onClick = function()
      target.paramV = o.colPreset
      addNeedUpdate(target)
    end
    })
  setmetatable(o, self)
  return o
end

Controller = El:new{} 
function Controller:new(o)
  self.__index = self
  o.x, o.y, o.w, o.h, o.flow = 0, o.y or 0, o.w or 6, o.h or 0, o.flow or true
  AddEl(o)
  o.controlType = o.controlType or 'themeParam'
  o.interactive = false -- only receives and distibutes interactions from elsewhere
  if o.agents==nil then o.agents = {} end -- to stop functions complaining
  o.onMouseOver = function()
    --reaper.ShowConsoleMsg('Controller onMouseOver\n')
    for i in ipairs (o.agents) do
      if o.agents[i].doOnMouseOver then o.agents[i]:doOnMouseOver() end
    end
  end
  o.onMouseAway = function()
    for i in ipairs (o.agents) do
      if o.agents[i].doOnMouseAway then o.agents[i]:doOnMouseAway() end
    end
  end
  
  if o.paramDesc and o.hidden~= true then -- test that the controller has a valid param in paramIdx. 
    if paramIdxGet(o.paramDesc) == -1 then
      o.paramError = true
      logError('Theme has no parameter for : '..o.paramDesc, 'amber')
    end
  end
  
  if o.paramVMin == nil or o.paramVMax == nil then -- then first time
    --reaper.ShowConsoleMsg((o.paramDesc or o.desc or 'nope')..' \n')
    if o.controlType == 'themeParam' then
      local p = paramIdxGet(o.paramDesc)
      if type(o.param) == 'number' then p = o.param end
      local tmp, tmp, tmp, paramVDef, paramVMin, paramVMax = reaper.ThemeLayout_GetParameter(p)
      if o.remapToMin and o.remapToMax then
        paramVDef, paramVMin, paramVMax = remapParam(paramVDef, paramVMin, paramVMax, o.remapToMin, o.remapToMax), o.remapToMin, o.remapToMax
      end
      o.paramVDef, o.paramVMin, o.paramVMax = paramVDef, paramVMin, paramVMax
    end
  end
  
  o.onReaperChange = function(k)
    if k.controlType == 'reaperActionToggle' then
      k:onUpdate()
      --reaper.ShowConsoleMsg('Controller reaperActionToggle onReaperChange\n')
    end
  end
  
  if o.controlType == 'reaperActionToggle' then
    o.onFps = function(k)
      k:onUpdate()
    end
    needing_fps[#needing_fps + 1] = o
  end
  
  o.resetToDefault = function()
    local p = paramIdxGet(o.paramDesc)
    if type(o.param) == 'number' then p = o.param end
    local tmp,tmp,tmp,d = reaper.ThemeLayout_GetParameter(p)
    reaper.ThemeLayout_SetParameter(p, d, true)
    o.paramV = nil
    o:onUpdate()
  end
  
  if o.controlType == 'themeParam' and not o.onValueEdited then
    -- onValueEdited() is called after the user edits a value, it should write the settings to REAPER/etc
    o.onValueEdited = function(k)
      if o.paramV ~= nil then
        local p
        if type(o.param) == 'number' then
          p = o.param 
        else
          p = paramIdxGet(o.paramDesc)
        end
        if o.style=='colour' then
          paramSet(p, o.paramV[1])
          paramSet(paramIdxGet(o.paramDesc..' G'), o.paramV[2])
          paramSet(paramIdxGet(o.paramDesc..' B'), o.paramV[3])
        else
          local retval, desc, value, defValue, minValue, maxValue = reaper.ThemeLayout_GetParameter(p)
          local v = o.paramV
          if k.remapToMin and k.remapToMax then 
            v = remapParam(o.paramV, k.remapToMin, k.remapToMax, minValue, maxValue) 
            --reaper.ShowConsoleMsg(o.paramV..' becomes '..v..'\n')
            --reaper.ShowConsoleMsg('not first time '..p..'  v : '..v..'   value : '..value..' \n')
          end
          if v ~= value then -- then the user has changed o.paramV
            paramSet(p, v)
          end
        end
      end
    end
  end
  
  if not o.onUpdate then
    o.onUpdate = function(k)
      --reaper.ShowConsoleMsg('controller onUpdate\n')
      
      if o.controlType == 'themeParam' then
        local p
        if type(o.param) == 'number' then
          p = o.param 
        else
          p = paramIdxGet(o.paramDesc)
        end

        if o.style=='colour' then
          if o.paramV == nil then -- set paramV for the first time
            o.paramV  = {}
            tmp, tmp, o.paramV[1] = reaper.ThemeLayout_GetParameter(p)
            tmp, tmp, o.paramV[2] = reaper.ThemeLayout_GetParameter(paramIdxGet(o.paramDesc..' G'))
            tmp, tmp, o.paramV[3] = reaper.ThemeLayout_GetParameter(paramIdxGet(o.paramDesc..' B'))
          end
          
        else
          if o.paramV == nil then -- set paramV for the first time
            local retval, desc, value, defValue, minValue, maxValue = reaper.ThemeLayout_GetParameter(p)
            if k.remapToMin and k.remapToMax then 
              o.paramV = remapParam(value, minValue, maxValue, k.remapToMin, k.remapToMax)
            else o.paramV = value 
            end
          end
          
        end
      end
      
      if o.controlType == 'reaperActionToggle' then
        o.paramV = reaper.GetToggleCommandState(o.param) -- o.param will be a Reaper command_id
      end
      
      if k.onNewValue then k:onNewValue() end
    
      for i in ipairs (k.agents) do
        if k.agents[i].onNewValue then k.agents[i]:onNewValue() end
      end
      
      if k.target then k.target:onNewValue() end
    end
  end
  
  
  setmetatable(o, self)
  return o
end


-------------- PARAMS --------------
 
function indexParams()
  paramsIdx ={['A']={},['B']={},['C']={},['global']={}}
  local i=0
  while reaper.ThemeLayout_GetParameter(i) ~= nil do
    local tmp,desc = reaper.ThemeLayout_GetParameter(i)
    if string.sub(desc, 1, 6) == 'Layout' then
      local layout, paramDesc = string.sub(desc, 8, 8), string.sub(desc, 12)
      if paramsIdx[layout] ~= nil then paramsIdx[layout][paramDesc] = i end
    else paramsIdx.global[desc] = i end
    i = i+1
  end
  return true
end

function paramIdxGet(param)
  if param == nil then return 10000 end -- if you're going to send nonsense, send it somewhere harmless
  if paramsIdx.global[param] then return paramsIdx.global[param] 
  else
    if activeLayout==nil then activeLayout = 'A' end
    if paramsIdx[activeLayout][param] then return paramsIdx[activeLayout][param] 
    else return -1 
    end
    --reaper.ShowConsoleMsg('paramIdxGet activeLayout '..activeLayout..' param '..param..' = '..paramsIdx[activeLayout][param]..'\n')
  end
end

function paramSet(p,v)
  --reaper.ShowConsoleMsg('set parameter '..p..' to '..v..'\n')
  reaper.ThemeLayout_SetParameter(p, math.tointeger(v) or 0, true)
  ThemeLayout_RefreshAll = true
end

function remapParam(value, min, max, translatedMin, translatedMax, raw)
  local newValue = math.floor((value - min)/(max - min) * (translatedMax - translatedMin) + translatedMin + 0.5)
  return math.tointeger(newValue)
end

function ExportParams(all)
  if not g_last_exported_name then g_last_exported_name = "MyThemeParameters" end
  local curname = g_last_exported_name
  while true do
    local retval, title = reaper.GetUserInputs(
      translate("Title for file to export"), 1,
      translate("Title for file to export :, extrawidth=100"),
      curname)
    if not title or not retval then break end
    curname = title
    local fn = script_path..'/'..title..'.Default7themeAdjustment'
    local skip = false
    local file = io.open(fn, 'r')
    if file ~= nil then
      file:close()
      local k = reaper.MB(translate("The file:\r\n\r\n\t") .. fn ..
                          translate("\r\n\r\nalready exists. Overwrite?"),
                          translate("Overwrite?"),1)
      if k ~= 1 then skip = true end
    end

    if not skip then
      local file = io.open(fn, 'w+')
      if not file then
        reaper.MB(translate("Error writing to:\r\n\r\n\t") .. fn, translate("Error"), 0)
      else
        g_last_exported_name = title
        local i=-1005
        local param,desc,val,def = reaper.ThemeLayout_GetParameter(i)
    
        while param ~= nil do
          if all~=true then
            if val~=def then file:write(desc..'='..val..'\n') end
          else file:write(desc..'='..val..'\n')
          end
          if i==-1000 then i=0 end
          i = i+1
          param,desc,val,def = reaper.ThemeLayout_GetParameter(i)
        end

        file:close()
        break
      end
    end
  end
end


  --------- FUNCS ----------
  
sqrt2 = math.sqrt(2)

function getCurrentTheme()
  local reaperLastTheme = string.match(string.match((reaper.GetLastColorThemeFile() or 'none'), '[^\\/]*$'),'(.*)%..*$') 
  if reaperLastTheme and ((reaper.file_exists(themes_path..'/'..reaperLastTheme..'.ReaperThemeZip')==true) or (reaper.file_exists(themes_path..'/'..reaperLastTheme..'.ReaperTheme')==true)) then 
    return reaperLastTheme
  else return nil
  end
end

function themeCheck()
  if themeTitle == nil then
    themeTitle = getCurrentTheme() or 'Unknown'
    last_theme_check = reaper.time_precise()
    switchTheme(themeTitle)
    oldthemeTitle = themeTitle
  else 
    local now = reaper.time_precise()
    if now > last_theme_check+1 and suspendSwitchTheme ~= true  then -- once per second see if the theme filename changed
      last_theme_check = now
      local tn = getCurrentTheme() or 'Unknown'
      if tn ~= themeTitle then
        if errorLog then errorLog = nil end -- reset that
        --reaper.ShowConsoleMsg('Theme Changed\n')
        
        themeTitle = tn
        if purgeAll() == true then
          indexParams()
          Populate()
          updateAnyNotHidden = true
          doArrange = true
        end
        switchTheme(themeTitle)
      end
    end
  end
end

showPages = {Global=true, TCP=true, EnvCP=true, MCP=true, Transport=true, Generic_Global=false, Generic=true, Errors=false} 

function switchTheme(thisTheme)
  if string.sub(thisTheme,1,11) ~= 'Default_7.0' then
    showPages.Global, showPages.TCP, showPages.EnvCP, showPages.MCP, showPages.Transport = false,false,false,false,false
    showPages.Generic_Global, showPages.Generic = true, true
  else
    showPages.Global, showPages.TCP, showPages.EnvCP, showPages.MCP, showPages.Transport = true,true,true,true,true
    showPages.Generic_Global, showPages.Generic = false, false
    if themeVerController and themeVerController.paramVDef and themeVerController.paramVDef~=scriptVersion then
      reaper.ShowMessageBox(translate('Script version : ')..scriptVersion..'\n' ..
                            translate('Theme version : ')..themeVerController.paramVDef, 
                            translate('Versions do not match'), 0)
      logError(translate('Script version ')..scriptVersion..
               translate(' does not match theme version ')..themeVerController.paramVDef, 'amber')
    end
  end
  if not showPages[activePage] then 
    if showPages.Global~=false then activePage="Global" else activePage="Generic_Global" end --don't get stuck on a page that's hidden
  end
  gfxWold = 0 -- force redraw of everything
end

function addAgent(agent)
  if agent.target.agents == nil then agent.target.agents = {} end
  table.insert(agent.target.agents, agent)
  if agent.alsoAgentOf ~= nil then
    for i,v in ipairs(agent.alsoAgentOf) do
      table.insert(v.agents, agent)
    end
  end
end  
  
function El:purge()
  --reaper.ShowConsoleMsg('purging\n')
  for b in ipairs(els) do -- iterate block
    for z in ipairs(els[b]) do
      if els[b][z] ~= nil and #els[b][z] ~= 0 then
        for j,k in pairs(els[b][z]) do
          if k == self then
            if self.children ~= nil then 
              for l,m in pairs(self.children) do
                m:purge() 
              end 
            end
            if self:addToDirtyZone(b) == true then
              if self.imgIdx then
                gfx.setimgdim(self.imgIdx,0,0)
              end
              table.remove(els[b][z],j)
              doDraw = true
            end
          end
        end
      end
    end
  end -- end iterating blocks
end

function purgeAll()
  --reaper.ShowConsoleMsg('purging All\n')
  els = nil
  paramsIdx = nil
  needing_updates = {}
  needing_fps = {}
  return true
end


function logError(error, severity)
  if severity == nil then severity = 'none' end
  if errorLog == nil then errorLog = {} end
  if errorLog[severity] == nil then 
    errorLog[severity] = {error} 
  else table.insert(errorLog[severity], error) 
  end
end

function colCycle(self) -- for debugging / inducing headaches
  if colDebug ~= true then self.col = {0,255,0,150}
  else self.col = {math.random(255),math.random(255),math.random(255),255}
    self:addToDirtyZone()
  end
end  

function math.Clamp(val, min, max)
  return math.min(math.max(val, min), max)
end

function adoptChild(parent, child)
  if parent.children then parent.children[#parent.children + 1] = child
  else parent.children = {child}
  end
end

function addTimer(self,index,time) 
  if Timers == nil then Timers = {} end
  if Timers[index] == nil then
    if self.Timers == nil then self.Timers = {} end
    self.Timers[index] = nowTime + time
    Timers[index] = self 
    return true
  end
end

function removeTimer(self,index)
  if self.Timers and self.Timers[index] and Timers[index] and self.onTimerComplete[index] then
    self.Timers[index], Timers[index], self.onTimerComplete[index] = nil, nil, nil
  end
end

function cycleBitmapStack(self)
  if self.iFrameC then
    self.iFrameDirection = self.iFrameDirection or 1
    if self.iFrame == self.iFrameC-1 and self.iFrameDirection == 1 then self.iFrameDirection = -1 end
    if self.iFrame == 0 then self.iFrameDirection = 1 end
    self.iFrame = self.iFrame + self.iFrameDirection
    self:addToDirtyZone()
  end
end

function El:reloadImg()
  if self.img then
    if self.imgIdx then
      local i = scaleToDrawImg(self) 
      loadImage(self.imgIdx, i, self.iLocation or nil, self.noIScales)
    end
    self:addToDirtyZone()
  end
end

function scaleToDrawImg(self)
  local i = self.img
  if scaleMult == 1.5 then i = self.img..'_150' end
  if scaleMult == 2 then i = self.img..'_200' end 
  return i
end

function setScale(scale)
  scaleMult = scale
  if scaleMult == 1 then textScaleOffs = 0 end
  if scaleMult == 1.5 then textScaleOffs = 4 end
  if scaleMult == 2 then textScaleOffs = 8 end
  reloadImgs()
  doArrange = true
  doOnGfxResize()
end

  --------- ARRANGE ----------

function El:dirtyXywhCheck(b)
  b = b or self.block or 1
  if self.drawX == nil then -- then you've never been arranged
    if self:arrange() == true then 
      self:addToDirtyZone(b) 
      return true
    end
  else
    self.ox,self.oy,self.ow,self.oh = self.drawX, self.drawY, self.drawW, self.drawH
    if self:arrange() == true then
      if self.isDirty==true or self.drawX~=self.ox or self.drawY~=self.oy or self.drawW~=self.ow or self.drawH~=self.oh then 
        self:addToDirtyZone(b, true)
        self.isDirty = nil
        return true
      end
    end
  end
end

function El:addToDirtyZone(b, newXywh)

  if self.hidden == true then return false end
  b = b or self.block or 1
  local kx,ky,kw,kh = self.drawX or self.x, self.drawY or self.y, self.drawW or self.w or 0, self.drawH or self.h or 0 
  if self.faderX and self.faderW and self.faderW~='1:1' then -- use fader track as dirtyZone
    kx, kw = self.faderX, self.faderW 
    if self.boundaryElement then
      kx,ky,kw,kh = self.boundaryElement.drawX or self.boundaryElement.x, self.boundaryElement.drawY or self.boundaryElement.y, 
        self.boundaryElement.drawW or self.boundaryElement.w or 0, self.boundaryElement.drawH or self.boundaryElement.h or 0 
    end
  end 
  --reaper.ShowConsoleMsg((self.img or 'el')..' addToDirtyZone '..' kx:'..kx..' ky:'..ky..' kw:'..kw..' kh:'..kh..' on z:'..z..'\n')
  
  if kw ~= nil then includeInDirtyZone(b,kx,ky,kw,kh) end -- dirtyZone the element
  if newXywh == true then includeInDirtyZone(b,self.ox,self.oy,self.ow,self.oh) end -- element has moved, so also dirtyZone its old location
  
  doDraw = true
  return true
end

function includeInDirtyZone(b,x,y,w,h)
  if dirtyZone[b]==nil then dirtyZone[b] = {} end
  if dirtyZone[b].xMin==nil or dirtyZone[b].xMin>x then dirtyZone[b].xMin = x end
  if dirtyZone[b].yMin==nil or dirtyZone[b].yMin>y then dirtyZone[b].yMin = y end
  if dirtyZone[b].xMax==nil or dirtyZone[b].xMax<(x+w) then dirtyZone[b].xMax = x+w end
  if dirtyZone[b].yMax==nil or dirtyZone[b].yMax<(y+h) then dirtyZone[b].yMax = y+h end
end

function hasOverlap(x1,y1,w1,h1,x2,y2,w2,h2)
  if ((x1 >= x2 and x1 <= x2+w2) or (x2 >= x1 and x2 <= x1+w1)) and
     ((y1 >= y2 and y1 <= y2+h2) or (y2 >= y1 and y2 <= y1+h1)) then
     return true
  end
end

function doOnGfxResize()
  --reaper.ShowConsoleMsg('doOnGfxResize\n')
  for b in ipairs(els) do -- iterate blocks
    for z in ipairs(els[b]) do -- iterate z
      if els[b][z] ~= nil then
        for j,k in pairs(els[b][z]) do
          if k.onGfxResize then k.onGfxResize(k) end
          doArrange = true
        end
      end
    end
  end
end

function toEdge(self,edge) -- sets an edge to another element's edge. Called by el:arrange()
 if edge == 'left' then -- my left edge
    if self.l[3] == 'left' then reaper.ShowConsoleMsg('left toEdge left not done, isnt that redundant? \n') end
    if self.l[3] == 'right' then return self.l[2].drawX + self.l[2].drawW + (self.x*scaleMult) end
  end
  if edge == 'top' then -- my top edge
    if self.t[3] == 'top' then return self.t[2].drawY + self.y end
    if self.t[3] == 'bottom' then return (self.t[2].drawY or self.t[2].y) + (self.t[2].drawH or self.t[2].h) + (self.y*scaleMult) end
  end
  if edge == 'right' then -- my right edge
    if self.r[3] == 'left' then reaper.ShowConsoleMsg('right toEdge left not done yet\n') end
    if self.r[3] == 'right' then return self.r[2].drawX + self.r[2].drawW - (self.drawX or self.x) + (self.w*scaleMult) end
  end
  if edge == 'bottom' then -- my bottom edge
    if self.b[3] == 'top' then reaper.ShowConsoleMsg('bottom toEdge top not done yet\n') end
    if self.b[3] == 'bottom' then return self.b[2].drawY + self.b[2].drawH - self.drawY + (self.h*scaleMult) end
  end
end

function findBiggestFlowY(el)
  local previousElBiggestY = 0
  if type(el.flow) == 'table' then -- recursively run this while this flow element has its own flow element
    previousElBiggestY = findBiggestFlowY(el.flow) or 0 
  end
  if el.drawY==nil or el.drawH==nil or previousElBiggestY > (el.drawY + el.drawH) then 
    return previousElBiggestY 
    else return el.drawY + el.drawH 
  end
end

function El:arrange()

  if self.belongsToPage and activePage then
    if self.belongsToPage ~= activePage then self.hidden = true
    else if self.hidden == true then -- it shouldn't, change hidden state and update
        self.hidden = nil
        addNeedUpdate(self, true)
      end
    end
  end
  
  if self.hidden==true then return false 
  else
  
    local px, py, pw, ph = 0, 0, 0, 0 
    if self.parent ~= nil then 
      px, py, pw, ph = self.parent.drawX or 0, self.parent.drawY or 0, self.parent.drawW or self.parent.w or 0, self.parent.drawH or self.parent.h or 0 
    else -- else is root to the block
      px, py, pw, ph = els[self.block].x, els[self.block].y, els[self.block].w, els[self.block].h
    end
   
    self.drawX = px+((self.x or 0)+(self.border or 0))*scaleMult + (self.scrollX or 0)
    self.drawY = py+((self.y or 0)+(self.border or 0))*scaleMult + (self.scrollY or 0)
    self.drawW, self.drawH = (self.w or 0)*scaleMult, (self.h or 0)*scaleMult
    if self.hidden == true then self.drawW = 0 end
        
    if self.l ~= nil then self.drawX = self.l[1](self,'left') end
    if self.t ~= nil then self.drawY = self.t[1](self,'top') end
    if self.r ~= nil then self.drawW = self.r[1](self,'right') end
    if self.b ~= nil then self.drawH = self.b[1](self,'bottom') end
    if self.minW ~= nil and self.drawW < self.minW then self.drawW = self.minW end
    if self.minH ~= nil and self.drawH < self.minH then self.drawH = self.minH end
    
    if self.onArrange then self.onArrange(self) end
    
    if self.img and self.hidden ~= true then 
      self.drawImg = scaleToDrawImg(self) -- adds _150 or _200 to name
      if self.imgIdx == nil then self.imgIdx = getImage(self.drawImg) end
      self.measuredImgW, self.measuredImgH = gfx.getimgdim(self.imgIdx)
      local pinkAdjustedImgW, pinkAdjustedImgH = self.measuredImgW, self.measuredImgH
      if bufferPinkValues[self.imgIdx] then pinkAdjustedImgW, pinkAdjustedImgH = self.measuredImgW-2, self.measuredImgH-2 end
  
      if self.iType ~= nil then
        if self.iType == 3 or self.iType == '3_manual' then
          if self.w==nil then self.drawW = pinkAdjustedImgW/3 end
          if self.h==nil then self.drawH = pinkAdjustedImgH end
        elseif self.iType == 'stack' then 
          self.drawW = self.measuredImgW
          self.drawH = self.iFrameH and (self.iFrameH * scaleMult)
        else -- any other iType
          if self.w==nil then self.drawW = pinkAdjustedImgW end
          if self.h==nil then self.drawH = pinkAdjustedImgH end 
        end
      end
  
    end 
    
    if self.text and self.text.resizeToFit==true then
      gfx.setfont(self.text.style or 1)
      self.w = gfx.measurestr(translate(self.text.str))
    end
    
    local b = (self.border or 0)*scaleMult
    if self.flow and self.hidden ~= true then
  
      if self.parent and self.flow == true and self.parent.children then -- runs on first arrange only
        for i=1, #self.parent.children do
          if self.parent.children[i] == self and i>1 then
            if self.parent.children[i-1].hidden ~= true then
              self.flow = self.parent.children[i-1] -- replace self.flow with a pointer to the previous child
            end
            break
          end
        end
      end
      
      if type(self.flow) == 'table' and pw>0 then -- then that's a valid flow element
        --reaper.ShowConsoleMsg('px:'..px..'   pw:'..pw..'   self.flow.drawX:'..self.flow.drawX..'  self.flow.drawW:'..self.flow.drawW..'\n')
        local fx, fy = (self.flow.drawX or 0) + (self.flow.drawW or 0) + (self.x*scaleMult or 0) + b, (self.y*scaleMult) + (self.flow.drawY or 0)
        if fx + b + self.drawW > px+pw then -- then flow to next row
          fx = (self.x*scaleMult or 0) + px + b
          fy = findBiggestFlowY(self.flow) + (self.y*scaleMult or 0) + b
        end
        self.drawX, self.drawY = fx, fy
      
        
      end 
      
    end
    
    if self.parent and self.parent.trackBiggestY==true then -- trackBiggestY and .biggestY are used to determine the block's scrollableH
      local withinBiggestY = self.parent.biggestY and self.parent.biggestY>(self.drawY + self.drawH)
      if not withinBiggestY then -- he has a wife, you know...
        if self.parent.biggestY == nil or self.parent.biggestY<(self.drawY + self.drawH) then 
          self.parent.biggestY = self.drawY + self.drawH 
          els[self.block].scrollableH = self.parent.biggestY -- and set the block's scrollableH
          --reaper.ShowConsoleMsg('set scrollableH to '..els[self.block].scrollableH..'\n') 
        end
      end
    end
    
    --check final position, cull if outside parent
    if self.drawX > px+pw then -- fully to the right of parent
      self.drawW = 0 -- using zero width (instead of some kind of 'don't draw' state) so that dirtyCheck notices
    end
  
    return true
  
  end
end


function clipped_rect(clipR, clipB, x,y,w,h,fill)
  if x < clipR and y < clipB then
    if fill == false then
      gfx.rect(x,y,math.min(w, clipR+1-x),math.min(h, clipB+1-y), false)
    else
      gfx.rect(x,y,math.min(w, clipR-x),math.min(h, clipB-y))
    end
  end
end

  --------- DRAW ----------
function El:draw(offsX,offsY, clipR, clipB)
  gfx.a = 1 -- reset that
  local x,y,w,h = self.drawX or self.x or 0, self.drawY or self.y or 0, self.drawW or self.w or 0, self.drawH or self.h or 0
  x, y = x-offsX, y-offsY
  local col = self.drawCol or self.col or nil
  if col ~= nil then -- fill
    setCol(col)
    if self.shape ~= nil then
      if self.shape == 'circle' and self.w ~= 0 then  gfx.circle(x+w/2,y+w/2,w/2,1,1) end
      if self.shape == 'evenCircle' and self.w ~= 0 then 
        x=x-1
        gfx.circle(x+w/2,y+(w/2),(w-2)/2,1,1) 
        gfx.circle(x+w/2,y+(w/2)-1,(w-2)/2,1,1)
        gfx.circle(x+(w/2)+1,y+(w/2)-1,(w-2)/2,1,1)
        gfx.circle(x+(w/2)+1,y+(w/2),(w-2)/2,1,1)
      end
      if self.shape == 'capsule' and self.w ~= 0 then
        clipped_rect(clipR, clipB, x+h/2,y,w-h,h)
        gfx.circle(x+h/2,y+(h/2),(h-2)/2,1,1)
        gfx.circle(x+w-h/2,y+(h/2),(h-2)/2,1,1)
        gfx.circle(x+h/2,y+(h/2)-1,(h-2)/2,1,1)
        gfx.circle(x+w-h/2,y+(h/2)-1,(h-2)/2,1,1)
      end
      if self.shape == 'poly' and self.w ~= 0 then
        local passList = {}
        for i,v in pairs(self.coords) do
          table.insert(passList, (v[1]*scaleMult) +x)
          table.insert(passList, (v[2]*scaleMult) +y)
        end
        gfx.triangle(table.unpack(passList))
      end
      if self.shape == 'gradient' and self.w ~= 0 then 
        local rDeg = (self.deg or 90) * math.pi / 180
        local colA = self.colA or {0,0,0,255}
        local colB = self.colB or {255,255,255,255}
        local a,b = fromRgbCol(colA), fromRgbCol(colB)
        local dr, dg, db, da = b[1]-a[1], b[2]-a[2], b[3]-a[3], b[4]-a[4]
        local drdx, drdy = math.cos(rDeg) * dr / w, math.sin(rDeg) * dr / h
        local dgdx, dgdy = math.cos(rDeg) * dg / w, math.sin(rDeg) * dg / h
        local dbdx, dbdy = math.cos(rDeg) * db / w, math.sin(rDeg) * db / h
        local dadx, dady = math.cos(rDeg) * da / w, math.sin(rDeg) * da / h
        gfx.gradrect(x,y,math.min(w,clipR-x),math.min(h,clipB-y),
            a[1],a[2],a[3],a[4],drdx,dgdx,dbdx,dadx,drdy,dgdy,dbdy,dady)
      end
      
      if self.shape == 'horizDash' and self.w ~= 0 then 
        local dashW, gapW = (self.dash.w or 8) * scaleMult, (self.dash.gap or 2) * scaleMult 
        if self.dash.direction and self.dash.direction=='reverse' then
          local endX = x+w
          while endX > x do
            if (endX-dashW) < x then dashW = endX-x end
            clipped_rect(clipR, clipB, endX-dashW,y,dashW,h)
            endX = endX - dashW - gapW
          end
        else
          local endX = x
          while endX < (x+w) do
            if (endX + dashW) > (x+w) then dashW = x+w-endX  end
            clipped_rect(clipR, clipB, endX,y,dashW,h)
            endX = endX + dashW + gapW
          end
        end
      end
      
      if self.shape == 'vertDash' and self.w ~= 0 then 
        local dashH, gapH = (self.dash.h or 8) * scaleMult, (self.dash.gap or 2) * scaleMult 
        if self.dash.direction and self.dash.direction=='reverse' then
          local endY = y+h
          while endY > y do
            if (endY-dashH) < y then dashH = endY-y end
            clipped_rect(clipR, clipB, x, endY-dashH,w,dashH)
            endY = endY - dashH - gapH
          end
        else
          local endY = y
          while endY < (y+h) do
            if (endY + dashH) > (y+h) then dashH = y+h-endY  end
            clipped_rect(clipR, clipB, x,endY,w,dashH)
            endY = endY + dashH + gapH
          end
        end
      end
      
    else clipped_rect(clipR, clipB, x,y,w,h)
    end
  end
  if self.strokeCol ~= nil then -- stroke
    local c = fromRgbCol(self.strokeCol)
      gfx.set(c[1],c[2],c[3],c[4])
      if self.shape ~= nil then reaper.ShowConsoleMsg('non-rectangular strokes not done yet in El:draw\n') 
      else clipped_rect(clipR, clipB, x,y,w,h,false)
      end
  end
  if self.text ~= nil then
    if self.text.val ~=nil then self.text.str = self.text.val() end
    local p = self.text.padding or textPadding
    if self.text.resizeToFit==true then p=0 end
    local tx,tw = x + p, w - 2*p
    local style = (self.text.style + textScaleOffs) or 1
    local thisBaselineShift = baselineShift[style] or 0
    text(self.text.str,tx,y+thisBaselineShift,tw,h,self.text.align,self.text.col,style,self.text.lineSpacing,self.text.vCenter,self.text.wrap)
  end
 
  if self.drawImg ~= nil and self.w ~= 0 then
 
    local pinkXY, pinkWH, imgW, imgH = 0,0,self.measuredImgW, self.measuredImgH
    if bufferPinkValues[self.imgIdx] then 
      pinkXY, pinkWH, imgW, imgH = 1, 2, self.measuredImgW-2, self.measuredImgH-2
    end

    gfx.a = (self.img.a or 255) / 255
    if self.iType == 'stack' then 
      local iFrameHScaled = self.iFrameH * scaleMult  
      if self.iFrameC == nil then self.iFrameC = self.measuredImgH / iFrameHScaled end
      local frame = (self.iFrame or 0) * iFrameHScaled 
      iFrameHScaled = math.min(iFrameHScaled, clipB - y)
      gfx.blit(self.imgIdx, 1, 0, 0, frame, self.measuredImgW, iFrameHScaled, x, y, w, iFrameHScaled)
      
    elseif self.iType == 3 or self.iType == '3_manual' then -- a 3 frame button
      local frameW = imgW/3
      if w==0 then w=frameW end
      if h==0 then h=imgH end
      
      if bufferPinkValues[self.imgIdx] then
        if frameW==w  and imgH==h  then --if this image is going to drawn at size, just draw it.
          h = math.min(h, clipB - y)
          gfx.blit(self.imgIdx, 1, 0, (self.iFrame or 0)*frameW +pinkXY, pinkXY, w, h, x, y, w, h)
        else
          local tx, ly, bx,ry = bufferPinkValues[self.imgIdx].tx, bufferPinkValues[self.imgIdx].ly, bufferPinkValues[self.imgIdx].bx, bufferPinkValues[self.imgIdx].ry
          local unstretchedC2W, unstretchedR2H = frameW+2 -tx -bx, imgH+2 -ly -ry    --frameW rather than imgH in this case, because it is a 3 state image
          local stretchedC2W, stretchedR2H = w -tx -bx +2, h -ly -ry +2
          pinkBlit(self.imgIdx, ((self.iFrame or 0)*frameW), 0, x, y, tx, ly, bx, ry, unstretchedC2W, unstretchedR2H, stretchedC2W, stretchedR2H)
        end
      else --3 frame button with no pink
        if self.iFlip == true then gfx.blit(self.imgIdx, 1, 0, (self.iFrame or 0)*frameW + frameW, h, -1*w, -1*h, x, y, w, h)
        else
          h = math.min(h, clipB - y)
          gfx.blit(self.imgIdx, 1, 0, (self.iFrame or 0)*frameW, 0, w, h, x, y, w, h)
        end
      end
      
    elseif self.iType ~= nil then
      if bufferPinkValues[self.imgIdx] then
        if imgW==w  and imgH==h  then --if this image is going to drawn at size, just draw it.
          h = math.min(h, clipB - y)
          gfx.blit(self.imgIdx, 1, 0, (self.iFrame or 0)*w +pinkXY, pinkXY, w, h, x, y, w, h)
        else --draw the image using pink stretching.
          local tx, ly, bx,ry = bufferPinkValues[self.imgIdx].tx, bufferPinkValues[self.imgIdx].ly, bufferPinkValues[self.imgIdx].bx, bufferPinkValues[self.imgIdx].ry
          pinkBlit(self.imgIdx, 0, 0, x, y, tx, ly, bx, ry, self.measuredImgW-tx-bx, self.measuredImgH-ly-ry, w-tx-bx+pinkWH, h-ly-ry+pinkWH)
        end
      else --image with no pink
        h = math.min(h, clipB - y)
        gfx.blit(self.imgIdx, 1, 0, (self.iFrame or 0)*w, 0, w, h, x, y, w, h)
      end
    
    else 
      gfx.blit(self.imgIdx, 1, 0, 0, 0, self.measuredImgW, self.measuredImgH, x, y, w, h)
    end
    
  end
end



  --------- MOUSE ---------
  
function El:mouseOver()
  if self.mouseOverCol ~= nil then 
    self.drawCol = self.mouseOverCol
    self:addToDirtyZone()
  end
  if self.onMouseOver then self:onMouseOver() end
  if self.mouseOverCursor ~= nil then
    --gfx.setcursor(429,1) -- hand
    gfx.setcursor(0,self.mouseOverCursor)
  end
  if self.img ~= nil then
    if self.iType ~= nil and self.iType == 3 then
      self.iFrame = 1
      self:addToDirtyZone()
    end
    if self.mouseOverImg then
      if self.mouseAwayImg==nil then self.mouseAwayImg=self.img end
      self.img = self.mouseOverImg
      self:reloadImg()
    end
  end
end

function El:mouseAway()
  if self.mouseOverCol ~= nil then 
    self.drawCol = self.col
    self:addToDirtyZone()
  end
  if self.onMouseAway then self:onMouseAway() end
  if self.mouseOverCursor ~= nil then
    gfx.setcursor(1,1)
  end
  if self.img ~= nil then
    if self.iType ~= nil and self.iType == 3 then
      self.iFrame = 0
      self:addToDirtyZone()
    end
    if self.mouseAwayImg then
      self.img = self.mouseAwayImg
      self:reloadImg()
    end
  end
  reaper.TrackCtl_SetToolTip('',0,0,true)
  removeTimer(self,'toolTip')
end

function El:mouseDown()
  if self.img ~= nil then
    if self.iType ~= nil and self.iType == 3 then
      self.iFrame = 2
      self:addToDirtyZone()
    end
  end
  if self.onClick ~= nil and singleClick ~= true then
    singleClick = true
    self:onClick()
  end
  if self.onDrag then
    dX, dY = mouseDrag(self)
    self.onDrag(dX, dY)
  end
end

function El:mouseUp()
  --reaper.ShowConsoleMsg('mouseUp\n')
  if draggingEl and draggingEl.onMouseUp~=nil then
    draggingEl.onMouseUp()
  else
    if self.onMouseUp ~= nil then
      self.onMouseUp()
    end
  end
end

function mouseDrag(self)
  if dragStart == nil then 
    dragStart = {x=gfx.mouse_x, y=gfx.mouse_y}
    draggingEl = self
  end
  local dX, dY = gfx.mouse_x - dragStart.x, gfx.mouse_y - dragStart.y
  
  local ctrl = gfx.mouse_cap&4
  if ctrl == 4 then -- ctrl
    if dragStart.fine ~= true then
      dragStart = {x=dragStart.x+dX, y=dragStart.y+dY}
      dragStart.fine = true
    end
    dX, dY = (gfx.mouse_x - dragStart.x)*0.25, (gfx.mouse_y - dragStart.y)*0.25
  end
  return dX/scaleMult, dY/scaleMult --divide by scaleMult because all calculations are at 100%
end

function El:showTooltip()
  if self.toolTip ~= nil then
    if addTimer(self,'toolTip',0.5) == true then
      if self.onTimerComplete == nil then self.onTimerComplete = {} end
      self.onTimerComplete.toolTip = function()
          local windX, windY = reaper.GetMousePosition()
          reaper.TrackCtl_SetToolTip(self.toolTip, windX, windY,false)
        end
    end
  end
end

function El:doubleClick() 
  if self.onDoubleClick ~= nil then
    if type(self.onDoubleClick) == 'string' then
      if self.onDoubleClick == 'reset' then reaper.ShowConsoleMsg('do reset value\n') end
    else self.onDoubleClick(self)
    end
  end
end

function El:mouseWheel(wheel_amt)
  if self.onMouseWheel ~= nil then
    self.onMouseWheel(wheel_amt, self)
  end
end

  --------- POPULATE ----------

indexParams()
setScale(1)
scaleFactor = 100
boxBorder = 20

function Populate()
    
  Block:new({x=0, y=0, w=160, h=800,
    onArrange = function()
      els[1].h = gfx.h / scaleMult
    end
    })
  
  sidebarBox = El:new({block=1, z=1, x=0, y=0, w=160, h=10, col=c_Grey20, interactive=false,
    onGfxResize = function()
      sidebarBox.h = gfx.h / scaleMult
      sidebarBox.isDirty = true
    end
    })
   
  pageController = Controller:new({parent=sidebarBox, x=0, y=0, w=0, h=0, 
    onNewValue = function(k)
    
      if k.paramV==0 then k.paramV = activePage or 'TCP' end
      local changedPage = activePage ~= k.paramV
      activePage = k.paramV
      local pageButtonHeight = 66
      pageMenu.h = 0
      
      if string.sub(themeTitle,1,11)=='Default_7.0' and errorLog~=nil then showPages.Errors=true else showPages.Errors=false end
      
      for i,v in ipairs(pageMenu.children) do
        if showPages[v.value]==true then 
          v.h = pageButtonHeight
          v.children[1].hidden, v.children[2].hidden, v.children[3].hidden = false, false, false
          pageMenu.h = pageMenu.h + pageButtonHeight
        else
          v.h = 0
          v.children[1].hidden, v.children[2].hidden, v.children[3].hidden = true, true, true
        end
      end
      
      if not els[2][1][2].y or not els[2].scrollY or changedPage == true then
        els[2][1][2].y, els[2].scrollY = 0, 0 -- reset the actual scrollbar on page change. 
      end

      if previousActivePage==nil or previousActivePage~=activePage and bodyBox~=nil then
        --reaper.ShowConsoleMsg('**PAGE CHANGE** to '..k.paramV..'\n')
        els[2].scrollableH = nil
        previousActivePage = activePage
      end
      
      bodyScrollbar:addToDirtyZone()
      bodyBox:addToDirtyZone()
    end
    }) 
    
  pageMenu = El:new({parent=sidebarBox, x=0, y=12, z=2, flow=true, border=0, w=160, h=0, col=c_Grey20 }) -- CAUTION my height is dynamic
  pageMenuButton:new({parent=pageMenu, buttonImg='page_global', textStr='GLOBAL', value='Global'})
  pageMenuButton:new({parent=pageMenu, buttonImg='page_global', textStr='GLOBAL', value='Generic_Global'})
  pageMenuButton:new({parent=pageMenu, buttonImg='page_theme', textStr='THEME CONTROLS', value='Generic'})
  pageMenuButton:new({parent=pageMenu, buttonImg='page_tcp', textStr='TRACK CONTROLS', value='TCP'})
  pageMenuButton:new({parent=pageMenu, buttonImg='page_envcp', textStr='ENVELOPE CONTROLS', value='EnvCP'})
  pageMenuButton:new({parent=pageMenu, buttonImg='page_mcp', textStr='MIXER CONTROLS', value='MCP'})
  pageMenuButton:new({parent=pageMenu, buttonImg='page_trans', textStr='TRANSPORT', value='Transport'})
  pageMenuButton:new({parent=pageMenu, buttonImg='page_error', textStr='ERROR REPORT', value='Errors', textCol={179,61,81}})
    
   
  El:new({parent=sidebarBox, x=10, y=-36, w=34, h=26, t={toEdge, sidebarBox, 'bottom'}, img='monitorScale', 
      onMouseOver = function(k)
        k.toolTip='Display scale of this monitor is '..(scaleMult*100)..'%'
      end
    })

  
  Block:new({x=0, y=0, w=0, h=0, 
    onArrange = function()
      els[2].h = gfx.h / scaleMult
      els[2].w = gfx.w / scaleMult  - 16 - els[1].w 
      addNeedUpdate(bodyBox, true)
    end})
  
    
  bodyBox = El:new({block=2, z=1, x=0, y=0, h=100, col={35,35,35}, trackBiggestY=true,
    onGfxResize = function() 
      addNeedUpdate(bodyBox, true)
      bodyBox:addToDirtyZone()
    end,
    onUpdate = function(k)
      k.w = els[k.block].w
      k.h =  els[k.block].h
      if els[k.block].scrollableH and (els[k.block].scrollableH > els[k.block].h) then
        k.h = els[k.block].scrollableH
      end
      k.biggestY = nil
    end,
    onMouseWheel = function(wheel_amt_unscaled)
      bodyScrollbar.children[1].onMouseWheel(wheel_amt_unscaled)
    end
    ,
    onArrange = function(k)

      local border = 20
      local containerW = k.drawW/scaleMult or k.w
      local nextX, nextY = 0,0
      local profile, rowProfile = {}, {} 
      
      for i,b in pairs(k.children) do
        
        if b.hidden~=true and b.tile==true then
          b.border = 0
          b.x= nextX + border
          
          if (b.x+b.w+border)>containerW then -- won't fit, move to a new row
            b.x = border
            profile = {}  -- empty the profile
            for r,s in pairs(rowProfile) do profile[r]=s end -- copy current rowProfile's entries into to profile
            rowProfile = {} -- empty rowProfile to start afresh
          end
          
          local readV = 0
          for r=0,b.x do --look through the beginning, find most recent profile value when b.x is reached 
            if profile[r] and profile[r]~=0 then 
              readV = profile[r] 
            end
          end
          
          nextY = readV + border
          for r=b.x,b.x+b.w+border do --now look through across the width of the box and find the highest profile
            if profile[r] and profile[r]>nextY then nextY = profile[r] + border end
          end
          
          rowProfile[b.x] = b.y+b.h
          b.y = nextY
          nextX = b.x + b.w
        end
      end
    end
      
  })
    
  
    
  ccGammaController = Controller:new({parent=bodyBox, x=0, y=0, w=6, h=0, param = -1000, remapToMin = 25, remapToMax = 200, desc = 'Gamma', units = 'γ' })  
  ccHighlightsController = Controller:new({parent=bodyBox, x=10, y=0, w=6, h=0,  param = -1003, remapToMin = -100, remapToMax = 100, desc = 'Highlights', units = '' })
  ccMidtonesController = Controller:new({parent=bodyBox, x=20, y=0, w=6, h=0, param = -1002, remapToMin = -100, remapToMax = 100, desc = 'Midtones', units = '' })
  ccShadowsController = Controller:new({parent=bodyBox, x=30, y=0, w=6, h=0, param = -1001, remapToMin = -100, remapToMax = 100, desc = 'Shadows', units = '' })
  ccSaturationController = Controller:new({parent=bodyBox, x=40, y=0, w=6, h=0, param = -1004, remapToMin = 0, remapToMax = 200, desc = 'Saturation', units = '%' })
  ccTintController = Controller:new({parent=bodyBox, x=50, y=0, w=6, h=0, param = -1005, remapToMin = -180, remapToMax = 180, desc = 'Tint', units = '°' })
  ccResetController = Controller:new({parent=bodyBox, controlType = '', x=60, y=0, w=6, h=0,
    onClick = function()
      ccGammaController:resetToDefault()
      ccHighlightsController:resetToDefault()
      ccMidtonesController:resetToDefault()
      ccShadowsController:resetToDefault()
      ccSaturationController:resetToDefault()
      ccTintController:resetToDefault()
    end
    })
  ccAlsoCustomController = Controller:new({parent=bodyBox, param = -1006, x=60, y=0, w=6, h=0  })
  
    
  Block:new({x=0, y=0, w=16, h=800,
    onArrange = function()
      els[3].h = gfx.h
    end})
    
  bodyScrollbar = ScrollbarV:new({block=3, z=1, x=0, y=0, scrollbarOfBlock=2 })
  
  activeLayoutController = Controller:new({parent=bodyBox, x=0, y=0, w=6, h=0,
    onNewValue = function(k)
      if k.lastActiveLayout==nil or k.lastActiveLayout~=activeLayout then 
        updateAnyNotHidden=true
        k.lastActiveLayout = activeLayout
      end
    end
    })
    
  paramsResetController = Controller:new({parent=bodyBox, controlType = '', x=60, y=0, w=6, h=0,
    onClick = function()
      if reaper.MB(
        translate("This will reset to default values any changes you have made with this Theme Adjuster."), 
        translate("Reset to default values"), 1) == 1 then
        
        local i=-1005
        local retval,tmp,val,def = reaper.ThemeLayout_GetParameter(i)
        while retval ~= nil do
          if val~=def then reaper.ThemeLayout_SetParameter(i, def, true) end
          if i==-1000 then i=0 end
          i = i+1
          retval,tmp,val,def = reaper.ThemeLayout_GetParameter(i)
        end
        ThemeLayout_RefreshAll = true
        
        clearAllParamV()
        
      end
    end
    })
    
  
  paramsExportController = Controller:new({parent=bodyBox, controlType = '', x=60, y=0, w=6, h=0, onClick = function() ExportParams() end })
  paramsExportAllController = Controller:new({parent=bodyBox, controlType = '', x=60, y=0, w=6, h=0, onClick = function() ExportParams(true) end })
    
  paramsLoadController = Controller:new({parent=bodyBox, controlType = '', x=60, y=0, w=6, h=0,
    onClick = function()
     
      local retval, importFile  = reaper.GetUserFileNameForRead(script_path.."/", "Import parameter values from File", "Default7themeAdjustment") 
      if retval == true then
        g_last_exported_name = importFile:match(".*[/\\](.*)%..+")
        for line in io.lines(importFile) do
          local param, val = line:match("(.+)=(.+)")
          local pIdx = 10000
          if string.sub(param, 1, 6) == 'Layout' then
            pIdx = paramsIdx[string.sub(param, 8, 8)][string.sub(param, 12, -1)]
          elseif (param=='Gamma' or param=='Highlights' or param=='Midtones' or param=='Shadows' or param=='Saturation' or param=='Tint') then
            if param=='Gamma' then pIdx = -1000 end
            if param=='Highlights' then pIdx = -1003 end
            if param=='Midtones' then pIdx = -1002 end
            if param=='Shadows' then pIdx = -1001 end
            if param=='Saturation' then pIdx = -1004 end
            if param=='Tint' then pIdx = -1005 end
          else pIdx = paramsIdx.global[param]
          end
          paramSet(pIdx, val)
        end
        
        if purgeAll() == true then
          indexParams()
          Populate()
          updateAnyNotHidden = true
          doArrange = true
        end
        
      end
    end
    })
    
  refreshThemeController = Controller:new({parent=bodyBox, controlType = '', x=60, y=0, w=6, h=0, 
    onClick = function()
      local theme = reaper.GetLastColorThemeFile()
      if theme then reaper.OpenColorThemeFile(theme) end
      reaper.ThemeLayout_RefreshAll()
    end })
    
  displayRedrawsController = Controller:new({parent=bodyBox, x=0, y=0, w=0, h=0, desc='Show Redraws',
    onUpdate = function(k)
      k.paramV = displayRedraws or 0
      for i in ipairs (k.agents) do if k.agents[i].onNewValue then k.agents[i]:onNewValue() end end
    end,
    onClick = function(k)
      if displayRedraws == 1 then
        displayRedraws = 0
      else
        displayRedraws = 1
      end
      k.target:onUpdate()
    end
    }) 
        
        
  ---------------------------------------------------
  --------------------- GLOBAL ----------------------
  ---------------------------------------------------      
        
  belongsToPage = 'Global' 
  
 
  globalBox = El:new({parent=bodyBox, x=0, y=0, border=boxBorder, w=500, h=202, col=c_Grey20 })
  TitleBar:new({parent=globalBox, x=0, y=0, layouts='none', text={str='Global Colors'} })
 
  globalColsDiag = El:new({parent=globalBox, x=0, y=0, border=0, w=500, h=174, flow = true, col=c_Grey20 })
  globalColLabelsController = Controller:new({parent=bodyBox, x=10, y=10, w=6, h=0, paramDesc = 'Custom Color Track Labels' })
  Button:new({parent=globalColsDiag, x=80, y=10, style='button', target=globalColLabelsController, img='button_upArrow_off', imgOn='button_upArrow_on', iFlip=true, iType=3 })
  Label:new({parent=globalColsDiag, x=4, y=4, w=60, h=20, flow=true, target=globalColLabelsController, 
    text={str='Apply custom color to track labels', style=2, align=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO } })
  
  globalColsDiagBg = El:new({parent=globalColsDiag, x=20, y=50, border=0, w=197, h=73, col=c_CyanGrey, interactive = false })
  El:new({parent=globalColsDiagBg, x=20, y=0, w=1, h=36, col={0,0,0,128}, interactive = false })
  El:new({parent=globalColsDiagBg, x=20, y=37, w=1, h=36, col={0,0,0,128}, interactive = false })
  El:new({parent=globalColsDiagBg, x=0, y=36, w=197, h=1, col={0,0,0,84}, interactive = false })
  
  egCustomColor = {255,0,0,255}
  if #projectCustCols>0 then egCustomColor = projectCustCols[math.random(1,#projectCustCols)] end
  El:new({parent=globalColsDiag, x=242, y=50, z=2, w=24, h=24, col={82,82,82}, shape='evenCircle', interactive = false })
  El:new({parent=globalColsDiag, x=456, y=50, z=2, w=24, h=24, col={egCustomColor[1],egCustomColor[2],egCustomColor[3]}, shape='evenCircle', interactive = false })
  El:new({parent=globalColsDiag, x=254, y=50, z=2, w=212, h=24, col={0}, shape='gradient', colA={82,82,82}, colB={egCustomColor[1],egCustomColor[2],egCustomColor[3]}, deg=0, interactive = false }) 
  El:new({parent=globalColsDiag, x=252, y=60, z=2, w=218, h=4, col=c_Grey15, shape='capsule', interactive = false })
  
  
  colStrengthController = Controller:new({parent=globalColsDiag, x=30, y=0, w=6, h=6, paramDesc='Custom Color Strength', desc = 'Custom Color Strength', units = '%' })
  textBrightController = Controller:new({parent=globalColsDiag, x=30, y=0, w=6, h=6, paramDesc='Text Brightness', desc = 'Global Text Brightness', units = '%' })
  colStrengthFaderBound = FaderBoundary:new({parent=globalColsDiag, target=colStrengthController, x=242, y=50, w=240, h=24 })
  Fader:new({parent=globalColsDiag, target=colStrengthController, faderW=234, faderX=244, x=0, y=48, boundaryElement=colStrengthFaderBound}) 
  ccControls:new({parent=globalColsDiag, x=266, y=82, target=colStrengthController  })
  El:new({parent=globalColsDiagBg, target=colStrengthController, x=0, y=0, w=20, h=36, col={egCustomColor[1],egCustomColor[2],egCustomColor[3]}, interactive = false })
  MiscAgent:new({parent=globalColsDiagBg, target=colStrengthController, x=21, y=0, w=176, h=36, col= egCustomColor, interactive = false,
    onNewValue = function(k)
      if k.col then k.col[4] = k.target.paramV*2.5 end 
      k.parent.isDirty=true
    end
    })
  
  custColorTrackCapsule = MiscAgent:new({parent=globalColsDiagBg, x=27, y=6, w=150, h=24, col=c_Grey15, shape='capsule', interactive = false, target=globalColLabelsController,
    text={str='Custom Color Track', style=3, padding=12, align=4, col=c_Grey70}, 
    onNewValue = function(k)
      if k.target.paramV==1 then 
        k.text.col = {egCustomColor[1],egCustomColor[2],egCustomColor[3]}
      else 
        local mult = textBrightController.paramV or 100
        k.text.col = {mult*2,mult*2,mult*2} 
      end
      k.parent.isDirty=true
    end
    })
   
  CapsuleFader:new({parent=globalColsDiag, x=242, y=110, w=238, target=textBrightController  })
  ccControls:new({parent=globalColsDiag, x=266, y=142, target=textBrightController  })  
  MiscAgent:new({parent=globalColsDiagBg, target=textBrightController, x=27, y=43, w=150, h=24, col=c_Grey15, shape='capsule', interactive = false, 
    text={str='Default Color Track', style=3, padding=12, align=4, col=c_Grey70}, 
    onNewValue = function(k)
      k.text.col = {k.target.paramV*2,k.target.paramV*2, k.target.paramV*2}
      custColorTrackCapsule:onNewValue()
      selectedTrackCapsule:onNewValue()
    end
    })
    
  
  selectionBox = El:new({parent=bodyBox, x=0, y=0, border=boxBorder, w=500, h=202, flow = true, col=c_Grey20 })
  El:new({parent=selectionBox, x=0, y=0, w=0, r={toEdge, selectionBox, 'right'}, h=26, col=c_Grey10, text={str='Indication of track selection', style=3, align=4, col=c_Grey50} }) 
 
  selStrengthController = Controller:new({parent=selectionBox, x=30, y=0, w=6, h=6, paramDesc='Selection Overlay Strength', desc = 'Selection Overlay Strength', units = '%' })
  CapsuleFader:new({parent=selectionBox, x=12, y=20, w=224, flow=true, target=selStrengthController  })
  ccControls:new({parent=selectionBox, x=260, y=48, target=selStrengthController  })
  
  selDiagBg = El:new({parent=selectionBox, x=0, y=70, border=20, w=147, h=73, col=c_CyanGrey, interactive = false })
  El:new({parent=selDiagBg, x=20, y=0, w=1, h=36, col={0,0,0,128}, interactive = false })
  El:new({parent=selDiagBg, x=20, y=37, w=1, h=36, col={0,0,0,128}, interactive = false })
  El:new({parent=selDiagBg, x=0, y=36, w=147, h=1, col={0,0,0,84}, interactive = false })
  MiscAgent:new({parent=selDiagBg, target=selStrengthController, x=21, y=0, w=126, h=36, col={255,255,255,255}, 
    onNewValue = function(k)
      k.col = {255,255,255,k.target.paramV*2.5}
      k.isDirty=true
    end
    })
  
  invertLabelsController = Controller:new({parent=selectionBox, x=200, y=60, w=6, h=6, paramDesc = 'Selection Invert Labels' })
  Button:new({parent=selectionBox, x=172, y=96, style='button', target=invertLabelsController, img='button_leftArrow_off', imgOn='button_leftArrow_on', iType=3 })
  Label:new({parent=selectionBox, x=4, y=4, w=60, h=20, flow=true, target=invertLabelsController, 
    text={str='Invert label text & background', style=2, align=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO} })
  
  selectedTrackCapsule = MiscAgent:new({parent=selDiagBg, x=27, y=6, w=100, h=24, col={227,228,228}, shape='capsule', interactive = false, target=invertLabelsController,
    text={str='Selected', style=3, padding=12, align=4, col=c_Grey20}, 
    onNewValue = function(k)
      if k.target.paramV==1 then 
        k.col={227,228,228} 
        k.text.col=c_Grey20
      else 
        k.col=c_Grey15 
        local mult = textBrightController.paramV or 100
        k.text.col = {mult*2,mult*2,mult*2} 
      end
      k.isDirty = true
    end
    })
  MiscAgent:new({parent=selDiagBg, target=textBrightController, x=27, y=43, w=100, h=24, col=c_Grey15, shape='capsule', interactive = false, 
    text={str='Unselected', style=3, padding=12, align=4, col=c_Grey70}, 
    onNewValue = function(k)
      k.text.col = {k.target.paramV*2,k.target.paramV*2, k.target.paramV*2}
      k.isDirty = true
    end
    })

  selDotController = Controller:new({parent=selectionBox, x=40, y=0, w=6, h=6, paramDesc = 'Selection Dot' })
  Button:new({parent=selDiagBg, x=10, y=12, w=20, h=12, target=selDotController, img='selDotOff', imgOn='selDotSel', iType=3 })
  Button:new({parent=selDiagBg, x=10, y=48, w=20, h=12, target=selDotController, img='selDotOff', imgOn='selDotUnsel', iType=3 })
  Button:new({parent=selectionBox, x=28, y=160, style='button', target=selDotController, img='button_upArrow_off', imgOn='button_upArrow_on', iType=3 })
  Label:new({parent=selectionBox, x=4, y=14, w=60, h=20, flow=true, target=selDotController, 
    text={str='Show selection dot', style=2, align=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO } })

  
  
  
  
  
  custColBox = El:new({parent=bodyBox, x=0, y=0, w=500, h=396, border=boxBorder, flow = true, col=c_Grey20 })
  El:new({parent=custColBox, x=0, y=0, w=0, r={toEdge, custColBox, 'right'}, h=26, col=c_Grey10, text={str='Custom Color Palettes', style=3, align=4, col=c_Grey50} })
  
  chosenPaletteController = Controller:new({parent=sidebarBox, x=0, y=0, w=0, h=0, 
    onNewValue = function(k)
    
      if k.value then chosenPalette = k.value end
      chosenPaletteTitle.text.str, chosenPaletteTitle.isDirty = chosenPalette, true
      for i=1,10 do
        selPal.children[i].col = palette[chosenPalette][i]
        selPal.children[i].children[1].colA=compositeCols(palette[chosenPalette][i], c_Grey20, 0.6)
        selPal.children[i].children[1].colB=compositeCols(palette[chosenPalette][i], c_Grey20, 1)
      end
      selPal.isDirty = true
      
      local nextPal = 1
      local palOrder = {'REAPER', 'PRIDE', 'WARM', 'COOL', 'VICE', 'EEEK', 'CASABLANCA', 'CHAUFFEUR', 'SPLIT'}
      for i,v in pairs(palOrder) do
        if palChoiceBox and v ~= chosenPalette then
          for j=1,10 do
            palChoiceBox.children[nextPal].children[j].col = palette[v][j]
          end
          palChoiceBox.children[nextPal].children[12].text.str = v
          palChoiceBox.children[nextPal].children[13].value = v
          nextPal = nextPal + 1
        end
      end
      palChoiceBox.isDirty, doArrange = true, true
      
    end
    }) 
    
  recolProjectController = Controller:new({parent=bodyBox, controlType = '', x=60, y=0, w=6, h=0, onClick = function() applyPalette() end })
  
  

  selPal = El:new({parent=custColBox, x=30, y=30, w=440, h=44, flow=true })
  for i=1,10 do
    local b = Button:new({parent=selPal, x=0, y=0, w=44, h=44, flow=true, border=0, col=palette[chosenPalette][i], target=selDotController, img='color_apply', iType=3, 
      toolTip='Apply to selected tracks', onClick = function(k) applyCustCol(k.col) end })
    El:new({parent=b, x=0, y=44, w=44, h=30, col={}, shape='gradient', interactive = false, 
      colA=compositeCols(palette[chosenPalette][i], c_Grey20, 0.6), colB=compositeCols(palette[chosenPalette][i], c_Grey20, 1)  })
  end
  
  Button:new({parent=custColBox, x=30, y=6, flow=true, style='button', target=recolProjectController, img='apply_colour_all', iType=3 })
  Label:new({parent=custColBox, flow=true, x=4, y=8, w=60, h=20, z=2, target=recolProjectController, 
    text={str='Recolor project using this palette', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end
    })
    
  chosenPaletteTitle = El:new({parent=custColBox, x=270, y=106, w=200, h=30, z=2, interactive = false, 
    text={str=chosenPalette, style=4, align=6, padding=0, col=c_Grey60 }     })
  
  palChoiceBox = El:new({parent=custColBox, x=0, y=160, w=500, h=236, col=c_Grey10 })
  for i=1,8 do paletteChoice:new({parent=palChoiceBox, loc=i }) end
  
  
  
  
  
 
  colControlBox = El:new({parent=bodyBox, x=0, y=0, w=500, h=396, border=boxBorder, flow = true, col=c_Grey15 })
  El:new({parent=colControlBox, x=0, y=0, w=0, r={toEdge, colControlBox, 'right'}, h=26, col=c_Grey10, text={str='Color Processing', style=3, align=4, col=c_Grey50} }) 
  
  CapsuleFader:new({parent=colControlBox, x=20, y=46, w=460, target=ccGammaController, colA={121,121,121}, colB={58,58,58}, faderTrack=false  })
  ccControls:new({parent=colControlBox, x=20, y=78, target=ccGammaController  })
  
  CapsuleFader:new({parent=colControlBox, x=20, y=106, w=460, target=ccHighlightsController, capsuleCol={102,102,102}, faderTrack=false  })
  ccControls:new({parent=colControlBox, x=20, y=190, target=ccHighlightsController  })
  CapsuleFader:new({parent=colControlBox, x=20, y=132, w=460, target=ccMidtonesController, capsuleCol={84,84,84}, faderTrack=false  })
  ccControls:new({parent=colControlBox, x=195, y=190, target=ccMidtonesController  })
  CapsuleFader:new({parent=colControlBox, x=20, y=158, w=460, target=ccShadowsController, capsuleCol={64,64,64}, faderTrack=false  })
  ccControls:new({parent=colControlBox, x=366, y=190, target=ccShadowsController  })
  
  CapsuleFader:new({parent=colControlBox, x=20, y=218, w=460, target=ccSaturationController, colA={82,82,82}, colB={20,83,73}, faderTrack=false  })
  ccControls:new({parent=colControlBox, x=20, y=250, target=ccSaturationController  })
  
  cc_tint_bg = El:new({parent=colControlBox, x=20, y=278, z=1, w=460, h=24, col=c_Grey15, interactive = false }) 
  El:new({parent=cc_tint_bg, x=0, y=0, w=24, h=24, col={83,56,51}, shape='evenCircle', interactive = false })
  El:new({parent=cc_tint_bg, x=436, y=0, w=24, h=24, col={83,51,55}, shape='evenCircle', interactive = false })
  El:new({parent=cc_tint_bg, x=12, y=0, w=54, h=24, col={0}, shape='gradient', colA={83,56,51}, colB={81,76,51}, deg=0, interactive = false })
  El:new({parent=cc_tint_bg, x=66, y=0, w=55, h=24, col={0}, shape='gradient', colA={81,76,51}, colB={65,83,52}, deg=0, interactive = false })
  El:new({parent=cc_tint_bg, x=121, y=0, w=54, h=24, col={0}, shape='gradient', colA={65,83,52}, colB={51,83,60}, deg=0, interactive = false })
  El:new({parent=cc_tint_bg, x=175, y=0, w=55, h=24, col={0}, shape='gradient', colA={51,83,60}, colB={51,83,83}, deg=0, interactive = false })
  El:new({parent=cc_tint_bg, x=230, y=0, w=54, h=24, col={0}, shape='gradient', colA={51,83,83}, colB={51,64,83}, deg=0, interactive = false })
  El:new({parent=cc_tint_bg, x=284, y=0, w=55, h=24, col={0}, shape='gradient', colA={51,64,83}, colB={66,52,83}, deg=0, interactive = false })
  El:new({parent=cc_tint_bg, x=339, y=0, w=54, h=24, col={0}, shape='gradient', colA={66,52,83}, colB={81,51,76}, deg=0, interactive = false })
  El:new({parent=cc_tint_bg, x=393, y=0, w=55, h=24, col={0}, shape='gradient', colA={81,51,76}, colB={83,51,55}, deg=0, interactive = false })
  ccTintFaderBound = FaderBoundary:new({parent=colControlBox, target=ccTintController, x=20, y=278, w=460, h=24 }) 
  Fader:new({parent=colControlBox, target=ccTintController, faderW=456, faderX=22, x=0, y=276, z=2, boundaryElement=ccTintFaderBound})
  ccControls:new({parent=colControlBox, x=20, y=310, target=ccTintController  })
  
  Button:new({parent=colControlBox, x=15, y=346, style='button', target=ccResetController, img='bin', iType=3 })
  Label:new({parent=colControlBox, flow=true, x=4, y=8, w=60, h=20, target=ccResetController, 
    text={str='Reset all color controls', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end
    })
   
  Button:new({parent=colControlBox, x=240, y=346, style='button', target=ccAlsoCustomController, img='apply_colour_all', imgOn='apply_colour_all_on', iType=3 })
  Label:new({parent=colControlBox, flow=true, x=4, y=8, w=60, h=20, target=ccAlsoCustomController, 
    text={str='Also affect project custom colors', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target.agents[1]:onClick() end
    })
    
 
  
  paramManagementBox = El:new({parent=bodyBox, x=0, y=0, border=boxBorder, w=260, h=202, flow = true, col=c_Grey20 })
  El:new({parent=paramManagementBox, x=0, y=0, w=0, r={toEdge, paramManagementBox, 'right'}, h=26, col=c_Grey10, text={str='Parameter Management', style=3, align=4, col=c_Grey50} }) 
  
  Button:new({parent=paramManagementBox, x=12, y=40, style='button', target=paramsResetController, img='bin', iType=3 })
  Label:new({parent=paramManagementBox, flow=true, x=4, y=8, w=60, h=20, target=paramsResetController, 
    text={str='Reset all values to their default', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end
    })
    
  Button:new({parent=paramManagementBox, x=12, y=78, style='button', target=paramsExportController, img='export', iType=3 })
  Label:new({parent=paramManagementBox, flow=true, x=6, y=8, w=60, h=20, target=paramsExportController, 
    text={str='Export any changed values to a file', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end
    })
  Button:new({parent=paramManagementBox, x=12, y=116, style='button', target=paramsExportAllController, img='export_all', iType=3 })
  Label:new({parent=paramManagementBox, flow=true, x=6, y=8, w=60, h=20, target=paramsExportAllController, 
    text={str='Export all values to a file', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end
    })
    
  Button:new({parent=paramManagementBox, x=12, y=152, style='button', target=paramsLoadController, img='import', iType=3 })
  Label:new({parent=paramManagementBox, flow=true, x=6, y=8, w=60, h=20, target=paramsLoadController, 
    text={str='Import values from a file', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end
    })
  
  
  
  debugBox = El:new({parent=bodyBox, x=0, y=0, flow=true, w=330, h=202,  border=boxBorder,  col=c_Grey20 })
  El:new({parent=debugBox, x=0, y=0, w=0, r={toEdge, debugBox, 'right'}, h=26, col=c_Grey10, text={str='Debugging', style=3, align=4, col=c_Grey50} }) 
  
  Button:new({parent=debugBox, x=6, y=6, flow=true, style='button', target=refreshThemeController, img='refresh', iType=3 })
  Label:new({parent=debugBox, flow=true, x=6, y=8, w=60, h=20, target=refreshThemeController, 
    text={str='Reload theme in REAPER', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end })
  
  El:new({parent=debugBox, flow = true, x=6, w=300, y=0, h=16,  text={str='Operating System : '..OS, style=2, align=0, col=c_Grey60} }) 
  RVerDisplay = El:new({parent=debugBox, flow = true, x=6, w=300, y=0, h=16, toolTip='REAPER version', 
    text={str= translate('REAPER version : ')..reaper.GetAppVersion(), style=2, align=0, col=c_Grey60}
    })

  showRawPageController = Controller:new({parent=debugBox, x=0, y=0, w=0, h=0, desc='Show raw theme parameters page',
    onClick = function(k)
      showPages.Generic = not showPages.Generic
      pageController:onNewValue()
      for i,a in ipairs (k.target.agents) do if a.onNewValue then a:onNewValue() end end
    end
    }) 
  Button:new({parent=debugBox, x=10, y=2, flow=true, style='button', target=showRawPageController, img='button_off', imgOn='button_on', iType=3 })
  Label:new({parent=debugBox, x=0, y=2, w=280, h=20, flow=true, target=showRawPageController,
    text={str='Show \"Theme Controls\" page of raw parameters', style=2, align=0, col=labelColMA, mouseOverCol=labelColMO } })  
  
  visSectionsController = Controller:new({parent=debugBox, x=0, y=0, w=0, h=0, paramDesc = 'Visualise sections' })
  Button:new({parent=debugBox, x=10, y=0, flow=true, style='button', target=visSectionsController, img='button_off', imgOn='button_on', iType=3 })
  Label:new({parent=debugBox, x=0, y=2, w=280, h=20, flow=true, target=visSectionsController,
    text={str='Visualise sections', style=2, align=0, col=labelColMA, mouseOverCol=labelColMO} })
  
  Button:new({parent=debugBox, x=10, y=0, flow=true, style='button', target=displayRedrawsController, img='button_off', imgOn='button_on', iType=3 })
  Label:new({parent=debugBox, x=0, y=2, w=280, h=20, flow=true, target=displayRedrawsController,
    text={str='Display script redraw areas', style=2, align=0, col=labelColMA, mouseOverCol=labelColMO } })
   
  themeVerController = Controller:new({parent=debugBox, x=0, y=0, w=0, h=0, flow=true, paramDesc='Theme Version Date', desc = 'Theme Version' })  
  MiscAgent:new({parent=debugBox, x=0, y=178, w=165,  h=24, col=c_Grey50, interactive = false, target=themeVerController,
    text={str='Theme Version', style=2, align=5, col=c_Grey10}, 
    onNewValue = function(k)
      if k.target.paramVDef then
        k.text.str=translate('Theme Version : ')..k.target.paramVDef
        if scriptVersion~=k.target.paramVDef then
          k.col, k.text.col = {204,0,68}, {255,255,255} 
        end
      end
    end
    })
  El:new({parent=debugBox, flow = true, x=0, y=0, w=165, h=24, col=c_Grey10, text={str=translate('Script Version : ')..scriptVersion, style=2, align=5, col={200,200,200}}  })
    
  El:new({parent=debugBox, x=280, y=140, w=34, h=26, img='monitorScale', 
      onMouseOver = function(k)
        k.toolTip='Display scale of this monitor is '..(scaleMult*100)..'%'
      end
    })
    

        
  
   ---------------------------------------------------
   ----------------- GENERIC GLOBAL ------------------
   ---------------------------------------------------      
         
  belongsToPage = 'Generic_Global'  
    
  genColControlBox = El:new({parent=bodyBox, x=0, y=0, w=500, h=396, tile=true, col=c_Grey15 })
  El:new({parent=genColControlBox, x=0, y=0, w=0, r={toEdge, genColControlBox, 'right'}, h=26, col=c_Grey10, text={str='Color Processing', style=3, align=4, col=c_Grey50} }) 
  
  CapsuleFader:new({parent=genColControlBox, x=20, y=46, w=460, target=ccGammaController, colA={121,121,121}, colB={58,58,58}, faderTrack=false  })
  ccControls:new({parent=genColControlBox, x=20, y=78, target=ccGammaController  })
  
  CapsuleFader:new({parent=genColControlBox, x=20, y=106, w=460, target=ccHighlightsController, capsuleCol={102,102,102}, faderTrack=false  })
  ccControls:new({parent=genColControlBox, x=20, y=190, target=ccHighlightsController  })
  CapsuleFader:new({parent=genColControlBox, x=20, y=132, w=460, target=ccMidtonesController, capsuleCol={84,84,84}, faderTrack=false  })
  ccControls:new({parent=genColControlBox, x=195, y=190, target=ccMidtonesController  })
  CapsuleFader:new({parent=genColControlBox, x=20, y=158, w=460, target=ccShadowsController, capsuleCol={64,64,64}, faderTrack=false  })
  ccControls:new({parent=genColControlBox, x=366, y=190, target=ccShadowsController  })
  
  CapsuleFader:new({parent=genColControlBox, x=20, y=218, w=460, target=ccSaturationController, colA={82,82,82}, colB={20,83,73}, faderTrack=false  })
  ccControls:new({parent=genColControlBox, x=20, y=250, target=ccSaturationController  })
  
  gen_cc_tint_bg = El:new({parent=genColControlBox, x=20, y=278, w=460, h=24, z=1, col=c_Grey15, interactive = false }) 
  El:new({parent=gen_cc_tint_bg, x=0, y=0, w=24, h=24, col={83,56,51}, shape='evenCircle', interactive = false })
  El:new({parent=gen_cc_tint_bg, x=436, y=0, w=24, h=24, col={83,51,55}, shape='evenCircle', interactive = false })
  El:new({parent=gen_cc_tint_bg, x=12, y=0, w=54, h=24, col={0}, shape='gradient', colA={83,56,51}, colB={81,76,51}, deg=0, interactive = false })
  El:new({parent=gen_cc_tint_bg, x=66, y=0, w=55, h=24, col={0}, shape='gradient', colA={81,76,51}, colB={65,83,52}, deg=0, interactive = false })
  El:new({parent=gen_cc_tint_bg, x=121, y=0, w=54, h=24, col={0}, shape='gradient', colA={65,83,52}, colB={51,83,60}, deg=0, interactive = false })
  El:new({parent=gen_cc_tint_bg, x=175, y=0, w=55, h=24, col={0}, shape='gradient', colA={51,83,60}, colB={51,83,83}, deg=0, interactive = false })
  El:new({parent=gen_cc_tint_bg, x=230, y=0, w=54, h=24, col={0}, shape='gradient', colA={51,83,83}, colB={51,64,83}, deg=0, interactive = false })
  El:new({parent=gen_cc_tint_bg, x=284, y=0, w=55, h=24, col={0}, shape='gradient', colA={51,64,83}, colB={66,52,83}, deg=0, interactive = false })
  El:new({parent=gen_cc_tint_bg, x=339, y=0, w=54, h=24, col={0}, shape='gradient', colA={66,52,83}, colB={81,51,76}, deg=0, interactive = false })
  El:new({parent=gen_cc_tint_bg, x=393, y=0, w=55, h=24, col={0}, shape='gradient', colA={81,51,76}, colB={83,51,55}, deg=0, interactive = false })
  Fader:new({parent=genColControlBox, target=ccTintController, faderW=456, faderX=22, x=0, y=276, z=2})
  ccControls:new({parent=genColControlBox, x=20, y=310, target=ccTintController  })
  
  Button:new({parent=genColControlBox, x=15, y=346, style='button', target=ccResetController, img='bin', iType=3 })
  Label:new({parent=genColControlBox, flow=true, x=4, y=8, w=60, h=20, target=ccResetController, 
    text={str='Reset all color controls', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end
    })
   
  Button:new({parent=genColControlBox, x=240, y=346, style='button', target=ccAlsoCustomController, img='apply_colour_all', imgOn='apply_colour_all_on', iType=3 })
  Label:new({parent=genColControlBox, flow=true, x=4, y=8, w=60, h=20, target=ccAlsoCustomController, 
    text={str='Also affect project custom colors', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end
    })
    
    
  genParamManagementBox = El:new({parent=bodyBox, x=0, y=0, border=boxBorder, w=330, h=84, flow = true, col=c_Grey20 })
  El:new({parent=genParamManagementBox, x=0, y=0, w=0, r={toEdge, genParamManagementBox, 'right'}, h=26, col=c_Grey10, text={str='Parameter Management', style=3, align=4, col=c_Grey50} }) 
 
  genDebugBox = El:new({parent=bodyBox, x=0, y=0, w=330, h=180, tile=true, col=c_Grey20 })
  El:new({parent=genDebugBox, x=0, y=0, w=0, r={toEdge, genDebugBox, 'right'}, h=26, col=c_Grey10, text={str='Debugging', style=3, align=4, col=c_Grey50} }) 
  
  Button:new({parent=genDebugBox, x=10, y=10, flow=true, style='button', target=refreshThemeController, img='refresh', iType=3 })
  Label:new({parent=genDebugBox, flow=true, x=6, y=8, w=-60, r={toEdge, genDebugBox, 'right'}, h=20, target=refreshThemeController,
    text={str='Refresh theme in REAPER', style=2, align=0, padding=0, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end })
  
  attemptDef7Controller = Controller:new({parent=bodyBox, controlType = '', x=0, y=0, w=6, h=0, 
    onClick = function()
      if reaper.MB(
        translate("HINT: To make this script automatically attempt to use the controls for Default 7.0 theme, prefix \"Default_7.0_\" to your theme\'s name "), 
        translate("Attempt to use the controls for Default 7.0 theme?"), 1) == 1 then
        showPages.Global, showPages.TCP, showPages.EnvCP, showPages.MCP, showPages.Transport = true,true,true,true,true
        showPages.Generic_Global, showPages.Generic = false, false
        pageController.paramV="Global"
        pageController:onNewValue()
      end 
    end })  
  Button:new({parent=genDebugBox, x=10, y=0, flow=true, style='button', target=attemptDef7Controller, img='bentNail', iType=3 })
  Label:new({parent=genDebugBox, flow=true, x=6, y=8, w=60, h=20, target=attemptDef7Controller, 
    text={str="Attempt to use the Default 7.0 theme\'s controls", style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
    onClick=function(k) k.target:onClick() end })
  
  El:new({parent=genDebugBox, flow = true, x=6, w=300, y=6, h=16,  text={str=translate('Operating System : ')..OS, style=2, align=0, col=c_Grey60} }) 
  RVerDisplayGeneric = El:new({parent=genDebugBox, flow = true, x=6, w=300, y=4, h=16, toolTip='REAPER version', col={0,0,0,0},
    text={str='REAPER version : '..reaper.GetAppVersion(), style=2, align=0, col=c_Grey60}
    })
  
  Button:new({parent=genDebugBox, x=10, y=6, flow=true, style='button', target=displayRedrawsController, img='button_off', imgOn='button_on', iType=3 })
  Label:new({parent=genDebugBox, x=0, y=2, w=280, h=20, flow=true, target=displayRedrawsController,
    text={str='Display script redraw areas', style=2, align=0, col=labelColMA, mouseOverCol=labelColMO } })
    
  El:new({parent=genDebugBox, x=280, y=140, w=34, h=26, img='monitorScale', 
      onMouseOver = function(k)
        k.toolTip='Display scale of this monitor is '..(scaleMult*100)..'%'
      end
    })

        
        
  ---------------------------------------------------
  ----------------------- TCP -----------------------
  ---------------------------------------------------      
        
  belongsToPage = 'TCP' 
   
   
  tcpAllLayoutsBox = El:new({parent=bodyBox, x=0, y=0, w=500, h=392, tile=true, col=c_Grey20 })
  TitleBar:new({parent=tcpAllLayoutsBox, x=0, y=0, layouts='all', text={str='Track Panel'} }) 
  
  tcpBgController = Controller:new({parent=tcpAllLayoutsBox, x=0, y=0, w=6, h=0, flow = '', style='colour', paramDesc = 'TCP background colour', labelStr='Background color' })
  El:new({parent=tcpAllLayoutsBox, flow = true, x=0, w=500, y=36, h=26, text={str='Drag elements to reorder them', style=2, align=1, col=c_Grey70  }  })
  tcpOrderBox=MiscAgent:new({parent=tcpAllLayoutsBox, flow=true, x=10, y=0, border=0, w=-10, r={toEdge, tcpAllLayoutsBox, 'right'}, h=42, col=c_CyanGrey, target=tcpBgController, 
     onNewValue = function(k)
       k.col = k.target.paramV
       k.isDirty, doArrange = true, true
     end
     })
  
  tcpOrderControl = El:new({parent=tcpOrderBox, x=10, y=10, w=460, h=40, dragNDropCursor = 'env_pt_leftright',
    onValueEdited = function(k)
      local p1 = paramIdxGet('TCP flow location 1')
      if p1>0 and k.paramV ~= nil then
        for i=1, 10 do -- iterate flow elements
          paramSet(p1 -1 +i, k.paramV[i])
        end
      end
    end,
    onUpdate = function(k)
  
      local p1 = paramIdxGet('TCP flow location 1')
      if p1>0 then
        
        if k.paramV == nil then -- first time populate paramV table with values from Reaper
          k.paramV = {}
          for i=1, 10 do -- iterate flow elements
            local tmp, tmp, value = reaper.ThemeLayout_GetParameter(p1 -1 +i)
            --reaper.ShowConsoleMsg('element '..i..' is at location '..value..' \n')
            k.paramV[i] = value
          end
        end
        
        local widths = {72, 40, 39, 30, 36, 42, 42, 56, 40, 16}
        --local names = {'labelBlock','volLabel','MSBlock','io','FxBlock','PanBlock','recmode','inputBlock','env','phase'} --only used in console
        local xMargin = 5
        for i=1, 10 do -- iterate my children 1-10, the position proxies, and fix their widths and x-positions
          k.children[i].w = widths[k.paramV[i]]
          if i>1 then k.children[i].x = k.children[i-1].x + k.children[i-1].w + xMargin end
        end
        
        for i=1, 10 do -- iterate my children 11-20, the display elements, positioning each to the appropriate proxy
          k.children[k.paramV[i]+10].x = k.children[i].x
          --reaper.ShowConsoleMsg('element '..i..' '..names[k.paramV[i]]..' is at location '..i..' \n')
          addNeedUpdate(k.children[i+10], true)
        end
        
        for i=0, 10 do -- iterate my DropTraget children, x-positioning them
          if i>0 then k.DropTargets[i].x = k.children[i].x + (0.5 * k.children[i].w) - 10 end
        end
        
      end
      
      if p1==-1 then -- param error
        k.text = {str='ERROR', style=3, align=3, col={0,0,0}}
        k.col={255,0,0}
      end
    end
  })
  
  -- 10 position proxies for 10 slots
  for i=1,10 do El:new({parent=tcpOrderControl, x=0, y=0, w=40, h=20 })  end
  
  tcpLabelBlock = DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=72, h=22, flow=false, param=1 })
    El:new({parent=tcpLabelBlock, x=0, y=-1, w=24, h=24, img='tcp_recarm', interactive=false })
    El:new({parent=tcpLabelBlock, x=24, y=-1, w=24, h=24, col={38,38,38}, interactive=false })
    El:new({parent=tcpLabelBlock, x=48, y=-1, w=24, h=24, img='tcp_vol', interactive=false }) 
  DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=40, h=22, flow=false, text={str='0.0dB', align=4, style=1}, param=2 })
  DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=39, h=22, flow=false, img='tcp_mutesolo', param=3 })
  DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=30, h=22, flow=false, img='tcp_io', param=4 })
  DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=36, h=22, flow=false, img='tcp_fx', param=5 })
  DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=42, h=22, flow=false, img='tcp_panwidth', param=6 })
  DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=42, h=22, flow=false, img='tcp_recmode', param=7 })
  tcpInputBlock = DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=56, h=22, flow=false, param=8 })
    El:new({parent=tcpInputBlock, x=0, y=0, w=20, h=22, img='tcp_infx', interactive=false })
    El:new({parent=tcpInputBlock, x=20, y=0, w=10, h=20, col={0,0,0,68}, interactive=false })
    El:new({parent=tcpInputBlock, x=30, y=0, w=26, h=22, img='tcp_recinput', interactive=false })
  DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=40, h=22, flow=false, img='tcp_env', param=9 })
  DragNDrop:new({parent=tcpOrderControl, x=0, y=0, w=16, h=22, flow=false, img='tcp_phase', param=10 })

  DropTarget:new({parent=tcpOrderControl, x=-10, param={0}})
  DropTarget:new({parent=tcpOrderControl, x=0, param={1}})
  DropTarget:new({parent=tcpOrderControl, x=0, param={2}})
  DropTarget:new({parent=tcpOrderControl, x=0, param={3}})
  DropTarget:new({parent=tcpOrderControl, x=0, param={4}})
  DropTarget:new({parent=tcpOrderControl, x=0, param={5}})
  DropTarget:new({parent=tcpOrderControl, x=0, param={6}})
  DropTarget:new({parent=tcpOrderControl, x=0, param={7}})
  DropTarget:new({parent=tcpOrderControl, x=0, param={8}})
  DropTarget:new({parent=tcpOrderControl, x=0, param={9}})
 
 MiscAgent:new({parent=tcpAllLayoutsBox, x=10, y=104, border=0, w=-10, r={toEdge, tcpAllLayoutsBox, 'right'}, h=42, col={0}, target=tcpBgController, 
    shape='gradient', colA=c_CyanGrey, colB=c_Grey20, deg=90, 
    onNewValue = function(k)
      k.colA = k.target.paramV or c_CyanGrey
      k.isDirty, doArrange = true, true
    end
    })     

  ColourChooseAgent:new({parent=tcpAllLayoutsBox, x=10, y=-30, border=10, w=196, h=50, flow=true, style='colour', target=tcpBgController})
  tcpDivOpacityController = Controller:new({parent=tcpAllLayoutsBox, x=30, y=0, w=6, h=6, paramDesc='TCP Div Opacity', desc = 'Divider Opacity', units = '%',  remapToMin = 0, remapToMax = 100 })
  CapsuleFader:new({parent=tcpAllLayoutsBox, x=228, y=126, w=242, target=tcpDivOpacityController, capsuleCol=c_Grey20  })
  ccControls:new({parent=tcpAllLayoutsBox, x=300, y=158, target=tcpDivOpacityController  })
  MiscAgent:new({parent=tcpAllLayoutsBox, target=tcpDivOpacityController, x=10, y=104, w=-10, r={toEdge, tcpAllLayoutsBox, 'right'}, h=1, col={0,0,0,80}, interactive = false,
    onNewValue = function(k)
      k.col = {0,0,0,k.target.paramV}
      k.isDirty=true
    end
    })
  
  
  tcpBalanceController = Controller:new({parent=tcpAllLayoutsBox, x=30, y=0, w=6, h=6, paramDesc='TCP Folder Balance Type', desc = 'Balancing method', units = '', 
    valueAlias = {[0]='None', [1]='Stretch Name', [2]='Balance All'},
    onValueEdited = function(k)
      local p = paramIdxGet('TCP Folder Balance Type')
      paramSet(p, k.paramV) 
    end,
    onUpdate = function(k)
      if k.paramV == nil then -- set paramV for the first time
        local p = paramIdxGet('TCP Folder Balance Type')
        local retval, desc, value, defValue = reaper.ThemeLayout_GetParameter(p)
        k.paramV = value
      end 

      for l,m in ipairs(k.agents) do
        if m.onNewValue then m:onNewValue() end
        if m.parent==tcpBalanceSect then
          if m.param == k.paramV then m.children[1].col, m.children[1].strokeCol = {48,64,59}, {26,128,94}
          else m.children[1].col, m.children[1].strokeCol = c_Grey20, nil
          end
        end
        m.isDirty=true
      end
    end
    })

  
  
  tcpSpacingDiag = El:new({parent=tcpAllLayoutsBox, x=10, y=190, w=480, h=136, col={255,100,0,0} }) 
  tcpIndentController = Controller:new({parent=tcpSpacingDiag, paramDesc = 'TCP Folder Indent', w=0, units = 'px', desc = 'Folder Indent' }) 
  tcpXSpaceController = Controller:new({parent=tcpSpacingDiag, paramDesc = 'X-Axis spacing', w=0, units = 'px', desc = 'X Spacing' }) 
  tcpYSpaceController = Controller:new({parent=tcpSpacingDiag, paramDesc = 'Y-Axis spacing', w=0, units = 'px', desc = 'Y Spacing' }) 
  
  tcpSpacingDiagBg = MiscAgent:new({parent=tcpSpacingDiag, target=tcpBalanceController, alsoAgentOf={tcpIndentController, tcpXSpaceController, tcpYSpaceController}, 
    x=0, y=0, w=300, h=100, flow=true, col={0,100,255,0},
    onNewValue = function(k)
      local indS = k.alsoAgentOf[1].paramV or 0
      local bal, xS, yS = k.target.paramV,  math.floor(k.alsoAgentOf[2].paramV or 0), math.floor(k.alsoAgentOf[3].paramV or 0)
      --reaper.ShowConsoleMsg('balance: '..bal..', xSpace: '..xS..', ySpace: '..yS..'\n')
      
      if bal~=1 then k.children[2].w = 90 else k.children[2].w = 90 + 2*indS end
      if bal==2 then k.children[2].x = 16+2*indS else k.children[2].x = 16 end
      k.children[3].x, k.children[4].x, k.children[5].x = xS + 10, xS, xS
      
      k.children[7].x, k.children[7].h = indS, 52+yS -- the idx block 
      if bal~=1 then k.children[8].w = 90 else k.children[8].w = 90 + indS end
      if bal==2 then k.children[8].x = 16+indS else k.children[8].x = 16 end
      k.children[9].x, k.children[10].x, k.children[11].x = xS + 10, xS, xS
      if bal~=0 then k.children[12].x = 2*indS+26 else k.children[12].x = indS+26 end
      k.children[12].y = yS + 58
      k.children[13].x, k.children[14].x = xS, xS
      
      k.children[15].x, k.children[15].y, k.children[15].w = indS*2, 84+yS, 280-indS*2 -- the second div 
      k.children[16].x, k.children[16].y = indS*2, 84+yS -- the idx block 
      k.children[17].w = 90
      k.children[18].x, k.children[19].x, k.children[20].x = xS + 10, xS, xS
      
    end
    })
    
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, z=2, w=20, h=32, col=c_Grey10, interactive = false })
    
    tcpSpacingDiagNameBox1 = El:new({parent=tcpSpacingDiagBg, x=16, y=6, flow=true, z=2, w=120, h=20, col=c_Grey10, interactive = false })
      El:new({parent=tcpSpacingDiagNameBox1, x=-10, y=0, z=2, w=20, h=22, img='round20_nonInteractive', iType=1, interactive = false })
      El:new({parent=tcpSpacingDiagNameBox1, x=-10, y=0, l={toEdge, tcpSpacingDiagNameBox1, 'right'}, z=2, w=20, h=22, img='round20_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=10, y=0, flow=true, z=2, w=30, h=22, img='rect20_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, flow=true, z=2, w=30, h=22, img='halfCapsule_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, flow=true, z=2, w=20, h=22, img='round20_nonInteractive', iType=1, interactive = false })
    
    El:new({parent=tcpSpacingDiagBg, x=0, y=32, z=2, w=280, h=1, col=c_Grey10, interactive = false,
      shape='gradient', colA=c_Grey10, colB=c_Grey15, deg=0 })
    El:new({parent=tcpSpacingDiagBg, x=0, y=33, z=2, w=20, h=58, col=c_Grey10, interactive = false })
    
    tcpSpacingDiagNameBox2 = El:new({parent=tcpSpacingDiagBg, x=16, y=6, flow=true, z=2, w=120, h=20, col=c_Grey10, interactive = false })
      El:new({parent=tcpSpacingDiagNameBox2, x=-10, y=0, z=2, w=20, h=22, img='round20_nonInteractive', iType=1, interactive = false })
      El:new({parent=tcpSpacingDiagNameBox2, x=-10, y=0, l={toEdge, tcpSpacingDiagNameBox2, 'right'}, z=2, w=20, h=22, img='round20_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=10, y=0, flow=true, z=2, w=30, h=22, img='rect20_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, flow=true, z=2, w=30, h=22, img='halfCapsule_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, flow=true, z=2, w=20, h=22, img='round20_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, z=2, w=30, h=22, img='rect20_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, flow=true, z=2, w=120, h=22, img='halfCapsule_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, flow=true, z=2, w=20, h=22, img='rect20_nonInteractive', iType=1, interactive = false })
    
    El:new({parent=tcpSpacingDiagBg, x=0, y=100, z=2, w=280, h=1, col=c_Grey10, interactive = false,
      shape='gradient', colA=c_Grey10, colB=c_Grey15, deg=0 })
    El:new({parent=tcpSpacingDiagBg, x=0, y=101, z=2, w=20, h=32, col=c_Grey10, interactive = false })
    
    tcpSpacingDiagNameBox3 = El:new({parent=tcpSpacingDiagBg, x=16, y=6, flow=true, z=2, w=120, h=20, col=c_Grey10, interactive = false })
      El:new({parent=tcpSpacingDiagNameBox3, x=-10, y=0, z=2, w=20, h=22, img='round20_nonInteractive', iType=1, interactive = false })
      El:new({parent=tcpSpacingDiagNameBox3, x=-10, y=0, l={toEdge, tcpSpacingDiagNameBox3, 'right'}, z=2, w=20, h=22, img='round20_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=10, y=0, flow=true, z=2, w=30, h=22, img='rect20_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, flow=true, z=2, w=30, h=22, img='halfCapsule_nonInteractive', iType=1, interactive = false })
    El:new({parent=tcpSpacingDiagBg, x=0, y=0, flow=true, z=2, w=20, h=22, img='round20_nonInteractive', iType=1, interactive = false })
    
  ccControls:new({parent=tcpSpacingDiag, x=310, y=14, target=tcpIndentController  }) 
  ccControls:new({parent=tcpSpacingDiag, x=310, y=40, target=tcpXSpaceController  }) 
  ccControls:new({parent=tcpSpacingDiag, x=310, y=66, target=tcpYSpaceController  }) 
  
  tcpBalanceSect = El:new({parent=tcpAllLayoutsBox, x=10, y=0, flow=true, w=480, h=56, col={100,0,255,0}  })   
  tcpBalanceButton:new({parent=tcpBalanceSect, x=0, y=0, tcpBalanceImg='folderBalance_none', param=0  })
  tcpBalanceButton:new({parent=tcpBalanceSect, x=0, y=0, flow=true, tcpBalanceImg='folderBalance_stretch', param=1  })
  tcpBalanceButton:new({parent=tcpBalanceSect, x=0, y=0, flow=true, tcpBalanceImg='folderBalance_all', param=2  })
  ccControls:new({parent=tcpAllLayoutsBox, x=360, y=-50, flow=true, target=tcpBalanceController, spinner=false  }) 
    
  
  
  tcpVisflagTableBox = El:new({parent=bodyBox, x=0, y=0, w=500, h=392, tile=true, col=c_CyanGrey })
  TitleBar:new({parent=tcpVisflagTableBox, x=0, y=0, w=0, r={toEdge, tcpVisflagTableBox, 'right'}, h=26, col=c_Grey10, text={str='Visibility programmer', style=3, align=4, col=c_Grey50} }) 
  tcpVisflagTableDarkBg = El:new({parent=tcpVisflagTableBox, x=89, y=27, w=410, h=364, col=c_Grey15 })
  
  El:new({parent=tcpVisflagTableBox, x=91, y=27, w=100, h=28, text={style=2, align=5, str='If mixer visible', wrap=true, col=c_Grey70} })
  El:new({parent=tcpVisflagTableBox, x=2, y=0, w=100, h=28, flow=true, text={style=2, align=5, str='If not selected', wrap=true, col=c_Grey70} })
  El:new({parent=tcpVisflagTableBox, x=2, y=0, w=100, h=28, flow=true, text={style=2, align=5, str='If not armed', wrap=true, col=c_Grey70} })
  El:new({parent=tcpVisflagTableBox, x=2, y=0, w=100, h=28, flow=true, text={style=2, align=5, str='ALWAYS', wrap=true, col=c_Grey70} })
  
  tcpVisflagTableOddRowStyle = {
    buttonOffStyle = {col=c_Grey20, mouseOverCol={64,64,64}, textCol={80,80,80}},
    buttonOnStyle = {col=c_Grey20, mouseOverCol={84,42,49}, textCol={255,64,95}}
  }
  tcpVisflagTableEvenRowStyle = {
    buttonOffStyle = {col=c_Grey15, mouseOverCol={51,51,51}, textCol={80,80,80}},
    buttonOnStyle = {col=c_Grey15, mouseOverCol={84,42,49}, textCol={255,64,95}}
  }
  
  tcpVisFlagDiags = El:new({parent=tcpVisflagTableBox, x=0, y=26, w=90, h=31 })
  El:new({parent=tcpVisFlagDiags, x=6, y=31, w=24, h=24, img='tcp_recarm', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=30, y=31, w=29, h=24, col={38,38,38}, interactive=false })
  El:new({parent=tcpVisFlagDiags, x=59, y=31, w=24, h=24, img='tcp_vol', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=71, y=61, w=16, h=22, img='tcp_monitor', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=44, y=89, w=39, h=22, img='tcp_mutesolo', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=53, y=117, w=30, h=22, img='tcp_io', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=47, y=145, w=36, h=22, img='tcp_fx', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=41, y=172, w=42, h=22, img='tcp_panwidth', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=41, y=201, w=42, h=22, img='tcp_recmode', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=6, y=229, w=20, h=22, img='tcp_infx', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=26, y=229, w=31, h=20, col={0,0,0,38}, interactive=false })
  El:new({parent=tcpVisFlagDiags, x=57, y=229, w=26, h=22, img='tcp_recinput', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=43, y=257, w=40, h=22, img='tcp_env', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=67, y=285, w=16, h=22, img='tcp_phase', interactive=false })
  El:new({parent=tcpVisFlagDiags, x=6, y=309, w=77, h=28, text={style=1, align=6, str='Labels & Values', wrap=true, col=c_Grey15}, interactive=false })
  El:new({parent=tcpVisFlagDiags, x=6, y=337, w=77, h=28, text={style=1, align=6, str='Meter Values', wrap=true, col=c_Grey15}, interactive=false })
  
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, y=53, paramDesc = 'Visflag Track Label Block', rowStyle='odd'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Recmon', rowStyle='even'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track MS Block', rowStyle='odd'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Io', rowStyle='even'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Fx Block', rowStyle='odd'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Pan Block', rowStyle='even'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Recmode', rowStyle='odd'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Input Block', rowStyle='even'})
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Env', rowStyle='odd'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Phase', rowStyle='even'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Labels and Values', rowStyle='odd'}) 
  tcpVisFlagRow:new({parent=tcpVisflagTableBox, x=89, flow=true, paramDesc = 'Visflag Track Meter Values', rowStyle='even'})
  

  
    
  tcpOneLayoutBox = El:new({parent=bodyBox, x=0, y=0, tile=true, w=500, h=364, col=c_CyanGrey }) 
  TitleBar:new({parent=tcpOneLayoutBox, x=0, y=0, text={str='Track Panel'} }) 
  
  tcpVolLabelSect = El:new({parent=tcpOneLayoutBox, x=0, y=0, border=10, flow=true, w=480, h=120, col={0,255,255,0} }) -- zero opacity color
  tcpLabelSizeController = Controller:new({parent=tcpVolLabelSect, x=40, y=0, w=6, h=6, paramDesc = 'TCP Label Font Size', units = '', desc='Label Font Size' })
  tcpVolLengthController = Controller:new({parent=tcpVolLabelSect, x=30, y=0, w=6, h=6, paramDesc='TCP Volume Length', desc = 'Volume Length', units = 'px',
    valueAlias = {[40] = 'Knob'}  })
  tcpLabelLengthController = Controller:new({parent=tcpVolLabelSect, x=40, y=0, w=6, h=6, paramDesc = 'TCP Label Length', units = 'px', desc='Label Length' })

  fontControl:new({parent=tcpVolLabelSect, target=tcpLabelSizeController, x=26, y=0, border=0, w=480, h=22, colMatch='c_CyanGrey', col={100,0,255,0} }) -- zero opacity color
  
  tcpLabelDiag = MiscAgent:new({parent=tcpVolLabelSect, target=tcpLabelLengthController, x=0, y=30, w=100, h=24, interactive=false, 
    onNewValue = function(k)
        k.w = k.target.paramV + 16
        tcpVolDiag.x = k.x+k.w
        if (k.x+k.w)>460 then 
          k.r={toEdge, k.parent, 'right'}
          k.w = -20
          tcpVolDiag.children[2].w = 0
        else 
          k.r = nil
          tcpVolDiag.children[2].w = 24
        end
        
        tcpVolLengthTape.x = tcpVolDiag.x
        if tcpVolLengthTape.x > 260 then tcpVolLengthTape.x = 260 end
        tcpVolLengthControls.x = tcpVolLengthTape.x + 30
      k.isDirty, doArrange = true, true
      tcpVolDiag:onNewValue()
    end
    })
    El:new({parent=tcpLabelDiag, x=0, y=0, w=24, h=24, col=c_Grey10, shape='evenCircle', interactive = false })
    El:new({parent=tcpLabelDiag, x=12, y=0, w=20, h=24, col=c_Grey10, interactive=false }) 
    El:new({parent=tcpLabelDiag, x=32, y=0, w=0, r={toEdge, tcpLabelDiag, 'right'}, h=24, col=c_Grey10, interactive = false,
      text={str='Track Name can be long, actually very very long, even longer than this, which is really quite long indeed', style=3, align=4, padding=0, col={180,180,180}} })
    El:new({parent=tcpLabelDiag, x=2, y=2, w=22, h=22, img='round22_nonInteractive', interactive=false }) 
  
  tcpVolDiag = MiscAgent:new({parent=tcpVolLabelSect, target=tcpVolLengthController, x=0, y=30, w=-12, r=nil, h=24, interactive=false, 
    onNewValue = function(k)
      k.r = nil
      if k.target.paramV==40 then
        k.children[1].w = -16
        k.children[3].w = 24 -- knob image
        k.children[4].w = 0
        k.children[5].w = 0
        tcpVolDiag.w = 32
      else 
        k.w = k.target.paramV
        k.children[1].w = -12
        k.children[3].w = 0 -- knob image
        k.children[4].w = -12
        k.children[5].x = math.ceil((k.target.paramV or 0)/2) - 10
        k.children[5].w = 20
      end
      if k.w and (k.x+k.w)>470 then 
        k.r={toEdge, k.parent, 'right'}
        k.children[3].w = 0
        k.children[5].w = 0
        k.w = -10
      end
      tcpLabelVolOversize:onNewValue()
      tcpVolLengthTape.children[4]:onNewValue()
      k.isDirty, doArrange = true, true
    end
    })
    El:new({parent=tcpVolDiag, x=0, y=0, w=-12, h=24, r={toEdge, tcpVolDiag, 'right'}, col=c_Grey10, interactive = false })
    El:new({parent=tcpVolDiag, x=-12, y=0, w=24, h=24, flow=true, col=c_Grey10, shape='evenCircle', interactive = false })
    El:new({parent=tcpVolDiag, x=2, y=2, w=22, h=22, img='round22_nonInteractive', interactive=false })  
    El:new({parent=tcpVolDiag, x=0, y=10, w=-12, h=4, r={toEdge, tcpVolDiag, 'right'}, col=c_Grey15, shape='capsule', interactive = false }) -- track
    El:new({parent=tcpVolDiag, x=50, y=-2, w=20, h=28, img='slider_nonInteractive', interactive=false }) 
    

  tcpVolLengthTape = TapeMeasure:new({parent=tcpVolLabelSect, target=tcpVolLengthController, x=0, y=62, z=2, tape={zeroAtV=40, colMatch='c_CyanGrey'}, w=0, h=20,  r={toEdge, tcpOneLayoutBox, 'right'}, interactive = false })  
  TapeMeasure:new({parent=tcpVolLabelSect, target=tcpLabelLengthController, x=26, y=92, z=2, tape={colMatch='c_CyanGrey'}, w=0, h=20,  r={toEdge, tcpOneLayoutBox, 'right'}, interactive = false })
  
  tcpLabelVolOversize = MiscAgent:new({parent=tcpVolLabelSect, target=tcpLabelLengthController, x=370, y=30, z=2, w=0, h=96,  
     col=c_CyanGrey, shape='gradient', colA={c_CyanGrey[1],c_CyanGrey[2],c_CyanGrey[3],0}, colB={c_CyanGrey[1],c_CyanGrey[2],c_CyanGrey[3],255}, deg=0,
    onNewValue = function(k)
      if k.target.paramV and tcpVolLengthController.paramV and (k.target.paramV + (tcpVolLengthController.paramV or 0))>434 then k.w=100
      else k.w=0
      end
    end })
    
  tcpVolLengthControls = ccControls:new({parent=tcpVolLabelSect, x=30, y=68, colMatch='c_CyanGrey', target=tcpVolLengthController  })
  ccControls:new({parent=tcpVolLabelSect, x=56, y=98, colMatch='c_CyanGrey', target=tcpLabelLengthController })
  
  El:new({parent=tcpOneLayoutBox, x=0, y=6, w=500, h=1, col={0,0,0,80}, flow=true, interactive = false })
  
  tcpInSect = El:new({parent=tcpOneLayoutBox, x=0, y=0, border=10, flow=true, w=480, h=90, col={255,0,255,0} }) -- zero opacity color
  tcpInLengthController = Controller:new({parent=tcpInSect, x=40, y=0, w=6, h=6, paramDesc = 'TCP Input Length', units = 'px', desc='Input Length' })
  tcpInFontController = Controller:new({parent=tcpInSect, x=40, y=0, w=6, h=6, paramDesc = 'TCP Input Font Size', units = '', desc='Input Font Size' })
  fontControl:new({parent=tcpInSect, target=tcpInFontController, x=26, y=0, border=0, w=480, h=22, colMatch='c_CyanGrey' }) 
  
  tcpInDiag = MiscAgent:new({parent=tcpInSect, target=tcpInLengthController, x=0, y=30, w=480, h=24, interactive=false, 
    onNewValue = function(k)
        k.w = k.target.paramV + 40
      k.isDirty, doArrange = true, true
    end
    })
    El:new({parent=tcpInDiag, x=0, y=0, w=20, h=20, img='tcpInFx_nonInteractive', interactive=false })
    El:new({parent=tcpInDiag, x=20, y=0, w=-20, h=20, col={0,0,0,34}, r={toEdge, tcpInDiag, 'right'}, interactive=false,
      text={str='Input Name can be long, actually very very long, even longer than this, which is really quite long indeed', style=1, align=4, padding=0, col={235,235,235}} })
    El:new({parent=tcpInDiag, x=0, y=0, w=20, h=20, flow=true, img='tcpDrop_nonInteractive', interactive=false })
    
    
  TapeMeasure:new({parent=tcpInSect, target=tcpInLengthController, x=20, y=58, z=2, tape={colMatch='c_CyanGrey'}, w=0, h=20,  r={toEdge, tcpInSect, 'right'}, interactive = false })  
  ccControls:new({parent=tcpInSect, x=50, y=64, z=2, colMatch='c_CyanGrey', target=tcpInLengthController })
    
  
  tcpMeterBox = El:new({parent=tcpOneLayoutBox, x=0, y=2, w=500, h=100, flow=true, col=c_Grey10, interactive=false })
  tcpMeterWidthController = Controller:new({parent=tcpMeterBox, x=0, y=0, w=6, h=0, paramDesc = 'TCP Meter Width', units = 'px', desc='Meter Width' })
  tcpMeterBorderController = Controller:new({parent=tcpMeterBox, x=0, y=0, w=6, h=0, paramDesc = 'TCP Meter Border', units = 'px', desc='Meter Border' })
  tcpMeterDiag = MiscAgent:new({parent=tcpMeterBox, target=tcpMeterWidthController, x=20, y=14, w=100, h=30, interactive=false, 
    onNewValue = function(k)
      k.w = k.target.paramV
      k.isDirty, doArrange = true, true
    end
    })
  MiscAgent:new({parent=tcpMeterDiag, target=tcpMeterWidthController, alsoAgentOf={tcpMeterBorderController}, x=0, y=0, z=2, w=100, h=20, col=c_GreenLit, interactive = false,
    onNewValue = function(k)
      local tmp, tmp, border = reaper.ThemeLayout_GetParameter(paramIdxGet(tcpMeterBorderController.paramDesc))
      if tcpMeterDiag.w > tcpMeterDiag.h then
        k.x, k.y = border, border
        k.w, k.h = -1*border, tcpMeterDiag.h/2 - 1.5*border
        k.r = {toEdge, tcpMeterDiag, 'right'}
      else
        k.x, k.y = border, border
        k.w, k.h = tcpMeterDiag.w/2 - 1.5*border, tcpMeterDiag.h - 2*border
        k.r = nil
      end
      k.isDirty, doArrange = true, true
    end
    }) 
  MiscAgent:new({parent=tcpMeterDiag, target=tcpMeterWidthController, alsoAgentOf={tcpMeterBorderController}, x=0, y=0, z=2, flow=true, w=100, h=20, col=c_GreenLit, interactive = false,
    onNewValue = function(k)
      local tmp, tmp, border = reaper.ThemeLayout_GetParameter(paramIdxGet(tcpMeterBorderController.paramDesc))
      if tcpMeterDiag.w > tcpMeterDiag.h then
        k.x, k.y = border, border
        k.w, k.h = -1*border, tcpMeterDiag.h/2 - 1.5*border
        k.r = {toEdge, tcpMeterDiag, 'right'}
      else
        k.x, k.y = border, 0
        k.w, k.h = tcpMeterDiag.w/2 - 1.5*border, tcpMeterDiag.h - 2*border
        k.r = nil
      end
      k.isDirty, doArrange = true, true
    end
    })
  
  TapeMeasure:new({parent=tcpMeterBox, target=tcpMeterWidthController, x=10, y=52, z=2, tape={lengthOffs=10}, w=0, h=20,  r={toEdge, tcpMeterDiag, 'right'}, interactive = false })
  ccControls:new({parent=tcpMeterBox, x=40, y=68, target=tcpMeterWidthController })
  ccControls:new({parent=tcpMeterBox, x=240, y=68, target=tcpMeterBorderController })
 
  
       
  tcpSecAssignBox = El:new({parent=bodyBox, x=0, y=0, w=500, h=364, tile=true, col=c_Grey20 })
  TitleBar:new({parent=tcpSecAssignBox, x=0, y=0, text={str='Section assignments'} }) 
  
  tcpSectionsAssignController = Controller:new({parent=tcpSecAssignBox, x=0, y=10, w=0, h=0, dragNDropCursor = 'arrange_move',
    onNewValue = function(k)
      --reaper.ClearConsole()
      local sectionCount = {}
      local visFlags = {-1, -1, -1}
      local sectionIndex = {left=1, bottom=2, right=3}
      
      if k.paramV.fxParam ~= 'none' then -- do params section first, its special 
        --reaper.ShowConsoleMsg('SET Params to '..k.paramV.fxParam..' in slot '..(sectionIndex[k.paramV.fxParam]*3-2)..'\n')
        sectionCount[k.paramV.fxParam] = {'params'}
        paramSet(paramIdxGet('FX Parameters Section'), sectionIndex[k.paramV.fxParam]*3-2)
      else
        --reaper.ShowConsoleMsg('SET Params to --off-- \n')  
        paramSet(paramIdxGet('FX Parameters Section'), 0)
      end
      
      
      if k.paramV.embedUi ~= 'none' then 
        if sectionCount[k.paramV.embedUi] then table.insert(sectionCount[k.paramV.embedUi], 'embedUi')
        else sectionCount[k.paramV.embedUi] = {'embedUi'}
        end
        --reaper.ShowConsoleMsg('SET embedUi to '..k.paramV.embedUi..' in slot '..(sectionIndex[k.paramV.embedUi]*3 -3 + #sectionCount[k.paramV.embedUi])..'\n')
        paramSet(paramIdxGet('Embedded FX Section'), sectionIndex[k.paramV.embedUi]*3 -3 + #sectionCount[k.paramV.embedUi])
      else
        --reaper.ShowConsoleMsg('SET embedUi to --off-- \n')  
        paramSet(paramIdxGet('Embedded FX Section'), 0)
      end
      
      
      if k.paramV.insert ~= 'none' then 
        if sectionCount[k.paramV.insert] then table.insert(sectionCount[k.paramV.insert], 'insert')
        else sectionCount[k.paramV.insert] = {'insert'}
        end
        if k.paramV.insert == k.paramV.fxParam then  
          --reaper.ShowConsoleMsg('>>> INSERT SHARING WITH PARAMS <<<\n')
          paramSet(paramIdxGet('FX List Section'), 0)
          paramSet(paramIdxGet('tcpFxparmVisflag1'), 1)
        else
          --reaper.ShowConsoleMsg('SET insert to '..k.paramV.insert..' in slot '.. (sectionIndex[k.paramV.insert]*3 -3 + #sectionCount[k.paramV.insert])..'\n')
          paramSet(paramIdxGet('FX List Section'), sectionIndex[k.paramV.insert]*3 -3 + #sectionCount[k.paramV.insert])
          paramSet(paramIdxGet('tcpFxparmVisflag1'), -1)
        end
      else
        --reaper.ShowConsoleMsg('SET insert to --off-- \n')  
        paramSet(paramIdxGet('FX List Section'), 0)
        paramSet(paramIdxGet('tcpFxparmVisflag1'), -1)
      end
      
      
      if k.paramV.send ~= 'none' then 
        if sectionCount[k.paramV.send] then table.insert(sectionCount[k.paramV.send], 'send')
        else sectionCount[k.paramV.send] = {'send'}
        end
        if k.paramV.send == k.paramV.fxParam then  
          --reaper.ShowConsoleMsg('>>> SEND SHARING WITH PARAMS <<<\n')
          paramSet(paramIdxGet('Send List Section'), 0)
          paramSet(paramIdxGet('tcpFxparmVisflag2'), 1)
        else
          --reaper.ShowConsoleMsg('SET send to '..k.paramV.send..' in slot '.. (sectionIndex[k.paramV.send]*3 -3 + #sectionCount[k.paramV.send])..'\n')
          paramSet(paramIdxGet('Send List Section'), sectionIndex[k.paramV.send]*3 -3 + #sectionCount[k.paramV.send])
          paramSet(paramIdxGet('tcpFxparmVisflag2'), -1)
        end
      else
        --reaper.ShowConsoleMsg('SET send to --off-- \n')  
        paramSet(paramIdxGet('Send List Section'), 0)
        paramSet(paramIdxGet('tcpFxparmVisflag2'), -1)
      end
      
      
      local bottomSectionDiv = 1
      if sectionCount['bottom'] and #sectionCount['bottom']>1 then 
        bottomSectionDiv = #sectionCount['bottom'] 
        if k.paramV.fxParam=='bottom' then
          if k.paramV.insert=='bottom' then bottomSectionDiv = bottomSectionDiv -1 end -- don't div bottom for this, its sharing with params
          if k.paramV.send=='bottom' then bottomSectionDiv = bottomSectionDiv -1 end -- don't div bottom for this, its sharing with params
        end
      end
      --reaper.ShowConsoleMsg('finally, SET bottom section division to '..bottomSectionDiv..' \n') 
      paramSet(paramIdxGet('tcpSectionBottomDiv'), bottomSectionDiv)
      
    end,
    onUpdate = function(k)
      
      if k.paramV == nil then -- first time populate paramV table with values from Reaper
        local getParams = {'FX Parameters Section', 'Send List Section', 'FX List Section', 'Embedded FX Section', 'tcpFxparmVisflag1', 'tcpFxparmVisflag2'}
        local gotParam = {}
        local locIndex = {'none', 'left', 'bottom', 'right'}
        for l,m in pairs(getParams) do
          local tmp, tmp, value = reaper.ThemeLayout_GetParameter(paramIdxGet(m))
          if l<5 then  gotParam[l] = locIndex[math.ceil((value)/3)+1] --translate exact sections plus fxparms into script button settings (section 1 to 3, or 0 for none)
          else gotParam[l] = value
          end
        end
        k.paramV = {fxParam=gotParam[1], send=gotParam[2], insert=gotParam[3], embedUi=gotParam[4], tcpFxparmVisflag1=gotParam[5], tcpFxparmVisflag2=gotParam[6]}
        if gotParam[2] == 'none' and gotParam[tcpFxparmVisflag2] == 1 then k.paramV.send = k.paramV.fxParam end -- sends are sharing with params
        if gotParam[3] == 'none' and gotParam[tcpFxparmVisflag1] == 1 then k.paramV.insert = k.paramV.fxParam end-- inserts are sharing with params
      end
      
      local dropTarget = {none=tcpSecDropTargetNone, left=tcpSecDropTargetLeft, bottom=tcpSecDropTargetBottom, right=tcpSecDropTargetRight}
      local dragNDrops = {assignParam, assignInsert, assignSend, assignEmbedUi}
      for i,v in pairs(dropTarget) do v.children=nil end -- clear existing children
      
      for i,v in ipairs(dragNDrops) do -- parent the dragNDrop element to the assigned dropTarget
        local assignment = k.paramV[v.param]
        v.y = 0
        if v==assignInsert and k.paramV.insert=='none' and k.paramV.tcpFxparmVisflag1==1 then -- inserts sharing with fxParams
          assignment = k.paramV.fxParam 
          v.y = -8
        end 
        if v==assignSend and k.paramV.send=='none' and k.paramV.tcpFxparmVisflag2==1 then -- sends sharing with fxParams
          assignment = k.paramV.fxParam 
          v.y = -8
        end 
        v.parent = dropTarget[assignment] 
        if v.parent.children then table.insert(v.parent.children, v) else v.parent.children = {v} end
        v.flow=true
        
        if assignment=='none' then -- hide disable and pin buttons if assignment is none
          v.w = 90
          if v.children[3] then v.children[3].w = 0 end
          if v.children[4] then v.children[4].w = 0 end
        else
          v.w = 134
          if v.children[3] then v.children[3].w = 16 end
          if v.children[4] then v.children[4].w = 16 end
        end
        
        if (v==assignInsert or v==assignSend) and k.paramV[v.param]==k.paramV.fxParam and assignment~='none' then v.y = -8 end -- inserts or sends sharing with fxParams
        
      end
      
      --FxParam grouping border & Section Properties blankers--
      local tcpSecParamBorderH = 30
      if insertSecWidthDiag then insertSecWidthDiag.children[9].w=0 end -- reset this
      if sendSecWidthDiag then sendSecWidthDiag.children[9].w=0 end -- reset this
      if k.paramV.fxParam==k.paramV.insert or k.paramV.tcpFxparmVisflag1==1 then
        tcpSecParamBorderH = tcpSecParamBorderH + 20
        if insertSecWidthDiag then insertSecWidthDiag.children[9].w=460 end
      end
      if k.paramV.fxParam==k.paramV.send or k.paramV.tcpFxparmVisflag2==1 then
        tcpSecParamBorderH = tcpSecParamBorderH + 22
        if sendSecWidthDiag then sendSecWidthDiag.children[9].w=460 end
      end
      if tcpSecParamBorder then 
        tcpSecParamBorder.w=0
        tcpSecParamBorder.parent = dropTarget[k.paramV.fxParam]
        if tcpSecParamBorderH>30 and k.paramV.fxParam~='none' then tcpSecParamBorder.w=144 end
        tcpSecParamBorder.h = tcpSecParamBorderH 
        addNeedUpdate(tcpSecParamBorder, true)
      end
    end
    })
    
  El:new({parent=tcpSecAssignBox, x=172, y=44, w=154, h=12, col={120,60,190,0},text={str='UNASSIGNED ELEMENTS', style=1, align=5, col= c_Grey50}, interactive=false })  
  tcpSecDropTargetNone = DropTarget:new({parent=tcpSecAssignBox, target=tcpSectionsAssignController, x=172, y=64, w=154, h=136, param='none', interactive=true,
    col=c_Grey20, origCol=c_Grey20, hoverCol=c_Grey33, strokeCol=c_Grey25 })
  
  tcpSecDropTargetLeft = DropTarget:new({parent=tcpSecAssignBox, target=tcpSectionsAssignController, x=16, y=126, w=154, h=120, param='left', col=c_Grey10, hoverCol=c_Grey15, interactive=true })
  El:new({parent=tcpSecAssignBox, x=16, y=248, w=154, h=24, col=c_Grey10, text={str='LEFT SECTION', style=1, align=5, col= c_Grey50}, interactive=false })
  tcpSecDropTargetBottom = DropTarget:new({parent=tcpSecAssignBox, target=tcpSectionsAssignController, x=172, y=202, w=154, h=120, param='bottom', col=c_Grey10, hoverCol=c_Grey15, interactive=true })
  El:new({parent=tcpSecAssignBox, x=172, y=324, w=154, h=24, col=c_Grey10, text={str='BOTTOM SECTION', style=1, align=5, col= c_Grey50}, interactive=false })
  tcpSecDropTargetRight = DropTarget:new({parent=tcpSecAssignBox, target=tcpSectionsAssignController, x=328, y=126, w=154, h=120, param='right', col=c_Grey10, hoverCol=c_Grey15, interactive=true })
  El:new({parent=tcpSecAssignBox, x=328, y=248, w=154, h=24, col=c_Grey10, text={str='RIGHT SECTION', style=1, align=5, col= c_Grey50}, interactive=false })
  
  tcpSecParamBorder = El:new({parent=tcpSecAssignBox, x=5, y=5, img='roundBox_white25', iType=1, w=0, h=72, interactive=false})
  
  assignParamPinController = Controller:new({parent=tcpSecAssignBox, x=0, y=0, w=6, h=0, paramDesc = 'FX Parameters Pin' })
  assignParam = DragNDrop:new({parent=tcpSecAssignBox, target=tcpSectionsAssignController, w=134, h=22, border=10, param='fxParam' }) 
    El:new({parent=assignParam, x=0, y=0, img='tcp_param', iType=1, w=90, h=22, interactive=false})
    El:new({parent=assignParam, x=20, y=0, w=0, r={toEdge, assignParam, 'right'}, h=10, col={120,60,190,0}, 
        text={str='Parameters', style=1, align=4, col= c_Grey15}, interactive=false })
    Button:new({parent=assignParam, target=assignParamPinController, x=96, y=3, img='tcp_Section_pin_off', imgOn='tcp_Section_pin_on', w=16, h=16,
      toolTip = 'Pin space even if empty', hidden = true})
  
  assignInsertDisController = Controller:new({parent=tcpSecAssignBox, x=0, y=0, w=6, h=0, controlType='reaperActionToggle', param=40302 })
  assignInsertPinController = Controller:new({parent=tcpSecAssignBox, x=0, y=0, w=6, h=0, paramDesc = 'FX List Pin' })
  assignInsert = DragNDrop:new({parent=tcpSecAssignBox, target=tcpSectionsAssignController, w=134, h=16, border=10, param='insert' }) 
    El:new({parent=assignInsert, x=0, y=0, img='tcp_insert', iType=1, w=90, h=16, interactive=false})
    El:new({parent=assignInsert, x=0, y=0, w=0, r={toEdge, assignInsert, 'right'}, h=16, col={120,60,190,0}, 
        text={str='Effects Inserts', style=1, align=4, col= c_Grey15}, interactive=false })
    Button:new({parent=assignInsert, target=assignInsertDisController, x=96, y=0, img='tcp_Section_disable_on', imgOn='tcp_Section_disable_off', w=16, h=16,
      toolTip = 'Show FX inserts in TCP (when size permits)' })
    Button:new({parent=assignInsert, target=assignInsertPinController, x=118, y=0, img='tcp_Section_pin_off', imgOn='tcp_Section_pin_on', w=16, h=16,
      toolTip = 'Pin space even if empty'})
  
  assignSendDisController = Controller:new({parent=tcpSecAssignBox, x=0, y=0, w=6, h=0, controlType='reaperActionToggle', param=40677 })
  assignSendPinController = Controller:new({parent=tcpSecAssignBox, x=0, y=0, w=6, h=0, paramDesc = 'Send List Pin' })
  assignSend = DragNDrop:new({parent=tcpSecAssignBox, target=tcpSectionsAssignController, w=134, h=22, border=10, param='send' }) 
    El:new({parent=assignSend, x=0, y=0, img='tcp_send', iType=1, w=90, h=20, interactive=false})
    El:new({parent=assignSend, x=0, y=0, w=0, r={toEdge, assignSend, 'right'}, h=20, col={120,60,190,0}, 
        text={str='Track Sends', style=1, align=4, col= c_Grey70}, interactive=false })
    Button:new({parent=assignSend, target=assignSendDisController, x=96, y=3, img='tcp_Section_disable_on', imgOn='tcp_Section_disable_off', w=16, h=16,
      toolTip = 'Show sends in TCP (when size permits)' })
    Button:new({parent=assignSend, target=assignSendPinController, x=118, y=3, img='tcp_Section_pin_off', imgOn='tcp_Section_pin_on', w=16, h=16,
      toolTip = 'Pin to use space even if empty'})
  
  assignEmbedUiPinController = Controller:new({parent=tcpSecAssignBox, x=0, y=0, w=6, h=0, paramDesc = 'Embedded FX Pin' })
  assignEmbedUi = DragNDrop:new({parent=tcpSecAssignBox, target=tcpSectionsAssignController, w=134, h=22, border=10, param='embedUi' }) 
    El:new({parent=assignEmbedUi, x=0, y=0, img='tcp_embedUi', iType=1, w=90, h=26, interactive=false })
    El:new({parent=assignEmbedUi, x=0, y=0, w=90, h=26, col={120,60,190,0}, text={str='FX UI', style=1, align=10, col={80,180,180}}, interactive=false })
    Button:new({parent=assignEmbedUi, target=assignEmbedUiPinController, x=96, y=3, img='tcp_Section_pin_off', imgOn='tcp_Section_pin_on', w=16, h=16,
      toolTip = 'Pin to use space even if empty'})
  
  leftSecWidth = El:new({parent=tcpSecAssignBox, x=16, y=280, w=154, h=26, col={255,100,0,0}, interactive=false })
  leftSecWidthController = Controller:new({parent=leftSecWidth, x=0, y=0, w=6, h=0, paramDesc = 'Left Section Width', units = 'px', desc='Width' })
  El:new({parent=leftSecWidth, x=6, y=0, w=20, h=20, shape='evenCircle', col=c_Grey50, interactive = false })
  Knob:new({parent=leftSecWidth, target=leftSecWidthController, x=6, y=0, w=20, h=20, img='knobStack_20px_dark', iFrameH=20, iFrame=20 })
  ccControls:new({parent=leftSecWidth, x=32, y=0, target=leftSecWidthController })
  
  rightSecWidth = El:new({parent=tcpSecAssignBox, x=328, y=280, w=154, h=26, col={255,100,0,0}, interactive=false })
  rightSecWidthController = Controller:new({parent=rightSecWidth, x=0, y=0, w=6, h=0, paramDesc = 'Right Section Width', units = 'px', desc='Width' })
  El:new({parent=rightSecWidth, x=6, y=0, w=20, h=20, shape='evenCircle', col=c_Grey50, interactive = false })
  Knob:new({parent=rightSecWidth, target=rightSecWidthController, x=6, y=0, w=20, h=20, img='knobStack_20px_dark', iFrameH=20, iFrame=20 })
  ccControls:new({parent=rightSecWidth, x=32, y=0, target=rightSecWidthController })
  
  
  
  tcpSecPropertiesBox = El:new({parent=bodyBox, x=0, y=0, w=500, h=364, tile=true, col=c_Grey20 })
  TitleBar:new({parent=tcpSecPropertiesBox, x=0, y=0, layouts='all', text={str='Section properties'} })
  
  tcpParamWMaxController = Controller:new({parent=tcpSecPropertiesBox, paramDesc = 'TCP FX Parameters Maximum Width', units = 'px', desc = 'Maximum Width' }) 
  tcpParamWMinController = Controller:new({parent=tcpSecPropertiesBox, paramDesc = 'TCP FX Parameters Minimum Width', units = 'px', desc = 'Minimum Width' }) 
  
  secWidthDiag:new({parent=tcpSecPropertiesBox, x=0, y=26, z=2, flow=nil, sec={img='tcp_param', imgH=22, str='Parameter Name', labelH=10, labelX=20,
    targetMin = tcpParamWMinController, targetMax = tcpParamWMaxController}  }) 
  
  tcpInsertWMaxController = Controller:new({parent=tcpSecPropertiesBox, paramDesc = 'TCP FX Maximum Width', units = 'px', desc = 'Maximum Width' }) 
  tcpInsertWMinController = Controller:new({parent=tcpSecPropertiesBox, paramDesc = 'TCP FX Minimum Width', units = 'px', desc = 'Minimum Width' }) 
  
  insertSecWidthDiag = secWidthDiag:new({parent=tcpSecPropertiesBox, x=0, y=0, z=2, flow=true, sec={img='tcp_insert', imgH=16, str='Insert Name', labelH=16, 
    targetMin = tcpInsertWMinController, targetMax = tcpInsertWMaxController}  }) 
  
  tcpSendWMaxController = Controller:new({parent=tcpSecPropertiesBox, paramDesc = 'TCP Send Maximum Width', units = 'px', desc = 'Maximum Width' }) 
  tcpSendWMinController = Controller:new({parent=tcpSecPropertiesBox, paramDesc = 'TCP Send Minimum Width', units = 'px', desc = 'Minimum Width' }) 
  
  sendSecWidthDiag = secWidthDiag:new({parent=tcpSecPropertiesBox, x=0, y=0, z=2, flow=true, sec={img='tcp_send', imgH=20, str='Send Name', labelH=20, labelW = -16, labelCol=c_Grey70,
    targetMin = tcpSendWMinController, targetMax = tcpSendWMaxController}  }) 
  
  emptySecOpacityController = Controller:new({parent=tcpSecPropertiesBox, x=0, y=0, w=6, h=0, paramDesc='Empty TCP Section Opacity', desc = 'Empty Section Opacity', units = '%',
    remapToMin = 0, remapToMax = 100})
  CapsuleFader:new({parent=tcpSecPropertiesBox, x=12, y=12, w=228, flow=true, target=emptySecOpacityController, colA=c_Grey20, colB=c_Grey10, trackCol=c_Grey25  })
  ccControls:new({parent=tcpSecPropertiesBox, x=254, y=260, target=emptySecOpacityController  }) 
 
  secMarginDiag = El:new({parent=tcpSecPropertiesBox, x=10, y=292, z=2, w=480, h=60, col={255,100,0,0} }) 
  secMarginController = Controller:new({parent=secMarginDiag, paramDesc = 'Section Margins', w=0, units = 'px', desc = 'Section Margins' }) 
  secMarginDiagBg = MiscAgent:new({parent=secMarginDiag, target=secMarginController, x=0, y=0, z=2, w=230, h=60, flow=true, col=c_Grey10,
    onNewValue = function(k)
      local dM = math.floor(k.target.paramV)
      local dW = math.floor((230 - (4*dM)) / 3)
      k.children[1].border, k.children[1].w = dM, dW
      k.children[2].x, k.children[2].w = dM, dW
      k.children[3].x, k.children[3].w = dM, dW
      k.children[4].x, k.children[4].w = dM, dW
      k.children[5].x, k.children[5].w = dM, dW
      k.children[6].x, k.children[6].w = dM, dW
      k.isDirty=true
    end
    }) 
  
    El:new({parent=secMarginDiagBg, x=0, y=0, z=2, w=1, h=16, img='tcp_insert', iType=1, interactive = false })
    El:new({parent=secMarginDiagBg, x=0, y=0, z=2, w=1, h=16, flow=true, img='tcp_insert', iType=1, interactive = false })
    El:new({parent=secMarginDiagBg, x=0, y=0, z=2, w=1, h=16, flow=true, img='tcp_insert', iType=1, interactive = false })
    El:new({parent=secMarginDiagBg, x=0, y=2, z=2, w=1, h=16, flow=true, img='tcp_insert', iType=1, interactive = false })
    El:new({parent=secMarginDiagBg, x=0, y=0, z=2, w=1, h=16, flow=true, img='tcp_insert', iType=1, interactive = false })
    El:new({parent=secMarginDiagBg, x=0, y=0, z=2, w=1, h=16, flow=true, img='tcp_insert', iType=1, interactive = false })
  ccControls:new({parent=secMarginDiag, x=244, y=20, target=secMarginController  }) 

          
          
          
  tcpMasterBox = El:new({parent=bodyBox, x=0, y=0, w=500, h=364, tile=true, col=c_Grey20 })    
  El:new({parent=tcpMasterBox, x=0, y=0, w=0, r={toEdge, tcpMasterBox, 'right'}, h=26, col=c_Grey10, text={str='Master Track', style=3, align=4, col=c_Grey50} }) 
  
  tcpMasterBgController = Controller:new({parent=tcpMasterBox, x=0, y=0, w=6, h=0, flow=true, style='colour', paramDesc = 'Master TCP background colour', labelStr = 'Background Color' })      
  ColourChooseAgent:new({parent=tcpMasterBox, x=6, y=34, border=10, w=196, h=50, style='colour', col=c_Grey20, target=tcpMasterBgController})
  
  tcpMasterLabelSect = El:new({parent=tcpMasterBox, x=0, y=12, border=10, flow=true, w=480, h=84, col={0,255,255,0} }) -- zero opacity color
  tcpMasterLabelsController = Controller:new({parent=tcpMasterLabelSect, x=40, y=0, w=6, h=6, paramDesc = 'Master TCP Labels' })
  tcpMasterLabelDiag = MiscAgent:new({parent=tcpMasterLabelSect, target=tcpMasterLabelsController, x=0, y=0, z=2, w=480, h=24, interactive=false, 
    onNewValue = function(k)
      if k.target.paramV==1 then
        k.children[2].w = 56
        tcpMasterVolDiag.x = 66
        tcpMasterVolTape.x = 66
        tcpMasterVolControls.x = 94
      else
        k.children[2].w = 0
        tcpMasterVolDiag.x=12
        tcpMasterVolTape.x = 26
        tcpMasterVolControls.x = 54
      end
      tcpMasterVolDiag:onNewValue()
      tcpMasterVolOversize:onNewValue()
      k.isDirty, doArrange = true, true
    end
    })
    El:new({parent=tcpMasterLabelDiag, x=0, y=0, w=24, h=24, col=c_Grey10, shape='evenCircle', interactive = false })
    El:new({parent=tcpMasterLabelDiag, x=12, y=0, w=56, h=24, col=c_Grey10, text={str='MASTER', style=2, align=4, padding=0, col={220, 220, 220}}, interactive = false })
  
  tcpMasterVolLengthController = Controller:new({parent=tcpMasterLabelSect, x=10, y=0, w=6, h=6, paramDesc='Master TCP Volume Length', desc = 'Volume Length', units = 'px',
    valueAlias = {[40] = 'Knob'}  })
  
  tcpMasterVolDiag = MiscAgent:new({parent=tcpMasterLabelSect, target=tcpMasterVolLengthController, x=0, y=0, z=2, w=-12, 
    r=nil, h=24, interactive=false, 
    onNewValue = function(k)
      k.r = nil
      if k.target.paramV==40 then
        k.children[1].w = -16
        k.children[3].w = 24 -- knob image
        k.children[4].w = 0
        k.children[5].w = 0
        tcpMasterVolDiag.w = 32
      else 
        tcpMasterVolDiag.w = k.target.paramV
        local maxWidth = 466
        if tcpMasterLabelsController.paramV==1 then maxWidth = 412 end
        if k.target.paramV and k.target.paramV>maxWidth then 
          k.w = 0
          k.r={toEdge, tcpMasterLabelSect, 'right'}
        end
        k.children[1].w = -12
        k.children[3].w = 0 -- knob image
        k.children[4].w = -12
        k.children[5].x = math.ceil((k.target.paramV or 1)/2) - 10
        k.children[5].w = 20
      end
      k.isDirty, doArrange = true, true
    end
    })
    El:new({parent=tcpMasterVolDiag, x=0, y=0, w=-12, h=24, r={toEdge, tcpMasterVolDiag, 'right'}, col=c_Grey10, interactive = false })
    El:new({parent=tcpMasterVolDiag, x=-12, y=0, w=24, h=24, flow=true, col=c_Grey10, shape='evenCircle', interactive = false })
    El:new({parent=tcpMasterVolDiag, x=2, y=2, w=22, h=22, img='round22_nonInteractive', interactive=false })  
    El:new({parent=tcpMasterVolDiag, x=0, y=10, w=-12, h=4, r={toEdge, tcpMasterVolDiag, 'right'}, col=c_Grey15, shape='capsule', interactive = false }) -- track
    El:new({parent=tcpMasterVolDiag, x=50, y=-2, w=20, h=28, img='slider_nonInteractive', interactive=false }) 
    
  tcpMasterVolTape = TapeMeasure:new({parent=tcpMasterLabelSect, target=tcpMasterVolLengthController, x=10, y=30, z=2, tape={zeroAtV=40}, 
    w=-20, h=20,  r={toEdge, tcpMasterLabelSect, 'right'}, interactive = false }) 
    
  tcpMasterVolOversize = MiscAgent:new({parent=tcpMasterLabelSect, target=tcpMasterVolLengthController, x=380, y=0, w=0, h=34,  
     col={255,0,0,100}, shape='gradient', colA={51,51,51,0}, colB={51,51,51,255}, deg=0,
    onNewValue = function(k)
      local maxWidth = 466
      if tcpMasterLabelsController.paramV==1 then maxWidth = 412 end
      if k.target.paramV and k.target.paramV>maxWidth then k.w=100
      else k.w=0
      end
    end })
    
  tcpMasterVolControls = ccControls:new({parent=tcpMasterLabelSect, x=140, y=36, target=tcpMasterVolLengthController  })

  Button:new({parent=tcpMasterLabelSect, x=18, y=48, style='button', target=tcpMasterLabelsController, img='button_upArrow_off', imgOn='button_upArrow_on', iType=3 })
  Label:new({parent=tcpMasterLabelSect, x=6, y=14, w=60, h=20, flow=true, target=tcpMasterLabelsController, 
    text={str='Show MASTER label', style=2, align=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO } })
  ToggleButton:new({parent=tcpMasterBox, x=6, y=0, w=300, h=20, flow=true, paramDesc = 'Master TCP Values', desc='Show Values' }) 
   
  
  tcpMasterMeterBox = El:new({parent=tcpMasterBox, x=0, y=10, w=500, h=130, flow=true, col=c_Grey10, interactive=false })
  tcpMasterMeterWidthController = Controller:new({parent=tcpMasterMeterBox, x=0, y=0, w=6, h=0, paramDesc = 'Master TCP Meter Width', units = 'px', desc='Meter Width' })
  tcpMasterMeterBorderController = Controller:new({parent=tcpMasterMeterBox, x=0, y=0, w=6, h=0, paramDesc = 'Master TCP Meter Border', units = 'px', desc='Meter Border' })
  tcpMasterMeterDiag = MiscAgent:new({parent=tcpMasterMeterBox, target=tcpMasterMeterWidthController, x=20, y=20, w=100, h=30, interactive=false, 
    onNewValue = function(k)
      local maxWidth = 466
      if k.target.paramV and k.target.paramV>maxWidth then k.w=462
      else k.w = k.target.paramV
      end
      k.isDirty=true
      doArrange = true
    end
    })
  MiscAgent:new({parent=tcpMasterMeterDiag, target=tcpMasterMeterWidthController, alsoAgentOf={tcpMasterMeterBorderController}, x=0, y=0, z=2, w=100, h=20, col=c_GreenLit, interactive = false,
    onNewValue = function(k)
      local tmp, tmp, border = reaper.ThemeLayout_GetParameter(paramIdxGet(tcpMasterMeterBorderController.paramDesc))
      if tcpMasterMeterDiag.w > tcpMasterMeterDiag.h then
        k.x, k.y = border, border
        k.w, k.h = -1*border, tcpMasterMeterDiag.h/2 - 1.5*border
        k.r = {toEdge, tcpMasterMeterDiag, 'right'}
      else
        k.x, k.y = border, border
        k.w, k.h = tcpMasterMeterDiag.w/2 - 1.5*border, tcpMasterMeterDiag.h - 2*border
        k.r = nil
      end
      k.isDirty=true
      doArrange = true
    end
    }) 
  MiscAgent:new({parent=tcpMasterMeterDiag, target=tcpMasterMeterWidthController, alsoAgentOf={tcpMasterMeterBorderController}, x=0, y=0, z=2, flow=true, w=100, h=20, col=c_GreenLit, interactive = false,
    onNewValue = function(k)
      local tmp, tmp, border = reaper.ThemeLayout_GetParameter(paramIdxGet(tcpMasterMeterBorderController.paramDesc))
      if tcpMasterMeterDiag.w > tcpMasterMeterDiag.h then
        k.x, k.y = border, border
        k.w, k.h = -1*border, tcpMasterMeterDiag.h/2 - 1.5*border
        k.r = {toEdge, tcpMasterMeterDiag, 'right'}
      else
        k.x, k.y = border, 0
        k.w, k.h = tcpMasterMeterDiag.w/2 - 1.5*border, tcpMasterMeterDiag.h - 2*border
        k.r = nil
      end
      k.isDirty=true
      doArrange = true
    end
    })
  tcpMasterMeterOversize = MiscAgent:new({parent=tcpMasterMeterBox, target=tcpMasterMeterWidthController, x=380, y=0, z=2, w=100, h=50, interactive = false, 
     col={255,100,0,0}, shape='gradient', colA={26,26,26,0}, colB={26,26,26,255}, deg=0,
    onNewValue = function(k)
      local maxWidth = 466
      if k.target.paramV and k.target.paramV>maxWidth then k.w=100
      else k.w=0
      end
    end })
  
  TapeMeasure:new({parent=tcpMasterMeterBox, target=tcpMasterMeterWidthController, x=10, y=58, tape={lengthOffs=10}, w=0, h=20,  r={toEdge, tcpMasterMeterDiag, 'right'}, interactive = false })
  ccControls:new({parent=tcpMasterMeterBox, x=40, y=74, target=tcpMasterMeterWidthController })
  ccControls:new({parent=tcpMasterMeterBox, x=240, y=74, target=tcpMasterMeterBorderController })
  
  ToggleButton:new({parent=tcpMasterMeterBox, x=0, y=20, w=300, h=20, flow=true, paramDesc = 'Master TCP Meter Values', desc='Show Meter Values' })
 
          
  ---------------------------------------------------
  ---------------------- EnvCP ----------------------
  ---------------------------------------------------
          
  belongsToPage = 'EnvCP'
  

  envBox = El:new({parent=bodyBox, x=0, y=0, w=500, h=340, border=20, col=c_Grey20 }) 
  TitleBar:new({parent=envBox, x=0, y=0, layouts='none', text={str='Envelope Control Panel'} }) 
  
  envBgController = Controller:new({parent=envBox, x=0, y=0, w=6, h=0, style='colour', paramDesc = 'EnvCP background colour', labelStr='Background color' })
  ColourChooseAgent:new({parent=envBox, x=6, y=16, w=196, h=50, flow=true, style='colour', col=c_Grey20, target=envBgController})
  
  envValueReadoutController = Controller:new({parent=envBox, x=0, y=2, w=0, h=0, paramDesc = 'Show envelope value' })
  Button:new({parent=envBox, x=240, y=46, style='button', target=envValueReadoutController, img='button_off', imgOn='button_on', iType=3 })
  Label:new({parent=envBox, x=4, y=4, w=10, h=20, flow=true, target=envValueReadoutController, 
    text={str='Show value Readout', style=2, align=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO } })
    
  envIndentController = Controller:new({parent=envBox, x=0, y=2, w=0, h=0, paramDesc = 'Env inherit track indent' })
  Button:new({parent=envBox, x=240, y=70, style='button', target=envIndentController, img='button_off', imgOn='button_on', iType=3 })
  Label:new({parent=envBox, x=4, y=4, w=60, h=20, flow=true, target=envIndentController, 
    text={str='Inherit folder indent from track', style=2, align=0,  resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO } })
  
  envFontController = Controller:new({parent=envBox, x=40, y=0, w=6, h=6, paramDesc = 'Env Label Font Size', units = '', desc='Label Font Size' })
  fontControl:new({parent=envBox, target=envFontController, x=26, y=110, border=0, w=200, h=22 })
  
  envLabelSect = El:new({parent=envBox, x=0, y=12, border=0, flow=true, w=500, h=90, col={0,255,255,0} }) -- zero opacity color
  envFaderLengthController = Controller:new({parent=envLabelSect, x=30, y=0, w=6, h=6, paramDesc='Env Fader Length', desc = 'Fader Length', units = 'px',
    valueAlias = {[40] = 'Knob'}  })
  envLabelLengthController = Controller:new({parent=envLabelSect, x=40, y=0, w=6, h=6, paramDesc = 'Env Label Length', units = 'px', desc='Label Length' })
  
  envLabelDiag = MiscAgent:new({parent=envLabelSect, target=envLabelLengthController, x=10, y=0, w=100, h=24, interactive=false, 
    onNewValue = function(k)
        k.w = k.target.paramV + 16
        envFaderDiag.x = k.x+k.w
        if (k.x+k.w)>460 then 
          k.r={toEdge, k.parent, 'right'}
          k.w = -20
          envFaderDiag.children[2].w = 0
        else 
          k.r = nil
          envFaderDiag.children[2].w = 24
        end
        
        envFaderLengthTape.x = envFaderDiag.x
        if envFaderLengthTape.x > 280 then envFaderLengthTape.x = 280 end
        envFaderLengthControls.x = envFaderLengthTape.x + 30
      envFaderDiag:onNewValue()
      k.isDirty, doArrange = true, true
    end
    })
    El:new({parent=envLabelDiag, x=0, y=0, w=24, h=24, col=c_Grey10, shape='evenCircle', interactive = false })
    El:new({parent=envLabelDiag, x=12, y=0, w=20, h=24, col=c_Grey10, interactive=false }) 
    El:new({parent=envLabelDiag, x=32, y=0, w=0, r={toEdge, envLabelDiag, 'right'}, h=24, col=c_Grey10, interactive = false,
      text={str='Envelope Name can be long, actually very very long, even longer than this, which is really quite long indeed', style=3, align=4, padding=0, col={180,180,180}} })
    El:new({parent=envLabelDiag, x=2, y=2, w=22, h=22, img='round22_nonInteractive', interactive=false }) 
  
  envFaderDiag = MiscAgent:new({parent=envLabelSect, target=envFaderLengthController, x=0, y=0, w=-12, r=nil, h=24, interactive=false, 
    onNewValue = function(k)
      k.r = nil
      if k.target.paramV==40 then
        k.children[1].w = -16
        k.children[3].w = 24 -- knob image
        k.children[4].w = 0
        k.children[5].w = 0
        envFaderDiag.w = 32
      else 
        k.w = k.target.paramV
        k.children[1].w = -12
        k.children[3].w = 0 -- knob image
        k.children[4].w = -12
        k.children[5].x = math.ceil((k.target.paramV or 0)/2) - 10
        k.children[5].w = 20
      end
      if k.w and (k.x+k.w)>460 then 
        k.r={toEdge, k.parent, 'right'}
        k.children[3].w = 0
        k.children[5].w = 0
        k.w = -20
      end
      envLabelVolOversize:onNewValue()
      k.isDirty, doArrange = true, true
    end
    })
    El:new({parent=envFaderDiag, x=0, y=0, w=-12, h=24, r={toEdge, envFaderDiag, 'right'}, col=c_Grey10, interactive = false })
    El:new({parent=envFaderDiag, x=-12, y=0, w=24, h=24, flow=true, col=c_Grey10, shape='evenCircle', interactive = false })
    El:new({parent=envFaderDiag, x=2, y=2, w=22, h=22, img='round22_nonInteractive', interactive=false })  
    El:new({parent=envFaderDiag, x=0, y=10, w=-12, h=4, r={toEdge, envFaderDiag, 'right'}, col=c_Grey15, shape='capsule', interactive = false }) -- track
    El:new({parent=envFaderDiag, x=50, y=-2, w=20, h=28, img='slider_nonInteractive', interactive=false }) 
    
  
  envFaderLengthTape = TapeMeasure:new({parent=envLabelSect, target=envFaderLengthController, x=10, y=32, z=2, tape={zeroAtV=40}, w=0, h=20,  r={toEdge, envBox, 'right'}, interactive = false })  
  TapeMeasure:new({parent=envLabelSect, target=envLabelLengthController, x=36, y=62, z=2, tape={}, w=0, h=20,  r={toEdge, envBox, 'right'}, interactive = false })
  
  envLabelVolOversize = MiscAgent:new({parent=envLabelSect, target=envLabelLengthController, x=380, y=0, z=2, w=0, h=100,  
     col={255,0,0,100}, shape='gradient', colA={51,51,51,0}, colB={51,51,51,255}, deg=0,
    onNewValue = function(k)
      if k.target.paramV and envFaderLengthController.paramV and (k.target.paramV + (envFaderLengthController.paramV or 0))>434 then k.w=100
      else k.w=0
      end
    end })
    
  envFaderLengthControls = ccControls:new({parent=envLabelSect, x=40, y=38, target=envFaderLengthController  })
  ccControls:new({parent=envLabelSect, x=66, y=68, target=envLabelLengthController })
  
  envColStrengthBox = El:new({parent=envBox, x=0, y=20, w=500, h=24, flow=true, interactive = false, col={255,0,100,0} })
  envColStrengthController = Controller:new({parent=envColStrengthBox, x=30, y=0, w=0, h=0, paramDesc='Env Custom Color Strength', desc = 'Custom Color Strength', units = '%' })
  CapsuleFader:new({parent=envColStrengthBox, x=12, y=0, w=236, flow=true, target=envColStrengthController, colA=c_Grey20, colB={egCustomColor[1],egCustomColor[2],egCustomColor[3]}, trackCol=c_Grey10  })
  ccControls:new({parent=envColStrengthBox, x=270, y=2, target=envColStrengthController  })
  
  envDivOpacBox = El:new({parent=envBox, x=0, y=16, w=500, h=24, flow=true, interactive = false, col={255,100,0,0} })
  envDivOpacityController = Controller:new({parent=envDivOpacBox, x=30, y=0, w=0, h=0, paramDesc='Env Div Opacity', desc = 'Divider Opacity', units = '%',  remapToMin = 0, remapToMax = 100 })
  CapsuleFader:new({parent=envDivOpacBox, x=12, y=0, w=236, flow=true, target=envDivOpacityController, colA=c_Grey20, colB=c_Grey10, trackCol=c_Grey25  })
  ccControls:new({parent=envDivOpacBox, x=270, y=2, target=envDivOpacityController  })
  

  
  
  ---------------------------------------------------
  ----------------------- MCP -----------------------
  ---------------------------------------------------
  
  
  belongsToPage = 'MCP'
  
  mcpAllLayoutsBox = El:new({parent=bodyBox, x=0, y=0, tile=true, w=226, h=312, col=c_Grey20 })
  mcpBgController = Controller:new({parent=mcpAllLayoutsBox, x=0, y=0, w=6, h=0, style='colour', paramDesc = 'MCP background colour', labelStr='Background color' }) 
  TitleBar:new({parent=mcpAllLayoutsBox, x=0, y=0, layouts='all', text={str='Mixer'} }) 
  ColourChooseAgent:new({parent=mcpAllLayoutsBox, x=12, y=18, w=196, h=50, flow=true, style='colour', col=c_Grey20, target=mcpBgController})
  mcpDivOpacBox = El:new({parent=mcpAllLayoutsBox, x=0, y=20, w=220, h=44, flow=true, interactive = false, col={255,100,0,0} })
  mcpDivOpacityController = Controller:new({parent=mcpDivOpacBox, x=30, y=0, w=0, h=0, paramDesc='MCP Div Opacity', desc = 'Divider Opacity', units = '%',  remapToMin = 0, remapToMax = 100 })
  CapsuleFader:new({parent=mcpDivOpacBox, x=10, y=0, w=198, flow=true, target=mcpDivOpacityController, colA=c_Grey20, colB=c_Grey10, trackCol=c_Grey25  })
  ccControls:new({parent=mcpDivOpacBox, x=46, y=26, target=mcpDivOpacityController  })        
  mcpIndentController = Controller:new({parent=mcpAllLayoutsBox, paramDesc = 'MCP Folder Indent', w=0, units = 'px', desc = 'Folder Indent' }) 
  ccControls:new({parent=mcpAllLayoutsBox, x=12, y=12, flow=true, target=mcpIndentController  })
  ToggleButton:new({parent=mcpAllLayoutsBox, x=6, y=26, w=300, h=20, flow=true, paramDesc = 'MCP Folder Balance Type', desc='Folder Balance' }) 
  ToggleButton:new({parent=mcpAllLayoutsBox, x=6, y=0, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40549, desc='Show FX Inserts' }) 
  ToggleButton:new({parent=mcpAllLayoutsBox, x=6, y=0, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40910, desc='Show FX Params' }) 
  ToggleButton:new({parent=mcpAllLayoutsBox, x=6, y=0, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40557, desc='Show Sends' }) 
  
  
  mcpBox = El:new({parent=bodyBox, x=0, y=0, tile=true, w=536, h=312, col=c_Grey20 }) 
  TitleBar:new({parent=mcpBox, x=0, y=0, text={str='Mixer Panel'} }) 
  
  mcpLabelFontController = Controller:new({parent=mcpBox, x=40, y=42, w=6, h=6, paramDesc = 'MCP Label Font Size', units = '', desc='Label Font Size' })
  fontControl:new({parent=mcpBox, target=mcpLabelFontController, x=10, y=40, border=0, w=510, h=22 })
  
  mcpSidebarWidthController = Controller:new({parent=mcpBox, x=0, y=0, w=6, h=0, paramDesc = 'Sidebar Width', units = 'px', desc='Sidebar width if added' })
  TapeMeasure:new({parent=mcpBox, target=mcpSidebarWidthController, x=240, y=42,  tape={}, w=0, h=20,  r={toEdge, mcpBox, 'right'}, interactive = false })  
  ccControls:new({parent=mcpBox, x=268, y=48, target=mcpSidebarWidthController })
  
  verboseMcpController = Controller:new({parent=mcpBox, x=0, y=0, w=0, h=0, paramDesc = 'Verbose MCP',
    onNewValue = function(k)
      if k.paramV==1 then
        stripEnvH = 32
      else
        stripEnvH = 22
      end
      mcpEnv.h = stripEnvH
      mcpIo.h = stripEnvH
      mcpStripOrderControl:onUpdate()
      if standardMcpBox then
        standardMcpIo.h, standardMcpEnv.h = stripEnvH, stripEnvH
        standardMcpBox.isDirty=true
      end
    end })
  Button:new({parent=mcpBox, x=10, y=24, flow=true, style='button', target=verboseMcpController, img='button_off', imgOn='button_on', iType=3 })
  Label:new({parent=mcpBox, x=4, y=4, w=60, h=20, flow=true, target=verboseMcpController, 
    text={str='Show labels & values', style=2, align=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO } })
    
  mcpMeterReadoutController = Controller:new({parent=mcpBox, x=0, y=0, w=0, h=0, paramDesc = 'mcpMeterReadout' })
  Button:new({parent=mcpBox, x=24, y=-4, flow=true, style='button', target=mcpMeterReadoutController, img='button_off', imgOn='button_on', iType=3 })
  Label:new({parent=mcpBox, x=4, y=4, w=60, h=20, flow=true, target=mcpMeterReadoutController, 
    text={str='Show meter readout', style=2, align=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO } })
 
  mcpFormWidths = {52, 88}
  mcpConditionTallyController = Controller:new({parent=mcpBox, x=0, y=0, w=0, h=0, 
    onNewValue = function(k)
      if mcpUnselWidthController and mcpSelWidthController and mcpArmedWidthController then
        k.paramV={{},{},{}}
        -- form this controller's paramV as a table with 3 positions (standard, reduced, strip) 
        for i,v in pairs{mcpUnselWidthController, mcpSelWidthController, mcpArmedWidthController} do
          if v.paramV then
            if v.paramV<mcpFormWidths[2] then
              if v.paramV<mcpFormWidths[1] then table.insert(k.paramV[3],i) else table.insert(k.paramV[2],i) end
            else table.insert(k.paramV[1],i)
            end
          end
        end 
        
        if standardMcpBox and reducedMcpBox and mcpStripBox then
          for i,v in pairs{standardMcpBox, reducedMcpBox, mcpStripBox} do
            if k.paramV[i] then
              v.children[1].col, v.children[2].col, v.children[3].col, v.children[1].text.col = c_Grey15, {0,0,0,0}, {0,0,0,0}, c_Grey33
              for l,m in pairs(k.paramV[i]) do
                --reaper.ShowConsoleMsg(i..' is size '..#k.paramV[i]..', active size is '..k.paramV[i][l]..' (1=unsel, 2=sel, 3=armed)\n')
                v.children[l].col = mcpConditionCols[k.paramV[i][l]]
                v.children[1].text.col = mcpConditionTextCols[k.paramV[i][1]]
                v.children[l].isDirty = true
              end
              v.children[1].isDirty, v.children[2].isDirty, v.children[3].isDirty = true, true, true
            end
          end
        end
      
      end
    end
    })
   
  mcpConditionCols = {c_Grey10, {200,200,200}, {180,0,0}}
  mcpConditionTextCols = {c_Grey80, {38,38,38}, {255,150,150}} 
        
  mcpUnselectedBox = El:new({parent=mcpBox, x=0, y=100, w=166, h=190, border=10, col=c_Grey15 })    
  El:new({parent=mcpUnselectedBox, x=0, y=0, w=0, r={toEdge, mcpUnselectedBox, 'right'}, h=20, col=mcpConditionCols[1], text={str='if a track is UNSELECTED', style=2, align=4, col=mcpConditionTextCols[1]} }) 
  
  mcpUnselWidth = El:new({parent= mcpUnselectedBox, x=6, y=6, w=160, h=40, flow=true, col={255,100,0,0}, interactive=false })
  El:new({parent=mcpUnselWidth, x=mcpFormWidths[2], y=2, w=76, h=16, text={str='STANDARD', style=1, align=0, padding=6, col={0,204,136,180}}, interactive = false }) 
  mcpUnselWidthController = Controller:new({parent=mcpUnselWidth, target=mcpConditionTallyController, x=0, y=0, w=6, h=0, paramDesc = 'Mixer Panel Width', units = 'px', desc='Width' , 
    onNewValue = function(k)
      k.parent.children[1].x, k.parent.children[1].text.str = mcpFormWidths[2], 'STANDARD'
      if k.paramV and k.paramV<mcpFormWidths[2] then 
        k.parent.children[1].x, k.parent.children[1].text.str = mcpFormWidths[1], 'REDUCED'
        if k.paramV<mcpFormWidths[1] then k.parent.children[1].x, k.parent.children[1].text.str = 20, 'STRIP' end
      end
    end })
  TapeMeasure:new({parent=mcpUnselWidth, target=mcpUnselWidthController, x=6, y=20,  tape={}, w=0, h=20,  r={toEdge, mcpUnselWidth, 'right'}, interactive = false })  
  ccControls:new({parent=mcpUnselWidth, x=32, y=26, target=mcpUnselWidthController })
  mcpUnselExpansionController = Controller:new({parent=mcpUnselectedBox, x=0, y=0, w=0, h=0, paramDesc='Mixer nChan Grow', desc = '', units = 'px', valueAlias = {[0] = 'None'}  })
  ccControls:new({parent=mcpUnselectedBox, x=4, y=12, h=18, flow=true, target=mcpUnselExpansionController })
  Label:new({parent=mcpUnselectedBox, x=10, y=6, z=2, w=40, h=20, flow=true, target=mcpUnselExpansionController, 
    text={str='Expansion by channel count', wrap=true, style=2, align=0, col=labelColMA, mouseOverCol=labelColMO, padding=0, resizeToFit=true} }) 
  ToggleButton:new({parent=mcpUnselectedBox, x=2, y=6, w=300, h=20, flow=true, paramDesc = 'Mixer Sidebar', desc='Add sidebar' }) 
  ToggleButton:new({parent=mcpUnselectedBox, x=2, y=0, w=300, h=20, flow=true, paramDesc = 'Mixer Meter Values', desc='Show meter values' }) 
  
  mcpSelectedBox = El:new({parent=mcpBox, x=0, y=0, w=166, h=190, border=10, flow = true, col=c_Grey15 })    
  El:new({parent=mcpSelectedBox, x=0, y=0, w=0, r={toEdge, mcpSelectedBox, 'right'}, h=20, col=mcpConditionCols[2], text={str='if a track is SELECTED', style=2, align=4, col=mcpConditionTextCols[2]} }) 
  mcpSelWidth = El:new({parent= mcpSelectedBox, x=6, y=6, w=160, h=40, flow=true, col={255,100,0,0}, interactive=false })
  El:new({parent=mcpSelWidth, x=mcpFormWidths[2], y=2, w=76, h=16, text={str='STANDARD', style=1, align=0, padding=6, col={0,204,136,180}}, interactive = false }) 
  mcpSelWidthController = Controller:new({parent=mcpSelWidth, target=mcpConditionTallyController, x=0, y=0, w=6, h=0, paramDesc = 'Selected Mixer Panel Width', units = 'px', desc='Width' , 
    onNewValue = function(k)
      k.parent.children[1].x, k.parent.children[1].text.str = mcpFormWidths[2], 'STANDARD'
      if k.paramV and k.paramV<mcpFormWidths[2] then 
        k.parent.children[1].x, k.parent.children[1].text.str = mcpFormWidths[1], 'REDUCED'
        if k.paramV<mcpFormWidths[1] then k.parent.children[1].x, k.parent.children[1].text.str = 20, 'STRIP' end
      end
    end })
  TapeMeasure:new({parent=mcpSelWidth, target=mcpSelWidthController, x=6, y=20,  tape={}, w=0, h=20,  r={toEdge, mcpSelWidth, 'right'}, interactive = false })  
  ccControls:new({parent=mcpSelWidth, x=32, y=26, target=mcpSelWidthController })
  mcpSelExpansionController = Controller:new({parent=mcpSelectedBox, x=0, y=0, w=0, h=0, paramDesc='Selected Mixer nChan Grow', desc = '', units = 'px', valueAlias = {[0] = 'None'}  })
  ccControls:new({parent=mcpSelectedBox, x=4, y=12, h=18, flow=true, target=mcpSelExpansionController })
  Label:new({parent=mcpSelectedBox, x=10, y=6, z=2, w=40, h=20, flow=true, target=mcpSelExpansionController, 
    text={str='Expansion by channel count', wrap=true, style=2, align=0, col=labelColMA, mouseOverCol=labelColMO, padding=0, resizeToFit=true} }) 
  ToggleButton:new({parent=mcpSelectedBox, x=2, y=6, w=300, h=20, flow=true, paramDesc = 'Selected Mixer Sidebar', desc='Add sidebar' }) 
  ToggleButton:new({parent=mcpSelectedBox, x=2, y=0, w=300, h=20, flow=true, paramDesc = 'Selected Mixer Meter Values', desc='Show meter values' }) 
  
  mcpArmedBox = El:new({parent=mcpBox, x=0, y=0, w=164, h=190, border=10, flow = true, col=c_Grey15 })    
  El:new({parent=mcpArmedBox, x=0, y=0, w=0, r={toEdge, mcpArmedBox, 'right'}, h=20, col=mcpConditionCols[3], text={str='if a track is ARMED', style=2, align=4, col=mcpConditionTextCols[3]} })
  mcpArmedWidth = El:new({parent= mcpArmedBox, x=6, y=6, w=160, h=40, flow=true, col={255,100,0,0}, interactive=false })
  El:new({parent=mcpArmedWidth, x=mcpFormWidths[2], y=2, w=76, h=16, text={str='STANDARD', style=1, align=0, padding=6, col={0,204,136,180}}, interactive = false }) 
  mcpArmedWidthController = Controller:new({parent=mcpArmedWidth, target=mcpConditionTallyController, x=0, y=0, w=6, h=0, paramDesc = 'Armed Mixer Panel Width', units = 'px', desc='Width' , 
    onNewValue = function(k)
      k.parent.children[1].x, k.parent.children[1].text.str = mcpFormWidths[2], 'STANDARD'
      if k.paramV and k.paramV<mcpFormWidths[2] then 
        k.parent.children[1].x, k.parent.children[1].text.str = mcpFormWidths[1], 'REDUCED'
        if k.paramV<mcpFormWidths[1] then k.parent.children[1].x, k.parent.children[1].text.str = 20, 'STRIP' end
      end
    end })
  TapeMeasure:new({parent=mcpArmedWidth, target=mcpArmedWidthController, x=6, y=20,  tape={}, w=0, h=20,  r={toEdge, mcpArmedWidth, 'right'}, interactive = false })  
  ccControls:new({parent=mcpArmedWidth, x=32, y=26, target=mcpArmedWidthController })          
  mcpArmExpansionController = Controller:new({parent=mcpArmedBox, x=0, y=0, w=0, h=0, paramDesc='Armed Mixer nChan Grow', desc = '', units = 'px', valueAlias = {[0] = 'None'}  })
  ccControls:new({parent=mcpArmedBox, x=4, y=12, h=18, flow=true, target=mcpArmExpansionController })
  Label:new({parent=mcpArmedBox, x=10, y=6, z=2, w=40, h=20, flow=true, target=mcpArmExpansionController, 
    text={str='Expansion by channel count', wrap=true, style=2, align=0, col=labelColMA, mouseOverCol=labelColMO, padding=0, resizeToFit=true} }) 
  ToggleButton:new({parent=mcpArmedBox, x=2, y=6, w=300, h=20, flow=true, paramDesc = 'Armed Mixer Sidebar', desc='Add sidebar' }) 
  ToggleButton:new({parent=mcpArmedBox, x=2, y=0, w=300, h=20, flow=true, paramDesc = 'Armed Mixer Meter Values', desc='Show meter values' }) 
  
  
  mcpWidthsBox = El:new({parent=bodyBox, x=0, y=0, tile=true, w=410, h=810, col=c_Grey15 }) 
  TitleBar:new({parent=mcpWidthsBox, x=0, y=0, text={str='if width'} }) 
  
  standardMcpBox = El:new({parent=mcpWidthsBox, x=0, y=0, w=190, h=400, border=10, flow = true, col=c_Grey20 })
  El:new({parent=standardMcpBox, x=0, y=0, w=190, h=20, col={120,255,255}, text={str='if STANDARD width', style=2, align=4, col={0,100,100}} })  
  El:new({parent=standardMcpBox, x=20, y=0, w=170, h=20, shape='poly', coords={{127,0}, {170,0}, {170,19}, {108,19} }, interactive=false, col={255,120,0} })  
  El:new({parent=standardMcpBox, x=20, y=0, w=170, h=20, shape='poly', coords={{153,0}, {170,0}, {170,19}, {134,19} }, interactive=false, col={0,120,255} }) 
  
  
  darkUnderButtonsController = Controller:new({parent=standardMcpBox, x=0, y=0, w=0, h=0, paramDesc = 'Dark Under Buttons' })
  Button:new({parent=standardMcpBox, x=32, y=12, flow=true, style='button', target=darkUnderButtonsController, img='button_upArrow_off', imgOn='button_upArrow_on', iFlip=true, iType=3 })
  Label:new({parent=standardMcpBox, x=6, y=8, w=120, h=20, flow=true, target=darkUnderButtonsController,
    text={str='Dark strip under the buttons section', style=2, align=0, padding=0, wrap=true, lineSpacing=12, col=labelColMA, mouseOverCol=labelColMO } })
  
  El:new({parent=standardMcpBox, x=6, y=6, w=20, h=200, flow=true, col={0}, shape='gradient', colA={c_Grey15[1], c_Grey15[2], c_Grey15[3], 0}, colB=c_Grey15, deg=0, interactive = false }) 
  
  standardMcpButtonsBox = MiscAgent:new({parent=standardMcpBox, target=mcpBgController, alsoAgentOf={darkUnderButtonsController}, x=0, y=0, z=2, w=34, h=200, flow=true, col= c_CyanGrey, interactive = false,
    onNewValue = function(k)
      k.col = mcpBgController.paramV
      if #projectCustCols>0 and mcpBgController.paramV and darkUnderButtonsController.paramV and k.target.paramV then 
        if darkUnderButtonsController.paramV==0 then
          local tmp, tmp, value  = reaper.ThemeLayout_GetParameter(paramIdxGet('Custom Color Strength'))
          k.col = compositeCols(k.target.paramV, egCustomColor, value/100)
        else k.col = c_Grey15
        end
      end
      k.parent.isDirty=true
    end
    })
 
  standardMcpShowRouteController = Controller:new({parent=standardMcpBox, x=0, y=0, w=0, h=0, paramDesc='mcpNormalShowRoute', desc='Show Route' })
  standardMcpShowFxController = Controller:new({parent=standardMcpBox, x=0, y=0, w=0, h=0, paramDesc='mcpNormalShowSecFx', desc='Show FX' })
  standardMcpShowEnvController = Controller:new({parent=standardMcpBox, x=0, y=0, w=0, h=0, paramDesc='mcpNormalShowEnv', desc='Show Envelope' })
  standardMcpShowPhaseController = Controller:new({parent=standardMcpBox, x=0, y=0, w=0, h=0, paramDesc='mcpNormalShowPhase', desc='Show Phase' })
  
  El:new({parent=standardMcpButtonsBox, x=7, y=6, z=2, w=20, h=42, flow=false, img='mcp_mutesolo', interactive=false })
  standardMcpIo = MiscAgent:new({parent=standardMcpButtonsBox, target=standardMcpShowRouteController, x=6, y=6, w=22, h=stripEnvH, flow=true, img='mcp_io', iType=1, interactive=false, 
    onNewValue = function(k)
      if k.target.paramV==1 then k.y,k.h,k.w=6,stripEnvH,22 else k.y,k.h,k.w=0,0,0 end
      k.parent.isDirty=true
    end })
  MiscAgent:new({parent=standardMcpButtonsBox, target=standardMcpShowFxController, x=7, y=6, w=20, h=38, flow=true, img='mcp_fx', interactive=false, 
    onNewValue = function(k)
      if k.target.paramV==1 then k.y,k.h,k.w=6,38,20 else k.y,k.h,k.w=0,0,0 end
      k.parent.isDirty=true
    end })
  standardMcpEnv = MiscAgent:new({parent=standardMcpButtonsBox, target=standardMcpShowEnvController, x=6, y=6, w=22, h=stripEnvH, flow=true, img='mcp_env', iType=1, interactive=false, 
    onNewValue = function(k)
      if k.target.paramV==1 then k.y,k.h,k.w=6,stripEnvH,22 else k.y,k.h,k.w=0,0,0 end
      k.parent.isDirty=true
    end })
  MiscAgent:new({parent=standardMcpButtonsBox, target=standardMcpShowPhaseController, x=9, y=6, w=16, h=18, flow=true, img='mcp_phase', interactive=false, 
    onNewValue = function(k)
      if k.target.paramV==1 then k.y,k.h,k.w=9,18,16 else k.y,k.h,k.w=0,0,0 end
      k.parent.isDirty=true
    end })
  
  ToggleButton:new({parent=standardMcpBox, x=58, y=124, w=240, h=20, target=standardMcpShowRouteController }) 
  ToggleButton:new({parent=standardMcpBox, x=58, y=8, flow=true, w=240, h=20, target=standardMcpShowFxController }) 
  ToggleButton:new({parent=standardMcpBox, x=58, y=8, flow=true, w=240, h=20, target=standardMcpShowEnvController })
  ToggleButton:new({parent=standardMcpBox, x=58, y=8, flow=true, w=240, h=20, target=standardMcpShowPhaseController })
  
  El:new({parent=standardMcpBox, x=12, y=290, w=100, h=16, text={str='HIDE SECTIONS', resizeToFit=true, style=2, align=0, col={255,64,95}}, col={255,150,0,0}  })
  El:new({parent=standardMcpBox, flow = true, x=12, y=0, w=100, h=16, text={str='if panel height is below...', resizeToFit=true, style=2, align=0, col=c_Grey70}, col={255,150,0,0}  })
  
  standardMcpHideIn = El:new({parent=standardMcpBox, x=6, y=12, flow=true, w=174, h=20, col={255,100,0,0}, interactive=false })
  standardMcpHideInController = Controller:new({parent=standardMcpHideIn, x=0, y=0, w=6, h=0, paramDesc = 'mcpNormalShowSecIn', units = 'px', desc='Input Section' })
  El:new({parent=standardMcpHideIn, x=6, y=0, w=20, h=20, z=2, shape='evenCircle', col=c_Grey50, interactive = false })
  Knob:new({parent=standardMcpHideIn, target=standardMcpHideInController, x=6, y=0, w=20, h=20, img='knobStack_20px_dark', iFrameH=20, iFrame=20 })
  ccControls:new({parent=standardMcpHideIn, x=32, y=0, target=standardMcpHideInController, spinner=false, readoutColMO={255,51,84}, readoutColMA={153,77,88}, readoutUnitCol={153,77,88} })
  
  standardMcpHidePan = El:new({parent=standardMcpBox, x=6, y=12, flow=true, w=174, h=20, col={255,100,0,0}, interactive=false })
  standardMcpHidePanController = Controller:new({parent=standardMcpHidePan, x=0, y=0, w=6, h=0, paramDesc = 'mcpNormalShowSecPan', units = 'px', desc='Pan Section' })
  El:new({parent=standardMcpHidePan, x=6, y=0, w=20, h=20, z=2, shape='evenCircle', col=c_Grey50, interactive = false })
  Knob:new({parent=standardMcpHidePan, target=standardMcpHidePanController, x=6, y=0, w=20, h=20, img='knobStack_20px_dark', iFrameH=20, iFrame=20 })
  ccControls:new({parent=standardMcpHidePan, x=32, y=0, target=standardMcpHidePanController, spinner=false, readoutColMO={255,51,84}, readoutColMA={153,77,88}, readoutUnitCol={153,77,88} })
  
  
  reducedMcpBox = El:new({parent=mcpWidthsBox, x=0, y=436, w=190, h=170, border=10,  col=c_Grey20 })
  El:new({parent=reducedMcpBox, x=0, y=0, w=190, h=20, col={0,255,150}, text={str='if REDUCED width', style=2, align=4, col={100,0,100}} }) 
  El:new({parent=reducedMcpBox, x=20, y=0, w=170, h=20, shape='poly', coords={{127,0}, {170,0}, {170,19}, {108,19} }, interactive=false, col={255,120,0} })  
  El:new({parent=reducedMcpBox, x=20, y=0, w=170, h=20, shape='poly', coords={{153,0}, {170,0}, {170,19}, {134,19} }, interactive=false, col={0,120,255} }) 
  
  El:new({parent=reducedMcpBox, x=12, y=30, w=100, h=16, text={str='HIDE SECTIONS', resizeToFit=true, style=2, align=0, col={255,64,95}}, col={255,150,0,0}  })
  El:new({parent=reducedMcpBox, flow = true, x=12, y=0, w=100, h=16, text={str='if panel height is below...', resizeToFit=true, style=2, align=0, col=c_Grey70}, col={255,150,0,0}  })
  
  reducedMcpHideIn = El:new({parent=reducedMcpBox, x=6, y=12, flow=true, w=174, h=20, col={255,100,0,0}, interactive=false })
  reducedMcpHideInController = Controller:new({parent=reducedMcpHideIn, x=0, y=0, w=6, h=0, paramDesc = 'mcpInterShowSecIn', units = 'px', desc='Input Section' })
  El:new({parent=reducedMcpHideIn, x=6, y=0, w=20, h=20, z=2, shape='evenCircle', col=c_Grey50, interactive = false })
  Knob:new({parent=reducedMcpHideIn, target=reducedMcpHideInController, x=6, y=0, w=20, h=20, img='knobStack_20px_dark', iFrameH=20, iFrame=20 })
  ccControls:new({parent=reducedMcpHideIn, x=32, y=0, target=reducedMcpHideInController, spinner=false, readoutColMO={255,51,84}, readoutColMA={153,77,88}, readoutUnitCol={153,77,88} })
  
  reducedMcpHideButtons = El:new({parent=reducedMcpBox, x=6, y=12, flow=true, w=174, h=20, col={255,100,0,0}, interactive=false })
  reducedMcpHideButtonsController = Controller:new({parent=reducedMcpHideButtons, x=0, y=0, w=6, h=0, paramDesc = 'mcpInterShowSecButtons', units = 'px', desc='Button Section' })
  El:new({parent=reducedMcpHideButtons, x=6, y=0, w=20, h=20, z=2, shape='evenCircle', col=c_Grey50, interactive = false })
  Knob:new({parent=reducedMcpHideButtons, target=reducedMcpHideButtonsController, x=6, y=0, w=20, h=20, img='knobStack_20px_dark', iFrameH=20, iFrame=20 })
  ccControls:new({parent=reducedMcpHideButtons, x=32, y=0, target=reducedMcpHideButtonsController, spinner=false, readoutColMO={255,51,84}, readoutColMA={153,77,88}, readoutUnitCol={153,77,88} })
  
  reducedMcpHidePan = El:new({parent=reducedMcpBox, x=6, y=12, flow=true, w=174, h=20, col={255,100,0,0}, interactive=false })
  reducedMcpHidePanController = Controller:new({parent=reducedMcpHidePan, x=0, y=0, w=6, h=0, paramDesc = 'mcpInterShowSecPan', units = 'px', desc='Pan Section' })
  El:new({parent=reducedMcpHidePan, x=6, y=0, w=20, h=20, z=2, shape='evenCircle', col=c_Grey50, interactive = false })
  Knob:new({parent=reducedMcpHidePan, target=reducedMcpHidePanController, x=6, y=0, w=20, h=20, img='knobStack_20px_dark', iFrameH=20, iFrame=20 })
  ccControls:new({parent=reducedMcpHidePan, x=32, y=0, target=reducedMcpHidePanController, spinner=false, readoutColMO={255,51,84}, readoutColMA={153,77,88}, readoutUnitCol={153,77,88} })
  

  mcpStripBox = El:new({parent=mcpWidthsBox, x=210, y=36, w=190, h=762, col=c_Grey20 }) 
  El:new({parent=mcpStripBox, x=0, y=0, w=190, h=20, col={255,255,120}, text={str='if STRIP width', style=2, align=4, col={100,100,0}} })  
  El:new({parent=mcpStripBox, x=20, y=0, w=70, h=20, shape='poly', coords={{127,0}, {170,0}, {170,19}, {108,19} }, interactive=false, col={255,120,0} })  
  El:new({parent=mcpStripBox, x=20, y=0, w=70, h=20, shape='poly', coords={{153,0}, {170,0}, {170,19}, {134,19} }, interactive=false, col={0,120,255} })
  
  El:new({parent=mcpStripBox, flow = true, x=0, y=10, w=190, h=26, text={str='Drag elements to reorder them', style=2, align=1, col=c_Grey70  }  })
  mcpStripHideExtmController = Controller:new({parent=mcpStripBox, x=0, y=0, w=0, h=0, paramDesc = 'Hide non-sidebar ExtMixer' })
  Button:new({parent=mcpStripBox, x=12, y=0, flow=true, style='button', target=mcpStripHideExtmController, img='button_upArrow_off', imgOn='button_upArrow_on', iFlip=true, iType=3 })
  Label:new({parent=mcpStripBox, x=6, y=8, w=130, h=20, flow=true, target=mcpStripHideExtmController,
    text={str='Hide the extmixer unless its in a sidebar', style=2, align=0, col={255,255,255,106}, padding=0, wrap=true, lineSpacing=12, col=labelColMA, mouseOverCol=labelColMO } })
  
  mcpStripOrderBox=MiscAgent:new({parent=mcpStripBox, target=mcpBgController, flow=true, x=10, y=6, z=2, w=28, h=656, col= c_CyanGrey, interactive = false,
    onNewValue = function(k)
      k.col = mcpBgController.paramV
      if #projectCustCols>0 and mcpBgController.paramV and k.target.paramV then 
        local tmp, tmp, value  = reaper.ThemeLayout_GetParameter(paramIdxGet('Custom Color Strength'))
        k.col = compositeCols(k.target.paramV, egCustomColor, value/100)
      end
      k.parent.isDirty=true
    end
    })
  stripEnvH = stripEnvH or 32
  stripVolH = stripVolH or 80
  stripMeterH = stripMeterH or 40
  local stripYMargin = 6
  mcpStripOrderControl = El:new({parent=mcpStripOrderBox, x=0, y=0, w=28, h=656, dragNDropCursor = 'env_pt_updown',
    onValueEdited = function(k)
      local p1 = paramIdxGet('MCP Strip flow location 1')
      if p1>0 and k.paramV ~= nil then
        -- else we're here because a button was pressed. Send all the values to Reaper.
        for i=1, 11 do -- iterate flow elements
          paramSet(p1 -1 +i, k.paramV[i])
        end
      end
    end,
    onUpdate = function(k)
  
      local p1 = paramIdxGet('MCP Strip flow location 1')
      
      if p1==-1 then -- param error
        k.text = {str='E R R O R', wrap=true, style=4, lineSpacing=14, align=5, col={0,0,0}}
        k.col={255,0,0}
        k.paramError = true
      end
      
      if p1>0 then
      
        if k.paramV == nil then -- first time populate paramV table with values from Reaper
          k.paramV = {}
          for i=1, 11 do -- iterate flow elements
            local tmp, tmp, value = reaper.ThemeLayout_GetParameter(p1 -1 +i)
            --reaper.ShowConsoleMsg('element '..i..' is at location '..value..' \n')
            k.paramV[i] = value
          end
        end
        
        local heights = {90, stripVolH, 42, stripEnvH, 38, 52, 42, 80, stripEnvH, 18, stripMeterH}
        local names = {'labelBlock','volumeBlock','MSBlock','io','FxBlock','PanBlock','recmode','inputBlock','env','phase', 'meter'} --only used in console
        local hasDarkBg = {1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1}
        
        for i=1, 11 do -- iterate my children 1-11, the position proxies, and fix their heights and y-positions
          local thisYMargin = stripYMargin
          k.children[i].h = heights[k.paramV[i]]
          if i==1 then k.children[1].y = k.h - k.children[i].h - thisYMargin end
          if hasDarkBg[k.paramV[i]]~=hasDarkBg[k.paramV[i-1]] then thisYMargin = thisYMargin * 2 end -- double margins for dark/light bg transitions
          if i>1 then k.children[i].y= k.children[i-1].y - k.children[i].h - thisYMargin end -- y-position this proxy
          if showDropHelpers == true then k.children[i].col = {math.random(255),math.random(255),math.random(255),100} end
        end
        
        for i=1, 11 do -- iterate my children 11-20, the display elements, positioning each to the appropriate proxy
          k.children[k.paramV[i]+11].y = k.children[i].y 
          k.children[k.paramV[i]+11].h = k.children[k.paramV[i]+11].h 
          addNeedUpdate(k.children[i+10], true)
        end
        
        for i=0, 11 do -- iterate my DropTarget children, y-positioning them
          if i>0 then k.DropTargets[i].y = k.children[i].y + (0.5 * k.children[i].h) - 10 end
        end
        
      end
    end
  })
  
  stripBox = El:new({parent=mcpStripBox, x=10, y=0, w=140, h=280, flow=true, border=0, col=c_Grey20 })
  
  stripMeterHeightController = Controller:new({parent=stripBox, x=0, y=0, w=6, h=0, paramDesc = 'Meter Height', units = 'px', desc='Meter Height' 
      --[[, onNewValue = function(k)
      --reaper.ShowConsoleMsg(k.paramV..'\n')
      stripMeterH = k.paramV+(2*stripYMargin)
      mcpStripMeterBlock.children[1].h = stripMeterH+(2*stripYMargin)
      mcpStripMeterBlock.children[2].h = stripMeterH - 20
      mcpStripMeterBlock.children[3].h = stripMeterH - 13
      addNeedUpdate(mcpStripOrderControl, true)
    end ]] -- code for resizing meter
    })
  stripVolHeightController = Controller:new({parent=stripBox, x=0, y=0, w=6, h=0, paramDesc = 'Volume Height', units = 'px', desc='Volume Height', valueAlias = {[60] = 'Knob'},
    onNewValue = function(k)
      --reaper.ShowConsoleMsg(k.paramV..'\n')
      --stripVolH = k.paramV+(2*stripYMargin)
      stripVolH = 60+(2*stripYMargin)
      mcpStripVolumeBlock.children[1].h = stripVolH+2*stripYMargin
      mcpStripVolumeBlock.children[2].w, mcpStripVolumeBlock.children[2].h = 2, stripVolH - 18
      mcpStripVolumeBlock.children[3].img, mcpStripVolumeBlock.children[3].imgIdx = 'mcp_volthumb', nil
      mcpStripVolumeBlock.children[3].x, mcpStripVolumeBlock.children[3].y, mcpStripVolumeBlock.children[3].w, mcpStripVolumeBlock.children[3].h = 2,10,23,53
      if k.paramV==60 then -- turn into a knob
        stripVolH = 20+(2*stripYMargin) 
        mcpStripVolumeBlock.children[1].h = 26+(2*stripYMargin)
        mcpStripVolumeBlock.children[2].w = 0
        mcpStripVolumeBlock.children[3].img, mcpStripVolumeBlock.children[3].imgIdx = 'tcp_vol', nil
        mcpStripVolumeBlock.children[3].x, mcpStripVolumeBlock.children[3].y, mcpStripVolumeBlock.children[3].w, mcpStripVolumeBlock.children[3].h = 2,2,24,24
      end 
      addNeedUpdate(mcpStripOrderControl, true)
    end
    })
  stripInHeightController = Controller:new({parent=stripBox, x=0, y=0, w=6, h=0, paramDesc = 'Record Input Height', units = 'px', desc='Input Height' })
  stripLabelHeightController = Controller:new({parent=stripBox, x=0, y=0, w=6, h=0, paramDesc = 'Label Height', units = 'px', desc='Label Height' })
  
  
  -- 11 position proxies for 11 slots
  El:new({parent=mcpStripOrderControl, x=0, y=0, w=28, h=20})
  for i=2,11 do El:new({parent=mcpStripOrderControl, x=0, y=0, w=28, h=20 })  end
  
  mcpStripLabelBlock = DragNDrop:new({parent=mcpStripOrderControl, x=0, y=0, w=28, h=90, flow=false, param=1 })
    El:new({parent=mcpStripLabelBlock, x=0, y=-1*stripYMargin, w=28, h=90+2*stripYMargin, col={38,38,38}, interactive=false })
    El:new({parent=mcpStripLabelBlock, x=4, y=38 + stripYMargin, w=20, h=20, img='mcp_recmon', interactive=false })
    El:new({parent=mcpStripLabelBlock, x=2, y=62 + stripYMargin, w=24, h=24, img='tcp_recarm', interactive=false })
  mcpStripVolumeBlock = DragNDrop:new({parent=mcpStripOrderControl, x=0, y=0, w=28, h=80, flow=false, param=2 })
    El:new({parent=mcpStripVolumeBlock, x=0, y=-1*stripYMargin, w=28, h=stripVolH+2*stripYMargin, col={38,38,38}, interactive=false })
    El:new({parent=mcpStripVolumeBlock, x=13, y=6, w=2, h=68, col={0,0,0}, interactive=false })
    El:new({parent=mcpStripVolumeBlock, x=2, y=10, w=23, h=53, img='mcp_volthumb', interactive=false }) 
  DragNDrop:new({parent=mcpStripOrderControl, x=4, y=0, w=20, h=42, flow=false, param=3, img='mcp_mutesolo' })
  mcpIo = DragNDrop:new({parent=mcpStripOrderControl, x=3, y=0, w=22, h=stripEnvH, flow=false, img='mcp_io', iType=1, param=4 })
  DragNDrop:new({parent=mcpStripOrderControl, x=4, y=0, w=20, h=38, flow=false, param=5, img='mcp_fx' })
  mcpStripPanBlock = DragNDrop:new({parent=mcpStripOrderControl, x=0, y=0, w=28, h=52, flow=false, param=6 })
    El:new({parent=mcpStripPanBlock, x=0, y=-1*stripYMargin, w=28, h=52+2*stripYMargin, col={38,38,38}, interactive=false })
    El:new({parent=mcpStripPanBlock, x=4, y=0, w=20, h=52, flow=false, img='mcpstrip_panwidth', interactive=false })
  mcpStripRecmodeBlock = DragNDrop:new({parent=mcpStripOrderControl, x=0, y=0, w=28, h=42, flow=false, param=7, col={150,0,150,0} })
    El:new({parent=mcpStripRecmodeBlock, x=4, y=0, w=20, h=42, img='mcpstrip_input', iType=1, interactive=false })
    El:new({parent=mcpStripRecmodeBlock, x=8, y=6, w=10, h=8, img='input_v', iType=1, interactive=false })
  mcpStripInputBlock = DragNDrop:new({parent=mcpStripOrderControl, x=0, y=0, w=28, h=80, flow=false, param=8, col={0,150,150,0} })
    El:new({parent=mcpStripInputBlock, x=4, y=0, w=20, h=22, img='tcp_infx', interactive=false })
    El:new({parent=mcpStripInputBlock, x=4, y=20, w=20, h=60, img='mcpstrip_input', iType=1, interactive=false })
    El:new({parent=mcpStripInputBlock, x=8, y=26, w=10, h=22, img='input_v', iType=1, interactive=false })
  mcpEnv = DragNDrop:new({parent=mcpStripOrderControl, x=3, y=0, w=22, h=stripEnvH, flow=false, img='mcp_env', iType=1, param=9 })
  DragNDrop:new({parent=mcpStripOrderControl, x=6, y=0, w=16, h=18, flow=false, img='mcp_phase', param=10 })
  mcpStripMeterBlock = DragNDrop:new({parent=mcpStripOrderControl, x=0, y=0, w=28, h=80, flow=false, param=11 })
    El:new({parent=mcpStripMeterBlock, x=0, y=-1*stripYMargin, w=28, h=40+2*stripYMargin, col={38,38,38}, interactive=false })
    El:new({parent=mcpStripMeterBlock, x=3, y=21, w=9, h=20, interactive=false, col=c_GreenLit })
    El:new({parent=mcpStripMeterBlock, x=14, y=14, w=9, h=27, interactive=false, col=c_GreenLit })
  
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={0}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={1}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={2}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={3}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={4}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={5}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={6}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={7}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={8}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={9}})
  DropTarget:new({parent=mcpStripOrderControl, x=2, w=24, param={10}})
  
  Stalk:new({parent=mcpStripMeterBlock, target=stripMeterHeightController, x=28, y=-4, w=130, h=42  }) 
  Stalk:new({parent=mcpStripInputBlock, target=stripInHeightController, x=28, y=16, w=130, h=42 }) 
  Stalk:new({parent=mcpStripVolumeBlock, target=stripVolHeightController, x=28, y=-12, w=130, h=42 }) 
  Stalk:new({parent=mcpStripLabelBlock, target=stripLabelHeightController, x=28, y=0, w=130, h=42 })  
  
  
  mixerPrefsBox = El:new({parent=bodyBox, x=0, y=0, w=320, h=160, tile=true, col=c_Grey20 })    
  TitleBar:new({parent= mixerPrefsBox, x=0, y=0, layouts='none', text={str='Mixer Preferences'} }) 
  El:new({parent= mixerPrefsBox, x=10, y=10, w=-10, r={toEdge,  mixerPrefsBox, 'right'}, h=26, flow=true, 
    text={str='These preferences are duplicated from the master mixer menu and mixer right-click menu.', wrap=true, style=2, align=5, col=c_Grey50}, interactive = false }) 
  ToggleButton:new({parent=mixerPrefsBox, x=6, y=6, w=300, h=20, flow=true, controlType='reaperActionToggle', param=41154, desc='Clickable icon for folder tracks to hide children' }) 
  ToggleButton:new({parent=mixerPrefsBox, x=6, y=0, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40371, desc='Show multiple rows of tracks when size permits' }) 
  ToggleButton:new({parent=mixerPrefsBox, x=6, y=0, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40372, desc='Show maximum rows even when fewer would fit' }) 
  
  
  mcpMasterBox = El:new({parent=bodyBox, x=0, y=0, w=440, h=240, tile=true, col=c_Grey20 })
  masterMcpBgController = Controller:new({parent=mcpMasterBox, x=0, y=0, w=6, h=0, style='colour', paramDesc = 'Master MCP background colour', labelStr = 'Background Color' }) 
  TitleBar:new({parent=mcpMasterBox, x=0, y=0, text={str='Master Mixer'}, layouts='none' }) 
  ColourChooseAgent:new({parent=mcpMasterBox, x=12, y=18, w=196, h=50, flow=true, style='colour', col=c_Grey20, target=masterMcpBgController})
  
  mcpMasterWidth = El:new({parent= mcpMasterBox, x=6, y=20, w=440, h=26, flow=true, col={255,100,0,0}, interactive=false })
  mcpMasterWidthController = Controller:new({parent=mcpMasterWidth, target=mcpConditionTallyController, x=0, y=0, w=6, h=0, paramDesc = 'Master Mixer Panel Width', units = 'px', desc='Panel Width'  })
  TapeMeasure:new({parent=mcpMasterWidth, target=mcpMasterWidthController, x=12, y=0,  tape={}, w=0, h=20,  r={toEdge, mcpMasterWidth, 'right'}, interactive = false })  
  ccControls:new({parent=mcpMasterWidth, x=42, y=6, target=mcpMasterWidthController })
  
  ToggleButton:new({parent=mcpMasterBox, x=6, y=6, w=300, h=20, flow=true, paramDesc = 'Master MCP Values', desc='Show Values' }) 
  ToggleButton:new({parent=mcpMasterBox, x=6, y=0, w=300, h=20, flow=true, paramDesc = 'Master MCP Labels', desc='Show Labels' }) 
  ToggleButton:new({parent=mcpMasterBox, x=6, y=0, w=300, h=20, flow=true, paramDesc = 'Master MCP Meter Values', desc='Show Meter Values' })  
   
  ---------------------------------------------------
  -------------------- TRANSPORT --------------------
  --------------------------------------------------- 
   
  belongsToPage = 'Transport'
  
  transBox = El:new({parent=bodyBox, x=0, y=0, w=732, h=370, tile=true, col=c_Grey25 }) 
  TitleBar:new({parent=transBox, x=0, y=0, layouts='none', text={str='Transport Sizes'} })
  transBgController = Controller:new({parent=bodyBox, x=0, y=0, w=0, h=0, style='colour', paramDesc = 'Transport background colour', labelStr = 'Background Color' }) 
  transStatusBgController = Controller:new({parent=bodyBox, x=0, y=0, w=0, h=0, style='colour', paramDesc = 'Transport status colour', labelStr = 'Status Display Color' }) 
  
  transMarginController = Controller:new({parent=transBox, x=0, y=0, w=0, h=0, flow=true, paramDesc='Transport Margins', desc = 'Transport Margins', units = 'px', valueAlias = {[0] = 'None'}  })
  ccControls:new({parent=transBox, x=16, y=10, h=18, flow=true, target=transMarginController })

  rateController = Controller:new({parent=transBox, x=0, y=0, w=0, h=0, paramDesc='Rate Width', desc = 'Rate Control Length', units = 'px', valueAlias = {[100] = 'Knob'}  })
  transRateDiag = MiscAgent:new({parent=transBox, target=rateController, x=16, y=10, w=700, h=36, flow=true, interactive = false,
    onNewValue = function(k)
      k.children[1].w,  k.children[3].w,  k.children[4].w, k.children[5].w, k.children[6].w = k.target.paramV, k.target.paramV-16, 20, 0, 0
      k.children[2].x, k.children[2].y, k.children[2].w, k.children[2].h, k.children[2].text.align = 0, 2, k.target.paramV, 26, 3
      k.children[4].x = k.target.paramV * 0.5 -6
      if k.target.paramV==100 then
        k.children[1].w, k.children[2].w, k.children[3].w, k.children[4].w, k.children[5].w, k.children[6].w = 0,40,0,0,32,1
        k.children[2].x, k.children[2].y, k.children[2].w, k.children[2].h, k.children[2].text.align = 50, 0, 36, 36, 5
      end
      k.isDirty=true
    end
    })
    El:new({parent=transRateDiag, x=0, y=0, w=100, h=36, img='transSectionBg', iType=1, interactive = false })
    El:new({parent=transRateDiag, x=0, y=2, w=100, h=26, text={str='Rate: 1.0', wrap=true, padding=0, lineSpacing = 16, style=2, align=3, col=c_Grey60} }) 
    El:new({parent=transRateDiag, x=8, y=24, w=84, h=4, col=c_Grey20, shape='capsule', interactive = false })
    El:new({parent=transRateDiag, x=40, y=12, w=20, h=28, img='slider_nonInteractive', iType=1, interactive = false })
    El:new({parent=transRateDiag, x=4, y=2, w=32, h=32, col=c_Grey15, shape='evenCircle', interactive = false })
    El:new({parent=transRateDiag, x=20, y=4, w=1, h=12, col=c_Grey70, interactive = false })
  TapeMeasure:new({parent=transBox, target=rateController, x=16, y=10, flow=true, tape={zeroAtV=100}, w=100, h=20, interactive=false, 
    onNewValue = function(k)
      k.w = k.target.paramV
      k.isDirty,doArrange=true,true
    end })
  ccControls:new({parent=transBox, x=46, y=-12, flow=true,  target=rateController })
  
  
  transStatusController = Controller:new({parent=transBox, x=0, y=0, w=0, h=0, paramDesc='Status Width', desc = 'Status Display Width', units = 'px'  })
  transStatusDiag = MiscAgent:new({parent=transBox, target= transStatusController, alsoAgentOf={transStatusBgController}, x=16, y=30, w=700, h=36, flow=true, interactive = false,
    onNewValue = function(k)
      if k.target.paramV then
        k.children[1].w = k.target.paramV
        k.children[1].col = transStatusBgController.paramV
        k.children[2].w = k.target.paramV
        k.children[3].x = k.target.paramV - 90
        k.isDirty=true
        doArrange = true
      end
    end
    })
    El:new({parent=transStatusDiag, x=0, y=0, w=100, h=36, col=c_Grey20, interactive = false })
    El:new({parent=transStatusDiag, x=0, y=0, w=100, h=36, text={str='00:00:00:00', padding=10, lineSpacing = 16, style=4, align=4, col=c_Grey66} }) 
    El:new({parent=transStatusDiag, x=0, y=0, w=90, h=36, text={str='[Stopped]', padding=10, style=3, align=6, col=c_Grey66} }) 
  TapeMeasure:new({parent=transBox, target=transStatusController, x=16, y=10, flow=true, tape={zeroAtV=100}, w=100, h=20, interactive=false, 
    onNewValue = function(k)
      k.w = k.target.paramV
      k.isDirty,doArrange=true,true
    end })
  ccControls:new({parent=transBox, x=46, y=-12, flow=true,  target=transStatusController })
  
  
  selectionFontController = Controller:new({parent=transBox, x=0, y=0, w=6, h=0, flow=true, paramDesc = 'Selection Font Size', units = '', desc='Selection Font Size' })
  fontControl:new({parent=transBox, target=selectionFontController, x=18, y=256, w=480, h=22 })
  
  transSelController = Controller:new({parent=transBox, x=0, y=0, w=0, h=0, paramDesc='Selection Width', desc = 'Selection DIsplay Width', units = 'px'  })
  transSelDiag = MiscAgent:new({parent=transBox, target= transSelController, alsoAgentOf={selectionFontController}, x=16, y=10, w=700, h=36, flow=true, interactive = false,
    onNewValue = function(k)
      k.children[1].w = k.target.paramV
      k.isDirty=true
    end
    })
    El:new({parent=transSelDiag, x=0, y=0, w=100, h=36, img='transSectionBg', iType=1, interactive = false })
    El:new({parent=transSelDiag, x=0, y=0, w=100, h=36, text={str='Selection', wrap=true, padding=10, lineSpacing = 16, style=2, align=4, col=c_Grey60} }) 
  TapeMeasure:new({parent=transBox, target=transSelController, x=16, y=10, flow=true, tape={zeroAtV=100}, w=100, h=20, interactive=false, 
    onNewValue = function(k)
      k.w = k.target.paramV
      k.isDirty,doArrange=true,true
    end })
  ccControls:new({parent=transBox, x=46, y=-12, flow=true,  target=transSelController })
  
  
  transColsBox = El:new({parent=bodyBox, x=0, y=0, w=220, h=196, tile=true, col=c_Grey20 })
  TitleBar:new({parent=transColsBox, x=0, y=0, text={str='Transport Colors'}, layouts='none' }) 
  ColourChooseAgent:new({parent=transColsBox, x=12, y=20, w=196, h=50, flow=true, style='colour', col=c_Grey20, target=transBgController})
  ColourChooseAgent:new({parent=transColsBox, x=12, y=26, w=196, h=50, flow=true, style='colour', col=c_Grey20, target=transStatusBgController})
   
  transPrefsBox = El:new({parent=bodyBox, x=0, y=0, w=200, h=224, tile=true, col=c_Grey20 })    
  TitleBar:new({parent=transPrefsBox, x=0, y=0, layouts='none', text={str='Transport Preferences'} }) 
  El:new({parent=transPrefsBox, x=10, y=10, w=-10, r={toEdge, transPrefsBox, 'right'}, h=26, flow=true, 
    text={str='These preferences are duplicated from the transport right-click menus.', wrap=true, style=2, align=5, col=c_Grey50}, interactive = false }) 
  ToggleButton:new({parent=transPrefsBox, x=6, y=20, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40531, desc='Show playrate control' }) 
  ToggleButton:new({parent=transPrefsBox, x=6, y=0, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40533, desc='Center transport controls' }) 
  ToggleButton:new({parent=transPrefsBox, x=6, y=0, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40680, desc='Show time signature' }) 
  ToggleButton:new({parent=transPrefsBox, x=6, y=0, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40868, desc='Use Previous/Next' }) 
  ToggleButton:new({parent=transPrefsBox, x=6, y=0, w=300, h=20, flow=true, controlType='reaperActionToggle', param=40532, desc='Show play state as text' })         
  
  ---------------------------------------------------
  --------------------- ERRORS ----------------------
  --------------------------------------------------- 
          
  belongsToPage = 'Errors' 
  
  errorsBox = El:new({parent=bodyBox, x=0, y=0, w=800, h=0, border=boxBorder,
    onUpdate = function(k)
      if errorLog == nil then 
        errorsBox:purge() 
        errorPageButton:purge()
        if activePage=='Errors' then activePage = 'Global' end
        doArrange = true
      else
        if errorsBox.children==nil and errorsBox.hidden~=true then 
          local gradeCols = {none={{50,50,50},{190,190,190}}, amber={{50,44,38},{255,190,120}}, red={{50,38,38},{255,120,120}} }
          for g,h in pairs(errorLog) do
            for i,v in ipairs(h) do
              El:new({parent=errorsBox, x=0, y=2, w=0, r={toEdge, errorsBox, 'right'}, belongsToPage = 'Errors', flow=true, h=18, col=gradeCols[g][1], text={str=v, style=2, align=4, col=gradeCols[g][2]} }) 
              errorsBox.h = errorsBox.h + 20
            end
          end
        end
      end
    end
    }) 
    
    
   ---------------------------------------------------
   --------------------- GENERIC ---------------------
   ---------------------------------------------------      
         
  belongsToPage = 'Generic'  
  
  if reaper.ThemeLayout_GetParameter(0) == nil then
    noParamsBox = El:new({parent=bodyBox,x=0, y=0, w=500, h=60, border=boxBorder,  col=c_Grey10, text = {str='', style=3, align=5, col=c_Grey50},
      onArrange = function(k)
        k.text.str = "\'"..themeTitle.."\' doesn't define any parameters for script control"
      end
      })
    
  else
    
    El:new({parent=bodyBox, x=6, y=6, z=2, w=0, h=36, r={toEdge, bodyBox, 'right'}, interactive = false, text={str='', style=4, align=4, col=c_Grey70},
      onArrange = function(k)
        k.text.str = themeTitle
      end
      })
    local i=0
    while reaper.ThemeLayout_GetParameter(i) ~= nil do
      local tmp,description = reaper.ThemeLayout_GetParameter(i)
      
      if description then
        local entry = El:new({parent=bodyBox, flow = true, x=6, w=350, y=0, h=26, text={str='', style=2, align=4, col=c_Grey70  }  })
        local entryController = Controller:new({parent=entry, x=0, y=0, w=0, h=0, desc=description, param=i })
        
        if entryController.paramVMin==0 and entryController.paramVMax==0 then
          local stylingVals = {c_Grey50, c_Grey10}
          if entryController.paramVDef==0 then 
            El:new({parent=entry, x=2, y=0, z=2, w=348, h=20, col=c_Grey15, text={str=entryController.desc, style=2, padding=0, align=4, col=c_Grey70} }) 
          else El:new({parent=entry, x=2, y=0, z=2, w=348, h=20, col=c_Grey50, text={str=entryController.desc, style=2, align=4, col=c_Grey10} }) 
          end
          
        else
        if entryController.paramVMin==0 and entryController.paramVMax==1 then
            Button:new({parent=entry, x=0, y=0, flow=true, style='button', target=entryController, img='button_off', imgOn='button_on', iType=3 })
          else
            El:new({parent=entry, x=2, y=2, w=20, h=20, z=2, shape='evenCircle', col=c_Grey50, interactive = false })
            Knob:new({parent=entry, target=entryController, x=2, y=2, w=20, h=20, img='knobStack_20px_dark', iFrameH=20, iFrame=20 })
          end
          Label:new({parent=entry, flow=true, x=6, y=2, z=2, w=60, h=20, target=entryController, 
            text={str=entryController.desc, style=2, align=0, padding=0, resizeToFit=true, col=c_Grey70, mouseOverCol=c_Grey80 } })    
          if (entryController.paramVMin==0 and entryController.paramVMax==1)==false then
            SpinnerH:new({parent=entry, x=4, y=-4, z=2, h=20, w=36, col={0,100,100,0}, flow=true, target=entryController}) 
            Readout:new({parent=entry, x=6, y=0, z=2, w=60, h=20, flow=true, target=entryController, 
              text={str='0.00', style=4, align=0, col={0,204,136,255}, padding=0, resizeToFit=true}  }) 
          end
        end
        
      end
      i = i+1
    end
    
    genResetBox = El:new({parent=bodyBox, x=0, y=6, w=0, h=32, r={toEdge, bodyBox, 'right'}, flow=true, interactive = false  })
    Button:new({parent=genResetBox, x=4, y=0, style='button', target=paramsResetController, img='bin', iType=3 })
    Label:new({parent=genResetBox, flow=true, x=4, y=8, w=60, h=20, target=paramsResetController, 
      text={str='Reset all theme parameters to default values', style=2, align=0, padding=0, resizeToFit=true, col=labelColMA, mouseOverCol=labelColMO },
      onClick=function(k) k.target:onClick() end })
    
  end
 
    
    
  belongsToPage = nil 
  DragWagon = El:new({block=2, z=2, x=0, y=0,  w=30, h=30, interactive=false })

end    

  

  
  

  --------- RUNLOOP ----------

gfx.clear = -1
activeLayout = 'A'
fps = 1
lastchgidx = 0
mouseXold = 0
mouseYold = 0
mouseWheelAccum = 0
trackCountOld = 0
dirtyZone ={}
gfxWold, gfxHold = gfx.w, gfx.h
bufferPinkValues ={}
ThemeLayout_RefreshAll = false
updateAnyNotHidden=true
getProjectCustCols()
--showDropHelpers = true

Populate()


function runloop()

  --[[if (skipcnt or 0) < 10 then skipcnt = (skipcnt or 0) + 1  reaper.runloop(runloop) return; end
    skipcnt = 0]]

  c=gfx.getchar()
  themeCheck()
 
  -- mouse stuff
  local isCap = (gfx.mouse_cap&1)
  
  if gfx.mouse_x ~= mouseXold or gfx.mouse_y ~= mouseYold or (firstClick ~= nil and last_click_time ~= nil and last_click_time+.25 < nowTime) then
    firstClick = nil
  end
  
  if gfx.mouse_x ~= mouseXold or gfx.mouse_y ~= mouseYold or isCap ~= mouseCapOld or gfx.mouse_wheel ~= 0 then
  
    local wheel_amt = 0
    if gfx.mouse_wheel ~= 0 then
      mouseWheelAccum = mouseWheelAccum + gfx.mouse_wheel
      gfx.mouse_wheel = 0
      wheel_amt = math.floor(mouseWheelAccum / 120 + 0.5)
      if wheel_amt ~= 0 then mouseWheelAccum = 0 end
    end
    
    local hit = nil
    
    for b in ipairs(els) do -- iterate blocks
      local thisBlockX = els[b].drawX or els[b].x
      local scrollXOffs = els[b].scrollX or 0
      local scrollYOffs = els[b].scrollY or 0
      for z = #els[b],1,-1 do -- iterate z backwards
        
        if els[b][z] ~= nil then
          for j,k in pairs(els[b][z]) do
            local x, y, w, h = (k.drawX or k.x or 0) + thisBlockX, k.drawY or k.y or 0, k.drawW or k.w or 0, k.drawH or k.h or 0
            if k.interactive ~= false and k.hidden ~= true and (gfx.mouse_x-scrollXOffs) > x and
                (gfx.mouse_x-scrollXOffs) < x+w and (gfx.mouse_y+scrollYOffs) > y and (gfx.mouse_y+scrollYOffs) < y+h ~= false then
              hit = k
            end
          end
        end

        if hit~=nil then break end
      end
      
    end
    
    if isCap == 0 or mouseCapOld == 0 then
      if activeMouseElement ~= nil and activeMouseElement ~= hit then
        activeMouseElement:mouseAway()
        singleClick = nil
        toolTipTimer = nil
      end
      activeMouseElement = hit
    end
    
    if isCap == 0 and mouseCapOld == 1 then -- mouse-up, reset stuff
      dragStart, singleClick = nil, nil
      if activeMouseElement then activeMouseElement:mouseUp() end
    end
    
    if activeMouseElement ~= nil then
      if isCap == 0 or mouseCapOld == 0 then
        activeMouseElement:mouseOver()
        activeMouseElement:showTooltip()
      end
      if wheel_amt ~= 0 then       
        activeMouseElement:mouseWheel(wheel_amt)
      end
       
      if isCap == 1 then -- mouse down
        activeMouseElement:mouseDown()
         
         local x,y = gfx.mouse_x,gfx.mouse_y
         if firstClick == nil or last_click_time == nil then 
           firstClick = {gfx.mouse_x,gfx.mouse_y}
           last_click_time = nowTime
         else if nowTime < last_click_time+.25 and math.abs((x-firstClick[1])*(x-firstClick[1]) + (y- firstClick[2])*(y- firstClick[2])) < 4 then 
           activeMouseElement:doubleClick() 
           firstClick = nil
           else
             firstClick = nil
           end 
         end
         
      end
    end
    
    mouseXold, mouseYold, mouseCapOld = gfx.mouse_x, gfx.mouse_y, isCap
  end
  
 
  -- changes every FPS
  nowTime = reaper.time_precise()
  if (nextTime == nil or nowTime > nextTime) then -- do onFrame updates
    for i,k in pairs(needing_fps) do
      if k.hidden ~= true then
        k:onFps()
      end
    end
    nextTime = nowTime + (1/fps)
  end
  
  -- changes because an Update flag is set
  if next(needing_updates) then
    local tmp = needing_updates
    needing_updates = { }
    for k,f in pairs(tmp) do
      if k.hidden ~= true then
         k:onUpdate()
      end
    end
  end
  
  
  -- changes because a Timer is running
  if Timers then
    for j,k in pairs(Timers) do --iterate Timers
      if nowTime > k.Timers[j] then -- Timer has expired
        k.onTimerComplete[j]()
        removeTimer(k,j)
      end
    end
  end
  
  
  -- changes from Reaper
  chgidx = reaper.GetProjectStateChangeCount(0)
  if chgidx ~= lastchgidx or doReaperGet == true then
    for b in ipairs(els) do -- iterate blocks
      for z in ipairs(els[b]) do -- iterate z
        if els[z] ~= nil then
          for j,k in pairs(els[b][z]) do

            if k.onReaperChange and k.hidden ~= true then
              k:onReaperChange()
            end
            
          end
        end
      end
      doArrange = true
    end
    
    getProjectCustCols()
    lastchgidx = chgidx
    doReaperGet = false
     
  end
 
  -- change in window size
  if gfxWold ~= gfx.w or gfxHold ~= gfx.h then
    doOnGfxResize()
    gfxWold, gfxHold = gfx.w, gfx.h
  end
  
  
  -- change in screen DPI
  if gfx.ext_retina ~= ext_retinaOld or ext_retinaOld == nil then
    local nScale = 1
    if gfx.ext_retina > 1.33 then nScale = 1.5 end
    if gfx.ext_retina > 1.66 then nScale = 2 end
    setScale(nScale)
    ext_retinaOld = gfx.ext_retina
    
    for b in ipairs(els) do -- iterate blocks
      for z in ipairs(els[b]) do -- iterate z
        if els[b][z] ~= nil then
          for j,k in pairs(els[b][z]) do -- iterate elements
            if k.onDpiChange and k.w ~= 0 and k.hidden ~= true then
              k.onDpiChange(k)
              doArrange = true
            end
          end
        end
      end
    end
    
  end
  
  if ThemeLayout_RefreshAll == true then
    reaper.ThemeLayout_RefreshAll()
    ThemeLayout_RefreshAll = false
  end
  
 
  -- ARRANGE --
  
  local trycnt = 0
  while doArrange == true and trycnt <= 8 do -- do Arrange
    local nothingDirty = true
    for b in ipairs(els) do -- iterate blocks
      --reaper.ShowConsoleMsg('do Arrange block '..b..'\n')
      els[b].onArrange()
      els[b].drawX, els[b].drawY, els[b].drawW, els[b].drawH = scaleMult*els[b].x, scaleMult*els[b].y, scaleMult*els[b].w, scaleMult*els[b].h
      if b>1 then
        --blocks arrange as vertical strips
        els[b].drawX = (els[b-1].drawX or els[b-1].x) + (els[b-1].drawW or els[b-1].w) 
      end
      
      for z in ipairs(els[b]) do -- iterate z
        if els[b][z] ~= nil then
          for j,k in pairs(els[b][z]) do 
            if k:dirtyXywhCheck(b)==true then -- dirtyXywhCheck stores the old xywh, arranges the element, then adds to dirtyZone if it is dirty
              nothingDirty = false
              if k.onUpdate then k:onUpdate() end
            end
            if updateAnyNotHidden==true and k.hidden~= true then 
              addNeedUpdate(k, true)
              --k.paramV = nil 
            end
          end
        end
      end
    end
    
    if nothingDirty == true then -- one complete check was done, and nothing dirty was found
      doArrange = false
    end
    trycnt = trycnt + 1
  end
  if trycnt > 0 then 
    -- reaper.ShowConsoleMsg("doArrange " .. trycnt .. " passes\n");
    updateAnyNotHidden = nil
  end



  -- DRAW --  
  
  if doDraw == true then
    --reaper.ClearConsole()
    --reaper.ShowConsoleMsg('do Draw\n')
    gfx.setimgdim(temporary_framebuffer, gfx.w, gfx.h)
    
    for b in ipairs(els) do -- iterate blocks
     
      if dirtyZone[b] ~= nil and dirtyZone[b].xMax ~= nil then -- there is a dirtyZone
        -- dx,dy are in block coordinates: (0,0) is top left of block
        local dx, dy = math.max(dirtyZone[b].xMin,0), math.max(dirtyZone[b].yMin,0)
        local dw, dh = math.max(dirtyZone[b].xMax - dx, 0), math.max(dirtyZone[b].yMax - dy,0)
        
        local elx, ely = (els[b].drawX or 0),  (els[b].drawY or 0)
        local elw, elh = (els[b].drawW or 0),  (els[b].drawH or 0)
        
        -- xo/yo represent offset when drawing to screen
        local xo = elx - (els[b].scrollX or 0)
        local yo = ely - (els[b].scrollY or 0)
        
        -- if scrolled out of view, don't try to render the offscreen (y<0) portion
        if dy + yo < 0 then
          dh = dh + (dy + yo)
          dy = -yo
        end
        if dx + xo < 0 then
          dw = dw + (dx + xo)
          dx = -xo
        end

        gfx.set(0,0,0,1,0,temporary_framebuffer)
        gfx.rect(0,0,dw,dh)
        for z in ipairs(els[b]) do -- iterate z
          for j,k in pairs(els[b][z]) do               -- iterate Els to draw to the buffer
            if k.hidden ~= true then
              local kw, kh = k.drawW or k.w or 0, k.drawH or k.h or 0
              if kw > 0 and kh > 0 and hasOverlap(k.drawX or k.x, k.drawY or k.y, kw, kh, dx,dy,dw,dh)==true then
                k:draw(dx,dy,dw,dh)
              end
            end
          end
        end -- end of this dirty z
        
        if displayRedraws == 1 then
          gfx.muladdrect(0,0,dw,dh,1,1,1,1,math.random()/3, math.random()/3, math.random()/3,0)
          --reaper.ShowConsoleMsg(string.format("%d: %d %d %d %d\n",b,dx,dy,dw,dh))
        end

        -- prevent blitting outside area of block
        xo = xo + dx
        yo = yo + dy
        dw = math.min(dw, elx + elw - xo)
        dh = math.min(dh, ely + elh - yo)

        gfx.set(0,0,0,1,2,-1)
        gfx.blit(temporary_framebuffer, 1, 0, 0,0,dw,dh, xo,yo,dw,dh)

        dirtyZone[b] = nil
      end
    end -- end iterating blocks
    
    doDraw = false 
  
  end
  

  
  if c>48 and c<59 then
    debugDrawZ = math.floor(c - 48)
  end
  
  if debugDrawZ ~= nil then 
    gfx.a, gfx.dest = 1, -1
    local iw, ih = gfx.getimgdim(debugDrawZ)
    gfx.muladdrect(0,0,iw, ih,0,0,0,0) 
    gfx.blit(debugDrawZ,1,0, 0, 0, iw, ih, 0, 0, gfx.w, gfx.h) 
    text('BUFFER '..debugDrawZ..' w:'..iw..' h:'..ih,0,0,200,20,0,{255,255,255},3)
  end
  --reaper.ShowConsoleMsg('runloop\n')
  if c >= 0 then reaper.runloop(runloop) end
  
end


activeMouseElement = nil
gfxWold, gfxHold = 0, 0
runloop()


function Quit()
  d,x,y,w,h=gfx.dock(-1,0,0,0,0)
  reaper.SetExtState(sTitle,"wndw",w,true)
  reaper.SetExtState(sTitle,"wndh",h,true)
  reaper.SetExtState(sTitle,"dock",d,true)
  reaper.SetExtState(sTitle,"wndx",x,true)
  reaper.SetExtState(sTitle,"wndy",y,true)
  reaper.SetExtState(sTitle,"activePage",activePage,true)
  reaper.SetExtState(sTitle,"chosenPalette",chosenPalette,true)
  gfx.quit()
end
reaper.atexit(Quit)
