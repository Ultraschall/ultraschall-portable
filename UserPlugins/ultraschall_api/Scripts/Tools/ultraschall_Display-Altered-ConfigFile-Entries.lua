files={}
files[1]=reaper.get_ini_file()
files[2]=reaper.GetResourcePath().."//reaper-midihw.ini"
files[3]=reaper.GetResourcePath().."/reaper-extstate.ini"
files[4]=reaper.GetResourcePath().."/reaper-dxplugins64.ini"
files[5]=reaper.GetResourcePath().."/reaper-reginfo2.ini"
files[6]=reaper.GetResourcePath().."/BR.ini"
files[7]=reaper.GetResourcePath().."/S&M.ini"
files[8]=reaper.GetResourcePath().."/sws-autocoloricon.ini"
files[9]=reaper.GetResourcePath().."/reaper-recentfx.ini"
files[10]=reaper.GetResourcePath().."/reaper-menu.ini"
files[11]=reaper.GetResourcePath().."/reaper-mouse.ini"
files[12]=reaper.GetResourcePath().."/reaper-install.ini"
files[13]=reaper.GetResourcePath().."/reaper-vstplugins64.ini"
files[14]=reaper.GetResourcePath().."/reaper-fxtags.ini"
files[15]=reaper.GetResourcePath().."/reaper-fxoptions.ini"
files[16]=reaper.GetResourcePath().."/Xenakios_Commands.ini"
files[17]=reaper.GetResourcePath().."/S&M_Cyclactions.ini"
files[18]=reaper.GetResourcePath().."/reaninjam.ini"
files[19]=reaper.GetResourcePath().."/reaper-auplugins64.ini"
files[20]=reaper.GetResourcePath().."/S&M_Cyclactions.ini"
files[21]=reaper.GetResourcePath().."/reaper-defpresets.ini"
files[22]=reaper.GetResourcePath().."/reaper-fxfolders.ini"
files[23]=reaper.GetResourcePath().."/reaper-screensets.ini"
files[24]=reaper.GetResourcePath().."/reaper-joystick.ini"
files[25]=reaper.GetResourcePath().."/reaper-pinstates.ini"
files[26]=reaper.GetResourcePath().."/S&M_Cyclactions.ini"
files[27]=reaper.GetResourcePath().."/ultraschall.ini"
--]]

maximumpowercounter=30

ultraschall={}

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
          reaper.ShowConsoleMsg(FILE.."->["..SECTION.."] -> "..Key.." = "..tostring(vartable[FILE..SECTION..Key]).."\n")
          T=true
          vartable[FILE..SECTION..Key]=Value
        end
      end
    end
  end
  if T==true then T=false reaper.ShowConsoleMsg("\n") end
  savepowercounter=savepowercounter+1
  reaper.defer(main)
end

main()
