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

function ultraschall.GetRenderCFG_Settings_FLAC(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_FLAC</slug>
    <requires>
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer encoding_depth, integer compression = ultraschall.GetRenderCFG_Settings_FLAC(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for flac.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer encoding_depth - the encoding-depth of the flac in bits(16 to 24)
      integer compression - the data-compression speed from fastest and worst efficiency(0) to slowest but best efficiency(8); default is 5
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the flac-settings; 
                        - nil, get the current new-project-default render-settings for flac
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, flac, encoding depth, compression</tags>
  </US_DocBloc>
  ]]
  if rendercfg~=nil and type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_FLAC", "rendercfg", "must be a string or nil", -1) return -1 end
  if rendercfg==nil then
    local retval
    retval, rendercfg = reaper.BR_Win32_GetPrivateProfileString("flac sink defaults", "default", "", reaper.get_ini_file())
    if retval==0 then rendercfg="63616C661000000005000000AB" end
    rendercfg = ultraschall.ConvertHex2Ascii(rendercfg)
    rendercfg=ultraschall.Base64_Encoder(rendercfg)
  end
  local Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="calf" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_FLAC", "rendercfg", "not a render-cfg-string of the format flac", -2) return -1 end
   
  if Decoded_string:len()==4 then
    return 16, 5
  end

  return string.byte(Decoded_string:sub(5,5)), string.byte(Decoded_string:sub(9))
end


--D,D2=ultraschall.GetRenderCFG_Settings_FLAC(B)


function ultraschall.GetRenderCFG_Settings_AIFF(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_AIFF</slug>
    <requires>
      Ultraschall=4.2
      Reaper=6.02
      Lua=5.3
    </requires>
    <functioncall>integer bitdepth, boolean EmbedBeatLength = ultraschall.GetRenderCFG_Settings_AIFF(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for aiff.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer bitdepth - the bitdepth of the AIFF-file(8, 16, 24, 32)
      boolean EmbedBeatLength - Embed beat length if exact-checkbox; true, checked; false, unchecked
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the aiff-settings
                        - nil, get the current new-project-default render-settings for aiff
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, aiff, bitdepth, beat length</tags>
  </US_DocBloc>
  ]]
  if rendercfg~=nil and type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AIFF", "rendercfg", "must be a string", -1) return -1 end
  if rendercfg==nil then
    local retval
    retval, rendercfg = reaper.BR_Win32_GetPrivateProfileString("aiff sink defaults", "default", "", reaper.get_ini_file())
    if retval==0 then rendercfg="66666961180000AE" end
    rendercfg = ultraschall.ConvertHex2Ascii(rendercfg)
    rendercfg=ultraschall.Base64_Encoder(rendercfg)
  end
  local Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="ffia" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AIFF", "rendercfg", "not a render-cfg-string of the format aiff", -2) return -1 end
  
  if Decoded_string:len()==4 then
    return 24, false
  end
  
  return string.byte(Decoded_string:sub(5,5)), string.byte(Decoded_string:sub(6,6))==32
end


--C=ultraschall.GetRenderCFG_Settings_AIFF(B)


function ultraschall.GetRenderCFG_Settings_AudioCD(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_AudioCD</slug>
    <requires>
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer trackmode, boolean use_markers_hashes, integer leadin_silence_tracks, integer leadin_silence_disc, boolean burn_cd_after_render = ultraschall.GetRenderCFG_Settings_AudioCD(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for AudioCD.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, audiocd, leadin silence, tracks, burn cd, image, markers as hashes</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AudioCD", "rendercfg", "must be a string", -1) return -1 end  
  local Decoded_string, LeadInSilenceDisc, LeadInSilenceTrack, num_integers, BurnImage, TrackMode, UseMarkers
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~=" osi" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AudioCD", "rendercfg", "not a render-cfg-string of the format audio cd", -2) return -1 end

  if Decoded_string:len()==4 then
    return 0, false, 0, 0, false
  end
  
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
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Mode, integer enc_quality, integer vbr_quality, integer abr_bitrate, integer cbr_bitrate, boolean no_joint_stereo, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MP3.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  if Decoded_string==nil or Decoded_string:sub(1,4)~="l3pm" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3", "rendercfg", "not a render-cfg-string of the format mp3", -2) return -1 end
  
  if Decoded_string:len()==4 then
    return 65344, 2, 40, 128, 128, false, false
  end
  
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
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer retval, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3MaxQuality(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MP3 with maximum quality-settings.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer cbr_bitrate, integer enc_quality, boolean no_joint_stereo, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3CBR(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MP3 CBR.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp3, cbr</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3CBR", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string, Mode, Mode2, Mode3, JointStereo, WriteReplayGain, EncodingQuality
  local VBR_Quality, ABR_Bitrate, num_integers, CBR_Bitrate
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="l3pm" or string.byte(Decoded_string:sub(17,17))~=255 or string.byte(Decoded_string:sub(13,13))==10 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3CBR", "rendercfg", "not a render-cfg-string of the format mp3-cbr", -2) return -1 end

  if Decoded_string:len()==4 then
    return 128, 2, false, false
  end
  

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
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer vbr_bitrate, integer enc_quality, boolean no_joint_stereo, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3VBR(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MP3 VBR.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp3, vbr</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3VBR", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string, Mode, Mode2, Mode3, JointStereo, WriteReplayGain, EncodingQuality
  local VBR_Quality, ABR_Bitrate, num_integers, CBR_Bitrate
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="l3pm" or string.byte(Decoded_string:sub(17,17))~=0 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3VBR", "rendercfg", "not a render-cfg-string of the format mp3-vbr", -2) return -1 end

  if Decoded_string:len()==4 then
    return 40, 2, false, false
  end

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
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer bitrate, integer enc_quality, boolean no_joint_stereo, boolean write_replay_gain = ultraschall.GetRenderCFG_Settings_MP3ABR(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MP3 ABR.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp3, abr</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3ABR", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string, Mode, Mode2, Mode3, JointStereo, WriteReplayGain, EncodingQuality
  local VBR_Quality, ABR_Bitrate, num_integers, CBR_Bitrate
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="l3pm" or string.byte(Decoded_string:sub(17,17))~=4 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP3ABR", "rendercfg", "not a render-cfg-string of the format mp3-abr", -2) return -1 end

  if Decoded_string:len()==4 then
    return 11, 2, false, false
  end

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
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Mode, integer VBR_quality, integer CBR_KBPS, integer ABR_KBPS, integer ABR_KBPS_MIN, integer ABR_KBPS_MAX = ultraschall.GetRenderCFG_Settings_OGG(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for OGG.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
                        - nil, get the current new-project-default render-settings for ogg
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, ogg, vbr, cbr, tbr, max quality</tags>
  </US_DocBloc>
  ]] 
  if rendercfg~=nil and type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_OGG", "rendercfg", "must be a string", -1) return -1 end
  if rendercfg==nil then
    local retval
    retval, rendercfg = reaper.BR_Win32_GetPrivateProfileString("ogg encoder defaults", "default", "", reaper.get_ini_file())
    if retval==0 then rendercfg="7667676F0000003F008000000080000000200000000001000013" end
    rendercfg = ultraschall.ConvertHex2Ascii(rendercfg)
    rendercfg=ultraschall.Base64_Encoder(rendercfg)
  end
  local Decoded_string
  local num_integers, Mode, VBR_quality, CBR_Bitrate, ABR_Bitrate, ABRmin_Bitrate, ABRmax_Bitrate
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="vggo" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_OGG", "rendercfg", "not a render-cfg-string of the format ogg", -2) return -1 end
  
  if Decoded_string:len()==4 then
    return 0, 0.50, 128, 128, 32, 256
  end
  
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
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Mode, integer Bitrate, integer Complexity, boolean channel_audio, boolean per_channel = ultraschall.GetRenderCFG_Settings_OPUS(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for Opus.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
                        - nil, get the current new-project-default render-settings for opus
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, opus, vbr, cbr, cvbr</tags>
  </US_DocBloc>
  ]]
  if rendercfg~=nil and type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_OPUS", "rendercfg", "must be a string", -1) return -1 end
  if rendercfg==nil then
    local retval
    retval, rendercfg = reaper.BR_Win32_GetPrivateProfileString("ogg opus encoder defaults", "default", "", reaper.get_ini_file())
    if retval==0 then rendercfg="5367674F00000043000A00000000000000BD" end
    rendercfg = ultraschall.ConvertHex2Ascii(rendercfg)
    rendercfg=ultraschall.Base64_Encoder(rendercfg)
  end
  local Decoded_string
  local num_integers, Mode, Bitrate, Complexity, Encode1, Encode2, Combine, Encode
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="SggO" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_OPUS", "rendercfg", "not a render-cfg-string of the format opus", -2) return -1 end
  
  if Decoded_string:len()==4 then
    return 0, 128, 10, false, true
  end
  
  num_integers, Bitrate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(6,8), 3)
  OOO=Bitrate[1]
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
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Width, integer Height, number MaxFramerate, boolean PreserveAspectRatio, integer IgnoreLowBits, boolean Transparency = ultraschall.GetRenderCFG_Settings_GIF(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for Gif.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, gif, width, height, framerate, transparency, aspect ratio</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_GIF", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, Width, Height, MaxFramerate, PreserveAspectRatio, Transparency, IgnoreLowBits
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~=" FIG" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_GIF", "rendercfg", "not a render-cfg-string of the format gif", -2) return -1 end
  
  if Decoded_string:len()==4 then
    return 640, 360, 30.00, false, 0, false
  end
  
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
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Width, integer Height, number MaxFramerate, boolean PreserveAspectRatio, string TweakSettings = ultraschall.GetRenderCFG_Settings_LCF(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for LCF.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, lcf, width, height, framerate, aspect ratio, tweak settings</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_LCF", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, Width, Height, MaxFramerate, PreserveAspectRatio, TweakSettings
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~=" FCL" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_LCF", "rendercfg", "not a render-cfg-string of the format lcf", -2) return -1 end
  
  if Decoded_string:len()==4 then
    return 640, 360, 30.00, false, "t20 x128 y16"
  end
  
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
      Ultraschall=4.2
      Reaper=6.13
      Lua=5.3
    </requires>
    <functioncall>integer BitDepth, integer LargeFiles, integer BWFChunk, integer IncludeMarkers, boolean EmbedProjectTempo = ultraschall.GetRenderCFG_Settings_WAV(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for WAV.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer BitDepth - the bitdepth of the WAV-file
                       - 0, 8 Bit PCM
                       - 1, 16 Bit PCM
                       - 2, 24 Bit PCM                     
                       - 3, 32 Bit FP
                       - 4, 64 Bit FP
                       - 5, 4 Bit IMA ADPCM
                       - 6, 2 Bit cADPCM                     
                       - 7, 32 Bit PCM
                       - 8, 8 Bit u-Law
      integer LargeFiles - how shall Reaper treat large WAV-files
                         -   0, Auto WAV/Wave64
                         -   1, Auto Wav/RF64
                         -   2, Force WAV
                         -   3, Force Wave64
                         -   4, Force RF64 
      integer BWFChunk - The "Write BWF ('bext') chunk" and "Include project filename in BWF data" - checkboxes
                       -   &1, checked - write BWF-checkbox; 0, unchecked
                       -   &2, checked - Include project filename in BWF data-checkbox; 0, unchecked
      integer IncludeMarkers -  The include markerlist-dropdownlist
                             -   0, Do not include markers and regions
                             -   1, Markers + regions
                             -   2, Markers + regions starting with #
                             -   3, Markers only
                             -   4, Markers starting with # only
                             -   5, Regions only
                             -   6, Regions starting with # only 
      boolean EmbedProjectTempo - Embed tempo-checkbox; true, checked; false, unchecked 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the wav-settings
                        - nil, get the current new-project-default render-settings for wav
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, wav</tags>
    <changelog>
    </changelog>
  </US_DocBloc>
  ]]
  if rendercfg~=nil and type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WAV", "rendercfg", "must be a string", -1) return -1 end
  if rendercfg==nil then
    local retval
    retval, rendercfg = reaper.BR_Win32_GetPrivateProfileString("wave sink defaults", "default", "", reaper.get_ini_file())
    if retval==0 then rendercfg="65766177180000CB" end
    rendercfg = ultraschall.ConvertHex2Ascii(rendercfg)
    rendercfg=ultraschall.Base64_Encoder(rendercfg)
  end
  local Decoded_string
  local IncludeMarkers, IncludeMarkers_temp, Bitdepth, LargeFiles, BWFChunk, EmbedProjectTempo
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  
  if Decoded_string==nil or Decoded_string:sub(1,4)~="evaw" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WAV", "rendercfg", "not a render-cfg-string of the format wav", -2) return -1 end
  if Decoded_string:len()==4 then 
    Bitdepth=2
    LargeFiles=0
    BWFChunk=1
    IncludeMarkers=0
    EmbedProjectTempo=false
  else
    Bitdepth=string.byte(Decoded_string:sub(5,5))
    if Bitdepth==8 then Bitdepth=0
    elseif Bitdepth==16 then Bitdepth=1
    elseif Bitdepth==24 then Bitdepth=2
    elseif Bitdepth==32 then Bitdepth=3
    elseif Bitdepth==64 then Bitdepth=4
    elseif Bitdepth==4 then Bitdepth=5
    elseif Bitdepth==2 then Bitdepth=6
    elseif Bitdepth==33 then Bitdepth=7
    elseif Bitdepth==14 then Bitdepth=8    
    end
  
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
  end
  
  return Bitdepth, LargeFiles, BWFChunk, IncludeMarkers, EmbedProjectTempo
end


function ultraschall.GetRenderCFG_Settings_WAVPACK(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_WAVPACK</slug>
    <requires>
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer Mode, integer Bitdepth, integer Writemarkers, boolean WriteBWFChunk, boolean IncludeFilenameBWF = ultraschall.GetRenderCFG_Settings_WAVPACK(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for WAVPACK.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
                        - nil, get the current new-project-default render-settings for wavpack
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, wavpack</tags>
  </US_DocBloc>
  ]]
  if rendercfg~=nil and type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WAVPACK", "rendercfg", "must be a string", -1) return -1 end
  if rendercfg==nil then
    local retval
    retval, rendercfg = reaper.BR_Win32_GetPrivateProfileString("wavpack encoder defaults", "default", "", reaper.get_ini_file())
    if retval==0 then rendercfg="6B70767700000000010000000000000000000000C9" end
    rendercfg = ultraschall.ConvertHex2Ascii(rendercfg)
    rendercfg=ultraschall.Base64_Encoder(rendercfg)
  end
  local Decoded_string
  local Mode, Bitdepth, WriteMarkers, WriteBWFChunk, IncludeProjectFilenameInBWFData
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="kpvw" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WAVPACK", "rendercfg", "not a render-cfg-string of the format wavpack", -2) return -1 end
  
  if Decoded_string:len()==4 then
    return 0, 1, 0, false, false
  end
  
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


function ultraschall.GetRenderCFG_Settings_WebM_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_WebM_Video</slug>
    <requires>
      Ultraschall=4.7
      Reaper=6.62
      Lua=5.3
    </requires>
    <functioncall>integer VIDKBPS, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, integer VideoCodec, integer AudioCodec, string VideoExportOptions, string AudioExportOptions = ultraschall.GetRenderCFG_Settings_WebM_Video(string rendercfg)</functioncall>
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
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
      integer VideoCodec - the video-codec used
                         - 0, VP8
                         - 1, VP9 (needs FFMPEG 4.1.3 installed)
                         - 2, NONE
      integer AudioCodec - the video-codec used
                         - 0, VORBIS
                         - 1, OPUS (needs FFMPEG 4.1.3 installed)
                         - 2, NONE
      string VideoExportOptions - the options for FFMPEG to apply to the video; examples: 
                                - g=1 ; all keyframes
                                - crf=1  ; h264 high quality
                                - crf=51 ; h264 small size
      string AudioExportOptions - the options for FFMPEG to apply to the audio; examples: 
                                - q=0 ; mp3 VBR highest
                                - q=9 ; mp3 VBR lowest
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the webm-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, webm, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WebM_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string, VideoCodec, AudioCodec
  local num_integers, VidKBPS, AudKBPS, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=6 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WebM_Video", "rendercfg", "not a render-cfg-string of the format webm-video", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_WebM_Video", "rendercfg", "can't make out, which video format is chosen", -3) return nil
  end
  
  VideoCodec=string.byte(Decoded_string:sub(9,9))  
  AudioCodec=string.byte(Decoded_string:sub(17,17))
  num_integers, VidKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(13,16), 4)
  num_integers, AudKBPS = ultraschall.ConvertStringToIntegers(Decoded_string:sub(21,24), 4)
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  local FFMPEG_Options=Decoded_string:sub(45, -1)
  local FFMPEG_Options_Audio, FFMPEG_Options_Video=FFMPEG_Options:match("(.-)\0(.-)\0")
  
  return VidKBPS[1], AudKBPS[1], Width[1], Height[1], FPS, AspectRatio, VideoCodec, AudioCodec, FFMPEG_Options_Video, FFMPEG_Options_Audio
end

ultraschall.GetRenderCFG_Settings_WebMVideo=ultraschall.GetRenderCFG_Settings_WebM_Video


function ultraschall.GetRenderCFG_Settings_MKV_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MKV_Video</slug>
    <requires>
      Ultraschall=4.7
      Reaper=6.62
      Lua=5.3
    </requires>
    <functioncall>integer VIDEO_CODEC, integer MJPEG_quality, integer AUDIO_CODEC, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, string VideoExportOptions, string AudioExportOptions = ultraschall.GetRenderCFG_Settings_MKV_Video(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MKV-Video.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer VIDEO_CODEC - the used VideoCodec for the MKV-video
                          - 0, FFV1 (lossless)
                          - 1, Hufyuv (lossless)
                          - 2, MJPEG
                          - 3, MPEG-2 (needs FFMPEG 4.1.3 installed)
                          - 4, H.264 (needs FFMPEG 4.1.3 installed)
                          - 5, XviD (needs FFMPEG 4.1.3 installed)
                          - 6, NONE
      integer MJPEG_quality - the MJPEG-quality of the MKV-video, if VIDEO_CODEC=2 or when VIDEO_CODEC=4
      integer AUDIO_CODEC - the audio-codec of the MKV-video
                          - 0, 16 bit PCM
                          - 1, 24 bit PCM
                          - 2, 32 bit FP
                          - 3, MP3 (needs FFMPEG 4.1.3 installed)
                          - 4, AAC (needs FFMPEG 4.1.3 installed)
                          - 5, NONE
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
      string VideoExportOptions - the options for FFMPEG to apply to the video; examples: 
                                - g=1 ; all keyframes
                                - crf=1  ; h264 high quality
                                - crf=51 ; h264 small size
      string AudioExportOptions - the options for FFMPEG to apply to the audio; examples: 
                                - q=0 ; mp3 VBR highest
                                - q=9 ; mp3 VBR lowest
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the mkv-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mkv, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MKV_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=4 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MKV_Video", "rendercfg", "not a render-cfg-string of the format mkv-video", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_MKV_Video", "rendercfg", "can't make out, which video format is chosen", -3) return nil
  end
   
  VideoCodec=string.byte(Decoded_string:sub(9,9))-2
  if VideoCodec==4 then VideoCodec=6 end
  if VideoCodec==-2 then VideoCodec=4 end
  if VideoCodec==-1 then VideoCodec=5 end
  
  num_integers, MJPEG_quality= ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  AudioCodec=string.byte(Decoded_string:sub(17,17))-2
  
  if AudioCodec==3 then AudioCodec=5 end
  if AudioCodec==-2 then AudioCodec=3 end
  if AudioCodec==-1 then AudioCodec=4 end
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  local FFMPEG_Options=Decoded_string:sub(45, -1)
  local FFMPEG_Options_Audio, FFMPEG_Options_Video=FFMPEG_Options:match("(.-)\0(.-)\0")
  
  return VideoCodec, MJPEG_quality[1], AudioCodec, Width[1], Height[1], FPS, AspectRatio, FFMPEG_Options_Video, FFMPEG_Options_Audio
end


function ultraschall.GetRenderCFG_Settings_AVI_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_AVI_Video</slug>
    <requires>
      Ultraschall=4.7
      Reaper=6.62
      Lua=5.3
    </requires>
    <functioncall>integer VIDEO_CODEC, integer MJPEG_quality, integer AUDIO_CODEC, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, string VideoExportOptions, string AudioExportOptions = ultraschall.GetRenderCFG_Settings_AVI_Video(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for AVI_Video.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Some format-combinations only work with FFMPEG 4.1.3 installed!
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer VIDEO_CODEC - the used VideoCodec for the AVI-video
                          - 0, DV
                          - 1, MJPEG
                          - 2, FFV1 (lossless)
                          - 3, Hufyuv (lossless)
                          - 4, MPEG-2 (only with FFMPEG 4.1.3 installed)
                          - 5, XVid (only with FFMPEG 4.1.3 installed)
                          - 6, H.264 (only with FFMPEG 4.1.3 installed)
                          - 7, NONE
      integer MJPEG_quality - the MJPEG-quality of the AVI-video, if VIDEO_CODEC=1 or VIDEO_CODEC=6
      integer AUDIO_CODEC - the audio-codec of the avi-video
                          - 0, 16 bit PCM
                          - 1, 24 bit PCM
                          - 2, 32 bit FP
                          - 3, MP3 (only with FFMPEG 4.1.3 installed)
                          - 4, AAC (only with FFMPEG 4.1.3 installed)
                          - 5, AC3 (only with FFMPEG 4.1.3 installed)
                          - 6, NONE
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
      string VideoExportOptions - the options for FFMPEG to apply to the video; examples: 
                                - g=1 ; all keyframes
                                - crf=1  ; h264 high quality
                                - crf=51 ; h264 small size
      string AudioExportOptions - the options for FFMPEG to apply to the audio; examples: 
                                - q=0 ; mp3 VBR highest
                                - q=9 ; mp3 VBR lowest
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the avi-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, avi, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AVI_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=0 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_AVI_Video", "rendercfg", "not a render-cfg-string of the format avi-video", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_AVI_Video", "rendercfg", "can't make out, which video format is chosen", -3) return nil
  end
  
  VideoCodec=string.byte(Decoded_string:sub(9,9))-2
  if VideoCodec==5 then VideoCodec=7 end
  if VideoCodec==-2 then VideoCodec=5 end
  if VideoCodec==-1 then VideoCodec=6 end
  num_integers, MJPEG_quality= ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  AudioCodec=string.byte(Decoded_string:sub(17,17))-3
  if AudioCodec==4 then AudioCodec=6 end
  if AudioCodec==-3 then AudioCodec=3 end
  if AudioCodec==-2 then AudioCodec=4 end
  if AudioCodec==-1 then AudioCodec=5 end
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  local FFMPEG_Options=Decoded_string:sub(45, -1)
  local FFMPEG_Options_Audio, FFMPEG_Options_Video=FFMPEG_Options:match("(.-)\0(.-)\0")
  
  return VideoCodec, MJPEG_quality[1], AudioCodec, Width[1], Height[1], FPS, AspectRatio, FFMPEG_Options_Video, FFMPEG_Options_Audio
end



function ultraschall.GetRenderCFG_Settings_QTMOVMP4_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_QTMOVMP4_Video</slug>
    <requires>
      Ultraschall=4.7
      Reaper=6.62
      Lua=5.3
    </requires>
    <functioncall>integer MJPEG_quality, integer AUDIO_CODEC, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, integer VIDEOCODEC, string VideoExportOptions, string AudioExportOptions = ultraschall.GetRenderCFG_Settings_QTMOVMP4_Video(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for QT/MOV/MP4-video.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Note: some settings work only with FFMPEG 4.1.3 installed
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer MJPEG_quality - the MJPEG-quality of the video, when VIDEO_CODEC=0 or VIDEO_CODEC=2
      integer AUDIO_CODEC - the audio-codec of the video
                          - 0, 16 bit PCM
                          - 1, 24 bit PCM
                          - 2, 32 bit FP
                          - 3, AAC(only with FFMPEG 4.1.3 installed)
                          - 4, MP3(only with FFMPEG 4.1.3 installed)
                          - 5, NONE
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
      integer VIDEOCODEC - the video-codec
                         - 0, H.264(only with FFMPEG 4.1.3 installed)
                         - 1, MPEG-2(only with FFMPEG 4.1.3 installed)
                         - 2, MJPEG
                         - 3, NONE
      string VideoExportOptions - the options for FFMPEG to apply to the video; examples: 
                                - g=1 ; all keyframes
                                - crf=1  ; h264 high quality
                                - crf=51 ; h264 small size
      string AudioExportOptions - the options for FFMPEG to apply to the audio; examples: 
                                - q=0 ; mp3 VBR highest
                                - q=9 ; mp3 VBR lowest
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the qt/mov/mp4-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mov, qt, mp4, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_QTMOVMP4_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=3 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_QTMOVMP4_Video", "rendercfg", "not a render-cfg-string of the format qt/move/mp4-video", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_QTMOVMP4_Video", "rendercfg", "can't make out, which video format is chosen", -3) return nil
  end
  
  VideoCodec=string.byte(Decoded_string:sub(9,9))
  num_integers, MJPEG_quality= ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  AudioCodec=string.byte(Decoded_string:sub(17,17))-2
  if AudioCodec==3 then AudioCodec=5 end
  if AudioCodec==-2 then AudioCodec=3 end
  if AudioCodec==-1 then AudioCodec=4 end
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  local FFMPEG_Options=Decoded_string:sub(45, -1)
  local FFMPEG_Options_Audio, FFMPEG_Options_Video=FFMPEG_Options:match("(.-)\0(.-)\0")
  
  return MJPEG_quality[1], AudioCodec, Width[1], Height[1], FPS, AspectRatio, VideoCodec, FFMPEG_Options_Video, FFMPEG_Options_Audio
end


function ultraschall.GetRenderCFG_Settings_DDP(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_DDP</slug>
    <requires>
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.GetRenderCFG_Settings_DDP(string rendercfg)</functioncall>
    <description>
      Returns, if a renderstring is a valid DDP-render-string
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
    Ultraschall=4.2
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, gif</tags>
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
    Ultraschall=4.2
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, lcf</tags>
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


function ultraschall.CreateRenderCFG_WebM_Video(VIDKBPS, AUDKBPS, WIDTH, HEIGHT, FPS, AspectRatio, VideoCodec, AudioCodec, VideoOptions, AudioOptions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_WebM_Video</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.62
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_WebM_Video(integer VIDKBPS, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, integer VideoCodec, integer AudioCodec, optional string VideoOptions, optional string AudioOptions)</functioncall>
  <description>
    Returns the render-cfg-string for the WebM-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: some settings need FFMPEG 4.1.3 to be installed
    
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
    number FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
    integer VideoCodec - the videocodec used for the video;
                       - 1, VP8
                       - 2, VP9(needs FFMPEG 4.1.3 to be installed)
                       - 3, NONE
    integer AudioCodec - the audiocodec to use for the video
                       - 1, VORBIS
                       - 2, OPUS(needs FFMPEG 4.1.3 to be installed)
                       - 3, NONE
    optional string VideoOptions - additional FFMPEG-options for rendering the video; examples:
                                 - g=1 ; all keyframes
                                 - crf=1  ; h264 high quality
                                 - crf=51 ; h264 small size
    optional string AudioOptions - additional FFMPEG-options for rendering the video; examples:
                                 - q=0 ; mp3 VBR highest
                                 - q=9 ; mp3 VBR lowest    
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, webm</tags>
</US_DocBloc>
]]
  if math.type(VIDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "VIDKBPS", "Must be an integer!", -2) return nil end
  if math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "AUDKBPS", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "AspectRatio", "Must be a boolean!", -7) return nil end
  if VIDKBPS<1 or VIDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "VIDKBPS", "Must be between 1 and 2147483647.", -8) return nil end
  if AUDKBPS<1 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "AUDKBPS", "Must be between 1 and 2147483647.", -9) return nil end
  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "WIDTH", "Must be between 1 and 2147483647.", -10) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "HEIGHT", "Must be between 1 and 2147483647.", -11) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -12) return nil end
  
  if VideoOptions~=nil and type(VideoOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "VideoOptions", "Must be a string with maximum length of 255 characters!", -17) return nil end
  if AudioOptions~=nil and type(AudioOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "AudioOptions", "Must be a string with maximum length of 255 characters!", -18) return nil end
  if VideoOptions==nil then VideoOptions="" end
  if AudioOptions==nil then AudioOptions="" end
  
  if VideoCodec~=nil and math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "VideoCodec", "Must be an integer!", -13) return nil end  
  if VideoCodec==nil then VideoCodec=0 end
  if AudioCodec~=nil and math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "AudioCodec", "Must be an integer!", -14) return nil end
  if AudioCodec==nil then AudioCodec=0 end
  if VideoCodec<1 or VideoCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "VideoCodec", "Must be between 1 and 2", -15) return nil end  
  if AudioCodec<1 or AudioCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_WebM_Video", "AudioCodec", "Must be between 1 and 2", -16) return nil end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4,ultraschall.DoubleToInt(FPS))  

  VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VIDKBPS)
  AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)
  local VideoCodec=string.char(VideoCodec-1)
  local VideoFormat=string.char(6)
  local AudioCodec=string.char(AudioCodec-1)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, 1)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality..AudioOptions.."\0"..VideoOptions.."\0")
end

--LLL=ultraschall.CreateRenderCFG_WebM_Video(1, 1, 1, 1, 1, true)

ultraschall.CreateRenderCFG_WebMVideo=ultraschall.CreateRenderCFG_WebM_Video


function ultraschall.CreateRenderCFG_MKV_Video(VideoCodec, MJPEG_quality, AudioCodec, WIDTH, HEIGHT, FPS, AspectRatio, VIDKBPS, AUDKBPS, VideoOptions, AudioOptions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MKV_Video</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.62
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MKV_Video(integer VideoCodec, integer MJPEG_quality, integer AudioCodec, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, optional integer VIDKBPS, optional integer AUDKBPS, optional string VideoOptions, optional string AudioOptions)</functioncall>
  <description>
    Returns the render-cfg-string for the MKV-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: some settings work only with FFMPEG 4.1.3 installed
    
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
                       -   4, MPEG-2
                       -   5, H.264
                       -   6, XviD
                       -   7, NONE
    integer MJPEG_quality - set here the MJPEG-quality in percent, when VideoCodec=3; otherwise just set it to 0
    integer AudioCodec - the audiocodec to use for the video
                       - 1, 16 bit PCM
                       - 2, 24 bit PCM
                       - 3, 32 bit FP
                       - 4, MP3
                       - 5, AAC
                       - 6, NONE
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    number FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
    optional integer VIDKBPS - the video-bitrate of the video in kbps; 1 to 2147483647(default is 2048)
    optional integer AUDKBPS - the audio-bitrate of the video in kbps; 1 to 2147483647(default is 128)
    optional string VideoOptions - additional FFMPEG-options for rendering the video; examples:
                                 - g=1 ; all keyframes
                                 - crf=1  ; h264 high quality
                                 - crf=51 ; h264 small size
    optional string AudioOptions - additional FFMPEG-options for rendering the video; examples:
                                 - q=0 ; mp3 VBR highest
                                 - q=9 ; mp3 VBR lowest    
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mkv</tags>
</US_DocBloc>
]]
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "VideoCodec", "Must be an integer!", -2) return nil end
  if math.type(MJPEG_quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "MJPEG_quality", "Must be an integer!", -3) return nil end
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "AudioCodec", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "AspectRatio", "Must be a boolean!", -7) return nil end
  
  if VideoCodec<1 or VideoCodec>7 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "VideoCodec", "Must be between 1 and 6", -8) return nil end
  if VideoCodec==1 then VideoCodec=2 
  elseif VideoCodec==2 then VideoCodec=3 
  elseif VideoCodec==3 then VideoCodec=4 
  elseif VideoCodec==4 then VideoCodec=5 
  elseif VideoCodec==5 then VideoCodec=0 
  elseif VideoCodec==6 then VideoCodec=1 
  elseif VideoCodec==7 then VideoCodec=6
  end
  if MJPEG_quality<0 or MJPEG_quality>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "MJPEG_quality", "Must be between 1 and 2147483647", -9) return nil end
  if AudioCodec<1 or AudioCodec>6 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "AudioCodec", "Must be between 1 and 5", -10) return nil end
  if AudioCodec==1 then AudioCodec=2 
  elseif AudioCodec==2 then AudioCodec=3 
  elseif AudioCodec==3 then AudioCodec=4 
  elseif AudioCodec==4 then AudioCodec=0 
  elseif AudioCodec==5 then AudioCodec=1 
  elseif AudioCodec==6 then AudioCodec=5
  end  
  
  if VIDKBPS~=nil and math.type(VIDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "VIDKBPS", "Must be an integer!", -14) return nil end
  if AUDKBPS~=nil and math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "AUDKBPS", "Must be an integer!", -15) return nil end  
  if VIDKBPS==nil then VIDKBPS=2048 end
  if AUDKBPS==nil then AUDKBPS=128 end
  if VIDKBPS<1 or VIDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "VIDKBPS", "Must be between 1 and 2147483647.", -16) return nil end
  if AUDKBPS<1 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "AUDKBPS", "Must be between 1 and 2147483647.", -17) return nil end

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "WIDTH", "Must be between 1 and 2147483647.", -11) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "HEIGHT", "Must be between 1 and 2147483647.", -12) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -13) return nil end

  if VideoOptions~=nil and type(VideoOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "VideoOptions", "Must be a string with maximum length of 255 characters!", -14) return nil end
  if AudioOptions~=nil and type(AudioOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_MKV_Video", "AudioOptions", "Must be a string with maximum length of 255 characters!", -15) return nil end
  if VideoOptions==nil then VideoOptions="" end
  if AudioOptions==nil then AudioOptions="" end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VIDKBPS)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)
  local VideoCodec=string.char(VideoCodec)
  local VideoFormat=string.char(4)
  local AudioCodec=string.char(AudioCodec)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, MJPEG_quality)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality..AudioOptions.."\0"..VideoOptions.."\0")
end

--A=ultraschall.CreateRenderCFG_MKVMVideo(1, 1, 1, 1, 1, 1, false)


function ultraschall.CreateRenderCFG_QTMOVMP4_Video(VideoCodec, MJPEG_quality, AudioCodec, WIDTH, HEIGHT, FPS, AspectRatio, VIDKBPS, AUDKBPS, VideoOptions, AudioOptions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_QTMOVMP4_Video</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.62
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_QTMOVMP4_Video(integer VideoCodec, integer MJPEG_quality, integer AudioCodec, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, optional integer VIDKBPS, optional integer AUDKBPS, optional string VideoOptions, optional string AudioOptions)</functioncall>
  <description>
    Returns the render-cfg-string for the QT/MOV/MP4-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: some settings work only with FFMPEG 4.1.3 installed
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected QT/MOV/MP4-Video-settings
  </retvals>
  <parameters>
    integer VideoCodec - the videocodec used for the video;
                       - 1, MJPEG
                       - 2, H.264(needs FFMPEG 4.1.3 installed)
                       - 3, MPEG-2(needs FFMPEG 4.1.3 installed)
                       - 4, NONE
    integer MJPEG_quality - set here the MJPEG-quality in percent
    integer AudioCodec - the audiocodec to use for the video
                       - 1, 16 bit PCM
                       - 2, 24 bit PCM
                       - 3, 32 bit FP
                       - 4, AAC(needs FFMPEG 4.1.3 installed)
                       - 5, MP3(needs FFMPEG 4.1.3 installed)
                       - 6, NONE
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    number FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
    optional integer VIDKBPS - the video-bitrate of the video in kbps; 1 to 2147483647(default 2048)
    optional integer AUDKBPS - the video-bitrate of the video in kbps; 1 to 2147483647(default 128)
    optional string VideoOptions - additional FFMPEG-options for rendering the video; examples:
                                 - g=1 ; all keyframes
                                 - crf=1  ; h264 high quality
                                 - crf=51 ; h264 small size
    optional string AudioOptions - additional FFMPEG-options for rendering the video; examples:
                                 - q=0 ; mp3 VBR highest
                                 - q=9 ; mp3 VBR lowest    
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mp4, qt, mov</tags>
</US_DocBloc>
]]
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "VideoCodec", "Must be an integer!", -2) return nil end
  if math.type(MJPEG_quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "MJPEG_quality", "Must be an integer!", -3) return nil end
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "AudioCodec", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "AspectRatio", "Must be a boolean!", -7) return nil end
  
  if VIDKBPS~=nil and math.type(VIDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "VIDKBPS", "Must be an integer!", -14) return nil end
  if AUDKBPS~=nil and math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "AUDKBPS", "Must be an integer!", -15) return nil end  
  if VIDKBPS==nil then VIDKBPS=2048 end
  if AUDKBPS==nil then AUDKBPS=128 end
  if VIDKBPS<1 or VIDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "VIDKBPS", "Must be between 1 and 2147483647.", -16) return nil end
  if AUDKBPS<1 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "AUDKBPS", "Must be between 1 and 2147483647.", -17) return nil end
  
  if VideoCodec<1 or VideoCodec>4 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "VideoCodec", "Must be between 1 and 3", -8) return nil end
  if VideoCodec==1 then VideoCodec=2 
  elseif VideoCodec==2 then VideoCodec=0 
  elseif VideoCodec==3 then VideoCodec=1 
  elseif VideoCodec==4 then VideoCodec=3
  end
  if MJPEG_quality<0 or MJPEG_quality>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "MJPEG_quality", "Must be between 1 and 2147483647", -9) return nil end
  if AudioCodec<1 or AudioCodec>6 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "AudioCodec", "Must be between 1 and 5", -10) return nil end
  if AudioCodec==1 then AudioCodec=2
  elseif AudioCodec==2 then AudioCodec=3 
  elseif AudioCodec==3 then AudioCodec=4   
  elseif AudioCodec==4 then AudioCodec=0 
  elseif AudioCodec==5 then AudioCodec=1 
  elseif AudioCodec==6 then AudioCodec=5
  end

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "WIDTH", "Must be between 1 and 2147483647.", -11) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "HEIGHT", "Must be between 1 and 2147483647.", -12) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -13) return nil end

  if VideoOptions~=nil and type(VideoOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "VideoOptions", "Must be a string with maximum length of 255 characters!", -14) return nil end
  if AudioOptions~=nil and type(AudioOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_QTMOVMP4_Video", "AudioOptions", "Must be a string with maximum length of 255 characters!", -15) return nil end
  if VideoOptions==nil then VideoOptions="" end
  if AudioOptions==nil then AudioOptions="" end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VIDKBPS)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)

  local VideoCodec=string.char(VideoCodec)
  local VideoFormat=string.char(3)
  local AudioCodec=string.char(AudioCodec)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, MJPEG_quality)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality..AudioOptions.."\0"..VideoOptions.."\0")
end

--A=ultraschall.CreateRenderCFG_QTMOVMP4_Video(1, 1, 1, 1, 1, 1, false)


function ultraschall.CreateRenderCFG_AVI_Video(VideoCodec, MJPEG_quality, AudioCodec, WIDTH, HEIGHT, FPS, AspectRatio, VideoOptions, AudioOptions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_AVI_Video</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.62
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_AVI_Video(integer VideoCodec, integer MJPEG_quality, integer AudioCodec, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, optional string VideoOptions, optional string AudioOptions)</functioncall>
  <description>
    Returns the render-cfg-string for the AVI-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: some settings work only with FFMPEG 4.1.3 installed
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected AVI-Video-settings
  </retvals>
  <parameters>
    integer VideoCodec - the videocodec used for the video;
                      - 1, DV
                      - 2, MJPEG
                      - 3, FFV1 (lossless)
                      - 4, Hufyuv (lossless)
                      - 5, MPEG-2
                      - 6, XviD (only with FFMPEG 4.1.3 installed)
                      - 7, H.264 (only with FFMPEG 4.1.3 installed)
                      - 8, NONE
    integer MJPEG_quality - set here the MJPEG-quality in percent when VideoCodec=2, otherwise just set it to 0
    integer AudioCodec - the audiocodec to use for the video
                       - 1, 16 bit PCM
                       - 2, 24 bit PCM
                       - 3, 32 bit FP
                       - 4, MP3 (only with FFMPEG 4.1.3 installed)
                       - 5, AAC (only with FFMPEG 4.1.3 installed)
                       - 6, AC3 (only with FFMPEG 4.1.3 installed)
                       - 7, NONE
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    number FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
    optional string VideoOptions - additional FFMPEG-options for rendering the video; examples:
                                 - g=1 ; all keyframes
                                 - crf=1  ; h264 high quality
                                 - crf=51 ; h264 small size
    optional string AudioOptions - additional FFMPEG-options for rendering the video; examples:
                                 - q=0 ; mp3 VBR highest
                                 - q=9 ; mp3 VBR lowest    
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, avi</tags>
</US_DocBloc>
]]
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "VideoCodec", "Must be an integer!", -2) return nil end
  if math.type(MJPEG_quality)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "MJPEG_quality", "Must be an integer!", -3) return nil end
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "AudioCodec", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "AspectRatio", "Must be a boolean!", -7) return nil end
  
  if VideoCodec<1 or VideoCodec>8 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "VideoCodec", "Must be between 1 and 7", -8) return nil end
  if VideoCodec==6 then VideoCodec=-1 end
  if VideoCodec==7 then VideoCodec=0 end
  if VideoCodec==8 then VideoCodec=6 end
  if MJPEG_quality<0 or MJPEG_quality>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "MJPEG_quality", "Must be between 1 and 2147483647", -9) return nil end
  if AudioCodec<1 or AudioCodec>7 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "AudioCodec", "Must be between 1 and 6", -10) return nil end
  if AudioCodec==4 then AudioCodec=-2 end
  if AudioCodec==5 then AudioCodec=-1 end
  if AudioCodec==6 then AudioCodec=0 end
  if AudioCodec==7 then AudioCodec=5 end

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "WIDTH", "Must be between 1 and 2147483647.", -11) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "HEIGHT", "Must be between 1 and 2147483647.", -12) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -13) return nil end

  if VideoOptions~=nil and type(VideoOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "VideoOptions", "Must be a string with maximum length of 255 characters!", -14) return nil end
  if AudioOptions~=nil and type(AudioOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_AVI_Video", "AudioOptions", "Must be a string with maximum length of 255 characters!", -15) return nil end
  if VideoOptions==nil then VideoOptions="" end
  if AudioOptions==nil then AudioOptions="" end

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
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality..AudioOptions.."\0"..VideoOptions.."\0")
end

--A=ultraschall.CreateRenderCFG_AVI_Video(1, 1, 1, 1, 1, 1, false)


function ultraschall.GetRenderCFG_Settings_MP4Mac_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MP4Mac_Video</slug>
    <requires>
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>boolean Stream, integer VIDKBPS, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_MP4Mac_Video(string rendercfg)</functioncall>
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
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the webm-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mp4, mac, stream, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP4Mac_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VidKBPS, AudKBPS, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="FVAX" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP4Mac_Video", "rendercfg", "not a render-cfg-string of the format mp4-for mac-video", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_MP4Mac_Video", "rendercfg", "can't make out, which video format is chosen", -4) return nil
  end
  
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
      Ultraschall=4.3
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer VideoCodec, integer VIDKBPS, integer MJPEG_quality, integer AudioCodec, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, integer Format = ultraschall.GetRenderCFG_Settings_MOVMac_Video(string rendercfg)</functioncall>
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
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
      integer Format - the format-dropdownlist
                     - 0, MPEG-4 Video (streaming optimized)
                     - 1, MPEG-4 Video
                     - 2, Quicktime MOV
                     - 3, MPEG-4 Audio
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the webm-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mov, mac, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MOVMac_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VidKBPS, AudKBPS, Width, Height, FPS, AspectRatio, VideoCodec, AudioCodec, MJPEG_quality
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string:sub(1,4)~="FVAX" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MOVMac_Video", "rendercfg", "not a render-cfg-string of the format mov-for mac-video", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_MOVMac_Video", "rendercfg", "can't make out, which video format is chosen", -3) return nil
  end
  
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
  Format=string.byte(Decoded_string:sub(5,5))
  

  return VideoCodec, VidKBPS[1], MJPEG_quality[1], AudioCodec, AudKBPS[1], Width[1], Height[1], FPS, AspectRatio, Format
end


function ultraschall.GetRenderCFG_Settings_M4AMac(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_M4AMac</slug>
    <requires>
      Ultraschall=4.2
      Reaper=5.975
      Lua=5.3
    </requires>
    <functioncall>integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_M4AMac(string rendercfg)</functioncall>
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
      number FPS  - the fps of the audio; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the webm-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MP4MAC_Video(boolean stream, integer VIDKBPS, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio)</functioncall>
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
    number FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mp4, stream, mac</tags>
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
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_M4AMAC(integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio)</functioncall>
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
    number FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, m4a, audio, mac</tags>
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
    Ultraschall=4.3
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MOVMAC_Video(integer VideoCodec, integer VIDKBPS, integer MJPEG_quality, integer AudioCodec, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, optional integer VideoFormat)</functioncall>
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
    integer VIDKBPS - the video-bitrate of the video in kbps
    integer MJPEG_quality - when VideoCodec==3, then MJPEG is used; given in percent
    integer AudioCodec - the audiocodec used 
                       - 0, AAC
                       - 1, 16-bit PCM
                       - 2, 24-bit PCM
                       - 3, 32-bit FP PCM
    integer AUDKBPS -  the audio-bitrate of the video in kbps
    integer WIDTH - the width of the video in pixels
    integer HEIGHT -  the height of the video in pixels
    number FPS - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mov, mac</tags>
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
  if VideoFormat~=nil and math.type(VideoFormat)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "VideoFormat", "Must be a nil or an integer!", -18) return nil end
  if VideoFormat==nil then VideoFormat=2 end
  if VideoFormat<0 or VideoFormat>3 then ultraschall.AddErrorMessage("CreateRenderCFG_MOVMAC_Video", "VideoFormat", "Must be between 0 and 3!", -19) return nil end
  
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
  local VideoFormat=string.char(VideoFormat)
  local AudioCodec=string.char(AudioCodec)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, MJPEG_quality)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("FVAX"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality)--, "FVAX"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality
end

--A,AA=reaper.EnumProjects(3, "")
--B=ultraschall.GetOutputFormat_RenderCfg(nil, 1)

function ultraschall.GetRenderTable_Project()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTable_Project</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.71
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.GetRenderTable_Project()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all stored render-settings for the current project, as a handy table.
            
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
            RenderTable["Brickwall_Limiter_Enabled"] - true, brickwall limiting is enabled; false, brickwall limiting is disabled            
            RenderTable["Brickwall_Limiter_Method"] - brickwall-limiting-mode; 1, peak; 2, true peak
            RenderTable["Brickwall_Limiter_Target"] - the volume of the brickwall-limit
            RenderTable["Bounds"] - 0, Custom time range; 
                                    1, Entire project; 
                                    2, Time selection; 
                                    3, Project regions; 
                                    4, Selected Media Items(in combination with Source 32); 
                                    5, Selected regions
                                    6, Razor edit areas
                                    7, All project markers
                                    8, Selected markers
            RenderTable["Channels"] - the number of channels in the rendered file; 
                                      1, mono; 
                                      2, stereo; 
                                      higher, the number of channels
            RenderTable["CloseAfterRender"] - true, closes rendering to file-dialog after render; false, doesn't close it
            RenderTable["Dither"] - &1, dither master mix; 
                                    &2, noise shaping master mix; 
                                    &4, dither stems; 
                                    &8, dither noise shaping stems
            RenderTable["EmbedMetaData"] - Embed metadata; true, checked; false, unchecked
            RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides; true, checked; false, unchecked
            RenderTable["EmbedTakeMarkers"] - Embed Take markers; true, checked; false, unchecked                        
            RenderTable["Enable2ndPassRender"] - true, 2nd pass render is enabled; false, 2nd pass render is disabled
            RenderTable["Endposition"] - the endposition of the rendering selection in seconds            
            RenderTable["FadeIn_Enabled"] - true, fade-in is enabled; false, fade-in is disabled
            RenderTable["FadeIn"] - the fade-in-time in seconds
            RenderTable["FadeIn_Shape"] - the fade-in-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["FadeOut_Enabled"] - true, fade-out is enabled; false, fade-out is disabled
            RenderTable["FadeOut"] - the fade-out time in seconds
            RenderTable["FadeOut_Shape"] - the fade-out-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked            
            RenderTable["Normalize_Enabled"] - true, normalization enabled; false, normalization not enabled
            RenderTable["Normalize_Method"] - the normalize-method-dropdownlist
                           0, LUFS-I
                           1, RMS-I
                           2, Peak
                           3, True Peak
                           4, LUFS-M max
                           5, LUFS-S max
            RenderTable["Normalize_Only_Files_Too_Loud"] - Only normalize files that are too loud,checkbox
                                                         - true, checkbox checked
                                                         - false, checkbox unchecked
            RenderTable["Normalize_Stems_to_Master_Target"] - true, normalize-stems to master target(common gain to stems)
                                                              false, normalize each file individually
            RenderTable["Normalize_Target"] - the normalize-target as dB-value
            RenderTable["NoSilentRender"] - Do not render files that are likely silent-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 
                                                    0, Full-speed Offline
                                                    1, 1x Offline
                                                    2, Online Render
                                                    3, Online Render(Idle)
                                                    4, Offline Render(Idle)
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
            RenderTable["OnlyChannelsSentToParent"] - true, option is checked; false, option is unchecked
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
            RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 
                                                0, Sinc Interpolation: 64pt (medium quality)
                                                1, Linear Interpolation: (low quality)
                                                2, Point Sampling (lowest quality, retro)
                                                3, Sinc Interpolation: 192pt
                                                4, Sinc Interpolation: 384pt
                                                5, Linear Interpolation + IIR
                                                6, Linear Interpolation + IIRx2
                                                7, Sinc Interpolation: 16pt
                                                8, Sinc Interpolation: 512pt(slow)
                                                9, Sinc Interpolation: 768pt(very slow)
                                                10, r8brain free (highest quality, fast)
            RenderTable["RenderStems_Prefader"] - true, option is checked; false, option is unchecked
            RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
            RenderTable["RenderString2"] - the render-cfg-string, that holds all settings of the currently set secondary-render-output-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"] - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; true, checked; false, unchecked
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; true, checked; false, unchecked
            RenderTable["Source"] - 0, Master mix; 
                                    1, Master mix + stems; 
                                    3, Stems (selected tracks); 
                                    8, Region render matrix; 
                                    32, Selected media items; 
                                    64, Selected media items via master; 
                                    128, selected tracks via master
                                    136, Region render matrix via master
                                    4096, Razor edit areas
                                    4224, Razor edit areas via master
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked
                                      &1, custom time bounds; 
                                      &2, entire project; 
                                      &4, time selection; 
                                      &8, all project regions; 
                                      &16, selected media items; 
                                      &32, selected project regions
                                      &64, razor edit areas
            RenderTable["TailMS"] - the amount of milliseconds of the tail
    
    Returns nil in case of an error
  </description>
  <retvals>
    table RenderTable - a table with all of the current project's render-settings
  </retvals>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, get, project, render, rendertable</tags>
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
  if RenderTable["Source"]&256~=0 then RenderTable["Source"]=RenderTable["Source"]-256 RenderTable["EmbedStretchMarkers"]=true else RenderTable["EmbedStretchMarkers"]=false end
  if RenderTable["Source"]&512~=0 then RenderTable["Source"]=RenderTable["Source"]-512 RenderTable["EmbedMetaData"]=true else RenderTable["EmbedMetaData"]=false end
  if RenderTable["Source"]&1024~=0 then RenderTable["Source"]=RenderTable["Source"]-1024 RenderTable["EmbedTakeMarkers"]=true else RenderTable["EmbedTakeMarkers"]=false end
  if RenderTable["Source"]&2048~=0 then RenderTable["Source"]=RenderTable["Source"]-2048 RenderTable["Enable2ndPassRender"]=true else RenderTable["Enable2ndPassRender"]=false end
  if RenderTable["Source"]&8192~=0 then RenderTable["Source"]=RenderTable["Source"]-8192 RenderTable["RenderStems_Prefader"]=true else RenderTable["RenderStems_Prefader"]=false end
  if RenderTable["Source"]&16384~=0 then RenderTable["Source"]=RenderTable["Source"]-16384 RenderTable["OnlyChannelsSentToParent"]=true else RenderTable["OnlyChannelsSentToParent"]=false end
  
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
  RenderTable["AddToProj"]=reaper.GetSetProjectInfo(ReaProject, "RENDER_ADDTOPROJ", 0, false)&1
  if RenderTable["AddToProj"]==1 then RenderTable["AddToProj"]=true else RenderTable["AddToProj"]=false end
  RenderTable["NoSilentRender"]=reaper.GetSetProjectInfo(ReaProject, "RENDER_ADDTOPROJ", 0, false)&2
  if RenderTable["NoSilentRender"]==2 then RenderTable["NoSilentRender"]=true else RenderTable["NoSilentRender"]=false end
  RenderTable["Dither"]=math.tointeger(reaper.GetSetProjectInfo(ReaProject, "RENDER_DITHER", 0, false))
  RenderTable["ProjectSampleRateFXProcessing"]=ultraschall.GetRender_ProjectSampleRateForMix()
  RenderTable["SilentlyIncrementFilename"]=ultraschall.GetRender_AutoIncrementFilename()
  
  RenderTable["RenderQueueDelay"], RenderTable["RenderQueueDelaySeconds"] = ultraschall.GetRender_QueueDelay()
  RenderTable["RenderResample"]=ultraschall.GetRender_ResampleMode()
  RenderTable["OfflineOnlineRendering"]=ultraschall.GetRender_OfflineOnlineMode()
  _temp, RenderTable["RenderFile"]=reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FILE", "", false)
  _temp, RenderTable["RenderPattern"]=reaper.GetSetProjectInfo_String(ReaProject, "RENDER_PATTERN", "", false)
  _temp, RenderTable["RenderString"]=reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FORMAT", "", false)
  _temp, RenderTable["RenderString2"]=reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FORMAT2", "", false)
            
  if reaper.SNM_GetIntConfigVar("renderclosewhendone", -111)&1==0 then
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
  
  RenderTable["Normalize_Method"]=math.tointeger(reaper.GetSetProjectInfo(0, "RENDER_NORMALIZE", 0, false))
  RenderTable["FadeIn"]=reaper.GetSetProjectInfo(0, "RENDER_FADEIN", 0, false)
  RenderTable["FadeOut"]=reaper.GetSetProjectInfo(0, "RENDER_FADEOUT", 0, false)
  RenderTable["FadeIn_Shape"]=math.tointeger(reaper.GetSetProjectInfo(0, "RENDER_FADEINSHAPE", 0, false))
  RenderTable["FadeOut_Shape"]=math.tointeger(reaper.GetSetProjectInfo(0, "RENDER_FADEOUTSHAPE", 0, false))
  
  RenderTable["FadeIn_Enabled"]=RenderTable["Normalize_Method"]&512==512
  if RenderTable["FadeIn_Enabled"]==true then RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-512 end
  RenderTable["FadeOut_Enabled"]=RenderTable["Normalize_Method"]&1024==1024 
  if RenderTable["FadeOut_Enabled"]==true then RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-1024 end
  
  local retval = reaper.GetSetProjectInfo(0, "RENDER_NORMALIZE", 0, false)&1==1
  RenderTable["Normalize_Enabled"]=retval
  if RenderTable["Normalize_Enabled"]==true then RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-1 end
  if reaper.GetSetProjectInfo(0, "RENDER_NORMALIZE_TARGET", 0, false)~="" then
    RenderTable["Normalize_Target"]=ultraschall.MKVOL2DB(reaper.GetSetProjectInfo(0, "RENDER_NORMALIZE_TARGET", 0, false))  
  else
    RenderTable["Normalize_Target"]=-24
  end
  
  if RenderTable["Normalize_Method"]&256==0 then     
    RenderTable["Normalize_Only_Files_Too_Loud"]=false
  elseif RenderTable["Normalize_Method"]&256==256 then
    RenderTable["Normalize_Only_Files_Too_Loud"]=true
    RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-256
  end
 
  if RenderTable["Normalize_Method"]&128==0 then     
    RenderTable["Brickwall_Limiter_Method"]=1    
  elseif RenderTable["Normalize_Method"]&128==128 then
    RenderTable["Brickwall_Limiter_Method"]=2
    RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-128
  end
  
  if RenderTable["Normalize_Method"]&64==64 then 
    RenderTable["Brickwall_Limiter_Enabled"]=true
    RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-64
  elseif RenderTable["Normalize_Method"]&64==0 then 
    RenderTable["Brickwall_Limiter_Enabled"]=false
  end
  
  RenderTable["Brickwall_Limiter_Target"]=ultraschall.MKVOL2DB(reaper.GetSetProjectInfo(0, "RENDER_BRICKWALL", 0, false))
  RenderTable["Normalize_Stems_to_Master_Target"]=RenderTable["Normalize_Method"]&32==32
  if RenderTable["Normalize_Stems_to_Master_Target"]==true then RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-32 end
  RenderTable["Normalize_Method"]=math.tointeger(RenderTable["Normalize_Method"]/2)  
  
  return RenderTable
end


--A=ultraschall.GetRenderTable_Project()


function ultraschall.GetRenderTable_ProjectFile(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTable_ProjectFile</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.71
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.GetRenderTable_ProjectFile(string projectfilename_with_path)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all stored render-settings in a projectfile, as a handy table.
            
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
            RenderTable["Brickwall_Limiter_Enabled"] - true, brickwall limiting is enabled; false, brickwall limiting is disabled            
            RenderTable["Brickwall_Limiter_Method"] - brickwall-limiting-mode; 1, peak; 2, true peak
            RenderTable["Brickwall_Limiter_Target"] - the volume of the brickwall-limit
            RenderTable["Bounds"] - 0, Custom time range; 
                                    1, Entire project; 
                                    2, Time selection; 
                                    3, Project regions; 
                                    4, Selected Media Items(in combination with Source 32); 
                                    5, Selected regions
                                    6, Razor edit areas
                                    7, All project markers
                                    8, Selected markers
            RenderTable["Channels"] - the number of channels in the rendered file; 
                                      1, mono; 
                                      2, stereo; 
                                      higher, the number of channels
            RenderTable["CloseAfterRender"] - true, closes rendering to file-dialog after render; always true, as this isn't stored in projectfiles
            RenderTable["Dither"] - &1, dither master mix; 
                                    &2, noise shaping master mix; 
                                    &4, dither stems; 
                                    &8, dither noise shaping stems
            RenderTable["EmbedMetaData"] - Embed metadata; true, checked; false, unchecked
            RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides; true, checked; false, unchecked
            RenderTable["EmbedTakeMarkers"] - Embed Take markers; true, checked; false, unchecked                        
            RenderTable["Enable2ndPassRender"] - true, 2nd pass render is enabled; false, 2nd pass render is disabled
            RenderTable["Endposition"] - the endposition of the rendering selection in seconds            
            RenderTable["FadeIn_Enabled"] - true, fade-in is enabled; false, fade-in is disabled
            RenderTable["FadeIn"] - the fade-in-time in seconds
            RenderTable["FadeIn_Shape"] - the fade-in-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["FadeOut_Enabled"] - true, fade-out is enabled; false, fade-out is disabled
            RenderTable["FadeOut"] - the fade-out time in seconds
            RenderTable["FadeOut_Shape"] - the fade-out-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["Normalize_Enabled"] - true, normalization enabled; false, normalization not enabled
            RenderTable["Normalize_Method"] - the normalize-method-dropdownlist
                                       0, LUFS-I
                                       1, RMS-I
                                       2, Peak
                                       3, True Peak
                                       4, LUFS-M max
                                       5, LUFS-S max
            RenderTable["Normalize_Stems_to_Master_Target"] - true, normalize-stems to master target(common gain to stems)
                                                              false, normalize each file individually
            RenderTable["Normalize_Target"] - the normalize-target as dB-value
            RenderTable["NoSilentRender"] - Do not render files that are likely silent-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 
                                                    0, Full-speed Offline; 
                                                    1, 1x Offline; 
                                                    2, Online Render; 
                                                    3, Online Render(Idle); 
                                                    4, Offline Render(Idle)
            RenderTable["OnlyChannelsSentToParent"] - true, option is checked; false, option is unchecked
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
            RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 
                                                0, Sinc Interpolation: 64pt (medium quality)
                                                1, Linear Interpolation: (low quality)
                                                2, Point Sampling (lowest quality, retro)
                                                3, Sinc Interpolation: 192pt
                                                4, Sinc Interpolation: 384pt
                                                5, Linear Interpolation + IIR
                                                6, Linear Interpolation + IIRx2
                                                7, Sinc Interpolation: 16pt
                                                8, Sinc Interpolation: 512pt(slow)
                                                9, Sinc Interpolation: 768pt(very slow)
                                                10, r8brain free (highest quality, fast)
            RenderTable["RenderStems_Prefader"] - true, option is checked; false, option is unchecked
            RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
            RenderTable["RenderString2"] - the render-cfg-string, that holds all settings of the currently set secondary-render-output-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"] - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; always true(checked), as this isn't stored in projectfiles
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; always false, as this is not stored in projectfiles
            RenderTable["Source"] - 0, Master mix; 
                                    1, Master mix + stems; 
                                    3, Stems (selected tracks); 
                                    8, Region render matrix; 
                                    32, Selected media items; 
                                    64, selected media items via master; 
                                    128, selected tracks via master
                                    136, Region render matrix via master
                                    4096, Razor edit areas
                                    4224, Razor edit areas via master
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked
                                      &1, custom time bounds; 
                                      &2, entire project; 
                                      &4, time selection; 
                                      &8, all project regions; 
                                      &16, selected media items; 
                                      &32, selected project regions
                                      &64, razor edit areas
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  ultraschall.SuppressErrorMessages(true)
  local render_cfg, render_cfg2 = ultraschall.GetProject_RenderCFG(nil, ProjectStateChunk)
  ultraschall.SuppressErrorMessages(false)

  local resample_mode, playback_resample_mode, project_smplrate4mix_and_fx = ultraschall.GetProject_RenderResample(projectfilename_with_path, ProjectStateChunk)
  
  local RenderTable=ultraschall.CreateNewRenderTable()
  RenderTable["RenderTable"]=true
  RenderTable["Source"]=render_stems
  if render_stems&256~=0 then RenderTable["EmbedStretchMarkers"]=true RenderTable["Source"]=RenderTable["Source"]-256 else RenderTable["EmbedStretchMarkers"]=false end
  if render_stems&512~=0 then RenderTable["Source"]=RenderTable["Source"]-512 RenderTable["EmbedMetaData"]=true elseif render_stems&512==0 then RenderTable["EmbedMetaData"]=false end
  if render_stems&1024~=0 then RenderTable["Source"]=RenderTable["Source"]-1024 RenderTable["EmbedTakeMarkers"]=true elseif render_stems&1024==0 then RenderTable["EmbedTakeMarkers"]=false end
  if render_stems&2048~=0 then RenderTable["Source"]=RenderTable["Source"]-2048 RenderTable["Enable2ndPassRender"]=true elseif render_stems&1024==0 then RenderTable["Enable2ndPassRender"]=false end
  if RenderTable["Source"]&8192~=0 then RenderTable["Source"]=RenderTable["Source"]-8192 RenderTable["RenderStems_Prefader"]=true else RenderTable["RenderStems_Prefader"]=false end
  if RenderTable["Source"]&16384~=0 then RenderTable["Source"]=RenderTable["Source"]-16384 RenderTable["OnlyChannelsSentToParent"]=true else RenderTable["OnlyChannelsSentToParent"]=false end
  
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
  if addmedia_after_render_state&1==1 then RenderTable["AddToProj"]=true else RenderTable["AddToProj"]=false end
  if addmedia_after_render_state&2==2 then RenderTable["NoSilentRender"]=true else RenderTable["NoSilentRender"]=false end
  RenderTable["Dither"]=renderdither_state
 
  
  RenderTable["ProjectSampleRateFXProcessing"]=project_smplrate4mix_and_fx
  if RenderTable["ProjectSampleRateFXProcessing"]==1 then RenderTable["ProjectSampleRateFXProcessing"]=true else RenderTable["ProjectSampleRateFXProcessing"]=false end
  RenderTable["SilentlyIncrementFilename"]=true
  RenderTable["RenderQueueDelay"], RenderTable["RenderQueueDelaySeconds"]=ultraschall.GetProject_RenderQueueDelay(nil, ProjectStateChunk)

  RenderTable["RenderResample"]=resample_mode
  RenderTable["OfflineOnlineRendering"]=ultraschall.GetProject_RenderSpeed(nil, ProjectStateChunk)
  
  RenderTable["RenderFile"]=render_filename
  RenderTable["RenderPattern"]=render_pattern
  if RenderTable["RenderPattern"]==nil then RenderTable["RenderPattern"]="" end
  RenderTable["RenderString"]=render_cfg 
  RenderTable["RenderString2"]=render_cfg2
  
  if RenderTable["RenderString"]==nil then RenderTable["RenderString"]="" end
  if RenderTable["RenderString2"]==nil then RenderTable["RenderString2"]="" end
  
  RenderTable["SaveCopyOfProject"]=false
  RenderTable["CloseAfterRender"]=true
  
  RenderTable["Normalize_Method"], 
  RenderTable["Normalize_Target"], 
  RenderTable["Brickwall_Limiter_Target"],
  RenderTable["FadeIn"],
  RenderTable["FadeOut"],
  RenderTable["FadeIn_Shape"],
  RenderTable["FadeOut_Shape"] = ultraschall.GetProject_Render_Normalize(nil, ProjectStateChunk)
  
  if RenderTable["Brickwall_Limiter_Enabled"]==nil then RenderTable["Brickwall_Limiter_Enabled"]=false end
  if RenderTable["FadeIn"]==nil then RenderTable["FadeIn"]=0.0 end
  if RenderTable["FadeOut"]==nil then RenderTable["FadeOut"]=0.0 end
  if RenderTable["FadeIn_Shape"]==nil then RenderTable["FadeIn_Shape"]=0 end
  if RenderTable["FadeOut_Shape"]==nil then RenderTable["FadeOut_Shape"]=0 end
    
  if RenderTable["Normalize_Method"]==nil then
    RenderTable["Normalize_Method"]=0
    RenderTable["Normalize_Target"]=-24
    RenderTable["Normalize_Enabled"]=false
    RenderTable["Normalize_Stems_to_Master_Target"]=false
    RenderTable["Normalize_Only_Files_Too_Loud"]=false
    
    RenderTable["Brickwall_Limiter_Target"]=0.99999648310761
    RenderTable["Brickwall_Limiter_Method"]=1
    RenderTable["Brickwall_Limiter_Enabled"]=false
  else
    RenderTable["Normalize_Enabled"]=RenderTable["Normalize_Method"]&1==1
    if RenderTable["Normalize_Enabled"]==true then RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-1 end
    RenderTable["Normalize_Target"]=ultraschall.MKVOL2DB(RenderTable["Normalize_Target"])
    RenderTable["Normalize_Stems_to_Master_Target"]=RenderTable["Normalize_Method"]&32==32
  
    if RenderTable["Normalize_Method"]&1024==0 then
      RenderTable["FadeOut_Enabled"]=false
    else
      RenderTable["FadeOut_Enabled"]=true
      RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-1024
    end
  
    if RenderTable["Normalize_Method"]&512==0 then
      RenderTable["FadeIn_Enabled"]=false
    else
      RenderTable["FadeIn_Enabled"]=true
      RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-512
    end
        
    if RenderTable["Normalize_Method"]&256==0 then     
      RenderTable["Normalize_Only_Files_Too_Loud"]=false
    elseif RenderTable["Normalize_Method"]&256==256 then
      RenderTable["Normalize_Only_Files_Too_Loud"]=true
      RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-256
    end
  
    if RenderTable["Normalize_Method"]&128==0 then     
      RenderTable["Brickwall_Limiter_Method"]=1    
    elseif RenderTable["Normalize_Method"]&128==128 then
      RenderTable["Brickwall_Limiter_Method"]=2
      RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-128
    end
      
    if RenderTable["Normalize_Method"]&64==64 then 
      RenderTable["Brickwall_Limiter_Enabled"]=true
      RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-64
    elseif RenderTable["Normalize_Method"]&64==0 then 
      RenderTable["Brickwall_Limiter_Enabled"]=false
    end
      
    RenderTable["Brickwall_Limiter_Target"]=ultraschall.MKVOL2DB(RenderTable["Brickwall_Limiter_Target"])

    if RenderTable["Normalize_Stems_to_Master_Target"]==true then 
      RenderTable["Normalize_Method"]=RenderTable["Normalize_Method"]-32 
    end
    RenderTable["Normalize_Method"]=math.tointeger(RenderTable["Normalize_Method"]/2)
  end
  
  return RenderTable
end


--B=ultraschall.ReadFullFile("c:\\Render-Queue-Documentation.RPP")
--AAA=ultraschall.GetRenderTable_ProjectFile(nil,B)

function ultraschall.GetOutputFormat_RenderCfg(Renderstring, ReaProject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetOutputFormat_RenderCfg</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string outputformat, string renderstring_decoded, string renderstring_encoded = ultraschall.GetOutputFormat_RenderCfg(string Renderstring, optional ReaProject ReaProject)</functioncall>
  <description>
    Returns the output-format set in a render-cfg-string, as stored in rpp-files and the render-presets file reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string outputformat - the outputformat, set in the render-cfg-string
    - The following are valid: 
    - "WAV", "AIFF", "CAF", "AUDIOCD-IMAGE", "DDP", "FLAC", "MP3", "OGG", "Opus", "Video", "Video (Mac)", "Video GIF", "Video LCF", "WAVPACK", "Unknown"
    string renderstring_decoded - the base64-decoded renderstring, which is either the renderstring you've passed or the one from the ReaProject you passed as second parameter
    string renderstring_encoded - the base64-encoded renderstring, which is either the renderstring you've passed or the one from the ReaProject you passed as second parameter
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
    Renderstring2=ultraschall.Base64_Decoder(Renderstring) 
  end

  --print2("9"..Renderstring:sub(1,4).."9")
  
  if Renderstring2:sub(1,4)=="evaw" then return "WAV", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)=="ffia" then return "AIFF", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)=="ffac" then return "CAF", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)==" osi" then return "AUDIOCD-IMAGE", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)==" pdd" then return "DDP", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)=="calf" then return "FLAC", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)=="l3pm" then return "MP3", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)=="vggo" then return "OGG", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)=="SggO" then return "Opus", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)=="PMFF" then return "Video", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)=="FVAX" then return "Video (Mac)", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)==" FIG" then return "Video GIF", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)==" FCL" then return "Video LCF", Renderstring2, Renderstring end
  if Renderstring2:sub(1,4)=="kpvw" then return "WAVPACK", Renderstring2, Renderstring end
    
  return "Unknown", Renderstring2, Renderstring
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
    
    Note: Can also be applied as RecCFG!
    
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, opus</tags>
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
    
    Note: Can also be applied as RecCFG!
    
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, ogg</tags>
</US_DocBloc>
]]

--(Mode, VBR_Quality, CBR_KBPS, ABR_KBPS, ABR_KBPS_MIN, ABR_KBPS_MAX)
  local ini_file=ultraschall.Api_Path.."IniFiles/double_to_int_2.ini"
  if reaper.file_exists(ini_file)==false then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "Ooops", "external render-code-ini-file does not exist. Reinstall Ultraschall-API again, please!", -1) return nil end
  if math.type(Mode)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "Kbps", "Must be an integer!", -2) return nil end
  if type(VBR_Quality)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "VBR_Quality", "Must be a float!", -3) return nil end
  if math.type(CBR_KBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "CBR_KBPS", "Must be an integer!", -4) return nil end
  if math.type(ABR_KBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "ABR_KBPS", "Must be an integer!", -5) return nil end
  if math.type(ABR_KBPS_MIN)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "ABR_KBPS_MIN", "Must be an integer!", -6) return nil end
  if math.type(ABR_KBPS_MAX)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "ABR_KBPS_MAX", "Must be an integer!", -7) return nil end
  if Mode<0 or Mode>2 then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "Mode", "must be between 0 and 2", -8) return nil end
  if VBR_Quality<0 or ultraschall.LimitFractionOfFloat(VBR_Quality,2)>1.0 then ultraschall.AddErrorMessage("CreateRenderCFG_OGG", "VBR_Quality", "must be a float-value between 0 and 1", -9) return nil end
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, ddp</tags>
</US_DocBloc>
]]
  return "IHBkZA=="
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
    
    Note: Can also be applied as RecCFG!
    
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, flac</tags>
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
    
    Note: Can also be applied as RecCFG!
    
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, wavpack</tags>
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
    Ultraschall=4.75
    Reaper=6.71
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidRenderTable(table RenderTable)</functioncall>
  <description>
    returns, if the table RenderTable is a valid RenderTable.
    
    Returns false in case of an error; the error-message contains the faulty table-entry.
  </description>
  <retvals>
    boolean retval - true, RenderTable is a valid RenderTable; false, it is not a valid RenderTable
  </retvals>
  <parameters>
    table RenderTable - the table, that you want to check for validity
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  if type(RenderTable["EmbedStretchMarkers"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"EmbedStretchMarkers\"] must be a boolean", -26) return false end
  if type(RenderTable["RenderString2"])~="string" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"RenderString2\"] must be a string", -17) return false end 
  if type(RenderTable["EmbedTakeMarkers"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"EmbedTakeMarkers\"] must be a boolean", -18) return false end 
  if type(RenderTable["NoSilentRender"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"NoSilentRender\"] must be a boolean", -19) return false end 
  if type(RenderTable["EmbedMetaData"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"EmbedMetaData\"] must be a boolean", -20) return false end
  if type(RenderTable["Enable2ndPassRender"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Enable2ndPassRender\"] must be a boolean", -21) return false end
  
  if type(RenderTable["Normalize_Enabled"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Normalize_Enabled\"] must be a boolean", -22) return false end
  if type(RenderTable["Normalize_Stems_to_Master_Target"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Normalize_Stems_to_Master_Target\"] must be a boolean", -23) return false end
  if type(RenderTable["Normalize_Target"])~="number" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Normalize_Target\"] must be a number", -24) return false end
  if math.type(RenderTable["Normalize_Method"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Normalize_Method\"] must be a number", -25) return false end

  if math.type(RenderTable["Brickwall_Limiter_Method"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Brickwall_Limiter_Method\"] must be an integer", -26) return false end
  if type(RenderTable["Brickwall_Limiter_Enabled"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Brickwall_Limiter_Enabled\"] must be a boolean", -27) return false end
  if type(RenderTable["Brickwall_Limiter_Target"])~="number" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Brickwall_Limiter_Target\"] must be a number", -28) return false end
  if type(RenderTable["Normalize_Only_Files_Too_Loud"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"Normalize_Only_Files_Too_Loud\"] must be a boolean", -29) return false end
  
  if type(RenderTable["FadeIn"])~="number" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"FadeIn\"] must be a number", -30) return false end
  if type(RenderTable["FadeOut"])~="number" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"FadeOut\"] must be a number", -31) return false end
  if type(RenderTable["FadeIn_Enabled"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"FadeIn_Enabled\"] must be a boolean", -32) return false end
  if type(RenderTable["FadeOut_Enabled"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"FadeOut_Enabled\"] must be a boolean", -33) return false end
  if math.type(RenderTable["FadeIn_Shape"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"FadeIn_Shape\"] must be an integer", -34) return false end
  if math.type(RenderTable["FadeOut_Shape"])~="integer" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"FadeOut_Shape\"] must be an integer", -35) return false end
  if type(RenderTable["OnlyChannelsSentToParent"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"OnlyChannelsSentToParent\"] must be a boolean", -36) return false end
  if type(RenderTable["RenderStems_Prefader"])~="boolean" then ultraschall.AddErrorMessage("IsValidRenderTable", "RenderTable", "RenderTable[\"RenderStems_Prefader\"] must be a boolean", -37) return false end

  return true
end

function ultraschall.ApplyRenderTable_Project(RenderTable, apply_rendercfg_string, dirtyness)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyRenderTable_Project</slug>
  <requires>
    Ultraschall=5
    Reaper=6.71
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval, boolean dirty = ultraschall.ApplyRenderTable_Project(table RenderTable, optional boolean apply_rendercfg_string, optional boolean dirtyness)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets all stored render-settings from a RenderTable as the current project-settings.

    Note: On Reaper 6.10, you cannot set AddToProj and NoSilentRender simultaneously due a bug in Reaper; is fixed in higher versions.
            
    Expected table is of the following structure:
    
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; 
                                        true, checked; 
                                        false, unchecked
            RenderTable["Brickwall_Limiter_Enabled"] - true, brickwall limiting is enabled; false, brickwall limiting is disabled            
            RenderTable["Brickwall_Limiter_Method"] - brickwall-limiting-mode; 1, peak; 2, true peak
            RenderTable["Brickwall_Limiter_Target"] - the volume of the brickwall-limit
            RenderTable["Bounds"]    - 0, Custom time range; 
                                       1, Entire project; 
                                       2, Time selection; 
                                       3, Project regions; 
                                       4, Selected Media Items(in combination with Source 32); 
                                       5, Selected regions
                                       6, Razor edit areas
                                       7, All project markers
                                       8, Selected markers
            RenderTable["Channels"] - the number of channels in the rendered file; 
                                          1, mono; 
                                          2, stereo; 
                                          higher, the number of channels
            RenderTable["CloseAfterRender"] - true, close rendering to file-dialog after render; 
                                              false, don't close it
            RenderTable["Dither"] - &1, dither master mix; 
                                    &2, noise shaping master mix; 
                                    &4, dither stems; 
                                    &8, dither noise shaping stems
            RenderTable["EmbedMetaData"]       - Embed metadata; true, checked; false, unchecked
            RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides; true, checked; false, unchecked
            RenderTable["EmbedTakeMarkers"]    - Embed Take markers; true, checked; false, unchecked
            RenderTable["Enable2ndPassRender"] - true, 2nd pass render is enabled; false, 2nd pass render is disabled
            RenderTable["Endposition"]         - the endposition of the rendering selection in seconds
            RenderTable["FadeIn_Enabled"] - true, fade-in is enabled; false, fade-in is disabled
            RenderTable["FadeIn"] - the fade-in-time in seconds
            RenderTable["FadeIn_Shape"] - the fade-in-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["FadeOut_Enabled"] - true, fade-out is enabled; false, fade-out is disabled
            RenderTable["FadeOut"] - the fade-out time in seconds
            RenderTable["FadeOut_Shape"] - the fade-out-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["MultiChannelFiles"]   - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked            
            RenderTable["Normalize_Enabled"]   - true, normalization enabled; 
                                                 false, normalization not enabled
            RenderTable["Normalize_Method"]    - the normalize-method-dropdownlist
                                                     0, LUFS-I
                                                     1, RMS-I
                                                     2, Peak
                                                     3, True Peak
                                                     4, LUFS-M max
                                                     5, LUFS-S max
            RenderTable["Normalize_Only_Files_Too_Loud"] - Only normalize files that are too loud,checkbox
                                                         - true, checkbox checked
                                                         - false, checkbox unchecked
            RenderTable["Normalize_Stems_to_Master_Target"] - true, normalize-stems to master target(common gain to stems)
                                                              false, normalize each file individually
            RenderTable["Normalize_Target"]       - the normalize-target as dB-value    
            RenderTable["NoSilentRender"]         - Do not render files that are likely silent-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 
                                                        0, Full-speed Offline; 
                                                        1, 1x Offline; 
                                                        2, Online Render; 
                                                        3, Online Render(Idle); 
                                                        4, Offline Render(Idle)
            RenderTable["OnlyChannelsSentToParent"] - true, option is checked; false, option is unchecked
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; 
                                               true, checked; 
                                               false, unchecked
            RenderTable["Preserve_Start_Offset"] - true, preserve start-offset-checkbox(with Bounds=4 and Source=32); false, don't preserve
            RenderTable["Preserve_Metadata"] - true, preserve metadata-checkbox; false, don't preserve
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; 
                                                           true, checked; false, unchecked
            RenderTable["RenderFile"]       - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"]    - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 
                                                0, Sinc Interpolation: 64pt (medium quality)
                                                1, Linear Interpolation: (low quality)
                                                2, Point Sampling (lowest quality, retro)
                                                3, Sinc Interpolation: 192pt
                                                4, Sinc Interpolation: 384pt
                                                5, Linear Interpolation + IIR
                                                6, Linear Interpolation + IIRx2
                                                7, Sinc Interpolation: 16pt
                                                8, Sinc Interpolation: 512pt(slow)
                                                9, Sinc Interpolation: 768pt(very slow)
                                                10, r8brain free (highest quality, fast)
            RenderTable["RenderStems_Prefader"] - true, option is checked; false, option is unchecked
            RenderTable["RenderString"]     - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
            RenderTable["RenderString2"]    - the render-cfg-string, that holds all settings of the currently set secondary-render-output-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"]       - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; 
                                                true, checked; 
                                                false, unchecked
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; 
                                                        true, checked
                                                        false, unchecked
            RenderTable["Source"] - 0, Master mix; 
                                    1, Master mix + stems; 
                                    3, Stems (selected tracks); 
                                    8, Region render matrix; 
                                    32, Selected media items; 64, selected media items via master; 
                                    64, selected media items via master; 
                                    128, selected tracks via master
                                    136, Region render matrix via master
                                    4096, Razor edit areas
                                    4224, Razor edit areas via master
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? 
                                        &1, custom time bounds; 
                                        &2, entire project; 
                                        &4, time selection; 
                                        &8, all project regions; 
                                        &16, selected media items; 
                                        &32, selected project regions
                                        &64, razor edit areas
            RenderTable["TailMS"] - the amount of milliseconds of the tail
            
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the render-settings was successful; false, it wasn't successful
    boolean dirty - true, settings have been altered(project is dirty); false, settings haven't been altered(undirty)
  </retvals>
  <parameters>
    table RenderTable - a RenderTable, that contains all render-dialog-settings
    optional boolean apply_rendercfg_string - true or nil, apply it as well; false, don't apply it
    optional boolean dirtyness - true, function set the project to dirty, if any project setting has been altered by RenderTable(only if dirty==true); false and nil, don't set to dirty, if anything changed
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>projectfiles, set, project, rendertable</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("ApplyRenderTable_Project", "RenderTable", "not a valid RenderTable", -1) return false end  
  if dirtyness==true then
    local RenderTable2=ultraschall.GetRenderTable_Project()
    if ultraschall.AreRenderTablesEqual(RenderTable, RenderTable2)==true then return true, false end
  end
  
  if apply_rendercfg_string~=nil and type(apply_rendercfg_string)~="boolean" then ultraschall.AddErrorMessage("ApplyRenderTable_Project", "apply_rendercfg_string", "must be boolean", -2) return false end
  local _temp, retval, hwnd, AddToProj, ProjectSampleRateFXProcessing, ReaProject, SaveCopyOfProject, retval
  if ReaProject==nil then ReaProject=0 end
  local Source=RenderTable["Source"]
  
  if RenderTable["EmbedStretchMarkers"]==true then 
    if Source&256==0 then Source=Source+256 end
  else 
    if Source&256~=0 then Source=Source-256 end
  end
  
  if RenderTable["EmbedMetaData"]==true then 
    if Source&512==0 then Source=Source+512 end
  else 
    if Source&512~=0 then Source=Source-512 end
  end
  
  if RenderTable["EmbedTakeMarkers"]==true then 
    if Source&1024==0 then Source=Source+1024 end
  else 
    if Source&1024~=0 then Source=Source-1024 end
  end
  
  if RenderTable["Enable2ndPassRender"]==true then 
    if Source&2048==0 then Source=Source+2048 end
  else 
    if Source&2048~=0 then Source=Source-2048 end
  end
  
  if RenderTable["Preserve_Start_Offset"]==true then 
    if Source&65536==0 then
      Source=Source+65536
    end
  end
  
  if RenderTable["Preserve_Metadata"]==true then
    if Source&32768==0 then
      Source=Source+32768
    end
  end
  
  if RenderTable["RenderStems_Prefader"]==true then
    if Source&8192==0 then Source=Source+8192 end
  else 
    if Source&8192~=0 then Source=Source-8192 end
  end  
 
  if RenderTable["OnlyChannelsSentToParent"]==true then
    if Source&16384==0 then Source=Source+16384 end
  else 
    if Source&16384~=0 then Source=Source-16384 end
  end  
  
  if RenderTable["MultiChannelFiles"]==true and Source&4==0 then 
    Source=Source+4 
  elseif RenderTable["MultiChannelFiles"]==false and Source&4==4 then 
    Source=Source-4 
  end
  
  if RenderTable["OnlyMonoMedia"]==true and Source&16==0 then 
    Source=Source+16 
  elseif RenderTable["OnlyMonoMedia"]==false and Source&16==16 then 
    Source=Source-16 
  end

  local normalize_method=RenderTable["Normalize_Method"]
  normalize_method=normalize_method*2
  local normalize_target=ultraschall.DB2MKVOL(RenderTable["Normalize_Target"])
  if RenderTable["Normalize_Enabled"]==true and normalize_method&1==0 then normalize_method=normalize_method+1 end
  if RenderTable["Normalize_Enabled"]==false and normalize_method&1==1 then normalize_method=normalize_method-1 end  

  if RenderTable["Normalize_Only_Files_Too_Loud"]==true and normalize_method&256==0 then normalize_method=normalize_method+256 end
  if RenderTable["Normalize_Only_Files_Too_Loud"]==false and normalize_method&256==1 then normalize_method=normalize_method-256 end 

  if RenderTable["Normalize_Stems_to_Master_Target"]==true and normalize_method&32==0 then normalize_method=normalize_method+32 end
  if RenderTable["Normalize_Stems_to_Master_Target"]==false and normalize_method&32==32 then normalize_method=normalize_method-32 end
  
  if RenderTable["Brickwall_Limiter_Enabled"]==true and normalize_method&64==0 then normalize_method=normalize_method+64 end
  if RenderTable["Brickwall_Limiter_Enabled"]==false and normalize_method&64==64 then normalize_method=normalize_method-64 end
  
  if RenderTable["Brickwall_Limiter_Method"]==2 and normalize_method&128==0 then normalize_method=normalize_method+128 end
  if RenderTable["Brickwall_Limiter_Method"]==1 and normalize_method&128==128 then normalize_method=normalize_method-128 end
  
  if RenderTable["FadeIn_Enabled"]==true and normalize_method&512==0 then normalize_method=normalize_method+512 end
  if RenderTable["FadeOut_Enabled"]==true and normalize_method&1024==0 then normalize_method=normalize_method+1024 end
  
  reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FILE", RenderTable["RenderFile"], true)
  reaper.GetSetProjectInfo_String(ReaProject, "RENDER_PATTERN", RenderTable["RenderPattern"], true)
  if apply_rendercfg_string~=false then
    reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FORMAT", RenderTable["RenderString"], true)
    reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FORMAT2", RenderTable["RenderString2"], true)
  end
  
  reaper.GetSetProjectInfo(ReaProject, "RENDER_FADEIN", RenderTable["FadeIn"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_FADEOUT", RenderTable["FadeOut"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_FADEINSHAPE", RenderTable["FadeIn_Shape"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_FADEOUTSHAPE", RenderTable["FadeOut_Shape"], true)
  
  reaper.GetSetProjectInfo(0, "RENDER_BRICKWALL", ultraschall.DB2MKVOL(RenderTable["Brickwall_Limiter_Target"]), true)
  
  reaper.GetSetProjectInfo(ReaProject, "RENDER_NORMALIZE", normalize_method, true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_NORMALIZE_TARGET", normalize_target, true)
  
  reaper.GetSetProjectInfo(ReaProject, "RENDER_SETTINGS",   Source, true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_BOUNDSFLAG", RenderTable["Bounds"], true)
  
  reaper.GetSetProjectInfo(ReaProject, "RENDER_CHANNELS", RenderTable["Channels"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_SRATE", RenderTable["SampleRate"], true)
  
  reaper.GetSetProjectInfo(ReaProject, "RENDER_STARTPOS", RenderTable["Startposition"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_ENDPOS", RenderTable["Endposition"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_TAILFLAG", RenderTable["TailFlag"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_TAILMS", RenderTable["TailMS"], true)
  
  if RenderTable["AddToProj"]==true then AddToProj=1 else AddToProj=0 end
  if RenderTable["NoSilentRender"]==true then AddToProj=AddToProj+2 end

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
  if dirtyness==true then
    reaper.MarkProjectDirty(0)
    return true, true
  end
  return true, false
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
    Ultraschall=5
    Reaper=7.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string ProjectStateChunk = ultraschall.ApplyRenderTable_ProjectFile(table RenderTable, string projectfilename_with_path, optional boolean apply_rendercfg_string, optional string ProjectStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets all stored render-settings from a RenderTable as the current project-settings.
            
    Expected table is of the following structure:
    
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; 
                                        true, checked; 
                                        false, unchecked
            RenderTable["Brickwall_Limiter_Enabled"] - true, brickwall limiting is enabled; false, brickwall limiting is disabled            
            RenderTable["Brickwall_Limiter_Method"] - brickwall-limiting-mode; 1, peak; 2, true peak
            RenderTable["Brickwall_Limiter_Target"] - the volume of the brickwall-limit
            RenderTable["Bounds"]    - 0, Custom time range; 
                                       1, Entire project; 
                                       2, Time selection; 
                                       3, Project regions; 
                                       4, Selected Media Items(in combination with Source 32); 
                                       5, Selected regions
                                       6, Razor edit areas
                                       7, All project markers
                                       8, Selected markers
            RenderTable["Channels"] - the number of channels in the rendered file; 
                                          1, mono; 
                                          2, stereo; 
                                          higher, the number of channels
            RenderTable["CloseAfterRender"] - true, close rendering to file-dialog after render; 
                                              false, don't close it
            RenderTable["Dither"] - &1, dither master mix; 
                                    &2, noise shaping master mix; 
                                    &4, dither stems; 
                                    &8, dither noise shaping stems
            RenderTable["EmbedMetaData"]       - Embed metadata; true, checked; false, unchecked
            RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides; true, checked; false, unchecked
            RenderTable["EmbedTakeMarkers"]    - Embed Take markers; true, checked; false, unchecked
            RenderTable["Enable2ndPassRender"] - true, 2nd pass render is enabled; false, 2nd pass render is disabled
            RenderTable["Endposition"]         - the endposition of the rendering selection in seconds
            RenderTable["FadeIn_Enabled"] - true, fade-in is enabled; false, fade-in is disabled
            RenderTable["FadeIn"] - the fade-in-time in seconds
            RenderTable["FadeIn_Shape"] - the fade-in-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["FadeOut_Enabled"] - true, fade-out is enabled; false, fade-out is disabled
            RenderTable["FadeOut"] - the fade-out time in seconds
            RenderTable["FadeOut_Shape"] - the fade-out-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["MultiChannelFiles"]   - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["Normalize_Enabled"]   - true, normalization enabled; 
                                                 false, normalization not enabled
            RenderTable["Normalize_Only_Files_Too_Loud"] - Only normalize files that are too loud,checkbox
                                                         - true, checkbox checked
                                                         - false, checkbox unchecked
            RenderTable["Normalize_Method"]    - the normalize-method-dropdownlist
                                                     0, LUFS-I
                                                     1, RMS-I
                                                     2, Peak
                                                     3, True Peak
                                                     4, LUFS-M max
                                                     5, LUFS-S max
            RenderTable["Normalize_Stems_to_Master_Target"] - true, normalize-stems to master target(common gain to stems)
                                                              false, normalize each file individually
            RenderTable["Normalize_Target"]       - the normalize-target as dB-value    
            RenderTable["NoSilentRender"]         - Do not render files that are likely silent-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 
                                                        0, Full-speed Offline; 
                                                        1, 1x Offline; 
                                                        2, Online Render; 
                                                        3, Online Render(Idle); 
                                                        4, Offline Render(Idle)
            RenderTable["OnlyChannelsSentToParent"] - true, option is checked; false, option is unchecked
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; 
                                               true, checked; 
                                               false, unchecked
            RenderTable["Preserve_Start_Offset"] - true, preserve start-offset-checkbox(with Bounds=4 and Source=32); false, don't preserve
            RenderTable["Preserve_Metadata"] - true, preserve metadata-checkbox; false, don't preserve
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; 
                                                           true, checked; false, unchecked
            RenderTable["RenderFile"]       - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"]    - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 
                                                0, Sinc Interpolation: 64pt (medium quality)
                                                1, Linear Interpolation: (low quality)
                                                2, Point Sampling (lowest quality, retro)
                                                3, Sinc Interpolation: 192pt
                                                4, Sinc Interpolation: 384pt
                                                5, Linear Interpolation + IIR
                                                6, Linear Interpolation + IIRx2
                                                7, Sinc Interpolation: 16pt
                                                8, Sinc Interpolation: 512pt(slow)
                                                9, Sinc Interpolation: 768pt(very slow)
                                                10, r8brain free (highest quality, fast)
            RenderTable["RenderStems_Prefader"] - true, option is checked; false, option is unchecked
            RenderTable["RenderString"]     - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
            RenderTable["RenderString2"]    - the render-cfg-string, that holds all settings of the currently set secondary-render-output-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"]       - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; 
                                                true, checked; 
                                                false, unchecked
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; 
                                                        true, checked
                                                        false, unchecked
            RenderTable["Source"] - 0, Master mix; 
                                    1, Master mix + stems; 
                                    3, Stems (selected tracks); 
                                    8, Region render matrix; 
                                    32, Selected media items; 64, selected media items via master; 
                                    64, selected media items via master; 
                                    128, selected tracks via master
                                    136, Region render matrix via master
                                    4096, Razor edit areas
                                    4224, Razor edit areas via master
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? 
                                        &1, custom time bounds; 
                                        &2, entire project; 
                                        &4, time selection; 
                                        &8, all project regions; 
                                        &16, selected media items; 
                                        &32, selected project regions
                                        &64, razor edit areas
            RenderTable["TailMS"] - the amount of milliseconds of the tail
            
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the render-settings was successful; false, it wasn't successful
    string ProjectStateChunk - the altered project/ProjectStateChunk as a string
  </retvals>
  <parameters>
    table RenderTable - a RenderTable, that contains all render-dialog-settings
    string projectfilename_with_path - the rpp-projectfile, to which you want to apply the RenderTable; nil, to use parameter ProjectStateChunk instead
    optional boolean apply_rendercfg_string - true or nil, apply it as well; false, don't apply it
    optional parameter ProjectStateChunk - the ProjectStateChunkk, to which you want to apply the RenderTable
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("ApplyRenderTable_ProjectFile", "RenderTable", "not a valid RenderTable", -6) return nil end
  
  local Source=RenderTable["Source"]
  
  if RenderTable["MultiChannelFiles"]==true and Source&4==0 then 
    Source=Source+4 
  elseif RenderTable["MultiChannelFiles"]==false and Source&4==4 then 
    Source=Source-4 
  end
  
  if RenderTable["OnlyMonoMedia"]==true and Source&16==0 then 
    Source=Source+16 
  elseif RenderTable["OnlyMonoMedia"]==false and Source&16==16 then 
    Source=Source-16 
  end
  
  if RenderTable["EmbedStretchMarkers"]==true then 
    if Source&256==0 then 
       Source=Source+256
    end
  else
    if Source&256~=0 then 
       Source=Source-256
    end
  end
    
  if RenderTable["EmbedMetaData"]==true then 
    if Source&512==0 then 
       Source=Source+512
    end
  else
    if Source&512~=0 then 
       Source=Source-512
    end
  end
  
  if RenderTable["EmbedTakeMarkers"]==true then 
    if Source&1024==0 then 
       Source=Source+1024
    end
  else
    if Source&1024~=0 then 
       Source=Source-1024
    end
  end
  if RenderTable["Enable2ndPassRender"]==true then 
    if Source&2048==0 then 
       Source=Source+2048       
    end
  else
    if Source&2048~=0 then 
       Source=Source-2048
    end
  end

  if RenderTable["RenderStems_Prefader"]==true then    
    if Source&8192==0 then Source=Source+8192 end
  else 
    if Source&8192~=0 then Source=Source-8192 end
  end  
 
  if RenderTable["OnlyChannelsSentToParent"]==true then
    if Source&16384==0 then Source=Source+16384 end
  else 
    if Source&16384~=0 then Source=Source-16384 end
  end  

  if RenderTable["Preserve_Start_Offset"]==true then 
    if Source&65536==0 then
      Source=Source+65536
    end
  end
  
  if RenderTable["Preserve_Metadata"]==true then
    if Source&32768==0 then
      Source=Source+32768
    end
  end

  local normalize_method=RenderTable["Normalize_Method"]
  normalize_method=normalize_method*2
  local normalize_target=ultraschall.DB2MKVOL(RenderTable["Normalize_Target"])
  local brickwall_target=ultraschall.DB2MKVOL(RenderTable["Brickwall_Limiter_Target"])
  if RenderTable["Normalize_Enabled"]==true and normalize_method&1==0 then normalize_method=normalize_method+1 end
  if RenderTable["Normalize_Enabled"]==false and normalize_method&1==1 then normalize_method=normalize_method-1 end
  
  if RenderTable["Normalize_Only_Files_Too_Loud"]==true and normalize_method&256==0 then normalize_method=normalize_method+256 end
  if RenderTable["Normalize_Only_Files_Too_Loud"]==false and normalize_method&256==1 then normalize_method=normalize_method-256 end 
  
  if RenderTable["Normalize_Stems_to_Master_Target"]==true and normalize_method&32==0 then normalize_method=normalize_method+32 end
  if RenderTable["Normalize_Stems_to_Master_Target"]==false and normalize_method&32==32 then normalize_method=normalize_method-32 end
  
  if RenderTable["Brickwall_Limiter_Enabled"]==true and normalize_method&64==0 then normalize_method=normalize_method+64 end
  if RenderTable["Brickwall_Limiter_Enabled"]==false and normalize_method&64==64 then normalize_method=normalize_method-64 end
  
  if RenderTable["Brickwall_Limiter_Method"]==1 and normalize_method&128==128 then normalize_method=normalize_method-128 end
  if RenderTable["Brickwall_Limiter_Method"]==2 and normalize_method&128==0 then normalize_method=normalize_method+128 end
  
  if RenderTable["FadeIn_Enabled"]==true and normalize_method&512==0 then normalize_method=normalize_method+512 end
  if RenderTable["FadeOut_Enabled"]==true and normalize_method&1024==0 then normalize_method=normalize_method+1024 end  
  
  retval, ProjectStateChunk = ultraschall.SetProject_Render_Normalize(nil, normalize_method, normalize_target, ProjectStateChunk, brickwall_target, RenderTable["FadeIn"], RenderTable["FadeOut"], RenderTable["FadeInShape"], RenderTable["FadeOutShape"])
    
  retval, ProjectStateChunk = ultraschall.SetProject_RenderStems(nil, Source, ProjectStateChunk)
  retval, ProjectStateChunk = ultraschall.SetProject_RenderRange(nil, RenderTable["Bounds"], RenderTable["Startposition"], RenderTable["Endposition"], RenderTable["TailFlag"], RenderTable["TailMS"], ProjectStateChunk)  
  retval, ProjectStateChunk = ultraschall.SetProject_RenderFreqNChans(nil, 0, RenderTable["Channels"], RenderTable["SampleRate"], ProjectStateChunk)

  if RenderTable["AddToProj"]==true then AddToProj=1 else AddToProj=0 end  
  if RenderTable["NoSilentRender"]==true then AddToProj=AddToProj+2 end 
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
    retval, ProjectStateChunk = ultraschall.SetProject_RenderCFG(nil, RenderTable["RenderString"], RenderTable["RenderString2"], ProjectStateChunk)
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

function ultraschall.CreateNewRenderTable(
Source, Bounds, Startposition, Endposition, TailFlag, 
TailMS, RenderFile, RenderPattern, SampleRate, Channels, 
OfflineOnlineRendering, ProjectSampleRateFXProcessing, RenderResample, OnlyMonoMedia, MultiChannelFiles,
Dither, RenderString, SilentlyIncrementFilename, AddToProj, SaveCopyOfProject, 
RenderQueueDelay, RenderQueueDelaySeconds, CloseAfterRender, EmbedStretchMarkers, RenderString2, 
EmbedTakeMarkers, DoNotSilentRender, EmbedMetadata, Enable2ndPassRender, 
Normalize_Enabled, Normalize_Method, Normalize_Stems_to_Master_Target, Normalize_Target, 
Brickwall_Limiter_Enabled, Brickwall_Limiter_Method, Brickwall_Limiter_Target,
Normalize_Only_Files_Too_Loud, FadeIn_Enabled, FadeIn, FadeIn_Shape, FadeOut_Enabled, FadeOut, FadeOut_Shape, OnlyChannelsSentToParent, RenderStems_Prefader, Preserve_Start_Offset, Preserve_Metadata)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateNewRenderTable</slug>
  <requires>
    Ultraschall=5
    Reaper=7.16
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.CreateNewRenderTable(optional integer Source, optional integer Bounds, optional number Startposition, optional number Endposition, optional integer TailFlag, optional integer TailMS, optional string RenderFile, optional string RenderPattern, optional integer SampleRate, optional integer Channels, optional integer OfflineOnlineRendering, optional boolean ProjectSampleRateFXProcessing, optional integer RenderResample, optional boolean OnlyMonoMedia, optional boolean MultiChannelFiles, optional integer Dither, optional string RenderString, optional boolean SilentlyIncrementFilename, optional boolean AddToProj, optional boolean SaveCopyOfProject, optional boolean RenderQueueDelay, optional integer RenderQueueDelaySeconds, optional boolean CloseAfterRender, optional boolean EmbedStretchMarkers, optional string RenderString2, optional boolean EmbedTakeMarkers, optional boolean DoNotSilentRender, optional boolean EmbedMetadata, optional boolean Enable2ndPassRender, optional boolean Normalize_Enabled, optional integer Normalize_Method, optional boolean Normalize_Stems_to_Master_Target, optional number Normalize_Target, optional boolean Brickwall_Limiter_Enabled, optional integer Brickwall_Limiter_Method, optional number Brickwall_Limiter_Target, optional boolean Normalize_Only_Files_Too_Loud, optional boolean FadeIn_Enabled, optional number FadeIn, optional integer FadeIn_Shape, optional boolean FadeOut_Enabled, optional number FadeOut, optional integer FadeOut_Shape, optional boolean OnlyChannelsSentToParent, optional boolean RenderStems_Prefader, optional boolean Preserve_Start_Offset, optional boolean Preserve_Metadata)</functioncall>
  <description>
    Creates a new RenderTable.
    
    Parameters set to nil will create a rendertable with all entries set to that of a vanilla factory-default Reaper installation:

    Factory-Default will be set to these settings:
              
              RenderTable["AddToProj"]=false
              RenderTable["Brickwall_Limiter_Enabled"]=false
              RenderTable["Brickwall_Limiter_Method"]=1
              RenderTable["Brickwall_Limiter_Target"]=1
              RenderTable["Bounds"]=1
              RenderTable["Channels"]=2
              RenderTable["CloseAfterRender"]=true
              RenderTable["Dither"]=0
              RenderTable["EmbedMetaData"]=false
              RenderTable["EmbedStretchMarkers"]=false
              RenderTable["EmbedTakeMarkers"]=false
              RenderTable["Enable2ndPassRender"]=false
              RenderTable["Endposition"]=0
              RenderTable["FadeIn_Enabled"]=false
              RenderTable["FadeIn"]=0
              RenderTable["FadeIn_Shape"]=0
              RenderTable["FadeOut_Enabled"]=false
              RenderTable["FadeOut"]=0
              RenderTable["FadeOut_Shape"]=false
              RenderTable["MultiChannelFiles"]=false
              RenderTable["Normalize_Enabled"]=false
              RenderTable["Normalize_Only_Files_Too_Loud"]=false
              RenderTable["Normalize_Method"]=0
              RenderTable["Normalize_Stems_to_Master_Target"]=false
              RenderTable["Normalize_Target"]=-24
              RenderTable["NoSilentRender"]=false
              RenderTable["OfflineOnlineRendering"]=0
              RenderTable["OnlyChannelsSentToParent"]=false
              RenderTable["OnlyMonoMedia"]=false
              RenderTable["ProjectSampleRateFXProcessing"]=true
              RenderTable["Preserve_Start_Offset"]=false
              RenderTable["Preserve_Metadata"]=false
              RenderTable["RenderFile"]=""
              RenderTable["RenderPattern"]=""
              RenderTable["RenderQueueDelay"]=false
              RenderTable["RenderQueueDelaySeconds"]=0
              RenderTable["RenderResample"]=3
              RenderTable["RenderStems_Prefader"]=false
              RenderTable["RenderString"]=""
              RenderTable["RenderString2"]=""
              RenderTable["RenderTable"]=true
              RenderTable["SampleRate"]=44100
              RenderTable["SaveCopyOfProject"]=false
              RenderTable["SilentlyIncrementFilename"]=true
              RenderTable["Source"]=0
              RenderTable["Startposition"]=0
              RenderTable["TailFlag"]=18
              RenderTable["TailMS"]=0

    Returns nil in case of an error
  </description>
  <retvals>
    table RenderTable - the created RenderTable
  </retvals>
  <parameters>
    optional integer Source - The Source-dropdownlist; 
                   - 0, Master mix(default)
                   - 1, Master mix + stems
                   - 3, Stems (selected tracks)
                   - 8, Region render matrix
                   - 32, Selected media items
                   - 256, Embed stretch markers/transient guides-checkbox=on; optional, as parameter EmbedStretchMarkers is meant for that
    optional integer Bounds - The Bounds-dropdownlist
                   - 0, Custom time range
                   - 1, Entire project(default)
                   - 2, Time selection
                   - 3, Project regions
                   - 4, Selected Media Items(in combination with Source 32)
                   - 5, Selected regions
                   - 6, Razor edit areas
                   - 7, All project markers
                   - 8, Selected markers
    optional number Startposition - the startposition of the render-section in seconds; only used when Bounds=0(Custom time range); default=0
    optional number Endposition - the endposition of the render-section in seconds; only used when Bounds=0(Custom time range); default=0
    optional integer TailFlag - in which bounds is the Tail-checkbox checked? (default=18)
                     - &1, custom time bounds
                     - &2, entire project
                     - &4, time selection
                     - &8, all project regions
                     - &16, selected media items
                     - &32, selected project regions
    optional integer TailMS - the amount of milliseconds of the tail(default=1000)
    optional string RenderFile - the contents of the Directory-inputbox of the Render to File-dialog; default=""
    optional string RenderPattern - the render pattern as input into the File name-inputbox of the Render to File-dialog; set to "" if you don't want to use it; default=""
    optional integer SampleRate - the samplerate of the rendered file(s); default=44100
    optional integer Channels - the number of channels in the rendered file; 
                     - 1, mono
                     - 2, stereo(default)
                     - 3 and higher, the number of channels
    optional integer OfflineOnlineRendering - Offline/Online rendering-dropdownlist
                                   - 0, Full-speed Offline(default)
                                   - 1, 1x Offline
                                   - 2, Online Render
                                   - 3, Online Render(Idle)
                                   - 4, Offline Render(Idle)
    optional boolean ProjectSampleRateFXProcessing - Use project sample rate for mixing and FX/synth processing-checkbox; true(default), checked; false, unchecked
    optional integer RenderResample - Resample mode-dropdownlist
                                               - 0, Sinc Interpolation: 64pt (medium quality)
                                               - 1, Linear Interpolation: (low quality)
                                               - 2, Point Sampling (lowest quality, retro)
                                               - 3, Sinc Interpolation: 192pt
                                               - 4, Sinc Interpolation: 384pt
                                               - 5, Linear Interpolation + IIR
                                               - 6, Linear Interpolation + IIRx2
                                               - 7, Sinc Interpolation: 16pt
                                               - 8, Sinc Interpolation: 512pt(slow)
                                               - 9, Sinc Interpolation: 768pt(very slow)
                                               - 10, r8brain free (highest quality, fast)
    optional boolean OnlyMonoMedia - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked(default)
    optional boolean MultiChannelFiles - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked(default)
    optional integer Dither - the Dither/Noise shaping-checkboxes; default=0
                   - &1, dither master mix
                   - &2, noise shaping master mix
                   - &4, dither stems
                   - &8, dither noise shaping stems
    optional string RenderString - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
                                 - default is "ZXZhdw==" = WAV, 24 bit PCM, Auto WAV/Wave 64, WriteBWFChunk checked, 
                                 - Include project filename in BWF unchecked, Do not include markers or regions, Embed tempo unchecked.
    optional boolean SilentlyIncrementFilename - Silently increment filenames to avoid overwriting-checkbox; default=true
    optional boolean AddToProj - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked(default)
    optional boolean SaveCopyOfProject - the "Save copy of project to outfile.wav.RPP"-checkbox; default=false
    optional boolean RenderQueueDelay - Delay queued render to allow samples to load-checkbox; default=false
    optional integer RenderQueueDelaySeconds - the amount of seconds for the render-queue-delay; default=0
    optional boolean CloseAfterRender - true, closes rendering to file-dialog after render(default); false, doesn't close it
    optional boolean EmbedStretchMarkers - true, Embed stretch markers/transient guides-checkbox=on; false or nil, Embed stretch markers/transient guides"-checkbox=off(default)
    optional string RenderString2 - the render-string for the secondary rendering; default=""
    optional boolean EmbedTakeMarkers - the "Take markers"-checkbox; true, checked; false, unchecked(default)
    optional boolean DoNotSilentRender - the "Do not render files that are likely silent"-checkbox; true, checked; false, unchecked(default)
    optional boolean EmbedMetadata - the "Embed metadata"-checkbox; true, checked; false, unchecked(default)
    optional boolean Enable2ndPassRender - true, 2nd pass render is enabled; false, 2nd pass render is disabled
    optional boolean Normalize_Enabled - true, normalization enabled; false, normalization not enabled
    optional integer Normalize_Method - the normalize-method-dropdownlist
                                      - 0, LUFS-I
                                      - 1, RMS-I
                                      - 2, Peak
                                      - 3, True Peak
                                      - 4, LUFS-M max
                                      - 5, LUFS-S max
    optional boolean Normalize_Stems_to_Master_Target - true, normalize-stems to master target(common gain to stems); false, normalize each file individually
    optional number Normalize_Target - the normalize-target as dB-value
    optional boolean Brickwall_Limiter_Enabled - true, enable brickwall-limiter
    optional integer Brickwall_Limiter_Method - the brickwall-limiter-method; 1, peak; 2, True Peak
    optional number Brickwall_Limiter_Target - the target of brickwall-limiter in dB
    optional boolean Normalize_Only_Files_Too_Loud - only normalize files that are too loud; true, enabled; false, disabled
    optional boolean FadeIn_Enabled - true, fade in is enabled; false, fade-in is not enabled
    optional number FadeIn - the fade-in in seconds
    optional integer FadeIn_Shape - the fade-in-shape
                                  - 0, Linear fade in
                                  - 1, Inverted quadratic fade in
                                  - 2, Quadratic fade in
                                  - 3, Inverted quartic fade in
                                  - 4, Quartic fade in
                                  - 5, Cosine S-curve fade in
                                  - 6, Quartic S-curve fade in
    optional boolean FadeOut_Enabled - true, fade-out is enabled; false, fade-out is disabled
    optional number FadeOut - the fade-out time in seconds
    optional integer FadeOut_Shape - the fade-out-shape 
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
    optional boolean OnlyChannelsSentToParent - true, will only render channels sent to parent; false, normal rendering
    optional boolean RenderStems_Prefader - true, stems will be rendered pre-fader; false, normal rendering of stems
    optional boolean Preserve_Start_Offset - true, preserve start-offset (when selected media items as source); false, don't preserve start-offset
    optional boolean Preserve_Metadata - true, preserve metadata(when selected media items as source); false, don't preserve metadata
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, create, new, rendertable</tags>
</US_DocBloc>
]]
  if Source~=nil and math.type(Source)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Source", "#1: must be nil or an integer", -20) return end    
  if Bounds~=nil and math.type(Bounds)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Bounds", "#2: must be nil or an integer", -4) return end
  if Startposition~=nil and type(Startposition)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Startposition", "#3: must be nil or an integer", -21) return end
  if Endposition~=nil and type(Endposition)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Endposition", "#4: must be nil or an integer", -7) return end
  if TailFlag~=nil and math.type(TailFlag)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "TailFlag", "#5: must be nil or an integer", -22) return end    
  if TailMS~=nil and math.type(TailMS)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "TailMS", "#6: must be nil or an integer", -23) return end    
  if RenderFile~=nil and type(RenderFile)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderFile", "#7: must be nil or a string", -12) return end 
  if RenderPattern~=nil and type(RenderPattern)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderPattern", "#8: must be nil or a string", -13) return end 
  if SampleRate~=nil and math.type(SampleRate)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SampleRate", "#9: must be nil or an integer", -17) return end
  if Channels~=nil and math.type(Channels)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Channels", "#10: must be nil or an integer", -5) return end
  if OfflineOnlineRendering~=nil and math.type(OfflineOnlineRendering)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "OfflineOnlineRendering", "#11: must be nil or an integer", -9) return end
  if ProjectSampleRateFXProcessing~=nil and type(ProjectSampleRateFXProcessing)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "ProjectSampleRateFXProcessing", "#12: must be nil or a boolean", -11) return end 
  if RenderResample~=nil and math.type(RenderResample)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderResample", "#13: must be nil or an integer", -15) return end
  if OnlyMonoMedia~=nil and type(OnlyMonoMedia)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "OnlyMonoMedia", "#14: must be nil or a boolean", -10) return end 
  if MultiChannelFiles~=nil and type(MultiChannelFiles)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "MultiChannelFiles", "#15: must be nil or a boolean", -8) return end
  if Dither~=nil and math.type(Dither)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Dither", "#16: must be nil or an integer", -6) return end
  if RenderString~=nil and type(RenderString)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderString", "#17: must be nil or a string", -16) return end 
  if SilentlyIncrementFilename~=nil and type(SilentlyIncrementFilename)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SilentlyIncrementFilename", "#18: must be nil or a boolean", -19) return end
  if AddToProj~=nil and type(AddToProj)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "AddToProj", "#19: must be nil or a boolean", -3) return end
  if SaveCopyOfProject~=nil and type(SaveCopyOfProject)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SaveCopyOfProject", "#20: must be nil or a boolean", -18) return end
  if RenderQueueDelay~=nil and type(RenderQueueDelay)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderQueueDelay", "#21: must be nil or a boolean", -14) return end
  if RenderQueueDelaySeconds~=nil and math.type(RenderQueueDelaySeconds)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderQueueDelaySeconds", "#22: must be nil or an integer", -24) return end
  if CloseAfterRender~=nil and type(CloseAfterRender)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "CloseAfterRender", "#23: must be nil or a boolean", -25) return end
    
  if EmbedStretchMarkers~=nil and type(EmbedStretchMarkers)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "#24: EmbedStretchMarkers", "must be nil or boolean", -26) return end
  if RenderString2~=nil and type(RenderString2)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderString2", "#25: must be nil or string", -27) return end
  if EmbedStretchMarkers==nil then EmbedStretchMarkers=false end
  if RenderString2==nil then RenderString2="" end
  
  if EmbedTakeMarkers~=nil and type(EmbedTakeMarkers)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "EmbedTakeMarkers", "#26: must be nil or boolean", -28) return end
  if DoNotSilentRender~=nil and type(DoNotSilentRender)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "DoNotSilentRender", "#27: must be nil or boolean", -29) return end
  
  if EmbedMetadata~=nil and type(EmbedMetadata)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "CloseAfterRender", "#28: must be nil or a boolean", -30) return end
  if Enable2ndPassRender~=nil and type(Enable2ndPassRender)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Enable2ndPassRender", "#29: must be nil or a boolean", -31) return end

  if Normalize_Enabled~=nil and type(Normalize_Enabled)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Normalize_Enabled", "#30: must be nil or a boolean", -32) return end
  if Normalize_Method~=nil and math.type(Normalize_Method)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Normalize_Method", "#31: must be nil or a number", -33) return end
  if Normalize_Stems_to_Master_Target~=nil and type(Normalize_Stems_to_Master_Target)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Normalize_Stems_to_Master_Target", "#32: must be nil or a boolean", -34) return end
  if Normalize_Target~=nil and type(Normalize_Target)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Normalize_Target", "#33: must be nil or a number", -34) return end
  
  if Brickwall_Limiter_Enabled~=nil and type(Brickwall_Limiter_Enabled)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Brickwall_Limiter_Enabled", "#34: must be nil or a boolean", -35) return end
  if Brickwall_Limiter_Method~=nil and math.type(Brickwall_Limiter_Method)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Brickwall_Limiter_Method", "#35: must be nil or an integer", -36) return end
  if Brickwall_Limiter_Target~=nil and type(Brickwall_Limiter_Target)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Brickwall_Limiter_Target", "#36: must be nil or a number", -37) return end
  
  if Normalize_Only_Files_Too_Loud~=nil and type(Normalize_Only_Files_Too_Loud)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Normalize_Only_Files_Too_Loud", "#37: must be nil or boolean", -38) return end
    
  if FadeIn_Enabled~=nil and type(FadeIn_Enabled)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "FadeIn_Enabled", "#38: must be nil or boolean", -39) return end
  if FadeIn~=nil and type(FadeIn)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "FadeIn", "#39: must be nil or a number", -40) return end
  if FadeIn_Shape~=nil and math.type(FadeIn_Shape)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "FadeIn_Shape", "#40: must be nil or an integer", -41) return end
  if FadeOut_Enabled~=nil and type(FadeOut_Enabled)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "FadeOut_Enabled", "#41: must be nil or boolean", -42) return end
  if FadeOut~=nil and type(FadeOut)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "FadeOut", "#42: must be nil or a number", -43) return end
  if FadeOut_Shape~=nil and math.type(FadeOut_Shape)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "FadeOut_Shape", "#43: must be nil or an integer", -44) return end
  
  if OnlyChannelsSentToParent~=nil and type(OnlyChannelsSentToParent)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "OnlyChannelsSentToParent", "#44: must be nil or a boolean", -45) return end  
  if RenderStems_Prefader~=nil and type(RenderStems_Prefader)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderStems_Prefader", "#45: must be nil or a boolean", -46) return end  
  
  if Preserve_Start_Offset~=nil and type(Preserve_Start_Offset)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Preserve_Start_Offset", "#46: must be nil or a boolean", -47) return end  
  if Preserve_Metadata~=nil and type(Preserve_Metadata)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Preserve_Metadata", "#47: must be nil or a boolean", -48) return end  
  
  -- create Reaper-vanilla default RenderTable
  local RenderTable={}  
  RenderTable["AddToProj"]=false
  RenderTable["Bounds"]=1
  RenderTable["Channels"]=2
  RenderTable["CloseAfterRender"]=true
  RenderTable["Dither"]=0
  RenderTable["EmbedMetaData"]=false
  RenderTable["EmbedStretchMarkers"]=false
  RenderTable["EmbedTakeMarkers"]=false
  RenderTable["Endposition"]=0
  RenderTable["MultiChannelFiles"]=false
  RenderTable["NoSilentRender"]=false
  RenderTable["OfflineOnlineRendering"]=0
  RenderTable["OnlyMonoMedia"]=false
  RenderTable["ProjectSampleRateFXProcessing"]=true
  RenderTable["RenderFile"]=""
  RenderTable["RenderPattern"]=""
  RenderTable["RenderQueueDelay"]=false
  RenderTable["RenderQueueDelaySeconds"]=0
  RenderTable["RenderResample"]=3
  RenderTable["RenderString"]="ZXZhdw=="
  RenderTable["RenderString2"]=""
  RenderTable["RenderTable"]=true
  RenderTable["SampleRate"]=44100
  RenderTable["SaveCopyOfProject"]=false
  RenderTable["SilentlyIncrementFilename"]=true
  RenderTable["Source"]=0
  RenderTable["Startposition"]=0
  RenderTable["TailFlag"]=18
  RenderTable["TailMS"]=0
  RenderTable["Enable2ndPassRender"]=false
  RenderTable["Normalize_Enabled"]=false
  RenderTable["Normalize_Method"]=0
  RenderTable["Normalize_Stems_to_Master_Target"]=false
  RenderTable["Normalize_Target"]=-24
  RenderTable["Brickwall_Limiter_Enabled"]=false
  RenderTable["Brickwall_Limiter_Method"]=1
  RenderTable["Brickwall_Limiter_Target"]=1
  RenderTable["Normalize_Only_Files_Too_Loud"]=false
  RenderTable["FadeIn_Enabled"]=false
  RenderTable["FadeIn"]=0
  RenderTable["FadeIn_Shape"]=0
  RenderTable["FadeOut_Enabled"]=false
  RenderTable["FadeOut"]=0
  RenderTable["FadeOut_Shape"]=0
  RenderTable["OnlyChannelsSentToParent"]=false
  RenderTable["RenderStems_Prefader"]=false
  RenderTable["Preserve_Start_Offset"]=false
  RenderTable["Preserve_Metadata"]=false

  -- set all attributes passed via parameters
  if AddToProj~=nil           then RenderTable["AddToProj"]=AddToProj end
  if Bounds~=nil              then RenderTable["Bounds"]=Bounds end
  if Channels~=nil            then RenderTable["Channels"]=Channels end
  if CloseAfterRender~=nil    then RenderTable["CloseAfterRender"]=CloseAfterRender end
  if Dither~=nil              then RenderTable["Dither"]=Dither end
  if EmbedMetadata~=nil       then RenderTable["EmbedMetaData"]=EmbedMetadata end
  if EmbedStretchMarkers~=nil then RenderTable["EmbedStretchMarkers"]=EmbedStretchMarkers end
  if EmbedTakeMarkers~=nil    then RenderTable["EmbedTakeMarkers"]=EmbedTakeMarkers end
  if Endposition~=nil         then RenderTable["Endposition"]=Endposition end
  if MultiChannelFiles~=nil   then RenderTable["MultiChannelFiles"]=MultiChannelFiles end
  if OfflineOnlineRendering~=nil  then RenderTable["OfflineOnlineRendering"]=OfflineOnlineRendering end
  if OnlyMonoMedia~=nil       then RenderTable["OnlyMonoMedia"]=OnlyMonoMedia end
  if ProjectSampleRateFXProcessing~=nil then RenderTable["ProjectSampleRateFXProcessing"]=ProjectSampleRateFXProcessing end
  if RenderFile~=nil          then RenderTable["RenderFile"]=RenderFile end
  if RenderPattern~=nil       then RenderTable["RenderPattern"]=RenderPattern end
  if RenderQueueDelaySeconds~=nil then RenderTable["RenderQueueDelaySeconds"]=RenderQueueDelaySeconds end
  if RenderQueueDelay~=nil    then RenderTable["RenderQueueDelay"]=RenderQueueDelay end
  if RenderResample~=nil      then RenderTable["RenderResample"]=RenderResample end
  if RenderString2~=nil       then RenderTable["RenderString2"]=RenderString2 end
  if RenderString~=nil        then RenderTable["RenderString"]=RenderString end
  if SampleRate~=nil          then RenderTable["SampleRate"]=SampleRate end
  if SaveCopyOfProject~=nil   then RenderTable["SaveCopyOfProject"]=SaveCopyOfProject end
  if DoNotSilentRender~=nil   then RenderTable["NoSilentRender"]=DoNotSilentRender end
  if SilentlyIncrementFilename~=nil then RenderTable["SilentlyIncrementFilename"]=SilentlyIncrementFilename end
  if Source~=nil              then RenderTable["Source"]=Source end
  if Startposition~=nil       then RenderTable["Startposition"]=Startposition end
  if TailFlag~=nil            then RenderTable["TailFlag"]=TailFlag end
  if TailMS~=nil              then RenderTable["TailMS"]=TailMS end
  if Enable2ndPassRender~=nil then RenderTable["Enable2ndPassRender"]=Enable2ndPassRender end
  if Normalize_Enabled~=nil then RenderTable["Normalize_Enabled"]=Normalize_Enabled end
  if Normalize_Method~=nil then RenderTable["Normalize_Method"]=Normalize_Method end
  if Normalize_Stems_to_Master_Target~=nil then RenderTable["Normalize_Stems_to_Master_Target"]=Normalize_Stems_to_Master_Target end
  if Normalize_Target~=nil then RenderTable["Normalize_Target"]=Normalize_Target end
  if Brickwall_Limiter_Enabled~=nil then RenderTable["Brickwall_Limiter_Enabled"]=Brickwall_Limiter_Enabled end
  if Brickwall_Limiter_Method~=nil then RenderTable["Brickwall_Limiter_Method"]=Brickwall_Limiter_Method end
  if Brickwall_Limiter_Target~=nil then RenderTable["Brickwall_Limiter_Target"]=Brickwall_Limiter_Target end
  
  if Normalize_Only_Files_Too_Loud~=nil then RenderTable["Normalize_Only_Files_Too_Loud"]=Normalize_Only_Files_Too_Loud end
  if FadeIn_Enabled~=nil then RenderTable["FadeIn_Enabled"]=FadeIn_Enabled end
  if FadeIn~=nil then RenderTable["FadeIn"]=FadeIn end
  if FadeIn_Shape~=nil then RenderTable["FadeIn_Shape"]=FadeIn_Shape end
  if FadeOut_Enabled~=nil then RenderTable["FadeOut_Enabled"]=FadeOut_Enabled end
  if FadeOut~=nil then RenderTable["FadeOut"]=FadeOut end
  if FadeOut_Shape~=nil then RenderTable["FadeOut_Shape"]=FadeOut_Shape end
  
  if Preserve_Start_Offset~=nil then RenderTable["Preserve_Start_Offset"]=false end
  if Preserve_Metadata~=nil then RenderTable["Preserve_Metadata"]=false end
 
  return RenderTable
end

-- Für Dich zum Testen für zukünftige Parameters:

--[[
A=ultraschall.CreateNewRenderTable(2, 0, 2, 22, 0,                          -- 5
                                     190, "aRenderFile", "apattern", 99, 3, -- 10
                                     3,    false,   2, false, false,        -- 15
                                     1, "", true, true, true,               -- 20
                                     true, 0, true, true, "",               -- 25
                                     true, true, true, true, true,          -- 30
                                     1, true, 1, false, 1,                  -- 35
                                     3, true, true, 1.1, 9,                 -- 40 Brickwall_Limiter_Target plus
                                     true, 1, 9)                            -- 43
                                     SLEM()
--]]
--Source, Bounds, Startposition, Endposition, TailFlag, TailMS, RenderFile, RenderPattern,
--SampleRate, Channels, OfflineOnlineRendering, ProjectSampleRateFXProcessing, RenderResample, OnlyMonoMedia, MultiChannelFiles,
--Dither, RenderString, SilentlyIncrementFilename, AddToProj, SaveCopyOfProject, RenderQueueDelay
-- RenderQueueDelaySeconds, CloseAfterRender, EmbedStretchMarkers, RenderString2, 
-- EmbedTakeMarkers, SilentRender, EmbedMetadata, Enable2ndPassRender, Normalize_Enabled, Normalize_Method, Normalize_Stems_to_Master_Target, Normalize_Target, 
-- Brickwall_Limiter_Enabled, Brickwall_Limiter_Method, Brickwall_Limiter_Target,
-- Normalize_Only_Files_Too_Loud, FadeIn_Enabled, FadeIn, FadeIn_Shape, FadeOut_Enabled, FadeOut, FadeOut_Shape)


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
  <description>
    Gets the current state of the "Save copy of project to outfile.wav.RPP"-checkbox from the Render to File-dialog.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, checkbox is checked; false, checkbox is unchecked
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <description>
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
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <description>
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
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <description>
    Gets the current checkstate of the "Delay queued render to allow samples to load"-checkbox from the Render to File-dialog,
    as well as the length of the queue-render-delay.
  </description>
  <retvals>
    boolean state - true, check the checkbox; false, uncheck the checkbox
    integer length - the number of seconds the delay shall be
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <description>
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
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <description>
    Gets the current state of the "Use project sample rate for mixing and FX/synth processing"-checkbox from the Render to File-dialog.
  </description>
  <retvals>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <description>
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
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
    Ultraschall=4.7
    Reaper=6.20
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetRender_AutoIncrementFilename()</functioncall>
  <description>
    Gets the current state of the "Silently increment filenames to avoid overwriting"-checkbox from the Render to File-dialog.
  </description>
  <retvals>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, get, checkbox, render, auto increment filenames</tags>
</US_DocBloc>
]]
  local SaveCopyOfProject, hwnd, retval, length, state
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    state=reaper.SNM_GetIntConfigVar("renderclosewhendone", 0)
    if state&16==0 then state=0 end
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
     Reaper=6.02
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
   <target_document>US_Api_Functions</target_document>
   <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
   <tags>render management, get, render preset, names</tags>
 </US_DocBloc>
 ]]
  local Output_Preset_Counter=0
  local Output_Preset={}
  local Preset_Counter=0
  local Preset={}
  local Presetname, Presetname2, Quote
 
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
   for A in string.gmatch(A, "(RENDERPRESET_OUTPUT .-)\n") do
    Quote=A:sub(21,21)
    if Quote=="\"" then
      Presetname2=A:match(" [\"](.-)[\"]")
    else
      Quote=""
      Presetname2=A:match("%s(.-)%s")
    end
    Output_Preset_Counter=Output_Preset_Counter+1
    Output_Preset[Output_Preset_Counter]=Presetname2
  end

  for A2 in string.gmatch(A, "<RENDERPRESET.->") do
    Quote=A2:sub(15,15)
    if Quote=="\"" then
      Presetname=A2:match(" [\"](.-)[\"]")
    else
      Quote=""
      Presetname=A2:match("%s(.-)%s")
    end
    Preset_Counter=Preset_Counter+1
    Preset[Preset_Counter]=Presetname
  end
  
  local duplicate_count, duplicate_array = ultraschall.GetDuplicatesFromArrays(Preset, Output_Preset)
  return Output_Preset_Counter, Output_Preset, Preset_Counter, Preset, duplicate_count, duplicate_array 
end

--A,B,C,D,E,F,G=ultraschall.GetRender_AllPresetNames()



function ultraschall.GetRenderPreset_RenderTable(Bounds_Name, Options_and_Format_Name)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>GetRenderPreset_RenderTable</slug>
   <requires>
     Ultraschall=5
     Reaper=7.16
     Lua=5.3
   </requires>
   <functioncall>table RenderTable = ultraschall.GetRenderPreset_RenderTable(string Bounds_Name, string Options_and_Format_Name)</functioncall>
   <description markup_type="markdown" markup_version="1.0.1" indent="default">
     returns a rendertable, that contains all settings of a specific render-preset.
    
     use [GetRenderPreset_Names](#GetRenderPreset_Names) to get the available render-preset-names.
     
     Some settings aren't stored in Presets and will get default values:
     TailMS=0, SilentlyIncrementFilename=false, AddToProj=false, SaveCopyOfProject=false, RenderQueueDelay=false, RenderQueueDelaySeconds=false, NoSilentRender=false
     
     returned table if of the following format:
     
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; 
                                       always false, as this isn't stored in render-presets
            RenderTable["Brickwall_Limiter_Enabled"] - true, brickwall limiting is enabled; false, brickwall limiting is disabled            
            RenderTable["Brickwall_Limiter_Method"] - brickwall-limiting-mode; 1, peak; 2, true peak
            RenderTable["Brickwall_Limiter_Target"] - the volume of the brickwall-limit
            RenderTable["Bounds"]    - 0, Custom time range; 
                                       1, Entire project; 
                                       2, Time selection; 
                                       3, Project regions; 
                                       4, Selected Media Items(in combination with Source 32); 
                                       5, Selected regions
                                       6, Razor edit areas
                                       7, All project markers
                                       8, Selected markers
            RenderTable["Channels"] - the number of channels in the rendered file; 
                                          1, mono; 
                                          2, stereo; 
                                          higher, the number of channels
            RenderTable["CloseAfterRender"] - close rendering to file-dialog after rendering; 
                                              always true, as this isn't stored in render-presets
            RenderTable["Dither"] - &1, dither master mix; 
                                    &2, noise shaping master mix; 
                                    &4, dither stems; 
                                    &8, dither noise shaping stems
            RenderTable["EmbedMetaData"]       - Embed metadata; true, checked; false, unchecked
            RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides; true, checked; false, unchecked
            RenderTable["EmbedTakeMarkers"]    - Embed Take markers; true, checked; false, unchecked
            RenderTable["Enable2ndPassRender"] - true, 2nd pass render is enabled; false, 2nd pass render is disabled
            RenderTable["Endposition"]         - the endposition of the rendering selection in seconds
            RenderTable["FadeIn_Enabled"] - true, fade-in is enabled; false, fade-in is disabled
            RenderTable["FadeIn"] - the fade-in-time in seconds
            RenderTable["FadeIn_Shape"] - the fade-in-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["FadeOut_Enabled"] - true, fade-out is enabled; false, fade-out is disabled
            RenderTable["FadeOut"] - the fade-out time in seconds
            RenderTable["FadeOut_Shape"] - the fade-out-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["MultiChannelFiles"]   - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["Normalize_Enabled"]   - true, normalization enabled; 
                                                 false, normalization not enabled
            RenderTable["Normalize_Only_Files_Too_Loud"] - Only normalize files that are too loud,checkbox
                                                         - true, checkbox checked
                                                         - false, checkbox unchecked
            RenderTable["Normalize_Method"]    - the normalize-method-dropdownlist
                                                     0, LUFS-I
                                                     1, RMS-I
                                                     2, Peak
                                                     3, True Peak
                                                     4, LUFS-M max
                                                     5, LUFS-S max
            RenderTable["Normalize_Stems_to_Master_Target"] - true, normalize-stems to master target(common gain to stems); 
                                                              false, normalize each file individually
            RenderTable["Normalize_Target"]       - the normalize-target as dB-value    
            RenderTable["NoSilentRender"]         - Do not render files that are likely silent-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 
                                                        0, Full-speed Offline; 
                                                        1, 1x Offline; 
                                                        2, Online Render; 
                                                        3, Online Render(Idle); 
                                                        4, Offline Render(Idle)
            RenderTable["OnlyChannelsSentToParent"] - true, option is checked; false, option is unchecked
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; 
                                               true, checked; 
                                               false, unchecked
            RenderTable["Preserve_Start_Offset"] - true, preserve start-offset-checkbox(with Bounds=4 and Source=32); false, don't preserve
            RenderTable["Preserve_Metadata"] - true, preserve metadata-checkbox; false, don't preserve
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; 
                                                           true, checked; false, unchecked
            RenderTable["RenderFile"]       - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"]    - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; 
                                              always false, as this isn't stored in render-presets
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay; 
                                                     always 0, as this isn't stored in render-presets
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 
                                                0, Sinc Interpolation: 64pt (medium quality)
                                                1, Linear Interpolation: (low quality)
                                                2, Point Sampling (lowest quality, retro)
                                                3, Sinc Interpolation: 192pt
                                                4, Sinc Interpolation: 384pt
                                                5, Linear Interpolation + IIR
                                                6, Linear Interpolation + IIRx2
                                                7, Sinc Interpolation: 16pt
                                                8, Sinc Interpolation: 512pt(slow)
                                                9, Sinc Interpolation: 768pt(very slow)
                                                10, r8brain free (highest quality, fast)
            RenderTable["RenderStems_Prefader"] - true, option is checked; false, option is unchecked
            RenderTable["RenderString"]     - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
            RenderTable["RenderString2"]    - the render-cfg-string, that holds all settings of the currently set secondary-render-output-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"]       - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; always false, as this isn't stored in render-presets
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; 
                                                       always true, as this isn't stored in Presets
            RenderTable["Source"] - 0, Master mix; 
                                    1, Master mix + stems; 
                                    3, Stems (selected tracks); 
                                    8, Region render matrix; 
                                    32, Selected media items; 64, selected media items via master; 
                                    64, selected media items via master; 
                                    128, selected tracks via master
                                    136, Region render matrix via master
                                    4096, Razor edit areas
                                    4224, Razor edit areas via master
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? 
                                        &1, custom time bounds; 
                                        &2, entire project; 
                                        &4, time selection; 
                                        &8, all project regions; 
                                        &16, selected media items; 
                                        &32, selected project regions
                                        &64, razor edit areas
            RenderTable["TailMS"] - the amount of milliseconds of the tail; for presets stored in Reaper 6.61 and 
                                  - earlier, it's always 0, as this wasn't stored in render-presets back then

     Returns nil in case of an error
   </description>
   <parameters>
     string Bounds_Name - the name of the Bounds-render-preset you want to get; case-insensitive
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to get; case-insensitive
   </parameters>
   <retvals>
     table RenderTable - a render-table, which contains all settings from a render-preset
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Functions</target_document>
   <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
   <tags>render management, get, render preset, names</tags>
 </US_DocBloc>
 ]]
  if type(Bounds_Name)~="string" then ultraschall.AddErrorMessage("GetRenderPreset_RenderTable", "Bounds_Name", "must be a string", -1) return end
  if type(Options_and_Format_Name)~="string" then ultraschall.AddErrorMessage("GetRenderPreset_RenderTable", "Options_and_Format_Name", "must be a string", -2) return end
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")  
  if A==nil then A="" end
  local RenderTable={}

  local Presetname, SampleRate, Channels, Offline_online_dropdownlist, found
  local Useprojectsamplerate_checkbox, Resamplemode_dropdownlist, Various_checkboxes, Various_checkboxes2, k1
  local rendercfg, Presetname, rendercfg2
  local Presetname2, Bounds_dropdownlist2, Start_position2, Endposition2
  local Source_dropdownlist_and_checkboxes2, Unknown2, Outputfilename_renderpattern2
  local Tail_checkbox2, Quote
  local B, _temp, path, _temp2

  -- bounds-presets
  for A in string.gmatch(A, "(RENDERPRESET_OUTPUT .-)\n") do
    
    Quote=A:sub(21,21)
    if Quote=="\"" then
      Presetname2=A:match(" [\"](.-)[\"]")
    else
      Quote=""
      Presetname2=A:match("%s(.-)%s")
    end
    
    B=A:sub(0,20).."A"..A:sub(21+Quote:len()+Quote:len()+Presetname2:len(),-1)
    
    if B:match("%s.-%s.-%s.-%s.-%s.-%s.-%s(.)")=="\"" then
    
      Quote="\""
      Outputfilename_renderpattern2=B:match("\"(.-)\"")
    else
      Quote=""
      Outputfilename_renderpattern2=B:match("%s.-%s.-%s.-%s.-%s.-%s.-%s.-(.-)%s.*")

    end
    B=B.." "
    B=string.gsub(B, Quote..Outputfilename_renderpattern2..Quote, "A").." "    
 
    _temp, Bounds_dropdownlist2, Start_position2, Endposition2,
    Source_dropdownlist_and_checkboxes2, Unknown2, _temp2,
    Tail_checkbox2, offset=
    B:match(".- (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) ()")--\"(.*)\"")--%s(.-) ")
    local B2=B:sub(offset, -1)
    
    path, offset=B2:match("\"(.-)\"() ")    
    if path==nil then path, offset=B2:match("(.-)() ") end
    local Tail_MS=tonumber(B2:sub(offset, -1))
    --print2(path)
    
    if Presetname2:lower()==Bounds_Name:lower() then found=true break end
  end
  
  if found~=true then ultraschall.AddErrorMessage("GetRenderPreset_RenderTable", "Bounds_Name", "no such preset", -3) return end
  found=nil

  -- options
  for A2 in string.gmatch(A, "<RENDERPRESET.->") do
    A2=A2.." "
    rendercfg=A2:match(".-\n%s*(.-)\n")
    Quote=A2:sub(15,15)
    
    if Quote=="\"" then
      Presetname=A2:match(" [\"](.-)[\"]")
    else
      Quote=""
      Presetname=A2:match("%s(.-)%s")
    end
    
    A2=A2:sub(0,14).."A"..A2:sub(15+Quote:len()+Quote:len()+Presetname:len(),-1)
  
    _temp, SampleRate, Channels, Offline_online_dropdownlist, 
    Useprojectsamplerate_checkbox, Resamplemode_dropdownlist, Various_checkboxes, Various_checkboxes2
    =A2:match(".- (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) ")
    if Various_checkboxes2=="" then
      -- management of old Reaper5-render-presets; hopefully, I can remove that code one day...sigh
      _temp, SampleRate, Channels, Offline_online_dropdownlist, 
      Useprojectsamplerate_checkbox, Resamplemode_dropdownlist, Various_checkboxes, Various_checkboxes2
      =A2:match(".- (.-) (.-) (.-) (.-) (.-) (.-) (.-) ")
      Various_checkboxes2=Source_dropdownlist_and_checkboxes2
      Source_dropdownlist_and_checkboxes2=Source_dropdownlist_and_checkboxes2&4-Various_checkboxes2
    end
    
    if Presetname:lower()==Options_and_Format_Name:lower() then found=true break end
  end
  
  --normalization-presets
  local Normalize_Method=0
  local Normalize_Target=0.063096
  local Brickwall_Target=1.122018
  for A in string.gmatch(A, "(RENDERPRESET_EXT .-)\n") do
    Quote=A:sub(21,21)
    if Quote=="\"" then
      Presetname2=A:match(" [\"](.-)[\"]")
    else
      Quote=""
      Presetname2=A:match("%s(.-)%s")
    end
    local A1, A2, A3, A4, A5, A6, A7 = A:match(".* (%d-) (.*) (.*) (.*) (.*) (.*) (.*)")

    if A1==nil then
      A1, A2=A:match(".* (%d-) (.*)")
      A3=0
    end
    if A1~=nil then 
      Normalize_Method, Normalize_Target, Brickwall_Target, FadeIn_Length, FadeOut_Length, FadeIn_Shape, FadeOut_Shape 
        = 
      tonumber(A1), tonumber(A2), tonumber(A3), tonumber(A4), tonumber(A5), tonumber(A6), tonumber(A7)
    end
    
    if Presetname2==Options_and_Format_Name then found=true break end
  end
  
  if found~=true then ultraschall.AddErrorMessage("GetRenderPreset_RenderTable", "Options_and_Format_Name", "no such preset", -4) return end
  found=nil
  
  --Presetname=nil
  
  for A2, A3 in string.gmatch(A, "<RENDERPRESET2 (.-)\n(.->)") do
    
    if A2:sub(1,1)=="\"" then A2=A2:sub(2,-2) end    
    rendercfg2=A3:match(".-%s*(.-)\n")

    if Presetname==Options_and_Format_Name then found=true break end
  end
  
  if found~=true then rendercfg2="" end
  
  if rendercfg2==nil then rendercfg2="" end
  RenderTable["AddToProj"]=false
  RenderTable["Bounds"]=tonumber(Bounds_dropdownlist2)
  RenderTable["Channels"]=tonumber(Channels)
  RenderTable["CloseAfterRender"]=true
  RenderTable["Endposition"]=tonumber(Endposition2)
  RenderTable["OfflineOnlineRendering"]=tonumber(Offline_online_dropdownlist)
  RenderTable["ProjectSampleRateFXProcessing"]=useprojectsamplerate_checkbox~=1
  RenderTable["RenderFile"]=string.gsub(path, "\"", "")
  RenderTable["RenderPattern"]=Outputfilename_renderpattern2
  RenderTable["RenderQueueDelay"]=false
  RenderTable["RenderQueueDelaySeconds"]=0
  RenderTable["RenderResample"]=tonumber(Resamplemode_dropdownlist)
  RenderTable["RenderString"]=rendercfg
  RenderTable["RenderString2"]=rendercfg2
  RenderTable["RenderTable"]=true
  RenderTable["SampleRate"]=tonumber(SampleRate)
  RenderTable["SaveCopyOfProject"]=false
  RenderTable["SilentlyIncrementFilename"]=true
  RenderTable["Startposition"]=tonumber(Start_position2)
  RenderTable["TailFlag"]=tonumber(Tail_checkbox2)
  RenderTable["TailMS"]=tonumber(Tail_MS)
  if RenderTable["TailMS"]==nil then RenderTable["TailMS"]=0 end
  RenderTable["MultiChannelFiles"]=tonumber(Various_checkboxes2)&4==4
  RenderTable["OnlyMonoMedia"]=tonumber(Various_checkboxes2)&16==16
  RenderTable["EmbedStretchMarkers"]=tonumber(Various_checkboxes2)&256==256
  RenderTable["EmbedTakeMarkers"]=tonumber(Various_checkboxes2)&1024==1024
  RenderTable["NoSilentRender"]=false
  RenderTable["Source"]=tonumber(Source_dropdownlist_and_checkboxes2)
  RenderTable["Dither"]=tonumber(Various_checkboxes)
  RenderTable["EmbedMetaData"]=tonumber(Various_checkboxes2)&512==512
  RenderTable["Enable2ndPassRender"]=tonumber(Various_checkboxes2)&2048==2048
  RenderTable["OnlyChannelsSentToParent"]=tonumber(Various_checkboxes2)&16384==16384
  RenderTable["RenderStems_Prefader"]=tonumber(Various_checkboxes2)&8192==8192
  RenderTable["Normalize_Enabled"]=Normalize_Method&1==1  
  RenderTable["Normalize_Stems_to_Master_Target"]=Normalize_Method&32==32
  RenderTable["Preserve_Start_Offset"]=tonumber(Various_checkboxes2)&65536==65536
  RenderTable["Preserve_Metadata"]=tonumber(Various_checkboxes2)&32768==32768
  if RenderTable["Normalize_Enabled"]==true then Normalize_Method=Normalize_Method-1 end
  if RenderTable["Normalize_Stems_to_Master_Target"]==true then Normalize_Method=Normalize_Method-32 end
  RenderTable["Brickwall_Limiter_Enabled"]=Normalize_Method&64==64
  if RenderTable["Brickwall_Limiter_Enabled"]==true then Normalize_Method=Normalize_Method-64 end
  if Normalize_Method&128==128 then 
    RenderTable["Brickwall_Limiter_Method"]=2
    Normalize_Method=Normalize_Method-128
  else
    RenderTable["Brickwall_Limiter_Method"]=1
  end  
  
  if Normalize_Method&256==0 then     
    RenderTable["Normalize_Only_Files_Too_Loud"]=false
  elseif Normalize_Method&256==256 then
    RenderTable["Normalize_Only_Files_Too_Loud"]=true
    Normalize_Method=Normalize_Method-256
  end
  
  if Normalize_Method&512==0 then     
    RenderTable["FadeIn_Enabled"]=false
  elseif Normalize_Method&512==512 then
    RenderTable["FadeIn_Enabled"]=true
    Normalize_Method=Normalize_Method-512
  end
  
    if Normalize_Method&1024==0 then     
    RenderTable["FadeOut_Enabled"]=false
  elseif Normalize_Method&1024==1024 then
    RenderTable["FadeOut_Enabled"]=true
    Normalize_Method=Normalize_Method-1024
  end  
  
  if FadeIn_Length==nil then RenderTable["FadeIn"]=0 else RenderTable["FadeIn"]=FadeIn_Length end
  if FadeOut_Length==nil then RenderTable["FadeOut"]=0 else RenderTable["FadeOut"]=FadeOut_Length end
  if FadeIn_Shape==nil then RenderTable["FadeIn_Shape"]=0 else RenderTable["FadeIn_Shape"]=FadeIn_Shape end
  if FadeOut_Shape==nil then RenderTable["FadeOut_Shape"]=0 else RenderTable["FadeOut_Shape"]=FadeOut_Shape end
  
  RenderTable["Brickwall_Limiter_Target"]=ultraschall.MKVOL2DB(Brickwall_Target)
  
  RenderTable["Normalize_Method"]=math.tointeger(Normalize_Method/2)
  RenderTable["Normalize_Target"]=ultraschall.MKVOL2DB(Normalize_Target)
  
  

  return RenderTable
end

--OOO=ultraschall.GetRenderPreset_RenderTable("A127", "A17")

function ultraschall.DeleteRenderPreset_Bounds(Bounds_Name)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>DeleteRenderPreset_Bounds</slug>
   <requires>
     Ultraschall=4.7
     Reaper=6.02
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
     string Bounds_Name - the name of the Bounds-render-preset you want to get; case-insensitive
   </parameters>
   <retvals>
     boolean retval - true, deleting was successful; false, deleting was unsuccessful
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Functions</target_document>
   <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
   <tags>render management, delete, render preset, names, bounds</tags>
 </US_DocBloc>
 ]]
  if type(Bounds_Name)~="string" then ultraschall.AddErrorMessage("DeleteRenderPreset_Bounds", "Bounds_Name", "must be a string", -1) return false end
  local Options_and_Format_Name
  Bounds_Name, Options_and_Format_Name=ultraschall.ResolvePresetName(Bounds_Name, Options_and_Format_Name)
  local A,B
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  if Bounds_Name:match("%s") then Bounds_Name="\""..Bounds_Name.."\"" end
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
     Ultraschall=4.7
     Reaper=6.32
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
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to get; case-insensitive
   </parameters>
   <retvals>
     boolean retval - true, deleting was successful; false, deleting was unsuccessful
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Functions</target_document>
   <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
   <tags>render management, delete, render preset, names, format options</tags>
 </US_DocBloc>
 ]]
  if type(Options_and_Format_Name)~="string" then ultraschall.AddErrorMessage("DeleteRenderPreset_FormatOptions", "Options_and_Format_Name", "must be a string", -1) return false end
  local Bounds_Name
  Bounds_Name, Options_and_Format_Name=ultraschall.ResolvePresetName(Bounds_Name, Options_and_Format_Name)
  local A,B
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  if Options_and_Format_Name:match("%s") then Options_and_Format_Name="\""..Options_and_Format_Name.."\"" end
  B=string.gsub(A, "<RENDERPRESET "..Options_and_Format_Name.." (.-\n>)\n", "")
  B=string.gsub(B, "<RENDERPRESET2 "..Options_and_Format_Name.."(.-\n>)\n", "")
  B=string.gsub(B, "RENDERPRESET_EXT "..Options_and_Format_Name.." .-\n", "")

  if A==B then ultraschall.AddErrorMessage("DeleteRenderPreset_FormatOptions", "Options_and_Format_Name", "no such Options and Format-preset", -2) return false end
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
     Ultraschall=5
     Reaper=7.16
     Lua=5.3
   </requires>
   <functioncall>boolean retval = ultraschall.AddRenderPreset(string Bounds_Name, string Options_and_Format_Name, table RenderTable)</functioncall>
   <description>
     adds a new render-preset into reaper-render.ini. 
     
     This function will check, whether the chosen names are already in use. 
     
     Added render-presets are available after (re-)opening in the Render to File-dialog     
     
     Note: You can choose, whether to include only Bounds, only RenderFormatOptions of both. The Bounds and the RenderFormatOptions store different parts of the render-presets.
     
     Some settings aren't stored in Presets and will be ignored:
     TailMS=0(Reaper 6.61 and earlier), SilentlyIncrementFilename=false, AddToProj=false, SaveCopyOfProject=false, RenderQueueDelay=false, RenderQueueDelaySeconds=false, NoSilentRender=false
     
     Bounds_Name stores only:
              RenderTable["Bounds"] - the bounds-dropdownlist, 
                                      0, Custom time range
                                      1, Entire project 
                                      2, Time selection 
                                      3, Project regions
                                      4, Selected Media Items(in combination with Source 32)
                                      5, Selected regions 
                                      6, Razor edit areas
                                      7, All project markers
                                      8, Selected markers
              RenderTable["Startposition"] - the startposition of the render
              RenderTable["Endposition"] - the endposition of the render
              RenderTable["Source"] - the source dropdownlist, includes 
                                      0, Master mix 
                                      1, Master mix + stems
                                      3, Stems (selected tracks)
                                      8, Region render matrix
                                      32, Selected media items
                                      64, selected media items via master
                                      128, selected tracks via master
                                      136, Region render matrix via master
                                      4096, Razor edit areas
                                      4224, Razor edit areas via master
              RenderTable["RenderPattern"] - the renderpattern, which hold also the wildcards
              RenderTable["RenderFile"] - the output-path
              RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? 
                                        &1, custom time bounds
                                        &2, entire project
                                        &4, time selection
                                        &8, all project regions
                                        &16, selected media items
                                        &32, selected project regions
              RenderTable["TailMS"] - the length of the tail in milliseconds(Reaper 6.62+)
     
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
                                                0, Sinc Interpolation: 64pt (medium quality)
                                                1, Linear Interpolation: (low quality)
                                                2, Point Sampling (lowest quality, retro)
                                                3, Sinc Interpolation: 192pt
                                                4, Sinc Interpolation: 384pt
                                                5, Linear Interpolation + IIR
                                                6, Linear Interpolation + IIRx2
                                                7, Sinc Interpolation: 16pt
                                                8, Sinc Interpolation: 512pt(slow)
                                                9, Sinc Interpolation: 768pt(very slow)
                                                10, r8brain free (highest quality, fast)
              RenderTable["Dither"] - the Dither/Noise shaping-checkboxes: 
                                      &1, dither master mix
                                      &2, noise shaping master mix
                                      &4, dither stems
                                      &8, dither noise shaping stems
              RenderTable["MultiChannelFiles"] - multichannel-files-checkbox
              RenderTable["Normalize_Enabled"] - true, normalization enabled; false, normalization not enabled
              RenderTable["Normalize_Only_Files_Too_Loud"] - Only normalize files that are too loud,checkbox
                                             - true, checkbox checked
                                             - false, checkbox unchecked
              RenderTable["Normalize_Method"] - the normalize-method-dropdownlist
                                                0, LUFS-I
                                                1, RMS-I
                                                2, Peak
                                                3, True Peak
                                                4, LUFS-M max
                                                5, LUFS-S max
              RenderTable["Normalize_Stems_to_Master_Target"] - true, normalize-stems to master target(common gain to stems)
                                                                false, normalize each file individually
              RenderTable["Normalize_Target"] - the normalize-target as dB-value
              RenderTable["OnlyChannelsSentToParent"] - true, option is checked; false, option is unchecked
              RenderTable["RenderStems_Prefader"] - true, option is checked; false, option is unchecked
              RenderTable["OnlyMonoMedia"] - only mono media-checkbox
              RenderTable["EmbedMetaData"] - Embed metadata; true, checked; false, unchecked
              RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides-checkbox
              RenderTable["EmbedTakeMarkers"] - Embed Take markers-checkbox
              RenderTable["Enable2ndPassRender"] - true, 2nd pass render is enabled; false, 2nd pass render is disabled
              RenderTable["Preserve_Start_Offset"] - true, preserve start-offset-checkbox(with Bounds=4 and Source=32); false, don't preserve
              RenderTable["Preserve_Metadata"] - true, preserve metadata-checkbox; false, don't preserve
              RenderTable["RenderString"] - the render-cfg-string, which holds the render-outformat-settings
              RenderTable["RenderString2"] - the render-cfg-string, which holds the secondary render-outformat-settings
              RenderTable["Brickwall_Limiter_Enabled"] - true, brickwall limiting is enabled; false, brickwall limiting is disabled
              RenderTable["Brickwall_Limiter_Method"] - brickwall-limiting-mode; 1, peak; 2, true peak
              RenderTable["Brickwall_Limiter_Target"] - the volume of the brickwall-limit
              RenderTable["FadeIn_Enabled"] - true, fade-in is enabled; false, fade-in is disabled
              RenderTable["FadeIn"] - the fade-in-time in seconds
              RenderTable["FadeIn_Shape"] - the fade-in-shape
                                     - 0, Linear fade in
                                     - 1, Inverted quadratic fade in
                                     - 2, Quadratic fade in
                                     - 3, Inverted quartic fade in
                                     - 4, Quartic fade in
                                     - 5, Cosine S-curve fade in
                                     - 6, Quartic S-curve fade in
              RenderTable["FadeOut_Enabled"] - true, fade-out is enabled; false, fade-out is disabled
              RenderTable["FadeOut"] - the fade-out time in seconds
              RenderTable["FadeOut_Shape"] - the fade-out-shape
                                     - 0, Linear fade in
                                     - 1, Inverted quadratic fade in
                                     - 2, Quadratic fade in
                                     - 3, Inverted quartic fade in
                                     - 4, Quartic fade in
                                     - 5, Cosine S-curve fade in
                                     - 6, Quartic S-curve fade in
  
     Returns false in case of an error
   </description>
   <parameters>
     string Bounds_Name - the name of the Bounds-render-preset you want to add; nil, to not add a new Bounds-render-preset
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to add; to not add a new Render-Format-Options-render-preset
     table RenderTable - the RenderTable, which holds all information for inclusion into the Render-Preset
   </parameters>
   <retvals>
     boolean retval - true, adding was successful; false, adding was unsuccessful
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Functions</target_document>
   <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
   <tags>render management, add, render preset, names, format options, bounds, rendertable</tags>
 </US_DocBloc>
 ]]
  if Bounds_Name==nil and Options_and_Format_Name==nil then  ultraschall.AddErrorMessage("AddRenderPreset", "RenderTable/Options_and_Format_Name", "can't be both set to nil", -6) return false end
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("AddRenderPreset", "RenderTable", "must be a valid render-table", -1) return false end
  if Bounds_Name~=nil and type(Bounds_Name)~="string" then   ultraschall.AddErrorMessage("AddRenderPreset", "Bounds_Name", "must be a string", -2) return false end
  if Options_and_Format_Name~=nil and type(Options_and_Format_Name)~="string" then ultraschall.AddErrorMessage("AddRenderPreset", "Options_and_Format_Name", "must be a string", -3) return false end
  
  local A,B, Source, RenderPattern, ProjectSampleRateFXProcessing, String, String2, Checkboxes
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  
  local CheckBoxes=0
  if RenderTable["MultiChannelFiles"]==true then CheckBoxes=CheckBoxes+4 end
  if RenderTable["OnlyMonoMedia"]==true then CheckBoxes=CheckBoxes+16 end
  if RenderTable["EmbedStretchMarkers"]==true then CheckBoxes=CheckBoxes+256 end
  if RenderTable["EmbedMetaData"]==true then CheckBoxes=CheckBoxes+512 end
  if RenderTable["EmbedTakeMarkers"]==true then CheckBoxes=CheckBoxes+1024 end
  if RenderTable["Enable2ndPassRender"]==true then CheckBoxes=CheckBoxes+2048 end
  if RenderTable["RenderStems_Prefader"]==true then CheckBoxes=CheckBoxes+8192 end
  if RenderTable["OnlyChannelsSentToParent"]==true then CheckBoxes=CheckBoxes+16384 end
  
  if RenderTable["Preserve_Start_Offset"]==true then CheckBoxes=CheckBoxes+65536 end
  if RenderTable["Preserve_Metadata"]==true then CheckBoxes=CheckBoxes+32768 end
  
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

  if RenderPattern:match("%s") and RenderPattern:match("\"")==nil then RenderPattern="\""..RenderPattern.."\"" end
  if Options_and_Format_Name:match("%s") and Options_and_Format_Name:match("\"")==nil then Options_and_Format_Name="\""..Options_and_Format_Name.."\"" end
  if Bounds_Name:match("%s") and Bounds_Name:match("\"")==nil then Bounds_Name="\""..Bounds_Name.."\"" end
  
  -- add Bounds-preset, if given
  if Bounds_Name~=nil then 
    String="\nRENDERPRESET_OUTPUT "..Bounds_Name.." "..RenderTable["Bounds"]..
           " "..RenderTable["Startposition"]..
           " "..RenderTable["Endposition"]..
           " "..RenderTable["Source"]..
           " ".."0"..
           " "..RenderPattern..
           " "..RenderTable["TailFlag"]..
           " \""..RenderTable["RenderFile"].."\" "..
           RenderTable["TailMS"].."\n"
    A=A..String
  end
  
  -- add Format-options-preset, if given
  if Options_and_Format_Name~=nil then 
      String="<RENDERPRESET "..Options_and_Format_Name..
             " "..RenderTable["SampleRate"]..
             " "..RenderTable["Channels"]..
             " "..RenderTable["OfflineOnlineRendering"]..
             " "..ProjectSampleRateFXProcessing..
             " "..RenderTable["RenderResample"]..
             " "..RenderTable["Dither"]..
             " "..CheckBoxes..
             "\n  "..RenderTable["RenderString"].."\n>"
             
      if RenderTable["RenderString2"]~="" then
        String2="\n<RENDERPRESET2 "..Options_and_Format_Name..
             "\n  "..RenderTable["RenderString2"].."\n>"
      else String2=""
      end
      local normalize_method=RenderTable["Normalize_Method"]*2
      if RenderTable["Normalize_Enabled"]==true then normalize_method=normalize_method+1 end
      if RenderTable["Normalize_Stems_to_Master_Target"]==true then normalize_method=normalize_method+32 end      
      if RenderTable["Brickwall_Limiter_Enabled"]==true then normalize_method=normalize_method+64 end
      if RenderTable["Brickwall_Limiter_Method"]==2 then normalize_method=normalize_method+128 end
      if RenderTable["Normalize_Only_Files_Too_Loud"]==true then normalize_method=normalize_method+256 end
      local brickwall_target=ultraschall.DB2MKVOL(RenderTable["Brickwall_Limiter_Target"])
      local normalize_target=ultraschall.DB2MKVOL(RenderTable["Normalize_Target"])
      --local String3="\nRENDERPRESET_EXT "..Options_and_Format_Name.." "..normalize_method.." "..normalize_target.." "..brickwall_target
      local String3="\nRENDERPRESET_EXT "..Options_and_Format_Name.." "..normalize_method.." "..normalize_target.." "..brickwall_target.." "..RenderTable["FadeIn"].." "..RenderTable["FadeOut"].." "..RenderTable["FadeIn_Shape"].." "..RenderTable["FadeOut_Shape"]
      A=A..String..String2..String3
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
     Ultraschall=5
     Reaper=7.16
     Lua=5.3
   </requires>
   <functioncall>boolean retval = ultraschall.SetRenderPreset(string Bounds_Name, string Options_and_Format_Name, table RenderTable)</functioncall>
   <description>
     sets an already existing render-preset in reaper-render.ini. 
     
     This function will check, whether the chosen names aren't given yet in any preset. 
     
     Changed render-presets are updated after (re-)opening in the Render to File-dialog     
     
     Note: You can choose, whether to include only Bounds, only RenderFormatOptions of both. The Bounds and the RenderFormatOptions store different parts of the render-presets.
     
     Some settings aren't stored in Presets and will be ignored:
     TailMS=0(Reaper 6.61 and earlier), SilentlyIncrementFilename=false, AddToProj=false, SaveCopyOfProject=false, RenderQueueDelay=false, RenderQueueDelaySeconds=false, NoSilentRender=false
     
     Bounds_Name stores only:
              RenderTable["Bounds"] - the bounds-dropdownlist, 
                                      0, Custom time range
                                      1, Entire project 
                                      2, Time selection 
                                      3, Project regions
                                      4, Selected Media Items(in combination with Source 32)
                                      5, Selected regions
                                      6, Razor edit areas
                                      7, All project markers
                                      8, Selected markers
              RenderTable["Startposition"] - the startposition of the render
              RenderTable["Endposition"] - the endposition of the render
              RenderTable["Preserve_Start_Offset"] - true, preserve start-offset-checkbox(with Bounds=4 and Source=32); false, don't preserve
              RenderTable["Preserve_Metadata"] - true, preserve metadata-checkbox; false, don't preserve
              RenderTable["Source"]+RenderTable["MultiChannelFiles"]+RenderTable["OnlyMonoMedia"] - the source dropdownlist, includes 
                                      0, Master mix 
                                      1, Master mix + stems
                                      3, Stems (selected tracks)
                                      &4, Multichannel tracks to multichannel files
                                      8, Region render matrix
                                      &16, Tracks with only mono media to mono files
                                      32, Selected media items
                                      64, selected media items via master
                                      128, selected tracks via master
                                      4096, Razor edit areas
                                      4224, Razor edit areas via master
              RenderTable["RenderPattern"] - the renderpattern, which hold also the wildcards
              RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? 
                                      &1, custom time bounds
                                      &2, entire project
                                      &4, time selection
                                      &8, all project regions
                                      &16, selected media items
                                      &32, selected project regions 
              RenderTable["TailMS"] - the length of the tail in milliseconds(Reaper 6.62+)
     
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
                                                0, Sinc Interpolation: 64pt (medium quality)
                                                1, Linear Interpolation: (low quality)
                                                2, Point Sampling (lowest quality, retro)
                                                3, Sinc Interpolation: 192pt
                                                4, Sinc Interpolation: 384pt
                                                5, Linear Interpolation + IIR
                                                6, Linear Interpolation + IIRx2
                                                7, Sinc Interpolation: 16pt
                                                8, Sinc Interpolation: 512pt(slow)
                                                9, Sinc Interpolation: 768pt(very slow)
                                                10, r8brain free (highest quality, fast)
              RenderTable["Dither"] - the Dither/Noise shaping-checkboxes: 
                                      &1, dither master mix
                                      &2, noise shaping master mix
                                      &4, dither stems
                                      &8, dither noise shaping stems
              RenderTable["EmbedMetaData"] - Embed metadata; true, checked; false, unchecked  
              RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides-checkbox
              RenderTable["EmbedTakeMarkers"] - Embed Take markers-checkbox
              RenderTable["Enable2ndPassRender"] - true, 2nd pass render is enabled; false, 2nd pass render is disabled
              RenderTable["RenderString"] - the render-cfg-string, which holds the render-outformat-settings
              RenderTable["RenderString2"] - the render-cfg-string, which holds the secondary render-outformat-settings; "" to remove it from this preset
              RenderTable["Normalize_Enabled"] - true, normalization enabled; false, normalization not enabled
              RenderTable["Normalize_Method"] - the normalize-method-dropdownlist
                                                0, LUFS-I
                                                1, RMS-I
                                                2, Peak
                                                3, True Peak
                                                4, LUFS-M max
                                                5, LUFS-S max
              RenderTable["Normalize_Only_Files_Too_Loud"] - Only normalize files that are too loud,checkbox
                                                           - true, checkbox checked
                                                           - false, checkbox unchecked
              RenderTable["Normalize_Stems_to_Master_Target"] - true, normalize-stems to master target(common gain to stems)
                                                                false, normalize each file individually
              RenderTable["Normalize_Target"] - the normalize-target as dB-value
              RenderTable["OnlyChannelsSentToParent"] - true, option is checked; false, option is unchecked
              RenderTable["RenderStems_Prefader"] - true, option is checked; false, option is unchecked
              RenderTable["FadeIn_Enabled"] - true, fade-in is enabled; false, fade-in is disabled
              RenderTable["FadeIn"] - the fade-in-time in seconds
              RenderTable["FadeIn_Shape"] - the fade-in-shape
                                     - 0, Linear fade in
                                     - 1, Inverted quadratic fade in
                                     - 2, Quadratic fade in
                                     - 3, Inverted quartic fade in
                                     - 4, Quartic fade in
                                     - 5, Cosine S-curve fade in
                                     - 6, Quartic S-curve fade in
              RenderTable["FadeOut_Enabled"] - true, fade-out is enabled; false, fade-out is disabled
              RenderTable["FadeOut"] - the fade-out time in seconds
              RenderTable["FadeOut_Shape"] - the fade-out-shape
                                     - 0, Linear fade in
                                     - 1, Inverted quadratic fade in
                                     - 2, Quadratic fade in
                                     - 3, Inverted quartic fade in
                                     - 4, Quartic fade in
                                     - 5, Cosine S-curve fade in
                                     - 6, Quartic S-curve fade in
              RenderTable["Brickwall_Limiter_Enabled"] - true, brickwall limiting is enabled; false, brickwall limiting is disabled            
              RenderTable["Brickwall_Limiter_Method"] - brickwall-limiting-mode; 1, peak; 2, true peak
              RenderTable["Brickwall_Limiter_Target"] - the volume of the brickwall-limit
     Returns false in case of an error
   </description>
   <parameters>
     string Bounds_Name - the name of the Bounds-render-preset you want to add; nil, to not add a new Bounds-render-preset; case-insensitive
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to add; to not add a new Render-Format-Options-render-preset; case-insensitive
     table RenderTable - the RenderTable, which holds all information for inclusion into the Render-Preset
   </parameters>
   <retvals>
     boolean retval - true, setting was successful; false, setting was unsuccessful
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Functions</target_document>
   <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
   <tags>render management, set, render preset, names, format options, bounds, rendertable</tags>
 </US_DocBloc>
 ]]
  if Bounds_Name==nil and Options_and_Format_Name==nil then ultraschall.AddErrorMessage("SetRenderPreset", "RenderTable/Options_and_Format_Name", "can't be both set to nil", -6) return false end
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("SetRenderPreset", "RenderTable", "must be a valid render-table", -1) return false end
  if Bounds_Name~=nil and type(Bounds_Name)~="string" then ultraschall.AddErrorMessage("SetRenderPreset", "Bounds_Name", "must be a string", -2) return false end
  if Options_and_Format_Name~=nil and type(Options_and_Format_Name)~="string" then ultraschall.AddErrorMessage("SetRenderPreset", "Options_and_Format_Name", "must be a string", -3) return false end
  
  if Bounds_Name:match("%s") then Bounds_Name="\""..Bounds_Name.."\"" end
  if Options_and_Format_Name:match("%s") then Options_and_Format_Name="\""..Options_and_Format_Name.."\"" end
  local A,B, Source, RenderPattern, ProjectSampleRateFXProcessing, String, Bounds, RenderFormatOptions
  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-render.ini")
  if A==nil then A="" end
  Bounds_Name, Options_and_Format_Name=ultraschall.ResolvePresetName(Bounds_Name, Options_and_Format_Name)
  if Bounds_Name==nil then ultraschall.AddErrorMessage("SetRenderPreset", "Bounds_Name", "no bounds-preset with that name", -4) return false end
  if Options_and_Format_Name==nil then ultraschall.AddErrorMessage("SetRenderPreset", "Options_and_Format_Name", "no renderformat/options-preset with that name", -5) return false end
  
  Source=RenderTable["Source"]
  local MonoMultichannelEmbed=0
  local CheckBoxes=0
  if RenderTable["MultiChannelFiles"]==true then MonoMultichannelEmbed=MonoMultichannelEmbed+4 end
  if RenderTable["OnlyMonoMedia"]==true then MonoMultichannelEmbed=MonoMultichannelEmbed+16 end
  if RenderTable["EmbedStretchMarkers"]==true then MonoMultichannelEmbed=MonoMultichannelEmbed+256 end
  if RenderTable["EmbedMetaData"]==true then CheckBoxes=CheckBoxes+512 end
  if RenderTable["EmbedTakeMarkers"]==true then MonoMultichannelEmbed=MonoMultichannelEmbed+1024 end
  if RenderTable["Enable2ndPassRender"]==true then MonoMultichannelEmbed=MonoMultichannelEmbed+2048 end
  if RenderTable["RenderStems_Prefader"]==true then CheckBoxes=CheckBoxes+8192 end
  if RenderTable["OnlyChannelsSentToParent"]==true then CheckBoxes=CheckBoxes+16384 end

  if RenderTable["Preserve_Start_Offset"]==true then CheckBoxes=CheckBoxes+65536 end
  if RenderTable["Preserve_Metadata"]==true then CheckBoxes=CheckBoxes+32768 end

  if RenderTable["ProjectSampleRateFXProcessing"]==true then ProjectSampleRateFXProcessing=1 else ProjectSampleRateFXProcessing=0 end
  if RenderTable["RenderPattern"]=="" or RenderTable["RenderPattern"]:match("%s")~=nil then
    RenderPattern="\""..RenderTable["RenderPattern"].."\""
  else
    RenderPattern=RenderTable["RenderPattern"]
  end

 
  -- set Bounds-preset, if given
  if Bounds_Name~=nil then 
    Bounds=("\n"..A):match("(\nRENDERPRESET_OUTPUT "..Bounds_Name..".-\n)")
    Bounds = ultraschall.EscapeMagicCharacters_String(Bounds)

    String="\nRENDERPRESET_OUTPUT "..Bounds_Name.." "..RenderTable["Bounds"]..
           " "..RenderTable["Startposition"]..
           " "..RenderTable["Endposition"]..
           " "..Source..
           " ".."0"..
           " "..RenderPattern..
           " "..RenderTable["TailFlag"]..
           " \""..RenderTable["RenderFile"].."\" "..
           RenderTable["TailMS"].."\n"

    A=string.gsub(A, Bounds, String)
  end

  -- set Format-options-preset, if given
  if Options_and_Format_Name~=nil then 
      RenderFormatOptions=A:match("<RENDERPRESET "..Options_and_Format_Name..".->")
      String="<RENDERPRESET "..Options_and_Format_Name..
             " "..RenderTable["SampleRate"]..
             " "..RenderTable["Channels"]..
             " "..RenderTable["OfflineOnlineRendering"]..
             " "..ProjectSampleRateFXProcessing..
             " "..RenderTable["RenderResample"]..
             " "..RenderTable["Dither"].. -- various_checkboxes
             " "..CheckBoxes..  -- various_checkboxes2
             "\n  "..RenderTable["RenderString"].."\n>"
    RenderFormatOptions = ultraschall.EscapeMagicCharacters_String(RenderFormatOptions)
    A=string.gsub(A, RenderFormatOptions, String)
    
    if RenderTable["RenderString2"]~="" then
      RenderFormatOptions=A:match("<RENDERPRESET2 "..Options_and_Format_Name..".->")
      String="<RENDERPRESET2 "..Options_and_Format_Name..
             "\n  "..RenderTable["RenderString2"].."\n>"
      if RenderFormatOptions~=nil then
        RenderFormatOptions = ultraschall.EscapeMagicCharacters_String(RenderFormatOptions)      
        A=string.gsub(A, RenderFormatOptions, String)
      else
        A=A.."\n"..String
      end
    else
      RenderFormatOptions=A:match("<RENDERPRESET2 "..Options_and_Format_Name..".->")
      if RenderFormatOptions~=nil then
        RenderFormatOptions = ultraschall.EscapeMagicCharacters_String(RenderFormatOptions)
        A=string.gsub(A, RenderFormatOptions, "")
      end
    end    
    
      local normalize_method=RenderTable["Normalize_Method"]*2
      if RenderTable["Normalize_Enabled"]==true then normalize_method=normalize_method+1 end
      if RenderTable["Normalize_Stems_to_Master_Target"]==true then normalize_method=normalize_method+32 end
      if RenderTable["Brickwall_Limiter_Enabled"]==true then normalize_method=normalize_method+64 end
      if RenderTable["Brickwall_Limiter_Method"]==2 then normalize_method=normalize_method+128 end
      if RenderTable["Normalize_Only_Files_Too_Loud"]==true then normalize_method=normalize_method+256 end
      
      local brickwall_target=ultraschall.DB2MKVOL(RenderTable["Brickwall_Limiter_Target"])
      local normalize_target=ultraschall.DB2MKVOL(RenderTable["Normalize_Target"])
      local String3="\nRENDERPRESET_EXT "..Options_and_Format_Name.." "..normalize_method.." "..normalize_target.. " "..brickwall_target.." "..RenderTable["FadeIn"].." "..RenderTable["FadeOut"].." "..RenderTable["FadeIn_Shape"].." "..RenderTable["FadeOut_Shape"]
      A=A.."\n"
      local RenderNormalization=A:match("\nRENDERPRESET_EXT "..Options_and_Format_Name..".-\n")
      
      if RenderNormalization~=nil then
        RenderNormalization=ultraschall.EscapeMagicCharacters_String(RenderNormalization)
        A=string.gsub(A, RenderNormalization, String3.."\n"):sub(1,-2)
      else
        A=A:sub(1,-2)
        A=A..String3
      end
  end
    
  
  local AA=ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-render.ini", A)
  if A==-1 then ultraschall.AddErrorMessage("SetRenderPreset", "", "can't access "..reaper.GetResourcePath().."/reaper-render.ini", -7) return false end
  return true
  --]]
end

--L=ultraschall.GetRenderTable_Project()
--ultraschall.SetRenderPreset("A04", "A04", L)


function ultraschall.RenderProject_RenderTable(projectfilename_with_path, RenderTable, AddToProj, CloseAfterRender, SilentlyIncrementFilename, ignore_if_cancelled)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject_RenderTable</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.64
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProject_RenderTable(optional string projectfilename_with_path, optional table RenderTable, optional boolean AddToProj, optional boolean CloseAfterRender, optional boolean SilentlyIncrementFilename)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Renders a projectfile or the current active project, using the settings from a RenderTable.
            
    Expected RenderTable is of the following structure:
    
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; 
                                        true, checked; 
                                        false, unchecked
            RenderTable["Bounds"]    - 0, Custom time range; 
                                       1, Entire project; 
                                       2, Time selection; 
                                       3, Project regions; 
                                       4, Selected Media Items(in combination with Source 32); 
                                       5, Selected regions
                                       6, Razor edit areas
                                       7, All project markers
                                       8, Selected markers
            RenderTable["Channels"] - the number of channels in the rendered file; 
                                          1, mono; 
                                          2, stereo; 
                                          higher, the number of channels
            RenderTable["CloseAfterRender"] - true, close rendering to file-dialog after render; 
                                              false, don't close it
            RenderTable["Dither"] - &1, dither master mix; 
                                    &2, noise shaping master mix; 
                                    &4, dither stems; 
                                    &8, dither noise shaping stems
            RenderTable["EmbedMetaData"]       - Embed metadata; true, checked; false, unchecked
            RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides; true, checked; false, unchecked
            RenderTable["EmbedTakeMarkers"]    - Embed Take markers; true, checked; false, unchecked
            RenderTable["Enable2ndPassRender"] - true, 2nd pass render is enabled; false, 2nd pass render is disabled
            RenderTable["Endposition"]         - the endposition of the rendering selection in seconds
            RenderTable["MultiChannelFiles"]   - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["Normalize_Enabled"]   - true, normalization enabled; 
                                                 false, normalization not enabled
            RenderTable["Normalize_Method"]    - the normalize-method-dropdownlist
                                                     0, LUFS-I
                                                     1, RMS-I
                                                     2, Peak
                                                     3, True Peak
                                                     4, LUFS-M max
                                                     5, LUFS-S max
            RenderTable["Normalize_Only_Files_Too_Loud"] - Only normalize files that are too loud,checkbox
                                                         - true, checkbox checked
                                                         - false, checkbox unchecked
            RenderTable["Normalize_Stems_to_Master_Target"] - true, normalize-stems to master target(common gain to stems)
                                                              false, normalize each file individually
            RenderTable["Normalize_Target"]       - the normalize-target as dB-value    
            RenderTable["NoSilentRender"]         - Do not render files that are likely silent-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 
                                                        0, Full-speed Offline; 
                                                        1, 1x Offline; 
                                                        2, Online Render; 
                                                        3, Online Render(Idle); 
                                                        4, Offline Render(Idle)
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; 
                                               true, checked; 
                                               false, unchecked
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; 
                                                           true, checked; false, unchecked
            RenderTable["RenderFile"]       - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"]    - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 
                                                0, Sinc Interpolation: 64pt (medium quality)
                                                1, Linear Interpolation: (low quality)
                                                2, Point Sampling (lowest quality, retro)
                                                3, Sinc Interpolation: 192pt
                                                4, Sinc Interpolation: 384pt
                                                5, Linear Interpolation + IIR
                                                6, Linear Interpolation + IIRx2
                                                7, Sinc Interpolation: 16pt
                                                8, Sinc Interpolation: 512pt(slow)
                                                9, Sinc Interpolation: 768pt(very slow)
                                                10, r8brain free (highest quality, fast)
            RenderTable["RenderString"]     - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
            RenderTable["RenderString2"]    - the render-cfg-string, that holds all settings of the currently set secondary-render-output-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"]       - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; 
                                                true, checked; 
                                                false, unchecked
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; 
                                                        true, checked
                                                        false, unchecked
            RenderTable["Source"] - 0, Master mix; 
                                    1, Master mix + stems; 
                                    3, Stems (selected tracks); 
                                    8, Region render matrix; 
                                    32, Selected media items; 64, selected media items via master; 
                                    64, selected media items via master; 
                                    128, selected tracks via master
                                    136, Region render matrix via master
                                    4096, Razor edit areas
                                    4224, Razor edit areas via master
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? 
                                        &1, custom time bounds; 
                                        &2, entire project; 
                                        &4, time selection; 
                                        &8, all project regions; 
                                        &16, selected media items; 
                                        &32, selected project regions
                                        &64, razor edit areas
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
    optional table RenderTable - the RenderTable with all render-settings, that you want to apply; nil, use the project's existing settings
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>projectfiles, render, output, file, rendertable</tags>
</US_DocBloc>
]]
  if RenderTable~=nil and ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("RenderProject_RenderTable", "RenderTable", "must be a valid RenderTable", -1) return -1 end
  if AddToProj~=nil and type(AddToProj)~="boolean" then ultraschall.AddErrorMessage("RenderProject_RenderTable", "AddToProj", "must be nil(for false) or boolean", -10) return -1 end
  if CloseAfterRender~=nil and type(CloseAfterRender)~="boolean" then ultraschall.AddErrorMessage("RenderProject_RenderTable", "CloseAfterRender", "must be nil(for true) or boolean", -11) return -1 end
  if SilentlyIncrementFilename~=nil and type(SilentlyIncrementFilename)~="boolean" then ultraschall.AddErrorMessage("RenderProject_RenderTable", "SilentlyIncrementFilename", "must be nil(for true) or boolean", -12) return -1 end
  if SilentlyIncrementFilename==nil then SilentlyIncrementFilename=true end
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
    if SilentlyIncrementFilename~=nil then RenderTable["SilentlyIncrementFilename"]=SilentlyIncrementFilename end    
    if CloseAfterRender==nil and norendertable==true then RenderTable["CloseAfterRender"]=true end
    
    local peakval
    if AddToProj==false then
    -- temporarily disable building peak-caches
        peakval=reaper.SNM_GetIntConfigVar("peakcachegenmode", -99)
        reaper.SNM_SetIntConfigVar("peakcachegenmode", 0)
    end
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
    
    if ignore_if_cancelled~=nil then
      oldadd=RenderTable["AddToProj"]
      RenderTable["AddToProj"]=false
    end
    
    ultraschall.ApplyRenderTable_Project(RenderTable, true) -- here the bug happens(Which bug, Meo? Which Bug? Forgot about me, Meo? - Yours sincerely Meo)
    --ultraschall.ShowLastErrorMessage()
    
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
    
    -- render
    reaper.Main_OnCommand(41824,0)    -- render using it with the last rendersettings(those, we inserted included)
    reaper.SNM_SetIntConfigVar("saveopts", oldSaveOpts) -- reset old bak-files-behavior    
    
    if ignore_if_cancelled~=nil then
      RenderTable["AddToProj"]=oldadd
    end
    
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
        --print2(MediaItemStateChunkArray[i]:match("%<SOURCE.-FILE \".-\""))
        Filearray[i]=MediaItemStateChunkArray[i]:match("%<SOURCE.-FILE (.-)\n")
        if Filearray[i]:sub(1,1)=="\"" and Filearray[i]:sub(-1,-1)=="\"" then
          Filearray[i]=Filearray[i]:sub(2,-2)
        end
      end
    end
    
    -- restore old settings, that I temporarily overwrite in the RenderTable
    RenderTable["CloseAfterRender"]=oldcloseafterrender
    RenderTable["SilentlyIncrementFilename"]=oldsilentlyincreasefilename
    if AddToProj==false then
      reaper.SNM_SetIntConfigVar("peakcachegenmode", peakval)
    end

    if aborted == true then ultraschall.AddErrorMessage("RenderProject_RenderTable", "", "rendering aborted", -2) return -1 end
    
    -- return, what has been found
    return Count, MediaItemStateChunkArray, Filearray
  else
    -- if user wants to render a projectfile:
    
    -- check parameters
    local retval2, oldSaveOpts
    if type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("RenderProject_RenderTable", "projectfilename_with_path", "must be a string", -3) return -1 end
    if reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("RenderProject_RenderTable", "projectfilename_with_path", "no such file", -4) return -1 end
    local length, content = ultraschall.ReadBinaryFile_Offset(projectfilename_with_path, 0, 16)
    if content~="<REAPER_PROJECT " then ultraschall.AddErrorMessage("RenderProject_RenderTable", "projectfilename_with_path", "no rpp-projectfile", -6) return -1 end
        
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
  <description>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <description>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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

function ultraschall.RenderProject(projectfilename_with_path, renderfilename_with_path, startposition, endposition, overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg, rendercfg2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.04
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>integer retval, integer renderfilecount, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProject(string projectfilename_with_path, string renderfilename_with_path, number startposition, number endposition, boolean overwrite_without_asking, boolean renderclosewhendone, boolean filenameincrease, optional string rendercfg, optional string rendercfg2)</functioncall>
  <description>
    Renders a project, using a specific render-cfg-string.
    To get render-cfg-strings, see functions starting with CreateRenderCFG_, like <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, etc.
    
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
    optional string rendercfg - the rendercfg-string, that contains all render-settings for an output-format
                              - To get render-cfg-strings, see CreateRenderCFG_xxx-functions, like: <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, <a href="#CreateRenderCFG_WAVPACK">CreateRenderCFG_WAVPACK</a>, <a href="#CreateRenderCFG_WebMVideo">CreateRenderCFG_WebMVideo</a>
                              - 
                              - If you want to render the current project, you can use a four-letter-version of the render-string; will use the default settings for that format. Not available with projectfiles!
                              - "evaw" for wave, "ffia" for aiff, " iso" for audio-cd, " pdd" for ddp, "calf" for flac, "l3pm" for mp3, "vggo" for ogg, "SggO" for Opus, "PMFF" for FFMpeg-video, "FVAX" for MP4Video/Audio on Mac, " FIG" for Gif, " FCL" for LCF, "kpvw" for wavepack 
    optional string rendercfg2 - just like rendercfg, but for the secondary render-format
  </parameters>
  <chapter_context>
    Rendering Projects
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
    local length, content = ultraschall.ReadBinaryFile_Offset(projectfilename_with_path, 0, 16)
    if content~="<REAPER_PROJECT " then ultraschall.AddErrorMessage("RenderProject", "projectfilename_with_path", "no rpp-projectfile", -19) return -1 end
  end
  if type(renderfilename_with_path)~="string" then ultraschall.AddErrorMessage("RenderProject", "renderfilename_with_path", "Must be a string.", -7) return -1 end  
  if rendercfg==nil or (ultraschall.GetOutputFormat_RenderCfg(rendercfg)==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg)=="Unknown") then ultraschall.AddErrorMessage("RenderProject", "rendercfg", "No valid render_cfg-string.", -9) return -1 end
  if rendercfg2==nil then rendercfg2=""
  elseif rendercfg2~=nil and (ultraschall.GetOutputFormat_RenderCfg(rendercfg2)==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg2)=="Unknown") then 
    ultraschall.AddErrorMessage("RenderProject", "rendercfg2", "No valid render_cfg-string.", -18) 
    return -1 
  end
  if type(overwrite_without_asking)~="boolean" then ultraschall.AddErrorMessage("RenderProject", "overwrite_without_asking", "Must be boolean", -10) return -1 end
  if filenameincrease~=nil and type(filenameincrease)~="boolean" then ultraschall.AddErrorMessage("RenderProject", "filenameincrease", "Must be either nil or boolean", -13) return -1 end
  if renderclosewhendone~=nil and type(renderclosewhendone)~="boolean" then ultraschall.AddErrorMessage("RenderProject", "renderclosewhendone", "Must be either nil or a boolean", -12) return -1 end


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
    if rendercfg2==nil then temp, rendercfg2 = reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT2", "", false) end 
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
    if timesel1_start>timesel1_end then timesel1_start, timesel1_end = timesel1_end, timesel1_start end
    if startposition==-1 then startposition=0
    elseif startposition==-2 then startposition=timesel1_start
    end
    if endposition==-1 then endposition=ultraschall.GetProject_Length(projectfilename_with_path)
    elseif endposition==-2 then endposition=timesel1_end
    end
  end    
  
  -- desired render-range invalid?
  if endposition<=startposition then ultraschall.AddErrorMessage("RenderProject", "endposition", "Must be bigger than startposition.", -11) return -1 end
  
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
  RenderTable["RenderString2"]=rendercfg2
  
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


function ultraschall.RenderProject_Regions(projectfilename_with_path, renderfilename_with_path, region, addregionname, overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg, addregionnameseparator, rendercfg2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject_Regions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.04
    Lua=5.3
  </requires>
  <functioncall>integer retval, integer renderfilecount, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProject_Regions(string projectfilename_with_path, string renderfilename_with_path, integer region, boolean addregionname, boolean overwrite_without_asking, boolean renderclosewhendone, boolean filenameincrease, string rendercfg, optional string addregionnameseparator, optional string rendercfg2)</functioncall>
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
    optional string rendercfg2 - the render-cfg-string for secondary render-format
  </parameters>
  <chapter_context>
    Rendering Projects
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  if rendercfg2~=nil and (ultraschall.GetOutputFormat_RenderCfg(rendercfg2)==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg2)=="Unknown") then ultraschall.AddErrorMessage("RenderProject_Regions", "rendercfg2", "No valid render_cfg-string.", -10) return -1 end

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
  end
--      print2(renderfilename_with_path, "Ach")  
  return ultraschall.RenderProject(projectfilename_with_path, renderfilename_with_path, tonumber(markertable[region][2]), tonumber(markertable[region][3]), overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg, rendercfg2)
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
    Ultraschall=4.6
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer num_queued_projects = ultraschall.AddSelectedItemsToRenderQueue(optional boolean render_items_individually, optional boolean render_items_through_master, optional table RenderTable)</functioncall>
  <description>
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
    optional table RenderTable - a RenderTable to apply for the renders in the render-queue
  </parameters>
  <chapter_context>
    Rendering Projects
    RenderQueue
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  local count
  
  if render_items_individually~=true then
    reaper.Main_OnCommand(41823,0)
    count=1
  else
    count, MediaItemArray = ultraschall.GetAllSelectedMediaItems()
    for i=1, reaper.CountMediaItems(0)-1 do
        reaper.SetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "B_UISEL", 0)
    end
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
    
    Note: Can also be applied as RecCFG!
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mp3 high quality, mp3</tags>
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
    
    Note: Can also be applied as RecCFG!
    
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mp3 vbr, mp3</tags>
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
    
    Note: Can also be applied as RecCFG!
    
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mp3 abr, mp3</tags>
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
    
    Note: Can also be applied as RecCFG!
    
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mp3 cbr, mp3</tags>
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
    Ultraschall=4.2
    Reaper=6.13
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_WAV(integer BitDepth, integer LargeFiles, integer BWFChunk, integer IncludeMarkers, boolean EmbedProjectTempo)</functioncall>
  <description>
    Creates the render-cfg-string for the WAV-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: Can also be applied as RecCFG!
    
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
                     - 7, 32 Bit PCM
                     - 8, 8 Bit u-Law
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
    boolean EmbedProjectTempo - Embed tempo-checkbox; true, checked; false, unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, wav</tags>
  <changelog>
  </changelog>
</US_DocBloc>
]]
  if math.type(BitDepth)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "BitDepth", "Must be an integer.", -1) return nil end
  if math.type(LargeFiles)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "LargeFiles", "Must be an integer.", -2) return nil end
  if math.type(BWFChunk)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "BWFChunk", "Must be an integer.", -3) return nil end
  if math.type(IncludeMarkers)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "IncludeMarkers", "Must be an integer.", -4) return nil end
  if type(EmbedProjectTempo)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "EmbedProjectTempo", "Must be a boolean.", -5) return nil end
  
  if BitDepth<0 or BitDepth>8 then ultraschall.AddErrorMessage("CreateRenderCFG_WAV", "Bitdepth", "Must be between 0 and 8.", -6) return nil end
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
  elseif BitDepth==7 then BitDepth="y" A0="E" -- 32 Bit PCM
  elseif BitDepth==4 then BitDepth="0" A0="A" -- 64 Bit FP
  elseif BitDepth==5 then BitDepth="w" A0="Q" -- 4 Bit IMA ADPCM
  elseif BitDepth==6 then BitDepth="w" A0="I" -- 2 Bit cADPCM
  elseif BitDepth==8 then BitDepth="w" A0="4" -- 8 Bit u-Law
  
  
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
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

function ultraschall.CreateRenderCFG_AIFF(bits, EmbedBeatLength)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_AIFF</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_AIFF(integer bits, optional boolean EmbedBeatLength)</functioncall>
  <description>
    Returns the render-cfg-string for the AIFF-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: Can also be applied as RecCFG!
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected AIFF-settings
  </retvals>
  <parameters>
    integer bits - the bitdepth of the aiff-file; 8, 16, 24 and 32 are supported
    optional boolean EmbedBeatLength - Embed beat length if exact-checkbox; true, checked; false or nil, unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, aiff</tags>
</US_DocBloc>
]]
  if math.type(bits)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AIFF", "bits", "must be an integer", -1) return nil end
  if bits~=8 and bits~=16 and bits~=24 and bits~=32 then ultraschall.AddErrorMessage("CreateRenderCFG_AIFF", "bits", "only 8, 16, 24 and 32 are supported by AIFF", -2) return nil end
  if EmbedBeatLength~=nil and type(EmbedBeatLength)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_AIFF", "EmbedBeatLength", "must be a boolean", -3) return nil end  
  if EmbedBeatLength==nil or EmbedBeatLength==false then EmbedBeatLength=0 else EmbedBeatLength=32 end
  
  local renderstring="ffia"..string.char(bits)..string.char(EmbedBeatLength)..string.char(0)
  renderstring=ultraschall.Base64_Encoder(renderstring)

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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, audiocd, cd, image, burn cd</tags>
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

function ultraschall.GetRender_EmbedStretchMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_EmbedStretchMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetRender_EmbedStretchMarkers()</functioncall>
  <description>
    Gets the current state of the "Embed stretch markers/transient guides"-checkbox from the Render to File-dialog.
  </description>
  <retvals>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, get, checkbox, render, embed stretch markers, transient guides</tags>
</US_DocBloc>
]]
  local SaveCopyOfProject, hwnd, retval, length, state
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    state=reaper.SNM_GetIntConfigVar("projrenderstems", 0)&256
  else
    state = reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1173), "BM_GETCHECK", 0,0,0,0)
  end
  if state==0 then state=false else state=true end
  return state
end

--A=ultraschall.GetRender_EmbedStretchMarkers()

function ultraschall.SetRender_EmbedStretchMarkers(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_EmbedStretchMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetRender_EmbedStretchMarkers(boolean state)</functioncall>
  <description>
    Sets the new state of the "Embed stretch markers/transient guides"-checkbox from the Render to File-dialog.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </parameters>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, set, checkbox, render, embed stretch markers, transient guides</tags>
</US_DocBloc>
]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("SetRender_EmbedStretchMarkers", "state", "must be a boolean", -1) return false end
  local SaveCopyOfProject, hwnd, retval, Oldstate, Oldstate2, state2
  if state==false then state=0 else state=1 end
  hwnd = ultraschall.GetRenderToFileHWND()
  Oldstate=reaper.SNM_GetIntConfigVar("projrenderstems", -99)
  Oldstate2=Oldstate&256  
  if Oldstate2==256 and state==0 then state2=Oldstate-256
  elseif Oldstate2==0 and state==1 then state2=Oldstate+256
  else state2=Oldstate
  end
  
  
  if hwnd==nil then
    reaper.SNM_SetIntConfigVar("projrenderstems", state2)
  else
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1173), "BM_SETCHECK", state,0,0,0)
    reaper.SNM_SetIntConfigVar("projrenderstems", state2)
  end
  return true
end

--A=ultraschall.SetRender_EmbedStretchMarkers(false)

function ultraschall.Render_Loop(RenderTable, RenderFilename, AutoIncrement, FirstStart, FirstEnd, SecondStart, SecondEnd, FadeIn, FadeOut, FadeInShape, FadeOutShape)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Render_Loop</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    JS=0.998
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemStateChunkArray, array Filearray = ultraschall.Render_Loop(table RenderTable, string RenderFilename, boolean AutoIncrement, number FirstStart, number FirstEnd, number SecondStart, number SecondEnd, number FadeIn, number FadeOut, integer FadeInShape, integer FadeOutShape)</functioncall>
  <description>
    Renders a part of a project using 2 passes. Good for rendering loops, including wetloops.
    
    The first pass will be set by FirstStart and FirstStart. This is the one for possible fx-buildups(reverbs, etc).
    The second pass will be set by SecondStart and SecondEnd. This is the one, which "crops" the first-pass to its correct length.
    
    You can also influence the second pass by setting fadein and fadeout, including the fadein/fadeout-shape. 
    That way, you can control, how the beginning and the end of the loop-item sounds.
    
    SecondStart and SecondEnd are in relation of the original source project. SecondStart is from the beginning of the source-project, NOT FirstStart!
    
    returns -1 in case of an error 
  </description>
  <parameters>
    table RenderTable - the RenderTable, which holds the render-settings for the second pass
    string RenderFilename - the filename with path of the final rendered file
    boolean AutoIncrement - true, autoincrement the filename(if it already exists); false, ask before rendering(if file already exists)
    number FirstStart - the beginning of the first-pass-render in seconds
    number FirstEnd - the end of the first-pass-render in seconds
    number SecondStart - the beginning of the second-pass-render in seconds
    number SecondEnd - the end of the second-pass-render in seconds
    number FadeIn - the length of the fade-in in the second-pass-render and therefore the final rendered file in seconds
    number FadeOut - the length of the fade-out in the second-pass-render and therefore the final rendered file in seconds
    integer FadeInShape - the shape of the fade-in-curve; fadein shape, 0..6, 0=linear
    integer FadeOutShape - the shape of the fade-out-curve; fadeout shape, 0..6, 0=linear
  </parameters>
  <retvals>
    integer count - the number of rendered files
    array MediaItemStateChunkArray - all MediaItemStateChunks within an array
    array Filearray - all rendered filenames including path
  </retvals>
  <chapter_context>
    Rendering Projects
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, render, loop, first pass, second pass</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("Render_Loop", "RenderTable", "Not a valid RenderTable", -1) return -1 end
  if type(RenderFilename)~="string" then ultraschall.AddErrorMessage("Render_Loop", "RenderFilename", "Must be a string", -2) return -1 end
  if type(AutoIncrement)~="boolean" then ultraschall.AddErrorMessage("Render_Loop", "AutoIncrement", "Must be a boolean", -3) return -1 end
  if type(FirstStart)~="number" then ultraschall.AddErrorMessage("Render_Loop", "FirstStart", "Must be a number", -4) return -1 end
  if type(FirstEnd)~="number" then ultraschall.AddErrorMessage("Render_Loop", "FirstEnd", "Must be a number", -5) return -1 end
  if type(SecondStart)~="number" then ultraschall.AddErrorMessage("Render_Loop", "SecondStart", "Must be a number", -6) return -1 end
  if type(SecondEnd)~="number" then ultraschall.AddErrorMessage("Render_Loop", "SecondEnd", "Must be a number", -7) return -1 end

  if type(FadeIn)~="number" then ultraschall.AddErrorMessage("Render_Loop", "FadeIn", "Must be a number", -8) return -1 end
  if type(FadeOut)~="number" then ultraschall.AddErrorMessage("Render_Loop", "FadeOut", "Must be a number", -9) return -1 end
  
  if math.type(FadeInShape)~="integer" then ultraschall.AddErrorMessage("Render_Loop", "FadeInShape", "Must be an integer", -10) return -1 end
  if math.type(FadeOutShape)~="integer" then ultraschall.AddErrorMessage("Render_Loop", "FadeOutShape", "Must be an integer", -11) return -1 end
  
  local RenderFilename2=ultraschall.Api_Path.."/temp/LoopRender/"..reaper.genGuid("")..".wav"
  local RenderFilenamepath, RenderFilenamefilename = ultraschall.GetPath(RenderFilename2)
  local RenderFilenamepath2, RenderFilenamefilename2 = ultraschall.GetPath(RenderFilename)
  
  local ThirdStart=SecondStart-FirstStart
  local ThirdEnd=SecondEnd-FirstStart
  
  local render_cfg_string = ultraschall.CreateRenderCFG_WAV(4, 0, 0, 0, false)
  
  local RenderTable2 = ultraschall.CreateNewRenderTable(0, 0, FirstStart, FirstEnd, 1, 0, RenderFilenamepath, RenderFilenamefilename, 192000, 2, 0, true, 0, false, false, 0, render_cfg_string, false, false, false, false, 0, true, false)
  
  local count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(nil, RenderTable2, false, true, false)
  if count==-1 then 
    ultraschall.AddErrorMessage("Render_Loop", "", "First Pass-Render has been cancelled", -12) 
    local dircount, dirs, filecount, files = ultraschall.GetAllRecursiveFilesAndSubdirectories(ultraschall.Api_Path.."/temp/LoopRender/")
    for i=1, filecount do
      os.remove(files[i])
    end
    return -1 
  end
  local O=ultraschall.ReadFullFile(ultraschall.Api_Path.."/misc/tempproject.RPP")
  local newproject = ultraschall.NewProjectTab(true)
  reaper.Main_openProject("noprompt:"..ultraschall.Api_Path.."/misc/tempproject.RPP")
  local retval, item, endposition, numchannels, Samplerate, Filetype, editcursorposition, track = ultraschall.InsertMediaItemFromFile(RenderFilename2, 1, 0, -1, 0)
  reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", FadeIn)
  reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", FadeOut)
  reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", FadeInShape)
  reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", FadeOutShape)
  reaper.UpdateArrange()
  RenderTable["Startposition"]=ThirdStart
  RenderTable["Endposition"]=ThirdEnd
  RenderTable["RenderFile"]=RenderFilenamepath2
  RenderTable["RenderPattern"]=RenderFilenamefilename2
  local count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(nil, RenderTable, false, true, AutoIncrement)
  reaper.Main_SaveProject(0,false)
  reaper.Main_OnCommand(40860,0)
  ultraschall.WriteValueToFile(ultraschall.Api_Path.."/misc/tempproject.RPP",O)
  os.remove(RenderFilename2)
  
  local dircount, dirs, filecount, files = ultraschall.GetAllRecursiveFilesAndSubdirectories(ultraschall.Api_Path.."/temp/LoopRender/")
  for i=1, filecount do
    os.remove(files[i])
  end
  if count==-1 then ultraschall.AddErrorMessage("Render_Loop", "", "Second Pass-Render has been cancelled", -13) return -1 end
  return count, MediaItemStateChunkArray, Filearray
end

function ultraschall.GetRender_EmbedMetaData()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_EmbedMetaData</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetRender_EmbedMetaData()</functioncall>
  <description>
    Gets the current state of the "Embed metadata"-checkbox from the Render to File-dialog.
  </description>
  <retvals>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, get, checkbox, render, embed metadata</tags>
</US_DocBloc>
]]
  local SaveCopyOfProject, hwnd, retval, length, state
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    state=reaper.SNM_GetIntConfigVar("projrenderstems", 0)&512
  else
    state = reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1178), "BM_GETCHECK", 0,0,0,0)
  end
  if state==0 then state=false else state=true end
  return state
end

--A=ultraschall.GetRender_EmbedMetaData()

function ultraschall.SetRender_EmbedMetaData(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_EmbedMetaData</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetRender_EmbedMetaData(boolean state)</functioncall>
  <description>
    Sets the new state of the "Embed metadata"-checkbox from the Render to File-dialog.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </parameters>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, set, checkbox, render, embed metadata, transient guides</tags>
</US_DocBloc>
]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("SetRender_EmbedStretchMarkers", "state", "must be a boolean", -1) return false end
  local SaveCopyOfProject, hwnd, retval, Oldstate, Oldstate2, state2
  if state==false then state=0 else state=1 end
  hwnd = ultraschall.GetRenderToFileHWND()
  Oldstate=reaper.SNM_GetIntConfigVar("projrenderstems", -99)
  Oldstate2=Oldstate&512  
  if Oldstate2==512 and state==0 then state2=Oldstate-512
  elseif Oldstate2==0 and state==1 then state2=Oldstate+512
  else state2=Oldstate
  end
  
  
  if hwnd==nil then
    reaper.SNM_SetIntConfigVar("projrenderstems", state2)
  else
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1178), "BM_SETCHECK", state,0,0,0)
    reaper.SNM_SetIntConfigVar("projrenderstems", state2)
  end
  return true
end

--A=ultraschall.SetRender_EmbedMetaData(true)


function ultraschall.SetRender_OfflineOnlineMode(mode)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_OfflineOnlineMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetRender_OfflineOnlineMode(integer mode)</functioncall>
  <description>
    sets the current mode of the offline/online-render-dropdownlist from the Render to File-dialog
    
    Returns false in case of an error
  </description>
  <parameters>
    integer mode - the mode, that you want to set
                 - 0, Full-speed Offline
                 - 1, 1x Offline
                 - 2, Online Render
                 - 3, Offline Render (Idle)
                 - 4, 1x Offline Render (Idle)
  </parameters>
  <retvals>
    boolean retval - true, setting it was successful; false, setting it was unsuccessful
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>rendermanagement, render, set, offline, online, idle</tags>
</US_DocBloc>
]]
  if math.type(mode)~="integer" then ultraschall.AddErrorMessage("SetRender_OfflineOnlineMode", "mode", "must be an integer", -1) return false end
  if mode<0 or mode>4 then ultraschall.AddErrorMessage("SetRender_OfflineOnlineMode", "mode", "must be between 0 and 4", -2) return false end
  local oldfocus=reaper.JS_Window_GetFocus()
  
  local hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then reaper.SNM_SetIntConfigVar("projrenderlimit", mode) return end

    -- select the new format-setting
    if ultraschall.IsOS_Windows()==true then
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1001), "CB_SETCURSEL", mode,0,0,0)
    --[[
      reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(hwnd, 1001), "CB_SETCURSEL", mode,0,0,0)
    
      reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1001), "WM_LBUTTONDOWN", 1,0,0,0)
      reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(hwnd, 1001), "WM_LBUTTONUP", 1,0,0,0)
        
      reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(hwnd, 1001), "WM_LBUTTONDOWN", 1,0,0,0)
      reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(hwnd, 1001), "WM_LBUTTONUP", 1,0,0,0)
      --]]
    elseif ultraschall.IsOS_Mac()==true then
      reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1001), "CB_SETCURSEL", mode,0,0,0)
    else
      -- ToDo: Check with Linux
      reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1001), "CB_SETCURSEL", mode,0,0,0)
    end

    reaper.JS_Window_SetFocus(oldfocus)    --]]
    
    --[[
    -- select the new format-setting
    reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(hwnd,1001), "CB_SETCURSEL", mode,0,0,0)
    -- the following triggers Reaper to understand, that changes occurred, by clicking at the
    -- dropdownlist twice.
    -- Does this work on Mac and Linux?
    reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(hwnd, 1001), "WM_LBUTTONDOWN", 1,0,0,0)
    reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(hwnd, 1001), "WM_LBUTTONUP", 1,0,0,0)
    
    reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(hwnd, 1001), "WM_LBUTTONDOWN", 1,0,0,0)
    reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(hwnd, 1001), "WM_LBUTTONUP", 1,0,0,0)

    reaper.JS_Window_SetFocus(oldfocus)    --]]
    return true
end

--A=ultraschall.SetRender_OfflineOnlineMode(4)

function ultraschall.GetRender_OfflineOnlineMode()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_OfflineOnlineMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>integer mode = ultraschall.GetRender_OfflineOnlineMode()</functioncall>
  <description>
    gets the current mode of the offline/online-render-dropdownlist from the Render to File-dialog
  </description>
  <retvals>
    integer mode - the mode, that is set
                 - 0, Full-speed Offline
                 - 1, 1x Offline
                 - 2, Online Render
                 - 3, Offline Render (Idle)
                 - 4, 1x Offline Render (Idle)
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>rendermanagement, render, get, offline, online, idle</tags>
</US_DocBloc>
]]
  local oldfocus=reaper.JS_Window_GetFocus()
  
  local hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then return reaper.SNM_GetIntConfigVar("projrenderlimit", -1) end

  return reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1001), "CB_GETCURSEL", 0,100,0,100)
end

--A,B,C=ultraschall.GetRender_OfflineOnlineMode()


function ultraschall.GetRender_ResampleMode()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_ResampleMode</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>integer mode = ultraschall.GetRender_ResampleMode()</functioncall>
  <description>
    gets the current mode of the "Resample mode (if needed)"-dropdownlist from the Render to File-dialog
  </description>
  <retvals>
    integer mode - the mode, that is set
                 - 0, Sinc Interpolation: 64pt (medium quality)
                 - 1, Linear Interpolation: (low quality)
                 - 2, Point Sampling (lowest quality, retro)
                 - 3, Sinc Interpolation: 192pt
                 - 4, Sinc Interpolation: 384pt
                 - 5, Linear Interpolation + IIR
                 - 6, Linear Interpolation + IIRx2
                 - 7, Sinc Interpolation: 16pt
                 - 8, Sinc Interpolation: 512pt(slow)
                 - 9, Sinc Interpolation: 768pt(very slow)
                 - 10, r8brain free (highest quality, fast)
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>rendermanagement, render, get, resample mode</tags>
</US_DocBloc>
]]
  local oldfocus=reaper.JS_Window_GetFocus()
  
  local hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then return reaper.SNM_GetIntConfigVar("projrenderresample", -1) end
  
  local mode=reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1000), "CB_GETCURSEL", 0,100,0,100)
  
  local majorversion, subversion = ultraschall.GetReaperAppVersion()
  local version = tonumber(majorversion.."."..subversion)
  local LookupTable_Old_ResampleModes_vs_New
  if version<6.43 then
    LookupTable_Old_ResampleModes_vs_New={0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
  else
    LookupTable_Old_ResampleModes_vs_New={2, 1, 5, 6, 7, 0, 3, 4, 8, 9, 10}
  end

  return LookupTable_Old_ResampleModes_vs_New[mode+1]
end

--A,B,C=ultraschall.GetRender_ResampleMode()

function ultraschall.SetRender_ResampleMode(mode)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_ResampleMode</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.975
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetRender_ResampleMode(integer mode)</functioncall>
  <description>
    sets the current mode of the "Resample mode (if needed)"-dropdownlist from the Render to File-dialog
    
    Returns false in case of an error
  </description>
  <parameters>
    integer mode - the mode, that is set
                 - 0, Sinc Interpolation: 64pt (medium quality)
                 - 1, Linear Interpolation: (low quality)
                 - 2, Point Sampling (lowest quality, retro)
                 - 3, Sinc Interpolation: 192pt
                 - 4, Sinc Interpolation: 384pt
                 - 5, Linear Interpolation + IIR
                 - 6, Linear Interpolation + IIRx2
                 - 7, Sinc Interpolation: 16pt
                 - 8, Sinc Interpolation: 512pt(slow)
                 - 9, Sinc Interpolation: 768pt(very slow)
                 - 10, r8brain free (highest quality, fast)
  </parameters>
  <retvals>
    boolean retval - true, setting it was successful; false, setting it was unsuccessful
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>rendermanagement, render, set, resample mode</tags>
</US_DocBloc>
]]
  if math.type(mode)~="integer" then ultraschall.AddErrorMessage("SetRender_ResampleMode", "mode", "must be an integer", -1) return false end
  if mode<0 or mode>10 then ultraschall.AddErrorMessage("SetRender_ResampleMode", "mode", "must be between 0 and 10", -2) return false end
  local oldfocus=reaper.JS_Window_GetFocus()
  
  local hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then reaper.SNM_SetIntConfigVar("projrenderresample", mode) return end

  local majorversion, subversion = ultraschall.GetReaperAppVersion()
  local version = tonumber(majorversion.."."..subversion)
  
  local LookupTable_Old_ResampleModes_vs_New
  
  if version<6.43 then
    LookupTable_Old_ResampleModes_vs_New={0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
  else
    LookupTable_Old_ResampleModes_vs_New={5, 1, 0, 6, 7, 2, 3, 4, 8, 9, 10}
  end

  local mode=LookupTable_Old_ResampleModes_vs_New[mode+1]

  -- select the new format-setting
  if ultraschall.IsOS_Windows()==true then
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1000), "CB_SETCURSEL", mode,0,0,0)   
  elseif ultraschall.IsOS_Mac()==true then
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1000), "CB_SETCURSEL", mode,0,0,0)
  else
    -- ToDo: Check with Linux
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd, 1000), "CB_SETCURSEL", mode,0,0,0)
  end

  reaper.JS_Window_SetFocus(oldfocus)    --]]
  return true
end


function ultraschall.GetRender_NoSilentFiles()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_NoSilentFiles</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolan curcheckstate = ultraschall.GetRender_NoSilentFiles()</functioncall>
  <description>
    Returns the current check-state of the "Do not render files that are likely silent"-checkbox of the Render to File-dialog
  </description>
  <retvals>
    boolean curcheckstate - true, checkbox is checked; false, checkbox is unchecked
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, get, silent files render, checkbox</tags>
</US_DocBloc>
]]  
  return reaper.GetSetProjectInfo(0, "RENDER_ADDTOPROJ", 0, false)&2==2
end

function ultraschall.SetRender_NoSilentFiles(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_NoSilentFiles</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolan retval = ultraschall.SetRender_NoSilentFiles(boolean state)</functioncall>
  <description>
    Sets the current check-state of the "Do not render files that are likely silent"-checkbox of the Render to File-dialog
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting checkbox was successful; false, setting checkbox was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, checkbox is checked; false, checkbox is unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, set, silent files render, checkbox</tags>
</US_DocBloc>
]]  
  if ultraschall.type(state)~="boolean" then ultraschall.AddErrorMessage("SetRender_NoSilentFiles", "state", "must be a boolean", -1) return false end
  local curstate=reaper.GetSetProjectInfo(0, "RENDER_ADDTOPROJ", 0, false)
  if curstate&2==2 and state==false then reaper.GetSetProjectInfo(0, "RENDER_ADDTOPROJ", curstate-2, true)
  elseif curstate&2==0 and state==true then reaper.GetSetProjectInfo(0, "RENDER_ADDTOPROJ", curstate+2, true)
  end
  return true
end

--ultraschall.SetRender_NoSilentFiles(false)

function ultraschall.GetRender_AddRenderedFilesToProject()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_AddRenderedFilesToProject</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolan curcheckstate = ultraschall.GetRender_AddRenderedFilesToProject()</functioncall>
  <description>
    Returns the current check-state of the "Add rendered items to new tracks in project"-checkbox of the Render to File-dialog
  </description>
  <retvals>
    boolean curcheckstate - true, checkbox is checked; false, checkbox is unchecked
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, get, add rendered items to new tracks in project, checkbox</tags>
</US_DocBloc>
]]  
  return reaper.GetSetProjectInfo(0, "RENDER_ADDTOPROJ", 0, false)&1==1
end

--A=ultraschall.GetRender_AddRenderedFilesToProject()

function ultraschall.SetRender_AddRenderedFilesToProject(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_AddRenderedFilesToProject</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolan retval = ultraschall.SetRender_AddRenderedFilesToProject(boolean state)</functioncall>
  <description>
    Sets the current check-state of the "Add rendered items to new tracks in project"-checkbox of the Render to File-dialog
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting checkbox was successful; false, setting checkbox was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, checkbox is checked; false, checkbox is unchecked
  </parameters>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, set, add rendered items to new tracks in project, checkbox</tags>
</US_DocBloc>
]]  
  if ultraschall.type(state)~="boolean" then ultraschall.AddErrorMessage("SetRender_AddRenderedFilesToProject", "state", "must be a boolean", -1) return false end
  local curstate=reaper.GetSetProjectInfo(0, "RENDER_ADDTOPROJ", 0, false)
  if curstate&1==1 and state==false then reaper.GetSetProjectInfo(0, "RENDER_ADDTOPROJ", curstate-1, true)
  elseif curstate&1==0 and state==true then reaper.GetSetProjectInfo(0, "RENDER_ADDTOPROJ", curstate+1, true)
  end
  return true
end

function ultraschall.GetRender_TailLength()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_TailLength</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>integer taillength_ms = ultraschall.GetRender_TailLength()</functioncall>
  <description>
    Returns the current tail-length in ms, as set in the Render to File-dialog
  </description>
  <retvals>
    integer taillength_ms - the current taillength in ms
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, get, tail length, ms, checkbox</tags>
</US_DocBloc>
]]  
  return math.tointeger(reaper.GetSetProjectInfo(0, "RENDER_TAILMS", 0, false))
end

--A=ultraschall.GetRender_TailLength()

function ultraschall.SetRender_TailLength(taillength)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_TailLength</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolan retval = ultraschall.SetRender_TailLength(boolean state)</functioncall>
  <description>
    Sets the tail-length, as set in the Render to File-dialog
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer taillength - the taillength in milliseconds
  </parameters>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, set, tail length, ms, checkbox</tags>
</US_DocBloc>
]]  
  if ultraschall.type(taillength)~="number: integer" then ultraschall.AddErrorMessage("SetRender_TailLength", "taillength", "must be an integer", -1) return false end
  if taillength<0 then ultraschall.AddErrorMessage("SetRender_TailLength", "taillength", "must be an integer", -2) return false end

  reaper.GetSetProjectInfo(0, "RENDER_TAILMS", taillength, true)
  return true
end

function ultraschall.AreRenderTablesEqual(RenderTable1, RenderTable2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AreRenderTablesEqual</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional integer count_differentEntries1, optional table differentEntries1, optional integer count_differentEntries2, optional table differentEntries2 = ultraschall.AreRenderTablesEqual(table RenderTable1, table RenderTable2)</functioncall>
  <description>
    compares two RenderTables and returns true, if they are equal.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, RenderTables are equal; false, RenderTables aren't equal
    optional integer count_differentEntries1 - the number of different table-entries in RenderTable1
    optional table differentEntries1 - the table-entry-names, that are different in RenderTable1
    optional integer count_differentEntries2 - the number of different table-entries in RenderTable2
    optional table differentEntries2 - the table-entry-names, that are different in RenderTable2
  </retvals>
  <parameters>
    table RenderTable1 - the first RenderTable, that you want to compare
    table RenderTable2 - the second RenderTable, that you want to compare
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>projectfiles, compare, rendertable</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidRenderTable(RenderTable1)==false then ultraschall.AddErrorMessage("AreRenderTablesEqual", "RenderTable1", "must be a valid RenderTable", -1) return false end
  if ultraschall.IsValidRenderTable(RenderTable2)==false then ultraschall.AddErrorMessage("AreRenderTablesEqual", "RenderTable2", "must be a valid RenderTable", -2) return false end
  local equal=true
  local entries={}
  local entries_count=0
  local entries2={}
  local entries_count2=0
  for k, v in pairs(RenderTable1) do
    --print_alt(k,v,RenderTable2[k])
    if RenderTable2[k]~=v then
      entries_count=entries_count+1
      entries[entries_count]=k
      equal=false
    end
  end
  for k, v in pairs(RenderTable2) do
    --print_alt(k,v,RenderTable2[k])
    if RenderTable1[k]~=v then
      entries_count2=entries_count2+1
      entries2[entries_count2]=k
      equal=false
    end
  end
  return equal, entries_count, entries, entries_count2, entries2
end


--A={ultraschall.AreRenderTablesEqual(B,C)}

function ultraschall.GetRenderCFG_Settings_CAF(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_CAF</slug>
    <requires>
      Ultraschall=4.2
      Reaper=6.43
      Lua=5.3
    </requires>
    <functioncall>integer bitdepth, boolean EmbedTempo, integer include_markers = ultraschall.GetRenderCFG_Settings_CAF(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for CAF.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer bitdepth - the bitdepth of the CAF-file(8, 16, 24, 32(fp), 33(pcm), 64)
      boolean EmbedTempo - Embed tempo-checkbox; true, checked; false, unchecked
      integer include_markers - the include markers and regions dropdownlist
                              - 0, Do not include markers or regions
                              - 1, Markers + Regions
                              - 2, Markers + Regions starting with #
                              - 3, Markers only
                              - 4, Markers starting with # only
                              - 5, Regions only
                              - 6, Regions starting with # only
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the caf-settings
                        - nil, get the current new-project-default render-settings for caf
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, caff, caf, bitdepth, beat length</tags>
  </US_DocBloc>
  ]]
  if rendercfg~=nil and type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_CAF", "rendercfg", "must be a string", -1) return -1 end
  if rendercfg==nil then
    local retval
    retval, rendercfg = reaper.BR_Win32_GetPrivateProfileString("caff sink defaults", "default", "", reaper.get_ini_file())
    if retval==0 then rendercfg="6666616340B80088" end
    rendercfg = ultraschall.ConvertHex2Ascii(rendercfg)
    rendercfg=ultraschall.Base64_Encoder(rendercfg)
  end
  local Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="ffac" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_CAF", "rendercfg", "not a render-cfg-string of the format caf", -2) return -1 end
  
  if Decoded_string:len()==4 then
    return 24, false
  end
  
  dropdownlist=tonumber(string.byte(Decoded_string:sub(6,6)))
  if dropdownlist&32~=0 then dropdownlist=dropdownlist-32 end
  dropdownlist=dropdownlist>>3
  if dropdownlist==0 then dropdownlist=0
  elseif dropdownlist==1 then dropdownlist=1
  elseif dropdownlist==3 then dropdownlist=2
  elseif dropdownlist==9 then dropdownlist=3
  elseif dropdownlist==11 then dropdownlist=4
  elseif dropdownlist==17 then dropdownlist=5
  elseif dropdownlist==19 then dropdownlist=6
  end
  
  return string.byte(Decoded_string:sub(5,5)), tonumber(string.byte(Decoded_string:sub(6,6)))&32==32, dropdownlist
end

function ultraschall.CreateRenderCFG_CAF(bits, EmbedTempo, include_markers)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_CAF</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_CAF(integer bits, boolean EmbedTempo, integer include_markers)</functioncall>
  <description>
    Returns the render-cfg-string for the CAF-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: Can also be applied as RecCFG!
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected CAF-settings
  </retvals>
  <parameters>
      integer bitdepth - the bitdepth of the CAF-file(8, 16, 24, 32(fp), 33(pcm), 64)
      boolean EmbedTempo - Embed tempo-checkbox; true, checked; false, unchecked
      integer include_markers - the include markers and regions dropdownlist
                              - 0, Do not include markers or regions
                              - 1, Markers + Regions
                              - 2, Markers + Regions starting with #
                              - 3, Markers only
                              - 4, Markers starting with # only
                              - 5, Regions only
                              - 6, Regions starting with # only
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, caf</tags>
</US_DocBloc>
]]
  if math.type(bits)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_CAF", "bits", "must be an integer", -1) return nil end
  if bits~=8 and bits~=16 and bits~=24 and bits~=32 and bits~=33 and bits~=64 then ultraschall.AddErrorMessage("CreateRenderCFG_CAF", "bits", "only 8, 16, 24, 32, 33(32 pcm) and 64 are supported by CAF", -2) return nil end
  if EmbedTempo~=nil and type(EmbedTempo)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_CAF", "EmbedTempo", "must be a boolean", -3) return nil end  
  
  if include_markers==2 then include_markers=3
  elseif include_markers==3 then include_markers=9
  elseif include_markers==4 then include_markers=11
  elseif include_markers==5 then include_markers=17
  elseif include_markers==6 then include_markers=19
  end
  
  include_markers=include_markers<<3
  
  if EmbedTempo==true then include_markers=include_markers+32 end

  local renderstring="ffac"..string.char(bits)..string.char(include_markers)..string.char(0)
  renderstring=ultraschall.Base64_Encoder(renderstring)
  
  return renderstring
end

function ultraschall.GetRenderTargetFiles()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTargetFiles</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.33
    Lua=5.3
  </requires>
  <functioncall>string path, integer file_count, array filenames_with_path = ultraschall.GetRenderTargetFiles()</functioncall>
  <description>
    Will return the render output-path and all filenames with path that would be rendered, if rendering would run right now
    
    returns nil in case of error
  </description>
  <retvals>
    string path - the output-path for the rendered files
    integer file_count - the number of files that would be rendered
    array filenames_with_path - the filenames with path of the files that would be rendered
  </retvals>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, get, output filenames, target path</tags>
</US_DocBloc>
--]]
  retval, Targets = reaper.GetSetProjectInfo_String(0, "RENDER_TARGETS", "", false)
  if retval==false then return end
  local Temp=Targets:sub(1,2)
  local Count, Files = ultraschall.CSV2IndividualLinesAsArray(Targets, ";"..Temp)
  for i=2, Count do
    Files[i]=Temp..Files[i]
  end
  
  local Path=Files[1]:match("(.*[\\/])")
  
  return Path, Count, Files
end

function ultraschall.GetRenderCFG_Settings_MPEG1_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MPEG1_Video</slug>
    <requires>
      Ultraschall=4.7
      Reaper=6.62
      Lua=5.3
    </requires>
    <functioncall>integer VIDEO_CODEC, integer AUDIO_CODEC, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, string VideoExportOptions, string AudioExportOptions = ultraschall.GetRenderCFG_Settings_MPEG1_Video(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MPEG-1-Video.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Note: this works only with FFMPEG 4.1.3 installed
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer VIDEO_CODEC - the used VideoCodec for the MPEG-1-video
                          - 0, MPEG-1
                          - 1, NONE
      integer AUDIO_CODEC - the audio-codec of the MPEG-1-video
                          - 0, mp3
                          - 1, mp2
                          - 2, NONE
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
      string VideoExportOptions - the options for FFMPEG to apply to the video; examples: 
                                - g=1 ; all keyframes
                                - crf=1  ; h264 high quality
                                - crf=51 ; h264 small size
      string AudioExportOptions - the options for FFMPEG to apply to the audio; examples: 
                                - q=0 ; mp3 VBR highest
                                - q=9 ; mp3 VBR lowest
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the MPEG-1-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mpeg 1, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MPEG1_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=1 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MPEG1_Video", "rendercfg", "not a render-cfg-string of the format MPEG-1-video", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_MPEG1_Video", "rendercfg", "can't make out, which video format is chosen", -3) return nil
  end
  
  VideoCodec=string.byte(Decoded_string:sub(9,9))
  num_integers, MJPEG_quality= ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  AudioCodec=string.byte(Decoded_string:sub(17,17))
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  local FFMPEG_Options=Decoded_string:sub(45, -1)
  local FFMPEG_Options_Audio, FFMPEG_Options_Video=FFMPEG_Options:match("(.-)\0(.-)\0")
  
  return VideoCodec, AudioCodec, Width[1], Height[1], FPS, AspectRatio, FFMPEG_Options_Video, FFMPEG_Options_Audio
end

function ultraschall.GetRenderCFG_Settings_MPEG2_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_MPEG2_Video</slug>
    <requires>
      Ultraschall=4.7
      Reaper=6.62
      Lua=5.3
    </requires>
    <functioncall>integer VIDEO_CODEC, integer AUDIO_CODEC, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, string VideoExportOptions, string AudioExportOptions = ultraschall.GetRenderCFG_Settings_MPEG2_Video(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for MPEG-2-Video.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Note: this works only with FFMPEG 4.1.3 installed
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer VIDEO_CODEC - the used VideoCodec for the MPEG-2-video
                          - 0, MPEG-2
                          - 1, NONE
      integer AUDIO_CODEC - the audio-codec of the MPEG-2-video
                          - 0, aac
                          - 1, mp3
                          - 2, mp2
                          - 3, NONE
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
      string VideoExportOptions - the options for FFMPEG to apply to the video; examples: 
                                - g=1 ; all keyframes
                                - crf=1  ; h264 high quality
                                - crf=51 ; h264 small size
      string AudioExportOptions - the options for FFMPEG to apply to the audio; examples: 
                                - q=0 ; mp3 VBR highest
                                - q=9 ; mp3 VBR lowest
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the MPEG-2-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, mpeg 2, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MPEG2_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=2 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_MPEG2_Video", "rendercfg", "not a render-cfg-string of the format MPEG-2-video", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_MPEG2_Video", "rendercfg", "can't make out, which video format is chosen", -3) return nil
  end
  
  VideoCodec=string.byte(Decoded_string:sub(9,9))
  num_integers, MJPEG_quality= ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  AudioCodec=string.byte(Decoded_string:sub(17,17))
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  local FFMPEG_Options=Decoded_string:sub(45, -1)
  local FFMPEG_Options_Audio, FFMPEG_Options_Video=FFMPEG_Options:match("(.-)\0(.-)\0")
  
  return VideoCodec, AudioCodec, Width[1], Height[1], FPS, AspectRatio, FFMPEG_Options_Video, FFMPEG_Options_Audio
end

function ultraschall.GetRenderCFG_Settings_FLV_Video(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_FLV_Video</slug>
    <requires>
      Ultraschall=4.7
      Reaper=6.62
      Lua=5.3
    </requires>
    <functioncall>integer VIDEO_CODEC, integer MJPEG_quality, integer AUDIO_CODEC, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, string VideoExportOptions, string AudioExportOptions = ultraschall.GetRenderCFG_Settings_FLV_Video(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for FLV-Video.
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Note: this works only with FFMPEG 4.1.3 installed
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer VIDEO_CODEC - the used VideoCodec for the FLV-video
                          - 0, H.264
                          - 1, FLV1
                          - 2, NONE
      integer MJPEG_quality - the MJPEG-quality of the MKV-video, if VIDEO_CODEC=0
      integer AUDIO_CODEC - the audio-codec of the FLV-video
                          - 0, MP3
                          - 1, AAC
                          - 2, NONE
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
      string VideoExportOptions - the options for FFMPEG to apply to the video; examples: 
                                - g=1 ; all keyframes
                                - crf=1  ; h264 high quality
                                - crf=51 ; h264 small size
      string AudioExportOptions - the options for FFMPEG to apply to the audio; examples: 
                                - q=0 ; mp3 VBR highest
                                - q=9 ; mp3 VBR lowest
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the MPEG-2-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, flv, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_FLV_Video", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~="PMFF" or string.byte(Decoded_string:sub(5,5))~=5 then ultraschall.AddErrorMessage("GetRenderCFG_Settings_FLV_Video", "rendercfg", "not a render-cfg-string of the format FLV-video", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_FLV_Video", "rendercfg", "can't make out, which video format is chosen", -3) return nil
  end
  
  VideoCodec=string.byte(Decoded_string:sub(9,9))  
  num_integers, MJPEG_quality= ultraschall.ConvertStringToIntegers(Decoded_string:sub(41,44), 4)
  AudioCodec=string.byte(Decoded_string:sub(17,17))
  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  
  local FFMPEG_Options=Decoded_string:sub(45, -1)
  local FFMPEG_Options_Audio, FFMPEG_Options_Video=FFMPEG_Options:match("(.-)\0(.-)\0")
  
  return VideoCodec, MJPEG_quality[1], AudioCodec, Width[1], Height[1], FPS, AspectRatio, FFMPEG_Options_Video, FFMPEG_Options_Audio
end


function ultraschall.CreateRenderCFG_MPEG1_Video(VideoCodec, VIDKBPS, AudioCodec, AUDKBPS, WIDTH, HEIGHT, FPS, AspectRatio, VideoOptions, AudioOptions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MPEG1_Video</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.62
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MPEG1_Video(integer VideoCodec, integer VIDKBPS, integer AudioCodec, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, optional string VideoOptions, optional string AudioOptions)</functioncall>
  <description>
    Returns the render-cfg-string for the MPEG-1-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: works only with FFMPEG 4.1.3 installed
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected MPEG-1-Video-settings
  </retvals>
  <parameters>
    integer VideoCodec - the videocodec used for the video;
                       - 1, MPEG-1
                       - 2, NONE
    integer VIDKBPS - the video-bitrate of the video in kbps; 1 to 2147483647
    integer AudioCodec - the audiocodec to use for the video
                       - 1, MP3
                       - 2, MP2
                       - 3, NONE
    integer AUDKBPS - the audio-bitrate of the video in kbps; 1 to 2147483647
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    number FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
    optional string VideoOptions - additional FFMPEG-options for rendering the video; examples:
                                 - g=1 ; all keyframes
                                 - crf=1  ; h264 high quality
                                 - crf=51 ; h264 small size
    optional string AudioOptions - additional FFMPEG-options for rendering the video; examples:
                                 - q=0 ; mp3 VBR highest
                                 - q=9 ; mp3 VBR lowest
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mpeg 1</tags>
</US_DocBloc>
]]
  if math.type(VIDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "VIDKBPS", "Must be an integer!", -1) return nil end
  if math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "AUDKBPS", "Must be an integer!", -2) return nil end
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "VideoCodec", "Must be an integer!", -3) return nil end  
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "AudioCodec", "Must be an integer!", -4) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "WIDTH", "Must be an integer!", -5) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "HEIGHT", "Must be an integer!", -6) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -7) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "AspectRatio", "Must be a boolean!", -8) return nil end
  
  if VideoCodec<1 or VideoCodec>2 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "VideoCodec", "Must be 1", -9) return nil end  
  if AudioCodec<1 or AudioCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "AudioCodec", "Must be between 1 and 2", -10) return nil end
  if VIDKBPS<1 or VIDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "VIDKBPS", "Must be between 1 and 2147483647.", -11) return nil end
  if AUDKBPS<1 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "AUDKBPS", "Must be between 1 and 2147483647.", -12) return nil end

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "WIDTH", "Must be between 1 and 2147483647.", -13) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "HEIGHT", "Must be between 1 and 2147483647.", -14) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -15) return nil end

  if VideoOptions~=nil and type(VideoOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "VideoOptions", "Must be a string with maximum length of 255 characters!", -16) return nil end
  if AudioOptions~=nil and type(AudioOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG1_Video", "AudioOptions", "Must be a string with maximum length of 255 characters!", -17) return nil end
  if VideoOptions==nil then VideoOptions="" end
  if AudioOptions==nil then AudioOptions="" end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VIDKBPS)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)
  local VideoCodec=string.char(VideoCodec-1)
  local VideoFormat=string.char(1)
  local AudioCodec=string.char(AudioCodec-1)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, 0)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality..AudioOptions.."\0"..VideoOptions.."\0")
end

function ultraschall.CreateRenderCFG_MPEG2_Video(VideoCodec, VIDKBPS, AudioCodec, AUDKBPS, WIDTH, HEIGHT, FPS, AspectRatio, VideoOptions, AudioOptions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_MPEG2_Video</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.62
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_MPEG2_Video(integer VideoCodec, integer VIDKBPS, integer AudioCodec, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, optional string VideoOptions, optional string AudioOptions)</functioncall>
  <description>
    Returns the render-cfg-string for the MPEG-2-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: works only with FFMPEG 4.1.3 installed
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected MPEG-2-Video-settings
  </retvals>
  <parameters>
    integer VideoCodec - the videocodec used for the video;
                       - 1, MPEG-2
                       - 2, NONE
    integer VIDKBPS - the video-bitrate of the video in kbps; 1 to 2147483647
    integer AudioCodec - the audiocodec to use for the video
                       - 1, AAC
                       - 2, MP3
                       - 3, MP2
                       - 4, NONE
    integer AUDKBPS - the audio-bitrate of the video in kbps; 1 to 2147483647
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    number FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
    optional string VideoOptions - additional FFMPEG-options for rendering the video; examples:
                                 - g=1 ; all keyframes
                                 - crf=1  ; h264 high quality
                                 - crf=51 ; h264 small size
    optional string AudioOptions - additional FFMPEG-options for rendering the video; examples:
                                 - q=0 ; mp3 VBR highest
                                 - q=9 ; mp3 VBR lowest    
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, mpeg 2</tags>
</US_DocBloc>
]]
  if math.type(VIDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "VIDKBPS", "Must be an integer!", -1) return nil end
  if math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "AUDKBPS", "Must be an integer!", -2) return nil end
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "VideoCodec", "Must be an integer!", -3) return nil end  
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "AudioCodec", "Must be an integer!", -4) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "WIDTH", "Must be an integer!", -5) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "HEIGHT", "Must be an integer!", -6) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -7) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "AspectRatio", "Must be a boolean!", -8) return nil end
  
  if VideoCodec<1 or VideoCodec>2 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "VideoCodec", "Must be 1", -9) return nil end  
  if AudioCodec<1 or AudioCodec>4 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "AudioCodec", "Must be between 1 and 3", -10) return nil end
  if VIDKBPS<1 or VIDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "VIDKBPS", "Must be between 1 and 2147483647.", -11) return nil end
  if AUDKBPS<1 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "AUDKBPS", "Must be between 1 and 2147483647.", -12) return nil end

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "WIDTH", "Must be between 1 and 2147483647.", -13) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "HEIGHT", "Must be between 1 and 2147483647.", -14) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -15) return nil end

  if VideoOptions~=nil and type(VideoOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "VideoOptions", "Must be a string with maximum length of 255 characters!", -16) return nil end
  if AudioOptions~=nil and type(AudioOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_MPEG2_Video", "AudioOptions", "Must be a string with maximum length of 255 characters!", -17) return nil end
  if VideoOptions==nil then VideoOptions="" end
  if AudioOptions==nil then AudioOptions="" end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VIDKBPS)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)
  local VideoCodec=string.char(VideoCodec-1)
  local VideoFormat=string.char(2)
  local AudioCodec=string.char(AudioCodec-1)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, 0)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality..AudioOptions.."\0"..VideoOptions.."\0")
end

function ultraschall.CreateRenderCFG_FLV_Video(VideoCodec, VIDKBPS, AudioCodec, AUDKBPS, WIDTH, HEIGHT, FPS, AspectRatio, VideoOptions, AudioOptions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_FLV_Video</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.62
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_FLV_Video(integer VideoCodec, integer VIDKBPS, integer AudioCodec, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, optional string VideoOptions, optional string AudioOptions)</functioncall>
  <description>
    Returns the render-cfg-string for the FLV-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Note: works only with FFMPEG 4.1.3 installed
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected MPEG-2-Video-settings
  </retvals>
  <parameters>
    integer VideoCodec - the videocodec used for the video;
                       - 1, H.264
                       - 2, FLV1
                       - 3, NONE
    integer VIDKBPS - the video-bitrate of the video in kbps; 1 to 2147483647
    integer AudioCodec - the audiocodec to use for the video
                       - 1, MP3
                       - 2, AAC
                       - 3, NONE
    integer AUDKBPS - the audio-bitrate of the video in kbps; 1 to 2147483647
    integer WIDTH - the width of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    integer HEIGHT - the height of the video in pixels; 1 to 2147483647; only even values(2,4,6,etc) will be accepted by Reaper, uneven will be rounded up!
    number FPS - the fps of the video; must be a double-precision-float value (e.g. 9.09 or 25.00); 0.01 to 2000.00
    boolean AspectRatio - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio
    optional string VideoOptions - additional FFMPEG-options for rendering the video; examples:
                                 - g=1 ; all keyframes
                                 - crf=1  ; h264 high quality
                                 - crf=51 ; h264 small size
    optional string AudioOptions - additional FFMPEG-options for rendering the video; examples:
                                 - q=0 ; mp3 VBR highest
                                 - q=9 ; mp3 VBR lowest
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, flv</tags>
</US_DocBloc>
]]
  if math.type(VIDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "VIDKBPS", "Must be an integer!", -1) return nil end
  if math.type(AUDKBPS)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "AUDKBPS", "Must be an integer!", -2) return nil end
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "VideoCodec", "Must be an integer!", -3) return nil end  
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "AudioCodec", "Must be an integer!", -4) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "WIDTH", "Must be an integer!", -5) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "HEIGHT", "Must be an integer!", -6) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -7) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "AspectRatio", "Must be a boolean!", -8) return nil end
  
  if VideoCodec<1 or VideoCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "VideoCodec", "Must be between 1 and 2", -9) return nil end  
  if AudioCodec<1 or AudioCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "AudioCodec", "Must be between 1 and 2", -10) return nil end
  if VIDKBPS<1 or VIDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "VIDKBPS", "Must be between 1 and 2147483647.", -11) return nil end
  if AUDKBPS<1 or AUDKBPS>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "AUDKBPS", "Must be between 1 and 2147483647.", -12) return nil end

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "WIDTH", "Must be between 1 and 2147483647.", -13) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "HEIGHT", "Must be between 1 and 2147483647.", -14) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -15) return nil end
  
  if VideoOptions~=nil and type(VideoOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "VideoOptions", "Must be a string with maximum length of 255 characters!", -16) return nil end
  if AudioOptions~=nil and type(AudioOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_FLV_Video", "AudioOptions", "Must be a string with maximum length of 255 characters!", -17) return nil end
  if VideoOptions==nil then VideoOptions="" end
  if AudioOptions==nil then AudioOptions="" end
  
  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VIDKBPS)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AUDKBPS)
  local VideoCodec=string.char(VideoCodec-1)
  local VideoFormat=string.char(5)
  local AudioCodec=string.char(AudioCodec-1)
  local MJPEGQuality=ultraschall.ConvertIntegerIntoString2(4, 0)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder("PMFF"..VideoFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0"..MJPEGQuality..AudioOptions.."\0"..VideoOptions.."\0")
end


function ultraschall.GetRenderTable_ProjectDefaults()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTable_ProjectDefaults</slug>
  <requires>
    Ultraschall=5
    Reaper=7.16
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.GetRenderTable_ProjectDefaults()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all stored render-settings for the project-defaults, as a handy table.
            
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
            RenderTable["Brickwall_Limiter_Enabled"] - true, brickwall limiting is enabled; false, brickwall limiting is disabled            
            RenderTable["Brickwall_Limiter_Method"] - brickwall-limiting-mode; 1, peak; 2, true peak
            RenderTable["Brickwall_Limiter_Target"] - the volume of the brickwall-limit
            RenderTable["Bounds"] - not stored with project defaults; will use the default bounds for the source
                                    0, Custom time range; 
                                    1, Entire project; 
                                    2, Time selection; 
                                    3, Project regions; 
                                    4, Selected Media Items(in combination with Source 32); 
                                    5, Selected regions
                                    6, Razor edit areas
                                    7, All project markers
                                    8, Selected markers
            RenderTable["Channels"] - the number of channels in the rendered file; 
                                      1, mono; 
                                      2, stereo; 
                                      higher, the number of channels
            RenderTable["CloseAfterRender"] - true, closes rendering to file-dialog after render; false, doesn't close it
            RenderTable["Dither"] - &1, dither master mix; 
                                    &2, noise shaping master mix; 
                                    &4, dither stems; 
                                    &8, dither noise shaping stems
            RenderTable["EmbedMetaData"] - Embed metadata; true, checked; false, unchecked
            RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides; true, checked; false, unchecked
            RenderTable["EmbedTakeMarkers"] - Embed Take markers; true, checked; false, unchecked                        
            RenderTable["Enable2ndPassRender"] - true, 2nd pass render is enabled; false, 2nd pass render is disabled
            RenderTable["Endposition"] - the endposition of the rendering selection in seconds; always 0 because it's not stored with project defaults
            RenderTable["FadeIn_Enabled"] - true, fade-in is enabled; false, fade-in is disabled
            RenderTable["FadeIn"] - the fade-in-time in seconds
            RenderTable["FadeIn_Shape"] - the fade-in-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["FadeOut_Enabled"] - true, fade-out is enabled; false, fade-out is disabled
            RenderTable["FadeOut"] - the fade-out time in seconds
            RenderTable["FadeOut_Shape"] - the fade-out-shape
                                   - 0, Linear fade in
                                   - 1, Inverted quadratic fade in
                                   - 2, Quadratic fade in
                                   - 3, Inverted quartic fade in
                                   - 4, Quartic fade in
                                   - 5, Cosine S-curve fade in
                                   - 6, Quartic S-curve fade in
            RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked            
            RenderTable["Normalize_Enabled"] - true, normalization enabled; false, normalization not enabled
            RenderTable["Normalize_Method"] - the normalize-method-dropdownlist
                           0, LUFS-I
                           1, RMS-I
                           2, Peak
                           3, True Peak
                           4, LUFS-M max
                           5, LUFS-S max
            RenderTable["Normalize_Only_Files_Too_Loud"] - Only normalize files that are too loud,checkbox
                                                         - true, checkbox checked
                                                         - false, checkbox unchecked
            RenderTable["Normalize_Stems_to_Master_Target"] - true, normalize-stems to master target(common gain to stems)
                                                              false, normalize each file individually
            RenderTable["Normalize_Target"] - the normalize-target as dB-value
            RenderTable["NoSilentRender"] - Do not render files that are likely silent-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 
                                                    0, Full-speed Offline
                                                    1, 1x Offline
                                                    2, Online Render
                                                    3, Online Render(Idle)
                                                    4, Offline Render(Idle)
            RenderTable["OnlyChannelsSentToParent"] - true, option is checked; false, option is unchecked
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
            RenderTable["Preserve_Start_Offset"] - true, preserve start-offset-checkbox(with Bounds=4 and Source=32); false, don't preserve
            RenderTable["Preserve_Metadata"] - true, preserve metadata-checkbox; false, don't preserve
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; 
                                                           true, checked; false, unchecked
            RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog; 
                                        always "" because it's not stored with project defaults
            RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog; 
                                           always "" because it's not stored with project defaults
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; 
                                              true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 
                                                0, Sinc Interpolation: 64pt (medium quality)
                                                1, Linear Interpolation: (low quality)
                                                2, Point Sampling (lowest quality, retro)
                                                3, Sinc Interpolation: 192pt
                                                4, Sinc Interpolation: 384pt
                                                5, Linear Interpolation + IIR
                                                6, Linear Interpolation + IIRx2
                                                7, Sinc Interpolation: 16pt
                                                8, Sinc Interpolation: 512pt(slow)
                                                9, Sinc Interpolation: 768pt(very slow)
                                                10, r8brain free (highest quality, fast)
            RenderTable["RenderStems_Prefader"] - true, option is checked; false, option is unchecked
            RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
            RenderTable["RenderString2"] - the render-cfg-string, that holds all settings of the currently set secondary-render-output-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"] - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; true, checked; false, unchecked
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; true, checked; false, unchecked
            RenderTable["Source"] - 0, Master mix; 
                                    1, Master mix + stems; 
                                    3, Stems (selected tracks); 
                                    8, Region render matrix; 
                                    32, Selected media items; 
                                    64, selected media items via master; 
                                    128, selected tracks via master
                                    136, Region render matrix via master
                                    4096, Razor edit areas
                                    4224, Razor edit areas via master
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds; always 0 because it's not stored with project defaults
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked
                                      &1, custom time bounds; 
                                      &2, entire project; 
                                      &4, time selection; 
                                      &8, all project regions; 
                                      &16, selected media items; 
                                      &32, selected project regions
                                      &64, razor edit areas
            RenderTable["TailMS"] - the amount of milliseconds of the tail
    
    Returns nil in case of an error
  </description>
  <retvals>
    table RenderTable - a table with all of the current project's default render-settings
  </retvals>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>projectfiles, get, project, default, rendertable</tags>
</US_DocBloc>
]]
  local RenderTable = ultraschall.CreateNewRenderTable()

  -- debugging help
  --for k in pairs(RenderTable) do
  --  RenderTable[k]="HONK"
  --end
  
  local attributetable={
    "projrenderstems",
    "rendertails",
    "rendertaillen",
    "projrendernch",
    "projrendersrate",
    "projrenderlimit",
    "projrenderrateinternal",
    "projrenderresample",
    "projrendernorm",
    "projrendernormtgt",
    "projrenderbrickwall",
    "projrenderdither",
    "renderclosewhendone",
    "projrenderaddtoproj",
    "autosaveonrender", 
    "rendercfg",
    "rendercfg2",
    "projrenderfadein",
    "projrenderfadeout",
    "projrenderfadeinshape",
    "projrenderfadeoutshape"
  }

  for i=1, #attributetable do
    local retval, temp = reaper.BR_Win32_GetPrivateProfileString("REAPER", attributetable[i], "", reaper.get_ini_file())
    local temp2=tonumber(temp)
    if attributetable[i]~="rendercfg" and attributetable[i]~="rendercfg2" then
      attributetable[attributetable[i]]=temp2
    else
      attributetable[attributetable[i]]=temp
    end
  end
  
  attributetable["rendercfg"]=ultraschall.ConvertHex2Ascii(attributetable["rendercfg"])
  attributetable["rendercfg"]=ultraschall.Base64_Encoder(attributetable["rendercfg"]:sub(1,-2))

  attributetable["rendercfg2"]=ultraschall.ConvertHex2Ascii(attributetable["rendercfg2"])
  attributetable["rendercfg2"]=ultraschall.Base64_Encoder(attributetable["rendercfg2"]:sub(1,-2))

  RenderTable["RenderString"]=attributetable["rendercfg"]
  RenderTable["RenderString2"]=attributetable["rendercfg2"]

  if attributetable["projrenderaddtoproj"]~=nil then
    RenderTable["AddToProj"]=attributetable["projrenderaddtoproj"]&1==1
    RenderTable["NoSilentRender"]=attributetable["projrenderaddtoproj"]&2==2
  end
  
  if attributetable["projrenderstems"]~=nil then
    RenderTable["Source"]=attributetable["projrenderstems"]

    RenderTable["MultiChannelFiles"]=RenderTable["Source"]&4==4
    if RenderTable["Source"]&4==4 then RenderTable["Source"]=RenderTable["Source"]-4 end
    
    RenderTable["OnlyMonoMedia"]=RenderTable["Source"]&16==16
    if RenderTable["Source"]&16==16 then RenderTable["Source"]=RenderTable["Source"]-16 end
    
    RenderTable["EmbedStretchMarkers"]=RenderTable["Source"]&256==256
    if RenderTable["Source"]&256==256 then RenderTable["Source"]=RenderTable["Source"]-256 end
    
    RenderTable["EmbedMetaData"]=RenderTable["Source"]&512==512
    if RenderTable["Source"]&512==512 then RenderTable["Source"]=RenderTable["Source"]-512 end
    
    RenderTable["EmbedTakeMarkers"]=RenderTable["Source"]&1024==1024
    if RenderTable["Source"]&1024==1024 then RenderTable["Source"]=RenderTable["Source"]-1024 end
    
    RenderTable["Enable2ndPassRender"]=RenderTable["Source"]&2048==2048
    if RenderTable["Source"]&2048==2048 then RenderTable["Source"]=RenderTable["Source"]-2048 end
    
    RenderTable["OnlyChannelsSentToParent"]=RenderTable["Source"]&2048==2048
    if RenderTable["Source"]&8192==8192 then RenderTable["Source"]=RenderTable["Source"]-8192 end
    RenderTable["Preserve_Start_Offset"]=RenderTable["Source"]&65536==65536
    RenderTable["Preserve_Metadata"]=RenderTable["Source"]&32768==32768
            
    RenderTable["RenderStems_Prefader"]=RenderTable["Source"]&2048==2048
    if RenderTable["Source"]&16384==16384 then RenderTable["Source"]=RenderTable["Source"]-16384 end
    
    RenderTable["Bounds"]=1
    if RenderTable["Source"]==8 then RenderTable["Bounds"]=3 end
    if RenderTable["Source"]==32 then RenderTable["Bounds"]=4 end
    if RenderTable["Source"]==64 then RenderTable["Bounds"]=4 end
    
    if RenderTable["Source"]==4096 then RenderTable["Bounds"]=6 end
    if RenderTable["Source"]==4224 then RenderTable["Bounds"]=6 end
  end

  if attributetable["projrendernorm"]~=nil then
    RenderTable["Normalize_Enabled"]=attributetable["projrendernorm"]&1==1
    if attributetable["projrendernorm"]&1==1 then attributetable["projrendernorm"]=attributetable["projrendernorm"]-1 end
  
    RenderTable["Normalize_Stems_to_Master_Target"]=attributetable["projrendernorm"]&32==32
    if attributetable["projrendernorm"]&32==32 then attributetable["projrendernorm"]=attributetable["projrendernorm"]-32 end

  
    RenderTable["Brickwall_Limiter_Enabled"]=attributetable["projrendernorm"]&64==64
    if attributetable["projrendernorm"]&64==64 then attributetable["projrendernorm"]=attributetable["projrendernorm"]-64 end
    RenderTable["Brickwall_Limiter_Method"]=(attributetable["projrendernorm"]&128)
    
    if RenderTable["Brickwall_Limiter_Method"]==128 then RenderTable["Brickwall_Limiter_Method"]=2 else RenderTable["Brickwall_Limiter_Method"]=1 end
    if attributetable["projrendernorm"]&128==128 then attributetable["projrendernorm"]=attributetable["projrendernorm"]-128 end  
  
    RenderTable["Normalize_Only_Files_Too_Loud"]=attributetable["projrendernorm"]&256==256
    if attributetable["projrendernorm"]&256==256 then attributetable["projrendernorm"]=attributetable["projrendernorm"]-256 end
    RenderTable["Normalize_Method"]=attributetable["projrendernorm"]>>1
  end  
  if attributetable["autosaveonrender"]~=nil then
    RenderTable["SaveCopyOfProject"]=attributetable["autosaveonrender"]==1
  end
  
  if attributetable["rendertaillen"]~=nil then
    RenderTable["TailMS"]=attributetable["rendertaillen"]
  end
  
  if attributetable["projrendernormtgt"]~=nil then
    RenderTable["Normalize_Target"]=ultraschall.MKVOL2DB(attributetable["projrendernormtgt"])
  end

  if attributetable["projrenderbrickwall"]~=nil then
    RenderTable["Brickwall_Limiter_Target"]=ultraschall.MKVOL2DB(attributetable["projrenderbrickwall"])
  end
  
  if attributetable["projrendersrate"]~=nil then
    RenderTable["Channels"]=attributetable["projrendersrate"]
  end

  RenderTable["Startposition"]=0
  RenderTable["Endposition"]=0
  
  if attributetable["projrendernch"]~=nil then
    RenderTable["SampleRate"]=attributetable["projrendernch"]
  end
  
  if attributetable["renderclosewhendone"]~=nil then
    RenderTable["CloseAfterRender"]=attributetable["renderclosewhendone"]&1==1
    RenderTable["SilentlyIncrementFilename"]=attributetable["renderclosewhendone"]&16==16
  end
  
  RenderTable["RenderPattern"]=""
  RenderTable["RenderFile"]=""

  RenderTable["RenderQueueDelay"], RenderTable["RenderQueueDelaySeconds"] = ultraschall.GetRender_QueueDelay()
  
  if attributetable["rendertails"]~=nil then
    RenderTable["TailFlag"]=attributetable["rendertails"]
  end
  
  if attributetable["projrenderresample"]~=nil then
    RenderTable["RenderResample"]=attributetable["projrenderresample"]
  end
  
  if attributetable["projrenderlimit"]~=nil then
    RenderTable["OfflineOnlineRendering"]=attributetable["projrenderlimit"]
  end
  
  if attributetable["projrenderrateinternal"]~=nil then
    RenderTable["ProjectSampleRateFXProcessing"]=attributetable["projrenderrateinternal"]&1==1
  end
  
  if attributetable["projrenderdither"]~=nil then
    RenderTable["Dither"]=attributetable["projrenderdither"]
  end
  
  if attributetable["projrenderfadein"]~=nil then
    RenderTable["FadeIn"]=attributetable["projrenderfadein"]
  end
  
  if attributetable["projrenderfadeout"]~=nil then
    RenderTable["FadeOut"]=attributetable["projrenderfadeout"]
  end
  
  if attributetable["projrenderfadeinshape"]~=nil then
    RenderTable["FadeIn_Shape"]=attributetable["projrenderfadeinshape"]
  end

  if attributetable["projrenderfadeoutshape"]~=nil then
    RenderTable["FadeOut_Shape"]=attributetable["projrenderfadeoutshape"]
  end
  
  return RenderTable
end


function ultraschall.GetSetRenderBlocksize(is_set, value)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetSetRenderBlocksize</slug>
    <requires>
      Ultraschall=4.5
      Reaper=6.20
      SWS=2.10.0.1
      Lua=5.3
    </requires>
    <functioncall>integer blocksize = ultraschall.GetSetRenderBlocksize(boolean is_set, integer value)</functioncall>
    <description>
      gets/sets the blocksize for rendering
      
      Returns nil in case of an error
    </description>
    <retvals>
      integer blocksize - the blocksize 
    </retvals>
    <parameters>
      boolean is_set - true, set a new value; false, get the current one
      integer value - the new value, must be between 4 and 2147483647; lower for auto
    </parameters>
    <chapter_context>
      Rendering Projects
      Assistance functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, set, render blocksize</tags>
  </US_DocBloc>
  ]]
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetRenderBlocksize", "is_set", "must be a boolean", -1) return end
  if math.type(value)~="integer" then ultraschall.AddErrorMessage("GetSetRenderBlocksize", "value", "must be an integer", -2) return end
  if value<4 then value=0 end
  if value>2147483647 then value=2147483647 end
  if is_set~=true then
    return reaper.SNM_GetIntConfigVar("renderbsnew", -111)
  end
  reaper.SNM_SetIntConfigVar("renderbsnew", value)
  return value
end

function ultraschall.GetRenderCFG_Settings_WMF(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_WMF</slug>
    <requires>
      Ultraschall=4.7
      Reaper=6.59
      Lua=5.3
    </requires>
    <functioncall>integer OutputFormat, integer VIDEO_CODEC, integer VideoBitrate, integer AUDIO_CODEC, integer AudioBitrate, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio = ultraschall.GetRenderCFG_Settings_WMF(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for Windows Media Foundation-formats (WMA, WMV, MPEG-4).
      
      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer OutputFormat - the used OutputFormat
                           - 0, MPEG-4
      integer VIDEO_CODEC - the used VideoCodec for the mp4-video
                          - 0, H.264
                          - 1, no video(Reaper 6.59+)
                          - 255, no video(before Reaper 6.59)
      integer VideoBitrate - in kbps; 0 to 2147483647
      integer AUDIO_CODEC - the audio-codec of the mp4-video
                          - 0, AAC
                          - 2, no audio(Reaper 6.59+)
      integer AudioBitrate - in kbps; 0 to 2147483647
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the wmf-settings
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, aac, wmv, wmf, windows media foundation, mpeg-4, audio, video</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WMF", "rendercfg", "must be a string", -1) return -1 end
  local Decoded_string
  local num_integers, VideoCodec, MJPEG_quality, AudioCodec, Width, Height, FPS, AspectRatio, VideoBitrate, AudioBitrate, OutputFormat
  Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~=" FMW" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_WMF", "rendercfg", "not a render-cfg-string of the format windows-media-foundation", -2) return -1 end
  
  if Decoded_string:len()==4 then
    ultraschall.AddErrorMessage("GetRenderCFG_Settings_WMF", "rendercfg", "can't make out, which video format is chosen", -3) return nil
  end
  
  OutputFormat=string.byte(Decoded_string:sub(5,5))
  VideoCodec=string.byte(Decoded_string:sub(9,9))
  AudioCodec=string.byte(Decoded_string:sub(17,17))

  num_integers, Width  = ultraschall.ConvertStringToIntegers(Decoded_string:sub(25,28), 4)
  num_integers, Height = ultraschall.ConvertStringToIntegers(Decoded_string:sub(29,32), 4)
  num_integers, VideoBitrate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(13,16), 4)
  num_integers, AudioBitrate = ultraschall.ConvertStringToIntegers(Decoded_string:sub(21,24), 4)
  num_integers, FPS    = ultraschall.ConvertStringToIntegers(Decoded_string:sub(33,36), 4)
  FPS=ultraschall.IntToDouble(FPS[1])
  AspectRatio=string.byte(Decoded_string:sub(37,37))~=0
  

  
  return OutputFormat, VideoCodec, VideoBitrate[1], AudioCodec, AudioBitrate[1], Width[1], Height[1], FPS, AspectRatio
end

function ultraschall.CreateRenderCFG_WMF(OutputFormat, VideoCodec, VideoBitrate, AudioCodec, AudioBitrate, WIDTH, HEIGHT, FPS, AspectRatio)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_WMF</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.59
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_WMF(integer VideoFormat, integer VideoCodec, integer VideoBitrate, integer AudioCodec, integer AudioBitrate, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio)</functioncall>
  <description>
    Returns the render-cfg-string for the WMF-Video-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected wmf-Video-settings
  </retvals>
  <parameters>
      integer OutputFormat - the used OutputFormat
                           - 0, MPEG-4
      integer VIDEO_CODEC - the used VideoCodec for the mp4-video
                          - 0, H.264
                          - 1, no video
      integer VideoBitrate - in kbps; 0 to 2147483647
      integer AUDIO_CODEC - the audio-codec of the mp4-video
                          - 0, AAC
                          - 2, no audio
      integer AudioBitrate - in kbps; 0 to 2147483647
      integer WIDTH  - the width of the video in pixels
      integer HEIGHT - the height of the video in pixels
      number FPS  - the fps of the video; must be a double-precision-float value (9.09 or 25.00); due API-limitations, this supports 0.01fps to 2000.00fps
      boolean AspectRatio  - the aspect-ratio; true, keep source aspect ratio; false, don't keep source aspect ratio 
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, wmf</tags>
</US_DocBloc>
]]
  if math.type(OutputFormat)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "OutputFormat", "Must be an integer!", -1) return nil end
  if math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "VideoCodec", "Must be an integer!", -2) return nil end
  if math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "AudioCodec", "Must be an integer!", -3) return nil end
  if math.type(WIDTH)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "WIDTH", "Must be an integer!", -4) return nil end
  if math.type(HEIGHT)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "HEIGHT", "Must be an integer!", -5) return nil end
  if type(FPS)~="number" then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "FPS", "Must be a float-value with two digit precision (e.g. 29.97 or 25.00)!", -6) return nil end
  if type(AspectRatio)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "AspectRatio", "Must be a boolean!", -7) return nil end
  
  if VideoCodec<0 or VideoCodec>0 then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "VideoCodec", "Must be 0", -8) return nil end

  if AudioCodec<0 or AudioCodec>0 then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "AudioCodec", "Must be 0", -9) return nil end
  
  if VideoBitrate~=nil and math.type(VideoBitrate)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "VideoBitrate", "Must be an integer!", -10) return nil end
  if AudioBitrate~=nil and math.type(AudioBitrate)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "AudioBitrate", "Must be an integer!", -11) return nil end  
  if VideoBitrate==nil then VideoBitrate=2048 end
  if AudioBitrate==nil then AudioBitrate=128 end
  if VideoBitrate<1 or VideoBitrate>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "VideoBitrate", "Must be between 1 and 2147483647.", -12) return nil end
  if AudioBitrate<1 or AudioBitrate>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "AudioBitrate", "Must be between 1 and 2147483647.", -13) return nil end

  if WIDTH<1 or WIDTH>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "WIDTH", "Must be between 1 and 2147483647.", -14) return nil end
  if HEIGHT<1 or HEIGHT>2147483647 then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "HEIGHT", "Must be between 1 and 2147483647.", -15) return nil end
  if FPS<0.01 or FPS>2000.00 then ultraschall.AddErrorMessage("CreateRenderCFG_WMF", "FPS", "Ultraschall-API supports only fps-values between 0.01 and 2000.00, sorry.", -16) return nil end

  WIDTH=ultraschall.ConvertIntegerIntoString2(4, WIDTH)
  HEIGHT=ultraschall.ConvertIntegerIntoString2(4, HEIGHT)
  FPS = ultraschall.ConvertIntegerIntoString2(4, ultraschall.DoubleToInt(FPS))  

  local VIDKBPS=ultraschall.ConvertIntegerIntoString2(4, VideoBitrate)
  local AUDKBPS=ultraschall.ConvertIntegerIntoString2(4, AudioBitrate)
  local VideoCodec=string.char(VideoCodec)
  local OutputFormat=string.char(OutputFormat)
  local AudioCodec=string.char(AudioCodec)
  
  if AspectRatio==true then AspectRatio=string.char(1) else AspectRatio=string.char(0) end
  
  return ultraschall.Base64_Encoder(" FMW"..OutputFormat.."\0\0\0"..VideoCodec.."\0\0\0"..VIDKBPS..AudioCodec.."\0\0\0"..AUDKBPS..
         WIDTH..HEIGHT..FPS..AspectRatio.."\0\0\0\0\0\0\0\0")
end

CreateRenderCFG_WMF_Video=CreateRenderCFG_WMF -- look above for the actual function!!

function ultraschall.ResolvePresetName(bounds_name, options_and_formats_name)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>ResolvePresetName</slug>
   <requires>
     Ultraschall=4.7
     Reaper=6.48
     Lua=5.3
   </requires>
   <functioncall>string Bounds_Name, string Options_and_Format_Name = ultraschall.ResolvePresetName(string Bounds_Name, string Options_and_Format_Name)</functioncall>
   <description>
     returns the correct case-sensitive-spelling of a bound/options-renderpreset name.
     
     Just pass the name in any kind of case-style and it will find the correct case-sensitive-names.
    
     Returns nil in case of an error or if no such name was found
   </description>
   <parameters>
     string Bounds_Name - the name of the Bounds-render-preset you want to query
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to query
   </parameters>
   <retvals>
     string Bounds_Name - the name of the Bounds-render-preset in correct case-sensitivity as stored
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset in correct case-sensitivity as stored
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Functions</target_document>
   <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
   <tags>render management, resolve, render preset, names, format options, bounds, case sensitivity</tags>
 </US_DocBloc>
 ]]
  if bounds_name~=nil and type(bounds_name)~="string" then ultraschall.AddErrorMessage("ResolvePresetName", "bounds_name", "must be a string", -1) return end
  if options_and_formats_name~=nil and type(options_and_formats_name)~="string" then ultraschall.AddErrorMessage("ResolvePresetName", "options_and_formats_name", "must be a string", -2) return end
  local bounds_presets, bounds_names, options_format_presets, options_format_names, both_presets, both_names = ultraschall.GetRenderPreset_Names()
  local foundbounds=nil
  local found_options=nil
  
  if bounds_name~=nil then
    for i=1, #bounds_names do
      if bounds_name:lower()==bounds_names[i]:lower() then foundbounds=bounds_names[i] break end
    end
  end
  if options_and_formats_name~=nil then
    for i=1, #options_format_names do
      if options_and_formats_name:lower()==options_format_names[i]:lower() then found_options=options_format_names[i] break end
    end
  end
  return foundbounds, found_options
end

function ultraschall.SetRender_SaveRenderStats(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetRender_SaveRenderStats</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.71
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetRender_SaveRenderStats(boolean state)</functioncall>
  <description>
    Sets the "Save outfile.render_stats.html"-checkboxstate of the Render to File-dialog.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </parameters>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, set, checkbox, render, save outfile renderstats</tags>
</US_DocBloc>
]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("SetRender_SaveRenderStats", "state", "must be a boolean", -1) return false end
  local SaveCopyOfProject, hwnd, retval
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd~=nil then
    if state==true then newstate=1 else newstate=0 end
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1174), "BM_SETCHECK", newstate,0,0,0)
    retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "renderqdelay", newstate, reaper.get_ini_file())
  end

  local nstate=reaper.SNM_GetIntConfigVar("renderclosewhendone", 0)
  if nstate&32768==0 and state==true then nstate=nstate+32768
  elseif nstate&32768==32768 and state==false then nstate=nstate-32768 end

  local A=reaper.SNM_SetIntConfigVar("renderclosewhendone", nstate)
  retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "renderclosewhendone", nstate, reaper.get_ini_file())
  if retval==false then ultraschall.AddErrorMessage("SetRender_SaveRenderStats", "", "couldn't write to reaper.ini", -2) return false end
  return retval
end

--ultraschall.SetRender_QueueDelay(true)
--SLEM()

function ultraschall.GetRender_SaveRenderStats()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRender_SaveRenderStats</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.71
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetRender_SaveRenderStats()</functioncall>
  <description>
    Sets the "Save outfile.render_stats.html"-checkboxstate of the Render to File-dialog.
  </description>
  <retvals>
    boolean state - true, check the checkbox; false, uncheck the checkbox
  </retvals>
  <chapter_context>
    Rendering Projects
    Render Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, get, checkbox, render, outfile renderstats</tags>
</US_DocBloc>
]]
  local SaveCopyOfProject, hwnd, retval, length, state
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    state=reaper.SNM_GetIntConfigVar("renderclosewhendone", 0)&32768==1
  else
    state = reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1174), "BM_GETCHECK", 0,0,0,0)
    if state==0 then state=false else state=true end
  end
  return state
end


function ultraschall.StoreRenderTable_ProjExtState(proj, section, RenderTable)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StoreRenderTable_ProjExtState</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.StoreRenderTable_ProjExtState(ReaProject proj, string section, table RenderTable)</functioncall>
  <description>
    Stores the render-settings of a RenderTable into a project-extstate.
  </description>
  <parameters>
    ReaProject proj - the project, into which you want to store the render-settings
    string section - the section-name, into which you want to store the render-settings
    table RenderTable - the RenderTable which holds all render-settings
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>render functions, store, render table, projextstate</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidReaProject(proj)==false then ultraschall.AddErrorMessage("StoreRenderTable_ProjExtState", "proj", "must be a valid ReaProject", -1) return end
  if type(section)~="string" then ultraschall.AddErrorMessage("StoreRenderTable_ProjExtState", "section", "must be a string", -2) return end
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("StoreRenderTable_ProjExtState", "RenderTable", "must be a valid RenderTable", -3) return end
  
  for k, v in pairs(RenderTable) do
    reaper.SetProjExtState(proj, section, k, tostring(v))
  end
end

--ultraschall.StoreRenderTable_ProjExtState(0, "test", A)

function ultraschall.GetRenderTable_ProjExtState(proj, section)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTable_ProjExtState</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.GetRenderTable_ProjExtState(ReaProject proj, string section)</functioncall>
  <description>
    Gets the render-settings of a RenderTable from a project-extstate, stored by SetRenderTable_ProjExtState.
  </description>
  <retvals>
    table RenderTable - the stored render-settings as a RenderTable
  </retvals>
  <parameters>
    ReaProject proj - the project, in which you stored the render-settings
    string section - the section-name, in which you stored the render-settings
  </parameters>  
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>render functions, get, render table, projextstate</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidReaProject(proj)==false then ultraschall.AddErrorMessage("GetRenderTable_ProjExtState", "proj", "must be a valid ReaProject", -1) return end
  if type(section)~="string" then ultraschall.AddErrorMessage("GetRenderTable_ProjExtState", "section", "must be a string", -2) return end
  
  local RenderTable=ultraschall.CreateNewRenderTable()
  for k, v in pairs(RenderTable) do
    local retval, val = reaper.GetProjExtState(proj, section, k)
    if type(v)=="number" then val=tonumber(val)
    elseif type(v)=="boolean" then val=toboolean(val)
    elseif val=="" then val=v
    end
    RenderTable[k]=val
  end
  return RenderTable
end

--B=ultraschall.GetRenderTable_ProjExtState(0, "test")

function ultraschall.StoreRenderTable_ExtState(section, RenderTable, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StoreRenderTable_ExtState</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.StoreRenderTable_ExtState(string section, table RenderTable, boolean persist)</functioncall>
  <description>
    Stores the render-settings of a RenderTable into an extstate.
  </description>
  <parameters>
    string section - the section-name, into which you want to store the render-settings
    table RenderTable - the RenderTable which holds all render-settings
    boolean persist - true, the settings shall be stored long-term; false, the settings shall be stored until Reaper exits
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>render functions, store, render table, extstate</tags>
</US_DocBloc>
--]]
  if type(section)~="string" then ultraschall.AddErrorMessage("StoreRenderTable_ExtState", "section", "must be a string", -1) return end
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("StoreRenderTable_ExtState", "RenderTable", "must be a valid RenderTable", -2) return end
  if type(persist)~="boolean" then ultraschall.AddErrorMessage("StoreRenderTable_ExtState", "persist", "must be a boolean", -3) return end
  
  for k, v in pairs(RenderTable) do
    reaper.SetExtState(section, k, tostring(v), persist)
  end
end

--ultraschall.StoreRenderTable_ExtState("test", A, false)

function ultraschall.GetRenderTable_ExtState(section)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTable_ExtState</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.GetRenderTable_ExtState(string section)</functioncall>
  <description>
    Gets the render-settings of a RenderTable from an extstate, stored by SetRenderTable_ExtState.
  </description>
  <retvals>
    table RenderTable - the stored render-settings as a RenderTable
  </retvals>
  <parameters>
    string section - the section-name, in which you stored the render-settings
  </parameters>  
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>render functions, get, render table, extstate</tags>
</US_DocBloc>
--]]
  if type(section)~="string" then ultraschall.AddErrorMessage("GetRenderTable_ExtState", "section", "must be a string", -1) return end
  
  local RenderTable=ultraschall.CreateNewRenderTable()
  for k, v in pairs(RenderTable) do
    local val = reaper.GetExtState(section, k)
    if type(v)=="number" then val=tonumber(val)
    elseif type(v)=="boolean" then val=toboolean(val)
    elseif val=="" then val=v
    end
    RenderTable[k]=val
  end
  return RenderTable
end

--B=ultraschall.GetRenderTable_ExtState("test")
--ultraschall.IsValidRenderTable(B)

function ultraschall.CreateRenderCFG_RAW(bitrate, write_sidecar_file)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_RAW</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_RAW(integer bitrate, boolean write_sidecar_file)</functioncall>
  <description>
    Returns the render-cfg-string for the RAW-PCM-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected RAW PCM-settings
  </retvals>
  <parameters>
    integer bitrate - the bitrate 
                    - 1, 8 bit unsigned
                    - 2, 8 bit signed
                    - 3, 16 bit little endian
                    - 4, 24 bit little endian
                    - 5, 32 bit little endian
                    - 6, 16 bit big endian
                    - 7, 24 bit big endian
                    - 8, 32 bit big endian
                    - 9, 32 bit FP little endian
                    - 10, 64 bit FP little endian
                    - 11, 32 bit FP big endian
                    - 12, 64 bit FP big endian
    boolean write_sidecar_file - true, write a .rsrc.txt sidecar file; false, don't write a sidecar file
  </parameters>
  <chapter_context>
    Rendering Projects
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, create, render, outputformat, raw, pcm, sidecar</tags>
</US_DocBloc>
]]
  if math.type(bitrate)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_RAW", "bitrate", "must be an integer", -1) return end
  if type(write_sidecar_file)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_RAW", "write_sidecar_file", "must be a boolean", -2) return end
  if bitrate<1 or bitrate>12 then ultraschall.AddErrorMessage("CreateRenderCFG_RAW", "bitrate", "must be between 1 and 12", -3) return end
  if     bitrate==1 then bitrate=8 option=4 -- 8bit unsigned
  elseif bitrate==2 then bitrate=8 option=0 -- 8bit signed
  elseif bitrate==3 then bitrate=16 option=0 -- 16 bit little endian
  elseif bitrate==4 then bitrate=24 option=0 -- 24 bit little endian
  elseif bitrate==5 then bitrate=32 option=0 -- 32 bit little endian
  elseif bitrate==6 then bitrate=16 option=2 -- 16 bit big endian
  elseif bitrate==7 then bitrate=24 option=2 -- 24 bit big endian
  elseif bitrate==8 then bitrate=32 option=2 -- 32 bit big endian
  elseif bitrate==9 then bitrate=32 option=1 -- 32 bit FP little endian
  elseif bitrate==10 then bitrate=64 option=1 -- 64 bit FP little endian
  elseif bitrate==11 then bitrate=32 option=3 -- 32 bit FP big endian
  elseif bitrate==12 then bitrate=64 option=3 -- 64 bit FP big endian
  end
  if write_sidecar_file==false then option=option+64 end
  --print2(option)
  return ultraschall.Base64_Encoder(" war"..string.char(bitrate)..string.char(option))
end

function ultraschall.GetRenderCFG_Settings_RAW(rendercfg)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRenderCFG_Settings_RAW</slug>
    <requires>
      Ultraschall=5
      Reaper=7.0
      Lua=5.4
    </requires>
    <functioncall>integer bitrate, boolean write_sidecar_file = ultraschall.GetRenderCFG_Settings_RAW(string rendercfg)</functioncall>
    <description>
      Returns the settings stored in a render-cfg-string for RAW PCM.

      You can get this from the current RENDER_FORMAT using reaper.GetSetProjectInfo_String or from ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
      
      Returns -1 in case of an error
    </description>
    <retvals>
      integer bitrate - the encoding-depth of the raw-pcm
      integer bitrate - the bitrate 
                      - 1, 8 bit unsigned
                      - 2, 8 bit signed
                      - 3, 16 bit little endian
                      - 4, 24 bit little endian
                      - 5, 32 bit little endian
                      - 6, 16 bit big endian
                      - 7, 24 bit big endian
                      - 8, 32 bit big endian
                      - 9, 32 bit FP little endian
                      - 10, 64 bit FP little endian
                      - 11, 32 bit FP big endian
                      - 12, 64 bit FP big endian
      boolean write_sidecar_file - true, write .rsrc.txt sidecar file; false, don't write a sidecar file
    </retvals>
    <parameters>
      string render_cfg - the render-cfg-string, that contains the raw-settings; 
    </parameters>
    <chapter_context>
      Rendering Projects
      Analyzing Renderstrings
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>render management, get, settings, rendercfg, renderstring, raw, pcm, sidecar</tags>
  </US_DocBloc>
  ]]
  if type(rendercfg)~="string" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_RAW", "rendercfg", "must be a string", -1) return -1 end
  if rendercfg==nil then
    local retval
    retval, rendercfg = reaper.BR_Win32_GetPrivateProfileString("flac sink defaults", "default", "", reaper.get_ini_file())
    if retval==0 then rendercfg="63616C661000000005000000AB" end
    rendercfg = ultraschall.ConvertHex2Ascii(rendercfg)
    rendercfg=ultraschall.Base64_Encoder(rendercfg)
  end
  local Decoded_string = ultraschall.Base64_Decoder(rendercfg)
  if Decoded_string==nil or Decoded_string:sub(1,4)~=" war" then ultraschall.AddErrorMessage("GetRenderCFG_Settings_RAW", "rendercfg", "not a render-cfg-string of the format raw pcm", -2) return -1 end
   
  if Decoded_string:len()==4 then
    return 3, false
  end
  local bitrate=string.byte(Decoded_string:sub(5,5))
  local option= string.byte(Decoded_string:sub(6,6))
  if option&64==64 then option=option-64 end
  local val=-2
  if     bitrate==8 and option==4 then val=1 -- 8bit unsigned
  elseif bitrate==8 and option==0 then val=2-- 8bit signed
  elseif bitrate==16 and option==0 then val=3-- 16 bit little endian
  elseif bitrate==24 and option==0 then val=4-- 24 bit little endian
  elseif bitrate==32 and option==0 then val=5-- 32 bit little endian
  elseif bitrate==16 and option==2 then val=6-- 16 bit big endian
  elseif bitrate==24 and option==2 then val=7-- 24 bit big endian
  elseif bitrate==32 and option==2 then val=8-- 32 bit big endian
  elseif bitrate==32 and option==1 then val=9-- 32 bit FP little endian
  elseif bitrate==64 and option==1 then val=10-- 64 bit FP little endian
  elseif bitrate==32 and option==3 then val=11-- 32 bit FP big endian
  elseif bitrate==64 and option==3 then val=12-- 64 bit FP big endian
  end
  return val, string.byte(Decoded_string:sub(6,6))&64==0
end


