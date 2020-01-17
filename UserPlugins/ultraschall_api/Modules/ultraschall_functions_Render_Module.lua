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

-------------------------------------
--- ULTRASCHALL - API - FUNCTIONS ---
-------------------------------------
---         Render  Module        ---
-------------------------------------

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Render-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  if string=="" then string=10000 
  else 
    string=tonumber(string) 
    string=string+1
  end
  if string2=="" then string2=10000 
  else 
    string2=tonumber(string2)
    string2=string2+1
  end 
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "Functions-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  
  ultraschall.API_TempPath=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/temp/"
end


function ultraschall.GetRenderCFG_Settings_FLAC(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_FLAC</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer encoding_depth, integer compression = ultraschall.GetRenderCFG_Settings_FLAC(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for flac.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer encoding_depth - the encoding-depth of the flac in bits(16 to 24)
      integer compression - the data-compression speed from fastest and worst efficiency(0) to slowest but best efficiency(8); default is 5
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the flac-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, flac, encoding depth, compression</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_FLAC", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="calf" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_FLAC", "rendercfg", "not a render-cfg-string of the format flac", -2) return -1 end

  return string.byte(Decoded_string:sub(5,5)), string.byte(Decoded_string:sub(9))
end


--D,D2=ultraschall.GetRenderCFG_Settings_FLAC(B)


function ultraschall.GetRenderCFG_Settings_AIFF(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_AIFF</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer bitdepth = ultraschall.GetRenderCFG_Settings_AIFF(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for aiff.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer bitdepth - the bitdepth of the AIFF-file(8, 16, 24, 32)
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the aiff-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, aiff, bitdepth</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AIFF", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="ffia" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AIFF", "rendercfg", "not a render-cfg-string of the format aiff", -2) return -1 end
  return string.byte(Decoded_string:sub(5,5))
end

--C=ultraschall.GetRenderCFG_Settings_AIFF(B)


function ultraschall.GetRenderCFG_Settings_AudioCD(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_AudioCD</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer trackmode, boolean use_markers_hashes, integer leadin_silence_tracks, integer leadin_silence_disc, boolean burn_cd_after_render = ultraschall.GetRenderCFG_Settings_AudioCD(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for AudioCD.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer trackmode - the trackmode
                        -   0, Markers define new tracks
                        -   1, Regions define tracks (other areas ignored)
                        -   2, One track
      boolean use_markers_hashes - Only use markers starting with #-checkbox; only available when trackmode=0, otherwise it will be ignored
                                 -  true, checkbox is checked; false, checkbox is unchecked
      integer leadin_silence_tracks - the leadin-silence for tracks in milliseconds(0 to 2147483647)
      integer leadin_silence_disc - the leadin-silence for discs in milliseconds(0 to 2147483647)
      boolean burn_cd_after_render - burn cd image after render-checkbox
                                   -    true, checkbox is checked; false, checkbox is unchecked
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the audiocd-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, audiocd, leadin silence, tracks, burn cd, image, markers as hashes</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AudioCD", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string, LeadInSilenceDisc, LeadInSilenceTrack, num_integers, BurnImage, TrackMode, UseMarkers
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~=" osi" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AudioCD", "rendercfg", "not a render-cfg-string of the format audio cd", -2) return -1 end
  LeadInSilenceDisc=Decoded_string:sub(5,8)
  LeadInSilenceTrack=Decoded_string:sub(9,12)
  num_integers, LeadInSilenceDisc = ultraschall.ConvertStringToIntegers(LeadInSilenceDisc, 4)
  num_integers, LeadInSilenceTrack = ultraschall.ConvertStringToIntegers(LeadInSilenceTrack, 4)
  BurnImage=string.byte(Decoded_string:sub(13,13))
  TrackMode=string.byte(Decoded_string:sub(17,17))
  UseMarkers=string.byte(Decoded_string:sub(21,21))
  if BurnImage==1 then BurnImage=true else BurnImage=false end
  if UseMarkers==1 then UseMarkers=true else UseMarkers=false end
  return TrackMode, UseMarkers, LeadInSilenceTrack[1], LeadInSilenceDisc[1], BurnImage
end

--C,D,E,F,G=ultraschall.GetRenderCFG_Settings_AudioCD(B)

function ultraschall.GetRenderCFG_Settings_MP3(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MP3</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Mode, integer enc_quality, integer vbr_quality, integer abr_bitrate, integer cbr_bitrate, boolean no_joint_stereo, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for MP3.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer Mode - the encoding-mode
                   - 32, Target quality(VBR)
                   - 1056, Target bitrate (ABR)
                   - 65344, Constant bitrate (CBR)
                   - 65088, Maximum bitrate/quality
      integer enc_quality - the encoding-quality
                          -   0, Maximum(slow)
                          -   2, Better(recommended)
                          -   3, Normal
                          -   5, Fast encode
                          -   7, Faster encode
                          -   9, Fastest encode
      integer vbr_quality - target-quality for VBR; 0(best 100%) to 9(worst 10%); 4, when Mode is set to  ABR, CBR or Maximum bitrate/quality
      integer abr_bitrate - the average bitrate for ABR in kbps
                          - 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320
      integer cbr_bitrate - the bitrate for CBR in kbps
                          - 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320
      boolean no_joint_stereo - the do not allow joint stereo-checkbox
                              - true, checkbox is checked; false, checkbox is unchecked
      boolean write_replay_gain - the write ReplayGain tag-checkbox
                                - true, checkbox is checked; false, checkbox is unchecked
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the mp3-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp3, vbr, cbr, tbr, max quality</tags>
  </US_DocBloc>
  ]]
  -- Mode:
  --  32 - Target quality(VBR)
  --  1056 - Target bitrate (ABR)
  --  65280 - Constant bitrate (CBR)
  --  65344 - Maximum bitrate/quality
  --
  -- VBR_Quality:
  --  4 - for ABR, CBR, max quality
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string, Mode, Mode2, Mode3, JointStereo, WriteReplayGain, EncodingQuality
  local VBR_Quality, ABR_Bitrate, num_integers, CBR_Bitrate, add
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="l3pm" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3", "rendercfg", "not a render-cfg-string of the format mp3", -2) return -1 end
  EncodingQuality=string.byte(Decoded_string:sub(13,13))
  if EncodingQuality==10 then add=1 else add=0 end
  Mode=string.byte(Decoded_string:sub(5,5))
  Mode2=string.byte(Decoded_string:sub(17,17))
  Mode3=ultraschall.CombineBytesToInteger(0, Mode, Mode2-add)
  JointStereo=string.byte(Decoded_string:sub(9,9))
  if JointStereo==0 then JointStereo=false else JointStereo=true end
  WriteReplayGain=string.byte(Decoded_string:sub(11,11))
  if WriteReplayGain==0 then WriteReplayGain=false else WriteReplayGain=true end
  VBR_Quality=string.byte(Decoded_string:sub(21,21))
  CBR_Bitrate=Decoded_string:sub(25,26)
  num_integers, CBR_Bitrate = ultraschall.ConvertStringToIntegers(CBR_Bitrate, 2)
  ABR_Bitrate=Decoded_string:sub(29,30)
  num_integers, ABR_Bitrate = ultraschall.ConvertStringToIntegers(ABR_Bitrate, 2)
  return Mode3, EncodingQuality, VBR_Quality, ABR_Bitrate[1], CBR_Bitrate[1], JointStereo, WriteReplayGain
end

--C,D,E,F,G,H,I=ultraschall.GetRenderCFG_Settings_MP3(B)

function ultraschall.GetRenderCFG_Settings_MP3MaxQuality(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MP3MaxQuality</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer retval, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3MaxQuality(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for MP3 with maximum quality-settings.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer retval - 0, the renderstring is a valid MP3-MaxQuality-setting; -1, it is not a valid renderstring for MP3-MaxQuality
      boolean write_replay_gain - the write ReplayGain tag-checkbox
                                - true, checkbox is checked; false, checkbox is unchecked
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the mp3-maxquality-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp3, max quality</tags>
  </US_DocBloc>
  ]]
  if rendercfg=="bDNwbUABAAAAAAQACgAAAP////8EAAAAQAEAAAAAAAA=" then return 0, true end
  if rendercfg=="bDNwbUABAAAAAAAACgAAAP////8EAAAAQAEAAAAAAAA=" then return 0, false end
  ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3MaxQuality", "rendercfg", "no valid renderstring for MP3-Maxquality", -1)
  return -1
end

--C,D,E,F,G,H,I=ultraschall.GetRenderCFG_Settings_MP3(B)


function ultraschall.GetRenderCFG_Settings_MP3CBR(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MP3CBR</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer cbr_bitrate, integer enc_quality, boolean no_joint_stereo, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3CBR(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for MP3 CBR.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer cbr_bitrate - the bitrate for CBR in kbps
                          - 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320
      integer enc_quality - the encoding-quality
                          -   0, Maximum(slow)
                          -   2, Better(recommended)
                          -   3, Normal
                          -   5, Fast encode
                          -   7, Faster encode
                          -   9, Fastest encode
      boolean no_joint_stereo - the do not allow joint stereo-checkbox
                              - true, checkbox is checked; false, checkbox is unchecked
      boolean write_replay_gain - the write ReplayGain tag-checkbox
                                - true, checkbox is checked; false, checkbox is unchecked
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the mp3-cbr-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp3, cbr</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3CBR", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string, Mode, Mode2, Mode3, JointStereo, WriteReplayGain, EncodingQuality
  local VBR_Quality, ABR_Bitrate, num_integers, CBR_Bitrate
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="l3pm" or string.byte(Decoded_string:sub(17,17))~=255 or string.byte(Decoded_string:sub(13,13))==10 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3CBR", "rendercfg", "not a render-cfg-string of the format mp3-cbr", -2) return -1 end

  CBR_Bitrate=Decoded_string:sub(25,26)
  num_integers, CBR_Bitrate = ultraschall.ConvertStringToIntegers(CBR_Bitrate, 2)
  
  EncodingQuality=string.byte(Decoded_string:sub(13,13))
  JointStereo=string.byte(Decoded_string:sub(9,9))
  if JointStereo==0 then JointStereo=false else JointStereo=true end
  WriteReplayGain=string.byte(Decoded_string:sub(11,11))
  if WriteReplayGain==0 then WriteReplayGain=false else WriteReplayGain=true end

  return CBR_Bitrate[1], EncodingQuality, JointStereo, WriteReplayGain
end

--C,D,E,F,G,H,I=ultraschall.GetRenderCFG_Settings_MP3(B)

function ultraschall.GetRenderCFG_Settings_MP3VBR(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MP3VBR</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer vbr_bitrate, integer enc_quality, boolean no_joint_stereo, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3VBR(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for MP3 VBR.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer vbr_quality - the variable-bitrate quality; 1(for 10%) to 10(for 100%) 
      integer enc_quality - the encoding-quality
                          -   0, Maximum(slow)
                          -   2, Better(recommended)
                          -   3, Normal
                          -   5, Fast encode
                          -   7, Faster encode
                          -   9, Fastest encode
      boolean no_joint_stereo - the do not allow joint stereo-checkbox
                              - true, checkbox is checked; false, checkbox is unchecked
      boolean write_replay_gain - the write ReplayGain tag-checkbox
                                - true, checkbox is checked; false, checkbox is unchecked
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the mp3-vbr-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp3, vbr</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3VBR", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string, Mode, Mode2, Mode3, JointStereo, WriteReplayGain, EncodingQuality
  local VBR_Quality, ABR_Bitrate, num_integers, CBR_Bitrate
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="l3pm" or string.byte(Decoded_string:sub(17,17))~=0 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3VBR", "rendercfg", "not a render-cfg-string of the format mp3-vbr", -2) return -1 end

  VBR_Quality=string.byte(Decoded_string:sub(21,21))
  VBR_Quality=(VBR_Quality-10)*-1
  
  
  EncodingQuality=string.byte(Decoded_string:sub(13,13))
  JointStereo=string.byte(Decoded_string:sub(9,9))
  if JointStereo==0 then JointStereo=false else JointStereo=true end
  WriteReplayGain=string.byte(Decoded_string:sub(11,11))
  if WriteReplayGain==0 then WriteReplayGain=false else WriteReplayGain=true end

  return VBR_Quality, EncodingQuality, JointStereo, WriteReplayGain
end

--C,D,E,F,G,H,I=ultraschall.GetRenderCFG_Settings_MP3(B)


function ultraschall.GetRenderCFG_Settings_MP3ABR(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MP3ABR</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer bitrate, integer enc_quality, boolean no_joint_stereo, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3ABR(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for MP3 ABR.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer bitrate -   the encoding quality for the mp3
                      -      0, 8 kbps
                      -      1, 16 kbps
                      -      2, 24 kbps
                      -      3, 32 kbps
                      -      4, 40 kbps
                      -      5, 48 kbps
                      -      6, 56 kbps
                      -      7, 64 kbps
                      -      8, 80 kbps
                      -      9, 96 kbps
                      -      10, 112 kbps
                      -      11, 128 kbps
                      -      12, 160 kbps
                      -      13, 192 kbps
                      -      14, 224 kbps
                      -      15, 256 kbps
                      -      16, 320 kbps 
      integer enc_quality - the encoding-quality
                          -   0, Maximum(slow)
                          -   2, Better(recommended)
                          -   3, Normal
                          -   5, Fast encode
                          -   7, Faster encode
                          -   9, Fastest encode
      boolean no_joint_stereo - the do not allow joint stereo-checkbox
                              - true, checkbox is checked; false, checkbox is unchecked
      boolean write_replay_gain - the write ReplayGain tag-checkbox
                                - true, checkbox is checked; false, checkbox is unchecked
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the mp3-abr-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp3, abr</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3ABR", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string, Mode, Mode2, Mode3, JointStereo, WriteReplayGain, EncodingQuality
  local VBR_Quality, ABR_Bitrate, num_integers, CBR_Bitrate
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="l3pm" or string.byte(Decoded_string:sub(17,17))~=4 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3ABR", "rendercfg", "not a render-cfg-string of the format mp3-abr", -2) return -1 end

  ABR_Bitrate=Decoded_string:sub(29,30)
  num_integers, ABR_Bitrate = ultraschall.ConvertStringToIntegers(ABR_Bitrate, 2)  
  
  EncodingQuality=string.byte(Decoded_string:sub(13,13))
  JointStereo=string.byte(Decoded_string:sub(9,9))
  if JointStereo==0 then JointStereo=false else JointStereo=true end
  WriteReplayGain=string.byte(Decoded_string:sub(11,11))
  if WriteReplayGain==0 then WriteReplayGain=false else WriteReplayGain=true end

  return ABR_Bitrate[1], EncodingQuality, JointStereo, WriteReplayGain
end

--C,D,E,F,G,H,I=ultraschall.GetRenderCFG_Settings_MP3(B)

function ultraschall.GetRenderCFG_Settings_OGG(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_OGG</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Mode, integer VBR_quality, integer CBR_KBPS, integer ABR_KBPS, integer ABR_KBPS_MIN, integer ABR_KBPS_MAX = ultraschall.GetRenderCFG_Settings_OGG(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for OGG.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer Mode - the mode for the ogg-file; 0, VBR; 1, CBR; 2, ABR 
      integer VBR_quality - the quality for VBR-mode; a floating-value between 0 and 1
      integer CBR_KBPS - the bitrate for CBR-mode; 0 to 4294967295 
      integer ABR_KBPS - the bitrate for ABR-mode; 0 to 4294967295
      integer ABR_KBPS_MIN - the minimum bitrate for ABR-mode; 0 to 4294967295
      integer ABR_KBPS_MAX - the maximum bitrate for ABR-mode; 0 to 4294967295
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the ogg-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, ogg, vbr, cbr, tbr, max quality</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_OGG", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, Mode, VBR_quality, CBR_Bitrate, ABR_Bitrate, ABRmin_Bitrate, ABRmax_Bitrate
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="vggo" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_OGG", "rendercfg", "not a render-cfg-string of the format ogg", -2) return -1 end
  num_integers, VBR_quality = ultraschall.ConvertStringToIntegers(Decoded_string:sub(5,8), 4)
  VBR_quality = ultraschall.IntToDouble(VBR_quality[1])
  Mode=string.byte(Decoded_string:sub(9,9))
  num_integers, CBR_Bitrate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(10,13), 4)
  num_integers, ABR_Bitrate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(14,17), 4)
  num_integers, ABRmin_Bitrate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(18,21), 4)
  num_integers, ABRmax_Bitrate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(22,25), 4)
  
  return Mode, VBR_quality, CBR_Bitrate[1], ABR_Bitrate[1], ABRmin_Bitrate[1], ABRmax_Bitrate[1]
end


function ultraschall.GetRenderCFG_Settings_OPUS(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_OPUS</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Mode, integer Bitrate, integer Complexity, boolean channel_audio, boolean per_channel = ultraschall.GetRenderCFG_Settings_OPUS(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for Opus.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer Mode - the Mode for the Opus-file; 0, VBR; 1, CVBR; 2, HARDCBR 
      integer Bitrate - the kbps of the opus-file; between 1 and 256 
      integer Complexity - the complexity-setting between 0(lowest quality) and 10(highest quality, slow encoding) 
      boolean channel_audio - true, Encode 3-8 channel audio as 2.1-7.1(LFE) -> checked; false, DON'T Encode 3-8 channel audio as 2.1-7.1(LFE) -> unchecked
      boolean per_channel - true, kbps per channel (6-256); false, kbps combined for all channels 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the opus-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, opus, vbr, cbr, cvbr</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_OPUS", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, Mode, Bitrate, Complexity, Encode1, Encode2, Combine, Encode
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="SggO" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_OPUS", "rendercfg", "not a render-cfg-string of the format opus", -2) return -1 end
  num_integers, Bitrate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(6,8), 3)
  Bitrate = ultraschall.IntToDouble((Bitrate[1]),1)-1
  Mode=string.byte(Decoded_string:sub(9,9))
  Complexity=string.byte(Decoded_string:sub(10,10))
  Encode=string.byte(Decoded_string:sub(14,14))
  if Encode&1==1 then Encode1=true else Encode1=false end
  if Encode&2==2 then Combine=false else Combine=true end

  return Mode, Bitrate, Complexity, Encode1, Combine
end


function ultraschall.GetRenderCFG_Settings_GIF(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_GIF</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Width, integer Height, number MaxFramerate, boolean PreserveAspectRatio, integer IgnoreLowBits, boolean Transparency = ultraschall.GetRenderCFG_Settings_GIF(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for Gif.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer Width - the width of the gif in pixels; 1 to 2147483647 pixels
      integer Height - the height of the gif in pixels; 1 to 2147483647 pixels
      number MaxFramerate - the maximum framerate of the gif
      boolean PreserveAspectRatio - Preserve aspect ratio (black bars, if necessary)-checkbox; true, checked; false, unchecked
      integer IgnoreLowBits - Ignore changed in low bits of color (0-7, 0 = full quality)-inputbox
      boolean Transparency - Encode transparency (bad for normal video, good for some things possibly)-checkbox; true, checked; false, unchecked
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the gif-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, gif, width, height, framerate, transparency, aspect ratio</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_GIF", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, Width, Height, MaxFramerate, PreserveAspectRatio, Transparency, IgnoreLowBits
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~=" FIG" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_GIF", "rendercfg", "not a render-cfg-string of the format gif", -2) return -1 end
  num_integers, Width = ultraschall.ConvertStringToIntegers(Decoded_string:sub(5,8), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(9,12), 4)
  num_integers, MaxFramerate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(13,16), 4)
  MaxFramerate=ultraschall.IntToDouble(MaxFramerate[1])
  PreserveAspectRatio=string.byte(Decoded_string:sub(17,17))
  if PreserveAspectRatio==0 then PreserveAspectRatio=false else PreserveAspectRatio=true end
  IgnoreLowBits=string.byte(Decoded_string:sub(18,18))
  Transparency=(math.floor(IgnoreLowBits/2)~=IgnoreLowBits/2)
  
  IgnoreLowBits=math.floor(IgnoreLowBits/2)
  
  return Width[1], Height[1], MaxFramerate, PreserveAspectRatio, IgnoreLowBits, Transparency
end


function ultraschall.GetRenderCFG_Settings_LCF(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_LCF</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Width, integer Height, number MaxFramerate, boolean PreserveAspectRatio, string TweakSettings = ultraschall.GetRenderCFG_Settings_LCF(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for LCF.

      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer Width - the width of the gif in pixels; 1 to 2147483647 pixels
      integer Height - the height of the gif in pixels; 1 to 2147483647 pixels
      number MaxFramerate - the maximum framerate of the gif
      boolean PreserveAspectRatio - Preserve aspect ratio (black bars, if necessary)-checkbox; true, checked; false, unchecked
      string TweakSettings - the tweak-settings for LCF, default is "t20 x128 y16"
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the lcf-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, lcf, width, height, framerate, aspect ratio, tweak settings</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_LCF", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, Width, Height, MaxFramerate, PreserveAspectRatio, TweakSettings
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~=" FCL" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_LCF", "rendercfg", "not a render-cfg-string of the format lcf", -2) return -1 end
  num_integers, Width = ultraschall.ConvertStringToIntegers(Decoded_string:sub(5,8), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(9,12), 4)
  num_integers, MaxFramerate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(13,16), 4)
  MaxFramerate=ultraschall.IntToDouble(MaxFramerate[1])
  PreserveAspectRatio=string.byte(Decoded_string:sub(17,17))
  if PreserveAspectRatio==0 then PreserveAspectRatio=false else PreserveAspectRatio=true end

  for i=18, 82 do
    if string.byte(Decoded_string:sub(i,i))~=0 then TweakSettings=Decoded_string:sub(18,82) end
  end
  if TweakSettings==nil then TweakSettings="t20 x128 y16" end
  
  
  return Width[1], Height[1], MaxFramerate, PreserveAspectRatio, TweakSettings
end


function ultraschall.GetRenderCFG_Settings_WAV(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_WAV</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer BitDepth, integer LargeFiles, integer BWFChunk, integer IncludeMarkers, boolean EmbedProjectTempo = ultraschall.GetRenderCFG_Settings_WAV(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for WAV.
      
      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer BitDepth - the bitdepth of the WAV-file
                       -   0, 8 Bit PCM
                       -   1, 16 Bit PCM
                       -   2, 24 Bit PCM
                       -   3, 32 Bit FP
                       -   4, 64 Bit FP
                       -   5, 4 Bit IMA ADPCM
                       -   6, 2 Bit cADPCM 
      integer LargeFiles - how shall Reaper treat large WAV-files
                         -   0, Auto WAV/Wave64
                         -   1, Auto Wav/RF64
                         -   2, Force WAV
                         -   3, Force Wave64
                         -   4, Force RF64 
      integer BWFChunk - The "Write BWF ('bext') chunk" and "Include project filename in BWF data" - checkboxes
                       -   0, unchecked - unchecked
                       -   1, checked - unchecked
                       -   2, unchecked - checked
                       -   3, checked - checked 
      integer IncludeMarkers -  The include markerlist-dropdownlist
                             -   0, Do not include markers and regions
                             -   1, Markers + regions
                             -   2, Markers + regions starting with #
                             -   3, Markers only
                             -   4, Markers starting with # only
                             -   5, Regions only
                             -   6, Regions starting with # only 
      boolean EmbedProjectTempo - Embed project tempo (use with care)-checkbox; true, checked; false, unchecked 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the wav-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, wav</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WAV", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local IncludeMarkers, IncludeMarkers_temp, Bitdepth, LargeFiles, BWFChunk, EmbedProjectTempo
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="evaw" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WAV", "rendercfg", "not a render-cfg-string of the format wav", -2) return -1 end
  Bitdepth=string.byte(Decoded_string:sub(5,5))
  IncludeMarkers_temp={string.byte(Decoded_string:sub(6,6))&8,
                       string.byte(Decoded_string:sub(6,6))&16,
                       string.byte(Decoded_string:sub(6,6))&64,
                       string.byte(Decoded_string:sub(6,6))&128}
  IncludeMarkers=0
  if IncludeMarkers_temp[1]~=0 then IncludeMarkers=IncludeMarkers+1 end
  if IncludeMarkers_temp[2]~=0 then IncludeMarkers=IncludeMarkers+1 end
  if IncludeMarkers_temp[3]~=0 then IncludeMarkers=IncludeMarkers+2 end
  if IncludeMarkers_temp[4]~=0 then IncludeMarkers=IncludeMarkers+4 end
  
  LargeFiles=string.byte(Decoded_string:sub(7,7))
  if string.byte(Decoded_string:sub(6,6))&2~=0 and LargeFiles==0 then LargeFiles=2 
  elseif LargeFiles>1 then LargeFiles=LargeFiles+1
  end
  
  BWFChunk=0
  if string.byte(Decoded_string:sub(6,6))&1==0 then BWFChunk=BWFChunk+1 end
  if string.byte(Decoded_string:sub(6,6))&4~=0 then BWFChunk=BWFChunk+2 end
  
  EmbedProjectTempo=string.byte(Decoded_string:sub(6,6))&32~=0
  
  return Bitdepth, LargeFiles, BWFChunk, IncludeMarkers, EmbedProjectTempo
end


function ultraschall.GetRenderCFG_Settings_WAVPACK(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_WAVPACK</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Mode, integer Bitdepth, integer Writemarkers, boolean WriteBWFChunk, boolean IncludeFilenameBWF = ultraschall.GetRenderCFG_Settings_WAVPACK(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for WAVPACK.
      
      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer Mode - 0, Normal; 1, Fast; 2, High; 3, Very High(slowest) 
      integer Bitdepth -   the bitdepth of the WAVPACK-file
                       -      0(16Bit)
                       -      1(24Bit)
                       -      2(32Bit integer)
                       -      3(32Bit floating point)
                       -      4(23/24 Bit)
                       -      5(22/24 Bit)
                       -      6(21/24 Bit)
                       -      7(20/24 Bit)
                       -      8(19/24 Bit)
                       -      9(18/24 Bit)
                       -      10(17/24 Bit)
                       -      11(32 bit floating point -144dB floor)
                       -      12(32 bit floating point -120dB floor)
                       -      13(32 bit floating point -96dB floor) 
      integer Writemarkers - Write markers as cues-checkboxes
                           -   0, nothing checked
                           -   1, Write markers as cues->checked
                           -   2, Write markers as cues and Only write markers starting with #->checked 
      boolean WriteBWFChunk - the Write BWF chunk-checkbox; true, checked; false, unchecked 
      boolean IncludeFilenameBWF - the include project filename in BWF data-checkbox; true, checked; false, unchecked 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the wavpack-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, wavpack</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WAVPACK", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local Mode, Bitdepth, WriteMarkers, WriteBWFChunk, IncludeProjectFilenameInBWFData
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="kpvw" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WAVPACK", "rendercfg", "not a render-cfg-string of the format wavpack", -2) return -1 end
  Mode=string.byte(Decoded_string:sub(5,5))
  if Mode>1 then Mode=Mode-1 end
  Bitdepth=string.byte(Decoded_string:sub(9,9))
  WriteMarkers=string.byte(Decoded_string:sub(13,13))
  if WriteMarkers==2 then WriteMarkers=1 
  elseif WriteMarkers==1 then WriteMarkers=2
  end
  
  WriteBWFChunk=string.byte(Decoded_string:sub(17,17))&1~=0
  IncludeProjectFilenameInBWFData=string.byte(Decoded_string:sub(17,17))&2~=0

  return Mode, Bitdepth, WriteMarkers, WriteBWFChunk, IncludeProjectFilenameInBWFData
end


function ultraschall.GetRenderCFG_Settings_WebMVideo(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_WebMVideo</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer VIDKBPS, integer AUDKBPS, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_WebMVideo(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for WEBM_Video.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer VIDKBPS -  the video-bitrate of the video in kbps
      integer AUDKBPS -  the audio-bitrate of the video in kbps
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT -  the height of the video in pixels
      integer FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the webm-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, webm, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WebMVideo", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VidKBPS, AudKBPS, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=6 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WebMVideo", "rendercfg", "not a render-cfg-string of the format webm-video", -2) return -1 end
  num_integers, VidKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(13,16), 4)
  num_integers, AudKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(21,24), 4)
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  return VidKBPS[1], AudKBPS[1], Width[1], Height[1], FPS, AspectRatio
end




function ultraschall.GetRenderCFG_Settings_MKV_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MKV_Video</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer VIDEO_CODEC, integer MJPEG_quality, integer AUDIO_CODEC, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_MKV_Video(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for MKV-Video.
      
      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer VIDEO_CODEC - the used VideoCodec for the MKV-video
                          - 0, FFV1 (lossless)
                          - 1, Hufyuv (lossless)
                          - 2, MJPEG
      integer MJPEG_quality - the MJPEG-quality of the MKV-video, if VIDEO_CODEC=2
      integer AUDIO_CODEC - the audio-codec of the MKV-video
                          - 0, 16 bit PCM
                          - 1, 24 bit PCM
                          - 2, 32 bit FP
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      integer FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the mkv-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mkv, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MKV_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=4 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MKV_Video", "rendercfg", "not a render-cfg-string of the format mkv-video", -2) return -1 end
  VideoCodec=string.byte(Decoded_string:sub(9,9))-2
  num_integers, MJPEG_quality= ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  AudioCodec=string.byte(Decoded_string:sub(17,17))-2
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  return VideoCodec, MJPEG_quality[1], AudioCodec, Width[1], Height[1], FPS, AspectRatio
end


function ultraschall.GetRenderCFG_Settings_AVI_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_AVI_Video</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer VIDEO_CODEC, integer MJPEG_quality, integer AUDIO_CODEC, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_AVI_Video(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for AVI_Video.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer VIDEO_CODEC - the used VideoCodec for the AVI-video
                          - 0, DV
                          - 1, MJPEG
                          - 2, FFV1 (lossless)
                          - 3, Hufyuv (lossless)
      integer MJPEG_quality - the MJPEG-quality of the AVI-video, if VIDEO_CODEC=1
      integer AUDIO_CODEC - the audio-codec of the avi-video
                          - 0, 16 bit PCM
                          - 1, 24 bit PCM
                          - 2, 32 bit FP
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      integer FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the avi-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, avi, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AVI_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=0 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AVI_Video", "rendercfg", "not a render-cfg-string of the format avi-video", -2) return -1 end
  VideoCodec=string.byte(Decoded_string:sub(9,9))-2
  num_integers, MJPEG_quality= ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  AudioCodec=string.byte(Decoded_string:sub(17,17))-3
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  return VideoCodec, MJPEG_quality[1], AudioCodec, Width[1], Height[1], FPS, AspectRatio
end


function ultraschall.GetRenderCFG_Settings_QTMOVMP4_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_QTMOVMP4_Video</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer MJPEG_quality, integer AUDIO_CODEC, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_QTMOVMP4_Video(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the settings stored in a render-cfg-string for QT/MOV/MP4-video.
      
      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer MJPEG_quality - the MJPEG-quality of the video
      integer AUDIO_CODEC - the audio-codec of the video
                          - 0, 16 bit PCM
                          - 1, 24 bit PCM
                          - 2, 32 bit FP
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      integer FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the qt/mov/mp4-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mov, qt, mp4, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_QTMOVMP4_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=3 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_QTMOVMP4_Video", "rendercfg", "not a render-cfg-string of the format qt/move/mp4-video", -2) return -1 end
  num_integers, MJPEG_quality= ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  AudioCodec=string.byte(Decoded_string:sub(17,17))-2
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  return MJPEG_quality[1], AudioCodec, Width[1], Height[1], FPS, AspectRatio
end


function ultraschall.GetRenderCFG_Settings_DDP(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_DDP</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.GetRenderCFG_Settings_DDP(string rendercfg)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns, if a renderstring is a valid DDP-render-string
      
      You can get this from the current RENDER\_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      boolean retval - true, if renderstring is of the format DDP; false, if not
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the DDP-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, ddp</tags>
  </US_DocBloc>
  ]]
  if rendercfg=="IHBkZA==" then return true else return false end
end


function ultraschall.CreateRenderCFG_GIF(Width, Height, MaxFPS, AspectRatio, IgnoreLowBits, EncodeTransparency)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_GIF</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_GIF(integer Width, integer Height, number MaxFPS, boolean AspectRatio, integer IgnoreLowBits, boolean EncodeTransparency)</functioncall>
  <description>
    Creates the render-cfg-string for the GIF-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected GIF-settings
  </retvals>
  <parameters>
    integer Width - the width of the gif in pixels; 1 to 2147483647
    integer Height - the height of the gif in pixels; 1 to 2147483647 
    number MaxFPS - the maximum framerate of the gif in fps; 0.01 to 2000.01 supported by the Ultraschall API
    boolean AspectRatio - Preserve aspect ratio-checkbox; true, checked; false, unchecked
    integer IgnoreLowBits - Ignore changes in low bits of color-inputbox, 0-7
    boolean EncodeTransparency - Encode transparency-checkbox; true, checked; false, unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, gif</tags>
</US_DocBloc>
]]
  if math.type(Width)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "Width", "Must be an integer.", -1) return nil end
  if math.type(Height)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "Height", "Must be an integer.", -2) return nil end
  if type(MaxFPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "MaxFPS", "Must be a number.", -3) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "AspectRatio", "Must be a boolean.", -4) return nil end
  if math.type(IgnoreLowBits)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "IgnoreLowBits", "Must be an integer.", -5) return nil end
  if type(EncodeTransparency)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "EncodeTransparency", "Must be a boolean.", -6) return nil end

  if Width<1 or Width>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "Width", "Must be an integer.", -7) return nil end
  if Height<1 or Height>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "Height", "Must be an integer.", -8) return nil end 
  if MaxFPS<0.01 or MaxFPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "MaxFPS", "Must be between 0.01 and 2000.00(maximum supported by Ultraschall API).", -9) return nil end
  if IgnoreLowBits<0 or IgnoreLowBits>7 then ultraschall.AddErrorMessage("CreateRenderCFG_GIF", "IgnoreLowBits", "Must be between 0 and 7.", -10) return nil end
  
  Width=ultraschall.ConvertIntegerIntoString2(4, Width)
  Height=ultraschall.ConvertIntegerIntoString2(4, Height)
  MaxFPS = ultraschall.LimitFractionOfFloat(MaxFPS, 2, true)
  MaxFPS = ultraschall.ConvertIntegerIntoString2(4,ultraschall.DoubleToInt(MaxFPS))
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  IgnoreLowBits=IgnoreLowBits*2
  if EncodeTransparency==true then IgnoreLowBits=IgnoreLowBits+1 end
  
  return ultraschall.Base64_Encoder(" FIG"..Width..Height..MaxFPS..AspectRatio..string.char(IgnoreLowBits).."\0")
end

--A=ultraschall.CreateRenderCFG_GIF(640, 360, 30.00, false, 0, false)

function ultraschall.CreateRenderCFG_LCF(Width, Height, MaxFPS, AspectRatio, LCFoptionstweak)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_LCF</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_LCF(integer Width, integer Height, number MaxFPS, boolean AspectRatio, optional string LCFoptionstweak)</functioncall>
  <description>
    Creates the render-cfg-string for the LCF-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected LCF-settings
  </retvals>
  <parameters>
    integer Width - the width of the lcf in pixels; 1 to 2147483647
    integer Height - the height of the lcf in pixels; 1 to 2147483647 
    number MaxFPS - the maximum framerate of the lcf in fps; 0.01 to 2000.01 supported by the Ultraschall API
    boolean AspectRatio - Preserve aspect ratio-checkbox; true, checked; false, unchecked
    optional string LCFoptionstweak - a 64bytes string, which can hold tweak-settings for lcf; default is "t20 x128 y16"; this function does not check for these options to be valid!
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, lcf</tags>
</US_DocBloc>
]]
  if math.type(Width)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_LCF", "Width", "Must be an integer.", -1) return nil end
  if math.type(Height)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_LCF", "Height", "Must be an integer.", -2) return nil end
  if type(MaxFPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_LCF", "MaxFPS", "Must be a number.", -3) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_LCF", "AspectRatio", "Must be a boolean.", -4) return nil end
  if LCFoptionstweak~=nil and type(LCFoptionstweak)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_LCF", "LCFoptionstweak", "Must be a string.", -5) return nil end
  if LCFoptionstweak==nil then LCFoptionstweak="t20 x128 y16" end
  if LCFoptionstweak:len()>63 then ultraschall.AddErrorMessage("CreateRenderCFG_LCF", "LCFoptionstweak", "Must not be longer than 63 bytes.", -6) return nil end
  if Width<1 or Width>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_LCF", "Width", "Must be an integer.", -7) return nil end
  if Height<1 or Height>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_LCF", "Height", "Must be an integer.", -8) return nil end 
  if MaxFPS<0.01 or MaxFPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_LCF", "MaxFPS", "Must be between 0.01 and 2000.00(maximum supported by Ultraschall API).", -9) return nil end
  
  for i=LCFoptionstweak:len(), 64 do
    LCFoptionstweak=LCFoptionstweak.."\0"
  end
  Width=ultraschall.ConvertIntegerIntoString2(4, Width)
  Height=ultraschall.ConvertIntegerIntoString2(4, Height)
  MaxFPS = ultraschall.LimitFractionOfFloat(MaxFPS, 2, true)
  MaxFPS = ultraschall.ConvertIntegerIntoString2(4,ultraschall.DoubleToInt(MaxFPS))
  
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end

  return ultraschall.Base64_Encoder(" FCL"..Width..Height..MaxFPS..AspectRatio..LCFoptionstweak)
end

--A=ultraschall.CreateRenderCFG_LCF(10,10,120,true,"Tudelu                                                         A")


function ultraschall.CreateRenderCFG_WebMVideo(VIDKBPS, AUDKBPS, WIDTH, HEIGHT, FPS, AspectRatio)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_WebMVideo</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_WebMVideo(integer VIDKBPS, integer AUDKBPS, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio)</functioncall>
  <description>
    Returns the render-cfg-string for the WebM-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected WebM-Video-settings
  </retvals>
  <parameters>
    integer VIDKBPS - the video-bitrate of the video in kbps; 1 to 2147483647
    integer AUDKBPS - the audio-bitrate of the video in kbps; 1 to 2147483647
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, webm</tags>
</US_DocBloc>
]]
  if math.type(VIDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "VIDKBPS", "Must be an integer!", -2) return nil end
  if math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "AUDKBPS", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "AspectRatio", "Must be a boolean!", -7) return nil end
  if VIDKBPS<1 or VIDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "VIDKBPS", "Must be between 1 and 2147483647.", -8) return nil end
  if AUDKBPS<1 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "AUDKBPS", "Must be between 1 and 2147483647.", -9) return nil end
  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "WIDTH", "Must be between 1 and 2147483647.", -10) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "HEIGHT", "Must be between 1 and 2147483647.", -11) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -12) return nil end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4,ultraschall.DoubleToInt(FPS))  

  VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VIDKBPS)
  AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)
  local VideoCodec=string.char(0)
  local VideoFormat=string.char(6)
  local AudioCodec=string.char(0)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, 1)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality.."\0")
end

--LLL=ultraschall.CreateRenderCFG_WebMVideo(1, 1, 1, 1, 1, true)


function ultraschall.CreateRenderCFG_MKV_Video(VideoCodec, MJPEG_quality, AudioCodec, WIDTH, HEIGHT, FPS, AspectRatio)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MKV_Video</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MKV_Video(integer VideoCodec, integer MJPEG_quality, integer AudioCodec, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio)</functioncall>
  <description>
    Returns the render-cfg-string for the MKV-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected MKV-Video-settings
  </retvals>
  <parameters>
    integer VideoCodec - the videocodec used for the video;
                       -   1, FFV1 (lossless)
                       -   2, Hufyuv (lossles)
                       -   3, MJPEG
    integer MJPEG_quality - set here the MJPEG-quality in percent, when VideoCodec=3; otherwise just set it to 0
    integer AudioCodec - the audiocodec to use for the video
                       - 1, 16 bit PCM
                       - 2, 24 bit PCM
                       - 3, 32 bit FP
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, mkv</tags>
</US_DocBloc>
]]
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "VideoCodec", "Must be an integer!", -2) return nil end
  if math.type(MJPEG_quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "MJPEG_quality", "Must be an integer!", -3) return nil end
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "AudioCodec", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "AspectRatio", "Must be a boolean!", -7) return nil end
  
  if VideoCodec<1 or VideoCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "VideoCodec", "Must be between 1 and 3", -8) return nil end
  if MJPEG_quality<0 or MJPEG_quality>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "MJPEG_quality", "Must be between 1 and 2147483647", -9) return nil end
  if AudioCodec<1 or AudioCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "AudioCodec", "Must be between 1 and 3", -10) return nil end
  

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "WIDTH", "Must be between 1 and 2147483647.", -11) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "HEIGHT", "Must be between 1 and 2147483647.", -12) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -13) return nil end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, 0)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, 0)
  local VideoCodec=string.char(VideoCodec+1)
  local VideoFormat=string.char(4)
  local AudioCodec=string.char(AudioCodec+1)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, MJPEG_quality)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality.."\0")
end

--A=ultraschall.CreateRenderCFG_MKVMVideo(1, 1, 1, 1, 1, 1, false)


function ultraschall.CreateRenderCFG_QTMOVMP4_Video(VideoCodec, MJPEG_quality, AudioCodec, WIDTH, HEIGHT, FPS, AspectRatio)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_QTMOVMP4_Video</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_QTMOVMP4_Video(integer VideoCodec, integer MJPEG_quality, integer AudioCodec, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio)</functioncall>
  <description>
    Returns the render-cfg-string for the QT/MOV/MP4-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected QT/MOV/MP4-Video-settings
  </retvals>
  <parameters>
    integer VideoCodec - the videocodec used for the video;
                       -   1, MJPEG
    integer MJPEG_quality - set here the MJPEG-quality in percent
    integer AudioCodec - the audiocodec to use for the video
                       - 1, 16 bit PCM
                       - 2, 24 bit PCM
                       - 3, 32 bit FP
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, mp4, qt, mov</tags>
</US_DocBloc>
]]
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "VideoCodec", "Must be an integer!", -2) return nil end
  if math.type(MJPEG_quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "MJPEG_quality", "Must be an integer!", -3) return nil end
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "AudioCodec", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "AspectRatio", "Must be a boolean!", -7) return nil end
  
  if VideoCodec<1 or VideoCodec>1 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "VideoCodec", "Must be 1", -8) return nil end
  if MJPEG_quality<0 or MJPEG_quality>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "MJPEG_quality", "Must be between 1 and 2147483647", -9) return nil end
  if AudioCodec<1 or AudioCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "AudioCodec", "Must be between 1 and 3", -10) return nil end
  

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "WIDTH", "Must be between 1 and 2147483647.", -11) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "HEIGHT", "Must be between 1 and 2147483647.", -12) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -13) return nil end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, 0)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, 0)
  local VideoCodec=string.char(VideoCodec+1)
  local VideoFormat=string.char(3)
  local AudioCodec=string.char(AudioCodec+1)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, MJPEG_quality)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality.."\0")
end

--A=ultraschall.CreateRenderCFG_QTMOVMP4_Video(1, 1, 1, 1, 1, 1, false)


function ultraschall.CreateRenderCFG_AVI_Video(VideoCodec, MJPEG_quality, AudioCodec, WIDTH, HEIGHT, FPS, AspectRatio)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_AVI_Video</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_AVI_Video(integer VideoCodec, integer MJPEG_quality, integer AudioCodec, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio)</functioncall>
  <description>
    Returns the render-cfg-string for the AVI-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected QT/MOV/MP4-Video-settings
  </retvals>
  <parameters>
    integer VideoCodec - the videocodec used for the video;
                      - 1, DV
                      - 2, MJPEG
                      - 3, FFV1 (lossless)
                      - 4, Hufyuv (lossless)
    integer MJPEG_quality - set here the MJPEG-quality in percent when VideoCodec=2, otherwise just set it to 0
    integer AudioCodec - the audiocodec to use for the video
                       - 1, 16 bit PCM
                       - 2, 24 bit PCM
                       - 3, 32 bit FP
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, avi</tags>
</US_DocBloc>
]]
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "VideoCodec", "Must be an integer!", -2) return nil end
  if math.type(MJPEG_quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "MJPEG_quality", "Must be an integer!", -3) return nil end
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "AudioCodec", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "AspectRatio", "Must be a boolean!", -7) return nil end
  
  if VideoCodec<1 or VideoCodec>4 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "VideoCodec", "Must be between 1 and 4", -8) return nil end
  if MJPEG_quality<0 or MJPEG_quality>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "MJPEG_quality", "Must be between 1 and 2147483647", -9) return nil end
  if AudioCodec<1 or AudioCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "AudioCodec", "Must be between 1 and 3", -10) return nil end
  

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "WIDTH", "Must be between 1 and 2147483647.", -11) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "HEIGHT", "Must be between 1 and 2147483647.", -12) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -13) return nil end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, 0)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, 0)
  local VideoCodec=string.char(VideoCodec+1)
  local VideoFormat=string.char(0)
  local AudioCodec=string.char(AudioCodec+2)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, MJPEG_quality)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality.."\0")
end

--A=ultraschall.CreateRenderCFG_AVI_Video(1, 1, 1, 1, 1, 1, false)


function ultraschall.GetRenderCFG_Settings_MP4Mac_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MP4Mac_Video</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>boolean Stream, integer VIDKBPS, integer AUDKBPS, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_MP4Mac_Video(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MP4 for Mac_Video(stream optimised and non-stream optimised).
      This is Mac-OS only!
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      boolean Stream - true, mp4-video would be stream-optimized; false, mp4-video would not be stream-optimized
      integer VIDKBPS -  the video-bitrate of the video in kbps
      integer AUDKBPS -  the audio-bitrate of the video in kbps
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT -  the height of the video in pixels
      integer FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the webm-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp4, mac, stream, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP4Mac_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VidKBPS, AudKBPS, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="FVAX" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP4Mac_Video", "rendercfg", "not a render-cfg-string of the format mp4-for mac-video", -2) return -1 end
  if string.byte(Decoded_string:sub(5,5))<0 or string.byte(Decoded_string:sub(5,5))>1 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP4Mac_Video", "rendercfg", "not a render-cfg-string of the format mp4-for mac-video", -3) return -1 end  

  local Stream=string.byte(Decoded_string:sub(5,5))==0
  
  num_integers, VidKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(13,16), 4)
  num_integers, AudKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(21,24), 4)
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  return Stream, VidKBPS[1], AudKBPS[1], Width[1], Height[1], FPS, AspectRatio
end


function ultraschall.GetRenderCFG_Settings_MOVMac_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MOVMac_Video</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer VideoCodec, integer VIDKBPS, integer MJPEG_quality, integer AudioCodec, integer AUDKBPS, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_MOVMac_Video(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MOV for Mac_Video.
      This is MacOS-only.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer VideoCodec - the videocodec used for this setting
                         - 0, h264
                         - 1, Apple ProRes 4444
                         - 2, Apple ProRes 422
                         - 3, MJPEG
      integer VIDKBPS -  the video-bitrate of the video in kbps
      integer MJPEG_quality - when VideoCodec==3, then MJPEG is used; given in percent
      integer AudioCodec - the audiocodec used 
                         - 0, AAC
                         - 1, 16-bit PCM
                         - 2, 24-bit PCM
                         - 3, 32-bit FP PCM
      integer AUDKBPS -  the audio-bitrate of the video in kbps
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT -  the height of the video in pixels
      integer FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the webm-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mov, mac, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MOVMac_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VidKBPS, AudKBPS, Width, Height, FPS, AspectRatio, VideoCodec, AudioCodec, MJPEG_quality
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="FVAX" or string.byte(Decoded_string:sub(5,5))~=2 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MOVMac_Video", "rendercfg", "not a render-cfg-string of the format mov-for mac-video", -2) return -1 end
  local Stream=string.byte(Decoded_string:sub(5,5))==0
  
  num_integers, VidKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(13,16), 4)
  num_integers, AudKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(21,24), 4)
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  VideoCodec=string.byte(Decoded_string:sub(9,9))
  AudioCodec=string.byte(Decoded_string:sub(17,17))
  num_integers, MJPEG_quality = ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  

  return VideoCodec, VidKBPS[1], MJPEG_quality[1], AudioCodec, AudKBPS[1], Width[1], Height[1], FPS, AspectRatio
end


function ultraschall.GetRenderCFG_Settings_M4AMac(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_M4AMac</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer AUDKBPS, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_M4AMac(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for M4A for Mac_Video(even though this stores only audio-files).
      This is MacOS-only.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer AUDKBPS -  the audio-bitrate of the audio in kbps
      integer WIDTH  - the width of the audio in pixels
      integer HEIGHT -  the height of the audio in pixels
      integer FPS  - the fps of the audio; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the webm-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, m4a, audio, mac, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_M4AMac", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VidKBPS, AudKBPS, Width, Height, FPS, AspectRatio, VideoCodec, AudioCodec, MJPEG_quality
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="FVAX" or string.byte(Decoded_string:sub(5,5))~=3 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_M4AMac", "rendercfg", "not a render-cfg-string of the format m4a-for mac", -2) return -1 end
  local Stream=string.byte(Decoded_string:sub(5,5))==0
  
  num_integers, VidKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(13,16), 4)
  num_integers, AudKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(21,24), 4)
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  VideoCodec=string.byte(Decoded_string:sub(9,9))
  AudioCodec=string.byte(Decoded_string:sub(17,17))
  num_integers, MJPEG_quality = ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  

  return AudKBPS[1], Width[1], Height[1], FPS, AspectRatio
end

function ultraschall.CreateRenderCFG_MP4MAC_Video(Stream, VIDKBPS, AUDKBPS, WIDTH, HEIGHT, FPS, AspectRatio)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MP4MAC_Video</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MP4MAC_Video(boolean stream, integer VIDKBPS, integer AUDKBPS, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio)</functioncall>
  <description>
    Returns the render-cfg-string for the MP4-Mac-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    Only available on MacOS!
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected MP4-Mac-Video-settings
  </retvals>
  <parameters>
    boolean Stream - true, the mp4-video is stream-optimized; false, the video is not stream-optimized
    integer VIDKBPS - the video-bitrate for the video; 0 to 2147483647kbps
    integer AUDKBPS - the audio-bitrate for the video; 0 to 2147483647kbps
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, mp4, stream, mac</tags>
</US_DocBloc>
]]
  if type(Stream)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "Stream", "Must be a boolean!", -1) return nil end
  if math.type(VIDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "VIDKBPS", "Must be an integer!", -2) return nil end
  if math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "AUDKBPS", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "AspectRatio", "Must be a boolean!", -7) return nil end
  
  if VIDKBPS<0 or VIDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "VIDKBPS", "Must be between 1 and 2147483647", -8) return nil end
  if AUDKBPS<0 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "AUDKBPS", "Must be between 1 and 2147483647", -9) return nil end

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "WIDTH", "Must be between 1 and 2147483647.", -10) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "HEIGHT", "Must be between 1 and 2147483647.", -11) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_MP4MAC_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -12) return nil end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VIDKBPS)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)
  local VideoCodec=string.char(0)
  local VideoFormat=string.char(1) -- default is not stream-optimized
  if Stream==true then VideoFormat=string.char(0) end
  local AudioCodec=string.char(0)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, 0)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("FVAX"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality.."\0")
end

function ultraschall.CreateRenderCFG_M4AMAC(AUDKBPS, WIDTH, HEIGHT, FPS, AspectRatio)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_M4AMAC</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_M4AMAC(integer AUDKBPS, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio)</functioncall>
  <description>
    Returns the render-cfg-string for the M4A-Mac-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    Only available on MacOS!
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected M4A-Mac-settings
  </retvals>
  <parameters>
    integer AUDKBPS - the audio-bitrate for the video; 0 to 2147483647 kbps
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, m4a, audio, mac</tags>
</US_DocBloc>
]]
  if math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_M4AMAC", "AUDKBPS", "Must be an integer!", -1) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_M4AMAC", "WIDTH", "Must be an integer!", -2) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_M4AMAC", "HEIGHT", "Must be an integer!", -3) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_M4AMAC", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -4) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_M4AMAC", "AspectRatio", "Must be a boolean!", -5) return nil end
  
  if AUDKBPS<0 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_M4AMAC", "AUDKBPS", "Must be between 1 and 2147483647", -6) return nil end

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_M4AMAC", "WIDTH", "Must be between 1 and 2147483647.", -7) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_M4AMAC", "HEIGHT", "Must be between 1 and 2147483647.", -8) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_M4AMAC", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -9) return nil end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, 1)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)
  local VideoCodec=string.char(0)
  local VideoFormat=string.char(3)
  local AudioCodec=string.char(0)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, 0)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("FVAX"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality.."\0")
end

--integer VideoCodec, integer VIDKBPS, integer MJPEG_quality, integer AudioCodec, integer AUDKBPS, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio
function ultraschall.CreateRenderCFG_MOVMAC_Video(VideoCodec, VIDKBPS, MJPEG_quality, AudioCodec, AUDKBPS, WIDTH, HEIGHT, FPS, AspectRatio)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MOVMAC_Video</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MOVMAC_Video(integer VideoCodec, integer VIDKBPS, integer MJPEG_quality, integer AudioCodec, integer AUDKBPS, integer WIDTH, integer HEIGHT, integer FPS, boolean AspectRatio)</functioncall>
  <description>
    Returns the render-cfg-string for the MOV-Mac-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    Only available on MacOS!
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected MP4-Mac-Video-settings
  </retvals>
  <parameters>
    integer VideoCodec - the videocodec used for this setting
                       - 0, h264
                       - 1, Apple ProRes 4444
                       - 2, Apple ProRes 422
                       - 3, MJPEG
    integer VIDKBPS -  the video-bitrate of the video in kbps
    integer MJPEG_quality - when VideoCodec==3, then MJPEG is used; given in percent
    integer AudioCodec - the audiocodec used 
                       - 0, AAC
                       - 1, 16-bit PCM
                       - 2, 24-bit PCM
                       - 3, 32-bit FP PCM
    integer AUDKBPS -  the audio-bitrate of the video in kbps
    integer WIDTH  - the width of the video in pixels
    integer HEIGHT -  the height of the video in pixels
    integer FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
    boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, mov, mac</tags>
</US_DocBloc>
]]
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "VideoCodec", "Must be a integer!", -1) return nil end
  if math.type(VIDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "VIDKBPS", "Must be an integer!", -2) return nil end
  if math.type(MJPEG_quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "MJPEG_quality", "Must be an integer!", -3) return nil end
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "AudioCodec", "Must be an integer!", -4) return nil end
  if math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "AUDKBPS", "Must be an integer!", -5) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "WIDTH", "Must be an integer!", -6) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "HEIGHT", "Must be an integer!", -7) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -8) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "AspectRatio", "Must be a boolean!", -9) return nil end
  
  if VideoCodec<0 or VideoCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "VideoCodec", "Must be between 0 and 3", -10) return nil end
  if AudioCodec<0 or AudioCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "AudioCodec", "Must be between 0 and 3", -11) return nil end
  if VIDKBPS<0 or VIDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "VIDKBPS", "Must be between 0 and 2147483647", -12) return nil end
  if AUDKBPS<0 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "AUDKBPS", "Must be between 0 and 2147483647", -13) return nil end
  if MJPEG_quality<0 or MJPEG_quality>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "MJPEG_quality", "Must be between 0 and 2147483647", -14) return nil end
  
  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "WIDTH", "Must be between 1 and 2147483647.", -15) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "HEIGHT", "Must be between 1 and 2147483647.", -16) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -17) return nil end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VIDKBPS)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)
  local VideoCodec=string.char(VideoCodec)
  local VideoFormat=string.char(2)
  local AudioCodec=string.char(AudioCodec)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, MJPEG_quality)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("FVAX"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality.."\0")
end

--A,AA=reaper.EnumProjects(3, "")
--B=ultraschall.GetOutputFormat_RenderCfg(nil, 1)

function ultraschall.GetRenderTable_Project()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTable_Project</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.GetRenderTable_Project()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all stored render-settings for the current project, as a handy table.
            
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
            RenderTable["Bounds"] - 0, Custom time range; 1, Entire project; 2, Time selection; 3, Project regions; 4, Selected Media Items(in combination with Source 32); 5, Selected regions
            RenderTable["Channels"] - the number of channels in the rendered file; 1, mono; 2, stereo; higher, the number of channels
            RenderTable["CloseAfterRender"] - true, closes rendering to file-dialog after render; false, doesn't close it
            RenderTable["Dither"] - &1, dither master mix; &2, noise shaping master mix; &4, dither stems; &8, dither noise shaping
            RenderTable["Endposition"] - the endposition of the rendering selection in seconds
            RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 0, Full-speed Offline; 1, 1x Offline; 2, Online Render; 3, Online Render(Idle); 4, Offline Render(Idle)
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
            RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 0, Medium (64pt Sinc); 1, Low (Linear Interpolation); 2, Lowest (Point Sampling); 3, Good (192pt Sinc); 4, Better (348 pt Sinc); 5, Fast (IIR + Linear Interpolation); 6, Fast (IIRx2 + Linear Interpolation); 7, Fast (16pt Sinc); 8, HQ (512 pt); 9, Extreme HQ(768pt HQ Sinc)
            RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-ouput-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"] - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; true, checked; false, unchecked
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; true, checked; false, unchecked
            RenderTable["Source"] - 0, Master mix; 1, Master mix + stems; 3, Stems (selected tracks); 8, Region render matrix; 16, Tracks with only Mono-Media to Mono Files; 32, Selected media items
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? &1, custom time bounds; &2, entire project; &4, time selection; &8, all project regions; &16, selected media items; &32, selected project regions
            RenderTable["TailMS"] - the amount of milliseconds of the tail
    
    Returns nil in case of an error
  </description>
  <retvals>
    table RenderTable - a table with all of the current project's render-settings
  </retvals>
        <parametersss>
          ReaProject ReaProject - the project, whose render-settings you want; either a ReaProject-object or an integer, that signals the projecttab of the project
                                - use 0, for the currently active project; 1, for the first project-tab; 2, for the second, etc; -1, for the currently rendering project
        </parametersss>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, get, project, rendertable</tags>
</US_DocBloc>
]]
  local _temp, ReaProject, hwnd, retval
  if ReaProject==nil then ReaProject=0 end
  if ultraschall.type(ReaProject)~="ReaProject" and math.type(ReaProject)~="integer" then ultraschall.AddErrorMessage("GetRenderTable_Project", "ReaProject", "no such project available, must be either a ReaProject-object or the projecttab-number(1-based)", -1) return nil end
  if ReaProject==-1 then ReaProject=0x40000000 _temp=true 
  elseif ReaProject<-2 then 
    ultraschall.AddErrorMessage("GetRenderTable_Project", "ReaProject", "no such project-tab available, must be 0, for the current; 1, for the first, etc; -1, for the currently rendering project", -3) return nil 
  end
  
  if math.type(ReaProject)=="integer" then ReaProject=reaper.EnumProjects(ReaProject-1, "") end
  if ReaProject==nil and _temp~=true then 
    ultraschall.AddErrorMessage("GetRenderTable_Project", "ReaProject", "no such project available, must be either a ReaProject-object or the projecttab-number(1-based)", -4) return nil 
  elseif _temp==true then
    ultraschall.AddErrorMessage("GetRenderTable_Project", "ReaProject", "no project currently rendering", -5) return nil 
  end
  local RenderTable={}
  RenderTable["RenderTable"]=true
  RenderTable["Source"]=math.tointeger(reaper.GetSetProjectInfo(ReaProject, "RENDER_SETTINGS", 0, false))
  if RenderTable["Source"]&4~=0 then RenderTable["Source"]=RenderTable["Source"]-4 RenderTable["MultiChannelFiles"]=true else RenderTable["MultiChannelFiles"]=false end
  if RenderTable["Source"]&16~=0 then RenderTable["Source"]=RenderTable["Source"]-16 RenderTable["OnlyMonoMedia"]=true else RenderTable["OnlyMonoMedia"]=false end
  RenderTable["Bounds"]=math.tointeger(reaper.GetSetProjectInfo(ReaProject, "RENDER_BOUNDSFLAG", 0, false))
  RenderTable["Channels"]=math.tointeger(reaper.GetSetProjectInfo(ReaProject, "RENDER_CHANNELS", 0, false))
  RenderTable["SampleRate"]=math.tointeger(reaper.GetSetProjectInfo(ReaProject, "RENDER_SRATE", 0, false))
  if RenderTable["SampleRate"]==0 then 
    RenderTable["SampleRate"]=math.tointeger(reaper.GetSetProjectInfo(ReaProject, "PROJECT_SRATE", 0, false))
  end
  RenderTable["Startposition"]=reaper.GetSetProjectInfo(ReaProject, "RENDER_STARTPOS", 0, false)
  RenderTable["Endposition"]=reaper.GetSetProjectInfo(ReaProject, "RENDER_ENDPOS", 0, false)
  RenderTable["TailFlag"]=math.tointeger(reaper.GetSetProjectInfo(ReaProject, "RENDER_TAILFLAG", 0, false))
  RenderTable["TailMS"]=math.tointeger(reaper.GetSetProjectInfo(ReaProject, "RENDER_TAILMS", 0, false))
  RenderTable["AddToProj"]=reaper.GetSetProjectInfo(ReaProject, "RENDER_ADDTOPROJ", 0, false)
  if RenderTable["AddToProj"]==1 then RenderTable["AddToProj"]=true else RenderTable["AddToProj"]=false end
  RenderTable["Dither"]=math.tointeger(reaper.GetSetProjectInfo(ReaProject, "RENDER_DITHER", 0, false))
  RenderTable["ProjectSampleRateFXProcessing"]=ultraschall.GetRender_ProjectSampleRateForMix()
  RenderTable["SilentlyIncrementFilename"]=ultraschall.GetRender_AutoIncrementFilename()
  
  RenderTable["RenderQueueDelay"], RenderTable["RenderQueueDelaySeconds"] = ultraschall.GetRender_QueueDelay()
  RenderTable["RenderResample"]=ultraschall.GetRender_ResampleMode()
  RenderTable["OfflineOnlineRendering"]=ultraschall.GetRender_OfflineOnlineMode()
  _temp, RenderTable["RenderFile"]=reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FILE", "", false)
  _temp, RenderTable["RenderPattern"]=reaper.GetSetProjectInfo_String(ReaProject, "RENDER_PATTERN", "", false)
  _temp, RenderTable["RenderString"]=reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FORMAT", "", false)
  if reaper.SNM_GetIntConfigVar("renderclosewhendone", -111)&16==0 then
    RenderTable["CloseAfterRender"]=false
  else
    RenderTable["CloseAfterRender"]=true
  end

  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    retval, RenderTable["SaveCopyOfProject"] = reaper.BR_Win32_GetPrivateProfileString("REAPER", "autosaveonrender2", -1, reaper.get_ini_file())
    RenderTable["SaveCopyOfProject"]=tonumber(RenderTable["SaveCopyOfProject"])
  else
    RenderTable["SaveCopyOfProject"]=reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1060), "BM_GETCHECK", 0,0,0,0)
  end
  if RenderTable["SaveCopyOfProject"]==1 then RenderTable["SaveCopyOfProject"]=true else RenderTable["SaveCopyOfProject"]=false end

  return RenderTable
end


--A=ultraschall.GetRenderTable_Project()


function ultraschall.GetRenderTable_ProjectFile(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTable_ProjectFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.GetRenderTable_ProjectFile(string projectfilename_with_path)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all stored render-settings in a projectfile, as a handy table.
            
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
            RenderTable["Bounds"] - 0, Custom time range; 1, Entire project; 2, Time selection; 3, Project regions; 4, Selected Media Items(in combination with Source 32); 5, Selected regions
            RenderTable["Channels"] - the number of channels in the rendered file; 1, mono; 2, stereo; higher, the number of channels
            RenderTable["CloseAfterRender"] - close rendering to file-dialog after render; always true, as this isn't stored in projectfiles
            RenderTable["Dither"] - &1, dither master mix; &2, noise shaping master mix; &4, dither stems; &8, dither noise shaping
            RenderTable["Endposition"] - the endposition of the rendering selection in seconds
            RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 0, Full-speed Offline; 1, 1x Offline; 2, Online Render; 3, Online Render(Idle); 4, Offline Render(Idle)
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
            RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checkbox is checked; false, checkbox is unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 0, Medium (64pt Sinc); 1, Low (Linear Interpolation); 2, Lowest (Point Sampling); 3, Good (192pt Sinc); 4, Better (348 pt Sinc); 5, Fast (IIR + Linear Interpolation); 6, Fast (IIRx2 + Linear Interpolation); 7, Fast (16pt Sinc); 8, HQ (512 pt); 9, Extreme HQ(768pt HQ Sinc)
            RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-ouput-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"] - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; always true(checked), as this isn't stored in projectfiles
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; always false, as this is not stored in projectfiles
            RenderTable["Source"] - 0, Master mix; 1, Master mix + stems; 3, Stems (selected tracks); 8, Region render matrix; 16, Tracks with only Mono-Media to Mono Files; 32, Selected media items
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? &1, custom time bounds; &2, entire project; &4, time selection; &8, all project regions; &16, selected media items; &32, selected project regions
            RenderTable["TailMS"] - the amount of milliseconds of the tail
    
    Returns nil in case of an error
  </description>
  <retvals>
    table RenderTable - a table with all of the current project's render-settings
  </retvals>
  <parameters>
    string projectfilename_with_path - the projectfile, whose render-settings you want to get
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, get, projectfile, rendertable</tags>
</US_DocBloc>
]]
  if projectfilename_with_path~=nil and (type(projectfilename_with_path)~="string" or reaper.file_exists(projectfilename_with_path)==false) then ultraschall.AddErrorMessage("GetRenderTable_ProjectFile", "projectfilename_with_path", "file does not exist", -1) return nil end
  
  if projectfilename_with_path~=nil then
    ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path)
  end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetRenderTable_ProjectFile", "projectfilename_with_path", "not a valid rpp-project", -2) return nil end
  local render_stems = ultraschall.GetProject_RenderStems(nil, ProjectStateChunk)
  local bounds, time_start, time_end, tail, tail_length = ultraschall.GetProject_RenderRange(nil, ProjectStateChunk)
  local unknown, rendernum_chans, render_frequency = ultraschall.GetProject_RenderFreqNChans(nil, ProjectStateChunk)
  local addmedia_after_render_state = ultraschall.GetProject_AddMediaToProjectAfterRender(nil, ProjectStateChunk)
  local renderdither_state = ultraschall.GetProject_RenderDitherState(nil, ProjectStateChunk)
  local render_pattern = ultraschall.GetProject_RenderPattern(nil, ProjectStateChunk)
  if render_pattern==nil then render_pattern="" end
  local render_filename = ultraschall.GetProject_RenderFilename(nil, ProjectStateChunk)
  local render_cfg = ultraschall.GetProject_RenderCFG(nil, ProjectStateChunk)

  local resample_mode, playback_resample_mode, project_smplrate4mix_and_fx = ultraschall.GetProject_RenderResample(projectfilename_with_path, ProjectStateChunk)
  
  local RenderTable={}
  RenderTable["RenderTable"]=true
  RenderTable["Source"]=render_stems
  if RenderTable["Source"]&4~=0 then RenderTable["Source"]=RenderTable["Source"]-4 RenderTable["MultiChannelFiles"]=true else RenderTable["MultiChannelFiles"]=false end
  if RenderTable["Source"]&16~=0 then RenderTable["Source"]=RenderTable["Source"]-16 RenderTable["OnlyMonoMedia"]=true else RenderTable["OnlyMonoMedia"]=false end
  RenderTable["Bounds"]=bounds
  RenderTable["Channels"]=rendernum_chans
  RenderTable["SampleRate"]=render_frequency
  if RenderTable["SampleRate"]==0 then RenderTable["SampleRate"]=ultraschall.GetProject_SampleRate(nil, ProjectStateChunk) end
  RenderTable["Startposition"]=time_start
  RenderTable["Endposition"]=time_end
  RenderTable["TailFlag"]=tail
  RenderTable["TailMS"]=tail_length
  RenderTable["AddToProj"]=addmedia_after_render_state
  if RenderTable["AddToProj"]==1 then RenderTable["AddToProj"]=true else RenderTable["AddToProj"]=false end
  RenderTable["Dither"]=renderdither_state
  
  RenderTable["ProjectSampleRateFXProcessing"]=project_smplrate4mix_and_fx
  if RenderTable["ProjectSampleRateFXProcessing"]==1 then RenderTable["ProjectSampleRateFXProcessing"]=true else RenderTable["ProjectSampleRateFXProcessing"]=false end
  RenderTable["SilentlyIncrementFilename"]=true
  RenderTable["RenderQueueDelay"], RenderTable["RenderQueueDelaySeconds"]=ultraschall.GetProject_RenderQueueDelay(nil, ProjectStateChunk)

  RenderTable["RenderResample"]=resample_mode
  RenderTable["OfflineOnlineRendering"]=ultraschall.GetProject_RenderSpeed(nil, ProjectStateChunk)
  
  RenderTable["RenderFile"]=render_filename
  RenderTable["RenderPattern"]=render_pattern
  RenderTable["RenderString"]=render_cfg 
  RenderTable["SaveCopyOfProject"]=false
  RenderTable["CloseAfterRender"]=true
  
  return RenderTable
end


--B=ultraschall.ReadFullFile("c:\\Render-Queue-Documentation.RPP")
--AAA=ultraschall.GetRenderTable_ProjectFile(nil,B)

function ultraschall.GetOutputFormat_RenderCfg(Renderstring, ReaProject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetOutputFormat_RenderCfg</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string outputformat, string renderstring = ultraschall.GetOutputFormat_RenderCfg(string Renderstring, optional ReaProject ReaProject)</functioncall>
  <description>
    Returns the output-format set in a render-cfg-string, as stored in rpp-files and the render-presets file reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string outputformat - the outputformat, set in the render-cfg-string
    - The following are valid: 
    - WAV, AIFF, AUDIOCD-IMAGE, DDP, FLAC, MP3, OGG, Opus, Video, Video (Mac), Video GIF, Video LCF, WAVPACK
    string renderstring - the renderstringm which is either the renderstring you've passed or the one from the ReaProject you passed as second parameter
  </retvals>
  <parameters>
    string Renderstring - the render-cfg-string from a rpp-projectfile or the reaper-render.ini
                        - nil, to get the settings of the currently opened project
    optional ReaProject ReaProject - a ReaProject, whose renderformat you want to know; only available, when Renderstring=nil
                                   - set to nil, to use the currently opened project
                                   - pass as integer to get the renderformat of a specific projecttab, with 0 for the current, 1 for the first, 2 for the second, etc
  </parameters>
  <chapter_context>
    Rendering Projects
    Analyzing Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, get, render, outputformat, reaproject, projecttab</tags>
</US_DocBloc>
]]

  -- check parameter
  if Renderstring~=nil and type(Renderstring)~="string" then ultraschall.AddErrorMessage("GetOutputFormat_RenderCfg", "Renderstring", "Must be a string!", -1) return nil end
  if ReaProject~=nil and ultraschall.type(ReaProject)~="ReaProject" and math.type(ReaProject)~="integer" then ultraschall.AddErrorMessage("GetOutputFormat_RenderCfg", "ReaProject", "Must be a valid ReaProject or nil!", -2) return nil end
  local retval
  if ReaProject==nil then ReaProject=0 end
  if Renderstring==nil then 
    if math.type(ReaProject)=="integer" and ReaProject>-1 then 
      ReaProject=ReaProject-1
      ReaProject = reaper.EnumProjects(ReaProject, "")
      if ReaProject==nil then ultraschall.AddErrorMessage("GetOutputFormat_RenderCfg", "ReaProject", "Must be a valid ReaProject or nil!", -3) return nil end
    end
    retval, Renderstring = reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FORMAT", "", false)
    if retval==false then ultraschall.AddErrorMessage("GetOutputFormat_RenderCfg", "ReaProject", "Must be a valid ReaProject or nil!", -4) return nil end
  end

  -- get rid of anything else than printable characters
  
  --print2(Renderstring)
  
  -- return the proper value
  if Renderstring:len()>4 then 
    local A2,B=Renderstring:match("%s*()[%g%=]*()")
    Renderstring=Renderstring:sub(A2,B-1)
    Renderstring=ultraschall.Base64_Decoder(Renderstring) 
  end

  --print2("9"..Renderstring:sub(1,4).."9")
  
  if Renderstring:sub(1,4)=="evaw" then return "WAV", Renderstring end
  if Renderstring:sub(1,4)=="ffia" then return "AIFF", Renderstring end
  if Renderstring:sub(1,4)==" osi" then return "AUDIOCD-IMAGE", Renderstring end
  if Renderstring:sub(1,4)==" pdd" then return "DDP", Renderstring end
  if Renderstring:sub(1,4)=="calf" then return "FLAC", Renderstring end
  if Renderstring:sub(1,4)=="l3pm" then return "MP3", Renderstring end
  if Renderstring:sub(1,4)=="vggo" then return "OGG", Renderstring end
  if Renderstring:sub(1,4)=="SggO" then return "Opus", Renderstring end
  if Renderstring:sub(1,4)=="PMFF" then return "Video", Renderstring end
  if Renderstring:sub(1,4)=="FVAX" then return "Video (Mac)", Renderstring end
  if Renderstring:sub(1,4)==" FIG" then return "Video GIF", Renderstring end
  if Renderstring:sub(1,4)==" FCL" then return "Video LCF", Renderstring end
  if Renderstring:sub(1,4)=="kpvw" then return "WAVPACK", Renderstring end
    
  return "Unknown", Renderstring
end

--A=
--A,AA=reaper.EnumProjects(1, "")

--B=ultraschall.GetOutputFormat_RenderCfg(nil, A)

function ultraschall.CreateRenderCFG_Opus(Mode, Kbps, Complexity, channel_audio, per_channel)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_Opus</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_Opus(integer Mode, integer Kbps, integer Complexity, optional boolean channel_audio, optional boolean per_channel)</functioncall>
  <description>
    Creates the render-cfg-string for the Opus-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected Opus-settings
  </retvals>
  <parameters>
    integer Mode - the Mode for the Opus-file; 0, VBR; 1, CVBR; 2, HARDCBR
    integer Kbps - the kbps of the opus-file; Ultraschall-Api supports between 1 and 10256 
    integer Complexity - the complexity-setting between 0(lowest quality) and 10(highest quality, slow encoding)
    boolean channel_audio - true, Encode 3-8 channel audio as 2.1-7.1(LFE); false, DON'T Encode 3-8 channel audio as 2.1-7.1(LFE) 
    boolean per_channel - true, kbps per channel (6-256); false, kbps combined for all channels 
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, opus</tags>
</US_DocBloc>
]]
  local ini_file=ultraschall.Api_Path.."IniFiles/double_to_int_24bit.ini"
  if reaper.file_exists(ini_file)==false then ultraschall.AddErrorMessage("CreateRenderCFG_Opus", "Ooops", "external render-code-ini-file does not exist. Reinstall Ultraschall-API again, please!", -1) return nil end
  if math.type(Kbps)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_Opus", "Kbps", "Must be an integer!", -2) return nil end
  if math.type(Mode)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_Opus", "Mode", "Must be an integer!", -3) return nil end
  if math.type(Complexity)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_Opus", "Complexity", "Must be an integer!", -4) return nil end
  if Kbps<1 or Kbps>10256 then ultraschall.AddErrorMessage("CreateRenderCFG_Opus", "Kbps", "Must be bigger than 0 and smaller than 10256!", -5) return nil end
  if Mode<0 or Mode>2 then ultraschall.AddErrorMessage("CreateRenderCFG_Opus", "Mode", "must be between 0 and 2", -6) return nil end
  if Complexity<0 or Complexity>10 then ultraschall.AddErrorMessage("CreateRenderCFG_Opus", "Complexity", "must be between 0 and 10", -7) return nil end
  local Mode, Bitrate, EncodeChannelAudio, RenderString
  Mode=0
  Bitrate = ultraschall.ConvertIntegerIntoString2(3, ultraschall.DoubleToInt(Kbps+1,1))
  EncodeChannelAudio=0
  if channel_audio==true then EncodeChannelAudio=EncodeChannelAudio+1 end
  if per_channel==true then EncodeChannelAudio=EncodeChannelAudio+2 end
  
  RenderString="SggO\0"..Bitrate..string.char(Mode)..string.char(Complexity).."\0\0\0"..string.char(EncodeChannelAudio).."\0\0\0\0"
  
  return ultraschall.Base64_Encoder(RenderString)
end


function ultraschall.CreateRenderCFG_Opus2(Mode, Kbps, Complexity, channel_audio, per_channel)
  return ultraschall.CreateRenderCFG_Opus(Mode, Kbps, Complexity, channel_audio, per_channel)
end

--A=ultraschall.CreateRenderCFG_Opus2(0, 1, 0, false, false)
--B = ultraschall.GetProject_RenderCFG("c:\\opustest.rpp")




function ultraschall.CreateRenderCFG_OGG(Mode, VBR_Quality, CBR_KBPS, ABR_KBPS, ABR_KBPS_MIN, ABR_KBPS_MAX)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_OGG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_OGG(integer Mode, number VBR_Quality, integer CBR_KBPS, integer ABR_KBPS, integer ABR_KBPS_MIN, integer ABR_KBPS_MAX)</functioncall>
  <description>
    Returns the render-cfg-string for the OGG-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    For all mode-settings that you don't need(kbps or quality), you can safely set them to 1.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected OGG-settings
  </retvals>
  <parameters>
    integer Mode - the mode for the ogg-file; 0, VBR; 1, CBR; 2, ABR
    number VBR_Quality - the quality for VBR-mode; a floating-value between 0 and 1
    integer CBR_KBPS - the bitrate for CBR-mode; 0 to 2048
    integer ABR_KBPS - the bitrate for ABR-mode; 0 to 2048
    integer ABR_KBPS_MIN - the minimum-bitrate for ABR-mode; 0 to 2048
    integer ABR_KBPS_MAX - the maximum-bitrate for ABR-mode; 0 to 2048
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, ogg</tags>
</US_DocBloc>
]]

--(Mode, VBR_Quality, CBR_KBPS, ABR_KBPS, ABR_KBPS_MIN, ABR_KBPS_MAX)
  local ini_file=ultraschall.Api_Path.."IniFiles/double_to_int.ini"
  if reaper.file_exists(ini_file)==false then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "Ooops", "external render-code-ini-file does not exist. Reinstall Ultraschall-API again, please!", -1) return nil end
  if math.type(Mode)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "Kbps", "Must be an integer!", -2) return nil end
  if type(VBR_Quality)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "VBR_Quality", "Must be a float!", -3) return nil end
  if math.type(CBR_KBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "CBR_KBPS", "Must be an integer!", -4) return nil end
  if math.type(ABR_KBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "ABR_KBPS", "Must be an integer!", -5) return nil end
  if math.type(ABR_KBPS_MIN)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "ABR_KBPS_MIN", "Must be an integer!", -6) return nil end
  if math.type(ABR_KBPS_MAX)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "ABR_KBPS_MAX", "Must be an integer!", -7) return nil end
  if Mode<0 or Mode>2 then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "Mode", "must be between 0 and 2", -8) return nil end
  if VBR_Quality<0 or VBR_Quality>1.0 then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "VBR_Quality", "must be a float-value between 0 and 1", -9) return nil end
  if CBR_KBPS<0 or CBR_KBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "CBR_KBPS", "must be between 0 and 2048", -10) return nil end  
  if ABR_KBPS<0 or ABR_KBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "ABR_KBPS", "must be between 0 and 2048", -11) return nil end  
  if ABR_KBPS_MIN<0 or ABR_KBPS_MIN>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "ABR_KBPS_MIN", "must be between 0 and 2048", -12) return nil end  
  if ABR_KBPS_MAX<0 or ABR_KBPS_MAX>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "ABR_KBPS_MAX", "must be between 0 and 2048", -13) return nil end  
  
  local RenderString
  VBR_Quality=VBR_Quality+0.0
  VBR_Quality = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(VBR_Quality))
  CBR_KBPS = ultraschall.ConvertIntegerIntoString2(4, CBR_KBPS)
  ABR_KBPS = ultraschall.ConvertIntegerIntoString2(4, ABR_KBPS)
  ABR_KBPS_MIN = ultraschall.ConvertIntegerIntoString2(4, ABR_KBPS_MIN)
  ABR_KBPS_MAX = ultraschall.ConvertIntegerIntoString2(4, ABR_KBPS_MAX)
  
  local EncodeChannelAudio=0
  if channel_audio==true then EncodeChannelAudio=EncodeChannelAudio+1 end
  if per_channel==true then EncodeChannelAudio=EncodeChannelAudio+2 end
  
  RenderString="vggo"..VBR_Quality..string.char(Mode)..CBR_KBPS..ABR_KBPS..ABR_KBPS_MIN..ABR_KBPS_MAX.."\0"
  
  return ultraschall.Base64_Encoder(RenderString)
end
--A=ultraschall.CreateRenderCFG_OGG(1,1,3,4,5,600)

function ultraschall.CreateRenderCFG_DDP()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_DDP</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_DDP()</functioncall>
  <description>
    Returns the render-cfg-string for the DDP-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected DDP-settings
  </retvals>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, ddp</tags>
</US_DocBloc>
]]
  return "IHBkZA="
end

--A=ultraschall.CreateRenderCFG_DDP()



function ultraschall.CreateRenderCFG_FLAC(Bitrate, EncSpeed)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_FLAC</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_FLAC(integer Bitrate, integer EncSpeed)</functioncall>
  <description>
    Returns the render-cfg-string for the FLAC-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected FLAC-settings
  </retvals>
  <parameters>
    integer Bitrate - the bitrate of the flac-file; 
                    - 0, 24 bit
                    - 1, 23/24 bit
                    - 2, 22/24 bit
                    - 3, 21/24 bit
                    - 4, 20/24 bit
                    - 5, 19/24 bit
                    - 6, 18/24 bit
                    - 7, 17/24 bit
                    - 8, 16 bit
    integer EncSpeed - the encoding speed; 0(fastest) to 8(slowest); 5(default)
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, flac</tags>
</US_DocBloc>
]]
  if math.type(Bitrate)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_FLAC", "Bitrate", "must be an integer", -1) return nil end
  if math.type(EncSpeed)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_FLAC", "EncSpeed", "must be an integer", -2) return nil end
  if Bitrate<0 or Bitrate>8 then ultraschall.AddErrorMessage("CreateRenderCFG_FLAC", "Bitrate", "must be between 0(24 Bit) and 8(16 Bit)", -3) return nil end
  if EncSpeed<0 or EncSpeed>8 then ultraschall.AddErrorMessage("CreateRenderCFG_FLAC", "EncSpeed", "must be between 0(fastest speed) and 8(slowest speed)", -3) return nil end

  local renderstring="Y2FsZh[BITRATE]AAAA[ENCSPEED]AAAA"
  if Bitrate==0 then Bitrate="g"      -- 24 Bit
  elseif Bitrate==1 then Bitrate="c"  -- 23/24 Bit
  elseif Bitrate==2 then Bitrate="Y"  -- 22/24 Bit
  elseif Bitrate==3 then Bitrate="U"  -- 21/24 Bit
  elseif Bitrate==4 then Bitrate="Q"  -- 20/24 Bit
  elseif Bitrate==5 then Bitrate="M"  -- 19/24 Bit
  elseif Bitrate==6 then Bitrate="I"  -- 18/24 Bit
  elseif Bitrate==7 then Bitrate="E"  -- 17/24 Bit
  elseif Bitrate==8 then Bitrate="A"  -- 16 Bit  
  end
  
  if EncSpeed==0 then EncSpeed="A"     -- 0 - fastest
  elseif EncSpeed==1 then EncSpeed="B" -- 1
  elseif EncSpeed==2 then EncSpeed="C" -- 2
  elseif EncSpeed==3 then EncSpeed="D" -- 3
  elseif EncSpeed==4 then EncSpeed="E" -- 4
  elseif EncSpeed==5 then EncSpeed="F" -- 5 - default setting
  elseif EncSpeed==6 then EncSpeed="G" -- 6
  elseif EncSpeed==7 then EncSpeed="H" -- 7
  elseif EncSpeed==8 then EncSpeed="I" -- 8 - slowest speed
  end
  
  renderstring=string.gsub(renderstring, "%[BITRATE%]", Bitrate)
  renderstring=string.gsub(renderstring, "%[ENCSPEED%]", EncSpeed)
  return renderstring
end

--A=ultraschall.CreateRenderCFG_FLAC(1,1)

function ultraschall.CreateRenderCFG_WAVPACK(Mode, Bitdepth, Writemarkers, WriteBWFChunk, IncludeFilenameBWF)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_WAVPACK</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_WAVPACK(integer Mode, integer Bitdepth, integer Writemarkers, boolean WriteBWFChunk, boolean IncludeFilenameBWF)</functioncall>
  <description>
    Returns the render-cfg-string for the WAVPACK-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected WAVPACK-settings
  </retvals>
  <parameters>
    integer Mode - 0, Normal; 1, Fast; 2, High; 3, Very High(slowest)
    integer Bitdepth - the bitdepth of the WAVPACK-file
                     -   0(16Bit)
                     -   1(24Bit)
                     -   2(32Bit integer)
                     -   3(32Bit floating point)
                     -   4(23/24 Bit)
                     -   5(22/24 Bit)
                     -   6(21/24 Bit)
                     -   7(20/24 Bit)
                     -   8(19/24 Bit)
                     -   9(18/24 Bit)
                     -   10(17/24 Bit)
                     -   11(32 bit floating point -144dB floor)
                     -   12(32 bit floating point -120dB floor)
                     -   13(32 bit floating point -96dB floor)
    integer Writemarkers - Write markers as cues-checkboxes
                         - 0, nothing checked
                         - 1, Write markers as cues->checked
                         - 2, Write markers as cues and Only write markers starting with #->checked
    boolean WriteBWFChunk - the Write BWF chunk-checkbox; true, checked; false, unchecked
    boolean IncludeFilenameBWF - the include project filename in BWF data-checkbox; true, checked; false, unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, wavpack</tags>
</US_DocBloc>
]]
  if math.type(Mode)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAVPACK", "Mode", "must be an integer", -1) return nil end
  if math.type(Bitdepth)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAVPACK", "Bitdepth", "must be an integer", -2) return nil end
  if math.type(Writemarkers)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAVPACK", "Writemarkers", "must be an integer", -3) return nil end
  if type(WriteBWFChunk)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_WAVPACK", "WriteBWFChunk", "must be a boolean", -4) return nil end
  if type(IncludeFilenameBWF)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_WAVPACK", "IncludeFilenameBWF", "must be a boolean", -5) return nil end
  
  if Mode<0 or Mode>3 then ultraschall.AddErrorMessage("CreateRenderCFG_WAVPACK", "Mode", "must be between 0(Normal) and 3(Very High - slowest)", -6) return nil end
  if Bitdepth<0 or Bitdepth>13 then ultraschall.AddErrorMessage("CreateRenderCFG_WAVPACK", "Bitdepth", "must be between 0 and 13", -7) return nil end
  if Writemarkers<0 or Writemarkers>2 then ultraschall.AddErrorMessage("CreateRenderCFG_WAVPACK", "Writemarkers", "must be between 0 and 2", -8) return nil end


  local renderstring="a3B2dw[MODE]AAAA[BITDEPTH]AAAAA[WRITEMARKERS]AAAA[BWFCHUNK]AAAA="
  local BWFCHUNK
  if Mode==0 then Mode="A"      -- Normal
  elseif Mode==1 then Mode="E"  -- Fast
  elseif Mode==2 then Mode="M"  -- High
  elseif Mode==3 then Mode="Q"  -- Very High (slowest)
  end
  
  if Bitdepth==0 then Bitdepth="A"      -- 16 Bit
  elseif Bitdepth==1 then Bitdepth="B"  -- 24 Bit
  elseif Bitdepth==2 then Bitdepth="C"  -- 32 Bit integer
  elseif Bitdepth==3 then Bitdepth="D"  -- 32 Bit floating point
  elseif Bitdepth==4 then Bitdepth="E"  -- 23/24 Bit
  elseif Bitdepth==5 then Bitdepth="F"  -- 22/24 Bit
  elseif Bitdepth==6 then Bitdepth="G"  -- 21/24 Bit
  elseif Bitdepth==7 then Bitdepth="H"  -- 20/24 Bit
  elseif Bitdepth==8 then Bitdepth="I"  -- 19/24 Bit
  elseif Bitdepth==9 then Bitdepth="J"  -- 18/24 Bit
  elseif Bitdepth==10 then Bitdepth="K" -- 17/24 Bit
  elseif Bitdepth==11 then Bitdepth="L" -- 32 Bit floating point - -144dB floor
  elseif Bitdepth==12 then Bitdepth="M" -- 32 Bit floating point - -120dB floor
  elseif Bitdepth==13 then Bitdepth="N" -- 32 Bit floating point - -96dB floor
  end
  
  if Writemarkers==0 then Writemarkers="A"     -- nothing checked
  elseif Writemarkers==1 then Writemarkers="g" -- Write markers as cues->checked
  elseif Writemarkers==2 then Writemarkers="Q" -- Write markers as cues and Only write markers starting with #->checked
  end

  if WriteBWFChunk==false and IncludeFilenameBWF==false then BWFCHUNK="A"     -- nothing checked
  elseif WriteBWFChunk==true and IncludeFilenameBWF==false then BWFCHUNK="E"  -- Only write BWF-chunk
  elseif WriteBWFChunk==false and IncludeFilenameBWF==true then BWFCHUNK="I"  -- Only include project-filename in BWF-data
  elseif WriteBWFChunk==true and IncludeFilenameBWF==true then BWFCHUNK="M"   -- Write BWF-chunk and Include project filename in BWF data
  end
  
  renderstring=string.gsub(renderstring, "%[MODE%]", Mode)
  renderstring=string.gsub(renderstring, "%[BITDEPTH%]", Bitdepth)
  renderstring=string.gsub(renderstring, "%[WRITEMARKERS%]", Writemarkers)
  renderstring=string.gsub(renderstring, "%[BWFCHUNK%]", BWFCHUNK)
  
  return renderstring
end

--A=ultraschall.CreateRenderCFG_WAVPACK(0, 0, 2, true, true)

function ultraschall.IsValidRenderTable(RenderTable)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidRenderTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidRenderTable(RenderTable RenderTable)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns, if the table RenderTable is a valid RenderTable.
    
    Returns false in case of an error; the error-message contains the faulty table-entry.
  </description>
  <retvals>
    boolean retval - true, RenderTable is a valid RenderTable; false, it is not a valid RenderTable
  </retvals>
  <parameters>
    RenderTable RenderTable - the table, that you want to check for validity
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, is valid, check, rendertable</tags>
</US_DocBloc>
]]
  if type(RenderTable)~="table" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "must be a table", -1) return false end
  if type(RenderTable["RenderTable"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "no valid rendertable", -2) return false end
  if type(RenderTable["AddToProj"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"AddToProj\"] must be a boolean", -3) return false end
  if math.type(RenderTable["Bounds"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Bounds\"] must be an integer", -4) return false end
  if math.type(RenderTable["Channels"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Channels\"] must be an integer", -5) return false end
  if math.type(RenderTable["Dither"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Dither\"] must be an integer", -6) return false end
  if type(RenderTable["Endposition"])~="number" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Endposition\"] must be an integer", -7) return false end
  if type(RenderTable["MultiChannelFiles"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"MultiChannelFiles\"] must be a boolean", -8) return false end
  if math.type(RenderTable["OfflineOnlineRendering"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"OfflineOnlineRendering\"] must be an integer", -9) return false end
  if type(RenderTable["OnlyMonoMedia"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"OnlyMonoMedia\"] must be a boolean", -10) return false end 
  if type(RenderTable["ProjectSampleRateFXProcessing"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"ProjectSampleRateFXProcessing\"] must be a boolean", -11) return false end 
  if type(RenderTable["RenderFile"])~="string" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"RenderFile\"] must be a string", -12) return false end 
  if type(RenderTable["RenderPattern"])~="string" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"RenderPattern\"] must be a string", -13) return false end 
  if type(RenderTable["RenderQueueDelay"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"RenderQueueDelay\"] must be a boolean", -14) return false end
  if math.type(RenderTable["RenderResample"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"RenderResample\"] must be an integer", -15) return false end
  if type(RenderTable["RenderString"])~="string" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"RenderString\"] must be a string", -16) return false end 
  if math.type(RenderTable["SampleRate"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"SampleRate\"] must be an integer", -17) return false end
  if type(RenderTable["SaveCopyOfProject"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"SaveCopyOfProject\"] must be a boolean", -18) return false end
  if type(RenderTable["SilentlyIncrementFilename"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"SilentlyIncrementFilename\"] must be a boolean", -19) return false end
  if math.type(RenderTable["Source"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Source\"] must be an integer", -20) return false end    
  if type(RenderTable["Startposition"])~="number" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Startposition\"] must be an integer", -21) return false end
  if math.type(RenderTable["TailFlag"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"TailFlag\"] must be an integer", -22) return false end    
  if math.type(RenderTable["TailMS"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"TailMS\"] must be an integer", -23) return false end
  if math.type(RenderTable["RenderQueueDelaySeconds"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"RenderQueueDelaySeconds\"] must be an integer", -24) return false end
  if type(RenderTable["CloseAfterRender"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"CloseAfterRender\"] must be a boolean", -25) return false end
    
  return true
end

function ultraschall.ApplyRenderTable_Project(RenderTable, apply_rendercfg_string)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyRenderTable_Project</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyRenderTable_Project(RenderTable RenderTable, optional boolean apply_rendercfg_string)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets all stored render-settings from a RenderTable as the current project-settings.
            
    Expected table is of the following structure:
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
            RenderTable["Bounds"] - 0, Custom time range; 1, Entire project; 2, Time selection; 3, Project regions; 4, Selected Media Items(in combination with Source 32); 5, Selected regions
            RenderTable["Channels"] - the number of channels in the rendered file; 1, mono; 2, stereo; higher, the number of channels
            RenderTable["CloseAfterRender"] - true, close rendering to file-dialog after render; false, don't close it
            RenderTable["Dither"] - &1, dither master mix; &2, noise shaping master mix; &4, dither stems; &8, dither noise shaping
            RenderTable["Endposition"] - the endposition of the rendering selection in seconds
            RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 0, Full-speed Offline; 1, 1x Offline; 2, Online Render; 3, Online Render(Idle); 4, Offline Render(Idle)
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
            RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 0, Medium (64pt Sinc); 1, Low (Linear Interpolation); 2, Lowest (Point Sampling); 3, Good (192pt Sinc); 4, Better (348 pt Sinc); 5, Fast (IIR + Linear Interpolation); 6, Fast (IIRx2 + Linear Interpolation); 7, Fast (16pt Sinc); 8, HQ (512 pt); 9, Extreme HQ(768pt HQ Sinc)
            RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-ouput-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"] - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; true, checked; false, unchecked
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; true, checked; false, unchecked
            RenderTable["Source"] - 0, Master mix; 1, Master mix + stems; 3, Stems (selected tracks); 8, Region render matrix; 16, Tracks with only Mono-Media to Mono Files; 32, Selected media items
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? &1, custom time bounds; &2, entire project; &4, time selection; &8, all project regions; &16, selected media items; &32, selected project regions
            RenderTable["TailMS"] - the amount of milliseconds of the tail
            
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the render-settings was successful; false, it wasn't successful
  </retvals>
  <parameters>
    RenderTable RenderTable - a RenderTable, that contains all render-dialog-settings
    optional boolean apply_rendercfg_string - true or nil, apply it as well; false, don't apply it
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, set, project, rendertable</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("ApplyRenderTable_Project", "RenderTable", "not a valid RenderTable", -1) return false end
  if apply_rendercfg_string~=nil and type(apply_rendercfg_string)~="boolean" then ultraschall.AddErrorMessage("ApplyRenderTable_Project", "apply_rendercfg_string", "must be boolean", -2) return false end
  local _temp, retval, hwnd, AddToProj, ProjectSampleRateFXProcessing, ReaProject, SaveCopyOfProject, retval
  if ReaProject==nil then ReaProject=0 end
  --[[
  if ultraschall.type(ReaProject)~="ReaProject" and math.type(ReaProject)~="integer" then ultraschall.AddErrorMessage("ApplyRenderTable_Project", "ReaProject", "no such project available, must be either a ReaProject-object or the projecttab-number(1-based)", -1) return nil end
  if ReaProject==-1 then ReaProject=0x40000000 _temp=true 
  elseif ReaProject<-2 then 
    ultraschall.AddErrorMessage("GetRenderTable_Project", "ReaProject", "no such project-tab available, must be 0, for the current; 1, for the first, etc; -1, for the currently rendering project", -3) return nil 
  end
  
  if math.type(ReaProject)=="integer" then ReaProject=reaper.EnumProjects(ReaProject-1, "") end
  if ReaProject==nil and _temp~=true then 
    ultraschall.AddErrorMessage("GetRenderTable_Project", "ReaProject", "no such project available, must be either a ReaProject-object or the projecttab-number(1-based)", -4) return nil 
  elseif _temp==true then
    ultraschall.AddErrorMessage("GetRenderTable_Project", "ReaProject", "no project currently rendering", -5) return nil 
  end
  --]]
  if RenderTable["MultiChannelFiles"]==true then RenderTable["Source"]=RenderTable["Source"]+4 end
  if RenderTable["OnlyMonoMedia"]==true then RenderTable["Source"]=RenderTable["Source"]+16 end
  reaper.GetSetProjectInfo(ReaProject, "RENDER_SETTINGS", RenderTable["Source"], true)

  reaper.GetSetProjectInfo(ReaProject, "RENDER_BOUNDSFLAG", RenderTable["Bounds"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_CHANNELS", RenderTable["Channels"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_SRATE", RenderTable["SampleRate"], true)
  
  reaper.GetSetProjectInfo(ReaProject, "RENDER_STARTPOS", RenderTable["Startposition"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_ENDPOS", RenderTable["Endposition"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_TAILFLAG", RenderTable["TailFlag"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_TAILMS", RenderTable["TailMS"], true)
  
  if RenderTable["AddToProj"]==true then AddToProj=1 else AddToProj=0 end
  --print2(AddToProj)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_ADDTOPROJ", AddToProj, true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_DITHER", RenderTable["Dither"], true)
  
  ultraschall.SetRender_ProjectSampleRateForMix(RenderTable["ProjectSampleRateFXProcessing"])
  ultraschall.SetRender_AutoIncrementFilename(RenderTable["SilentlyIncrementFilename"])
  ultraschall.SetRender_QueueDelay(RenderTable["RenderQueueDelay"], RenderTable["RenderQueueDelaySeconds"])
  ultraschall.SetRender_ResampleMode(RenderTable["RenderResample"])
  ultraschall.SetRender_OfflineOnlineMode(RenderTable["OfflineOnlineRendering"])
  
  if RenderTable["RenderFile"]==nil then RenderTable["RenderFile"]="" end
  if RenderTable["RenderPattern"]==nil then 
    local path, filename = ultraschall.GetPath(RenderTable["RenderFile"])
    if filename:match(".*(%.).")~=nil then
      RenderTable["RenderPattern"]=filename:match("(.*)%.")
      RenderTable["RenderFile"]=string.gsub(path,"\\\\", "\\")
    else
      RenderTable["RenderPattern"]=filename
      RenderTable["RenderFile"]=string.gsub(path,"\\\\", "\\")
    end
  end
  reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FILE", RenderTable["RenderFile"], true)
  reaper.GetSetProjectInfo_String(ReaProject, "RENDER_PATTERN", RenderTable["RenderPattern"], true)
  if apply_rendercfg_string~=false then
    reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FORMAT", RenderTable["RenderString"], true)
  end
  
  if RenderTable["SaveCopyOfProject"]==true then SaveCopyOfProject=1 else SaveCopyOfProject=0 end
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "autosaveonrender2", SaveCopyOfProject, reaper.get_ini_file())
  else
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1060), "BM_SETCHECK", SaveCopyOfProject,0,0,0)
  end
  
  if reaper.SNM_GetIntConfigVar("renderclosewhendone",-199)&1==0 and RenderTable["CloseAfterRender"]==true then
    local temp = reaper.SNM_GetIntConfigVar("renderclosewhendone",-199)+1
    reaper.SNM_SetIntConfigVar("renderclosewhendone", temp)
  elseif reaper.SNM_GetIntConfigVar("renderclosewhendone",-199)&1==1 and RenderTable["CloseAfterRender"]==false then
    local temp = reaper.SNM_GetIntConfigVar("renderclosewhendone",-199)-1
    reaper.SNM_SetIntConfigVar("renderclosewhendone", temp)
  end
  return true
end

--A=ultraschall.GetRenderTable_Project(0)
--A=ultraschall.GetRenderTable_ProjectFile("C:\\Users\\meo\\Desktop\\Ultraschall-TutorialEinsteigerworkshop-Transkript-deutsch4.RPP")
--ultraschall.IsValidRenderTable(A)
--A["AddToProj"]="Tudelu, Zucker im Schuh"
--A["SaveCopyOfProject"]=false
--ultraschall.ApplyRenderTable_Project(A, false)

--AA =  reaper.GetSetProjectInfo(ReaProject, "PROJECT_SRATE_USE", 1, true)


function ultraschall.ApplyRenderTable_ProjectFile(RenderTable, projectfilename_with_path, apply_rendercfg_string, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyRenderTable_ProjectFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string ProjectStateChunk = ultraschall.ApplyRenderTable_ProjectFile(RenderTable RenderTable, string projectfilename_with_path, optional boolean apply_rendercfg_string, optional string ProjectStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets all stored render-settings from a RenderTable as the current project-settings.
            
    Expected table is of the following structure:
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
            RenderTable["Bounds"] - 0, Custom time range; 1, Entire project; 2, Time selection; 3, Project regions; 4, Selected Media Items(in combination with Source 32); 5, Selected regions
            RenderTable["Channels"] - the number of channels in the rendered file; 1, mono; 2, stereo; higher, the number of channels
            RenderTable["CloseAfterRender"] - close rendering to file-dialog after render; ignored, as this can't be set in projectfiles
            RenderTable["Dither"] - &1, dither master mix; &2, noise shaping master mix; &4, dither stems; &8, dither noise shaping
            RenderTable["Endposition"] - the endposition of the rendering selection in seconds
            RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 0, Full-speed Offline; 1, 1x Offline; 2, Online Render; 3, Online Render(Idle); 4, Offline Render(Idle);  
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
            RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 0, Medium (64pt Sinc); 1, Low (Linear Interpolation); 2, Lowest (Point Sampling); 3, Good (192pt Sinc); 4, Better (348 pt Sinc); 5, Fast (IIR + Linear Interpolation); 6, Fast (IIRx2 + Linear Interpolation); 7, Fast (16pt Sinc); 8, HQ (512 pt); 9, Extreme HQ(768pt HQ Sinc)
            RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-ouput-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"] - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; ignored, as this can't be stored in projectfiles
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; ignored, as this can't be stored in projectfiles
            RenderTable["Source"] - 0, Master mix; 1, Master mix + stems; 3, Stems (selected tracks); 8, Region render matrix; 16, Tracks with only Mono-Media to Mono Files; 32, Selected media items
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? &1, custom time bounds; &2, entire project; &4, time selection; &8, all project regions; &16, selected media items; &32, selected project regions
            RenderTable["TailMS"] - the amount of milliseconds of the tail
            
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the render-settings was successful; false, it wasn't successful
    string ProjectStateChunk - the altered project/ProjectStateChunk as a string
  </retvals>
  <parameters>
    RenderTable RenderTable - a RenderTable, that contains all render-dialog-settings
    string projectfilename_with_path - the rpp-projectfile, to which you want to apply the RenderTable; nil, to use parameter ProjectStateChunk instead
    optional boolean apply_rendercfg_string - true or nil, apply it as well; false, don't apply it
    optional parameter ProjectStateChunk - the ProjectStateChunkk, to which you want to apply the RenderTable
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, set, projectfile, rendertable</tags>
</US_DocBloc>
]]
  local retval, AddToProj, ProjectSampleRateFXProcessing
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("ApplyRenderTable_ProjectFile", "RenderTable", "not a valid RenderTable", -1) return false end
  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("ApplyRenderTable_ProjectFile", "ProjectStateChunk", "not a valid ProjectStateChunk", -2) return false end
  if projectfilename_with_path~=nil and (type(projectfilename_with_path)~="string" or reaper.file_exists(projectfilename_with_path)==false) then ultraschall.AddErrorMessage("ApplyRenderTable_ProjectFile", "projectfilename_with_path", "no such file", -3) return false end
  if ProjectStateChunk==nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("ApplyRenderTable_ProjectFile", "projectfilename_with_path", "not a valid rpp-projectfile", -4) return false end
  if apply_rendercfg_string~=nil and type(apply_rendercfg_string)~="boolean" then ultraschall.AddErrorMessage("ApplyRenderTable_ProjectFile", "apply_rendercfg_string", "must be boolean", -5) return false end
  
  if RenderTable["MultiChannelFiles"]==true then RenderTable["Source"]=RenderTable["Source"]+4 end
  if RenderTable["OnlyMonoMedia"]==true then RenderTable["Source"]=RenderTable["Source"]+16 end
  retval, ProjectStateChunk = ultraschall.SetProject_RenderStems(nil, RenderTable["Source"], ProjectStateChunk)
  retval, ProjectStateChunk = ultraschall.SetProject_RenderRange(nil, RenderTable["Bounds"], RenderTable["Startposition"], RenderTable["Endposition"], RenderTable["TailFlag"], RenderTable["TailMS"], ProjectStateChunk)  
  retval, ProjectStateChunk = ultraschall.SetProject_RenderFreqNChans(nil, 0, RenderTable["Channels"], RenderTable["SampleRate"], ProjectStateChunk)

  if RenderTable["AddToProj"]==true then AddToProj=1 else AddToProj=0 end  
  retval, ProjectStateChunk = ultraschall.SetProject_AddMediaToProjectAfterRender(nil, AddToProj, ProjectStateChunk)
  retval, ProjectStateChunk = ultraschall.SetProject_RenderDitherState(nil, RenderTable["Dither"], ProjectStateChunk)
  
  if RenderTable["ProjectSampleRateFXProcessing"]==true then ProjectSampleRateFXProcessing=1 else ProjectSampleRateFXProcessing=0 end
  local resample_mode, playback_resample_mode, project_smplrate4mix_and_fx = ultraschall.GetProject_RenderResample(nil, ProjectStateChunk)
  retval, ProjectStateChunk = ultraschall.SetProject_RenderResample(nil, RenderTable["RenderResample"], playback_resample_mode, ProjectSampleRateFXProcessing, ProjectStateChunk)
  
  retval, ProjectStateChunk = ultraschall.SetProject_RenderSpeed(nil, RenderTable["OfflineOnlineRendering"], ProjectStateChunk)
  retval, ProjectStateChunk = ultraschall.SetProject_RenderFilename(nil, RenderTable["RenderFile"], ProjectStateChunk)
  retval, ProjectStateChunk = ultraschall.SetProject_RenderPattern(nil, RenderTable["RenderPattern"], ProjectStateChunk)

  if RenderTable["RenderQueueDelay"]==true then 
    retval, ProjectStateChunk = ultraschall.SetProject_RenderQueueDelay(nil, RenderTable["RenderQueueDelaySeconds"], ProjectStateChunk)
  else
    retval, ProjectStateChunk = ultraschall.SetProject_RenderQueueDelay(nil, nil, ProjectStateChunk)
  end
  
  if apply_rendercfg_string==true or apply_rendercfg_string==nil then
    retval, ProjectStateChunk = ultraschall.SetProject_RenderCFG(nil, RenderTable["RenderString"], ProjectStateChunk)
  end
  
  if projectfilename_with_path~=nil then ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk) return true, ProjectStateChunk
  else return true, ProjectStateChunk
  end
end

--A=ultraschall.GetRenderTable_Project(0)
--A["RenderString"]="Whoops"
--B=ultraschall.ReadFullFile("c:\\Render-Queue-Documentation.RPP")
--L,L2=ultraschall.ApplyRenderTable_ProjectFile(A, "c:\\Render-Queue-Documentation.RPP", true, B)
--print2(L2)



--A=ultraschall.GetRenderTable_Project(0)

--B=ultraschall.IsValidRenderTable(A)

function ultraschall.CreateNewRenderTable(Source, Bounds, Startposition, Endposition, TailFlag, TailMS, RenderFile, RenderPattern,
SampleRate, Channels, OfflineOnlineRendering, ProjectSampleRateFXProcessing, RenderResample, OnlyMonoMedia, MultiChannelFiles,
Dither, RenderString, SilentlyIncrementFilename, AddToProj, SaveCopyOfProject, RenderQueueDelay, RenderQueueDelaySeconds, CloseAfterRender)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateNewRenderTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>RenderTable RenderTable = ultraschall.IsValidRenderTable(integer Source, integer Bounds, number Startposition, number Endposition, integer TailFlag, integer TailMS, string RenderFile, string RenderPattern, integer SampleRate, integer Channels, integer OfflineOnlineRendering, boolean ProjectSampleRateFXProcessing, integer RenderResample, boolean OnlyMonoMedia, boolean MultiChannelFiles, integer Dither, string RenderString, boolean SilentlyIncrementFilename, boolean AddToProj, boolean SaveCopyOfProject, boolean RenderQueueDelay, integer RenderQueueDelaySeconds, boolean CloseAfterRender)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Creates a new RenderTable.
    
    Returns nil in case of an error
  </description>
  <retvals>
    RenderTable RenderTable - the created RenderTable
  </retvals>
  <parameters>
    integer Source - The Source-dropdownlist; 
                   - 0, Master mix
                   - 1, Master mix + stems
                   - 3, Stems (selected tracks)
                   - 8, Region render matrix
                   - 32, Selected media items
    integer Bounds - The Bounds-dropdownlist
                   - 0, Custom time range
                   - 1, Entire project
                   - 2, Time selection
                   - 3, Project regions
                   - 4, Selected Media Items(in combination with Source 32)
                   - 5, Selected regions
    number Startposition - the startposition of the render-section in seconds; only used when Bounds=0(Custom time range)
    number Endposition - the endposition of the render-section in seconds; only used when Bounds=0(Custom time range)
    integer TailFlag - in which bounds is the Tail-checkbox checked? 
                     - &1, custom time bounds
                     - &2, entire project
                     - &4, time selection
                     - &8, all project regions
                     - &16, selected media items
                     - &32, selected project regions
    integer TailMS - the amount of milliseconds of the tail
    string RenderFile - the contents of the Directory-inputbox of the Render to File-dialog
    string RenderPattern - the render pattern as input into the File name-inputbox of the Render to File-dialog; set to "" if you don't want to use it
    integer SampleRate - the samplerate of the rendered file(s)
    integer Channels - the number of channels in the rendered file; 
                     - 1, mono
                     - 2, stereo
                     - 3 and higher, the number of channels
    integer OfflineOnlineRendering - Offline/Online rendering-dropdownlist
                                   - 0, Full-speed Offline
                                   - 1, 1x Offline
                                   - 2, Online Render
                                   - 3, Online Render(Idle)
                                   - 4, Offline Render(Idle)
    boolean ProjectSampleRateFXProcessing - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
    integer RenderResample - Resample mode-dropdownlist
                           - 0, Medium (64pt Sinc)
                           - 1, Low (Linear Interpolation)
                           - 2, Lowest (Point Sampling)
                           - 3, Good (192pt Sinc)
                           - 4, Better (348 pt Sinc)
                           - 5, Fast (IIR + Linear Interpolation)
                           - 6, Fast (IIRx2 + Linear Interpolation)
                           - 7, Fast (16pt Sinc)
                           - 8, HQ (512 pt)
                           - 9, Extreme HQ(768pt HQ Sinc)
    boolean OnlyMonoMedia - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
    boolean MultiChannelFiles - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
    integer Dither - the Dither/Noise shaping-checkboxes: 
                   - &1, dither master mix
                   - &2, noise shaping master mix
                   - &4, dither stems
                   - &8, dither noise shaping
    string RenderString - the render-cfg-string, that holds all settings of the currently set render-ouput-format as BASE64 string
    boolean SilentlyIncrementFilename - Silently increment filenames to avoid overwriting-checkbox; ignored, as this can't be stored in projectfiles
    boolean AddToProj - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
    boolean SaveCopyOfProject - the "Save copy of project to outfile.wav.RPP"-checkbox; ignored, as this can't be stored in projectfiles
    boolean RenderQueueDelay - Delay queued render to allow samples to load-checkbox; ignored, as this can't be stored in projectfiles
    integer RenderQueueDelaySeconds - the amount of seconds for the render-queue-delay
    boolean CloseAfterRender - true, closes rendering to file-dialog after render; false, doesn't close it
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, is valid, check, rendertable</tags>
</US_DocBloc>
]]
  if type(AddToProj)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "AddToProj", "must be a boolean", -3) return end
  if math.type(Bounds)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Bounds", "must be an integer", -4) return end
  if math.type(Channels)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Channels", "must be an integer", -5) return end
  if math.type(Dither)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Dither", "must be an integer", -6) return end
  if type(Endposition)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Endposition", "must be an integer", -7) return end
  if type(MultiChannelFiles)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "MultiChannelFiles", "must be a boolean", -8) return end
  if math.type(OfflineOnlineRendering)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "OfflineOnlineRendering", "must be an integer", -9) return end
  if type(OnlyMonoMedia)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "OnlyMonoMedia", "must be a boolean", -10) return end 
  if type(ProjectSampleRateFXProcessing)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "ProjectSampleRateFXProcessing", "must be a boolean", -11) return end 
  if type(RenderFile)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderFile", "must be a string", -12) return end 
  if type(RenderPattern)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderPattern", "must be a string", -13) return end 
  if type(RenderQueueDelay)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderQueueDelay", "must be a boolean", -14) return end
  if math.type(RenderResample)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderResample", "must be an integer", -15) return end
  if type(RenderString)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderString", "must be a string", -16) return end 
  if math.type(SampleRate)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SampleRate", "must be an integer", -17) return end
  if type(SaveCopyOfProject)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SaveCopyOfProject", "must be a boolean", -18) return end
  if type(SilentlyIncrementFilename)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SilentlyIncrementFilename", "must be a boolean", -19) return end
  if math.type(Source)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Source", "must be an integer", -20) return end    
  if type(Startposition)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Startposition", "must be an integer", -21) return end
  if math.type(TailFlag)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "TailFlag", "must be an integer", -22) return end    
  if math.type(TailMS)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "TailMS", "must be an integer", -23) return end    
  if math.type(RenderQueueDelaySeconds)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderQueueDelaySeconds", "must be an integer", -24) return end
  if math.type(CloseAfterRender)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "CloseAfterRender", "must be a boolean", -25) return end
  
  local RenderTable={}
  RenderTable["AddToProj"]=AddToProj
  RenderTable["Bounds"]=Bounds
  RenderTable["Channels"]=Channels
  RenderTable["Dither"]=Dither
  RenderTable["Endposition"]=Endposition
  RenderTable["MultiChannelFiles"]=MultiChannelFiles
  RenderTable["OfflineOnlineRendering"]=OfflineOnlineRendering
  RenderTable["OnlyMonoMedia"]=OnlyMonoMedia
  RenderTable["ProjectSampleRateFXProcessing"]=ProjectSampleRateFXProcessing
  RenderTable["RenderFile"]=RenderFile
  RenderTable["RenderPattern"]=RenderPattern
  RenderTable["RenderQueueDelay"]=RenderQueueDelay
  RenderTable["RenderQueueDelaySeconds"]=RenderQueueDelaySeconds
  RenderTable["RenderResample"]=RenderResample
  RenderTable["RenderString"]=RenderString
  RenderTable["RenderTable"]=true 
  RenderTable["SampleRate"]=SampleRate
  RenderTable["SaveCopyOfProject"]=SaveCopyOfProject
  RenderTable["SilentlyIncrementFilename"]=SilentlyIncrementFilename
  RenderTable["Source"]=Source
  RenderTable["Startposition"]=Startposition
  RenderTable["TailFlag"]=TailFlag
  RenderTable["TailMS"]=TailMS
  RenderTable["CloseAfterRender"]=CloseAfterRender
  return RenderTable
end

--Source, Bounds, Startposition, Endposition, TailFlag, TailMS, RenderFile, RenderPattern,
--SampleRate, Channels, OfflineOnlineRendering, ProjectSampleRateFXProcessing, RenderResample, OnlyMonoMedia, MultiChannelFiles,
--Dither, RenderString, SilentlyIncrementFilename, AddToProj, SaveCopyOfProject, RenderQueueDelay)


--O=ultraschall.CreateNewRenderTable(2, 0, 2, 22, 0, 190, "aRenderFile", "apattern", 99, 3, 3,    false,   2, false, false, 1, "l3pm", true, true, true, true)
 


--ultraschall.IsValidRenderTable(O)
--L,L2=ultraschall.ApplyRenderTable_Project(O)
--print2(O["RenderString"])
--reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT", "l3pm", true)

function ultraschall.GetRender_SaveCopyOfProject()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_SaveCopyOfProject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetRender_SaveCopyOfProject()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the current state of the "Save copy of project to outfile.wav.RPP"-checkbox from the Render to File-dialog.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, checkbox is checked; false, checkbox is unchecked
  </retvals>
  <chapter_context>
    Configuration Settings
    Render to File
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, get, checkbox, render, save copy of project</tags>
</US_DocBloc>
]]
  local SaveCopyOfProject, hwnd, state, retval
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    state, retval = reaper.BR_Win32_GetPrivateProfileString("REAPER", "autosaveonrender2", 0, reaper.get_ini_file())
    retval=tonumber(retval)
  else
    retval=reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1060), "BM_GETCHECK", 0,0,0,0)
  end
  if retval==0 then retval=false else retval=true end
  return retval
end

--A=ultraschall.GetRender_SaveCopyOfProject(false)

function ultraschall.SetRender_SaveCopyOfProject(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_SaveCopyOfProject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetRender_SaveCopyOfProject(boolean state)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets the "Save copy of project to outfile.wav.RPP"-checkbox of the Render to File-dialog.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </parameters>
  <chapter_context>
    Configuration Settings
    Render to File
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, set, checkbox, render, save copy of project</tags>
</US_DocBloc>
]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("SetRender_SaveCopyOfProject", "state", "must be a boolean", -1) return false end
  local SaveCopyOfProject, hwnd, retval
  if state==true then SaveCopyOfProject=1 else SaveCopyOfProject=0 end
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "autosaveonrender2", SaveCopyOfProject, reaper.get_ini_file())
    retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "autosaveonrender", SaveCopyOfProject, reaper.get_ini_file())
  else
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1060), "BM_SETCHECK", SaveCopyOfProject,0,0,0)
    retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "autosaveonrender2", SaveCopyOfProject, reaper.get_ini_file())
    retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "autosaveonrender", SaveCopyOfProject, reaper.get_ini_file())
  end
  return retval
end

--B=ultraschall.SetRender_SaveCopyOfProject(true)


function ultraschall.SetRender_QueueDelay(state, length)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_QueueDelay</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetRender_QueueDelay(boolean state, integer length)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets the "Delay queued render to allow samples to load"-checkbox of the Render to File-dialog.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, check the checkbox; false, uncheck the checkbox
    integer length - the number of seconds the delay shall be
  </parameters>
  <chapter_context>
    Configuration Settings
    Render to File
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, set, checkbox, render, delay queued render</tags>
</US_DocBloc>
]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("SetRender_QueueDelay", "state", "must be a boolean", -1) return false end
  if math.type(length)~="integer" then ultraschall.AddErrorMessage("SetRender_QueueDelay", "length", "must be an integer", -2) return false end
  local SaveCopyOfProject, hwnd, retval
  if state==false then state=0 length=-length else state=1 end
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    reaper.SNM_SetIntConfigVar("renderqdelay", length)
    retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "renderqdelay", length, reaper.get_ini_file())
  else
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1808), "BM_SETCHECK", state,0,0,0)
    reaper.SNM_SetIntConfigVar("renderqdelay", length)
    retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "renderqdelay", length, reaper.get_ini_file())
  end
  return retval
end

--A=ultraschall.SetRender_SaveCopyOfProject(true)
--ultraschall.SetRender_QueueDelay(true, 118)
--reaper.SNM_SetIntConfigVar("renderqdelay", 7)

function ultraschall.GetRender_QueueDelay()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_QueueDelay</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer length = ultraschall.GetRender_QueueDelay()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the current checkstate of the "Delay queued render to allow samples to load"-checkbox from the Render to File-dialog,
    as well as the length of the queue-render-delay.
  </description>
  <retvals>
    boolean state - true, check the checkbox; false, uncheck the checkbox
    integer length - the number of seconds the delay shall be
  </retvals>
  <chapter_context>
    Configuration Settings
    Render to File
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, get, checkbox, render, delay queued render</tags>
</US_DocBloc>
]]
  local SaveCopyOfProject, hwnd, retval, length, state
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    length=reaper.SNM_GetIntConfigVar("renderqdelay", 0)
    if length<1 then length=-length state=false else state=true end
  else
    state = reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1808), "BM_GETCHECK", 0,0,0,0)
    length = reaper.SNM_GetIntConfigVar("renderqdelay", 0)
    if length<0 then length=-length end
    if state==0 then state=false else state=true end
  end
  return state, length
end

--A,B=ultraschall.GetRender_QueueDelay()

--A,B=reaper.GetTrackStateChunk(reaper.GetTrack(0,1),"",false)
--A1=ultraschall.GetTrackAUXSendReceives(-1, 1, B)

function ultraschall.SetRender_ProjectSampleRateForMix(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_ProjectSampleRateForMix</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetRender_ProjectSampleRateForMix(boolean state)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets the "Use project sample rate for mixing and FX/synth processing"-checkbox of the Render to File-dialog.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </parameters>
  <chapter_context>
    Configuration Settings
    Render to File
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, set, checkbox, render, use project sample rate for mixing</tags>
</US_DocBloc>
]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("SetRender_ProjectSampleRateForMix", "state", "must be a boolean", -1) return false end
  local SaveCopyOfProject, hwnd, retval
  if state==false then state=0 else state=1 end
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    reaper.SNM_SetIntConfigVar("projrenderrateinternal", state)
  else
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1062), "BM_SETCHECK", state,0,0,0)
    reaper.SNM_SetIntConfigVar("projrenderrateinternal", state)
  end
  return true
end

--A=ultraschall.SetRender_ProjectSampleRateForMix(false)

function ultraschall.GetRender_ProjectSampleRateForMix()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_ProjectSampleRateForMix</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetRender_ProjectSampleRateForMix()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the current state of the "Use project sample rate for mixing and FX/synth processing"-checkbox from the Render to File-dialog.
  </description>
  <retvals>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </retvals>
  <chapter_context>
    Configuration Settings
    Render to File
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, get, checkbox, render, use project sample rate for mixing</tags>
</US_DocBloc>
]]
  local SaveCopyOfProject, hwnd, retval, length, state
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    state=reaper.SNM_GetIntConfigVar("projrenderrateinternal", 0)
  else
    state = reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1062), "BM_GETCHECK", 0,0,0,0)
  end
  if state==0 then state=false else state=true end
  return state
end

--A=ultraschall.GetRender_ProjectSampleRateForMix()

function ultraschall.SetRender_AutoIncrementFilename(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_AutoIncrementFilename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetRender_AutoIncrementFilename(boolean state)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the current state of the "Silently increment filenames to avoid overwriting"-checkbox from the Render to File-dialog.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </parameters>
  <chapter_context>
    Configuration Settings
    Render to File
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, get, checkbox, render, auto increment filenames</tags>
</US_DocBloc>
]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("SetRender_AutoIncrementFilename", "state", "must be a boolean", -1) return false end
  local SaveCopyOfProject, hwnd, retval
  if state==false then state=0 else state=1 end
  hwnd = ultraschall.GetRenderToFileHWND()
  local oldval=reaper.SNM_GetIntConfigVar("renderclosewhendone",-1)
  if state==1 and oldval&16==0 then oldval=oldval+16 
  elseif state==0 and oldval&16==16 then oldval=oldval-16 end
  if hwnd~=nil then
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1042), "BM_SETCHECK", state,0,0,0)
  end
  reaper.SNM_SetIntConfigVar("renderclosewhendone", oldval)
  return true
end

--A=ultraschall.SetRender_AutoIncrementFilename(false)

function ultraschall.GetRender_AutoIncrementFilename()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_AutoIncrementFilename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetRender_AutoIncrementFilename()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the current state of the "Silently increment filenames to avoid overwriting"-checkbox from the Render to File-dialog.
  </description>
  <retvals>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </retvals>
  <chapter_context>
    Configuration Settings
    Render to File
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render, get, checkbox, render, auto increment filenames</tags>
</US_DocBloc>
]]
  local SaveCopyOfProject, hwnd, retval, length, state
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    state=reaper.SNM_GetIntConfigVar("renderclosewhendone", 0)
    if state&16==16 then state=1 end
  else
    state = reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1042), "BM_GETCHECK", 1,0,0,0)
  end
  if state==0 then state=false else state=true end
  return state
end

--A=ultraschall.GetRender_AutoIncrementFilename()

function ultraschall.GetRenderPreset_Names()
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>GetRenderPreset_Names</slug>
   <requires>
     Ultraschall=4.00
     Reaper=5.975
     Lua=5.3
   </requires>
   <functioncall>integer bounds_presets, table bounds_names, integer options_format_presets, table options_format_names, integer both_presets, table both_names = ultraschall.GetRenderPreset_Names()</functioncall>
   <description>
     Returns all render-preset-names for a) Bounds and output pattern/filename b) Options and format c) both presets, who share the same name
   </description>
   <retvals>
      integer bounds_presets - the number of found bounds and output-pattern-presets
      table bounds_names - the names of all found bounds and output-pattern-presets
      integer options_format_presets - the number of found options and format-presets
      table options_format_names - the names of all found options and format-presets
      integer both_presets - the number of found presets, who both share the same name
      table both_names - the names of all found presets, who both share the same name
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Documentation</target_document>
   <source_document>ultraschall_functions_engine.lua</source_document>
   <tags>render management, get, render preset, names</tags>
 </US_DocBloc>
 ]]
  local A, Count, Lines, Output_Preset_Counter, Output_Preset, Preset_Counter, Preset, temp
  A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  Count, Lines=ultraschall.SplitStringAtLineFeedToArray(A)
  Output_Preset_Counter=0
  Output_Preset={}
  Preset_Counter=0
  Preset={}
  
  for i=1, Count do
    if Lines[i]:match("^<RENDERPRESET ") then 
      Preset_Counter=Preset_Counter+1 
      temp=Lines[i]:match("^<RENDERPRESET (.)")
      if temp=="\"" then 
        Preset[Preset_Counter]=Lines[i]:match("^<RENDERPRESET \"(.-)\"")
      else
        Preset[Preset_Counter]=Lines[i]:match("^<RENDERPRESET (.-) ")
      end
    elseif Lines[i]:match("^RENDERPRESET_OUTPUT ") then 
      Output_Preset_Counter=Output_Preset_Counter+1 
      temp=Lines[i]:match("^RENDERPRESET_OUTPUT (.)")
      if temp=="\"" then 
        Output_Preset[Output_Preset_Counter]=Lines[i]:match("^RENDERPRESET_OUTPUT \"(.-)\"")
      else
        Output_Preset[Output_Preset_Counter]=Lines[i]:match("^RENDERPRESET_OUTPUT (.-) ")
      end
    end
  end
  
  local duplicate_count, duplicate_array, originalscount_array1, originals_array1, 
                                          originalscount_array2, originals_array2 
                      = ultraschall.GetDuplicatesFromArrays(Output_Preset, Preset)
  
  return Output_Preset_Counter, Output_Preset, Preset_Counter, Preset, duplicate_count, duplicate_array
end

--A,B,C,D,E,F,G=ultraschall.GetRender_AllPresetNames()

function ultraschall.GetRenderPreset_RenderTable(Bounds_Name, Options_and_Format_Name)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>GetRenderPreset_RenderTable</slug>
   <requires>
     Ultraschall=4.00
     Reaper=5.975
     Lua=5.3
   </requires>
   <functioncall>RenderTable RenderTable = ultraschall.GetRenderPreset_RenderTable(string Bounds_Name, string Options_and_Format_Name)</functioncall>
   <description markup_type="markdown" markup_version="1.0.1" indent="default">
     returns a rendertable, that contains all settings of a specific render-preset.
    
     use [GetRenderPreset_Names](#GetRenderPreset_Names) to get the available render-preset-names.
     
     Some settings aren't stored in Presets and will get default values:
     TailMS=0, SilentlyIncrementFilename=false, AddToProj=false, SaveCopyOfProject=false, RenderQueueDelay=false, RenderQueueDelaySeconds=false
     
     returned table if of the following format:
     
     RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; always false, as this isn't stored in render-presets
     RenderTable["Bounds"] - 0, Custom time range; 1, Entire project; 2, Time selection; 3, Project regions; 4, Selected Media Items(in combination with Source 32); 5, Selected regions
     RenderTable["Channels"] - the number of channels in the rendered file; 1, mono; 2, stereo; higher, the number of channels
     RenderTable["CloseAfterRender"] - close rendering to file-dialog after rendering; always true, as this isn't stored in render-presets
     RenderTable["Dither"] - &1, dither master mix; &2, noise shaping master mix; &4, dither stems; &8, dither noise shaping
     RenderTable["Endposition"] - the endposition of the rendering selection in seconds
     RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
     RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 0, Full-speed Offline; 1, 1x Offline; 2, Online Render; 3, Online Render(Idle); 4, Offline Render(Idle)
     RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
     RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
     RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog
     RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog
     RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; always false, as this isn't stored in render-presets
     RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay; always 0, as this isn't stored in render-presets
     RenderTable["RenderResample"] - Resample mode-dropdownlist; 0, Medium (64pt Sinc); 1, Low (Linear Interpolation); 2, Lowest (Point Sampling); 3, Good (192pt Sinc); 4, Better (348 pt Sinc); 5, Fast (IIR + Linear Interpolation); 6, Fast (IIRx2 + Linear Interpolation); 7, Fast (16pt Sinc); 8, HQ (512 pt); 9, Extreme HQ(768pt HQ Sinc)
     RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-ouput-format as BASE64 string
     RenderTable["RenderTable"]=true - signals, this is a valid render-table
     RenderTable["SampleRate"] - the samplerate of the rendered file(s)
     RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; always false, as this isn't stored in render-presets
     RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; always true, as this isn't stored in Presets
     RenderTable["Source"] - 0, Master mix; 1, Master mix + stems; 3, Stems (selected tracks); 8, Region render matrix; 16, Tracks with only Mono-Media to Mono Files; 32, Selected media items
     RenderTable["Startposition"] - the startposition of the rendering selection in seconds
     RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? &1, custom time bounds; &2, entire project; &4, time selection; &8, all project regions; &16, selected media items; &32, selected project regions
     RenderTable["TailMS"] - the amount of milliseconds of the tail; always 0, as this isn't stored in render-presets
     
     
     Returns nil in case of an error
   </description>
   <parameters>
     string Bounds_Name - the name of the Bounds-render-preset you want to get
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to get
   </parameters>
   <retvals>
     RenderTable RenderTable - a render-table, which contains all settings from a render-preset
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Documentation</target_document>
   <source_document>ultraschall_functions_engine.lua</source_document>
   <tags>render management, get, render preset, names</tags>
 </US_DocBloc>
 ]]
  if type(Bounds_Name)~="string" then ultraschall.AddErrorMessage("GetRenderPreset_RenderTable", "Bounds_Name", "must be a string", -1) return end
  if type(Options_and_Format_Name)~="string" then ultraschall.AddErrorMessage("GetRenderPreset_RenderTable", "Options_and_Format_Name", "must be a string", -2) return end
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  if Bounds_Name:match("%s")~=nil then Bounds_Name="\""..Bounds_Name.."\"" end
  if Options_and_Format_Name:match("%s")~=nil then Options_and_Format_Name="\""..Options_and_Format_Name.."\"" end
  
  local Bounds=A:match("RENDERPRESET_OUTPUT "..Bounds_Name.." (.-)\n")
  if Bounds==nil then ultraschall.AddErrorMessage("GetRenderPreset_RenderTable", "Bounds_Name", "no such Bounds-preset available", -3) return end
  
  local RenderFormatOptions=A:match("<RENDERPRESET "..Options_and_Format_Name.." (.-\n>)\n")
  if RenderFormatOptions==nil then ultraschall.AddErrorMessage("GetRenderPreset_RenderTable", "Options_and_Format_Name", "no such Render-Format-preset available", -4) return end
  
  local SampleRate, channels, offline_online_dropdownlist, 
  useprojectsamplerate_checkbox, resamplemode_dropdownlist, 
  dither, rendercfg = RenderFormatOptions:match("(.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-)")
  rendercfg = RenderFormatOptions:match("\n%s*(.*)\n")

  local bounds_dropdownlist, start_position, endposition, source_dropdownlist_and_checkboxes, 
  unknown, outputfilename_renderpattern, tails_checkbox = Bounds:match("(.-) (.-) (.-) (.-) (.-) (.-) (.*)")
  
  local MultiChannel, MonoMedia
  
  if source_dropdownlist_and_checkboxes&4==0 then 
    MultiChannel=false 
  else 
    MultiChannel=true 
    source_dropdownlist_and_checkboxes=source_dropdownlist_and_checkboxes-4
  end
  if source_dropdownlist_and_checkboxes&16==0 then 
    MonoMedia=false 
  else 
    MonoMedia=true 
    source_dropdownlist_and_checkboxes=math.floor(source_dropdownlist_and_checkboxes-16)
  end
  
  if useprojectsamplerate_checkbox==0 then useprojectsamplerate_checkbox=false else useprojectsamplerate_checkbox=true end

  local RenderTable=ultraschall.CreateNewRenderTable(source_dropdownlist_and_checkboxes, tonumber(bounds_dropdownlist), tonumber(start_position),
                                               tonumber(endposition), tonumber(tails_checkbox), 0, "", outputfilename_renderpattern, 
                                               tonumber(SampleRate), tonumber(channels), tonumber(offline_online_dropdownlist), 
                                               useprojectsamplerate_checkbox, 
                                               tonumber(resamplemode_dropdownlist), MonoMedia, MultiChannel, tonumber(dither), rendercfg, 
                                               true, false, false, false, 0, true)
  return RenderTable
end

--OOO=ultraschall.GetRender_Preset("A127", "A17")

function ultraschall.DeleteRenderPreset_Bounds(Bounds_Name)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>DeleteRenderPreset_Bounds</slug>
   <requires>
     Ultraschall=4.00
     Reaper=5.975
     Lua=5.3
   </requires>
   <functioncall>boolean retval = ultraschall.DeleteRenderPreset_Bounds(string Bounds_Name)</functioncall>
   <description markup_type="markdown" markup_version="1.0.1" indent="default">
     deletes a Bounds-render-preset from Reaper's render-presets.
     
     This deletes all(!) occurrences of the Bounds-render-preset with the same name. 
     Though, you shouldn't store multiple Bounds-render-presets with the same name into reaper-render.ini in the first place.
    
     use [GetRenderPreset_Names](#GetRenderPreset_Names) to get the available render-preset-names.
     
     Returns false in case of an error
   </description>
   <parameters>
     string Bounds_Name - the name of the Bounds-render-preset you want to get
   </parameters>
   <retvals>
     boolean retval - true, deleting was successful; false, deleting was unsuccessful
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Documentation</target_document>
   <source_document>ultraschall_functions_engine.lua</source_document>
   <tags>render management, delete, render preset, names, bounds</tags>
 </US_DocBloc>
 ]]
  if type(Bounds_Name)~="string" then ultraschall.AddErrorMessage("DeleteRenderPreset_Bounds", "Bounds_Name", "must be a string", -1) return false end
  local A,B
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  B=string.gsub(A, "RENDERPRESET_OUTPUT "..Bounds_Name.." (.-)\n", "")
  if A==B then ultraschall.AddErrorMessage("DeleteRenderPreset_Bounds", "Bounds_Name", "no such Bounds-preset", -2) return false end
  A=ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-render.ini", B)
  if A==-1 then ultraschall.AddErrorMessage("DeleteRenderPreset_Bounds", "", "can't access "..reaper.GetResourcePath().."/reaper-render.ini", -3) return false end
  return true
end

--ultraschall.DeleteRenderPreset_Bounds("A02")

function ultraschall.DeleteRenderPreset_FormatOptions(Options_and_Format_Name)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>DeleteRenderPreset_FormatOptions</slug>
   <requires>
     Ultraschall=4.00
     Reaper=5.975
     Lua=5.3
   </requires>
   <functioncall>boolean retval = ultraschall.DeleteRenderPreset_FormatOptions(string Options_and_Format_Name)</functioncall>
   <description markup_type="markdown" markup_version="1.0.1" indent="default">
     deletes a Render-Format-Options-render-preset from Reaper's render-presets.
     
     This deletes all(!) occurrences of the Render-Format-Options-render-preset with the same name. 
     Though, you shouldn't store multiple Render-Format-Options-render-preset with the same name into reaper-render.ini in the first place.
    
     use [GetRenderPreset_Names](#GetRenderPreset_Names) to get the available render-preset-names.
     
     Returns false in case of an error
   </description>
   <parameters>
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to get
   </parameters>
   <retvals>
     boolean retval - true, deleting was successful; false, deleting was unsuccessful
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Documentation</target_document>
   <source_document>ultraschall_functions_engine.lua</source_document>
   <tags>render management, delete, render preset, names, format options</tags>
 </US_DocBloc>
 ]]
  if type(Options_and_Format_Name)~="string" then ultraschall.AddErrorMessage("DeleteRenderPreset_FormatOptions", "Options_and_Format_Name", "must be a string", -1) return false end
  local A,B
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  B=string.gsub(A, "<RENDERPRESET "..Options_and_Format_Name.." (.-\n>)\n", "")
  if A==B then ultraschall.AddErrorMessage("DeleteRenderPreset_FormatOptions", "Options_and_Format_Name", "no such Bounds-preset", -2) return false end
  A=ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-render.ini", B)
  if A==-1 then ultraschall.AddErrorMessage("DeleteRenderPreset_FormatOptions", "", "can't access "..reaper.GetResourcePath().."/reaper-render.ini", -3) return false end
  return true
end

--ultraschall.DeleteRenderPreset_FormatOptions("A02")


function ultraschall.AddRenderPreset(Bounds_Name, Options_and_Format_Name, RenderTable)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>AddRenderPreset</slug>
   <requires>
     Ultraschall=4.00
     Reaper=5.975
     Lua=5.3
   </requires>
   <functioncall>boolean retval = ultraschall.AddRenderPreset(string Bounds_Name, string Options_and_Format_Name, RenderTable RenderTable)</functioncall>
   <description>
     adds a new render-preset into reaper-render.ini. 
     
     This function will check, whether the chosen names are already in use. 
     
     Added render-presets are available after (re-)opening in the Render to File-dialog     
     
     Note: You can choose, whether to include only Bounds, only RenderFormatOptions of both. The Bounds and the RenderFormatOptions store different parts of the render-presets.
     
     Bounds_Name stores only:
              RenderTable["Bounds"] - the bounds-dropdownlist, 
                                      0, Custom time range
                                      1, Entire project 
                                      2, Time selection 
                                      3, Project regions
                                      4, Selected Media Items(in combination with Source 32)
                                      5, Selected regions 
              RenderTable["Startposition"] - the startposition of the render
              RenderTable["Endposition"] - the endposition of the render
              RenderTable["Source"]+RenderTable["MultiChannelFiles"]+RenderTable["OnlyMonoMedia"] - the source dropdownlist, includes 
                                      0, Master mix 
                                      1, Master mix + stems
                                      3, Stems (selected tracks)
                                      &4, Multichannel tracks to multichannel files
                                      8, Region render matrix
                                      &16, Tracks with only mono media to mono files
                                      32, Selected media items
              "0"    - unknown, default setting is 0
              RenderTable["RenderPattern"] - the renderpattern, which hold also the wildcards
              RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? 
                                      &1, custom time bounds
                                      &2, entire project
                                      &4, time selection
                                      &8, all project regions
                                      &16, selected media items
                                      &32, selected project regions 
     
     Options_and_Format_Name stores only:
              RenderTable["SampleRate"] - the samplerate, with which to render; 0, use project-settings
              RenderTable["Channels"] - the number of channels for the output-file
              RenderTable["OfflineOnlineRendering"] - the offline/online-dropdownlist 
                                      0, Full-speed Offline
                                      1, 1x Offline
                                      2, Online Render
                                      3, Online Render(Idle)
                                      4, Offline Render(Idle); 
              RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; 1, checked; 0, unchecked 
              RenderTable["RenderResample"] - Resample mode-dropdownlist; 
                                      0, Medium (64pt Sinc)
                                      1, Low (Linear Interpolation)
                                      2, Lowest (Point Sampling)
                                      3, Good (192pt Sinc)
                                      4, Better (348 pt Sinc)
                                      5, Fast (IIR + Linear Interpolation)
                                      6, Fast (IIRx2 + Linear Interpolation)
                                      7, Fast (16pt Sinc)
                                      8, HQ (512 pt)
                                      9, Extreme HQ(768pt HQ Sinc) 
              RenderTable["Dither"] - the Dither/Noise shaping-checkboxes: 
                                      &1, dither master mix
                                      &2, noise shaping master mix
                                      &4, dither stems
                                      &8, dither noise shaping 
              RenderTable["RenderString"] - the render-cfg-string, which holds the render-outformat-settings
      
     Returns false in case of an error
   </description>
   <parameters>
     string Bounds_Name - the name of the Bounds-render-preset you want to add; nil, to not add a new Bounds-render-preset
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to add; to not add a new Render-Format-Options-render-preset
     RenderTable RenderTable - the RenderTable, which holds all information for inclusion into the Render-Preset
   </parameters>
   <retvals>
     boolean retval - true, adding was successful; false, adding was unsuccessful
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Documentation</target_document>
   <source_document>ultraschall_functions_engine.lua</source_document>
   <tags>render management, add, render preset, names, format options, bounds, rendertable</tags>
 </US_DocBloc>
 ]]
  if Bounds_Name==nil and Options_and_Format_Name==nil then ultraschall.AddErrorMessage("AddRenderPreset", "RenderTable/Options_and_Format_Name", "can't be both set to nil", -6) return false end
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("AddRenderPreset", "RenderTable", "must be a valid render-table", -1) return false end
  if Bounds_Name~=nil and type(Bounds_Name)~="string" then ultraschall.AddErrorMessage("AddRenderPreset", "Bounds_Name", "must be a string", -2) return false end
  if Options_and_Format_Name~=nil and type(Options_and_Format_Name)~="string" then ultraschall.AddErrorMessage("AddRenderPreset", "Options_and_Format_Name", "must be a string", -3) return false end
  
  local A,B, Source, RenderPattern, ProjectSampleRateFXProcessing, String
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  
  Source=RenderTable["Source"]
  if RenderTable["MultiChannelFiles"]==true then Source=Source+4 end
  if RenderTable["OnlyMonoMedia"]==true then Source=Source+16 end
  if RenderTable["ProjectSampleRateFXProcessing"]==true then ProjectSampleRateFXProcessing=1 else ProjectSampleRateFXProcessing=0 end
  if RenderTable["RenderPattern"]=="" or RenderTable["RenderPattern"]:match("%s")~=nil then
    RenderPattern="\""..RenderTable["RenderPattern"].."\""
  else
    RenderPattern=RenderTable["RenderPattern"]
  end

  if Bounds_Name~=nil and (Bounds_Name:match("%s")~=nil or Bounds_Name=="") then Bounds_Name="\""..Bounds_Name.."\"" end
  if Options_and_Format_Name~=nil and (Options_and_Format_Name:match("%s")~=nil or Options_and_Format_Name=="") then Options_and_Format_Name="\""..Options_and_Format_Name.."\"" end
  
  if Bounds_Name~=nil and ("\n"..A):match("\nRENDERPRESET_OUTPUT "..Bounds_Name)~=nil then ultraschall.AddErrorMessage("AddRenderPreset", "Bounds_Name", "bounds-preset already exists", -4) return false end
  if Options_and_Format_Name~=nil and ("\n"..A):match("\n<RENDERPRESET "..Options_and_Format_Name)~=nil then ultraschall.AddErrorMessage("AddRenderPreset", "Options_and_Format_Name", "renderformat/options-preset already exists", -5) return false end

  -- add Bounds-preset, if given
  if Bounds_Name~=nil then 
    String="\nRENDERPRESET_OUTPUT "..Bounds_Name.." "..RenderTable["Bounds"]..
           " "..RenderTable["Startposition"]..
           " "..RenderTable["Endposition"]..
           " "..Source..
           " ".."0"..
           " "..RenderPattern..
           " "..RenderTable["TailFlag"].."\n"
    A=A..String
  end
  
  -- add Formar-options-preset, if given
  if Options_and_Format_Name~=nil then 
      String="<RENDERPRESET "..Options_and_Format_Name..
             " "..RenderTable["SampleRate"]..
             " "..RenderTable["Channels"]..
             " "..RenderTable["OfflineOnlineRendering"]..
             " "..ProjectSampleRateFXProcessing..
             " "..RenderTable["RenderResample"]..
             " "..RenderTable["Dither"]..
             "\n  "..RenderTable["RenderString"].."\n>"
      A=A..String
  end
    
  
  local AA=ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-render.ini", A)
  if A==-1 then ultraschall.AddErrorMessage("AddRenderPreset", "", "can't access "..reaper.GetResourcePath().."/reaper-render.ini", -7) return false end
  return true
end

--L=ultraschall.GetRenderTable_Project()
--ultraschall.AddRenderPreset(nil, nil, L)


function ultraschall.SetRenderPreset(Bounds_Name, Options_and_Format_Name, RenderTable)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>SetRenderPreset</slug>
   <requires>
     Ultraschall=4.00
     Reaper=5.975
     Lua=5.3
   </requires>
   <functioncall>boolean retval = ultraschall.SetRenderPreset(string Bounds_Name, string Options_and_Format_Name, RenderTable RenderTable)</functioncall>
   <description>
     sets an already existing render-preset in reaper-render.ini. 
     
     This function will check, whether the chosen names aren't given yet in any preset. 
     
     Changed render-presets are updated after (re-)opening in the Render to File-dialog     
     
     Note: You can choose, whether to include only Bounds, only RenderFormatOptions of both. The Bounds and the RenderFormatOptions store different parts of the render-presets.
     
     Bounds_Name stores only:
              RenderTable["Bounds"] - the bounds-dropdownlist, 
                                      0, Custom time range
                                      1, Entire project 
                                      2, Time selection 
                                      3, Project regions
                                      4, Selected Media Items(in combination with Source 32)
                                      5, Selected regions 
              RenderTable["Startposition"] - the startposition of the render
              RenderTable["Endposition"] - the endposition of the render
              RenderTable["Source"]+RenderTable["MultiChannelFiles"]+RenderTable["OnlyMonoMedia"] - the source dropdownlist, includes 
                                      0, Master mix 
                                      1, Master mix + stems
                                      3, Stems (selected tracks)
                                      &4, Multichannel tracks to multichannel files
                                      8, Region render matrix
                                      &16, Tracks with only mono media to mono files
                                      32, Selected media items
              "0"    - unknown, default setting is 0
              RenderTable["RenderPattern"] - the renderpattern, which hold also the wildcards
              RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? 
                                      &1, custom time bounds
                                      &2, entire project
                                      &4, time selection
                                      &8, all project regions
                                      &16, selected media items
                                      &32, selected project regions 
     
     Options_and_Format_Name stores only:
              RenderTable["SampleRate"] - the samplerate, with which to render; 0, use project-settings
              RenderTable["Channels"] - the number of channels for the output-file
              RenderTable["OfflineOnlineRendering"] - the offline/online-dropdownlist 
                                      0, Full-speed Offline
                                      1, 1x Offline
                                      2, Online Render
                                      3, Online Render(Idle)
                                      4, Offline Render(Idle); 
              RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; 1, checked; 0, unchecked 
              RenderTable["RenderResample"] - Resample mode-dropdownlist; 
                                      0, Medium (64pt Sinc)
                                      1, Low (Linear Interpolation)
                                      2, Lowest (Point Sampling)
                                      3, Good (192pt Sinc)
                                      4, Better (348 pt Sinc)
                                      5, Fast (IIR + Linear Interpolation)
                                      6, Fast (IIRx2 + Linear Interpolation)
                                      7, Fast (16pt Sinc)
                                      8, HQ (512 pt)
                                      9, Extreme HQ(768pt HQ Sinc) 
              RenderTable["Dither"] - the Dither/Noise shaping-checkboxes: 
                                      &1, dither master mix
                                      &2, noise shaping master mix
                                      &4, dither stems
                                      &8, dither noise shaping 
              RenderTable["RenderString"] - the render-cfg-string, which holds the render-outformat-settings
      
     Returns false in case of an error
   </description>
   <parameters>
     string Bounds_Name - the name of the Bounds-render-preset you want to add; nil, to not add a new Bounds-render-preset
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to add; to not add a new Render-Format-Options-render-preset
     RenderTable RenderTable - the RenderTable, which holds all information for inclusion into the Render-Preset
   </parameters>
   <retvals>
     boolean retval - true, setting was successful; false, setting was unsuccessful
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Documentation</target_document>
   <source_document>ultraschall_functions_engine.lua</source_document>
   <tags>render management, set, render preset, names, format options, bounds, rendertable</tags>
 </US_DocBloc>
 ]]
  if Bounds_Name==nil and Options_and_Format_Name==nil then ultraschall.AddErrorMessage("SetRenderPreset", "RenderTable/Options_and_Format_Name", "can't be both set to nil", -6) return false end
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("SetRenderPreset", "RenderTable", "must be a valid render-table", -1) return false end
  if Bounds_Name~=nil and type(Bounds_Name)~="string" then ultraschall.AddErrorMessage("SetRenderPreset", "Bounds_Name", "must be a string", -2) return false end
  if Options_and_Format_Name~=nil and type(Options_and_Format_Name)~="string" then ultraschall.AddErrorMessage("SetRenderPreset", "Options_and_Format_Name", "must be a string", -3) return false end
  
  local A,B, Source, RenderPattern, ProjectSampleRateFXProcessing, String, Bounds, RenderFormatOptions
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  
  Source=RenderTable["Source"]
  if RenderTable["MultiChannelFiles"]==true then Source=Source+4 end
  if RenderTable["OnlyMonoMedia"]==true then Source=Source+16 end
  if RenderTable["ProjectSampleRateFXProcessing"]==true then ProjectSampleRateFXProcessing=1 else ProjectSampleRateFXProcessing=0 end
  if RenderTable["RenderPattern"]=="" or RenderTable["RenderPattern"]:match("%s")~=nil then
    RenderPattern="\""..RenderTable["RenderPattern"].."\""
  else
    RenderPattern=RenderTable["RenderPattern"]
  end

  if Bounds_Name~=nil and (Bounds_Name:match("%s")~=nil or Bounds_Name=="") then Bounds_Name="\""..Bounds_Name.."\"" end
  if Options_and_Format_Name~=nil and (Options_and_Format_Name:match("%s")~=nil or Options_and_Format_Name=="") then Options_and_Format_Name="\""..Options_and_Format_Name.."\"" end
  
  if Bounds_Name~=nil and ("\n"..A):match("\nRENDERPRESET_OUTPUT "..Bounds_Name)==nil then ultraschall.AddErrorMessage("SetRenderPreset", "Bounds_Name", "no bounds-preset with that name", -4) return false end
  if Options_and_Format_Name~=nil and ("\n"..A):match("\n<RENDERPRESET "..Options_and_Format_Name)==nil then ultraschall.AddErrorMessage("SetRenderPreset", "Options_and_Format_Name", "no renderformat/options-preset with that name", -5) return false end

  -- set Bounds-preset, if given
  if Bounds_Name~=nil then 
    Bounds=("\n"..A):match("(\nRENDERPRESET_OUTPUT "..Bounds_Name..".-\n)")
    String="\nRENDERPRESET_OUTPUT "..Bounds_Name.." "..RenderTable["Bounds"]..
           " "..RenderTable["Startposition"]..
           " "..RenderTable["Endposition"]..
           " "..Source..
           " ".."0"..
           " "..RenderPattern..
           " "..RenderTable["TailFlag"].."\n"
    A=string.gsub(A, Bounds, String)
  end

  -- set Format-options-preset, if given
  if Options_and_Format_Name~=nil then 
      RenderFormatOptions=A:match("\n<RENDERPRESET "..Options_and_Format_Name..".->")
      String="\n<RENDERPRESET "..Options_and_Format_Name..
             " "..RenderTable["SampleRate"]..
             " "..RenderTable["Channels"]..
             " "..RenderTable["OfflineOnlineRendering"]..
             " "..ProjectSampleRateFXProcessing..
             " "..RenderTable["RenderResample"]..
             " "..RenderTable["Dither"]..
             "\n  "..RenderTable["RenderString"].."\n>"
    A=string.gsub(A, RenderFormatOptions, String)
  end
    
  
  local AA=ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-render.ini", A)
  if A==-1 then ultraschall.AddErrorMessage("SetRenderPreset", "", "can't access "..reaper.GetResourcePath().."/reaper-render.ini", -7) return false end
  return true
  --]]
end

--L=ultraschall.GetRenderTable_Project()
--ultraschall.SetRenderPreset("A04", "A04", L)


function ultraschall.RenderProject_RenderTable(projectfilename_with_path, RenderTable, AddToProj, CloseAfterRender, SilentlyIncrementFilename)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject_RenderTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProject_RenderTable(optional string projectfilename_with_path, optional RenderTable RenderTable, optional boolean AddToProj, optional boolean CloseAfterRender, optional boolean SilentlyIncrementFilename)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Renders a projectfile or the current active project, using the settings from a RenderTable.
            
    Expected RenderTable is of the following structure:
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
            RenderTable["Bounds"] - 0, Custom time range; 1, Entire project; 2, Time selection; 3, Project regions; 4, Selected Media Items(in combination with Source 32); 5, Selected regions
            RenderTable["Channels"] - the number of channels in the rendered file; 1, mono; 2, stereo; higher, the number of channels
            RenderTable["CloseAfterRender"] - true, close rendering to file-dialog after render; false, don't close it
            RenderTable["Dither"] - &1, dither master mix; &2, noise shaping master mix; &4, dither stems; &8, dither noise shaping
            RenderTable["Endposition"] - the endposition of the rendering selection in seconds
            RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 0, Full-speed Offline; 1, 1x Offline; 2, Online Render; 3, Online Render(Idle); 4, Offline Render(Idle)
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
            RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 0, Medium (64pt Sinc); 1, Low (Linear Interpolation); 2, Lowest (Point Sampling); 3, Good (192pt Sinc); 4, Better (348 pt Sinc); 5, Fast (IIR + Linear Interpolation); 6, Fast (IIRx2 + Linear Interpolation); 7, Fast (16pt Sinc); 8, HQ (512 pt); 9, Extreme HQ(768pt HQ Sinc)
            RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-ouput-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"] - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; true, checked; false, unchecked
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; true, checked; false, unchecked
            RenderTable["Source"] - 0, Master mix; 1, Master mix + stems; 3, Stems (selected tracks); 8, Region render matrix; 16, Tracks with only Mono-Media to Mono Files; 32, Selected media items
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? &1, custom time bounds; &2, entire project; &4, time selection; &8, all project regions; &16, selected media items; &32, selected project regions
            RenderTable["TailMS"] - the amount of milliseconds of the tail
            
    Returns -1 in case of an error
  </description>
  <retvals>
    integer count - the number of files that have been rendered
    array MediaItemStateChunkArray - the MediaItemStateChunks of all the rendered files
    array Filearray - filenames with path of all rendered files
  </retvals>
  <parameters>
    optional string projectfilename_with_path - the projectfilename with path of the rpp-file that you want to render; nil, to render the current active project
    optional RenderTable RenderTable - the RenderTable with all render-settings, that you want to apply; nil, use the project's existing settings
    optional boolean AddToProj - true, add the rendered files to the project; nil or false, don't add them; 
                               - will overwrite the settings in the RenderTable; will default to true, if no RenderTable is passed
                               - only has an effect, when rendering the current active project
    optional boolean CloseAfterRender - true or nil, closes rendering to file-dialog after rendering is finished; false, keep it open
                                      - will overwrite the settings in the RenderTable; will default to true, if no RenderTable is passed
    optional boolean SilentlyIncrementFilename - true or nil, silently increment filename, when file already exists; false, ask for overwriting
                                              - will overwrite the settings in the RenderTable; will default to true, if no RenderTable is passed
  </parameters>
  <chapter_context>
    Rendering Projects
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, render, output, file, rendertable</tags>
</US_DocBloc>
]]
  if RenderTable~=nil and ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("RenderProject_RenderTable", "RenderTable", "must be a valid RenderTable", -1) return -1 end
  if AddToProj~=nil and type(AddToProj)~="boolean" then ultraschall.AddErrorMessage("RenderProject_RenderTable", "AddToProj", "must be nil or boolean", -10) return -1 end
  if CloseAfterRender~=nil and type(CloseAfterRender)~="boolean" then ultraschall.AddErrorMessage("RenderProject_RenderTable", "CloseAfterRender", "must be nil or boolean", -11) return -1 end
  if SilentlyIncrementFilename~=nil and type(SilentlyIncrementFilename)~="boolean" then ultraschall.AddErrorMessage("RenderProject_RenderTable", "SilentlyIncrementFilename", "must be nil or boolean", -12) return -1 end

  if RenderTable==nil then norendertable=true end

  local tempfilename, retval, oldcloseafterrender, oldCopyOfProject, aborted, oldSaveOpts, Count, MediaItemArray, MediaItemStateChunkArray, trackstring
  if projectfilename_with_path==nil then
    -- if user wants to render the currently opened file
    -- use current render-settings, if user didn't pass a RenderTable
    if RenderTable==nil then RenderTable=ultraschall.GetRenderTable_Project() end
    
    -- enable adding files to project, as this gives us the filenames of the rendered files
    local oldAddToProj=RenderTable["AddToProj"] 
    if AddToProj==nil then AddToProj=oldAddToProj end
    RenderTable["AddToProj"]=true
    
    -- set the defaults for incrementing filenames and close rendering to file dialog after render, 
    -- if parameters got set to nil:
    local oldcloseafterrender=RenderTable["CloseAfterRender"]
    local oldsilentlyincreasefilename=RenderTable["SilentlyIncrementFilename"]
    if CloseAfterRender~=nil then RenderTable["CloseAfterRender"]=CloseAfterRender end
    if SilentlyIncrementFilename==nil then SilentlyIncrementFilename=true end
    if SilentlyIncrementFilename~=nil then RenderTable["SilentlyIncrementFilename"]=SilentlyIncrementFilename end    
    if CloseAfterRender==nil and norendertable==true then RenderTable["CloseAfterRender"]=true end
    
    -- get the old number of tracks
    local OldTrackNumber=reaper.CountTracks(0)     
    
    -- If RenderPattern is not set, I need to split up the RenderFile into path and filename and set them accordingly,
    -- or Reaper tries to write a file "untitled" into path RenderFile, even if RenderFile shall be the file+path.
    -- If RenderFile is a valid directory instead of a filename and RenderPattern is "", it will render the file untitled.ext into the
    -- path given in RenderFile
    local RenderPattern=RenderTable["RenderPattern"]
    local RenderFile=RenderTable["RenderFile"]
    if RenderPattern=="" and ultraschall.DirectoryExists2(RenderFile)==false then 
      RenderTable["RenderFile"], RenderTable["RenderPattern"] = ultraschall.GetPath(RenderFile) 
    end
    if RenderTable["RenderFile"]==nil then RenderTable["RenderFile"]="" end
    if RenderTable["RenderPattern"]==nil then RenderTable["RenderPattern"]="" end

    
    -- get the current settings as rendertable and apply the RenderTable the user passed to us
    local OldRenderTable=ultraschall.GetRenderTable_Project()
    ultraschall.ApplyRenderTable_Project(RenderTable, true) -- here the bug happens
    ultraschall.ShowLastErrorMessage()
    
    -- change back the entries in RenderTable so the user does not have my temporary changes in it
    RenderTable["RenderPattern"]=RenderPattern
    RenderTable["RenderFile"]=RenderFile
    
    -- let's render:
    reaper.PreventUIRefresh(-1) -- prevent updating the userinterface, as I don't want flickering when rendered files are added and I'll delete them after that

    -- let's change creation of copies of the rendered outfile.rpp-setting,
    oldCopyOfProject = ultraschall.GetRender_SaveCopyOfProject()
    ultraschall.SetRender_SaveCopyOfProject(RenderTable["SaveCopyOfProject"])
    
    -- temporarily prevent creation of bak-files and save project, as otherwise we couldn't close the tab
    oldSaveOpts=reaper.SNM_GetIntConfigVar("saveopts", -111)
    if oldSaveOpts&1==1 then reaper.SNM_SetIntConfigVar("saveopts", oldSaveOpts-1) end
    reaper.Main_OnCommand(41824,0)    -- render using it with the last rendersettings(those, we inserted included)
    reaper.SNM_SetIntConfigVar("saveopts", oldSaveOpts) -- reset old bak-files-behavior    
    
    -- reset old Save Copy of Project to outfile-checkbox setting
    ultraschall.SetRender_SaveCopyOfProject(oldCopyOfProject)
    
    -- if no track has been added, the rendering was aborted by userinteraction or error
    if reaper.CountTracks(0)==OldTrackNumber then aborted=true end
    
    -- restore old rendersettings
    ultraschall.ApplyRenderTable_Project(OldRenderTable, true)
    RenderTable["AddToProj"]=oldAddToProj
    
    -- get all rendered files, that have been added to the track
    if aborted~=true then
      trackstring=ultraschall.CreateTrackString(OldTrackNumber+1, reaper.CountTracks(0))
      Count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(0, reaper.GetProjectLength(), trackstring, false)
    end
    
    -- if user didn't want the renderd files to be added into the project, we delete them again.
    if AddToProj==false and aborted~=true then
      retval = ultraschall.ApplyActionToTrack(trackstring, "_SWS_DELALLITEMS")
      retval = ultraschall.DeleteTracks_TrackString(trackstring)
    end
    reaper.PreventUIRefresh(1) -- reenable refreshing of the user interface 
    
    -- let's get the filenames of the rendered files
    local Filearray={}
    if aborted~=true then
      for i=1, Count do
        --print2(MediaItemStateChunkArray[i]:match("%<SOURCE.-FILE \"(.-)\""))
        Filearray[i]=MediaItemStateChunkArray[i]:match("%<SOURCE.-FILE \"(.-)\"")
      end
    end
    
    -- restore old settings, that I temporarily overwrite in the RenderTable
    RenderTable["CloseAfterRender"]=oldcloseafterrender
    RenderTable["SilentlyIncrementFilename"]=oldsilentlyincreasefilename

    if aborted == true then ultraschall.AddErrorMessage("RenderProject_RenderTable", "", "rendering aborted", -2) return -1 end
    
    -- return, what has been found
    return Count, MediaItemStateChunkArray, Filearray
  else
    -- if user wants to render a projectfile:
    
    -- check parameters
    local retval2, oldSaveOpts
    if type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("RenderProject_RenderTable", "projectfilename_with_path", "must be a string", -3) return -1 end
    if reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("RenderProject_RenderTable", "projectfilename_with_path", "no such file", -4) return -1 end
        
    -- let's create a copy of the projectfile, which we will modify (Never use the original! Never!)
    tempfilename = ultraschall.CreateValidTempFile(projectfilename_with_path, true, "", true)
    if tempfilename==nil then ultraschall.AddErrorMessage("RenderProject_RenderTable", "projectfilename_with_path", "can't create temporary file in projectpath", -5) return -1 end
    retval = ultraschall.MakeCopyOfFile(projectfilename_with_path, tempfilename)
    
    -- use current render-settings from the project, if user didn't pass a RenderTable
    if RenderTable==nil then 
      RenderTable=ultraschall.GetRenderTable_ProjectFile(tempfilename) 
    end

    if SilentlyIncrementFilename~=nil then 
      RenderTable["SilentlyIncrementFilename"]=SilentlyIncrementFilename
    end
    
    if CloseAfterRender~=nil then 
      RenderTable["CloseAfterRender"]=CloseAfterRender
    end
          
    -- set Adding renderd files to project as enabled, as we need that to get the filenames of the rendered files
    RenderTable["AddToProj"]=true
    ultraschall.ApplyRenderTable_ProjectFile(RenderTable, tempfilename, true)
    local curProj=reaper.EnumProjects(-1,"") -- get the current tab, before we start the magic
    
    -- let's start the magic:
    
    -- load the project into a new projecttab
    reaper.Main_OnCommand(40859,0)    -- create new temporary tab
    reaper.Main_openProject(tempfilename) -- load the temporary projectfile
    
    -- manage automatically closing of the render-window and filename-increasing
    local val=reaper.SNM_GetIntConfigVar("renderclosewhendone", -99)
    local oldval=val
    if RenderTable["CloseAfterRender"]==true then 
      if val&1==0 then val=val+1 end
      if val==-99 then val=1 end
    elseif RenderTable["CloseAfterRender"]==false then 
      if val&1==1 then val=val-1 end
      if val==-99 then val=0 end
    end
    
    if RenderTable["SilentlyIncrementFilename"]==true then 
      if val&16==0 then val=val+16 end
      if val==-99 then val=16 end
    elseif RenderTable["SilentlyIncrementFilename"]==false then 
      if val&16==16 then val=val-16 end
      if val==-99 then val=0 end
    end
    reaper.SNM_SetIntConfigVar("renderclosewhendone", val)
    
    -- temporarily disable building peak-caches
    local peakval=reaper.SNM_GetIntConfigVar("peakcachegenmode", -99)
    reaper.SNM_SetIntConfigVar("peakcachegenmode", 0)
    
    local AllTracks=ultraschall.CreateTrackString_AllTracks() -- get number of tracks after rendering and adding of rendered files

    -- let's change creation of copies of the rendered outfile.rpp-setting,
    oldCopyOfProject = ultraschall.GetRender_SaveCopyOfProject()
    ultraschall.SetRender_SaveCopyOfProject(RenderTable["SaveCopyOfProject"])
    
    -- temporarily prevent creation of bak-files and save project, as otherwise we couldn't close the tab
    oldSaveOpts=reaper.SNM_GetIntConfigVar("saveopts", -111)
    if oldSaveOpts&1==1 then reaper.SNM_SetIntConfigVar("saveopts", oldSaveOpts-1) end
    reaper.Main_OnCommand(41824,0)    -- render using it with the last rendersettings(those, we inserted included)
    reaper.Main_SaveProject(0, false) -- save it(no use, but otherwise, Reaper would open a Save-Dialog, that we don't want and need)    
    reaper.SNM_SetIntConfigVar("saveopts", oldSaveOpts) -- reset old bak-files-behavior    
    
    -- reset old Save Copy of Project to outfile-checkbox setting
    ultraschall.SetRender_SaveCopyOfProject(retval)
    
    
    local AllTracks2=ultraschall.CreateTrackString_AllTracks() -- get number of tracks after rendering and adding of rendered files
    if AllTracks==AllTracks2 then aborted=true end
    local retval, Trackstring = ultraschall.OnlyTracksInOneTrackstring(AllTracks, AllTracks2) -- only get the newly added tracks as trackstring
    
    -- get the newly rendered items and their statechunks
    local count, MediaItemArray, MediaItemStateChunkArray
    if Trackstring~="" then 
      count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(0, reaper.GetProjectLength(0), Trackstring, false) -- get the new MediaItems created after adding the rendered files
    else
      count=0
    end
    reaper.Main_OnCommand(40860,0)    -- close the temporary-tab again
    
    -- get the individual filenames of all the rendered files
    local Filearray={}
    for i=1, count do
    
      Filearray[i]=MediaItemStateChunkArray[i]:match("%<SOURCE.-FILE \"(.-)\"")
    end
    
    -- reset old renderclose/overwrite/Peak-cache-settings
    reaper.SNM_SetIntConfigVar("renderclosewhendone", oldval)
    reaper.SNM_SetIntConfigVar("peakcachegenmode", peakval)
    
    --remove the temp-file, return to the old projecttab and we are done.
    os.remove(tempfilename)
    reaper.SelectProjectInstance(curProj)
    if aborted == true then ultraschall.AddErrorMessage("RenderProject_RenderTable", "", "rendering aborted", -2) return -1 end
    
    return count, MediaItemStateChunkArray, Filearray
  end
end

--ultraschall.SetRender_SaveCopyOfProject(true)


--C1=ultraschall.GetRenderTable_ProjectFile("C:\\temp\\1.RPP")
--[[ultraschall.ShowLastErrorMessage()
C1["RenderFile"]="c:\\temp\\"
C1["CloseAfterRender"]=false
C1["SilentlyIncrementFilename"]=true
C1["AddToProj"]=false
A1,A2,A3,A4 = ultraschall.RenderProject_RenderTable("C:\\temp\\1.RPP", C1)
--A1,A2,A3,A4 = ultraschall.RenderProject_RenderTable(nil, C1)
--  reaper.GetSetProjectInfo_String(ReaProject, "RENDER_PATTERN", "", true)
--  C1,C2=reaper.GetSetProjectInfo_String(ReaProject, "RENDER_PATTERN", "", false)
--  reaper.Main_OnCommand(41824,0) 
--]]
--D=ultraschall.GetRenderTable_Project("C:\\temp\\1.RPP")
--C1["CloseAfterRender"]=false
--C1["SilentlyIncrementFilename"]=false

--A1,A2,A3,A4 = ultraschall.RenderProject_RenderTable()

function ultraschall.GetRenderQueuedProjects()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderQueuedProjects</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer Filecount, array Filearray = ultraschall.GetRenderQueuedProjects()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the number and names of files currently in the render-queue
  </description>
  <retvals>
    integer Filecount - the number of project-files in the render-queue
    array Filearray - filenames with path of all queued-projectfiles
  </retvals>
  <chapter_context>
    Rendering Projects
    RenderQueue
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, get, count, files, projects, render, queue, renderqueue</tags>
</US_DocBloc>
]]
  local filecount, files = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/QueuedRenders/")
  for i=filecount, 1, -1 do
    if files[i]:sub(-4,-1):lower()~=".rpp" then table.remove(files,i) filecount=filecount-1 end
  end
  return filecount, files
end

--A, B = ultraschall.GetRenderQueuedProjects()

function ultraschall.AddProjectFileToRenderQueue(projectfilename_with_path)
-- Todo
-- add 
--  QUEUED_RENDER_OUTFILE "C:\defrenderpath\untitled.flac" 65553 {8B34A896-AAE3-4F7F-9A5E-63C19B1C9AE0}
-- to them, being dependend on, whether some render-stems is selected
-- need to have somehow a resolve render-pattern-function

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddProjectFileToRenderQueue</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AddProjectFileToRenderQueue(string projectfilename_with_path)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Adds a projectfile or the current active project to the render-queue
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, adding was successful; false, adding was unsuccessful
  </retvals>
  <parameters>
    string projectfilename_with_path - the projectfile, that you want to add to the render-queue; nil, to add the current active project
  </parameters>
  <chapter_context>
    Rendering Projects
    RenderQueue
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, add, project, render, queue, renderqueue</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil then reaper.Main_OnCommand(41823,0) return true end
  if type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("AddProjectFileToRenderQueue", "projectfilename_with_path", "must be a string", -1) return false end
  if reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("AddProjectFileToRenderQueue", "projectfilename_with_path", "no such projectfile", -2) return false end
  
  
  local path, projfilename = ultraschall.GetPath(projectfilename_with_path)
  local Projectfilename=ultraschall.API_TempPath..projfilename
  local A, B, Count, Individual_values, tempa, tempb, filename, Qfilename
  
  A=ultraschall.ReadFullFile(projectfilename_with_path) 
  B=""
  
  if ultraschall.IsValidProjectStateChunk(A)==false then ultraschall.AddErrorMessage("AddProjectFileToRenderQueue", "projectfilename_with_path", "not a valid projectfile", -3) return false end
  
  Count, Individual_values = ultraschall.CSV2IndividualLinesAsArray(A, "\n")
  
  for i=1, Count do
    if Individual_values[i]:match("^        FILE \"")~=nil then
      filename=Individual_values[i]:match("\"(.-)\"")
      if reaper.file_exists(path..filename)==true then
        tempa, tempb=Individual_values[i]:match("(.-\").-(\".*)")
        Individual_values[i]=tempa..path..filename..tempb
      end
    end
    B=B.."\n"..Individual_values[i]
  end
  
  -- let's create a valid render-queue-filename
  local A, month, day, hour, min, sec
  A=os.date("*t")
  if tostring(A["month"]):len()==1 then month="0"..tostring(A["month"]) else month=tostring(A["month"]) end
  if tostring(A["day"]):len()==1 then day="0"..tostring(A["day"]) else day=tostring(A["day"]) end
  
  if tostring(A["hour"]):len()==1 then hour="0"..tostring(A["hour"]) else hour=tostring(A["hour"]) end
  if tostring(A["min"]):len()==1 then min="0"..tostring(A["min"]) else min=tostring(A["min"]) end
  if tostring(A["sec"]):len()==1 then sec="0"..tostring(A["sec"]) else sec=tostring(A["sec"]) end
  
  Qfilename="qrender_"..tostring(A["year"]):sub(-2,-1)..month..day.."_"..hour..min..sec.."_"..projectfilename_with_path:match(".*[\\/](.*)")

  B=B:match(".-<REAPER_PROJECT.-\n").."  QUEUED_RENDER_ORIGINAL_FILENAME C:\\Render-Queue-Documentation.RPP\n"..B:match(".-<REAPER_PROJECT.-\n(.*)")

  -- write file into render-queue
  if ultraschall.WriteValueToFile(reaper.GetResourcePath().."/QueuedRenders/"..Qfilename, B)==-1 then return false else return true end
end

--A=ultraschall.AddProjectFileToRenderQueue("c:\\Render-Queue-Documentation.RPP")
--ultraschall.AddProjectFileToRenderQueue("c:\\Users\\meo\\Desktop\\trss\\Maerz2019-1\\rec\\rec-edit.RPP")


function ultraschall.RenderProject_RenderQueue(index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject_RenderQueue</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RenderProject_RenderQueue(integer index)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Renders a specific project from the render-queue. 
    
    See [GetRenderQueuedProjects](#GetRenderQueuedProjects) to get the names of the currently existing render-queue-projects, where the filename-order reflects the index needed for this function.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - false, a problem occurred; true, rendering went through; returns true as well, when rendering is aborted!
  </retvals>
  <parameters>
    integer index - the index of the render-queued-project; beginning with 1; -1 to render all projects in the render-queue
  </parameters>
  <chapter_context>
    Rendering Projects
    RenderQueue
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectmanagement, renderqueue, render</tags>
</US_DocBloc>
]]  
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("RenderProject_RenderQueue", "index", "no such queued-project", -1) return false end
  local Filecount, Filearray = ultraschall.GetRenderQueuedProjects()
  if index~=-1 and (index>Filecount or index<1) then ultraschall.AddErrorMessage("RenderProject_RenderQueue", "index", "no such queued-project; index must be an existing queued-project, bigger or equal 1 or -1 for all queued projects", -2) return false end
  if index~=-1 then
    Filecount=Filecount-1
    table.remove(Filearray,index)
    for i=1, Filecount do
      os.rename(Filearray[i], Filearray[i].."p")
    end
  end
  
  reaper.Main_OnCommand(41207,0)
  
  if index~=-1 then
    for i=1, Filecount do
      os.rename(Filearray[i].."p", Filearray[i])
    end
  end
  return true
end

--ultraschall.RenderProject_RenderQueue(2)

function ultraschall.RenderProject(projectfilename_with_path, renderfilename_with_path, startposition, endposition, overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>integer retval, integer renderfilecount, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProject(string projectfilename_with_path, string renderfilename_with_path, number startposition, number endposition, boolean overwrite_without_asking, boolean renderclosewhendone, boolean filenameincrease, optional string rendercfg)</functioncall>
  <description>
    Renders a project, using a specific render-cfg-string.
    To get render-cfg-strings, see functions starting with CreateRenderCFG_, like<a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, etc.
    
    Will use the render-settings currently set in projectfilename_with_path/the currently active project, except bound(set to Custom time range), render file and render-pattern, as they are set by this function!
    
    Returns -1 in case of an error
  </description>
  <retvals>
    integer retval - -1, in case of error; 0, in case of success
    integer renderfilecount - the number of rendered files
    array MediaItemStateChunkArray - the MediaItemStateChunks of all rendered files, with the one in entry 1 being the rendered master-track(when rendering stems+master)
    array Filearray - the filenames of the rendered files, including their paths. The filename in entry 1 is the one of the mastered track(when rendering stems+master)
  </retvals>
  <parameters>
    string projectfilename_with_path - the project to render; nil, for the currently opened project
    string renderfilename_with_path - the filename with path of the output-file. If you give the wrong extension, Reaper will exchange it by the correct one.
                                    - You can use wildcards to some extend in the actual filename(not the path!)
                                    - note: parameter overwrite_without_asking only works, when you give the right extension and use no wildcards, due API-limitations!
    number startposition - the startposition of the render-area in seconds; 
                         - -1, to use the startposition set in the projectfile itself; 
                         - -2, to use the start of the time-selection
    number endposition - the endposition of the render-area in seconds; 
                       - -1, to use the endposition set in the projectfile/current project itself
                       - -2, to use the end of the time-selection
    boolean overwrite_without_asking - true, overwrite an existing renderfile; false, don't overwrite an existing renderfile
                                     - works only, when renderfilename_with_path has the right extension given and when not using wildcards(due API-limitations)!
    boolean renderclosewhendone - true, automatically close the render-window after rendering; false, keep rendering window open after rendering; nil, use current settings
    boolean filenameincrease - true, silently increase filename, if it already exists; false, ask before overwriting an already existing outputfile; nil, use current settings
    string rendercfg         - the rendercfg-string, that contains all render-settings for an output-format
                             - To get render-cfg-strings, see CreateRenderCFG_xxx-functions, like: <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, <a href="#CreateRenderCFG_WAVPACK">CreateRenderCFG_WAVPACK</a>, <a href="#CreateRenderCFG_WebMVideo">CreateRenderCFG_WebMVideo</a>
                             - 
                             - If you want to render the current project, you can use a four-letter-version of the render-string; will use the default settings for that format. Not available with projectfiles!
                             - "evaw" for wave, "ffia" for aiff, " iso" for audio-cd, " pdd" for ddp, "calf" for flac, "l3pm" for mp3, "vggo" for ogg, "SggO" for Opus, "PMFF" for FFMpeg-video, "FVAX" for MP4Video/Audio on Mac, " FIG" for Gif, " FCL" for LCF, "kpvw" for wavepack 
  </parameters>
  <chapter_context>
    Rendering Projects
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, render, output, file</tags>
</US_DocBloc>
]]
  -- preparing variables
  local RenderTable
  local retval, path, filename, count, timesel1_end, timesel1_start, start_sel, end_sel, temp
  
  -- check parameters
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RenderProject", "startposition", "Must be a number in seconds.", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RenderProject", "endposition", "Must be a number in seconds.", -2) return -1 end
  if startposition>=0 and endposition>0 and endposition<=startposition then ultraschall.AddErrorMessage("RenderProject", "endposition", "Must be bigger than startposition.", -3) return -1 end
  if endposition<-2 then ultraschall.AddErrorMessage("RenderProject", "endposition", "Must be bigger than 0 or -1(to retain project-file's endposition).", -4) return -1 end
  if startposition<-2 then ultraschall.AddErrorMessage("RenderProject", "startposition", "Must be bigger than 0 or -1(to retain project-file's startposition).", -5) return -1 end
  
  if projectfilename_with_path~=nil then
    if type(projectfilename_with_path)~="string" or reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("RenderProject", "projectfilename_with_path", "File does not exist.", -6) return -1 end
  end
  if type(renderfilename_with_path)~="string" then ultraschall.AddErrorMessage("RenderProject", "renderfilename_with_path", "Must be a string.", -7) return -1 end  
  if rendercfg==nil or (ultraschall.GetOutputFormat_RenderCfg(rendercfg)==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg)=="Unknown") then ultraschall.AddErrorMessage("RenderProject", "rendercfg", "No valid render_cfg-string.", -9) return -1 end
  if type(overwrite_without_asking)~="boolean" then ultraschall.AddErrorMessage("RenderProject", "overwrite_without_asking", "Must be boolean", -10) return -1 end
  if filenameincrease~=nil and type(filenameincrease)~="boolean" then ultraschall.AddErrorMessage("RenderProject", "filenameincrease", "Must be either nil or boolean", -13) return -1 end
  if renderclosewhendone~=nil and type(renderclosewhendone)~="boolean" then ultraschall.AddErrorMessage("RenderProject", "renderclosewhendone", "Must be either nil or a boolean", -12) return -1 end

  if RenderTable~=nil and ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("RenderProject", "RenderTable", "Must be either nil or a valid RenderTable", -15) return -1 end

  -- split renderfilename into path and filename, as we need this for render-pattern and render-file-entries
  if renderfilename_with_path~=nil then 
    path, filename = ultraschall.GetPath(renderfilename_with_path)
  end
  if path==nil then path="" end
  if filename==nil then filename="" end
  
  if projectfilename_with_path==nil then
  -- if rendering the current active project

    -- get rendercfg from current project, if not already given
    if rendercfg==nil then temp, rendercfg = reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT", "", false) end 
    -- get rendersettings from current project
    RenderTable=ultraschall.GetRenderTable_Project()

    -- set the start and endposition according to settings (-1 for projectlength, -2 for time/loop-selection)
    start_sel, end_sel = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    if startposition==-1 then startposition=0
    elseif startposition==-2 then startposition=start_sel
    end
    if endposition==-1 then endposition=reaper.GetProjectLength(0)
    elseif endposition==-2 then endposition=end_sel
    end
  else
  -- if rendering an rpp-projectfile
    
    -- get rendercfg from projectfile, if not already given
    if rendercfg==nil then ultraschall.GetProject_RenderCFG(projectfilename_with_path) end
    
    -- get rendersettings from projectfile
    RenderTable=ultraschall.GetRenderTable_ProjectFile(projectfilename_with_path)
    
    -- set the start and endposition according to settings (-1 for projectlength, -2 for time/loop-selection)
    timesel1_start, timesel1_end = ultraschall.GetProject_Selection(projectfilename_with_path)
    if startposition==-1 then startposition=0
    elseif startposition==-2 then startposition=start_sel
    end
    if endposition==-1 then endposition=ultraschall.GetProject_Length(projectfilename_with_path)
    elseif endposition==-2 then endposition=end_sel
    end
  end    
  
  -- desired render-range invalid?
  if endposition<=startposition then ultraschall.AddErrorMessage("RenderProject", "startposition or endposition in RPP-Project", "Must be bigger than startposition.", -11) return -1 end
  
  -- set, if the rendering to file-dialog shall be automatically closed, according to user preference or default setting
  if renderclosewhendone==nil then 
    renderclosewhendone=reaper.SNM_GetIntConfigVar("renderclosewhendone", -2222)&1
    if renderclosewhendone==1 then renderclosewhendone=true else renderclosewhendone=false end
  end
  if filenameincrease==nil then 
    filenameincrease=reaper.SNM_GetIntConfigVar("renderclosewhendone", -2222)&16
    if filenameincrease==1 then filenameincrease=true else filenameincrease=false end
  end

  -- alter the rendersetting to the default ones, I need in this function
  -- the rest stays the way it has been set in the project
  RenderTable["Bounds"]=0
  RenderTable["Startposition"]=startposition
  RenderTable["Endposition"]=endposition
  RenderTable["SilentlyIncrementFilename"]=filenameincrease    
  RenderTable["RenderFile"]=path
  RenderTable["RenderPattern"]=filename
  RenderTable["CloseAfterRender"]=renderclosewhendone
  if projectfilename_with_path~=nil and rendercfg~=nil and rendercfg:len()==4 then 
    ultraschall.AddErrorMessage("RenderProject", "rendercfg", "When rendering projectfiles, rendercfg must be a valid Base64-encoded-renderstring!", -17)
    return -1
  end
  RenderTable["RenderString"]=rendercfg
  
--  if ultraschall.GetOutputFormat_RenderCfg(RenderTable["RenderString"])==nil or ultraschall.GetOutputFormat_RenderCfg(RenderTable["RenderString"])=="Unknown" then ultraschall.AddErrorMessage("RenderProject", "", "No valid render_cfg-string.", -16) return -1 end
  
  -- delete renderfile, if already existing and overwrite_without_asking==true
  if overwrite_without_asking==true then
    if renderfilename_with_path~=nil and reaper.file_exists(renderfilename_with_path)==true then
      os.remove(renderfilename_with_path) 
      if reaper.file_exists(renderfilename_with_path)==true then ultraschall.AddErrorMessage("RenderProject", "renderfilename_with_path", "Couldn't delete file. It's probably still in use.", -14) return -1 end
    end        
  end 

  -- render project and return the found files, if any
  local count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(projectfilename_with_path, RenderTable)
  if count==-1 then retval=-1 else retval=0 end
  return retval, count, MediaItemStateChunkArray, Filearray
end

--A,B,C=ultraschall.RenderProject("c:\\Targetfile.flac.RPP", "c:\\temp\\sk-huis.flac", 10, 100, true, true, true)
--A,B,C=ultraschall.RenderProject("c:\\Render-Queue-Documentation - Kopie.RPP", nil, 0, -1, true, true, true)
--A,B,C=ultraschall.RenderProject(nil, nil, -2, -1, true, true, true)

--A=reaper.DeleteTrackMediaItem(reaper.GetTrack(0,1), reaper.GetMediaItem(0,1))
--reaper.UpdateArrange()
  
--AAA=ultraschall.GetRenderTable_Project()

--AAA["Source"]=23

--A,B,C,D=ultraschall.RenderProject("c:\\Render-Queue-Documentation - Kopie.RPP", "c:\\tudelu.txt", 0, 1000, true, true, true, ultraschall.CreateRenderCFG_FLAC(1,1), AAA)
--A,B,C,D=ultraschall.RenderProject(nil, "c:\\HudelDudel.flac", 0, 1000, true, true, true, "calf", AAA)

function ultraschall.RenderProject_RenderCFG(...)
  ultraschall.RenderProject(...)
end


function ultraschall.RenderProject_Regions(projectfilename_with_path, renderfilename_with_path, region, addregionname, overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg, addregionnameseparator)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject_Regions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer retval, integer renderfilecount, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProject_Regions(string projectfilename_with_path, string renderfilename_with_path, integer region, boolean addregionname, boolean overwrite_without_asking, boolean renderclosewhendone, boolean filenameincrease, string rendercfg, optional string addregionnameseparator)</functioncall>
  <description>
    Renders a region of a project, using a specific render-cfg-string.
    To get render-cfg-strings, see <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>
    
    Returns -1 in case of an error
  </description>
  <retvals>
    integer retval - -1, in case of error; 0, in case of success
    integer renderfilecount - the number of rendered files
    array MediaItemStateChunkArray - the MediaItemStateChunks of all rendered files, with the one in entry 1 being the rendered master-track(when rendering stems)
    array Filearray - the filenames of the rendered files, including their paths. The filename in entry 1 is the one of the mastered track(when rendering stems)
  </retvals>
  <parameters>
    string projectfilename_with_path - the project to render; nil, for the currently opened project
    string renderfilename_with_path - the filename of the output-file. 
                                    - You can use wildcards to some extend in the actual filename(not the path!); doesn't support $region yet
                                    - Will be seen as path only, when you set addregionname=true and addregionnameseparator="/"
    integer region - the number of the region in the Projectfile to render
    boolean addregionname - add the name of the region to the renderfilename; only works, when you don't add a file-extension to renderfilename_with_path
    boolean overwrite_without_asking - true, overwrite an existing renderfile; false, don't overwrite an existing renderfile
    boolean renderclosewhendone - true, automatically close the render-window after rendering; false, keep rendering window open after rendering; nil, use current settings
    boolean filenameincrease - true, silently increase filename, if it already exists; false, ask before overwriting an already existing outputfile; nil, use current settings
    string rendercfg         - the rendercfg-string, that contains all render-settings for an output-format
                             - To get render-cfg-strings, see CreateRenderCFG_xxx-functions, like: <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, <a href="#CreateRenderCFG_WAVPACK">CreateRenderCFG_WAVPACK</a>, <a href="#CreateRenderCFG_WebMVideo">CreateRenderCFG_WebMVideo</a>
                             - 
                             - If you want to render the current project, you can use a four-letter-version of the render-string; will use the default settings for that format. Not available with projectfiles!
                             - "evaw" for wave, "ffia" for aiff, " iso" for audio-cd, " pdd" for ddp, "calf" for flac, "l3pm" for mp3, "vggo" for ogg, "SggO" for Opus, "PMFF" for FFMpeg-video, "FVAX" for MP4Video/Audio on Mac, " FIG" for Gif, " FCL" for LCF, "kpvw" for wavepack 
    optional string addregionnameseparator - when addregionname==true, this parameter allows you to set a separator between renderfilename_with_path and regionname. 
                                           - Also allows / or \\ to use renderfilename_with_path as only path as folder, into which the files are stored having the regionnames only.
                                           - Default is an empty string.
  </parameters>
  <chapter_context>
    Rendering Projects
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, render, output, file, region</tags>
</US_DocBloc>
]]
  local retval
  local curProj=reaper.EnumProjects(-1,"")
  if math.type(region)~="integer" then ultraschall.AddErrorMessage("RenderProject_Regions", "region", "Must be an integer.", -1) return -1 end
  if region<1 then ultraschall.AddErrorMessage("RenderProject_Regions", "region", "Must be 1 or higher", -8) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("RenderProject_Regions", "projectfilename_with_path", "File does not exist.", -3) return -1 end
  if type(renderfilename_with_path)~="string" then ultraschall.AddErrorMessage("RenderProject_Regions", "renderfilename_with_path", "Must be a string.", -4) return -1 end  
  if rendercfg==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg)==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg)=="Unknown" then ultraschall.AddErrorMessage("RenderProject_Regions", "rendercfg", "No valid render_cfg-string.", -5) return -1 end
  if type(overwrite_without_asking)~="boolean" then ultraschall.AddErrorMessage("RenderProject_Regions", "overwrite_without_asking", "Must be boolean", -6) return -1 end
  if addregionnameseparator~=nil and type(addregionnameseparator)~="string" then ultraschall.AddErrorMessage("RenderProject_Regions", "addregionnameseparator", "Must be a string or nil", -9) return -1 end

  local countmarkers, nummarkers, numregions, markertable, markertable_temp, countregions
  markertable={}
  if projectfilename_with_path~=nil then 
    countmarkers, nummarkers, numregions, markertable = ultraschall.GetProject_MarkersAndRegions(projectfilename_with_path)
  else
    countmarkers, countregions = ultraschall.CountMarkersAndRegions()
    numregions, markertable_temp = ultraschall.GetAllRegions()

    for index=1, numregions do
      markertable[index]={}
      markertable[index][1]=true
      markertable[index][2]=markertable_temp[index][0]
      markertable[index][3]=markertable_temp[index][1]
      markertable[index][4]=markertable_temp[index][2]
      markertable[index][5]=markertable_temp[index][4]
      markertable[index][6]=markertable_temp[index][5]
    end    
  end
  if region>numregions then ultraschall.AddErrorMessage("RenderProject_Regions", "region", "No such region in the project.", -7) return -1 end
  local regioncount=0
  
  for i=1, countmarkers do
    if markertable[i][1]==true then 
      regioncount=regioncount+1
      if regioncount==region then region=i break end
    end
  end
  
  --print2("Häh?", renderfilename_with_path)

  if addregionname==true then 
    if addregionnameseparator==nil then addregionnameseparator="" end
    renderfilename_with_path=renderfilename_with_path..addregionnameseparator..markertable[region][4]
--    render_filename_with_path2=renderfilename_with_path:match("(.*)%.")
--    render_filename_with_path3=renderfilename_with_path:match("(.*)%.")
--    if render_filename_with_path2==nil then
--      render_filename_with_path2=renderfilename_with_path.."O"
--      render_filename_with_path2=markertable[region][4].."O"
--    else
--      render_filename_with_path2=render_filename_with_path2..markertable[region][4]..render_filename_with_path2
--    end
  -- old buggy code. In here only for future reference, if my new code(the lines after if addregionname==true then) introduced new bugs, 
  -- rather than only fixing them
--      print(region, markertable[region], projectfilename_with_path)
--[[
      renderfilename_with_path2=
          renderfilename_with_path:match("(.*)%.")..
          markertable[region][4]..
          renderfilename_with_path:match(".*(%..*)")

  --]]
  --[[
    if renderfilename_with_path==nil then 
      renderfilename_with_path=renderfilename_with_path..markertable[region][4]
    else
      renderfilename_with_path=renderfilename_with_path2
      print2(renderfilename_with_path, "Ach", renderfilename_with_path2, "Ach", renderfilename_with_path3)
    end
    --]]
  end
--      print2(renderfilename_with_path, "Ach")  

  return ultraschall.RenderProject(projectfilename_with_path, renderfilename_with_path, tonumber(markertable[region][2]), tonumber(markertable[region][3]), overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg, RenderTable)
end

function ultraschall.RenderProjectRegions_RenderCFG(...)
  ultraschall.RenderProject_Regions(...)
end

--ultraschall.RenderProject_Regions("c:\\aa.rpp", "c:\\tudelu$user.flac", 1, true, true, renderclosewhendone, filenameincrease, ultraschall.CreateRenderCFG_FLAC(1,1))

--B=ultraschall.GetOutputFormat_RenderCfg("calf", A)

--K=ultraschall.ReadFullFile("c:\\pitchshifter.rpp")
--A1,K2=ultraschall.SetProject_DefPitchMode("c:\\pitchshifter.rpp", 7262,9,K)
--A,B=ultraschall.GetProject_DefPitchMode(nil, K2)

--print2(K2)


function ultraschall.AddSelectedItemsToRenderQueue(render_items_individually, render_items_through_master, RenderTable)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddSelectedItemsToRenderQueue</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer num_queued_projects = ultraschall.AddSelectedItemsToRenderQueue(optional boolean render_items_individually, optional boolean render_items_through_master, optional RenderTable RenderTables)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Adds the selected MediaItems to the render-queue.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, adding was successful; false, adding was unsuccessful
    integer num_queued_projects - the number of newly created projects in the render-queue
  </retvals>
  <parameters>
    optional boolean render_items_individually - false or nil, render all selected MediaItems in one render-queued-project; true, render all selected MediaItems individually as separate Queued-projects
    optional boolean render_items_through_master - false or nil, just render the MediaItems; true, render the MediaItems through the Master-channel
    optional RenderTable RenderTables - a RenderTable to apply for the renders in the render-queue
  </parameters>
  <chapter_context>
    Rendering Projects
    RenderQueue
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, add, mediaitem, item, items, selected, render, queue, renderqueue</tags>
</US_DocBloc>
]]
  if reaper.CountSelectedMediaItems(0)<1 then ultraschall.AddErrorMessage("AddSelectedItemsToRenderQueue", "", "no MediaItem selected", -1) return false end
  if RenderTable==nil then
    RenderTable = ultraschall.GetRenderTable_Project()
  else
    if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("AddSelectedItemsToRenderQueue", "RenderTable", "no valid Rendertable", -2) return false end
  end
  local RenderTable_org = ultraschall.GetRenderTable_Project()
  
  if render_items_through_master==true then
    RenderTable["Source"]=64
  else
    RenderTable["Source"]=32
  end
  RenderTable["Bounds"]=4
  RenderTable["RenderFile"]="c:\\temp\\"
  local retval = ultraschall.ApplyRenderTable_Project(RenderTable, true)
  
  if render_items_individually~=true then
    reaper.Main_OnCommand(41823,0)
    count=1
  else
    count, MediaItemArray = ultraschall.GetAllSelectedMediaItems()
    reaper.SelectAllMediaItems(0, false)
    for i=1, count do
      reaper.SetMediaItemSelected(MediaItemArray[i], true)
      reaper.Main_OnCommand(41823,0)
      reaper.SetMediaItemSelected(MediaItemArray[i], false)
    end
    ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray)
  end
  
  
  retval = ultraschall.ApplyRenderTable_Project(RenderTable_org, true)
  return true, count
end

--A,AA=ultraschall.AddSelectedItemsToRenderQueue(false, false)
--ultraschall.AddProjectFileToRenderQueue("c:\\Users\\meo\\Desktop\\trss\\Maerz2019-1\\rec\\rec-edit.RPP")


--RenderTable = ultraschall.GetRenderTable_Project()

function ultraschall.CreateRenderCFG_MP3MaxQuality()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MP3MaxQuality</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MP3MaxQuality(optional boolean write_replay_gain)</functioncall>
  <description>
    Creates the render-cfg-string for the MP3-format with highest quality-settings. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
  </description>
  <retvals>
    string render_cfg_string - the renderstring for MP3 with maximum quality
  </retvals>
  <parameters>
    optional boolean write_replay_gain - the "Write ReplayGain-tag"-checkbox; true, checked; false, unchecked; default is unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, mp3 high quality, mp3</tags>
</US_DocBloc>
]]
  if write_replay_gain==true then return "bDNwbUABAAAAAAQACgAAAP////8EAAAAQAEAAAAAAAA=" end
  return "bDNwbUABAAAAAAAACgAAAP////8EAAAAQAEAAAAAAAA="
end


function ultraschall.CreateRenderCFG_MP3VBR(vbr_quality, quality, no_joint_stereo, write_replay_gain)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MP3VBR</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MP3VBR(integer vbr_quality, integer quality, optional boolean no_joint_stereo, optional boolean write_replay_gain)</functioncall>
  <description>
    Creates the render-cfg-string for the MP3-format with variable bitrate. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected MP3-VBR-settings
  </retvals>
  <parameters>
    integer vbr_quality - the variable-bitrate quality; 1(for 10%) to 10(for 100%)
    integer quality - the encoding speed for the mp3
                           - 0, Maximum
                           - 1, Better
                           - 2, Normal
                           - 3, FastEncode
                           - 4, FasterEncode
                           - 5, FastestEncode
    optional boolean no_joint_stereo - the "Do not allow joint stereo"-checkbox; true, checked; false, unchecked; default is unchecked
    optional boolean write_replay_gain - the "Write ReplayGain-tag"-checkbox; true, checked; false, unchecked; default is unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, mp3 vbr, mp3</tags>
</US_DocBloc>
]]
  if math.type(vbr_quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP3VBR", "vbr_quality", "Must be an integer.", -1) return nil end
  if math.type(quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP3VBR", "quality", "Must be an integer.", -2) return nil end
  if vbr_quality<1 or vbr_quality>10 then ultraschall.AddErrorMessage("CreateRenderCFG_MP3VBR", "vbr_quality", "Must be between 1 and 10.", -3) return nil end
  if quality<0 or quality>5 then ultraschall.AddErrorMessage("CreateRenderCFG_MP3VBR", "quality", "Must be between 0 and 5.", -3) return nil end
  
  local RenderString="bDNwbSAAAAAAAAAAAAAAAAAAAAAJAAAAQAEAAAAAAAA="  
  local Cecoded_string = ultraschall.Base64_Decoder(RenderString)
  
  local Vbr_Quality={9,8,7,6,5,4,3,2,1,0}
  vbr_quality = ultraschall.ConvertIntegerIntoString2(2, Vbr_Quality[vbr_quality])
  
  local EncQuality={0,2,3,5,7,9}
  quality=ultraschall.ConvertIntegerIntoString2(1, EncQuality[quality+1])
  
  local Replaced_string=Cecoded_string
  Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, vbr_quality, 20, 2)
--  Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, vbr_quality, 4, 2)
  Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, quality, 12, 1)
  
  if no_joint_stereo==true then 
    Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, string.char(232), 8, 1)
    Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, string.char(3), 9, 1)
  end
  
  if write_replay_gain==true then 
    Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, string.char(4), 10, 1)
  end
  
  return ultraschall.Base64_Encoder(Replaced_string)
end

--A=ultraschall.CreateRenderCFG_MP3VBR(1, 0)


function ultraschall.CreateRenderCFG_MP3ABR(bitrate, quality, no_joint_stereo, write_replay_gain)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MP3ABR</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MP3ABR(integer bitrate, integer quality, optional boolean no_joint_stereo, optional boolean write_replay_gain)</functioncall>
  <description>
    Creates the render-cfg-string for the MP3-format with average bitrate. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected MP3-ABR-settings
  </retvals>
  <parameters>
    integer bitrate - the encoding quality for the mp3
                    - 0, 8 kbps
                    - 1, 16 kbps
                    - 2, 24 kbps
                    - 3, 32 kbps
                    - 4, 40 kbps
                    - 5, 48 kbps
                    - 6, 56 kbps
                    - 7, 64 kbps
                    - 8, 80 kbps
                    - 9, 96 kbps
                    - 10, 112 kbps
                    - 11, 128 kbps
                    - 12, 160 kbps
                    - 13, 192 kbps
                    - 14, 224 kbps
                    - 15, 256 kbps
                    - 16, 320 kbps
    integer quality - the encoding speed for the mp3
                           - 0, Maximum
                           - 1, Better
                           - 2, Normal
                           - 3, FastEncode
                           - 4, FasterEncode
                           - 5, FastestEncode
    optional boolean no_joint_stereo - the "Do not allow joint stereo"-checkbox; true, checked; false, unchecked; default is unchecked
    optional boolean write_replay_gain - the "Write ReplayGain-tag"-checkbox; true, checked; false, unchecked; default is unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, mp3 abr, mp3</tags>
</US_DocBloc>
]]
  if math.type(bitrate)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP3ABR", "bitrate", "Must be an integer.", -1) return nil end
  if math.type(quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP3ABR", "quality", "Must be an integer.", -2) return nil end
  if bitrate<0 or bitrate>16 then ultraschall.AddErrorMessage("CreateRenderCFG_MP3ABR", "bitrate", "Must be between 1 and 16.", -3) return nil end
  if quality<0 or quality>5 then ultraschall.AddErrorMessage("CreateRenderCFG_MP3ABR", "quality", "Must be between 0 and 5.", -3) return nil end
  
  local RenderString="bDNwbSAAAAAAAAAAAAAAAAQAAAAEAAAAQAEAAEAAAAA="  
  local Cecoded_string = ultraschall.Base64_Decoder(RenderString)
  
  local Bitrates={8,16,24,32,40,48,56,64,80,96,112,128,160,192,224,256,320}  
  bitrate = ultraschall.ConvertIntegerIntoString2(2, Bitrates[bitrate+1])
  
  local EncQuality={0,2,3,5,7,9}
  quality=ultraschall.ConvertIntegerIntoString2(1, EncQuality[quality+1])
  
  local Replaced_string=Cecoded_string
  Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, bitrate, 28, 2)
--  Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, bitrate, 4, 2)
  Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, quality, 12, 1)
  
  if no_joint_stereo==true then 
    Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, string.char(232), 8, 1)
    Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, string.char(3), 9, 1)
  end
  
  if write_replay_gain==true then 
    Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, string.char(4), 10, 1)
  end
  
  return ultraschall.Base64_Encoder(Replaced_string)  
end

--A=ultraschall.CreateRenderCFG_MP3ABR(1, 0)

function ultraschall.CreateRenderCFG_MP3CBR(bitrate, quality, no_joint_stereo, write_replay_gain)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MP3CBR</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MP3CBR(integer bitrate, integer quality, optional boolean no_joint_stereo, optional boolean write_replay_gain)</functioncall>
  <description>
    Creates the render-cfg-string for the MP3-format with constant bitrate. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected MP3-CBR-settings
  </retvals>
  <parameters>
    integer bitrate - the encoding quality for the mp3
                    - 0, 8 kbps
                    - 1, 16 kbps
                    - 2, 24 kbps
                    - 3, 32 kbps
                    - 4, 40 kbps
                    - 5, 48 kbps
                    - 6, 56 kbps
                    - 7, 64 kbps
                    - 8, 80 kbps
                    - 9, 96 kbps
                    - 10, 112 kbps
                    - 11, 128 kbps
                    - 12, 160 kbps
                    - 13, 192 kbps
                    - 14, 224 kbps
                    - 15, 256 kbps
                    - 16, 320 kbps
    integer quality - the encoding speed for the mp3
                           - 0, Maximum
                           - 1, Better
                           - 2, Normal
                           - 3, FastEncode
                           - 4, FasterEncode
                           - 5, FastestEncode
    optional boolean no_joint_stereo - the "Do not allow joint stereo"-checkbox; true, checked; false, unchecked; default is unchecked
    optional boolean write_replay_gain - the "Write ReplayGain-tag"-checkbox; true, checked; false, unchecked; default is unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, mp3 cbr, mp3</tags>
</US_DocBloc>
]]
  if math.type(bitrate)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP3CBR", "bitrate", "Must be an integer.", -1) return nil end
  if math.type(quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MP3CBR", "quality", "Must be an integer.", -2) return nil end
  if bitrate<0 or bitrate>16 then ultraschall.AddErrorMessage("CreateRenderCFG_MP3CBR", "bitrate", "Must be between 0 and 16.", -3) return nil end
  if quality<0 or quality>5 then ultraschall.AddErrorMessage("CreateRenderCFG_MP3CBR", "quality", "Must be between 0 and 4.", -3) return nil end

  local RenderString="bDNwbQgAAAAAAAAAAAAAAP////8EAAAACAAAAAAAAAA="  
  local Cecoded_string = ultraschall.Base64_Decoder(RenderString)
  
  local Bitrates={8,16,24,32,40,48,56,64,80,96,112,128,160,192,224,256,320}  
  bitrate = ultraschall.ConvertIntegerIntoString2(2, Bitrates[bitrate+1])
  
  local EncQuality={0,2,3,5,7,9}
  quality=ultraschall.ConvertIntegerIntoString2(1, EncQuality[quality+1])

  local Replaced_string=Cecoded_string
  Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, bitrate, 24, 2)
  Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, bitrate, 4, 2)
  Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, quality, 12, 1)

  if no_joint_stereo==true then 
    Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, string.char(232), 8, 1)
    Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, string.char(3), 9, 1)
  end

  if write_replay_gain==true then 
    Replaced_string = ultraschall.ReplacePartOfString(Replaced_string, string.char(4), 10, 1)
  end
  
  return ultraschall.Base64_Encoder(Replaced_string)  
end
--A=ultraschall.CreateRenderCFG_MP3CBR(1, 1)




function ultraschall.CreateRenderCFG_WAV(BitDepth, LargeFiles, BWFChunk, IncludeMarkers, EmbedProjectTempo)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_WAV</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_WAV(integer BitDepth, integer LargeFiles, integer BWFChunk, integer IncludeMarkers, boolean EmbedProjectTempo)</functioncall>
  <description>
    Creates the render-cfg-string for the WAV-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected WAV-settings
  </retvals>
  <parameters>
    integer BitDepth - the bitdepth of the WAV-file
                     - 0, 8 Bit PCM
                     - 1, 16 Bit PCM
                     - 2, 24 Bit PCM
                     - 3, 32 Bit FP
                     - 4, 64 Bit FP
                     - 5, 4 Bit IMA ADPCM
                     - 6, 2 Bit cADPCM
    integer LargeFiles - how shall Reaper treat large WAV-files
                       - 0, Auto WAV/Wave64
                       - 1, Auto Wav/RF64
                       - 2, Force WAV
                       - 3, Force Wave64
                       - 4, Force RF64
    integer BWFChunk - Write BWF ('bext') chunk and Include project filename in BWF data - checkboxes
                     - 0, unchecked - unchecked
                     - 1, checked - unchecked
                     - 2, unchecked - checked
                     - 3, checked - checked
    integer IncludeMarkers - The include markerlist-dropdownlist
                           - 0, Do not include markers and regions
                           - 1, Markers + regions
                           - 2, Markers + regions starting with #
                           - 3, Markers only
                           - 4, Markers starting with # only
                           - 5, Regions only
                           - 6, Regions starting with # only
    boolean EmbedProjectTempo - Embed project tempo (use with care)-checkbox; true, checked; false, unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, wav</tags>
</US_DocBloc>
]]
  if math.type(BitDepth)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "BitDepth", "Must be an integer.", -1) return nil end
  if math.type(LargeFiles)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "LargeFiles", "Must be an integer.", -2) return nil end
  if math.type(BWFChunk)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "BWFChunk", "Must be an integer.", -3) return nil end
  if math.type(IncludeMarkers)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "IncludeMarkers", "Must be an integer.", -4) return nil end
  if type(EmbedProjectTempo)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "EmbedProjectTempo", "Must be a boolean.", -5) return nil end
  
  if BitDepth<0 or BitDepth>6 then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "Bitdepth", "Must be between 0 and 6.", -6) return nil end
  if LargeFiles<0 or LargeFiles>4 then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "LargeFiles", "Must be between 0 and 4.", -7) return nil end
  if BWFChunk<0 or BWFChunk>3 then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "BWFChunk", "Must be between 0 and 3.", -8) return nil end
  if IncludeMarkers<0 or IncludeMarkers>6 then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "IncludeMarkers", "Must be between 0 and 6.", -9) return nil end

  -- Header
  local WavHeader="ZXZhd"
  local A0, A, B, C
  
  -- Bitdepth
  if BitDepth==0 then BitDepth="w" A0="g"     -- 8 Bit PCM
  elseif BitDepth==1 then BitDepth="x" A0="A" -- 16 Bit PCM
  elseif BitDepth==2 then BitDepth="x" A0="g" -- 24 Bit PCM
  elseif BitDepth==3 then BitDepth="y" A0="A" -- 32 Bit FP
  elseif BitDepth==4 then BitDepth="0" A0="A" -- 64 Bit FP
  elseif BitDepth==5 then BitDepth="w" A0="Q" -- 4 Bit IMA ADPCM
  elseif BitDepth==6 then BitDepth="w" A0="I" -- 2 Bit cADPCM
  else return nil 
  end
  
  -- Large Files  
  if LargeFiles==0 then A="B" B="A" C="A"     -- Auto WAV/Wave64
  elseif LargeFiles==1 then A="B" B="A" C="Q" -- Auto Wav/RF64
  elseif LargeFiles==2 then A="D" B="A" C="A" -- Force WAV
  elseif LargeFiles==3 then A="B" B="A" C="g" -- Force Wave64
  elseif LargeFiles==4 then A="B" B="A" C="w" -- Force RF64
  else return nil
  end
  
  -- Write BWF ('bext') chunk and Include project filename in BWF data - checkboxes
  if BWFChunk==0 then        -- unchecked unchecked
  elseif BWFChunk==1 then A=ultraschall.AddIntToChar(A, -1)   -- checked unchecked
  elseif BWFChunk==2 then A=ultraschall.AddIntToChar(A, 4)   -- unchecked checked
  elseif BWFChunk==3 then A=ultraschall.AddIntToChar(A, -1+4)   -- checked checked
  end
  
  -- The include markerlist-dropdownlist
  if IncludeMarkers==0 then                                       -- Do not include markers or regions
  elseif IncludeMarkers==1 then A=ultraschall.AddIntToChar(A, 8)    -- Markers + regions
  elseif IncludeMarkers==2 then A=ultraschall.AddIntToChar(A, 30)   -- Markers + regions starting with #
  elseif IncludeMarkers==3 then A0=ultraschall.AddIntToChar(A0, 1) A=ultraschall.AddIntToChar(A, 8) -- Markers only 
  elseif IncludeMarkers==4 then A0=ultraschall.AddIntToChar(A0, 1) A=ultraschall.AddIntToChar(A, 30) -- Markers starting with # only 
  elseif IncludeMarkers==5 then A0=ultraschall.AddIntToChar(A0, 2) A=ultraschall.AddIntToChar(A, 8) -- Regions only 
  elseif IncludeMarkers==6 then A0=ultraschall.AddIntToChar(A0, 2) A=ultraschall.AddIntToChar(A, 30) -- Regions starting with # only 
  end  
  
  -- The Embed project tempo (use with care) - checkbox
  -- Depending on the chosen setting in IncludeMarkers, you must either add 38 or subtract 43 from value A!
  -- This is for all options that have "starting with #" in them.
  -- Yes, it's confusing....
  if EmbedProjectTempo==true and IncludeMarkers<2 then A=ultraschall.AddIntToChar(A, 38)
  elseif EmbedProjectTempo==true and IncludeMarkers==2 then A=ultraschall.AddIntToChar(A, -43) 
  elseif EmbedProjectTempo==true and IncludeMarkers==3 then A=ultraschall.AddIntToChar(A, 38)
  elseif EmbedProjectTempo==true and IncludeMarkers==4 then A=ultraschall.AddIntToChar(A, -43)
  elseif EmbedProjectTempo==true and IncludeMarkers==5 then A=ultraschall.AddIntToChar(A, 38)
  elseif EmbedProjectTempo==true and IncludeMarkers==6 then A=ultraschall.AddIntToChar(A, -43)
  end
  
  local WavEnder="=="
  return WavHeader..BitDepth..A0..A..B..C..WavEnder  
end


function ultraschall.GetLastUsedRenderPatterns()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastUsedRenderPatterns</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>array last_render_patterns = ultraschall.GetLastUsedRenderPatterns()</functioncall>
  <description>
    returns the last 12 used render-patterns, that have been used for rendering by any project in Reaper.
  </description>
  <retvals>
    array last_render_patterns - a table, which holds the last 12 used render-patterns, used by any project in Reaper
  </retvals>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render management, get, last, used, renderpattern</tags>
</US_DocBloc>
]]
  local Table={}
  local temp
  for i=0, 11 do
    temp, Table[i]=reaper.BR_Win32_GetPrivateProfileString("REAPER", "render_pattern_"..i, "", reaper.get_ini_file())
  end
  return Table
end

--A=ultraschall.GetLastUsedRenderPatterns()

function ultraschall.GetLastRenderPaths()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastRenderPaths</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>array last_render_paths = ultraschall.GetLastRenderPaths()</functioncall>
  <description>
    returns the last 20 used render-output-paths, that have been used for rendering by any project in Reaper.
  </description>
  <retvals>
    array last_render_paths - a table, which holds the last 20 used render-output-paths, used by any project in Reaper
  </retvals>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render management, get, last, used, renderoutput, path</tags>
</US_DocBloc>
]]
  local Table={}
  local temp
  for i=1, 20 do
    if i==1 then a="" else a=i end
    temp, Table[i]=reaper.BR_Win32_GetPrivateProfileString("REAPER", "lastrenderpath"..a, "", reaper.get_ini_file())
  end
  return Table
end

--A,B=ultraschall.GetLastRenderPaths()

function ultraschall.IsReaperRendering()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsReaperRendering</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional number render_position, optional number render_projectlength, optional ReaProject proj, optional boolean queue_render = ultraschall.IsReaperRendering()</functioncall>
  <description>
    Returns, if Reaper is currently rendering and the rendering position and projectlength of the rendered project
  </description>
  <retvals>
    boolean retval - true, Reaper is rendering; false, Reaper does not render
    optional number render_position - the current rendering-position of the rendering project
    optional number render_projectlength - the length of the currently rendering project
    optional ReaProject proj - the project currently rendering
    optional boolean queue_render - true, if a project from the queued-folder is currently being rendered; false, if not; a hint if queued-rendering is currently active
  </retvals>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>rendering, get, current, renderstate, queued</tags>
</US_DocBloc>
]]
  local A,B=reaper.EnumProjects(0x40000000,"")  
  if A~=nil then 
    if B:match("^"..reaper.GetResourcePath()..ultraschall.Separator.."QueuedRenders"..ultraschall.Separator.."qrender_%d%d%d%d%d%d_%d%d%d%d%d%d")~=nil then queue=true else queue=false end
    return true, reaper.GetPlayPositionEx(A), reaper.GetProjectLength(A), A, queue
  else return false 
  end
end

function ultraschall.CreateRenderCFG_AIFF(bits)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_AIFF</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_AIFF(integer bits)</functioncall>
  <description>
    Returns the render-cfg-string for the AIFF-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected AIFF-settings
  </retvals>
  <parameters>
    integer bits - the bitdepth of the aiff-file; 8, 16, 24 and 32 are supported
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, aiff</tags>
</US_DocBloc>
]]
  if math.type(bits)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AIFF", "bits", "must be an integer", -1) return nil end
  local renderstring="ZmZpY..AAA=="
  if bits==8 then renderstring=string.gsub(renderstring, "%.%.", "Qg")
  elseif bits==16 then renderstring=string.gsub(renderstring, "%.%.", "RA")
  elseif bits==24 then renderstring=string.gsub(renderstring, "%.%.", "Rg")
  elseif bits==32 then renderstring=string.gsub(renderstring, "%.%.", "SA")
  else ultraschall.AddErrorMessage("CreateRenderCFG_AIFF", "bits", "only 8, 16, 24 and 32 are supported by AIFF", -2) return nil
  end
  return renderstring
end


function ultraschall.CreateRenderCFG_AudioCD(trackmode, only_markers_starting_with_hash, leadin_silence_tracks, leadin_silence_disc, burncd_image_after_render)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_AudioCD</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_AudioCD(integer trackmode, boolean only_markers_starting_with_hash, integer leadin_silence_tracks, integer leadin_silence_disc, boolean burncd_image_after_render)</functioncall>
  <description>
    Returns the render-cfg-string for the AudioCD-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    You can also check, whether to burn the created cd-image after rendering.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected AudioCD-image-settings
  </retvals>
  <parameters>
    integer trackmode - Track mode-dropdownlist: 1, Markers define new track; 2, Regions define tracks (other areas ignored); 3, One Track
    boolean only_markers_starting_with_hash - Only use markers starting with #-checkbox; true, checked; false, unchecked
    integer leadin_silence_tracks - Lead-in silence for tracks-inputbox, in milliseconds
    integer leadin_silence_disc - Extra lead-in silence for disc-inputbox, in milliseconds
    boolean burncd_image_after_render - Burn CD image after render-checkbox; true, checked; false, unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, audiocd, cd, image, burn cd</tags>
</US_DocBloc>
]]
  if math.type(trackmode)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "trackmode", "Must be an integer between 1 and 3!", -2) return nil end
  if type(only_markers_starting_with_hash)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "only_markers_starting_with_hash", "Must be a boolean!", -3) return nil end
  if math.type(leadin_silence_tracks)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "leadin_silence_tracks", "Must be an integer!", -4) return nil end
  if math.type(leadin_silence_disc)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "leadin_silence_disc", "Must be an integer!", -5) return nil end
  if type(burncd_image_after_render)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "burncd_image_after_render", "Must be a boolean!", -6) return nil end
  
  if trackmode<1 or trackmode>3 then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "trackmode", "Must be an integer between 1 and 3!", -7) return nil end
  if leadin_silence_tracks<0 or leadin_silence_tracks>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "leadin_silence_tracks", "Must be bigger or equal 0.", -8) return nil end
  if leadin_silence_disc<0 or leadin_silence_disc>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "leadin_silence_disc", "Must be bigger or equal 0", -9) return nil end

  leadin_silence_tracks = ultraschall.ConvertIntegerIntoString2(4, leadin_silence_tracks)
  leadin_silence_disc = ultraschall.ConvertIntegerIntoString2(4, leadin_silence_disc)
  if burncd_image_after_render==true then burncd_image_after_render=1 else burncd_image_after_render=0 end
  if only_markers_starting_with_hash==true then only_markers_starting_with_hash=1 else only_markers_starting_with_hash=0 end
  
  local RenderString=" osi"..leadin_silence_disc..leadin_silence_tracks..string.char(burncd_image_after_render).."\0\0\0"..string.char(trackmode-1).."\0\0\0"..string.char(only_markers_starting_with_hash).."\0\0\0\0"
  
  return ultraschall.Base64_Encoder(RenderString)
end

--A=ultraschall.CreateRenderCFG_AudioCD(1,false,100000,100000,false)
--reaper.CF_SetClipboard(A)

--B="IG9zaaCGAQCghgEAAAAAAAAAAAAAAAAA"