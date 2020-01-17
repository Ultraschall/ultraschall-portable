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

oldnotes=reaper.GetSetProjectNotes(0, false, "")
oldnotes=string.gsub(oldnotes, "\n", "\b")

if oldnotes=="" then
  Date = os.date("*t")
  oldnotes="\b\b\b"..Date.year
end


--if olll==nil then return end

retval, result = reaper.GetUserInputs("Edit ID3 Podcast Metadata", 6, "Episode Title:,Author:,Podcast:,Year:,Podcast Category:,Description:,extrawidth=300, separator=\b", oldnotes)



result=string.gsub(result, "\b", "\n")

if retval == true then
  notes = reaper.GetSetProjectNotes(0, true, result) -- write new notes
end