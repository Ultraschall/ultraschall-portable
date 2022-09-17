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

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

LockedTracksString=""
gfx.init("tudelu",40,40,0,1000,700)

function LockedTracks()
  retval1, LockedTracksString=reaper.GetUserInputs("Lock Tracks", 1, "Tracks separated by a comma", LockedTracksString)
  
end

function GetLiveEditMarkerTimes()
  num=reaper.CountProjectMarkers(0)
  markers={}
  markerpos={}
  zaehler=0
  for i=0, num do
    retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    temp=name:match("_LiveEdit:(.)")
    if temp~=nil then zaehler=zaehler+1 markers[zaehler]=temp markerpos[zaehler]=pos end
  end
  return zaehler, markers, markerpos
end

function DoTheCuts()
  C,D,E=GetLiveEditMarkerTimes()
  for i=1, C do
    if E[i+1]==nil then pos2=reaper.GetProjectLength() else pos2=E[i+1] end
    ultraschall.SectionCut(E[i], pos2, ultraschall.InverseTrackstring(D[i]..LockedTracksString, reaper.CountTracks(0)))
--    ultraschall.SectionCut(tonumber(E[i]), tonumber(pos2), "1,2,3")
--    ultraschall.SectionCut(10, pos2, "1,2,3")
    reaper.UpdateArrange()
  end
end

function main()
  B=gfx.getchar()
  if B==49 then reaper.AddProjectMarker2(0, false, reaper.GetPlayPosition(), 0, "_LiveEdit:1", 0, 0) end
  if B==50 then reaper.AddProjectMarker2(0, false, reaper.GetPlayPosition(), 0, "_LiveEdit:2", 0, 0) end
  if B==51 then reaper.AddProjectMarker2(0, false, reaper.GetPlayPosition(), 0, "_LiveEdit:3", 0, 0) end
  if B==52 then reaper.AddProjectMarker2(0, false, reaper.GetPlayPosition(), 0, "_LiveEdit:4", 0, 0) end
  if B==53 then reaper.AddProjectMarker2(0, false, reaper.GetPlayPosition(), 0, "_LiveEdit:5", 0, 0) end
  if B==54 then reaper.AddProjectMarker2(0, false, reaper.GetPlayPosition(), 0, "_LiveEdit:6", 0, 0) end
  if B==55 then reaper.AddProjectMarker2(0, false, reaper.GetPlayPosition(), 0, "_LiveEdit:7", 0, 0) end
  if B==56 then reaper.AddProjectMarker2(0, false, reaper.GetPlayPosition(), 0, "_LiveEdit:8", 0, 0) end
  if B==57 then reaper.AddProjectMarker2(0, false, reaper.GetPlayPosition(), 0, "_LiveEdit:9", 0, 0) end
  if B==115 then DoTheCuts() end
  if B==108 then LockedTracks() end
  gfx.update()  
  reaper.defer(main)
end

main()
