-- Dumped-Actionlist to Ini-File-Converter
-- by Meo Mespotine mespotine.de 26.4.2018

-- converts a dumped Reaper-action-list into an ini-file
-- to get a dumped-action-list, run the action 
--    _S&M_DUMP_CUST_ACTION_LIST - "SWS/S&M: Dump action list (all but custom actions)"
-- in the actions-list-dialog (needs SWS to be installed)
--
-- change the filename-variables and run it

filename="c:/Users/meo/Desktop/Reaper-Menu-Only-Actions.txt" -- the action-list
filename_ini="c:/Users/meo/Desktop/Reaper-Menu-Only-Actions.ini" -- the ini-file to be created

for c in io.lines(filename) do
  section, action, description=c:match("(.-)\t(.-)\t(.*)")
  if section=="Main" then
    reaper.BR_Win32_WritePrivateProfileString("Main", action, description, filename_ini)
  elseif section=="Media Explorer" then
    reaper.BR_Win32_WritePrivateProfileString("Media Explorer", action, description, filename_ini)
  elseif section=="MIDI Editor" then
    reaper.BR_Win32_WritePrivateProfileString("MIDI Editor", action, description, filename_ini)
  elseif section=="MIDI Event List Editor" then
    reaper.BR_Win32_WritePrivateProfileString("MIDI Event List Editor", action, description, filename_ini)
  elseif section=="MIDI Inline Editor" then
    reaper.BR_Win32_WritePrivateProfileString("MIDI Inline Editor", action, description, filename_ini)
  end
end
