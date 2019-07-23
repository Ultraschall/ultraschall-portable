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
]]


--retval, result = reaper.GetUserInputs("Edit ID3 Podcast Metadata", 6, "Title:,Artist:,Podcast:,Year:,Genre:,Comment:,extrawidth=300, separator=\b", reaper.GetSetProjectNotes(0, false, ""))

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- get current notes and split them at linefeed
Acount, split_string = ultraschall.SplitStringAtLineFeedToArray(reaper.GetSetProjectNotes(0, false, ""))

-- Get Userinputs for metadata
retval, number_of_inputfields, returnvalues = ultraschall.GetUserInputs("Edit ID3 Podcast Metadata", {"Title:", "Artist:", "Podcast:", "Year:", "Genre:", "Comment:"}, split_string, 300)

-- if user has entered values and hit OK, put them into Project Notes
if retval==true then
  result=""
  for i=1, number_of_inputfields do
    result=result..returnvalues[i].."\n"
  end
  notes = reaper.GetSetProjectNotes(0, true, result:sub(1,-2)) -- write new notes
end

