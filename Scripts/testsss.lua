dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

A,rendercfg=reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT", "", false)

function ultraschall.CreateRenderC11FG_WebMVideo(VIDKBPS, AUDKBPS, WIDTH, HEIGHT, FPS, AspectRatio, VideoCodec, AudioCodec, VideoOptions, AudioOptions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_WebMVideo</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.62
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_WebMVideo(integer VIDKBPS, integer AUDKBPS, integer WIDTH, integer HEIGHT, number FPS, boolean AspectRatio, optional string VideoOptions, optional string AudioOptions)</functioncall>
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
    optional integer VideoCodec - the videocodec used for the video;
                       - nil, VP8
                       - 1, VP8
                       - 2, VP9(needs FFMPEG 4.1.3 to be installed)
                       - 3, NONE
    optional integer AudioCodec - the audiocodec to use for the video
                       - nil, VORBIS
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
  
  if VideoOptions~=nil and type(VideoOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "VideoOptions", "Must be a string with maximum length of 255 characters!", -14) return nil end
  if AudioOptions~=nil and type(AudioOptions)~="string" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "AudioOptions", "Must be a string with maximum length of 255 characters!", -15) return nil end
  if VideoOptions==nil then VideoOptions="" end
  if AudioOptions==nil then AudioOptions="" end
  
  if VideoCodec~=nil and math.type(VideoCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "VideoCodec", "Must be an integer!", -13) return nil end  
  if VideoCodec==nil then VideoCodec=0 end
  if AudioCodec~=nil and math.type(AudioCodec)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "AudioCodec", "Must be an integer!", -14) return nil end
  if AudioCodec==nil then AudioCodec=0 end
  if VideoCodec<1 or VideoCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "VideoCodec", "Must be between 1 and 2", -15) return nil end  
  if AudioCodec<1 or AudioCodec>3 then ultraschall.AddErrorMessage("CreateRenderCFG_WebMVideo", "AudioCodec", "Must be between 1 and 2", -16) return nil end

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

A={ultraschall.GetRenderCFG_Settings_WebM_Video(rendercfg)}

--reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT", A, true)
