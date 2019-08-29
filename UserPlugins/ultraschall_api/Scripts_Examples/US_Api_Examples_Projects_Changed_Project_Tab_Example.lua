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
