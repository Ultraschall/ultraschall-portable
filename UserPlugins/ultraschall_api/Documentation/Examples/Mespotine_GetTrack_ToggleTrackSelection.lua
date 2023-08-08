-- How to toggle selection of all tracks?
-- coded by Meo-Ada Mespotine and licensed under MIT-license and can be used freely

-- let's go through all existing tracks
for tracknumber=0, reaper.CountTracks(0)-1 do
  -- get the track-object of the first track and put it into the variable tr
  local tr=reaper.GetTrack(0, tracknumber)
  
  -- find out, if the track is selected (selected==true) or if the track is unselected (selected==false)
  local selected=reaper.IsTrackSelected(tr)
  
  if selected==true then 
    -- set track unselected, if it's already selected
    reaper.SetTrackSelected(tr, false) 
  else
    -- else set track selected, if it's already unselected
    reaper.SetTrackSelected(tr, true)
  end
end
