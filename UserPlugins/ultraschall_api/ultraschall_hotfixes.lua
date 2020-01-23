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
ultraschall.hotfixdate="23_January_2020"

--ultraschall.ShowLastErrorMessage()

function ultraschall.RemoveFXStateChunkFromItemStateChunk(ItemStateChunk, take_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RemoveFXStateChunkFromItemStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string alteredItemStateChunk = ultraschall.RemoveFXStateChunkFromItemStateChunk(string ItemStateChunk, integer take_id)</functioncall>
  <description>
    Removes a certain Take-FXStateChunk from an ItemStateChunk.
    
    Returns nil in case of failure.
  </description>
  <parameters>
     string ItemStateChunk - the ItemStateChunk, from which you want to remove an FXStateChunk
     integer take_id - the take, whose FXStateChunk you want to remove
  </parameters>
  <retvals>
    string alteredItemStateChunk - the StateChunk, from which the FXStateChunk was removed
  </retvals>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fxmanagement, remove, fxstatechunk, statechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidItemStateChunk(ItemStateChunk)==false then ultraschall.AddErrorMessage("RemoveFXStateChunkFromItemStateChunk", "ItemStateChunk", "Must be a valid ItemStateChunk!", -1) return nil end
  if math.type(take_id)~="integer" then ultraschall.AddErrorMessage("RemoveFXStateChunkFromItemStateChunk", "take_id", "Must be an integer", -2) return nil end
  local OldFXStateChunk=ultraschall.GetFXStateChunk(ItemStateChunk, take_id)
  if OldFXStateChunk==nil then ultraschall.AddErrorMessage("RemoveFXStateChunkFromItemStateChunk", "take_id", "No FXChain in this take available", -3) return nil end
  
  ItemStateChunk=ultraschall.StateChunkLayouter(ItemStateChunk)
  local Startpos, Endpos = string.find (ItemStateChunk, OldFXStateChunk, 1, true)
  return string.gsub(ItemStateChunk:sub(1, Startpos)..ItemStateChunk:sub(Endpos+1, -1), "\n%s-\n", "\n")
end

function ultraschall.GetFXStateChunk(StateChunk, TakeFXChain_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.GetFXStateChunk(string StateChunk, optional integer TakeFXChain_id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns an FXStateChunk from a TrackStateChunk or a MediaItemStateChunk.
    
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    Returns nil in case of an error or if no FXStateChunk has been found.
  </description>
  <retvals>
    string FXStateChunk - the FXStateChunk, stored in the StateChunk
  </retvals>
  <parameters>
    string StateChunk - the StateChunk, from which you want to retrieve the FXStateChunk
    optional integer TakeFXChain_id - when using MediaItemStateChunks, this allows you to choose the take of which you want the FXChain; default is 1
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fxmanagement, get, fxstatechunk, trackstatechunk, mediaitemstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidTrackStateChunk(StateChunk)==false and ultraschall.IsValidMediaItemStateChunk(StateChunk)==false then ultraschall.AddErrorMessage("GetFXStateChunk", "StateChunk", "no valid Track/ItemStateChunk", -1) return end
  if TakeFXChain_id~=nil and math.type(TakeFXChain_id)~="integer" then ultraschall.AddErrorMessage("GetFXStateChunk", "TakeFXChain_id", "must be an integer", -2) return end
  if TakeFXChain_id==nil then TakeFXChain_id=1 end
  
  if string.find(StateChunk, "\n  ")==nil then
    StateChunk=ultraschall.StateChunkLayouter(StateChunk)
  end
  for w in string.gmatch(StateChunk, " <FXCHAIN.-\n  >") do
    return w
  end
  local count=0
  local FXStateChunk
      
  StateChunk=string.gsub(StateChunk, "TAKE\n", "TAKEend\n  TAKE\n")
  StateChunk="  TAKE\n"..StateChunk.."\n  TAKEend\n"

  for w in string.gmatch(StateChunk, "(  TAKE\n.-)\n  TAKEend\n") do
    count=count+1
    if TakeFXChain_id==count then
      FXStateChunk=w:match("  <TAKEFX.-\n  >")
      if FXStateChunk==nil then ultraschall.AddErrorMessage("GetFXStateChunk", "TakeFXChain_id", "No FXChain in this take available", -3) end
      return FXStateChunk
    end
  end
end

function ultraschall.SetFXStateChunk(StateChunk, FXStateChunk, TakeFXChain_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredStateChunk = ultraschall.SetFXStateChunk(string StateChunk, string FXStateChunk, optional integer TakeFXChain_id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets an already existing FXStateChunk in a TrackStateChunk or a MediaItemStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful
    optional string alteredStateChunk - the altered StateChunk
  </retvals>
  <parameters>
    string StateChunk - the TrackStateChunk, into which you want to set the FXChain
    string FXStateChunk - the FXStateChunk, which you want to set into the TrackStateChunk
    optional integer TakeFXChain_id - when using MediaItemStateChunks, this allows you to choose the take of which you want the FXChain; default is 1
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fx management, set, trackstatechunk, mediaitemstatechunk, fxstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if ultraschall.IsValidTrackStateChunk(StateChunk)==false and ultraschall.IsValidMediaItemStateChunk(StateChunk)==false then ultraschall.AddErrorMessage("SetFXStateChunk", "StateChunk", "no valid Track/ItemStateChunk", -1) return false end
  if TakeFXChain_id~=nil and math.type(TakeFXChain_id)~="integer" then ultraschall.AddErrorMessage("SetFXStateChunk", "TakeFXChain_id", "must be an integer", -3) return false end
  if TakeFXChain_id==nil then TakeFXChain_id=1 end
  local OldFXStateChunk=ultraschall.GetFXStateChunk(StateChunk, TakeFXChain_id)
  if OldFXStateChunk==nil then ultraschall.AddErrorMessage("SetFXStateChunk", "TakeFXChain_id", "no FXStateChunk found", -4) return false end
  OldFXStateChunk=string.gsub(OldFXStateChunk, "\n%s*", "\n")  
  OldFXStateChunk=string.gsub(OldFXStateChunk, "^%s*", "")
  
  local Start, Stop = string.find(StateChunk, OldFXStateChunk, 0, true)
  StateChunk=StateChunk:sub(1,Start-1)..FXStateChunk:sub(2,-1)..StateChunk:sub(Stop+1,-1)
  StateChunk=string.gsub(StateChunk, "\n%s*", "\n")
  return true, StateChunk
end