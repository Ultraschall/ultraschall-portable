-- Meo-Ada Mespotine - 20. February 2020
-- Add time-markers, and display the offset but not as project-time, but as time in 24-hour format

-- changelog:
-- 15th of June 2022 - sets now toggle-state to on, when started and off when stopped
--                   - remembers window position and size
--                   - remembers dockstate
A,B,C,D=reaper.get_action_context()

retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)

if dpi=="512" then
  gfx.ext_retina=1
  scale=2
else
  gfx.ext_retina=0
  scale=1
end

x_pos=tonumber(reaper.GetExtState("ultraschall_ShowTimeCode", "win_x-pos"))
y_pos=tonumber(reaper.GetExtState("ultraschall_ShowTimeCode", "win_y-pos"))
width=tonumber(reaper.GetExtState("ultraschall_ShowTimeCode", "win_width"))
height=tonumber(reaper.GetExtState("ultraschall_ShowTimeCode", "win_height"))
win_dockstate=tonumber(reaper.GetExtState("ultraschall_ShowTimeCode", "win_dockstate"))
if x_pos==nil then x_pos=900 end
if y_pos==nil then y_pos=0 end
if width==nil then width=286 end
if height==nil then height=95 end
if win_dockstate==nil then win_dockstate=0 end

gfx.init("Duration since last timemarker", width*scale, height*scale, win_dockstate, x_pos, y_pos)

if reaper.GetOS():match("Other")~=nil then 
  gfx.setfont(1,"Arial",100,0)
  gfx.setfont(2,"Arial",13,66)
elseif reaper.GetOS():match("Win")~=nil then
  gfx.setfont(1,"Arial",110,0)
  gfx.setfont(2,"Arial",16,66)
else
  gfx.setfont(1,"Arial",100,0)
  gfx.setfont(2,"Arial",14,66)
end

gfx.setimgdim(1,1000,1000)
color=reaper.ColorToNative(51,51,51)|0x1000000
gfx.clear=color

xoffset=2
yoffset=-43


function GetPreviousTimeMarker()
  if reaper.GetPlayState()==0 then position=reaper.GetCursorPosition() else position=reaper.GetPlayPosition() end
  for i=reaper.CountProjectMarkers(0)-1, 0, -1 do
    
    local A,B,C,D,E,F,G,H,I,J=reaper.EnumProjectMarkers2(0,i)
      if C<=position and E:sub(1,7)=="_Time: " then 
        LLLL=E:sub(8,-1)      
        Time=LLLL:match("T(..:..:..)")
        Date=LLLL:match("(.-)T")
        if Time~=nil and Date~=nil then return Time, Date,C end      
      end
  end 
  return "--:--:--", "----.--.--", 0
end

--A,B,C=


function CreateDateTime(time)
  local D=os.date("*t",time)
  if D.day<10 then D.day="0"..D.day else D.day=tostring(D.day) end
  if D.month<10 then D.month="0"..D.month else D.month=tostring(D.month) end
  if D.hour<10 then D.hour="0"..D.hour else D.hour=tostring(D.hour) end
  if D.min<10 then D.min="0"..D.min else D.min=tostring(D.min) end
  if D.sec<10 then D.sec="0"..D.sec else D.sec=tostring(D.sec) end
  local Date=D.day.."."..D.month.."."..D.year
  local Time=D.hour..":"..D.min..":"..D.sec
  return Date.." "..Time
end

--A,B,C=GetPreviousTimeMarker()

--if LLLLLL==nil then return end

function ConvertTimeToTable(datestring,timestring)
  local Table={}
  Table["day"]=tonumber(datestring:match(".*%-(.*)"))
  Table["month"]=datestring:match(".-%-(.-)%-")
  Table["year"]=datestring:match("(.-)%-")
  
  Table["hour"]=tonumber(timestring:match("(.-):"))
  Table["min"]=tonumber(timestring:match(":(.-):"))
  Table["sec"]=tonumber(timestring:match(".*:(.*)"))
  return Table
end


--if LLLLL==nil then return end


function main()
  Klumpel=Klumpel+1
  if Klumpel==3 or gfx.mouse_cap~=0 then
    Klumpel=0

    if reaper.GetPlayState()==0 then position=reaper.GetCursorPosition() else position=reaper.GetPlayPosition() end
    Offset, Dater, Pos=GetPreviousTimeMarker()
    if Offset~="--:--:--" then
      Offset_Seconds=reaper.parse_timestr(Offset)
      if Pos~=nil then
        Times=(Offset_Seconds-Pos+position)
        Time=(Offset_Seconds-Pos+position)
        
        D=math.floor(((Time/24)/60)/60)
        Time=math.floor(Time-(D*86400))
        Time=reaper.format_timestr_pos(Time,"",5)
        if Time:match(".(.)")==":" then Time="0"..Time:match("(.*)%:") end
        
        D=ConvertTimeToTable(Dater,Offset)
        L=os.time(D)
        M=L+position-Pos
        P=CreateDateTime(math.ceil(M))
        
        Finaltime="Day:        "..P:match("(.-)%s").." \nTime(24h):  "..P:match("%s(.*)")
        LLL=Finaltime:match("Time%(24h%): (.*)"):len()
        if Finaltime:match("Time%(24h%): (.*)"):len()==11 then 
          Finaltime=Finaltime:match("(.*)%:")
        end
      else
        D="Please set marker"
      end
    else
      Finaltime="Day:        --.--.----\nTime(24h):  \t--:--:--"
    end
    
    gfx.setfont(1)
    gfx.set(0.2,0.2,0.2,1,0,1)
  --  gfx.clear=color
    gfx.rect(0,0,1000,1000)
    gfx.set(1)
    gfx.x=20+xoffset
    gfx.y=0--14+yoffset
    gfx.drawstr(Finaltime)
    gfx.set(0,0,0,0,0,1)

    gfx.set(1,1,1,1,0,-1)
    L=gfx.w/gfx.h
    gfx.blit(1,1,0,0,0,1000,1000,0,15,gfx.w,gfx.h*L)
    gfx.set(0.6)

    gfx.set(0)
    gfx.setfont(2)

    if gfx.mouse_cap&1==0 then LOL=false end
    BBB=gfx.getchar(65536)
    if BBB&2~=2 then 
      gfx.r=0.0
      gfx.g=0.0
      gfx.b=0.0
      gfx.a=0.2
      gfx.rect(0,0,gfx.w,gfx.h,1)
    end
    BBB2=gfx.getchar()
    gfx.update()
    if BBB2>0 then reaper.SetCursorContext(1) end
  end
  if BBB2~=-1 then reaper.defer(main) end
end

Klumpel=0

function atexit()
  _,_,sec,cid=reaper.get_action_context()
  reaper.SetToggleCommandState(sec, cid, 0)
  Window_state={gfx.dock(-1, 0, 0, 0, 0)}
  reaper.SetExtState("ultraschall_ShowTimeCode", "win_x-pos", Window_state[2], true)
  reaper.SetExtState("ultraschall_ShowTimeCode", "win_y-pos", Window_state[3], true)
  reaper.SetExtState("ultraschall_ShowTimeCode", "win_width", Window_state[4], true)
  reaper.SetExtState("ultraschall_ShowTimeCode", "win_height", Window_state[5], true)
  reaper.SetExtState("ultraschall_ShowTimeCode", "win_dockstate", Window_state[1], true)
end

  _,_,sec,cid=reaper.get_action_context()
  reaper.SetToggleCommandState(sec, cid, 1)
reaper.atexit(atexit)
main()

 
