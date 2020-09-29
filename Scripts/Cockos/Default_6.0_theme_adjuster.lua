sTitle = 'Default_6.0 theme adjuster'
reaper.ClearConsole()

_desired_sizes = { { 590, 757}, { 850, 800 } }
gfx.ext_retina = 1
drawScale,drawScale_nonmac,drawScale_inv_nonmac,drawScale_inv_mac = 1,1,1,1

_gfxw,_gfxh = table.unpack(_desired_sizes[reaper.GetExtState(sTitle,'showHelp') == 'false' and 1 or 2])

gfx.init(sTitle, _gfxw,_gfxh,
tonumber(reaper.GetExtState(sTitle,"dock")) or 0,
tonumber(reaper.GetExtState(sTitle,"wndx")) or 100,
tonumber(reaper.GetExtState(sTitle,"wndy")) or 50)

function debugTable(t)
  local str = ''
  reaper.ShowConsoleMsg('------ debug ------ \n')
  for i, v in pairs(t) do
    str = str..i..' = '..tostring(v)..'\n'
  end
  reaper.ShowConsoleMsg(str..'\n')
end

globalBorderX, globalBorderY = 6,4 -- docked border
activeTcpLayout, activeMcpLayout = 'A', 'A'

  --------- COLOURS ---------

palette = {}
palette.idx = {'Rv6','Pride','Warm','Cool','Vice','Eeek'}
palette.current = tonumber(reaper.GetExtState(sTitle,'paletteCurrent')) or 1
palette.Rv6 = {{84,84,84},{105,137,137},{129,137,137},{168,168,168},{19,189,153},{51,152,135},{184,143,63},{187,156,148},{134,94,82},{130,59,42}}
palette.Pride = {{84,84,84},{138,138,138},{155,55,55},{155,129,55},{105,155,55},{55,155,81},{55,155,155},{55,81,155},{105,55,155},{155,55,129}}
palette.Warm = {{128,67,64},{184,82,46},{239,169,81},{230,204,143},{231,185,159},{208,193,180},{176,177,161},{108,120,116},{128,114,98},{97,87,74}}
palette.Cool = {{35,75,84},{58,79,128},{95,88,128},{92,102,112},{67,104,128},{91,125,134},{95,92,85},{131,135,97},{55,118,94},{75,99,32}}
palette.Vice = {{255,0,111},{255,89,147},{254,152,117},{255,202,193},{249,255,168},{122,242,178},{87,255,255},{51,146,255},{168,117,255},{99,77,196}}
palette.Eeek = {{255,0,0},{255,111,0},{255,221,0},{179,255,0},{0,255,123},{0,213,255},{0,102,255},{93,0,255},{204,0,255},{255,0,153}}

function getCurrentPalette()
  return palette.idx[palette.current] or 'Rv6'
end

function setCol(col)
  local r = col[1] / 255
  local g = col[2] / 255
  local b = col[3] / 255
  local a = 1
  if col[4] ~= nil then a = col[4] / 255 end
  gfx.set(r,g,b,a)
end

function setCustCol(track, r,g,b)
  reaper.SetTrackColor(reaper.GetTrack(0, track),reaper.ColorToNative(r,g,b))
end

function applyCustCol(col)
  if type(col) ~= "table" or #col < 3 then
    return
  end
  reaper.Undo_BeginBlock()
  for i=0, reaper.CountTracks(0)-1 do
    if reaper.IsTrackSelected(reaper.GetTrack(0, i)) then
      setCustCol(i, table.unpack(col))
    end
  end
  reaper.Undo_EndBlock('custom color changes',-1)
end

function paletteChoose(p)
  local _v = palette.current + p[2]
  if _v < 1 then _v = 1
  elseif _v > #palette.idx then _v = #palette.idx end
  palette.current = _v
end

function getCustCol(track)
  local c = reaper.GetTrackColor(reaper.GetTrack(0, track))
  if c == 0 then return nil end
  return reaper.ColorFromNative(c)
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
  local curpal = palette[getCurrentPalette()] or palette.Rv6
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


  ---------- TEXT -----------

textPadding = 3
if reaper.GetOS():match("^Win") == nil then
  gfx.setfont(1, "Verdana", 9)
  gfx.setfont(2, "Verdana", 10)
  gfx.setfont(3, "Tahoma", 10)
  gfx.setfont(4, "Verdana", 14)
  gfx.setfont(5, "Tahoma", 11)
  gfx.setfont(11, "Verdana", 18)
  gfx.setfont(12, "Verdana", 20)
  gfx.setfont(13, "Tahoma", 20)
  gfx.setfont(14, "Verdana", 28)
  gfx.setfont(15, "Tahoma", 22)
else
  gfx.setfont(1, "Calibri", 13)
  gfx.setfont(2, "Calibri", 15)
  gfx.setfont(3, "Calibri", 16)
  gfx.setfont(4, "Calibri", 20) -- used in : undocked palette title
  gfx.setfont(5, "Calibri", 16) -- IMPORTANT : match the font and size (by eye, oops!) of TCP & EnvCP labels
  gfx.setfont(11, "Calibri", 26)
  gfx.setfont(12, "Calibri", 30)
  gfx.setfont(13, "Calibri", 32)
  gfx.setfont(14, "Calibri", 40) -- used in : undocked palette title
  gfx.setfont(15, "Calibri", 32)
end


if reaper.LocalizeString ~= nil then
  translate = function(s) return reaper.LocalizeString(s or '---',"Default_6.0_Theme_Adjuster") end
else
  translate = function(s) return s or '---' end
end


function text(str,x,y,w,h,align,col,style,lineSpacing,vCenter,wrap)
  local lineSpace = drawScale*(lineSpacing or 11)
  setCol(col or {255,255,255})
  gfx.setfont(style or 1)

  local lines = nil
  str = translate(str)
  if wrap == true then
    lines = textWrap(str,drawScale * 105)
  else
    lines = {}
    for s in string.gmatch(str, "([^#]+)") do
      table.insert(lines, s)
    end
  end
  if vCenter ~= false and #lines > 1 then
    y = y - lineSpace/2
  end
  for k,v in ipairs(lines) do
    gfx.x, gfx.y = x,y
    gfx.drawstr(v,align or 0,x+(w or 0),y+(h or 0))
    y = y + lineSpace
  end
end

function textWrap(str,w) -- returns array of lines
  local lines,curlen,curline,last_sspace = {}, 0, "", false
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
      while length > w do
        -- split up a long word, decimating measure_s as we go
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
      else
        -- word would not fit, add without leading space and remeasure
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

function loadImage(idx, name)
  local str = debug.getinfo(1, "S").source:match[[^@(.*[\/])[^\/]-$]].."Default_6.0_theme_adjuster_images/"
  if gfx.loadimg(idx, str..name) == -1 then reaper.ShowConsoleMsg("image "..name.." not found") end
end

image_idx = {}
function getImage(img)
  for i, v in ipairs(image_idx) do
    if v == img then return i end
  end
  loadImage(#image_idx+1, img..'.png')
  image_idx[#image_idx+1] = img
  return #image_idx
end


  --------- OBJECTS ---------

function adoptChild(parent,o)
  if parent ~= nil then
    if parent.children == nil then parent.children = { o }
    else parent.children[#parent.children+1] = o end

    if parent.has_children_outside ~= 1 then
      if o.has_children_outside == 1 then
        parent.has_children_outside = 1
      else
        if o.x ~= nil and o.y ~= nil and parent.w ~= nil and parent.h ~= nil then
          if o.x < 0 or o.y < 0 or o.x+(o.w or 1) > parent.w or o.y+(o.h or 1) > parent.h then
            parent.has_children_outside = 1
          end
        end
      end
    end
  end
end

Element = {}
function Element:new(parent,o)
local o = o or {}
  self.__index = self
  self.x, self.y = self.x or 0, self.y or 0
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

Button = Element:new()
function Button:new(parent,o)
  self.__index = self
  o.x, o.y, self.w, self.h, self.border = o.x or 0, o.y or 0, o.w or 30,o.h or 30, o.border or ''
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

ButtonLabel = Element:new()
function ButtonLabel:new(parent,o)
  self.__index = self
  self.flow = true
  o.text={str=o.text.str, col={129,137,137}, align=4, style=1}
  self.x, self.h, self.w, self.border = 2, 30, o.w or 73, o.border or ''
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

Readout = Element:new()

Spinner = Element:new()
function Spinner:new(parent,o)
  self.__index = self
  self.x, self.y, self.w, self.h = 0,0,o.w or 119,o.h or 30
  self.flow = o.flow
  self.border = o.border or ''
  local spinStyle = o.spinStyle or 'light'
  local i = getImage(spinStyles[spinStyle].buttonLimage)
  self.buttonW = gfx.getimgdim(i) /3
  if spinStyles[spinStyle].title ~= false then
    local topBar = Element:new(o,{x=self.buttonW/2,y=2,w=self.w-self.buttonW,h=spinStyles[spinStyle].title.h,color=spinStyles[spinStyle].label.col,interactive=false})
  end
  if spinStyles[spinStyle].readout ~= false then
    local bottomBar = Element:new(o,{x=self.buttonW/2,y=spinStyles[spinStyle].readout.y,w=self.w-self.buttonW,h=spinStyles[spinStyle].readout.h,color=spinStyles[spinStyle].readout.col,interactive=false})
  end
  if o.spinStyle == 'image' then
    local ir = Readout:new(o,{x=self.buttonW,y=spinStyles[spinStyle].readout.y,w=self.w-(2*self.buttonW),h=spinStyles[spinStyle].readout.h,border='',
                      valsImage = o.valsImage, action = o.action, param={'editPage'}})
  else
    if spinStyles[spinStyle].readout ~= false then
      local r = Readout:new(o,{x=self.buttonW,y=spinStyles[spinStyle].readout.y,w=self.w-(2*self.buttonW),h=spinStyles[spinStyle].readout.h,border='',
                  text={str='---',align=5,val=o.value, col=spinStyles[spinStyle].readout.strCol, style=2},
                  action = o.action, param={o.param}, valsTable=o.valsTable})
    end
  end
  local hitBox = Element:new(o,{x=0,y=0,w=self.w,h=self.h,action = o.action, param={o.param},helpR=o.helpR,helpL=o.helpL})
  local l = Button:new(hitBox,{x=0,y=2,w=self.buttonW,h=self.h,img=spinStyles[spinStyle].buttonLimage,imgType=3,action=o.action,param={o.param,-1},helpR=o.helpR,helpL=o.helpL})
  local r = Button:new(hitBox,{x=self.w-self.buttonW,y=2,w=self.buttonW,h=self.h,img=spinStyles[spinStyle].buttonRimage,imgType=3,action=o.action,param={o.param,1},helpR=o.helpR,helpL=o.helpL})
  if o.title~=nil and spinStyles[spinStyle].title ~= false then
    Element:new(o,{x=self.buttonW,y=2,w=self.w-(2*self.buttonW),h=spinStyles[spinStyle].title.h,action=o.action,param={o.param}, -- label
                  text={str=(o.title or'LABEL STR'), align = 5, col=spinStyles[spinStyle].label.strCol}})
  end
  o.valsImage = nil -- was only there temporarily, to be passed to the readout child
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

spinStyles = {
  light = {buttonLimage = 'button_left', buttonRimage = 'button_right',
          title = {h=13},
          label = {strCol={51,51,51}, col={129,137,137}},
          readout = {y=15,h=13,strCol={129,137,137},col=nil}
  },
  image = {buttonLimage = 'left', buttonRimage = 'right', title = false,
          readout = {y=6,h=20,strCol={129,137,137},col=nil}
  }
}

Fader = Element:new()
function Fader:new(parent,o)
  o.parent = parent;
  self.__index = self
  o.x, o.y, self.w, self.h = o.x or 0, o.y or 0, o.w or 21,o.h or 27
  self.img, self.imgType ='slider', 3
  self.range, self.action, self.param, self.helpR = o.range, o.action, o.param, o.helpR
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

FaderBg = Element:new()
function FaderBg:new(parent,o)
  self.__index = self
  o.x, o.y, self.w, self.h = o.x or 0, o.y or 0, o.w or 21,o.h or 27
  o.parent = parent
  self.action, self.param, self.helpR = o.action, o.param, o.helpR
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

ParamTable = Element:new()
function ParamTable:new(parent,o)
  self.__index = self
  self.h = o.h
  for i, v in ipairs(o.valsTable.columns) do
    if v.text.col ~= nil then thisCol = {204,69,114} else thisCol = {129,137,137} end
    Element:new(o, {x=44+i*82,y=0,w=80,h=25,text={str=v.text.str,style=1,align=1,col=thisCol}}) --column titles
  end
  for i=1, #o.valsTable.rows do ParamRow:new(o,o.valsTable,i) end
  Element:new(o, {x=124,y=0,w=1,h=o.h,color={129,137,137,64}}) --
  Element:new(o, {x=206,y=0,w=1,h=o.h,color={129,137,137,64}}) -- column
  Element:new(o, {x=288,y=0,w=1,h=o.h,color={129,137,137,64}}) -- dividers
  Element:new(o, {x=370,y=0,w=1,h=o.h,color={129,137,137,64}}) --
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

ParamRow = Element:new()
function ParamRow:new(parent,valsTable,rowIdx)
  local o = {}
  self.__index = self
  if (rowIdx%2==0) then rowBgCol = {51,51,51} else rowBgCol = {44,44,44} end
  local row = Element:new(parent, {x=0,y=rowIdx*25+5,w=453,h=25,color=rowBgCol})
  local titleW = 114
  if valsTable.rows[rowIdx].img ~= nil then
    Element:new(row, {x=91,y=0,w=23,h=25,img=valsTable.rows[rowIdx].img}) --row title images
    titleW = 80
  end
  Element:new(row, {x=0,y=0,w=titleW,h=25,text={str=valsTable.rows[rowIdx].text.str,style=1,align=6,col={129,137,137}}})  --row titles
  for i, v in ipairs(valsTable.columns) do
    Button:new(row, {x=44+i*82,y=0,w=81,h=25,img=valsTable.img,imgType=3,action=doFlagParam,param={valsTable.rows[rowIdx].param,v.visFlag}})
  end
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

Palette = Element:new()
function Palette:new(parent,o)
  o.w = o.cellW * 10
  self.__index = self
  for i=1,10 do
    local p = Button:new(o,{flow=true,x=0,y=0,w=o.cellW, h=o.h, img=o.img or 'color_apply',imgType=3, action=o.action}) -- used to be x=2 to make the dividers
  end
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

Swatch = Element:new()
function Swatch:new(parent,o)
  self.__index = self
  self.x, self.y, self.w, self.h = o.x or 0,o.y or 0,200,30
  local SwatchHitbox = SwatchHitbox:new(o, {paletteIdx = o.paletteIdx})
  for i,v in pairs(palette[palette.idx[o.paletteIdx] or 'Rv6']) do
    local p = Element:new(o,{x=((i-1)*20),y=0,w=20, h=20,color=v})
  end
  local div = Element:new(o, {x=0,y=30,w=200,h=1})
  gfx.setfont(2)
  local palStr,tmp = undockPaletteNamesVals[o.paletteIdx]
  local palStrW = gfx.measurestr(palStr)+12
  local label = Element:new(o, {x=100-(palStrW/2),y=20,w=palStrW,h=17,text={str=palStr,style=2,align=9},color={38,38,38}})
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

SwatchHitbox = Element:new()
function SwatchHitbox:new(parent,o)
  o.parent = parent;
  self.__index = self
  self.x, self.y, self.w, self.h = 0,0,200,34
  self.helpR=helpR_choosePalette
  adoptChild(parent,o)
  setmetatable(o, self)
  return o
end

function Swatch:doParamGet()
  if self.paletteIdx == palette.current then
    self.children[12].color = {19,189,153}
    self.children[13].text.col = {19,189,153}
  else
    self.children[12].color = {51,51,51}
    self.children[13].text.col = {129,137,137}
  end
end

function Fader:doParamGet()
  local lx = self.x;
  local tmp,title,value,defValue,min,max = reaper.ThemeLayout_GetParameter(self.param)
  if max > min then
    self.x = 432 * ((value - min) / (max - min))
  else
    self.x = 432/2
  end
  if lx ~= self.x then
    self.parent:onSize()
    redraw = 1
  end
end

-------------- PARAMS --------------

function indexParams()
  
  paramsIdx ={['A']={},['B']={},['C']={},['global']={}}
  local i=1
  while reaper.ThemeLayout_GetParameter(i) ~= nil do
    local tmp,desc = reaper.ThemeLayout_GetParameter(i)
    local layout, paramDesc = string.sub(desc, 1, 1), string.sub(desc, 3)
    if paramsIdx[layout] ~= nil then
      paramsIdx[layout][paramDesc] = i
    end
    i = i+1
  end
  redraw = 1
end

function paramIdxGet(param)
  if paramsIdx == nil then reaper.ShowConsoleMsg('paramsIdx is nil\n') end
  local panel = param and string.sub(param,0,(string.find(param, '%_')-1))
  if param == 'tcp_indent' or param == 'tcp_control_align' or param == 'mcp_indent' or param == 'tcp_LabelMeasure'
      or panel == 'envcp' or panel == 'trans' or panel == 'glb' then --params which act on ALL layouts
    local p = paramsIdx['A'][param]
    if p ~= nil then return p end
  else
    if panel ~= nil and param ~= nil then
      local p = paramsIdx[activeLayout[panel]][param]
      if p ~= nil then return p end
    end
  end
end

function paramToVal(param,v)
  local val,suffix
  if param == -1000 then val, suffix = v / 1000, '' end
  if param <= -1001 and param >= -1003 then val, suffix = v / 256, '' end
  if param == -1004 then val, suffix = math.floor(v / 2.56 + .5), ' %' end
  if param == -1005 then val, suffix = math.floor(v * 0.9375 - 180 + .5),' °' end
  return val, suffix
end

function valToParam(param,v)
  local val
  if param == -1000 then val = v * 1000 end
  if param <= -1001 and param >= -1003 then val = v * 256 end
  if param == -1004 then val = math.floor(v * 2.56 + .5) end
  if param == -1005 then val = math.floor((v + 180) / 0.9375 + .5) end
  return val
end

function Element:doParamGet()
  if self.visible ~= false then paramGetChildren(self.children) end
end

function paramGetChildren(ch)
  if ch ~= ni then
    for i, v in ipairs(ch) do
      v:doParamGet() --get all the param values for your children.
    end
  end
end

function Button:doParamGet()
  if self.action == paramToggle then                          -- then you're a toggle state
    if type(self.param) ~= 'number' then
      self.param = paramIdxGet(self.param)
    end
    local tmp,tmp,v = reaper.ThemeLayout_GetParameter(self.param or -1)
    if v == 1 then
      self.drawImg = tostring(self.img..'_on')
    else self.drawImg = nil
    end
  end
  if self.action == doFlagParam  then                         --param table cells
    local p = paramIdxGet(self.param[1])
    local name,desc,value = reaper.ThemeLayout_GetParameter(p)
    if value & self.param[2] ~= 0 then
      if self.param[2] == 8 and self.img == 'cell_hide' then    -- use red hide images on column 4 of the tcp's table
       self.drawImg = tostring(self.img..'_all')
      else
        self.drawImg = tostring(self.img..'_on')
      end
    else self.drawImg = nil
    end
  end
end

function Readout:doParamGet()
  if self.param ~= nil and self.param[1]~= nil then
    if self.valsTable ~= nil then
      if self.action == nil then -- then you're just a palette
        self.text.str = self.valsTable[palette.current]
      else -- if you're not a palette you must be a paramSet spinner
        local p = paramIdxGet(self.param[1])
        local tmp,tmp,value = reaper.ThemeLayout_GetParameter(p or 0)
        if value <= #self.valsTable then
          self.text.str = self.valsTable[value]
        else self.text.str = 'ERR '..p..' '..value
        end
      end
    elseif self.action == doPageSpin then self.imgValueFrame = editPage-1
    elseif self.action == doFader then
      local tmp,tmp,value = reaper.ThemeLayout_GetParameter(self.param[1]) --< color faders have param as number, no need to lookup 
      local v, suffix = paramToVal(self.param[1],value)
      self.text.str = string.format(suffix == "" and "%.2f" or "%d%s",v,suffix);
    end
  end
end

function paramSet(param)
  local p,v = param[1], param[2]
  --reaper.ShowConsoleMsg('paramSet '..p..' to '..v..'\n')
  if type(p) ~= 'number' then p = paramIdxGet(p) or 0 end
  local name,desc,value,defvalue,minvalue,maxvalue = reaper.ThemeLayout_GetParameter(p)
  newValue = value + v
  if newValue < minvalue then newValue = minvalue end
  if newValue > maxvalue then newValue = maxvalue end
  reaper.ThemeLayout_SetParameter(p, newValue, true)
  reaper.ThemeLayout_RefreshAll()
  paramGet = 1
end

function doFlagParam(param) --param name, visFlag
  local p = paramIdxGet(param[1])
  local name,desc,value = reaper.ThemeLayout_GetParameter(p)
  reaper.ThemeLayout_SetParameter(p, value ~ param[2], true)
  reaper.ThemeLayout_RefreshAll()
  paramGet = 1
end

function paramToggle(p)
  if p ~= nil then
    local tmp,tmp,v = reaper.ThemeLayout_GetParameter(p)
    if v == 1 then
      reaper.ThemeLayout_SetParameter(p, 0, true)
    else
      reaper.ThemeLayout_SetParameter(p, 1, true)
    end
    reaper.ThemeLayout_RefreshAll()
  end
end

function actionToggle(p)
  reaper.Main_OnCommand(p, 0)
  needReaperStateUpdate=1
end

------------ doUpdateState gets/refreshes values. it should set redraw if a value changed. 
------------ needReaperStateUpdate is 1 if the project has changed (implies redraw)

function Element:doUpdateState()
  if self.updateState ~= nil then
    self:updateState()
  end

  if self.children ~= nil then
    for i, v in ipairs(self.children) do
      if v.visible ~= false then v:doUpdateState() end
    end
  end
end

function Button:doUpdateState()

  if self.updateState ~= nil then   --<< swap over to this for image buttons
    self:updateState()
  end

  local old = self.drawImg
  if self.action == actionToggle then
    local v = reaper.GetToggleCommandState(self.param)
    if v == 1 then
      self.drawImg = tostring(self.img..'_on')
    else self.drawImg = nil
    end
  end
  if self.action == doActiveLayout then
    local p, a = 'P_TCP_LAYOUT', ''
    if self.param[1] == 'mcp' then p = 'P_MCP_LAYOUT' end
    if self.param[2] == activeLayout[self.param[1]] then a = '_on' end  --you are the button for the active layout

    self.drawImg = nil
    if a ~= nil then self.drawImg = self.img..a end
  end
  if self.children ~= nil then
    for i, v in ipairs(self.children) do
      if v.visible ~= false then v:doUpdateState() end
    end
  end
  if old ~= self.drawImg then redraw = 1 end
end

function Fader:doUpdateState()
  if self.updateState ~= nil then
    self:updateState()
  end
  local tmp,title,value,defValue,min,max = reaper.ThemeLayout_GetParameter(self.param)
  local lx = self.x;
  if self.dragStart ~= nil then
    local dX = gfx.mouse_x - self.dragStart
    local v = math.floor(dX * ((max - min)/(432 * drawScale)))
    newValue = self.dragStartValue + v
    if newValue < min then newValue = min end
    if newValue > max then newValue = max end
    if max > min then
      self.x = 432 * ((newValue - min) / (max - min))
    else
      self.x = 432/2
    end
  else
    self:doParamGet()
  end
end

function Readout:doUpdateState()
  if self.updateState ~= nil then
    self:updateState()
  end
  self:doParamGet()
end

function anySelected(self) -- called by an object's updateState value, and uses its getParam values.
  if self.text ~= nil and self.text.colFalse ~= nil and needReaperStateUpdate==1 then
    local p  = 'P_TCP_LAYOUT'
    if self.getParam[1] == 'mcp' then p = 'P_MCP_LAYOUT' end --( NOTE :: param[1] tcp or mcp, param[2] A,B or C.)
    self.text.col = self.text.colFalse
    for i=0, reaper.CountTracks(0)-1 do
      local track = reaper.GetTrack(0, i)
      if reaper.IsTrackSelected(track) == true then
        local tmp, l = reaper.GetSetMediaTrackInfo_String(track, p, "", false)
        if string.sub(l,-1) == self.getParam[2] then -- a selected track is using this layout
          self.text.col = self.text.colTrue
          break
        end
      end
    end
  end
end

function noneSelected(self)
  if needReaperStateUpdate == 1 then
    local trackCount = reaper.CountTracks(0)-1
    local noneSelected = true
    for i=0, trackCount do
      if reaper.IsTrackSelected(reaper.GetTrack(0, i)) == true then
        noneSelected = false
        break
      end
    end
    if self.imgFalse ~= nil then
      if noneSelected == true then self.img = self.imgTrue else self.img = self.imgFalse end
    end
  end
end

function isDefault(self)
  local tmp, def = reaper.ThemeLayout_GetLayout(self.getParam[1], -1)
  if self.text ~= nil then
    if self.text.colFalse ~= nil then
      local oldcol = self.text.col
      if def == self.getParam[2] or (def == '' and self.getParam[2] == 'A') then
        self.text.col = self.text.colTrue
      else
        self.text.col = self.text.colFalse
      end
      if oldcol ~= self.text.col then redraw = 1 end
    end
  end
end

function read_ini(file, sec, ent)
  local insec, str, section = false, string.lower(ent), string.lower(sec)
  for l in io.lines(file) do
    local m = string.match(l,"^%s*[[](.-)[]]")
    if m ~= nil then
      insec = section == string.lower(m)
    else
      if insec then
        local a = string.match(l,"^%s*(.-)=")
        if a ~= nil and str == string.lower(a) then
          return string.match(l,"^.-=(.*)")
        end
      end
    end
  end
end

reaperDpi = {'tcp','mcp','envcp','trans'}
dpiParams = {{'apply_50','50%_'},{'apply_75','75%_'},{'apply_100',''},{'apply_150','150%_'},{'apply_200','200%_'}}
function getReaperDpi()

  for i, v in ipairs(reaperDpi) do
    local ok, dpi_str = reaper.ThemeLayout_GetLayout(v,-3)
    if reaperDpi[v] == nil then reaperDpi[v] = {} end
    local dpi = tonumber(dpi_str)
    if ok == true and dpi ~= nil and dpi > 0 then
      reaperDpi[v].new = dpi / 256
    else
      reaperDpi[v].new = 1.0
    end

    local p = {3,4,5}
    if reaperDpi[v].old == nil or reaperDpi[v].old ~= reaperDpi[v].new then
      if reaperDpi[v].new > 1.34 then
        p = {2,3,4}
        if reaperDpi[v].new > 1.74 then p = {1,2,3} end
      end
      for i=1,3 do
        if apply[v][i]==nil then apply[v][i] = {} end
        apply[v][i].img, apply[v][i].param = dpiParams[p[i]][1], {v,dpiParams[p[i]][2]}
        apply.und[v][i].img, apply.und[v][i].param = apply[v][i].img, apply[v][i].param
      end
      reaperDpi[v].old = reaperDpi[v].new
      redraw = true
    end
  end
end

function measureTrackNames(trackCount)
  local nameChanged = 0
  for i=0, trackCount do
    local tmp, trackName = reaper.GetSetMediaTrackInfo_String(reaper.GetTrack(0, i), 'P_NAME', "", false)
    if (trackNames[i] ~= trackName) then -- track name has changed
      trackNames[i] = trackName
      gfx.setfont(5)
      trackNamesW[i] = gfx.measurestr(trackName)
      nameChanged = 1
      redraw = 1
    end
  end
  if nameChanged == 1 then
    local trackNamesWMax = 25 -- setting a minimum size
    for k,v in pairs(trackNamesW) do
      if v > trackNamesWMax then trackNamesWMax = v end
    end
    local p = paramIdxGet('tcp_LabelMeasure')
    if p ~= nil then
      reaper.ThemeLayout_SetParameter(p, trackNamesWMax, true)
      reaper.ThemeLayout_RefreshAll()
    end
  end
end

function measureEnvNames(trackCount)
  for i=0, trackCount do
    local tr = reaper.GetTrack(0, i)
    local trEnvs = reaper.CountTrackEnvelopes(tr)
    if trEnvs > 0 then
      if envs[i] == nil then
        envs[i] = {}
      end
      while #envs[i] > trEnvs do
        table.remove(envs[i])
        redraw = 1
      end
    end
    for j=0, trEnvs-1 do
      local env = reaper.GetTrackEnvelope(tr,j)
      local b, envName = reaper.GetEnvelopeName(env,'')
      gfx.setfont(5)
      if b == true then
        if envs[i][j+1] ~= nil then
          if envs[i][j+1][name] ~= envName then -- env name has changed
            envs[i][j+1] = {name = envName, l = gfx.measurestr(envName)}
            redraw = 1
          end
        else envs[i][j+1] = {name = envName, l = gfx.measurestr(envName)}
        end
      end
    end
  end
  local envNamesWMax = 100
  for k,v in pairs(envs) do
    if v ~= nil then
      for kk,vv in pairs(v) do
        if vv.l > envNamesWMax then envNamesWMax = vv.l end
      end
    end
  end
  reaper.ThemeLayout_SetParameter(paramIdxGet('envcp_LabelMeasure'), envNamesWMax, true)
end

------------- ACTIONS --------------

function toggleHelp()
  if _helpR.visible ~= false then doHelpVis(false) else doHelpVis(true) end
end

function doHelpVis(visible)
  if visible == nil then
    if reaper.GetExtState(sTitle,'showHelp') == 'false' then visible = false else visible = true end
  end
  _helpL.visible, _helpR.visible = visible, visible
  _gfxw,_gfxh = table.unpack(_desired_sizes[visible == true and 2 or 1])
  _buttonHelp.img = visible == true and 'help_on' or 'help'
  reaper.SetExtState(sTitle,'showHelp',tostring(visible),true)
  getDpi()
  if _dockedRoot.visible ~= true then
    _gfxw,_gfxh = table.unpack(_desired_sizes[_helpL.visible == true and 2 or 1])
    _gfxw,_gfxh = drawScale_nonmac*_gfxw,drawScale_nonmac*_gfxh
    gfx.init("",_gfxw,_gfxh)
  end
end

function themeCheck()
  local theme,tmp,tmp,theme_version = reaper.ThemeLayout_GetParameter(0)
  if theme ~= oldTheme or theme == nil then
    last_theme_filename = reaper.GetLastColorThemeFile()
    last_theme_filename_check = reaper.time_precise()
    if theme ~= 'defaultV6' or theme_version < 1 then --theme_version catch for later changes
      _wrongTheme.visible, _dockedRoot.visible, _undockedRoot.visible = true, false, false
      _theme.text.str = string.match(last_theme_filename, '[^\\/]*$')
      if gfx.measurestr(_theme.text.str)<160 then _theme.w=160 else _theme.w=gfx.measurestr(_theme.text.str) end
      _wrongTheme:onSize()
      redraw = 1
    else
      indexParams()
      _wrongTheme.visible = false
      getDock() --it will decide which root to draw
      paramGet = 1
      redraw = 1
    end
    oldTheme = theme
  else
    local now = reaper.time_precise()
    if now > last_theme_filename_check+1 then
      -- once per second see if the theme filename changed and reload parameters
      last_theme_filename_check = now
      local tfn = reaper.GetLastColorThemeFile()
      if tfn ~= last_theme_filename then
        last_theme_filename = tfn
        paramGet = 1
        redraw = 1
      end
    end
  end
end

function switchTheme()
  local str = string.match(reaper.GetLastColorThemeFile(), '^(.*)[/\\].+$')
  if(reaper.file_exists(str.."/Default_6.0_unpacked.ReaperTheme")==true) then
    openTheme = reaper.OpenColorThemeFile(str.."/Default_6.0_unpacked.ReaperTheme")
  else if(reaper.file_exists(str.."/Default_6.0.ReaperThemeZip")==true) then
    openTheme = reaper.OpenColorThemeFile(str.."/Default_6.0.ReaperThemeZip")
    else reaper.ShowConsoleMsg("Default 6.0 theme not found")
    end
  end
  indexParams()
  redraw = 1
end

function doDock()
  local d = gfx.dock(-1)
  if d%2==0 then
    gfx.dock(d+1)
    _dockedRoot.visible, _undockedRoot.visible = true, false
  else
    gfx.dock(d-1)
    _dockedRoot.visible, _undockedRoot.visible = false, true
  end
  doActivePage()
  resize = 1
  paramGet = 1
end

function getDock()
  if _wrongTheme.visible ~= true then
   local d = gfx.dock(-1)
    if d%2==0 then
      _dockedRoot.visible, _undockedRoot.visible = false, true
    else _dockedRoot.visible, _undockedRoot.visible = true, false
    end
  end
end

function getDpi()
  if gfx.ext_retina ~= dpi then
    dpi = gfx.ext_retina
    if dpi>1.49 then drawScale = 2 else drawScale = 1 end
    if reaper.GetOS() ~= "OSX64" and reaper.GetOS() ~= "OSX32" then
      drawScale_nonmac = drawScale
      drawScale_inv_nonmac = 1/drawScale
    else
      drawScale_inv_mac = 1/drawScale
    end
    resize = 1
  end
end

function getEditPage()
  return menuBoxVals[editPage]
end

function doActivePage()
  if editPage<1 or editPage>6 then editPage = 1 end

  if _dockedRoot.visible ~= false then
    for i, v in ipairs(_dockedRoot.children) do
      if i>0 and i<7 then -- ignore the last child (the undock button)
        if i == editPage then v.visible = true
        else v.visible = false end
      end
    end
  end

  if _undockedRoot.visible ~= false then
    if editPage == 6 then editPage = 5 end
    for i, v in ipairs(_subPageContainer.children) do
      if i>0 and i<=(#_subPageContainer.children) then
        if i == editPage then v.visible = true
        else v.visible = false
        end
      end
    end
  end
  resize = 1
end

function doPageSpin(param)
  local val = param[2]
  local limit = #menuBoxVals

  if val == 0 then return end
  if val > 0 then val = 1 else val = -1 end -- one at a time

  if _undockedRoot.visible == true then limit = 5 end
  if editPage>=limit and val==1 then
    editPage = 1
  else
    if editPage==1 and val==-1 then editPage = limit
    else editPage = editPage + val
    end
  end
  doActivePage()
  needReaperStateUpdate = 1
  paramGet = 1
  root:onSize()
  redraw = 1
end

function doActiveLayout(param)
  function isLayoutName(n)
    if n ~= nil and (n == 'A' or n == 'B' or n == 'C') then return n end
  end
  if param ~= nil then
    if isLayoutName(param[2]) then
      activeLayout[param[1]] = param[2]
    end
  else
    activeLayout = {
      tcp = isLayoutName(reaper.GetExtState(sTitle,'activeLayoutTcp')) or 'A',
      mcp = isLayoutName(reaper.GetExtState(sTitle,'activeLayoutMcp')) or 'A'
    }
  end
  paramGet = 1
  redraw = 1
end

function applyLayout(param) --panel, size
  if param[1] == 'envcp' or param[1] == 'trans' then
    reaper.ThemeLayout_SetLayout(param[1], param[2]..'A')
  else
    local p =  'P_TCP_LAYOUT'
    if param[1] == 'mcp' then p = 'P_MCP_LAYOUT' end
    for i=0, reaper.CountTracks(0)-1 do
      local tr = reaper.GetTrack(0, i)
      if reaper.IsTrackSelected(tr) == true then
        reaper.GetSetMediaTrackInfo_String(tr, p, param[2]..tostring(activeLayout[param[1]]), true)
      end
    end
  end
end

function reduceCustCol(ifSelected)
  local ratio = 0.4
  local targetR, targetG, targetB = 84,84,84
  reaper.Undo_BeginBlock()
  for i=0, reaper.CountTracks(0)-1 do
    local selState = false
    if ifSelected == true then
      if reaper.IsTrackSelected(reaper.GetTrack(0, i)) == true then
        selState = true
      end
    end
    if (ifSelected ~= true or selState == true) and getCustCol(i)~=nil then
      local r,g,b = getCustCol(i)
      r = math.floor(r * (1-ratio) + targetR * ratio)
      g = math.floor(g * (1-ratio) + targetG * ratio)
      b = math.floor(b * (1-ratio) + targetB * ratio)
      setCustCol(i,r,g,b)
    end
  end
  reaper.Undo_EndBlock('Dimming of custom colors',-1)
end

function resetColorControls()
  for i=-1005,-1000,1 do
    local tmp,tmp,tmp,d = reaper.ThemeLayout_GetParameter(i)
    reaper.ThemeLayout_SetParameter(i, d, i == -1000)
  end
  paramGet = 1
  redraw = 1
end

function doFader(self,dX)
  if self.userEntry == true then --< the fader's readout
    local name,desc,value,defvalue,minvalue,maxvalue = reaper.ThemeLayout_GetParameter(self.param[1])
    local vValMin, vValMinSuffix = paramToVal(self.param[1],minvalue)
    local vValMax, vValMaxSuffix = paramToVal(self.param[1],maxvalue)
    local r,v = reaper.GetUserInputs(desc, 1, vValMin..vValMinSuffix..' to '..vValMax..vValMinSuffix, self.text.str)
    local val = tonumber(v:match("[-]?[%d.,]+"))
    if r ~= false and val ~= nil then
      local tmp,tmp,tmp,tmp,minvalue,maxvalue = reaper.ThemeLayout_GetParameter(self.param[1])
      val = math.floor(valToParam(self.param[1],val))
      if val < minvalue then val = minvalue end
      if val > maxvalue then val = maxvalue end
      reaper.ThemeLayout_SetParameter(self.param[1], val, true)
      paramGet = 1
      redraw = 1
    end
  else --non-readout fader stuff 
  end
end


--------- ARRANGE ELEMENTS ---------

function Element:onSize()

  local crop = self.crop or false
  if self.children ~= nil and self.visible ~= false and self.crop ~= true then
    for i, v in ipairs(self.children) do

      local bx,by = 0,0
      if v.border == 'xy' or v.border == 'x' then bx = globalBorderX end
      if v.border == 'xy' or v.border == 'y' then by = globalBorderY end

      local prevElX, prevElY, prevElW, prevElH = 0,0,0,0
      if i>1 then --there is a previous child
        prevElX, prevElY, prevElW, prevElH = self.children[i-1].drawx, self.children[i-1].drawy, self.children[i-1].drawW, self.children[i-1].drawH
        if self.children[i-1].visible == false then prevElW = 0 end
      end

      if v.flexW ~= nil then
        if v.flexW == 'fill' then
          v.drawW = self.drawx + (self.drawW or self.w) - ((prevElX or self.drawx) + (prevElW or 0)) + (v.w or 0)
        else v.drawW = (v.w or 0) + ((self.drawW or self.w) * (v.flexW:sub(1, -2) / 100))
        end
      else v.drawW = v.w
      end

      if v.flexH ~= nil then v.drawH = (v.h or 0) + ((self.drawH or self.h) * (v.flexH:sub(1, -2) / 100))
      else v.drawH = v.h end

      v:position(self.drawx,self.drawy,self.drawW,self.drawH,prevElX, prevElY, prevElW, prevElH, bx, by)
      v:onSize() -- this child sizes its children

    end
  end
end

function Element:position(parentX,parentY,parentW,parentH,prevElX, prevElY, prevElW, prevElH, bx, by)

  if parentX == nil then parentX = 0 end
  if parentY == nil then parentY = 0 end
  if parentW == nil then parentW = 0 end
  if parentH == nil then parentH = 0 end
  self.drawx, self.drawy = parentX  + self.x + bx, parentY + self.y + by

  if self.positionX ~= nil then
    if self.positionX == 'center' then
      parentW, parentH = parentW * drawScale_inv_nonmac, parentH * drawScale_inv_nonmac
      self.drawx, self.drawy = (parentW - self.drawW)/2, (parentH - self.drawH)/2
    elseif self.positionX == 'right' then
      self.drawx = parentW - self.w
    end
  end

  if self.flow ~= nil and self.flow ~= false then
    if prevElX == nil or prevElW == 0 then                                                  -- you're the first child
      self.drawx, self.drawy = parentX + self.x + bx, parentY + self.y + by
      self.crop = false
      if (parentX + parentW) < (self.drawx + self.drawW + bx) then
        self.crop = true
      end
    else                                                                    -- there is a previous child
      if (prevElX + prevElW + bx + self.drawW + bx) <= (parentX + parentW) then           -- place you as next element
        self.drawx, self.drawy = prevElX + prevElW + bx + self.x, prevElY + self.y
        self.debug = 'prevElX : '..prevElX..'    prevElW : '..prevElW..'    prevElY : '..prevElY
        self.crop = false
      elseif (parentY + parentH) > (prevElY + prevElH + self.y + self.drawH + by) then    -- flow you to next row
        self.drawx, self.drawy = parentX + self.x + globalBorderX, prevElY + prevElH + self.y + globalBorderY
        self.debug = 'FLOW! prevElX : '..prevElX..'    prevElW : '..prevElW..'    prevElY : '..prevElY
        self.crop = false
       else
        self.crop = true                                                          -- don't fit, crop you
      end
    end

  end
  self.crop = false

end


  ---------- DRAW -----------

function Element:draw()

  gfx.set(0,0,0,1) -- opacity reset
  local crop = self.crop or false
  if self.debug == true then debugTable(self) end
  if self.visible ~= false and crop ~= true then
    local thisX = drawScale * (self.drawx or self.x)
    local thisY = drawScale * (self.drawy or self.y)
    local thisW = drawScale * (self.drawW or self.w or 0)
    local thisH = drawScale * (self.drawH or self.h or 0)
    local thisDrawW = drawScale * (self.drawW or 0)
    local thisDrawH = drawScale * (self.drawH or 0)

    local thisCol = self.drawColor or self.color or nil
    if thisCol ~= nil then
      setCol(thisCol)
      if self.shape == nil then
        gfx.rect(thisX,thisY,thisDrawW,thisDrawH)
      else 
        local r = thisDrawW/2
        gfx.circle(thisX+r,thisY+r,r,true)
      end
    end

    if self.img ~= nil or  self.valsImage ~= nil then
      local img = self.img or self.valsImage
      if self.drawImg ~= nil then -- then this element's image isn't static
        img = self.drawImg
      end
      if drawScale == 2 then img = img..'@2x' end
      local i = getImage(img)                          --<< Refine getImage, it currently reloads the image whenever called
      local iDw, iDh = gfx.getimgdim(i)

      if self.imgType ~= nil and iDw ~= nil and self.imgType == 3 then
        local yOffset = 0
        if thisW ~= iDw/3 then -- width stretching needed
          local pad = drawScale * 10
          gfx.blit(i, 1, 0, (iDw/3)*(self.imgFrame or 0), 0, pad, iDh, thisX, thisY, pad, iDh)
          gfx.blit(i, 1, 0, ((iDw/3)*(self.imgFrame or 0))+ pad, 0, (iDw / 3) -(2*pad), iDh, thisX+pad, thisY, thisW-(2*pad), iDh)
          gfx.blit(i, 1, 0, (iDw/3)*(self.imgFrame or 0) + (iDw/3 -pad), 0, pad, iDh, thisX + thisW-pad, thisY, pad, iDh)
        else
          gfx.blit(i, 1, 0, (iDw/3)*(self.imgFrame or 0), 0, iDw / 3, iDh, thisX, thisY, iDw / 3, iDh)
        end
      elseif self.valsImage ~= nil then
        gfx.blit(i, 1, 0, thisW*(self.imgValueFrame or 0), 0, thisW, iDh, thisX, thisY, thisW, iDh)
      else
        gfx.blit(i, 1, 0, 0, 0, iDw, iDh, thisX, thisY, thisDrawW, thisDrawH)
      end

    end

    if self.text ~= nil then
      if self.text.val ~=nil then
        self.text.str = self.text.val()
      end
    local txtScaleOffs = ''
    if drawScale == 2 then txtScaleOffs = 1 end
      local tx,tw = thisX + (drawScale*textPadding), thisW - 2*(drawScale*textPadding)
      text(self.text.str,tx,thisY,tw,thisDrawH,self.text.align,self.text.col,txtScaleOffs..(self.text.style or 1),self.text.lineSpacing,self.text.vCenter,self.text.wrap)
    end

    drawChildren(self.children)
  end
end

function Palette:draw()
  local crop = self.crop or false
  if self.visible ~= false and crop ~= true then
    local p = getCurrentPalette()
    for i, v in ipairs(self.children) do
      v.color = palette[p][i]
      v.param = palette[p][i]
    end
    drawChildren(self.children)
  end
end

function drawChildren(ch)
  if ch ~= nil then
    for i, v in ipairs(ch) do
      v:draw() -- this box draws its children
    end
  end
end

  --------- MOUSE ---------
  
function Element:mouseOver()
  doHelp(self)
  if self.moColor ~= nil then 
    self.moColorOff, self.color = self.col, self.moColor
    redraw = 1
  end
end

function Element:mouseAway()
  if self.imgFrame ~= nil then
    self.imgFrame = 0
  end
  if self.moColor ~= nil then
    self.color, self.moColorOff = self.moColorOff, nil
  end
  _helpL.y, _helpR.y = 10000,10000
  redraw = 1
end

function Element:mouseDown(x,y) end 
function Element:mouseUp(x,y) end
function Element:doubleClick() end

function Element:mouseWheel(v)
  if self.action ~= nil and type(self.param) == "table" then
    self.action({self.param[1],v})
    root:doUpdateState() -- doing a complete root:doUpdateState because other buttons might have changed state as a result of my actions.
    root:doParamGet()
    redraw = 1
  end
end

function Button:mouseOver()
  if self.img ~= nil then
    if self.imgType ~= nil and self.imgType == 3 and self.imgFrame ~= 1 then
      self.imgFrame = 1
      redraw = 1
    end
  end
  doHelp(self)
end

function Fader:mouseOver()
  if self.img ~= nil then
    if self.imgType ~= nil and self.imgType == 3 and self.imgFrame ~= 1 then
      self.imgFrame = 1
      redraw = 1
    end
  end
end

function Fader:mouseDown(x,y)
  local name,desc,value,defvalue,minvalue,maxvalue = reaper.ThemeLayout_GetParameter(self.param)
  if self.dragStart == nil then
    self.dragStart = x
    self.dragStartValue = value
  end
  local dX = x - self.dragStart
  
  if dX ~= 0 then
    local v = math.floor(dX * ((maxvalue - minvalue)/(432 * drawScale)))
    newValue = self.dragStartValue + v
    if newValue < minvalue then newValue = minvalue end
    if newValue > maxvalue then newValue = maxvalue end
    reaper.ThemeLayout_SetParameter(self.param, newValue,false)
    ctheme_param_needsave = { self.param }
    self:doUpdateState()
    self.parent:onSize()
    redraw = 1
  end
end

function FaderBg:mouseDown(x,y)
  local tmp,tmp,value,tmp,minvalue,maxvalue = reaper.ThemeLayout_GetParameter(self.param)
  local v = minvalue + math.floor(((x/drawScale-self.drawx-10)/432)*(maxvalue-minvalue))
  reaper.ThemeLayout_SetParameter(self.param,v,false)
  ctheme_param_needsave = { self.param }
  self:doUpdateState()
  self.parent:onSize()
  redraw = 1
end

function Fader:doubleClick() 
  local tmp,title,value,defValue = reaper.ThemeLayout_GetParameter(self.param)
  reaper.ThemeLayout_SetParameter(self.param,defValue, true)
  ctheme_param_needsave = nil
end

function Fader:mouseWheel(v)
  local tmp,tmp,value,tmp,minvalue,maxvalue = reaper.ThemeLayout_GetParameter(self.param)
  newValue = value + v
  if newValue < minvalue then newValue = minvalue end
  if newValue > maxvalue then newValue = maxvalue end
  reaper.ThemeLayout_SetParameter(self.param, newValue, false)
  ctheme_param_needsave = { self.param, reaper.time_precise() + .5 }
  self:doUpdateState()
  self.parent:onSize()
  redraw = 1
end

FaderBg.mouseWheel = Fader.mouseWheel

function Readout:doubleClick() 
  if self.userEntry == true then
    self.action(self)
    root:doUpdateState()
    resize = 1
    paramGet = 1
  end
end

function doHelp(self)
  if _undockedRoot.visible ~= false and lastHelpElem ~= self then
    lastHelpElem = self
    if self.helpL ~= nil then
      _helpL.y = (self.drawy or self.y) - 36
      _helpL.text.str = self.helpL
    end
    if self.helpR ~= nil then
      _helpR.y = self.drawy - 36
      _helpR.text.str = self.helpR
    end
    resize = 1
  end
end

function Button:mouseUp()
  if self.img ~= nil then
    if self.imgType ~= nil and self.imgType == 3 then
      self.imgFrame = 2
    end
  end
  if self.action ~= nil then self.action(self.param) end
  root:doUpdateState() -- doing a complete root:doUpdateState because other buttons might have changed state as a result of my actions.
  paramGet = 1
  redraw = 1
end

function SwatchHitbox:mouseOver()
  self.parent.children[12].color = {180,180,180}
  self.parent.children[13].text.col = {180,180,180}
  doHelp(self)
end

function SwatchHitbox:mouseUp()
  palette.current = self.paletteIdx
  paramGet = 1
  redraw = 1
end

function SwatchHitbox:mouseAway()
  self.parent:doParamGet()
end

function Element:hitTest(x,y)
  local thisX, thisY, thisW, thisH = self.drawx or self.x, self.drawy or self.y, self.drawW or self.w or 0, self.drawH or self.h
  local xS,yS = x / drawScale, y / drawScale
  if self.visible ~= false then
    local inrect = xS >= thisX and yS >= thisY and xS < thisX + thisW and yS < thisY + thisH
    if self.children ~= nil and (inrect == true or self.has_children_outside == 1) then
      for i,v in pairs(self.children) do
        local s = v:hitTest(x,y)
        if s ~= nil then return s end
      end
    end
    if inrect and (self.interactive ~= false or self.helpL ~= nil or self.helpR ~= nil) then
      return self
    end
  end
  return nil
end

-- Spinner label values
menuBoxVals = {'GLOBAL','TRACK','MIXER','COLORS','ENVELOPE','TRANSPORT'}
folderIndentVals = {'NONE','1/8','1/4','1/2',1,2,'MAX' }
tcpLabelVals = {'AUTO',20,50,80,110,140,170}
tcpVolVals = {'KNOB',40,70,100,130,160,190}
tcpMeterVals = {4,10,20,40,80,160,320}
tcpInVals = {'MIN',25,40,60,90,150,200}
mcpMeterExpVals = {'NONE',2,4,8}
envcpLabelVals = {'AUTO',20,50,80,110,140,170}
transRateVals = {'KNOB',80,130,160,200,250,310,380}
mcpBorderVals = {'NONE', 'LEFT EDGE', 'RIGHT EDGE', 'ROOT FOLDERS', 'AROUND FOLDERS'}
dockedMcpMeterExpVals = {'NONE','+ 2 PIXELS','+ 4 PIXELS','+ 8 PIXELS'}
undockPaletteNamesVals = {'REAPER v6', 'PRIDE','WARM','COOL','VICE','EEEK'}
controlAlignVals = {'FOLDER INDENT','ALIGNED'}
trackControlAlignVals = {'FOLDER INDENT','ALIGNED','EXTEND NAME'}

helpL_layout = 'These settings are automatically saved to your REAPER install, and '
             ..'will be used whenever you use this theme.'
helpL_customCol = 'Any assigned custom colors will be saved with your '
             ..'project, when it is saved.'
helpL_colDimming = 'This theme draws custom colors at full strength. Old '
                 ..'projects may appear very bright, dim them here.'
helpL_dock = 'REAPER will remember whether you docked this script, and where.'
helpL_applySize = 'Layout and scale assignments are part of your REAPER '
                ..'project, and will be saved when it is saved.'

helpR_help = 'Turn off this help text.'
helpR_dock = 'Dock this script in its condensed format.'
helpR_trackLabelColor = 'If a track has a custom color, use that color on the track name.'
helpR_colAdj = 'Adjust how REAPER draws the theme colors.  Mousewheel for fine '
              ..'adjustment. Double click the fader to reset. Double click the value to enter a new value.'
helpR_resetColAdj = 'Reset all of these color controls to return the theme to its unaltered state.'
helpR_indent = 'Amount to indent a panel due to its depth within your project folder '
             ..'structure.  Value chosen is used by all layouts.'
helpR_control_align = 'Choose whether to indent the panel controls when '
                   ..'folders indent, or to keep controls aligned.  '
                    ..'Value chosen is used by all layouts.'
helpR_layoutButton = 'Select which of the three layouts you wish to edit or apply.'
helpR_default = 'Indicates whether this layout is the \'default\' layout. '
              ..'To choose your default use the Options > Layouts menu or the '
              ..'Screensets/Layouts window.'
helpR_selected = 'Indicates whether one or more of the selected tracks is using this layout.'
helpR_applySize = 'Applies this layout to any selected tracks, at this size. '
                ..'REAPER may already be using a non-100% size, depending on your '
                ..'HiDPI settings.'
helpR_nameSizeEnv = 'Size of the envelopes\' name field.  If set to AUTO then, '
                  ..'while the script is running, it will adjust this to fit the '
                  ..'longest envelope name currently in your project.'
helpR_meterScale = 'Requires \'DO METER EXPANSION\' to be ticked below, and '
                 ..'the conditions you set to be met. Tracks with greater '
                 ..'than 2 channels will then expand the width of their '
                 ..'meters by the set amount of pixels (per channel), and '
                 ..'enlarge the track width to fit.'
helpR_borders = 'Adds visual separation to your mixer with borders. '
              ..'LEFT EDGE and/or RIGHT EDGE allow you to manually use layout '
              ..'assignments to add these as needed. ROOT FOLDERS draws a border on '
              ..'the left edge of root level folders, and on the right hand '
              ..'edge of the end of that folder if it is one level deep. '
              ..'AROUND FOLDERS draws borders at the start and end of every folder.'
help_pref = 'These buttons set REAPER preferences. Their settings are automatically '
          ..'saved to your REAPER install.'

helpR_recolProject = 'Assigns random colors from the palette. Tracks which share '
                   ..'a color will be given the same new color.'
helpR_choosePalette = 'Click to select a palette.'

helpR_emvMatchIndent = 'Indent with folders, matching the \'Folder Indent '
                     ..'Width\' setting on the Track Control Panel Page.'
help_playRate = 'If \'Show Play Rate\' is on, sets the size of the play rate control. '
              ..'TIP : right-click the play rate control to adjust its range.'


  --------- POPULATE ---------

apply = {}
root = Element:new(nil, {x=0,y=0,drawx=0,drawy=0,w=_gfxw,h=_gfxh,color={38,38,38}})

_wrongTheme = Element:new(root, {flexW='100%',h=30,color={51,51,51}})
Element:new(_wrongTheme, {x=6,y=2,w=26,h=26,img='icon_warning_on'})
_theme = Element:new(_wrongTheme, {x=32,y=2,w=100,h=15,text={str='',align = 4,col={129,137,137}}})
Element:new(_theme, {x=0,y=11,w=160,h=15,text={str='is not compatible with this script',align = 4,col={230,23,91}}})
_switchTheme = Button:new(_wrongTheme, {flow=true,img='button_empty',imgType=3,y=2,w=92,border='x',action=switchTheme,text={str='Switch to the#Default v6 theme', align=5,lineSpacing=9,col={129,137,137}}})


  ------ DOCKED LAYOUT -------

_dockedRoot = Element:new(root, {flexW='100%',h=_gfxh})

_pageGlobal = Element:new(_dockedRoot, {flow=true,title='GLOBAL',y=0,flexW='fill',x=0,w=-16,h=_gfxh})
Spinner:new(_pageGlobal, {flow=true,spinStyle='image',valsImage='page_titles_small',x=6,y=0,w=133,border='',action=doPageSpin,readoutParam={editPage}})
_gammaUnd = Element:new(_pageGlobal, {flow=true,x=0,y=6,w=453,h=19,color={90,94,94},helpR=helpR_colAdj,interactive=false})
_gammaUndBg =  FaderBg:new(_gammaUnd, {x=1,y=1,w=451,h=17,img='faderbg_gamma',action=doFader,param=-1000,helpR=helpR_colAdj,interactive=false})
Element:new(_gammaUndBg, {x=195,y=2,w=1,h=13,color={255,255,255,64}}) --zero line
Fader:new(_gammaUndBg, {x=1,y=-4,action=doFader,param=-1000,helpR=helpR_colAdj})
_gammaBox = Element:new(_pageGlobal, {flow=true,x=0,y=-6,w=72,h=30,border='x'})
Element:new(_gammaBox, {x=0,y=4,w=72,h=11,text={str='GAMMA',style=2,align=4,col={129,137,137}}})
Readout:new(_gammaBox,{x=0,y=16,w=52,h=11,userEntry=true,action=doFader,moColor={60,60,60},param={-1000},text={str='',align=4,col={129,137,137}}})

_saturationUnd = Element:new(_pageGlobal, {flow=true,x=0,y=6,w=453,h=19,color={90,94,94},helpR=helpR_colAdj,interactive=false})
_saturationUndBg =  FaderBg:new(_saturationUnd, {x=1,y=1,w=451,h=17,img='faderbg_saturation',action=doFader,param=-1004,helpR=helpR_colAdj,interactive=false})
Element:new(_saturationUndBg, {x=226,y=2,w=1,h=13,color={255,255,255,64}}) --zero line
Fader:new(_saturationUndBg, {x=1,y=-4,action=doFader,param=-1004,helpR=helpR_colAdj})
_saturationBox = Element:new(_pageGlobal, {flow=true,x=0,y=-6,w=72,h=30,border='x'})
Element:new(_saturationBox, {x=0,y=4,w=72,h=11,text={str='SATURATION',style=2,align=4,col={129,137,137}}})
Readout:new(_saturationBox,{x=0,y=16,w=52,h=11,userEntry=true,action=doFader,moColor={60,60,60},param={-1004},text={str='',align=4,col={129,137,137}}})

_pageTrack = Element:new(_dockedRoot, {flow=true,title='TRACK',y=0,flexW='fill',x=0,w=-16,h=_gfxh})
Spinner:new(_pageTrack, {flow=true,spinStyle='image',valsImage='page_titles_small',x=6,y=0,w=133,border='',action=doPageSpin,readoutParam={editPage}})
Spinner:new(_pageTrack, {flow=true,w=92,title='INDENT',action=paramSet,param='tcp_indent',valsTable=folderIndentVals})
Button:new(_pageTrack, {flow=true,w=45,img='layout_A',imgType=3,border='x',action=doActiveLayout,param={'tcp','A'}})
Button:new(_pageTrack, {flow=true,w=43,img='layout_B',imgType=3,action=doActiveLayout,param={'tcp','B'}})
Button:new(_pageTrack, {flow=true,w=45,img='layout_C',imgType=3,action=doActiveLayout,param={'tcp','C'}})
_applyBoxTcp = Element:new(_pageTrack, {flow=true,w=228,h=30, color={51,51,51}})
Element:new(_applyBoxTcp, {w=44,h=30,img='apply_to_sel_docked'})
apply.tcp = {Button:new(_applyBoxTcp, {flow=true,w=61,y=5,img='apply_100',imgType=3,action=applyLayout,param={'tcp',''}})}
apply.tcp[2] = Button:new(_applyBoxTcp, {flow=true,w=61,img='apply_150',imgType=3,action=applyLayout,param={'tcp','150%_'}})
apply.tcp[3] = Button:new(_applyBoxTcp, {flow=true,w=61,img='apply_200',imgType=3,action=applyLayout,param={'tcp','200%_'}})
Spinner:new(_pageTrack, {flow=true,w=104,title='NAME SIZE',border='x',action=paramSet,param='tcp_LabelSize',valsTable=tcpLabelVals})
Spinner:new(_pageTrack, {flow=true,w=118,title='VOLUME SIZE',border='x',action=paramSet,param='tcp_vol_size',valsTable=tcpVolVals})
Spinner:new(_pageTrack, {flow=true,w=110,title='METER SIZE',border='x',action=paramSet,param='tcp_MeterSize',valsTable=tcpMeterVals})
Spinner:new(_pageTrack, {flow=true,w=110,title='INPUT SIZE',border='x',action=paramSet,param='tcp_InputSize',valsTable=tcpInVals})

_pageMixer = Element:new(_dockedRoot, {flow=true,title='MIXER',y=0,flexW='fill',w=-16,h=_gfxh})
Spinner:new(_pageMixer, {flow=true,spinStyle='image',valsImage='page_titles_small',x=6,y=0,w=133,border='',action=doPageSpin,readoutParam={editPage}})
Spinner:new(_pageMixer, {flow=true,w=92,title='INDENT',border='',action=paramSet,param='mcp_indent',valsTable=folderIndentVals})
Button:new(_pageMixer, {flow=true,w=45,img='layout_A',imgType=3,border='x',action=doActiveLayout,param={'mcp','A'}})
Button:new(_pageMixer, {flow=true,w=43,img='layout_B',imgType=3,action=doActiveLayout,param={'mcp','B'}})
Button:new(_pageMixer, {flow=true,w=45,img='layout_C',imgType=3,action=doActiveLayout,param={'mcp','C'}})
_applyBoxMcp = Element:new(_pageMixer, {flow=true,w=228,h=30, color={51,51,51}})
Element:new(_applyBoxMcp, {w=44,h=30,img='apply_to_sel_docked'})
apply.mcp = {Button:new(_applyBoxMcp, {flow=true,y=5,w=61,img='apply_100',imgType=3,action=applyLayout,param={'mcp',''}})}
apply.mcp[2] = Button:new(_applyBoxMcp, {flow=true,w=61,img='apply_150',imgType=3,action=applyLayout,param={'mcp','150%_'}})
apply.mcp[3] = Button:new(_applyBoxMcp, {flow=true,w=61,img='apply_200',imgType=3,action=applyLayout,param={'mcp','200%_'}})
Spinner:new(_pageMixer, {flow=true,w=154,title='ADD BORDER',border='x',action=paramSet,param='mcp_border',valsTable=mcpBorderVals})
Spinner:new(_pageMixer, {flow=true,w=108,title='METER EXP',border='x',action=paramSet,param='mcp_meterExpSize',valsTable=mcpMeterExpVals})
Button:new(_pageMixer, {flow=true,img='show_fx',imgType=3,border='x',action=actionToggle,param=40549})
Button:new(_pageMixer, {flow=true,img='show_param',imgType=3,border='',action=actionToggle,param=40910})
Button:new(_pageMixer, {flow=true,img='show_send',imgType=3,border='',action=actionToggle,param=40557})

_pageColors = Element:new(_dockedRoot, {flow=true,title='COLORS',x=0,y=0,flexW='fill',w=-16,h=_gfxh})
Spinner:new(_pageColors, {flow=true,spinStyle='image',valsImage='page_titles_small',x=6,y=0,w=133,border='',action=doPageSpin,readoutParam={editPage}})
_palette = Palette:new(_pageColors, {flow=true,border='y',w=318,h=30,cellW=30,action=applyCustCol})
Spinner:new(_pageColors, {flow=true,border='x',w=96,title='PALETTE',action=paletteChoose,value=getCurrentPalette})
Button:new(_pageColors, {flow=true,img='color_apply_all',imgType=3,border='x',action=applyPalette})
Button:new(_pageColors, {flow=true,img='color_dim',imgType=3,border='x',action=reduceCustCol,param=true})
Button:new(_pageColors, {flow=true,img='color_dim_all',imgType=3,border='x',action=reduceCustCol,param=false})

_pageEnv = Element:new(_dockedRoot, {flow=true,title='ENVELOPE',y=0,flexW='fill',w=-16,h=_gfxh})
Spinner:new(_pageEnv, {flow=true,spinStyle='image',valsImage='page_titles_small',x=6,y=0,w=133,border='',action=doPageSpin,readoutParam={editPage}})
_applyBoxEnv = Element:new(_pageEnv, {flow=true,w=188,h=30, color={51,51,51}})
apply.envcp = {Button:new(_applyBoxEnv, {x=5,y=5,w=61,img='apply_100',imgType=3,action=applyLayout,param={'envcp',''}})}
apply.envcp[2] = Button:new(_applyBoxEnv, {flow=true,w=61,img='apply_150',imgType=3,action=applyLayout,param={'envcp','150%_'}})
apply.envcp[3] = Button:new(_applyBoxEnv, {flow=true,w=61,img='apply_200',imgType=3,action=applyLayout,param={'envcp','200%_'}})
Spinner:new(_pageEnv, {flow=true,w=106,title='NAME SIZE',border='x',action=paramSet,param='envcp_labelSize',valsTable=envcpLabelVals})
Spinner:new(_pageEnv, {flow=true,w=106,title='FADER SIZE',border='x',action=paramSet,param='envcp_fader_size',valsTable=tcpVolVals})
Button:new(_pageEnv, {flow=true,img='match_folder_indent',imgType=3,border='x',action=paramToggle,param='envcp_folder_indent'})

_pageTrans = Element:new(_dockedRoot, {flow=true,title='TRANSPORT',y=0,flexW='fill',w=-16,h=_gfxh})
Spinner:new(_pageTrans, {flow=true,spinStyle='image',valsImage='page_titles_small',x=6,y=0,w=133,border='',action=doPageSpin,readoutParam={editPage}})
_applyBoxTrans = Element:new(_pageTrans, {flow=true,w=188,h=30, color={51,51,51}})
apply.trans = {Button:new(_applyBoxTrans, {x=5,y=5,w=61,img='apply_100',imgType=3,action=applyLayout,param={'trans',''},helpL=helpL_applySize})}
apply.trans[2] = Button:new(_applyBoxTrans, {flow=true,w=61,img='apply_150',imgType=3,action=applyLayout,param={'trans','150%_'},helpL=helpL_applySize})
apply.trans[3] = Button:new(_applyBoxTrans, {flow=true,w=61,img='apply_200',imgType=3,action=applyLayout,param={'trans','200%_'},helpL=helpL_applySize})
Spinner:new(_pageTrans, {flow=true,w=106,title='RATE SIZE',border='x',action=paramSet,param='trans_rate_size',valsTable=transRateVals})
Button:new(_pageTrans, {flow=true,img='show_play_rate',imgType=3,border='x',action=actionToggle,param=40531})
Button:new(_pageTrans, {flow=true,img='center_transport',imgType=3,border='',action=actionToggle,param=40533})
Button:new(_pageTrans, {flow=true,img='time_sig',imgType=3,border='',action=actionToggle,param=40680})
Button:new(_pageTrans, {flow=true,img='next_prev',imgType=3,border='',action=actionToggle,param=40868})
Button:new(_pageTrans, {flow=true,img='play_text',imgType=3,border='',action=actionToggle,param=40532})

Button:new(_dockedRoot, {positionX='right', img='docked_edit',imgType=3,-16,y=0,w=16,action=doDock})


  ----- UNDOCKED LAYOUT ------
_undockedRoot = Element:new(root, {flexW='100%',flexH='100%'})

_pageContainer = Element:new(_undockedRoot, {positionX='center', positionY='center',x=0,y=0,w=513,h=679})

_buttonHelp = Button:new(_pageContainer, {flow=false,x=0,y=0,w=30,img='help_on',imgType=3,w=30,action=toggleHelp,helpR=helpR_help})
_unDpageSpin = Spinner:new(_pageContainer, {spinStyle='image',valsImage='page_titles',x=130,y=0,w=253,action=doPageSpin,readoutParam={editPage}})
Button:new(_pageContainer, {flow=false,x=483,y=0,img='dock',imgType=3,w=30,action=doDock,helpL=helpL_dock,helpR=helpR_dock})
Element:new(_pageContainer, {x=0,y=39,w=513,h=1,color={0,0,0}}) -- black title div

_subPageContainer = Element:new(_pageContainer, {x=0,y=40,w=513,h=639})

--GLOBAL PAGE
_pageGlobal_und = Element:new(_subPageContainer, {x=0,y=0,w=513,h=639})
Button:new(_pageGlobal_und, {flow=false,x=169,y=29,w=30,img='color_text',imgType=3,action=paramToggle,param='glb_track_label_color',helpR=helpR_trackLabelColor})
Element:new(_pageGlobal_und, {x=208,y=30,w=165,h=28,text={str='Custom color track names',style=2,align=4,col={129,137,137}},helpR=helpR_trackLabelColor})

_colAdjBoxStroke = Element:new(_pageGlobal_und, {x=0,y=88,w=513,h=475,color={51,51,51}}) -- stroke
_colAdjBox = Element:new(_colAdjBoxStroke, {x=1,y=1,w=511,h=473,color={51,51,51},helpL=helpL_layout}) -- fill
Element:new(_colAdjBox, {x=0,y=26,w=511,h=11,text={str='COLOR CONTROLS',style=2,align=5,col={129,137,137}},helpR=helpR_trackLabelColor})

_gamma = Element:new(_colAdjBox, {x=29,y=64,w=453,h=19,color={90,94,94},helpR=helpR_colAdj,interactive=false})
_gammabg =  FaderBg:new(_gamma, {x=1,y=1,w=451,h=17,img='faderbg_gamma',action=doFader,param=-1000,helpR=helpR_colAdj,interactive=false})
Element:new(_gammabg, {x=195,y=2,w=1,h=13,color={255,255,255,64}}) --zero line
Fader:new(_gammabg, {x=1,y=-4,action=doFader,param=-1000,helpR=helpR_colAdj})
Element:new(_colAdjBox, {x=29,y=90,w=72,h=11,text={str='GAMMA',style=2,align=4,col={129,137,137}},helpR=helpR_colAdj})
Readout:new(_colAdjBox,{x=101,y=88,w=52,h=15,userEntry=true,action=doFader,moColor={40,40,40},param={-1000},text={str='',align=4,col={129,137,137}},helpR=helpR_colAdj})

_hms = Element:new(_colAdjBox, {x=29,y=128,w=453,h=53,color={90,94,94},helpR=helpR_colAdj,interactive=false})
_highlightbg = FaderBg:new(_hms, {x=1,y=1,w=451,h=17,color={71,73,73},action=doFader,param=-1003,helpR=helpR_colAdj})
Element:new(_highlightbg, {x=226,y=2,w=1,h=13,color={255,255,255,64}}) --zero line
_midtonebg = FaderBg:new(_hms, {x=1,y=18,w=451,h=17,color={51,51,51},action=doFader,param=-1002,helpR=helpR_colAdj})
Element:new(_midtonebg, {x=226,y=2,w=1,h=13,color={255,255,255,64}}) --zero line
_shadowbg = FaderBg:new(_hms, {x=1,y=35,w=451,h=17,color={44,44,44},action=doFader,param=-1001,helpR=helpR_colAdj})
Element:new(_shadowbg, {x=226,y=2,w=1,h=13,color={255,255,255,64}}) --zero line
Fader:new(_highlightbg, {x=1,y=-4,action=doFader,param=-1003,helpR=helpR_colAdj})
Fader:new(_midtonebg, {x=1,y=-4,action=doFader,param=-1002,helpR=helpR_colAdj})
Fader:new(_shadowbg, {x=1,y=-4,action=doFader,param=-1001,helpR=helpR_colAdj})
Element:new(_colAdjBox, {x=29,y=188,w=72,h=11,text={str='HIGHLIGHTS',style=2,align=4,col={129,137,137}},helpR=helpR_colAdj})
Readout:new(_colAdjBox,{x=101,y=186,w=52,h=15,userEntry=true,action=doFader,moColor={40,40,40},param={-1003},text={str='',align=4,col={129,137,137}},helpR=helpR_colAdj})
Element:new(_colAdjBox, {x=192,y=188,w=72,h=11,text={str='MIDTONES',style=2,align=6,col={129,137,137}},helpR=helpR_colAdj})
Readout:new(_colAdjBox,{x=266,y=186,w=52,h=15,userEntry=true,action=doFader,moColor={40,40,40},param={-1002},text={str='',align=5,col={129,137,137}},helpR=helpR_colAdj})
Element:new(_colAdjBox, {x=358,y=188,w=72,h=11,text={str='SHADOWS',style=2,align=6,col={129,137,137}},helpR=helpR_colAdj})
Readout:new(_colAdjBox,{x=430,y=186,w=52,h=15,userEntry=true,action=doFader,moColor={40,40,40},param={-1001},text={str='',align=6,col={129,137,137}},helpR=helpR_colAdj})

_saturation = Element:new(_colAdjBox, {x=29,y=226,w=453,h=19,color={90,94,94},helpR=helpR_colAdj,interactive=false})
_saturationbg = FaderBg:new(_saturation, {x=1,y=1,w=451,h=17,img='faderbg_saturation',action=doFader,param=-1004,helpR=helpR_colAdj})
Element:new(_saturationbg, {x=226,y=2,w=1,h=13,color={255,255,255,64}}) --zero line
Fader:new(_saturationbg, {x=1,y=-4,action=doFader,param=-1004,helpR=helpR_colAdj})
Element:new(_colAdjBox, {x=29,y=252,w=72,h=11,text={str='SATURATION',style=2,align=4,col={129,137,137}},helpR=helpR_colAdj})
Readout:new(_colAdjBox,{x=101,y=250,w=62,h=15,userEntry=true,action=doFader,moColor={40,40,40},param={-1004},text={str='',align=4,col={129,137,137}},helpR=helpR_colAdj})

_tint = Element:new(_colAdjBox, {x=29,y=290,w=453,h=19,color={90,94,94},helpR=helpR_colAdj,interactive=false})
_tintbg = FaderBg:new(_tint, {x=1,y=1,w=451,h=17,img='faderbg_tint',action=doFader,param=-1005,helpR=helpR_colAdj})
Element:new(_tintbg, {x=226,y=2,w=1,h=13,color={255,255,255,64}}) --zero line
Fader:new(_tintbg, {x=1,y=-4,action=doFader,param=-1005,helpR=helpR_colAdj})
Element:new(_colAdjBox, {x=29,y=316,w=72,h=11,text={str='TINT',style=2,align=4,col={129,137,137}},helpR=helpR_colAdj})
Readout:new(_colAdjBox,{x=101,y=314,w=62,h=15,userEntry=true,action=doFader,moColor={40,40,40},param={-1005},text={str='',align=4,col={129,137,137}},helpR=helpR_colAdj})

Button:new(_colAdjBox, {x=140,y=356,w=30,img='color_apply_all',imgType=3,action=paramToggle,param=-1006})
Element:new(_colAdjBox, {x=179,y=356,w=330,h=30,text={str='Also affect project custom colors',style=2,align=4,col={129,137,137}}})
Button:new(_colAdjBox, {flow=false,x=140,y=415,w=30,img='bin',imgType=3,action=resetColorControls,helpR=helpR_resetColAdj})
Element:new(_colAdjBox, {x=179,y=415,w=165,h=28,text={str='Reset all color controls',style=2,align=4,col={129,137,137}},helpR=helpR_resetColAdj})

--TRACK PAGE
_pageTrack_und = Element:new(_subPageContainer, {x=0,y=0,w=513,h=639})
Spinner:new(_pageTrack_und, {x=61,y=19,w=165,title='FOLDER INDENT',action=paramSet,param='tcp_indent',valsTable=folderIndentVals,helpR=helpR_indent,helpL=helpL_layout})
Spinner:new(_pageTrack_und, {x=287,y=19,w=165,title='ALIGN CONTROLS',action=paramSet,param='tcp_control_align',valsTable=trackControlAlignVals,helpR=helpR_control_align,helpL=helpL_layout})
_layoutTrackStroke = Element:new(_pageTrack_und, {x=0,y=153,w=513,h=486,color={129,137,137}}) -- stroke

_tcpButLayA = Button:new(_pageTrack_und, {x=30,y=65,w=69,img='layout_docked_A',imgType=3,action=doActiveLayout,param={'tcp','A'},helpR=helpR_layoutButton})
_tcpButLayB = Button:new(_pageTrack_und, {x=103,y=65,w=69,img='layout_docked_B',imgType=3,action=doActiveLayout,param={'tcp','B'},helpR=helpR_layoutButton})
_tcpButLayC = Button:new(_pageTrack_und, {x=176,y=65,w=69,img='layout_docked_C',imgType=3,action=doActiveLayout,param={'tcp','C'},helpR=helpR_layoutButton})
Readout:new(_tcpButLayA, {x=7,y=53,w=55,h=12,text={str='DEFAULT',style=1,align=5,colFalse={45,79,91},colTrue={19,189,153}},updateState=isDefault,getParam={'tcp','A'},helpR=helpR_default})
Readout:new(_tcpButLayB, {x=7,y=53,w=55,h=12,text={str='DEFAULT',style=1,align=5,colFalse={45,79,91},colTrue={19,189,153}},updateState=isDefault,getParam={'tcp','B'},helpR=helpR_default})
Readout:new(_tcpButLayC, {x=7,y=53,w=55,h=12,text={str='DEFAULT',style=1,align=5,colFalse={45,79,91},colTrue={19,189,153}},updateState=isDefault,getParam={'tcp','C'},helpR=helpR_default})
Readout:new(_tcpButLayA, {x=7,y=65,w=55,h=12,text={str='SELECTED',style=1,align=5,colFalse={90,94,94},colTrue={193,197,197}},updateState=anySelected,getParam={'tcp','A'},helpR=helpR_selected})
Readout:new(_tcpButLayB, {x=7,y=65,w=55,h=12,text={str='SELECTED',style=1,align=5,colFalse={90,94,94},colTrue={193,197,197}},updateState=anySelected,getParam={'tcp','B'},helpR=helpR_selected})
Readout:new(_tcpButLayC, {x=7,y=65,w=55,h=12,text={str='SELECTED',style=1,align=5,colFalse={90,94,94},colTrue={193,197,197}},updateState=anySelected,getParam={'tcp','C'},helpR=helpR_selected})

_applyStroke_Track = Element:new(_pageTrack_und, {x=274,y=64,w=239,h=89,color={129,137,137}}) -- stroke
_applyBox_Track = Element:new(_applyStroke_Track, {x=1,y=1,w=237,h=89,color={51,51,51},helpL=helpL_applySize}) -- fill
apply.und = {tcp={Button:new(_applyBox_Track, {x=29,y=29,w=61,img='apply_100',imgType=3,action=applyLayout,param={'tcp',''},helpR=helpR_applySize,helpL=helpL_applySize})}}
apply.und.tcp[2] = Button:new(_applyBox_Track, {x=90,y=29,w=61,img='apply_150',imgType=3,action=applyLayout,param={'tcp','150%_'},helpR=helpR_applySize,helpL=helpL_applySize})
apply.und.tcp[3] = Button:new(_applyBox_Track, {x=151,y=29,w=61,img='apply_200',imgType=3,action=applyLayout,param={'tcp','200%_'},helpR=helpR_applySize,helpL=helpL_applySize})
Element:new(_applyBox_Track, {x=40,y=66,w=153,h=7,img='apply_to_sel'})

_layoutTrack = Element:new(_layoutTrackStroke, {x=1,y=1,w=511,h=484,color={51,51,51},helpL=helpL_layout}) -- fill
Spinner:new(_layoutTrack, {x=29,y=29,w=119,title='NAME SIZE',action=paramSet,param='tcp_LabelSize',valsTable=tcpLabelVals})
Spinner:new(_layoutTrack, {x=71,y=70,w=163,title='METER SIZE',action=paramSet,param='tcp_MeterSize',valsTable=tcpMeterVals})
Spinner:new(_layoutTrack, {x=363,y=29,w=119,title='INPUT SIZE',action=paramSet,param='tcp_InputSize',valsTable=tcpInVals})
Spinner:new(_layoutTrack, {x=192,y=29,w=127,title='VOLUME SIZE',action=paramSet,param='tcp_vol_size',valsTable=tcpVolVals})
tcpMeterLocVals = {'LEFT','RIGHT','LEFT IF ARMED'}
Spinner:new(_layoutTrack, {x=278,y=70,w=163,title='METER LOCATION',action=paramSet,param='tcp_MeterLoc',valsTable=tcpMeterLocVals})

tcpTableVals = {img = 'cell_hide',
                columns = {{visFlag=1,text={str='IF MIXER#IS VISIBLE'}},{visFlag=2,text={str='IF TRACK#NOT SELECTED'}},
                        {visFlag=4,text={str='IF TRACK#NOT ARMED'}},{visFlag=8,text={str='ALWAYS#HIDE',col={204,69,114}}}},
                rows = {{param='tcp_Record_Arm',text={str='RECORD ARM'},img='key_recarm'},
                        {param='tcp_Monitor',text={str='MONITOR'},img='key_mon'},{param='tcp_Track_Name',text={str='TRACK NAME'}},
                        {param='tcp_Volume',text={str='VOLUME'},img='key_vol'},{param='tcp_Routing',text={str='ROUTING'},img='key_route'},
                        {param='tcp_Effects',text={str='INSERT FX'},img='key_fx'},{param='tcp_Envelope',text={str='ENVELOPE'},img='key_env'},
                        {param='tcp_Pan_&_Width',text={str='PAN & WIDTH'},img='key_pan'},{param='tcp_Record_Mode',text={str='RECORD MODE'},img='key_recmode'},
                        {param='tcp_Input',text={str='INPUT'},img='key_recinput'},{param='tcp_Values',text={str='LABELS & VALUES'}},
                        {param='tcp_Meter_Values',text={str='METER VALUES'}}}
}
_trackTable = ParamTable:new(_layoutTrack, {x=29,y=125,w=453,h=330,valsTable=tcpTableVals})

--MIXER PAGE
_pageMixer_und = Element:new(_subPageContainer, {x=0,y=0,w=513,h=639})
Spinner:new(_pageMixer_und, {x=61,y=19,w=165,title='FOLDER INDENT',action=paramSet,param='mcp_indent',valsTable=folderIndentVals,helpR=helpR_indent,helpL=helpL_layout})
Spinner:new(_pageMixer_und, {x=287,y=19,w=165,title='ALIGN CONTROLS',action=paramSet,param='mcp_control_align',valsTable=controlAlignVals,helpR=helpR_control_align,helpL=helpL_layout})
_mixerTopStroke = Element:new(_pageMixer_und, {x=0,y=153,w=513,h=245,color={129,137,137}}) -- stroke

_mcpButLayA = Button:new(_pageMixer_und, {x=30,y=65,w=69,img='layout_docked_A',imgType=3,action=doActiveLayout,param={'mcp','A'},helpR=helpR_layoutButton})
_mcpButLayB = Button:new(_pageMixer_und, {x=103,y=65,w=69,img='layout_docked_B',imgType=3,action=doActiveLayout,param={'mcp','B'},helpR=helpR_layoutButton})
_mcpButLayC = Button:new(_pageMixer_und, {x=176,y=65,w=69,img='layout_docked_C',imgType=3,action=doActiveLayout,param={'mcp','C'},helpR=helpR_layoutButton})
Readout:new(_mcpButLayA, {x=7,y=53,w=55,h=12,text={str='DEFAULT',style=1,align=5,colFalse={45,79,91},colTrue={19,189,153}},updateState=isDefault,getParam={'mcp','A'},helpR=helpR_default})
Readout:new(_mcpButLayB, {x=7,y=53,w=55,h=12,text={str='DEFAULT',style=1,align=5,colFalse={45,79,91},colTrue={19,189,153}},updateState=isDefault,getParam={'mcp','B'},helpR=helpR_default})
Readout:new(_mcpButLayC, {x=7,y=53,w=55,h=12,text={str='DEFAULT',style=1,align=5,colFalse={45,79,91},colTrue={19,189,153}},updateState=isDefault,getParam={'mcp','C'},helpR=helpR_default})
Readout:new(_mcpButLayA, {x=7,y=65,w=55,h=12,text={str='SELECTED',style=1,align=5,colFalse={90,94,94},colTrue={193,197,197}},updateState=anySelected,getParam={'mcp','A'},helpR=helpR_selected})
Readout:new(_mcpButLayB, {x=7,y=65,w=55,h=12,text={str='SELECTED',style=1,align=5,colFalse={90,94,94},colTrue={193,197,197}},updateState=anySelected,getParam={'mcp','B'},helpR=helpR_selected})
Readout:new(_mcpButLayC, {x=7,y=65,w=55,h=12,text={str='SELECTED',style=1,align=5,colFalse={90,94,94},colTrue={193,197,197}},updateState=anySelected,getParam={'mcp','C'},helpR=helpR_selected})

_applyStroke_Mixer = Element:new(_pageMixer_und, {x=274,y=64,w=239,h=89,color={129,137,137},helpL=helpL_applySize}) -- stroke
_applyBox_Mixer = Element:new(_applyStroke_Mixer, {x=1,y=1,w=237,h=89,color={51,51,51},helpL=helpL_applySize}) -- fill
apply.und.mcp = {Button:new(_applyBox_Mixer, {x=29,y=29,w=61,img='apply_100',imgType=3,action=applyLayout,param={'mcp',''},helpR=helpR_applySize,helpL=helpL_applySize})}
apply.und.mcp[2] = Button:new(_applyBox_Mixer, {x=90,y=29,w=61,img='apply_150',imgType=3,action=applyLayout,param={'mcp','150%_'},helpR=helpR_applySize,helpL=helpL_applySize})
apply.und.mcp[3] = Button:new(_applyBox_Mixer, {x=151,y=29,w=61,img='apply_200',imgType=3,action=applyLayout,param={'mcp','200%_'},helpR=helpR_applySize,helpL=helpL_applySize})
Element:new(_applyBox_Mixer, {x=40,y=66,w=153,h=7,img='apply_to_sel'})

_mixerTop = Element:new(_mixerTopStroke, {x=1,y=1,w=511,h=243,color={51,51,51},helpL=helpL_layout}) -- fill
Spinner:new(_mixerTop, {x=69,y=29,w=163,title='ADD BORDER',action=paramSet,param='mcp_border',valsTable=mcpBorderVals,helpR=helpR_borders})
Spinner:new(_mixerTop, {x=285,y=29,w=157,title='METER EXPANSION',action=paramSet,param='mcp_meterExpSize',valsTable=dockedMcpMeterExpVals,helpR=helpR_meterScale})

mcpTableVals = {img = 'cell_tick',
                columns = {{visFlag=1,text={str='IF TRACK#SELECTED'}},{visFlag=2,text={str='IF TRACK#NOT SELECTED'}},
                        {visFlag=4,text={str='IF TRACK#ARMED'}},{visFlag=8,text={str='IF TRACK#NOT ARMED'}}},
                rows = {{param='mcp_Sidebar',text={str='EXTEND WITH SIDEBAR', helpR=helpR_sidebar}},
                        {param='mcp_Narrow',text={str='NARROW FORM'}},{param='mcp_Meter_Expansion',text={str='DO METER EXPANSION'}},
                        {param='mcp_Labels',text={str='ELEMENT LABELS'}}}
}
_mixerTable = ParamTable:new(_mixerTop, {x=29,y=84,w=453,h=130,valsTable=mcpTableVals})

_mLower = Element:new(_pageMixer_und, {x=0,y=427,w=513,h=212,color={129,137,137}}) -- stroke
_extMixerf = Element:new(_mLower, {x=1,y=1,w=255,h=210,color={38,38,38},helpL=help_pref}) -- fill
Element:new(_extMixerf, {x=29,y=24,w=173,h=30,text={str='EXTENDED MIXER CONTROLS#when size permits',style=2,align=4,col={129,137,137}}})
Button:new(_extMixerf, {x=29,y=65,w=30,img='show_fx',imgType=3,action=actionToggle,param=40549})
Element:new(_extMixerf, {x=68,y=65,w=172,h=30,text={str='Show FX Inserts',style=2,align=4,col={129,137,137}}})
Button:new(_extMixerf, {x=29,y=108,w=30,img='show_param',imgType=3,action=actionToggle,param=40910})
Element:new(_extMixerf, {x=68,y=108,w=172,h=30,text={str='Show FX Parameters',style=2,align=4,col={129,137,137}}})
Button:new(_extMixerf, {x=29,y=151,w=30,img='show_send',imgType=3,action=actionToggle,param=40557})
Element:new(_extMixerf, {x=68,y=151,w=172,h=30,text={str='Show Sends',style=2,align=4,col={129,137,137}}})

_parmMixer = Element:new(_mLower, {x=256,y=1,w=256,h=210,color={51,51,51},helpL=help_pref}) -- fill
Button:new(_parmMixer, {x=29,y=65,w=30,img='multi_row',imgType=3,action=actionToggle,param=40371})
Element:new(_parmMixer, {x=68,y=65,w=172,h=30,text={str='Show Multiple-row Mixer#when size permits',style=2,align=4,col={129,137,137}}})
Button:new(_parmMixer, {x=29,y=108,w=30,img='scroll_sel',imgType=3,action=actionToggle,param=40221})
Element:new(_parmMixer, {x=68,y=108,w=172,h=30,text={str='Scroll to selected track',style=2,align=4,col={129,137,137}}})
Button:new(_parmMixer, {x=29,y=151,w=30,img='show_icons',imgType=3,action=actionToggle,param=40903})
Element:new(_parmMixer, {x=68,y=151,w=172,h=30,text={str='Show Icons',style=2,align=4,col={129,137,137}}})

--COLOR PAGE
_pageColor_und = Element:new(_subPageContainer, {x=0,y=40,w=513,h=639})
_paletteBoxStroke = Element:new(_pageColor_und, {x=0,y=0,w=513,h=425,color={129,137,137}}) -- stroke
_paletteBox = Element:new(_paletteBoxStroke, {x=1,y=1,w=511,h=205,color={51,51,51},helpL=helpL_customCol}) -- fill

Readout:new(_paletteBox, {x=124,y=19,w=263,h=30,param={'scriptVariable',palette.current},text={str='REAPER V6',style=4,align=5,col={129,137,137}},valsTable=undockPaletteNamesVals})

Element:new(_paletteBox, {x=30,y=49,w=450,h=1,color={35,35,35}}) --div above
_palette = Palette:new(_paletteBox, {x=30,y=58,w=450,h=45,cellW=45,img='color_apply_large',action=applyCustCol})
Element:new(_paletteBox, {x=30,y=111,w=450,h=1,color={35,35,35}}) --div below
Element:new(_paletteBox, {x=0,y=112,w=511,h=30,text={str='Click a color to apply it to all selected tracks',style=3,align=5,col={129,137,137}}})
Button:new(_paletteBox, {x=140,y=146,w=30,img='color_apply_all',imgType=3,action=applyPalette,helpR=helpR_recolProject})
Element:new(_paletteBox, {x=179,y=146,w=330,h=30,text={str='Recolor project using this palette',style=2,align=4,col={129,137,137}},helpR=helpR_recolProject})
_paletteMenuBox = Element:new(_paletteBoxStroke, {x=1,y=205,w=511,h=218,color={38,38,38}}) -- fill

-- add swatches
Swatch:new(_paletteMenuBox,{x=29,y=29,paletteIdx=1})
Swatch:new(_paletteMenuBox,{x=29,y=92,paletteIdx=3})
Swatch:new(_paletteMenuBox,{x=29,y=155,paletteIdx=5})
Swatch:new(_paletteMenuBox,{x=282,y=29,paletteIdx=2})
Swatch:new(_paletteMenuBox,{x=282,y=92,paletteIdx=4})
Swatch:new(_paletteMenuBox,{x=282,y=155,paletteIdx=6})

Button:new(_pageColor_und, {x=144,y=464,img='color_dim_all',imgType=3,action=reduceCustCol,param=false,helpR=helpL_colDimming})
Element:new(_pageColor_und, {x=183,y=464,w=330,h=30,text={str='Dim all assigned custom colors',style=2,align=4,col={129,137,137}},helpR=helpL_colDimming})
Button:new(_pageColor_und, {x=144,y=507,w=30,img='color_dim',imgType=3,action=reduceCustCol,param=true,helpR=helpL_colDimming})
Element:new(_pageColor_und, {x=183,y=507,w=330,h=30,text={str='Dim custom colors on selected tracks',style=2,align=4,col={129,137,137}},helpR=helpL_colDimming})

--ENV & TRANSPORT PAGE
_pageEnvTrans_und = Element:new(_subPageContainer, {x=0,y=40,w=513,h=639,helpL=helpL_layout})
apply.und.envcp = {Button:new(_pageEnvTrans_und, {x=166,y=2,w=61,img='apply_100',imgType=3,action=applyLayout,param={'envcp',''},helpL=helpL_applySize})}
apply.und.envcp[2] = Button:new(_pageEnvTrans_und, {x=228,y=2,w=61,img='apply_150',imgType=3,action=applyLayout,param={'envcp','150%_'},helpL=helpL_applySize})
apply.und.envcp[3] = Button:new(_pageEnvTrans_und, {x=290,y=2,w=61,img='apply_200',imgType=3,action=applyLayout,param={'envcp','200%_'},helpL=helpL_applySize})
Spinner:new(_pageEnvTrans_und, {x=97,y=55,w=120,title='NAME SIZE',action=paramSet,param='envcp_labelSize',valsTable=envcpLabelVals,helpR=helpR_nameSizeEnv})
Spinner:new(_pageEnvTrans_und, {x=283,y=55,w=120,title='FADER SIZE',action=paramSet,param='envcp_fader_size',valsTable=tcpVolVals})
Button:new(_pageEnvTrans_und, {flow=false,x=170,y=110,w=30,img='match_folder_indent',imgType=3,action=paramToggle,param='envcp_folder_indent',helpR=helpR_emvMatchIndent})
Element:new(_pageEnvTrans_und, {x=209,y=110,w=150,h=30,text={str='Match track folder indent',style=2,align=4,col={129,137,137}},helpR=helpR_emvMatchIndent})

Element:new(_pageEnvTrans_und, {x=210,y=252,w=94,h=23,img='transport_title'})
Element:new(_pageEnvTrans_und, {x=0,y=286,w=513,h=1,color={0,0,0}}) -- black title div
apply.und.trans = {Button:new(_pageEnvTrans_und, {x=166,y=318,w=61,img='apply_100',imgType=3,action=applyLayout,param={'trans',''},helpL=helpL_applySize})}
apply.und.trans[2] = Button:new(_pageEnvTrans_und, {x=228,y=318,w=61,img='apply_150',imgType=3,action=applyLayout,param={'trans','150%_'},helpL=helpL_applySize})
apply.und.trans[3] = Button:new(_pageEnvTrans_und, {x=290,y=318,w=61,img='apply_200',imgType=3,action=applyLayout,param={'trans','200%_'},helpL=helpL_applySize})
Spinner:new(_pageEnvTrans_und, {x=182,y=372,w=149,title='PLAY RATE SIZE',action=paramSet,param='trans_rate_size',valsTable=transRateVals,helpR=help_playRate,helpL=helpL_layout})

_transPrefsStroke = Element:new(_pageEnvTrans_und, {x=0,y=431,w=513,h=176,color={129,137,137}}) -- stroke
_transPrefs = Element:new(_transPrefsStroke, {x=1,y=1,w=511,h=174,color={38,38,38},helpL=helpL_pref}) -- fill

Button:new(_transPrefs, {x=192,y=26,img='center_transport',imgType=3,action=actionToggle,param=40533})
Element:new(_transPrefs, {x=231,y=26,w=150,h=30,text={str='Center transport',style=2,align=4,col={129,137,137}}})
Button:new(_transPrefs, {x=29,y=69,img='show_play_rate',imgType=3,action=actionToggle,param=40531})
Element:new(_transPrefs, {x=68,y=69,w=150,h=30,text={str='Show Play Rate',style=2,align=4,col={129,137,137}}})
Button:new(_transPrefs, {x=29,y=112,img='time_sig',imgType=3,action=actionToggle,param=40680})
Element:new(_transPrefs, {x=68,y=112,w=150,h=30,text={str='Show Time Signature',style=2,align=4,col={129,137,137}}})
Button:new(_transPrefs, {x=285,y=69,img='next_prev',imgType=3,action=actionToggle,param=40868})
Element:new(_transPrefs, {x=324,y=69,w=150,h=30,text={str='Use Home/End for Markers',style=2,align=4,col={129,137,137}}})
Button:new(_transPrefs, {x=285,y=112,img='play_text',imgType=3,action=actionToggle,param=40532})
Element:new(_transPrefs, {x=324,y=112,w=150,h=30,text={str='Show play state as text',style=2,align=4,col={129,137,137}}})

--HELP
_helpL = Element:new(_pageContainer, {x=-144,y=500,w=115,h=200,text={str='',style=2,align=2,wrap=true,vCenter=false,lineSpacing=14,col={129,137,137}}})
Element:new(_helpL, {x=18,y=-25,w=97,h=19,img='helpHeader_l'})
_helpR = Element:new(_pageContainer, {x=542,y=200,w=115,h=200,text={str='Show play state',style=2,align=0,wrap=true,vCenter=false,lineSpacing=14,col={129,137,137}}})
Element:new(_helpR, {x=0,y=-25,w=97,h=19,img='helpHeader_r'})

  --------- RUNLOOP ---------

needReaperStateUpdate = 1
paramGet = 1
resize = 1
redraw = 1
lastchgidx = 0
chgsel = 1
oldTheme = nil
mouseXold = 0
mouseYold = 0
mouseWheelAccum = 0 -- accumulated unused wheeling
trackNames = {}
trackNamesW = {}
envcp_LabelMeasureIdx = nil
tcpLayouts = {}
envs = {}
selectedTracks = {}
activeMouseElement = nil
_helpL.y, _helpR.y = 10000,10000
editPage = tonumber(reaper.GetExtState(sTitle,'editPage')) or 1
dpi = 1
drawScale = 1

indexParams()
themeCheck()
getDock()
doActivePage()
doActiveLayout()
doHelpVis()

function runloop()

  themeCheck()
  getDock()
  if gfx.ext_retina ~= dpi then getDpi() end

  chgidx = reaper.GetProjectStateChangeCount(0)
  if chgidx ~= lastchgidx then
    if #trackNames ~= (reaper.CountTracks(0)-1) then -- the track count has changed, rebuild from scratch
      trackNames = {}
      envs = {}
      tcpLayouts = {}
      selectedTracks = {}
    end
    needReaperStateUpdate = 1
    lastchgidx = chgidx
  end

  if _wrongTheme.visible ~= true then
    if needReaperStateUpdate == 1 then
      doActivePage()
      local trackCount = reaper.CountTracks(0)-1
      measureTrackNames(trackCount)
      measureEnvNames(trackCount)
      redraw = 1
    end
    needReaperStateUpdate_cnt = (needReaperStateUpdate_cnt or 0) + 1
    if needReaperStateUpdate == 1 or needReaperStateUpdate_cnt > 3 then
      getReaperDpi()
      root:doUpdateState()
      needReaperStateUpdate_cnt = 0
      needReaperStateUpdate = 0
    end
  end

  -- mouse stuff
  local isCap = (gfx.mouse_cap&1)
  now = reaper.time_precise()
  
  if gfx.mouse_x ~= mouseXold or gfx.mouse_y ~= mouseYold or (firstClick ~= nil and last_click_time ~= nil and last_click_time+.25 < now) then
    firstClick = nil
  end
  
  if gfx.mouse_x ~= mouseXold or gfx.mouse_y ~= mouseYold or isCap ~= mouseCapOld or gfx.mouse_wheel ~= 0  then
    local wheel_amt = 0
    if gfx.mouse_wheel ~= 0 then
      mouseWheelAccum = mouseWheelAccum + gfx.mouse_wheel
      gfx.mouse_wheel = 0
      wheel_amt = math.floor(mouseWheelAccum / 120 + 0.5)
      if wheel_amt ~= 0 then mouseWheelAccum = 0 end
    end

    local hit = root:hitTest(gfx.mouse_x,gfx.mouse_y)
    if isCap == 0 and mouseCapOld == 1 then -- mouse-up
      if activeMouseElement ~= nil and hit == activeMouseElement then -- still over element
        activeMouseElement:mouseUp(gfx.mouse_x,gfx.mouse_y)
      end
      if activeMouseElement ~= nil and activeMouseElement.dragStart ~= nil then
        activeMouseElement.dragStart, activeMouseElement.dragStartValue = nil, nil
      end
    end

    if isCap == 0 or mouseCapOld == 0 then -- uncaptured mouse-down or mouse-move
      if activeMouseElement ~= nil and activeMouseElement ~= hit then
        activeMouseElement:mouseAway()
      end
      activeMouseElement = hit 
    end

    if activeMouseElement ~= nil then

      if isCap == 0 or mouseCapOld == 0 then -- uncaptured mouse-down or mouse-move
        activeMouseElement:mouseOver()
      end
      if wheel_amt ~= 0 then
        activeMouseElement:mouseWheel(wheel_amt)
      end
      
      if isCap == 1 then
        local x,y = gfx.mouse_x,gfx.mouse_y
        activeMouseElement:mouseDown(gfx.mouse_x,gfx.mouse_y)
        
        if firstClick == nil or last_click_time == nil then 
          firstClick = {gfx.mouse_x,gfx.mouse_y}
          last_click_time = now
        else if now < last_click_time+.25 and math.abs((x-firstClick[1])*(x-firstClick[1]) + (y- firstClick[2])*(y- firstClick[2])) < 4 then 
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

  if paramGet == 1 then
    root:doParamGet()
    paramGet = 0
  end

  if resize == 1 or root.drawW ~= gfx.w*drawScale_inv_mac or root.drawH ~= gfx.h*drawScale_inv_mac then -- window resized
    root.drawW, root.drawH = gfx.w*drawScale_inv_mac,gfx.h*drawScale_inv_mac
    root:onSize()
    root:draw()
    resize,redraw = 0,0
  elseif redraw == 1 then
    root:draw()
    redraw = 0
  end

  if ctheme_param_needsave ~= nil then
    if (gfx.mouse_cap&1)==0 and (ctheme_param_needsave[2] == nil or now > ctheme_param_needsave[2]) then
      local tmp,tmp,value = reaper.ThemeLayout_GetParameter(ctheme_param_needsave[1])
      reaper.ThemeLayout_SetParameter(ctheme_param_needsave[1],value,true) 
      ctheme_param_needsave = nil
    end
  end

  gfx.update()
  local c = gfx.getchar()
  if c >= 0 then
    if c == 25 or (c == 26 and (gfx.mouse_cap&8)==8) then  -- ctrl+y or ctrl+shift+z
      reaper.Main_OnCommand(40030,0) -- redo
    elseif c == 26 then -- ctrl+z
      reaper.Main_OnCommand(40029,0) -- undo
    end
    reaper.runloop(runloop)
  end
end

gfx.clear = 0x454545
getDpi()
runloop()
redraw = 1 -- temporary workaround of REAPER bug

function storeTable(title,table,parent)
  for i, v in pairs(table) do
    local p = ''
    if parent~=nil then p = parent..'.' end
    if type(v)=='table' then storeTable(title,v,i) else reaper.SetExtState(sTitle,title..'.'..p..i,v,true) end
  end
end

function Quit()
  d,x,y,w,h=gfx.dock(-1,0,0,0,0)
  reaper.SetExtState(sTitle,"dock",d,true)
  reaper.SetExtState(sTitle,"wndx",x,true)
  reaper.SetExtState(sTitle,"wndy",y,true)
  reaper.SetExtState(sTitle,'editPage',editPage,true)
  reaper.SetExtState(sTitle,'paletteCurrent',palette.current,true)
  reaper.SetExtState(sTitle,'activeLayoutTcp',activeLayout.tcp,true)
  reaper.SetExtState(sTitle,'activeLayoutMcp',activeLayout.mcp,true)
  gfx.quit()
end
reaper.atexit(Quit)
