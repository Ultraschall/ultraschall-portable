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

-- This is the file for hotfixes of buggy functions.

-- If you have found buggy functions, you can submit fixes within here.
--      a) copy the function you found buggy into ultraschall_hotfixes.lua
--      b) debug the function IN HERE(!)
--      c) comment, what you've changed(this is for me to find out, what you did)
--      d) add information to the <US_DocBloc>-bloc of the function. So if the information in the
--         <US_DocBloc> isn't correct anymore after your changes, rewrite it to fit better with your fixes
--      e) add as an additional comment in the function your name and a link to something you do(the latter, if you want), 
--         so I can credit you and your contribution properly
--      f) submit the file as PullRequest via Github: https://github.com/Ultraschall/Ultraschall-Api-for-Reaper.git (preferred !)
--         or send it via lspmp3@yahoo.de(only if you can't do it otherwise!)
--
-- As soon as these functions are in here, they can be used the usual way through the API. They overwrite the older buggy-ones.
--
-- These fixes, once I merged them into the master-branch, will become part of the current version of the Ultraschall-API, 
-- until the next version will be released. The next version will has them in the proper places added.
-- That way, you can help making it more stable without being dependent on me, while I'm busy working on new features.
--
-- If you have new functions to contribute, you can use this file as well. Keep in mind, that I will probably change them to work
-- with the error-messaging-system as well as adding information for the API-documentation.
ultraschall.hotfixdate="XX_XXX_XXXX"

--ultraschall.ShowLastErrorMessage()

function ultraschall.TimeToMeasures(project, Time)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>TimeToMeasures</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>number measure = ultraschall.TimeToMeasures(ReaProject project, number Time))</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
       a function which converts a time into current projects time-measures
       only useful, when there are no tempo-changes in the project
       
       returns nil in case of an error
    </description>
    <retvals>
      number measure - the measures, that parameter time needs to be reflected
    </retvals>
    <parameters>
        ReaProject project  - ReaProject to use the timesignature-settings from
        number time         - in seconds, the time to convert into a time-measurment, which can be
                            - used in config-variable "prerollmeas"
    </parameters>
    <chapter_context>
      API-Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, convert, time, to measures</tags>
  </US_DocBloc>
  --]]
  -- quick function that converts a time into current projects time-measures
  -- only useful, when there are no tempo-changes in the project
  --
  -- parameters:
  --  project - ReaProject to use the timesignature-settings from
  --  time    - in seconds, the time to convert into a time-measurment, which can be
  --             used in config-variable "prerollmeas"
  --
  -- retval:
  --  measure - the measures, that parameter time needs to be reflected
  --print2(ultraschall.type(Time))
  if project~=0 and ultraschall.type(project)~="ReaProject" then ultraschall.AddErrorMessage("TimeToMeasures", "project", "must be a ReaProject", -1) return end
  if ultraschall.type(Time):sub(1,7)~="number:" then ultraschall.AddErrorMessage("TimeToMeasures", "Time", "must be a number in seconds", -2) return end
  local Measures=reaper.TimeMap2_beatsToTime(project, 0, 1)
  local retval, measures, cml, fullbeats, cdenom = reaper.TimeMap2_timeToBeats(project, 10)
  local QN=reaper.TimeMap2_timeToQN(project, 1)
  local Measures_Fin=Measures/cdenom
  local Measures_Fin2=Measures_Fin*Time
  return Measures_Fin2
end


