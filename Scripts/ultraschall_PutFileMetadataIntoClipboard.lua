--[[
################################################################################
#
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function ultraschall.Metadata_ExtractCover(media_filename, target_filename)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_ExtractCover</slug>
  <requires>
    Ultraschall=5.4
    Reaper=7.03
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string filename = ultraschall.Metadata_ExtractCover(string media_filename, string target_filename)</functioncall>
  <description>
    Extracts the cover-image from a media-file into an image-file.
    
    Note: don't add the extension to the target-filename, since the filetype is defined by the stored cover-image(usually jpeg or png).
    Use the return value "filename" to get the actual filename of the cover-image.
    
    returns false in case of an error
  </description> 
  <retvals>
    boolean retval - true, cover image was extracted; false, cover-image couldn't be extracted
    string filename - the filename of the extracted cover-image
    string image_description - a description of the image
    string cover_image - the binary-data of the cover-image
    string cover_type - the type of the cover-image
  </retvals>
  <parameters>
    string media_filename - the media-file, whose cover-image you want to extract
    optional string target_filename - the filename, where you want to store the cover-image(don't add an extension); nil, don't write a file
  </parameters>
  <chapter_context>
    Metadata Management
    Reaper Metadata Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, extract, cover image</tags>
</US_DocBloc>
]]
  if type(media_filename)~="string" then ultraschall.AddErrorMessage("Metadata_ExtractCover", "media_filename", "must be a string", -1) return false, "" end
  if target_filename~=nil and type(target_filename)~="string" then ultraschall.AddErrorMessage("Metadata_ExtractCover", "target_filename", "must be nil or a string", -2) return false, "" end
  if reaper.file_exists(media_filename)==false then ultraschall.AddErrorMessage("Metadata_ExtractCover", "media_filename", "no such file", -3) return false end
  local PCM_Source=reaper.PCM_Source_CreateFromFile(media_filename)
  local A,B,C=reaper.GetMediaFileMetadata(PCM_Source, "ID3:APIC")
  reaper.PCM_Source_Destroy(PCM_Source)
  if A==0 then ultraschall.AddErrorMessage("Metadata_ExtractCover", "media_filename", "no cover-image", -4) return false end

  local filetype, offset, length = B:match("image/(.-) .- offset:(.-) length:(.*)")

  local image_desc, image_type = B:match("desc:(.*) type:(.-) ")
  if image_desc==nil then
    image_desc=""
    image_type = B:match("type:(.-) ")
  end
  local length, C = ultraschall.ReadBinaryFile_Offset(media_filename, tonumber(offset), tonumber(length))
  local retval
  if target_filename~=nil then
    retval = ultraschall.WriteValueToFile(target_filename.."HUTZ."..filetype, C, true)
  end
  if target_filename==nil then target_filename="" else target_filename=target_filename.."."..filetype end
  if retval==-1 then ultraschall.AddErrorMessage("Metadata_ExtractCover", "target_filename", "can't write file", -5) return false, "" end

  if image_type=="0" then image_type="Other"
  elseif image_type=="1" then image_type="32x32 pixel file icon (PNG only)" 
  elseif image_type=="2" then image_type="Other file icon" 
  elseif image_type=="3" then image_type="Cover (front)"
  elseif image_type=="4" then image_type="Cover (back)" 
  elseif image_type=="5" then image_type="Leaflet page" 
  elseif image_type=="6" then image_type="Media" 
  elseif image_type=="7" then image_type="Lead artist/Lead performer/Soloist" 
  elseif image_type=="8" then image_type="Artist/Performer" 
  elseif image_type=="9" then image_type="Conductor" 
  elseif image_type=="10" then image_type="Band/Orchestra" 
  elseif image_type=="11" then image_type="Composer" 
  elseif image_type=="12" then image_type="Lyricist/Text Writer" 
  elseif image_type=="13" then image_type="Recording location" 
  elseif image_type=="14" then image_type="During recording" 
  elseif image_type=="15" then image_type="During performance" 
  elseif image_type=="16" then image_type="Movie/video screen capture" 
  elseif image_type=="17" then image_type="A bright colored fish" 
  elseif image_type=="18" then image_type="Illustration" 
  elseif image_type=="19" then image_type="Band/Artist logotype" 
  elseif image_type=="20" then image_type="Publisher/Studio logotype" 
  end
  
  return true, target_filename, image_desc, image_type, C, filetype
end

retval, filename = reaper.GetUserFileNameForRead(reaper.GetExtState("Ultraschall", "Export_Metadata_Path"), "Choose file", "")
if retval==false then return end

filename=string.gsub(filename, "\\", "/")
path=filename:match("(.*/)")
reaper.SetExtState("Ultraschall", "Export_Metadata_Path", path, true)

source=reaper.PCM_Source_CreateFromFile(filename)
metadata, metadata1=reaper.GetMediaFileMetadata(source, "")

metadata_tab={}
for k in string.gmatch(metadata1.."\n", "(.-)\n") do
  retval, metadata_tab[k]=reaper.GetMediaFileMetadata(source, k)
end

chapters={}
for k, v in pairs(metadata_tab) do
  if k:match("CHAP")~=nil then
    local id=tonumber(k:match("CHAP(.*)"))
    chapters[id]={}
    chapters[id]["time"], chapters[id]["title"]=v:match("(.-):.-:(.*)")
    chapters[id]["time"]=tonumber(chapters[id]["time"])*0.001
    chapters[id]["time"]=reaper.format_timestr(chapters[id]["time"], "")
  end
end


final_metadata={}

for k,v in pairs(metadata_tab) do
  if k:match("CHAP")==nil and k:match("CTOC")==nil and k:match("APIC")==nil then
    final_metadata[k]=v
  end
end

retval=0
if metadata_tab["ID3:APIC"]~=nil then
  retval, cover_filename = reaper.JS_Dialog_BrowseForSaveFile("Save Cover Image", reaper.GetExtState("Ultraschall", "Export_Metadata_Path"), "", "")
  retval1, cover_filename_, cover_type, cover_description, cover_data, cover_filetype = ultraschall.Metadata_ExtractCover(filename)
  if cover_filename:match(".*%.(.*)")==cover_filetype then cover_filetype="" else cover_filetype="."..cover_filetype end
  ultraschall.WriteValueToFile(cover_filename..cover_filetype, cover_data)
end
if retval==0 then cover_filename="" else cover_filename="Stored cover-image at "..cover_filename..cover_filetype.."\n\n" end

Metadata="Metadata for file: "..filename.."\n"
for k,v in pairs(final_metadata) do
  Metadata=Metadata.."  "..k..": "..v.."\n"
end

if #chapters>0 then Metadata=Metadata.."\nChapters:\n" end

for i=1, #chapters do
  Metadata=Metadata.."  Chapter #"..i.." - Time: "..chapters[i]["time"].." - Title: "..chapters[i]["title"].."\n"
end


reaper.PCM_Source_Destroy(source)

reaper.CF_SetClipboard(Metadata)
reaper.MB("Metadata stored in clipboard."..cover_filename,"",0)
