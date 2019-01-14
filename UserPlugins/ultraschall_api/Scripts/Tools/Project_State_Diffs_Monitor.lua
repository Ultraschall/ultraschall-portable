--[[

Display Project-changes in the rpp-file.
  
This displays diffs in a RPP-projectfile, for easier tracking, what changed in the ProjectStateChunk.

This constantly saves the current project, so be aware of that!
 
Projectfiles include Projectbay, Extension-stuff, TrackStateChunks who include MediaItemStateChunk of MediaItems in that given track, as well as TrackEnvelopes and ItemEnvelopes and many other settings in the project.

This will display the changed lines(including line-number within the statechunk)
 + the two lines before it (if existing and not being changed lines themselves)

Changed lines begin with:
line xx >>  

It will ask you, whether to put the changed lines into the clipboard.

Meo Mespotine mespotine.de - 31st of october 2018
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

function ReadFullFile(filename_with_path, binary)
  -- Returns the whole file filename_with_path or nil in case of error
  -- check parameters
  if filename_with_path == nil then return nil end
  if reaper.file_exists(filename_with_path)==false then return nil end
  
  -- prepare variables
  if binary==true then binary="b" else binary="" end
  local linenumber=0
  
  -- read file
  local file=io.open(filename_with_path,"r"..binary)
  local filecontent=file:read("a")
  
  -- count lines in file, when non binary
  if binary~=true then
    for w in string.gmatch(filecontent, "\n") do
      linenumber=linenumber+1
    end
  else
    linenumber=-1
  end
  file:close()
  -- return read file, length and linenumbers
  return filecontent, filecontent:len(), linenumber
end

timer=reaper.time_precise()+3
oldprojsc="\nlol"

function main()
  reaper.Main_SaveProject(0,false)
  Project, Filename=reaper.EnumProjects(-1,"")
  projsc=ReadFullFile(Filename)
    if oldprojsc:match("(\n.*)")~=projsc:match("(\n.*)") then
      count1, split_string1 = SplitStringAtLineFeedToArray(oldprojsc)
      count2, split_string2 = SplitStringAtLineFeedToArray(projsc)
      if split_string1==nil then split_string1={} end
      reaper.ClearConsole()
      reaper.ShowConsoleMsg("Monitoring StateChunk-changes in proj: "..Filename.."\n\n")
      a=-10
      temp=""
      for i=1, count2 do
        if split_string1[i]~=split_string2[i] and proj==oldproj then
          if a~=-10 and (a<i-2 or a<i-2) then reaper.ShowConsoleMsg("\n\n") end
          if a<i-2 and i-2>0 then reaper.ShowConsoleMsg("Change:\n\t"..split_string2[i-2].."\n") end
          if a<i-1 and i-1>0 then reaper.ShowConsoleMsg("\t"..split_string2[i-1].."\n") end
          if A==6 then temp=temp.."line "..i.." >>  "..split_string2[i].."\n" end
          reaper.ShowConsoleMsg("line "..i.." >>  "..split_string2[i].."\n")
          a=i
        elseif proj~=oldproj then
          if A==6 then temp=temp..split_string2[i].."\n" end
          reaper.ShowConsoleMsg(split_string2[i].."\n")
        end        
      end
      if A==6 and temp~="" then reaper.CF_SetClipboard("Monitoring StateChunk-changes in proj: "..Filename.."\n\n"..temp.."\n") end
    end
    oldprojsc=projsc
    oldproj=proj
  reaper.defer(main)
end

text=[[Display Project-changes in the rpp-file.
  
This displays diffs in a RPP-projectfile, for easier tracking, what changed in the ProjectStateChunk.

This constantly saves the current project, so be aware of that!
 
Projectfiles include Projectbay, Extension-stuff, TrackStateChunks who include MediaItemStateChunk of MediaItems in that given track, as well as TrackEnvelopes and ItemEnvelopes and many other settings in the project.

This will display the changed lines(including line-number within the statechunk)
 + the two lines before it (if existing and not being changed lines themselves)

Changed lines begin with:
line xx >>  

It will ask you, whether to put the changed lines into the clipboard.

Meo Mespotine mespotine.de - 31st of october 2018"]]
 
reaper.MB(text, "Project-StateChunk Diff-monitor-tool 1.0", 0)

a=-10
A=reaper.MB("Put Difs to Clipboard?", "", 4)

main()
