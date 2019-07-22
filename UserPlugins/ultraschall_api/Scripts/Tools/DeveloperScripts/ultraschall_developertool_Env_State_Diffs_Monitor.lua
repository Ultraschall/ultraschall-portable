--[[
Display Envelope changes in Envelope-State-Chunks.
  
This displays diffs in an EnvelopeStateChunk, for easier tracking, what changed in an EnvelopeStateChunk.

This will display the changed lines(including line-number within the statechunk)
 + the two lines before it (if existing and not being changed lines themselves)

Changed lines begin with:
line xx >>  


Before monitoring starts, a dialog will ask you, whether to monitor only the, at that time of the dialog, currently selected envelope(choose yes), 
or if you want to monitor other selected envelopes during scriptrun as well(choose No).

After that, it will ask you, whether to put the changed lines into the clipboard.

When changing a selected envelope, it will show all lines of the envelope-state-chunk.
So if you just want to see the change in a selected envelope, select it first, then apply the change.

Meo Mespotine mespotine.de - 1st of november 2018
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
  if tonumber(selected)==7 then Envelope=reaper.GetSelectedEnvelope(0)
  end
  if Envelope~=nil then
    retval, sc = reaper.GetEnvelopeStateChunk(Envelope, "", false)
    retval, buf = reaper.GetEnvelopeName(Envelope, "")
    if oldsc~=sc then
      count1, split_string1 = SplitStringAtLineFeedToArray(oldsc)
      count2, split_string2 = SplitStringAtLineFeedToArray(sc)
      if split_string1==nil then split_string1={} end
      reaper.ClearConsole()
      reaper.ShowConsoleMsg("Monitoring StateChunk-changes of Envelope: "..buf.."\n\n")
      a=-10
      temp=""
      for i=1, count2 do
        if split_string1[i]~=split_string2[i] and Envelope==oldEnvelope then
          if a~=-10 and (a<i-2 or a<i-2) then reaper.ShowConsoleMsg("\n\n") end
          if a<i-2 and i-2>0 then reaper.ShowConsoleMsg("Change:\n\t"..split_string2[i-2].."\n") end
          if a<i-1 and i-1>0 then reaper.ShowConsoleMsg("\t"..split_string2[i-1].."\n") end
          if A==6 then temp=temp.."line "..i.." >>  "..split_string2[i].."\n" end
          reaper.ShowConsoleMsg("line "..i.." >>  "..split_string2[i].."\n")
          a=i
        elseif Envelope~=oldEnvelope then
          reaper.ShowConsoleMsg(split_string2[i].."\n")
          if A==6 then temp=temp..split_string2[i].."\n" end
        end        
      end
      if A==6 and temp~="" then reaper.CF_SetClipboard(temp.."\n") end
    end
    oldsc=sc
    oldEnvelope=Envelope
  end
  reaper.defer(main)
end

text=[[Display Envelope changes in Envelope-State-Chunks.
  
This displays diffs in an EnvelopeStateChunk, for easier tracking, what changed in an EnvelopeStateChunk.

This will display the changed lines(including line-number within the statechunk)
 + the two lines before it (if existing and not being changed lines themselves)

Changed lines begin with:
line xx >>  


Before monitoring starts, a dialog will ask you, whether to monitor only the, at that time of the dialog, currently selected envelope(choose yes), 
or if you want to monitor other selected envelopes during scriptrun as well(choose No).

After that, it will ask you, whether to put the changed lines into the clipboard.

When changing a selected envelope, it will show all lines of the envelope-state-chunk.
So if you just want to see the change in a selected envelope, select it first, then apply the change.

Meo Mespotine mespotine.de - 1st of november 2018"]]
 
reaper.MB(text, "Item-StateChunk Diff-monitor-tool 1.0", 0)

selected=reaper.MB("Use Currently Selected Envelope Only? \n\nSelect No to monitor another selected Envelope during scriptrun.", "", 4)
if selected==6 then Item=reaper.GetSelectedEnvelope(0) if Item==nil then reaper.MB("No MediaItem selected. Quitting now.", "Ooops...", 0) return end end

A=reaper.MB("Put Difs to Clipboard?", "", 4)

main()
