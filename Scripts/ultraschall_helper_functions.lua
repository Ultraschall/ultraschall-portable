ultraschall={}

function ultraschall.pause_follow_one_cycle()
  follow_actionnumber = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
  if reaper.GetToggleCommandState(follow_actionnumber)==1 then
    reaper.SetExtState("follow", "skip", "true", false)
  end
end

function ultraschall.ToggleScrollingDuringPlayback(scrolling_switch, move_editcursor, goto_playcursor)
  -- integer scrolling_switch - 1-on, 0-off
  -- boolean move_editcursor - when scrolling stops, shall the editcursor be moved to current position of the playcursor(true) or not(false)
  -- boolean goto_playcursor - shall the view be moved to the playcursor(true) or not(false)? 
  -- changes, if necessary, the state of the actions 41817, 40036 and 40262
    local scroll_continuous=reaper.GetToggleCommandState(41817)
    local scroll_auto_play=reaper.GetToggleCommandState(40036)
    local scroll_auto_rec=reaper.GetToggleCommandState(40262)
    local editcursor=reaper.GetCursorPosition()
    local playcursor=reaper.GetPlayPosition()
  
    if move_editcursor==true then
      reaper.SetEditCurPos(playcursor, true, false)
    else
      reaper.SetEditCurPos(editcursor, false, false)
    end
  
    if scrolling_switch~=scroll_continuous then
      reaper.Main_OnCommand(41817,0) -- continuous scroll
    end
  
    if scrolling_switch~=scroll_auto_play then
      reaper.Main_OnCommand(40036,0) -- autoscroll during play
    end
  
    if scrolling_switch~=scroll_auto_rec then
      reaper.Main_OnCommand(40262,0) -- autoscroll during rec
    end
  
    if goto_playcursor~=false then
      reaper.Main_OnCommand(40150,0) -- go to playcursor
    end  
  end




function ultraschall.GetAllTrackEnvelopes()
-- returns all TrackEnvelopes of the current project as a table, number of tracks, the first track that has an envelope, if the master track has an envelope(0) or not (-1)
-- the table works as follows:
-- TrackEnvelopeArray[Tracknumber][0] - number of envelopes for track Tracknumber
-- TrackEnvelopeArray[Tracknumber][1][Envelopenumber] - the envelope Envelopenumber of track Tracknumber
--
-- tracknumber of 0 is for the master track

  local TrackEnvelopeArray={}
  local FirstEnvelopeTrackNumber=-1
  local FirstEnvelopeMaster=-1
  local trackcount=1
  
  for i=0, reaper.CountTracks(0)-1 do
    local MediaTrack=reaper.GetTrack(0,i)
    TrackEnvelopeArray[i+1]={}
    TrackEnvelopeArray[i+1][1]={}
    
    for a=0, reaper.CountTrackEnvelopes(MediaTrack)-1 do
      TrackEnvelopeArray[i+1][1][a]=reaper.GetTrackEnvelope(MediaTrack, a)
      if FirstEnvelopeTrackNumber==-1 then FirstEnvelopeTrackNumber=i+1 end
    end
    TrackEnvelopeArray[i+1][0]=reaper.CountTrackEnvelopes(MediaTrack)-1
  end

  local MediaTrack=reaper.GetMasterTrack(0)
  TrackEnvelopeArray[0]={}
  TrackEnvelopeArray[0][1]={}
  for a=0, reaper.CountTrackEnvelopes(MediaTrack)-1 do
    TrackEnvelopeArray[0][1][a]=reaper.GetTrackEnvelope(MediaTrack, a)
    FirstEnvelopeMaster=0
  end
  TrackEnvelopeArray[0][0]=reaper.CountTrackEnvelopes(MediaTrack)-1

  
  return TrackEnvelopeArray, reaper.CountTracks(0), FirstEnvelopeTrackNumber, FirstEnvelopeMaster
end

function ultraschall.RenumerateMarkers(colorvalue, startingnumber)
-- renumerates the shown number of markers(no regions!) that have 
-- color "colorvalue", beginning with "startingnumber"
-- 
-- returns -1 in case of error
-- Parameters:
--    colorvalue - the colorvalue the marker must have
--    startingnumber - the first number that shall be given to the first marker with "colorvalue"


  if type(colorvalue)~="number" then return -1 end
  if type(startingnumber)~="number" then return -1 end
  local counter=startingnumber
  local allmarkers, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color
  for i=0, allmarkers-1 do
    retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
  --  reaper.MB(color,"",0)
    if isrgn==false and color==colorvalue then --0 then
      reaper.SetProjectMarkerByIndex2(0, i, isrgn, pos, rgnend, counter, name, color, 0)
      counter=counter+1
    end
  end
end

function ultraschall.TimeToSeconds(timestring)
-- converts a timestring days:hours:minutes:seconds.milliseconds to timeposition in seconds
-- it is ok, to have only some of them given, so excluding hours or days is ok.
-- 
-- a single integer will be seen as seconds.
-- to specifiy milliseconds in particular, start the number with a .
-- all other values are seperated by :
--
-- returns -1 in case of error, timestring is a nil  or if you try to add an 
-- additional value, added before days
--
-- does not check for valid timeranges, so 61 minutes is possible to give, even if 
-- hours are present in the string
  local hour=0
  local milliseconds=0
  local minute=0
  local seconds=0
  local time=0
  local day=0

  if timestring==nil then return -1 end
  milliseconds=timestring:match("%..*")
--  reaper.MB(milliseconds,"",0)
  if tonumber(milliseconds)==nil and milliseconds~=nil then return -1 end
  if milliseconds==nil then milliseconds=0 end
  if milliseconds=="" then milliseconds=".0 " end
  if milliseconds=="0" then milliseconds=".0 " end
  if milliseconds==0 then milliseconds=".0 " end
  if milliseconds=="." then milliseconds=0 end
    
  if timestring:match("%.%d*")~=nil then timestring=timestring:match("(.*)%.") end
  if tonumber(timestring)~=nil then seconds=tonumber(timestring)
  elseif timestring==nil then seconds=0
  else
    seconds=tonumber(timestring:match(".*:(.*)"))
  end
  if seconds==nil then return -1 end

  if timestring~=nil then timestring=timestring:match("(.*):") end
  if tonumber(timestring)~=nil then minute=tonumber(timestring)
  elseif timestring==nil then minute=0
  else
    minute=tonumber(timestring:match(".*:(.*)"))
  end
  if minute==nil then return -1 end

  if timestring~=nil then timestring=timestring:match("(.*):") end
  if tonumber(timestring)~=nil then hour=tonumber(timestring)
  elseif timestring==nil then hour=0
  else
    hour=tonumber(timestring:match(".*:(.*)"))
  end
  if hour==nil then return -1 end

  if timestring~=nil then timestring=timestring:match("(.*):") end
  if tonumber(timestring)~=nil then day=tonumber(timestring)
  elseif timestring==nil then day=0
  else
    day=tonumber(timestring:match(".*:(.*)"))
  end
  if day==nil then return -1 end
  
  if timestring~=nil then timestring=timestring:match("(.*):") end
    
  if timestring~=nil then return -1 end

--reaper.MB(seconds,"",0)

  if day~=nil and tonumber(day)==nil then return -1 end
  if hour~=nil and tonumber(hour)==nil then return -1 end
  if minute~=nil and tonumber(minute)==nil then return -1 end
  if seconds~=nil and tonumber(seconds)==nil then return -1 end
  if milliseconds~=nil and tonumber(milliseconds)==nil then return -1 end

  
  if day==nil then day=0 end
  if hour==nil then hour=0 end
  if minute==nil then minute=0 end
  if seconds==nil then seconds=0 end
  if milliseconds==nil then milliseconds=0 end
    
  time=(day*86400)+(hour*3600)+(minute*60)+seconds+milliseconds
  if time<0 then return -1 end
  return time
end

function ultraschall.TimeStringToSeconds_hh_mm_ss_mss(timestring)
-- converts timestring to seconds
-- expects hh:mm:ss.mss as time, i.e. 12:23:34.456 or it returns -1 as result
  if type(timestring)~="string" then return -1 end
  local Hour=timestring:match("(%d-):")
  if Hour==nil or string.len(Hour)~=2 then return -1 end
  local Minute=timestring:match("%d%d:(%d-):")
  if Minute==nil or string.len(Minute)~=2 then return -1 end
  local Second=timestring:match("%d%d:%d%d:(%d-)%.")
  if Second==nil or string.len(Second)~=2 then return -1 end
  local MilliSeconds=timestring:match("%d%d:%d%d:%d%d(%.%d*)")
  if MilliSeconds==nil or string.len(MilliSeconds)~=4 then return -1 end
  return (Hour*3600)+(Minute*60)+Second+tonumber(MilliSeconds)
end

function ultraschall.GetStringFromClipboard_SWS()
-- gets a big string from clipboard, using the 
-- CF_GetClipboardBig-function from SWS
-- and deals with all aspects necessary, that
-- surround using it.
  local buf = reaper.CF_GetClipboard(buf)
  local WDL_FastString=reaper.SNM_CreateFastString("HudelDudel")
  local clipboardstring=reaper.CF_GetClipboardBig(WDL_FastString)
  reaper.SNM_DeleteFastString(WDL_FastString)
  return clipboardstring
end

function ultraschall.ParseMarkerString(markerstring, strict)
-- splits the entries in markerstring into timeposition and name
-- returns the number of entries in markerstring, as well as a table with all entries in them
--
-- markertable[1][i] - the timestring, -1 if no time is available
-- markertable[2][i] - the time, converted into position in seconds, -1 if no time is available
-- markertable[3][i] - the name of the marker
--
-- the variable i above, is the number of the marker, beginning with 1
-- splits the entries in markerstring into timeposition and name
-- returns the number of entries in markerstring, as well as a table with all entries in them
--
-- markertable[1][i] - the timestring, -1 if no time is available
-- markertable[2][i] - the time, converted into position in seconds, -1 if no time is available
-- markertable[3][i] - the name of the marker
--
-- the variable i above, is the number of the marker, beginning with 1
  if type(markerstring)~="string" then return -1 end
  local counter=1
  local markertable={}
  markertable[1]={}
  markertable[2]={}
  markertable[3]={}
  
  while markerstring~=nil do
    markertable[1][counter]=markerstring:match("(.-)%s")
      if strict~=true then
        markertable[2][counter]=ultraschall.TimeToSeconds(markertable[1][counter])--reaper.parse_timestr(markertable[1][counter])
      else
        markertable[2][counter]=ultraschall.TimeStringToSeconds_hh_mm_ss_mss(markertable[1][counter])--reaper.parse_timestr(markertable[1][counter])
      end
      if markertable[2][counter]==-1 then markertable[1][counter]="" end

    if markertable[1][counter]=="" then
      markertable[1][counter]=-1
      markertable[2][counter]=-1
      markertable[3][counter]=markerstring:match("(.-)\n")
      if markertable[3][counter]==nil then markertable[3][counter]=markerstring:match(".*") end
    else  
      markertable[3][counter]=markerstring:match("%s(.-)\n")
      if markertable[3][counter]==nil then markertable[3][counter]=markerstring:match("%s(.*)") end
    end
    markerstring=markerstring:match(".-\n(.*)")
    counter=counter+1
  end
  return counter-1, markertable
end

if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
    -- user_folder = buf --"C:\\Users\\[username]" -- need to be test
    ultraschall.Separator = "\\"
else
    -- user_folder = "/USERS/[username]" -- Mac OS. Not tested on Linux.
    ultraschall.Separator = "/"
end

function ultraschall.SetUSExternalState(section, key, value)
-- stores value into ultraschall.ini
-- returns true if sucessful, false if unsucessful

  if section:match(".*(%=).*")=="=" then return false end
  return reaper.BR_Win32_WritePrivateProfileString(section, key, value, reaper.GetResourcePath()..ultraschall.Separator.."ultraschall.ini")
end

function ultraschall.GetUSExternalState(section, key)
-- gets a value from ultraschall.ini
-- returns length of entry(integer) and the entry itself(string)

  return reaper.BR_Win32_GetPrivateProfileString(section, key, -1, reaper.GetResourcePath()..ultraschall.Separator.."ultraschall.ini")
end 

function ultraschall.CountNormalMarkers_NumGap()
-- returns number of normal markers in the project
  local nix=""
  a,nummarkers,b=reaper.CountProjectMarkers(0)
  count=0
  for b=1, nummarkers do
    for i=0, a do
    retval, isrgn, pos, rgnend, name, markrgnindexnumber, color= reaper.EnumProjectMarkers3(0, i)
    if markrgnindexnumber==b then count=b nix="hui" break
    end
    end
    if nix=="" then break end
    nix=""
  end

  return count+1
end  

function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

function runcommand(cmd)     -- run a command by its name

  start_id = reaper.NamedCommandLookup(cmd)
  reaper.Main_OnCommand(start_id,0) 

end

function GetPath(str,sep)
 
    return str:match("(.*"..sep..")")

end

function ultraschall.ConvertColor(r,g,b)

    return reaper.ColorToNative(r,g,b)|0x1000000
  
end

function ConsolidateFollowState()

  followstate = reaper.GetToggleCommandStateEx(0, 40036)
  followstate2 = reaper.GetToggleCommandStateEx(0, 40262)
  followstate3 = reaper.GetToggleCommandStateEx(0, 41817)

  if followstate ~= followstate2 then -- set both states to the same value
    reaper.Main_OnCommand(40262, 0) -- Toggle auto-view-scroll while recording
  end

  if followstate2 ~= followstate3 then -- set both states to the same value
    reaper.Main_OnCommand(41817, 0) -- Toggle continuous scrolling
  end
  
  ultraschall.SetUSExternalState("ultraschall_follow", "state", followstate, true)
  reaper.SetExtState("ultraschall_follow", "state2", followstate, false)

  return followstate

end
