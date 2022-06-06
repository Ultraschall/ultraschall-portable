  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

Display Project-changes in the rpp-file.
  
This displays diffs in a RPP-projectfile, for easier tracking, what changed in the ProjectStateChunk.

This constantly saves the current project, so be aware of that!
 
Projectfiles include Projectbay, Extension-stuff, TrackStateChunks who include MediaItemStateChunk of MediaItems in that given track, as well as TrackEnvelopes and ItemEnvelopes and many other settings in the project.

This will display the changed lines(including line-number within the statechunk)
 + the two lines before it (if existing and not being changed lines themselves)

It will ask you, whether to put the changed lines into the clipboard.

Meo Mespotine mespotine.de - 21 of January 2021
--]]

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

Proj, ProjFileName=reaper.EnumProjects(-1)

P=0
function main()
  P=P+1
  if P==10 then
    reaper.Main_SaveProject(Proj, false)
    Contents, correctnumberoflines, number_of_lines = ultraschall.ReadFileAsLines_Array(ProjFileName, 1, -1)
    Diffs=""
    
    if OldContents==nil then
      OldContents=Contents
      OldLength=number_of_lines
    else
      table_copy = ultraschall.MakeCopyOfTable(Contents)
      table_copy2={}
      for i=2, number_of_lines do
        for a=2, OldLength do
          if table_copy[i]==OldContents[a] then table_copy[i]=nil end
        end
      end

      first=true
      for i=2, number_of_lines do
        if table_copy[i]~=nil then 
          if i>=2 and table_copy[i-2]==nil and table_copy[i-1]==nil then print("\n\t     "..Contents[i-2]) Diffs=Diffs.."\n\t     "..Contents[i-2] end
          if i>=3 and table_copy[i-1]==nil then print("\t     "..Contents[i-1]) Diffs=Diffs.."\n\t     "..Contents[i-1] end
          print("  "..i.."\t:    "..table_copy[i]) Diffs=Diffs.."\n  "..i.."\t:"..table_copy[i]
          if i<number_of_lines and table_copy[i+1]==nil then print("\t     "..Contents[i+1]) Diffs=Diffs.."\n\t     "..Contents[i+1].."\n" end
          

          yes=true 
        end
      end
      if yes==true then print("***") end
      
      if yes==true and ToClipboard==6 then print3(Diffs.."\n") end
      
      yes=false
    end
    
    OldContents=Contents
    OldLength=number_of_lines  
    P=0
  end
  reaper.defer(main)
end

main()

text=[[Display Project-changes in the rpp-file.
  
This displays diffs in a RPP-projectfile, for easier tracking, what changed in the ProjectStateChunk.

This constantly saves the current project, so be aware of that!
 
Projectfiles include Projectbay, Extension-stuff, TrackStateChunks who include MediaItemStateChunk of MediaItems in that given track, as well as TrackEnvelopes and ItemEnvelopes and many other settings in the project.

This will display the changed lines(including line-number within the statechunk)
 + the two lines before it and the one after it

It will ask you, whether to put the changed lines into the clipboard.

Meo Mespotine mespotine.de - 21st of January 2021"]]
 
reaper.MB(text, "Project-StateChunk Diff-monitor-tool 2.0", 0)

a=-10
ToClipboard=reaper.MB("Put Difs to Clipboard?", "", 4)

main()
