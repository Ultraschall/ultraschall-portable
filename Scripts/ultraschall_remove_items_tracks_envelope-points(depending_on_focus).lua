Length=reaper.GetProjectLength()

reaper.Main_OnCommand(40697, 0)

Length2=reaper.GetProjectLength()

Diff=Length2-Length

if Diff~=0 and reaper.GetPlayState()~=0 and reaper.GetCursorContext()==1 and reaper.GetToggleCommandState(40311)==1 then
  reaper.SetEditCurPos(reaper.GetPlayPosition()+Diff, false, true)
end
