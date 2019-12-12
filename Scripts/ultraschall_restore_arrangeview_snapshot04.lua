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

-- written by Meo Mespotine 29th of November 2019 - ultraschall.fm

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

if ultraschall==nil then reaper.MB("Sorry, this script needs Ultraschall API installed. See ultraschall.fm/api for more details.", "Ooops", 0) return end

-- get snapshot
is_new_value, filename = reaper.get_action_context()
slot=tonumber(filename:match("snapshot(.-).lua")) -- get slotnumber from scriptfilename(yes, I'm lazy ;) )

-- restore arrangeview-snapshot
ultraschall.RestoreArrangeviewSnapshot(slot)
