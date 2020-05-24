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
]]

-- converts, if necessary old Metadata from Ultraschall 4 and lower to Ultraschall4.1 and higher format
-- 24th of May 2020, Meo-Ada Mespotine

-- read out Metadata (Ultraschall 4.1 and higher)
retval1, Title    = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TIT2", false)
retval2, Podcast  = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TALB", false)
retval3, Author   = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TPE1", false)
retval4, Year     = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TYER", false)
retval5, Category = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TCON", false)
retval6, Description = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:COMM", false)


-- If the metadata is from projects of Ultraschall 4.0 and lower, read it in from Project Notes
if Title=="" and Podcast=="" and Author=="" and Year=="" and Category=="" and Description=="" then
  oldnotes=reaper.GetSetProjectNotes(0, false, "").."\n"
  
  Title, Author, Podcast, Year, Category, Description = oldnotes:match("(.-)\n(.-)\n(.-)\n(.-)\n(.-)\n(.-)\n")
  
  if Title==nil       then Title="" end
  if Author==nil      then Author="" end
  if Podcast==nil     then Podcast="" end
  if Year==nil        then Year="" end
  if Category==nil    then Category="" end
  if Description==nil then Description="" end

  -- if no year is set already, set it to the current year
  if Year=="" then
    Date = os.date("*t")
    Year=Date.year
  end
  
  retval1, Title = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TIT2|"..Title, true)
  retval2, Podcast = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TALB|"..Podcast, true)
  retval3, Author = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TPE1|"..Author, true)
  retval4, Year = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TYER|"..Year, true)
  retval5, Category = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TCON|"..Category, true)
  retval6, Description = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:COMM|"..Description, true)
end

cmdid=reaper.NamedCommandLookup("_ULTRASCHALL_INSERT_MEDIA_PROPERTIES")
--_ULTRASCHALL_CONVERT_OLD_METADATA_AND_INSERT_MEDIA_PROPERTIES
reaper.Main_OnCommand(cmdid,0)
