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

files={}
files[#files+1]=reaper.GetResourcePath().."//BR.ini"
files[#files+1]=reaper.GetResourcePath().."//reaninjam.ini"
files[#files+1]=reaper.GetResourcePath().."//reapack.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-auplugins64.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-auplugins64-bc.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-defpresets.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-dxplugins64.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-dynsplit.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-extstate.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-fxfolders.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-fxlearn.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-fxoptions.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-fxtags.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-hwoutfx.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-install.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-joystick.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-jsfx.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-menu.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-midihw.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-mouse.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-pinstates.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-recentfx.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-reginfo2.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-screensets.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-themeconfig.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-vstfxppath.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-vstplugins64.ini"
files[#files+1]=reaper.GetResourcePath().."//reaper-wndpos.ini"
files[#files+1]=reaper.GetResourcePath().."//S&M.ini"
files[#files+1]=reaper.GetResourcePath().."//S&M_Cyclactions.ini"
files[#files+1]=reaper.GetResourcePath().."//sws-autocoloricon.ini"
files[#files+1]=reaper.GetResourcePath().."//ultraschall.ini"
files[#files+1]=reaper.GetResourcePath().."//Ultraschall_ShortCutsList.ini"
files[#files+1]=reaper.GetResourcePath().."//Ultraschall-Inspector.ini"
files[#files+1]=reaper.GetResourcePath().."//ultraschall-settings.ini"
files[#files+1]=reaper.GetResourcePath().."//Xenakios_Commands.ini"

--]]

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
fxfilecount, fxfiles = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/presets/")
for i=1, fxfilecount do
--  files[#files+1]=reaper.GetResourcePath().."/presets/"..fxfiles[i]:match(".*/(.*)")
end

filecount=#files

maximumpowercounter=30

--ultraschall={}
--[[
function ultraschall.ReadFullFile(filename_with_path, binary)
  -- Returns the whole file filename_with_path or nil in case of error

  -- check parameters
  if filename_with_path == nil then ultraschall.AddErrorMessage("ReadFullFile", "filename_with_path", "must be a string", -1) return nil end
  if reaper.file_exists(filename_with_path)==false then return nil end
  
  -- prepare variables
  if binary==true then binary="b" else binary="" end
  local linenumber=0
  
  -- read file
  local file=io.open(filename_with_path,"r"..binary)
  local filecontent=file:read("a")
  
  -- count lines in file, when non binary
  if binary~=true then
    for w in string.gmatch(filecontent, "\n") do
      linenumber=linenumber+1
    end
  else
    linenumber=-1
  end
  file:close()
  -- return read file, length and linenumbers
  return filecontent, filecontent:len(), linenumber
end
--]]

vartable={}
--vartable
reaper_ini=""

counter2=1
while files[counter2]~=nil do
  file=ultraschall.ReadFullFile(files[counter2],false)
  if file~=nil then reaper_ini=reaper_ini..files[counter2].."\n"..file end
  counter2=counter2+1
end
  

counter=1

for line in reaper_ini:gmatch("(.-)%c") do
  if line:match("%[.-%]")==nil and line:match("=")==nil and line~="" then FILE=line end
  if line:match("%[.-%]") then SECTION=line:match("%[(.-)%]") end
  if line:match(".-=.*") then 
    Key=line:match("(.-)=")
    Value=line:match("=(.*)")
    vartable[FILE..SECTION..Key]=Value
    counter=counter+1 
  end
end

savepowercounter=1

function main()
  if savepowercounter>maximumpowercounter then
    savepowercounter=1
    counter2=1
    reaper_ini=""
    while files[counter2]~=nil do
      file=ultraschall.ReadFullFile(files[counter2],false)
      if file~=nil then reaper_ini=reaper_ini..files[counter2].."\n"..file end
      counter2=counter2+1
    end
    for line in reaper_ini:gmatch("(.-)%c") do
      if line:match("%[")==nil and line:match("=")==nil and line~="" then FILE=line end
  --    if line:match("%[.-%)%)") then FILE=line:match("%[(.-)%)%)") end
      if line:match("%[.-%]") then SECTION=line:match("%[(.-)%]") end
      if line:match(".-=.*") then 
        Key=line:match("(.-)=")
        Value=line:match("=(.*)")
  
        if vartable[FILE..SECTION..Key]~=line:match(".-=(.*)") then 
          reaper.ShowConsoleMsg(FILE.."->["..SECTION.."] -> "..Key.."\n\tOld: "..tostring(vartable[FILE..SECTION..Key]).."   -   ")
          T=true
          local A1=tonumber(vartable[FILE..SECTION..Key])
          vartable[FILE..SECTION..Key]=Value
          reaper.ShowConsoleMsg("New: "..tostring(vartable[FILE..SECTION..Key]))
          local A2=tonumber(vartable[FILE..SECTION..Key])
          if A1~=nil and A2~=nil then
            reaper.ShowConsoleMsg("   -   Dif to old value: "..(A1-A2).." \n")
          else
            reaper.ShowConsoleMsg("\n")
          end
        end
      end
    end
  end
  if T==true then T=false reaper.ShowConsoleMsg("\n") end
  savepowercounter=savepowercounter+1
  O=reaper.time_precise()
  reaper.defer(main)
end

main()
