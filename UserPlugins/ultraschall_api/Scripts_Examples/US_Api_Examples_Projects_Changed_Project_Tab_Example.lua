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

-- Ultraschall-API demoscript by Meo Mespotine 29.10.2018
-- 
-- shows the number of projecttabs, that have been reordered, newly created or closed since last change
-- will display it in the Reaper-Console

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function main()
  retval, countReorderedProj, reorderedProj, countNewProj, newProj, countClosedProj, closedProj = ultraschall.CheckForChangedProjectTabs(true)
  if retval==true then reaper.ClearConsole() reaper.ShowConsoleMsg("Since "..os.date()..", there have been: \n\n"..countReorderedProj.." project-tab(s) reordered\n"..countNewProj.." project-tab(s) newly created and\n"..countClosedProj.." project-tab(s) been closed") end  

  reaper.defer(main)
end

retval=true
main()
