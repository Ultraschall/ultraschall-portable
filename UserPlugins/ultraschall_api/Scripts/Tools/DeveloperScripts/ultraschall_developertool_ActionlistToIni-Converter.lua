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

-- Dumped-Actionlist to Ini-File-Converter
-- by Meo Mespotine mespotine.de 26.4.2018

-- converts a dumped Reaper-action-list into an ini-file
-- to get a dumped-action-list, run the action 
--    _S&M_DUMP_CUST_ACTION_LIST - "SWS/S&M: Dump action list (all but custom actions)"
-- in the actions-list-dialog (needs SWS to be installed)
--
-- will create the file in the same folder as the selected one, with .ini as extension

retval, filename = reaper.GetUserFileNameForRead("", "Select dumped actionlist", "*.txt")
if retval==false then return end

--filename="c:/Users/meo/Desktop/Reaper-Menu-Only-Actions.txt" -- the action-list

filename_ini=filename:sub(1,-4).."ini" 

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

reaper.CF_LocateInExplorer(filename_ini)
