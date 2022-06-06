  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2022 Ultraschall (http://ultraschall.fm)
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

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

x,y=reaper.GetMousePosition()
state=ultraschall.ShowMenu("Docs Chain", "1. Push To Git|2. All Docs|3. Changelog|4. US-API", x, y-55)
path=ultraschall.Api_Path.."/Scripts/Tools/Docgenerator"
if state==1 then
  --ultraschall.Main_OnCommandByFilename(path:match("(.*)/Docgener").."/Reapack-API-xml-generator.lua")
  ultraschall.RunCommand("_RS05fed2445cd68755f220fbf9db90dc4db03f5da5")
elseif state==2 then
  ultraschall.Main_OnCommandByFilename(path.."/Doc_CreationPipeLine_v2.lua")
elseif state==3 then
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_ChangelogConverterDoc.lua")  
elseif state==4 then
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_ApiDownloads_Generator.lua")  
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_ConceptsDocConverter_DOC_v2.lua")  
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_ConceptsDocConverter_GFX_v2.lua")  
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_ConceptsDocConverter_v2.lua")  
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_ConceptsDocConverter_VID_v2.lua")  
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_Doc_DOC_Converter_v2.lua")  
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_Doc_Func_Converter_v2.lua")  
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_Doc_GFX_Converter_v2.lua")  
  ultraschall.Main_OnCommandByFilename(path.."/Ultraschall_Doc_VID_Converter_v2.lua")  
end
SLEM()

--A=reaper.file_exists("C:\\Ultraschall-US_API_4.1.001/ultraschall_api/Scripts/Tools/Docgenerator/Doc_CreationPipeLine_v2.lua")
