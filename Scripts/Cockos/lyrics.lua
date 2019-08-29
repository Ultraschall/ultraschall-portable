_gfxw,_gfxh,_th=800,600,0
_bg,_mg,_fg={1,1,1},{0.875,0.875,0.875},{0,0,0}
_font,_selfont,_toolfont={"verdana",18},{"verdana",20},{"verdana",14}
DEF,SEL,TOOL=1,2,3
_track=nil
_trackrect,_editrect={0,0,0,0},{0,0,0,0}
_cureditrect,_scrollrect={0,0,0,0},{0,0,0,0}
_exportrect,_importrect={0,0,0,0},{0,0,0,0}
_beatrect={0,0,0,0}
_lyrics,_tsnum={},{}
_origlyric=""
_scrollm,_pagem,_maxm=1,8,8
_playstate,_curm,_curb=0,1,1
_beatdiv=1.0
_editing,_mousedown=false,false
_mousex,_mousey=0,0
_scrollcapm,_scrollcapy=0,0
_mousedowntime=0.0
_capm,_capb=1,1
_caret={1,0}
_clock=0
_bullet=utf8.char(0x2219) -- 0x2022 or 0x2219
_downarrow=utf8.char(0x23F7)  -- 0x2BC6 or 0x23F7
ENSURE_MIDI_ITEMS,IMPORT_LYRICS,EXPORT_LYRICS=42069,42070,42071

gfx.init("MIDI Lyrics", 
  tonumber(reaper.GetExtState("lyrics","wndw")) or _gfxw,
  tonumber(reaper.GetExtState("lyrics","wndh")) or _gfxh,
  tonumber(reaper.GetExtState("lyrics","dock")) or 0,
  tonumber(reaper.GetExtState("lyrics","wndx")) or 100,
  tonumber(reaper.GetExtState("lyrics","wndy")) or 100)
  
function SetFonts(dsz)
  if dsz ~= nil and dsz ~= "" then
    _font[2]=_font[2]+dsz
    _selfont[2]=_selfont[2]+dsz
    _toolfont[2]=_toolfont[2]+dsz      
  end
  gfx.setfont(DEF,_font[1],_font[2])
  _th=gfx.texth
  gfx.setfont(SEL,_selfont[1],_selfont[2],string.byte("b"))
  gfx.setfont(TOOL,_toolfont[1],_toolfont[2])
end

function Quit()
  d,x,y,w,h=gfx.dock(-1,0,0,0,0)
  reaper.SetExtState("lyrics","wndw",w,true)
  reaper.SetExtState("lyrics","wndh",h,true)
  reaper.SetExtState("lyrics","dock",d,true)
  reaper.SetExtState("lyrics","wndx",x,true)
  reaper.SetExtState("lyrics","wndy",y,true)  
  reaper.SetExtState("lyrics","fontsz",_font[2]-18,true)
  gfx.quit()
end
reaper.atexit(Quit)

function GetLyric(m,b)
  str=_lyrics[m][b]
  return (str == bullet and "" or str)
end

function DrawString(str,rect,iscentered)
  gfx.x,gfx.y=rect[1],rect[2]
  flag=(iscentered == true and 4|1 or 4)
  gfx.drawstr(str,flag,rect[3],rect[4])
end

function DrawEditingText(str,rect)
  w,h=gfx.measurestr(str)
  if rect[3] < rect[1]+w+_th then rect[3]=rect[1]+w+_th end
  _cureditrect={rect[1]-_th/2,rect[2],rect[3]-_th/2,rect[4]}
  DrawBox(_cureditrect,"",false)
  gfx.x,gfx.y=rect[1],rect[2]+(rect[4]-rect[2]-_th)/2      
  
  sc,ec=_caret[1],_caret[1]+_caret[2]
  if sc > ec then sc,ec=ec,sc end
  if sc < 1 then sc=1 end
  if ec > str:len()+1 then ec=str:len()+1 end
  gfx.set(_fg[1],_fg[2],_fg[3])   
  if sc > 1 then gfx.drawstr(str:sub(1,sc-1)) end

  if ec > sc then -- selected text
    selw=gfx.measurestr(str:sub(sc,ec-1))    
    gfx.rectto(gfx.x+selw,gfx.y+_th)
    gfx.x,gfx.y=gfx.x-selw,gfx.y-_th
    gfx.set(_bg[1],_bg[2],_bg[3])
    gfx.drawstr(str:sub(sc,ec-1))
  else -- I-beam
    if _clock&1 == 1 then gfx.set(_fg[1],_fg[2],_fg[3])
    else gfx.set(_bg[1],_bg[2],_bg[3])
    end 
    gfx.lineto(gfx.x,gfx.y+_th)
    gfx.y=gfx.y-_th
  end
  
  gfx.set(_fg[1],_fg[2],_fg[3])  
  gfx.drawstr(str:sub(ec))     
end

function GetEditCaret(x,y)
  str=GetLyric(_capm,_capb)
  sx=_cureditrect[1]+_th/4
  for i=1,str:len() do
    w=gfx.measurestr(str:sub(1,i))
    if x < sx+w then return i end
  end
  return str:len()+1
end

function DrawBox(rect,str,iscombo)
  gfx.set(_mg[1],_mg[2],_mg[3])
  gfx.rect(rect[1],rect[2],rect[3]-rect[1],rect[4]-rect[2])
  gfx.set(_fg[1],_fg[2],_fg[3])
  gfx.rect(rect[1],rect[2],rect[3]-rect[1],rect[4]-rect[2],false)
  if str ~= "" then DrawString(str,rect,not iscombo) end
  if iscombo == true then
    gfx.x,gfx.y=rect[3]-_th*3/4,rect[2]+_th/8
    gfx.drawstr(_downarrow)  
  end
end

function DrawHeader()  
  gfx.setfont(TOOL)
  gfx.set((_mg[1]+_bg[1])/2,(_mg[2]+_bg[2])/2,(_mg[3]+_bg[3])/2)
  gfx.rect(0,0,gfx.w,_th*2)
  gfx.set(_fg[1],_fg[2],_fg[3])
  gfx.x,gfx.y=_th/2,_th*5/8
  gfx.drawstr("Track:")  
  name=""
  if _track ~= nil then ok,name=reaper.GetTrackName(_track,"") end
  
  boxsy,boxey,boxw=_th*3/8,_th*7/4,_th*10
  _trackrect={gfx.x+_th/4,boxsy,gfx.x+_th/2+boxw,boxey}  
  DrawBox(_trackrect," "..name,true)  
  
  gfx.x,gfx.y=_trackrect[3]+_th/2,_th*5/8
  gfx.drawstr("Beat:")
  boxw=_th*5/2
  _beatrect={gfx.x+_th/4,boxsy,gfx.x+_th/2+boxw,boxey}
  DrawBox(_beatrect," ".._beatdiv,true)
  
  gfx.setfont(DEF)
  if _editing then m,b=_capm,_capb else m,b=_curm,_curb end
  str=string.format("%d.%.2f",m,(b-1)*_beatdiv+1)
  w,h=gfx.measurestr(str)
  x=_th*3/2+(gfx.w-w)/2
  if x > gfx.x+_th/2 then
    gfx.x,gfx.y=x,_th/2
    gfx.drawstr(str) 
  end
  gfx.setfont(TOOL)  

  if _track ~= nil then
    boxw=_th*7/2
    _editrect={gfx.w-_th-boxw,boxsy,gfx.w-_th,_trackrect[4]}
    _importrect={_editrect[1]-_th/2-boxw,boxsy,_editrect[3]-_th/2-boxw,boxey}
    _exportrect={_importrect[1]-_th/2-boxw,boxsy,_importrect[3]-_th/2-boxw,boxey}
    gfx.set(_fg[1],_fg[2],_fg[3])
    if _editing == true then
      DrawBox(_editrect,"",false)
      gfx.set(1.0,0.0,0.0)
      DrawString("Editing",_editrect,true)
      gfx.set(_fg[1],_fg[2],_fg[3])
      DrawBox(_importrect,"Cancel",false)  
      DrawBox(_exportrect,"Commit",false)   
    else
      DrawBox(_editrect,"Edit",false)     
      DrawBox(_importrect,"Import",false)  
      DrawBox(_exportrect,"Export",false)
    end
  end
  gfx.setfont(DEF)
end

function GetLyricRect(m,b)
  y,dy=_th*5/2,_th*3/2
  sy=y+(m-_scrollm)*dy
  ey=sy+dy  
  if b < 0 then 
    sx,ex=_th/2,_th*4 -- measure number
  else
    sx,ex=_th*4,gfx.w-_th -- entire line
    if b > 0 and _editing == true then 
      bw=(ex-sx)/_tsnum[m]
      sx,ex=sx+(b-1)*bw,sx+b*bw
      sy,ey=sy+_th/8,ey-_th/8
    end
  end
  return {sx,sy,ex,ey}
end

function DrawMeasureNumbers()
  gfx.setfont(DEF)  
  for m=_scrollm,_maxm do
    if m >= _scrollm+_pagem then break end
    rect=GetLyricRect(m,-1)
    if m == _curm then gfx.setfont(SEL) end
    DrawString(tostring(m),rect,false)
    if m == _curm then gfx.setfont(DEF) end
  end
end

function HitTestLyrics(x,y) 
  for m=_scrollm,_maxm do
    if m >= _scrollm+_pagem then break end    
    rect=GetLyricRect(m,0)
    if HitTest(x,y,rect) then
      for b=1,_tsnum[m] do
        rect=GetLyricRect(m,b)
        if HitTest(x,y,rect) then return m,b end
      end
    end
  end
  return 0,0
end

function DrawEditingLyrics()
  gfx.setfont(DEF)  
  for m=_scrollm,_maxm do
    if m >= _scrollm+_pagem then break end
    for b=1,_tsnum[m] do
      rect=GetLyricRect(m,b)
      str=GetLyric(m,b)
      if m == _capm and b == _capb then       
        DrawEditingText(str,rect)
      else    
        DrawString(str,rect,false)
      end
    end    
  end 
end

function DrawPlaybackLyrics()
  gfx.setfont(DEF)
  for m=_scrollm,_maxm do
    if m >= _scrollm+_pagem then break end
    rect=GetLyricRect(m,0)
    
    line=""
    for b=1,_tsnum[m] do
      if b > 1 then line=line.." " end
      line=line.._lyrics[m][b]
    end
    if m ~= _curm then
      DrawString(line,rect,true)
    else
      w,h=gfx.measurestr(line)
      gfx.x=rect[1]+(rect[3]-rect[1]-w)/2
      gfx.y=rect[2]+(rect[4]-rect[2]-_th)/2
      for b=1,_tsnum[m] do
        if b == _curb then gfx.setfont(SEL) end
        gfx.drawstr(_lyrics[m][b].." ",4|256,gfx.x+w,gfx.y+_th)
        if b == _curb then gfx.setfont(DEF) end
      end
    end
  end
end

function DrawScrollbar()
  if _maxm > _pagem then
    h=gfx.h-2*_th
    sy=_th*2+h*(_scrollm-1)/_maxm
    ey=_th*2+h*(_scrollm+_pagem-1)/_maxm
    _scrollrect={gfx.w-_th,sy,gfx.w,ey}
    gfx.set(_mg[1],_mg[2],_mg[3])
    gfx.rect(gfx.w-_th,sy,_th,ey-sy)  
  else
    _scrollrect={0,0,0,0}
  end
end

function DrawLyrics()
  gfx.set(_bg[1],_bg[2],_bg[3])
  gfx.rect(0,_th*2,gfx.w,gfx.h)
  gfx.set(_fg[1],_fg[2],_fg[3])
  if _track == nil then
    rect={0,0,gfx.w,gfx.h-_th/2}
    gfx.setfont(DEF)
    DrawString("(no track selected)",rect,true)
    return
  end
   
  _pagem=math.floor((gfx.h-2*_th)/(_th*3/2))
  if _playstate&1 == 1 then _scrollm=math.floor(_curm-_pagem/4) end 
  if _scrollm > _maxm-_pagem+1 then _scrollm=_maxm-_pagem+1 end
  if _scrollm < 1 then _scrollm=1 end
    
  DrawMeasureNumbers()  
  if _editing == true then DrawEditingLyrics()
  else DrawPlaybackLyrics()
  end  
  DrawScrollbar()
end

function TrackHasAudio(track)
  icnt=reaper.CountTrackMediaItems(track)
  for i=1,icnt do
    item=reaper.GetTrackMediaItem(track,i-1)
    k=reaper.GetMediaItemInfo_Value(item, "I_CURTAKE")
    tk=reaper.GetMediaItemTake(item,k)
    if tk ~= nil and reaper.TakeIsMIDI(tk) == false then 
      return true
    end
  end
  return false
end

function ChooseTrack()
  menu=""
  tracks={}
  cnt=reaper.CountTracks()
  for t=1,cnt do    
    track=reaper.GetTrack(0,t-1)
    if TrackHasAudio(track) == false then
      if #tracks > 0 then menu=menu.."|" end
      if track == _track then menu=menu.."!" end
      ok,name=reaper.GetTrackName(track,"")
      menu=menu..name
      tracks[#tracks+1]=track    
    end
  end
  if #tracks == 0 then
    menu="#(no empty or MIDI tracks found)"
  end

  gfx.x,gfx.y=_trackrect[1],_trackrect[4]
  t=gfx.showmenu(menu)
  if #tracks > 0 and t > 0 then _track=tracks[t] end
end

function OnBeatDivChange(beatdiv)
  _capb=math.floor((_capb-1)/(beatdiv/_beatdiv))+1
  _beatdiv=beatdiv
  RefreshLyrics()
  StartEdit(_capm,_capb)
end

function ChooseBeatDiv()
  menu=""
  divs={4,2,1,0.5,0.25}
  for i=1,#divs do
    if i > 1 then menu=menu.."|" end
    if divs[i] == _beatdiv then menu=menu.."!" end
    menu=menu..divs[i]
  end
  
  gfx.x,gfx.y=_beatrect[1],_beatrect[4]
  t=gfx.showmenu(menu)
  if t > 0 then OnBeatDivChange(divs[t]) end
end

function RefreshLyrics()
  _lyrics={}
  if _track ~= nil then
    ok,lyricstr=reaper.GetTrackMIDILyrics(_track,2,"")
    if lyricstr:len() then
      for m,b,text in lyricstr:gmatch("(%d+).(%d+.%d+)\t([^\t]*)\t?") do
        m,b=tonumber(m),tonumber(b)
        b=math.floor((b-1)/_beatdiv)+1
        if _lyrics[m] == nil then _lyrics[m]={} end
        if _lyrics[m][b] == nil then _lyrics[m][b]=text
        else _lyrics[m][b]=_lyrics[m][b].." "..text
        end
      end    
    end
  end
  ValidateLyrics()  
end

function ValidateLyrics()
  maxt=reaper.GetProjectLength(0)
  b,_maxm=reaper.TimeMap2_timeToBeats(0,maxt)  
  for m in pairs(_lyrics) do
    if m > _maxm then
      if _lyrics[m] ~= nil then
        for b in pairs(_lyrics[m]) do
          if _lyrics[m][b] ~= "" and _lyrics[m][b] ~= _bullet then
            _maxm=m
            break
          end
        end
      end
    end
  end
  if _maxm == 0 then _maxm=8
  else _maxm=math.floor((_maxm-1)/4)*4+8
  end

  for m=1,_maxm do
    t=reaper.TimeMap2_beatsToTime(0,0,m-1)
    _tsnum[m],tsdenom=reaper.TimeMap_GetTimeSigAtTime(0,t)
    _tsnum[m]=math.floor(_tsnum[m]/_beatdiv)
    if _lyrics[m] == nil then _lyrics[m]={} end
    for b=1,_tsnum[m] do
      if _lyrics[m][b] == nil or _lyrics[m][b] == "" then 
        _lyrics[m][b]=_bullet 
      end
    end
  end
end

function CommitLyrics()
  minm,maxm=_maxm,0
  str=""
  for m=1,_maxm do
    for b=1,_tsnum[m] do
      if _lyrics[m][b] ~= "" and _lyrics[m][b] ~= _bullet then
        if m < minm then minm=m end
        if m > maxm then maxm=m end
        str=str..string.format("%d.%.2f\t%s\t",
          m,(b-1)*_beatdiv+1,_lyrics[m][b])
      end
    end
  end
  if minm <= maxm then
    st=reaper.TimeMap2_beatsToTime(0,0.0,minm-1)
    et=reaper.TimeMap2_beatsToTime(0,0.0,maxm)
    ost,oet=reaper.GetSet_LoopTimeRange2(0,false,false,0.0,0.0,false)
    reaper.GetSet_LoopTimeRange2(0,true,false,st,et,false)
    reaper.SetMediaTrackInfo_Value(_track,"I_SELECTED",1)
    reaper.Main_OnCommandEx(ENSURE_MIDI_ITEMS,0,0)
    reaper.GetSet_LoopTimeRange2(0,true,false,ost,oet,false) -- restore
  end
  
  reaper.SetTrackMIDILyrics(_track,0,str)
end

function HitTest(x,y,rect)
  return x >= rect[1] and x < rect[3] and y >= rect[2] and y < rect[4]
end

function GetPlayPos()
  _playstate=reaper.GetPlayState()&1
  if _playstate == 1 then _playpos=reaper.GetPlayPosition()  
  else _playpos=reaper.GetCursorPosition() 
  end
  
  b,m=reaper.TimeMap2_timeToBeats(0,_playpos)
  m,b=m+1,math.floor(b/_beatdiv)+1
  if m > _maxm then m,b=_maxm,1 end
  return m,b
end

function StartEdit(m,b)
  EndEdit()
  if m < 1 then m=1 end
  if m > _maxm then m=_maxm end  
  if m < _scrollm then _scrollm=m end
  if m > _scrollm+_pagem-1 then _scrollm=m-_pagem+1 end
  if b < 1 then b=1 end
  if b > _tsnum[m] then b=_tsnum[m] end
  
  _origlyric=_lyrics[m][b]
  if _lyrics[m][b] == _bullet then _lyrics[m][b]="" end
  _capm,_capb=m,b
  _caret={1,_lyrics[m][b]:len()+1}  
end

function EndEdit()
  if _lyrics[_capm] ~= nil and _lyrics[_capm][_capb] ~= nil then
    if _lyrics[_capm][_capb] == "" then 
      _lyrics[_capm][_capb]=_bullet 
    end
  end
  ValidateLyrics()
end

function OnMouseDown(x,y,doubleclick)
  if HitTest(x,y,_trackrect) then
    ChooseTrack()
    RefreshLyrics()
    if _track ~= nil and _editing == true then
      StartEdit(_capm,_capb)
    end
  elseif HitTest(x,y,_beatrect) then
    ChooseBeatDiv()   
  elseif _track ~= nil then    
    if HitTest(x,y,_editrect) then
      if _editing == false and _track ~= nil then
        _editing=true
        StartEdit(m,b) 
      else
        _editing=false
      end   
    elseif HitTest(x,y,_scrollrect) then
      _scrollcapm,_scrollcapy=_scrollm,y
    elseif HitTest(x,y,_importrect) then
      if _editing == true then
        RefreshLyrics()  
        _editing=false
      elseif _track ~= nil then
        reaper.SetMediaTrackInfo_Value(_track,"I_SELECTED",1)
        reaper.Main_OnCommandEx(IMPORT_LYRICS,0,0)
      end
    elseif HitTest(x,y,_exportrect) then
      if _editing == true then
        CommitLyrics()
        reaper.Undo_OnStateChange("Edited MIDI lyrics")
        RefreshLyrics()
        _editing=false
      elseif _track ~= nil then
        reaper.SetMediaTrackInfo_Value(_track,"I_SELECTED",1)
        reaper.Main_OnCommandEx(EXPORT_LYRICS,0,0)
      end
    elseif _editing then
      m,b=HitTestLyrics(x,y)
      if m == _capm and b == _capb then
        if doubleclick == true then 
          str=GetLyric(_capm,_capb)
          _caret={1,str:len()}
        else
          i=GetEditCaret(x,y)
          _caret={i,0}        
        end
      elseif m > 0 and b > 0 then
        StartEdit(m,b)
      end
    end
  end
  _mousedown=true
  _mousex,_mousey=x,y
end

function OnMouseUp(x,y)
  _mousedown=false
  _mousex,_mousey,_scrollcapy=0,0,0
end

function OnMouseMove(x,y)
  if _scrollcapy > 0 then
    dy=y-_scrollcapy
    h=gfx.h-2*_th
    _scrollm=math.floor(_scrollcapm+dy*_maxm/h)
  elseif _editing == true and HitTest(x,y,_cureditrect) then
    i=GetEditCaret(x,y)
    _caret[2]=i-_caret[1]
  end
  _mousex,_mousey=x,y
end

function OnMouseWheel(x, y, dv)
  if HitTest(x,y,_beatrect) then    
    if dv > 0 then
      if _beatdiv < 4.0 then OnBeatDivChange(_beatdiv*2.0) end
    else
      if _beatdiv > 0.25 then OnBeatDivChange(_beatdiv*0.5) end
    end
  elseif gfx.mouse_cap&4 == 4 then --ctrl
    SetFonts(dv > 0 and 1 or -1)    
  elseif gfx.y > _th*2 then
    if dv > 0 then _scrollm=_scrollm-1
    else _scrollm=_scrollm+1 end
    DrawLyrics()
  end    
end

function OnCtxMenu(x,y)
  if _editing == true then
    rect=GetLyricRect(_capm,_capb)
    if HitTest(x,y,rect) then
      menu="Forward\tShift+Right|Back\tShift+Left|Up\tUp|Down\tDown||"
      menu=menu.."Insert\tShift+Ins|Delete\tShift+Del|Delete previous\tShift+Bksp"
      gfx.x,gfx.y=rect[1]-_th/2,rect[4]
      t=gfx.showmenu(menu)
      if t == 1 then OnNavigateChar(RIGHT,false,true)
      elseif t == 2 then OnNavigateChar(LEFT,false,true)
      elseif t == 3 then OnNavigateChar(UP,false,false)
      elseif t == 4 then OnNavigateChar(DOWN,false,false)
      elseif t == 5 then OnNavigateChar(INS,false,true)
      elseif t == 6 then OnNavigateChar(DEL,false,true)
      elseif t == 7 then OnNavigateChar(BKSP,false,true)
      end
    end
  end
end

LEFT,RIGHT,UP,DOWN=0x6C656674,0x72676874,0x7570,0x646F776E
INS,DEL,BKSP=0x696E73,0x64656C,0x8
TAB,RET,ESC=0x9,0xD,0x1B
HOME,END=0x686F6D65,0x656E64
PGUP,PGDOWN=0x70677570,0x7067646E

function OnNavigateChar(c,ctrl,shift)
  if ((c == LEFT or c == TAB or c == RET) and shift == true) or
    (c == BKSP and GetLyric(_capm,_capb) == "") or
    (c == LEFT and _caret[1] == 1 and _caret[2] == 0) then
    if _capb > 1 or _capm > 1 then
      m,b=_capm,_capb-1
      if b < 1 then m,b=m-1,_tsnum[m-1] end
      StartEdit(m,b) 
    end 
    return true
  end  
  if (c == RIGHT and shift == true) or c == TAB or c == RET or
    (c == RIGHT and _caret[1] == GetLyric(_capm,_capb):len()+1 and _caret[2] == 0) then
    if _capb < _tsnum[_capm] or _capm < _maxm then
      m,b=_capm,_capb+1
      if b > _tsnum[m] then m,b=m+1,1 end
      StartEdit(m,b) 
    end
    return true
  end    
  if c == UP then
    if _capm > 1 then StartEdit(_capm-1,_capb) end
    return true
  end
  if c == DOWN then
    if _capm < _maxm then StartEdit(_capm+1,_capb) end
    return true
  end
  if (c == DEL or c == BKSP) and shift == true then
    if c == BKSP then
      if _capb > 1 then _capb=_capb-1
      elseif _capm > 1 then _capm,_capb=_capm-1,_tsnum[_capm-1]
      end
    end  
    for m=_capm,_maxm do
      for b=1,_tsnum[m]-1 do
        if m > _capm or b >= _capb then
          _lyrics[m][b]=_lyrics[m][b+1]            
        end
      end
      if m < _maxm then _lyrics[m][_tsnum[m]]=_lyrics[m+1][1] end
    end     
    ValidateLyrics()
    StartEdit(_capm,_capb)
    return true
  end
  if c == INS and shift == true then
    for m=_maxm,_capm,-1 do 
      if m < _maxm then _lyrics[m+1][1]=_lyrics[m][_tsnum[m]] end
      for b=_tsnum[m],2,-1 do
        if m == _capm and b == _capb then break end
        _lyrics[m][b]=_lyrics[m][b-1]
      end
    end    
    ValidateLyrics()
    _lyrics[_capm][_capb]=""
    StartEdit(_capm,_capb)    
    return true
  end
  return false
end

function OnEditChar(c,ctrl,shift)
  if c == LEFT then
    if _caret[1] > 1 then _caret[1]=_caret[1]-1 end
    _caret[2]=0        
    return true
  end   
  if c == RIGHT then
    str=GetLyric(_capm,_capb)
    if _caret[1] < str:len()+1 then _caret[1]=_caret[1]+1 end
    _caret[2]=0
    return true
  end
  if c == BKSP or c == DEL then
    sc,ec=_caret[1],_caret[1]+_caret[2]
    if sc > ec then sc,ec=ec,sc end
    str=GetLyric(_capm,_capb)
    if _caret[2] ~= 0 then
      _lyrics[_capm][_capb]=str:sub(1,sc-1)..str:sub(ec)
    elseif c == BKSP and _caret[1] > 1 then
      _lyrics[_capm][_capb]=str:sub(1,sc-2)..str:sub(ec)
      _caret[1]=_caret[1]-1
    elseif c == DEL and _caret[1] <= str:len() then
      _lyrics[_capm][_capb]=str:sub(1,sc-1)..str:sub(ec+1)
    end
    _caret[2]=0    
    return true
  end
  if c == HOME then
    _caret={1,0}
    return true
  end
  if c == END then
    _caret={GetLyric(_capm,_capb):len()+1,0}
  end
  return false
end

function OnInputChar(c)
  if c >= 0x20 and c <= 0x7E then
    sc,ec=_caret[1],_caret[1]+_caret[2]
    if sc > ec then sc,ec=ec,sc end
    str=GetLyric(_capm,_capb)
    _lyrics[_capm][_capb]=str:sub(1,sc-1)..string.char(c)..str:sub(ec)
    _caret={_caret[1]+1,0}  
    return true
  end
  return false
end

function OnMetaChar(c,ctrl,shift)
  if c == ESC then
    if _lyrics[_capm][_capb] == _origlyric and _caret[1] == _origlyric:len()+1 and _caret[2] == 0 then
      _editing=false
    else
      _lyrics[_capm][_capb]=_origlyric    
      _caret={_origlyric:len()+1,0}
    end
    return true
  end
  if c == 0x13 and ctrl == true then -- ctrl+S
    CommitLyrics()
    reaper.Undo_OnStateChange("Edited MIDI lyrics")
  end
  return false
end

function OnChar(c)
  --reaper.ShowConsoleMsg(string.format("0x%X\n",c))
  ctrl=(gfx.mouse_cap&4 == 4)
  shift=(gfx.mouse_cap&8 == 8)
  if OnMetaChar(c,ctrl,shift) then return end
  if OnNavigateChar(c,ctrl,shift) then return end
  if OnEditChar(c,ctrl,shift) then return end
  if OnInputChar(c) then return end
end

function runloop()
  upd=false

  if _track ~= nil and reaper.ValidatePtr2(0,_track,"MediaTrack*") == false then
    _track=nil
    RefreshLyrics()
    upd=true
  end

  m,b=GetPlayPos()
  if m ~= _curm or b ~= _curb then
    if m ~= _curm or _editing == false then upd=true end
    _curm,_curb=m,b
  end

  c=gfx.getchar()
  if c > 0 and _editing == true then 
    OnChar(c) 
    upd=true
  end

  if _mousedown == false then
    if gfx.mouse_cap&1 == 1 then
      t=os.clock()
      doubleclick=(t-_mousedowntime < 0.25)
      OnMouseDown(gfx.mouse_x,gfx.mouse_y,doubleclick)
      _mousedowntime=t
      upd=true
    elseif gfx.mouse_cap&2 == 2 then
      OnCtxMenu(gfx.mouse_x,gfx.mouse_y)
      upd=true
    elseif gfx.mouse_wheel ~= 0 and _mousedown == false then
      OnMouseWheel(gfx.mouse_x, gfx.mouse_y, gfx.mouse_wheel)
      gfx.mouse_wheel=0
      upd=true
    end
  else
    if gfx.mouse_cap&(1|2) == 0 then  
      OnMouseUp(gfx.mouse_x,gfx.mouse_y)
      upd=true
    elseif gfx.mouse_cap&1 == 1 then 
      if gfx.mouse_x ~= _mousex or gfx.mouse_y ~= _mousey then
        OnMouseMove(gfx.mouse_x,gfx.mouse_y)
        upd=true
      end
    end
  end
   
  if _editing == true and _caret[2] == 0 then
    c=math.floor(os.clock()*2)
    if (c~_clock)&1 == 1 then
      _clock=c
      upd=true
    end
  end

  if gfx.w ~= _gfxw or gfx.h ~= _gfxh then
    _gfxw,_gfxh=gfx.w,gfx.h
    upd=true
  end

  if upd == true then
    DrawHeader()
    DrawLyrics()
  end
  
  gfx.update()
  if c >= 0 then reaper.runloop(runloop) end
end

SetFonts(reaper.GetExtState("lyrics","fontsz"))   
RefreshLyrics()
DrawHeader()
DrawLyrics()
runloop()
