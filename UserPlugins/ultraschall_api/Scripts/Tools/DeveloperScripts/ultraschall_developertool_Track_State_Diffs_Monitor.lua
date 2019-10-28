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
  --]]

--[[
Display Track changes in Track-State-Chunks.
  
This displays diffs in a TrackStateChunk, for easier tracking, what changed in a TrackStateChunk.
 
TrackStateChunks include MediaItemStateChunk of MediaItems in that given track, as well as TrackEnvelopes and ItemEnvelopes.

This will display the changed lines(including line-number within the statechunk)
 + the two lines before it (if existing and not being changed lines themselves)

Changed lines begin with:
line xx >>  


Before monitoring it, a dialog will appear that asks you for the track to monitor.
Select the track to monitor by either giving the dialog the tracknumber(1-based)
or by giving it 0 or just hitting ok to monitor the first selected track.

After that, it will ask you, whether to put the changed lines into the clipboard.

When changing a selected track, it will show all lines of the track-state-chunk.
So if you just want to see the change in a selected track, select it first, then apply the change.

Meo Mespotine mespotine.de - 30th of october 2018
--]]

function SplitStringAtLineFeedToArray(unsplitstring)
  local array={}
  local i=1
  if unsplitstring==nil then return -1 end
  local astring=unsplitstring
  local pos
  astring=string.gsub (unsplitstring, "\r\n", "\n")
  astring=string.gsub (astring, "\n\r", "\n")
  astring=string.gsub (astring, "\r", "\n")
  astring=astring.."\n"
  while astring:match("%c") do
    array[i],pos=astring:match("(.-)\n()")
--    reaper.MB(array[i], tostring(pos),0)
    if sub~=nil then break end 
    astring=astring:sub(pos,-1)
    i=i+1
  end
  if astring~="" and astring~=nil then array[i]=astring
  else i=i-1
  end
  return i,array
end


function main()
  if tonumber(selected)>0 then tracknumber=selected Track=reaper.GetTrack(0,tonumber(selected)-1)
  else 
    Track=reaper.GetSelectedTrack(0,0) 
    if Track~=nil then tracknumber=reaper.GetMediaTrackInfo_Value(Track, "IP_TRACKNUMBER") end
  end
  if Track~=nil then
    retval, tracksc = reaper.GetTrackStateChunk(Track, "", false)
    if oldtracksc~=tracksc then
      count1, split_string1 = SplitStringAtLineFeedToArray(oldtracksc)
      count2, split_string2 = SplitStringAtLineFeedToArray(tracksc)
      if split_string1==nil then split_string1={} end
      reaper.ClearConsole()
      reaper.ShowConsoleMsg("Monitoring StateChunk-changes in Track: "..math.floor(tracknumber).."\n\n")
      a=-10
      temp=""
      for i=1, count2 do
        if split_string1[i]~=split_string2[i] and Track==oldTrack then
          if a~=-10 and (a<i-2 or a<i-2) then reaper.ShowConsoleMsg("\n\n") end
          if a<i-2 and i-2>0 then reaper.ShowConsoleMsg("Change:\n\t"..split_string2[i-2].."\n") end
          if a<i-1 and i-1>0 then reaper.ShowConsoleMsg("\t"..split_string2[i-1].."\n") end
          if A==6 then temp=temp.."line "..i.." >>  "..split_string2[i].."\n" end
          reaper.ShowConsoleMsg("line "..i.." >>  "..split_string2[i].."\n")
          a=i
        elseif Track~=oldTrack then
          if A==6 then temp=temp..split_string2[i].."\n" end
          reaper.ShowConsoleMsg(split_string2[i].."\n")
        end        
      end
      if A==6 and temp~="" then reaper.CF_SetClipboard("Monitoring StateChunk-changes in Track: "..math.floor(tracknumber).."\n\n"..temp.."\n") end
    end
    oldtracksc=tracksc
    oldTrack=Track
  end
  reaper.defer(main)
end

text=[[Display Track changes in Track-State-Chunks.
  
This displays diffs in a TrackStateChunk, for easier tracking, what changed in a TrackStateChunk.
 
TrackStateChunks include MediaItemStateChunk of MediaItems in that given track, as well as TrackEnvelopes and ItemEnvelopes.

This will display the changed lines(including line-number within the statechunk)
 + the two lines before it (if existing and not being changed lines themselves)

Changed lines begin with:
line xx >>  


Before monitoring it, a dialog will appear that asks you for the track to monitor.
Select the track to monitor by either giving the dialog the tracknumber(1-based)
or by giving it 0 or just hitting ok to monitor the first selected track.

After that, it will ask you, whether to put the changed lines into the clipboard.

When changing a selected track, it will show all lines of the track-state-chunk.
So if you just want to see the change in a selected track, select it first, then apply the change.

Meo Mespotine mespotine.de - 30th of october 2018"]]
 
reaper.MB(text, "Track-StateChunk Diff-monitor-tool 1.0", 0)

retval, selected = reaper.GetUserInputs("Which track? Use 0 to use selected track.", 1, "Tracknumber:", "")
if tonumber(selected)==nil then selected=0 end
a=-10

A=reaper.MB("Put Difs to Clipboard?", "", 4)

main()
