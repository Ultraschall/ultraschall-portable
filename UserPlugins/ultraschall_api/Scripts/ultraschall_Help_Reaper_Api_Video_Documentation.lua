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


--A=ultraschall.OpenURL("file://"..ultraschall.Api_Path .."Documentation/Reaper_API_Video_Documentation.html")

function OpenURL(url)
  local OS=reaper.GetOS()
  url="\""..url.."\""
  if OS=="OSX32" or OS=="OSX64" or OS=="macOS-arm64" then
    os.execute("open ".. url)
  elseif OS=="Other" then
    os.execute("xdg-open "..url)
  else
    B="start \"Ultraschall-URL\" /B ".. url
    os.execute("start \"Ultraschall-URL\" /B ".. url)
  end
  return true
end

_,filename=reaper.get_action_context()

Sep=package.config:sub(1,1)

filename=filename:match("(.*)[\\/]"):sub(1,-2)
filename=filename:match("(.*)[\\/]")..Sep.."Documentation"..Sep.."Reaper_API_Video_Documentation.html"
filename=reaper.GetResourcePath()..Sep.."UserPlugins"..Sep.."ultraschall_api"..Sep.."Documentation"..Sep.."Reaper_API_Video_Documentation.html"

OpenURL("file:///"..string.gsub(filename, "\\", "/"))
