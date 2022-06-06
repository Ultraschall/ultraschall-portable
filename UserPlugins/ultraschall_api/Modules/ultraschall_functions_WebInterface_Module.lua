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
---      WebInterface Module      ---
-------------------------------------

function ultraschall.WebInterface_GetInstalledInterfaces()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WebInterface_GetInstalledInterfaces</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer reapers_webinterface_count, array reapers_webinterface_filenames, array reapers_webinterface_titles, integer users_webinterface_count, array users_webinterface_filenames, array users_webinterface_titles = ultraschall.WebInterface_GetInstalledInterfaces()</functioncall>
  <description>
    Returns the currently installed web-interface-pages.
    
    Will return Reaper's default ones(resources-folder/Plugins/reaper_www_root/) as well as your customized ones(resources-folder/reaper_www_root/)
  </description>
  <retvals>  
    integer reapers_webinterface_count - the number of factory-default webinterfaces, installed by Reaper
    array reapers_webinterface_filenames - the filenames with path of the webinterfaces(can be .htm or .html)
    array reapers_webinterface_titles - the titles of the webinterfaces, as shown in the titlebar of the browser
    integer users_webinterface_count - the number of user-customized webinterfaces
    array users_webinterface_filenames - the filenames with path of the webinterfaces(can be .htm or .html)
    array users_webinterface_titles - the titles of the webinterfaces, as shown in the titlebar of the browser
  </retvals>
  <chapter_context>
    Web Interface
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_WebInterface_Module.lua</source_document>
  <tags>web interface, get, all, installed, webrc, filename, title</tags>
</US_DocBloc>
]]  
  local filecount, files = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/Plugins/reaper_www_root")
  local files_WEBRC_names={}
  for i=filecount, 1, -1 do
    if files[i]:sub(-5,-1):match("%.htm")==nil then
      table.remove(files, i)
      filecount=filecount-1
    end
  end
  for i=1, filecount do
    local A=ultraschall.ReadFullFile(files[i])
    local start, ende=A:lower():match("<title>().-()</title>")
    if start==nil or ende==nil then  
      files_WEBRC_names[i]=""
    else
      files_WEBRC_names[i]=A:sub(start, ende-1)
    end
  end

  local filecount2, files2 = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/reaper_www_root")
  local files_WEBRC_names2={}
  for i=filecount2, 1, -1 do
    if files2[i]:sub(-5,-1):match("%.htm")==nil then
      table.remove(files2, i)
      filecount2=filecount2-1
    end
  end
  for i=1, filecount2 do
    local A=ultraschall.ReadFullFile(files2[i])
    local start, ende=A:lower():match("<title>().-()</title>")
    if start==nil or ende==nil then  
      files_WEBRC_names2[i]=""
    else
      files_WEBRC_names2[i]=A:sub(start, ende-1)
    end
  end
  
  return filecount, files, files_WEBRC_names, filecount2, files2, files_WEBRC_names2
end
