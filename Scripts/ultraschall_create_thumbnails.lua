dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

num_params, params, caller_script_identifier = ultraschall.GetScriptParameters()


if num_params<=3 then return end

reaper.SetExtState("A", "2", caller_script_identifier, false)
--print2(caller_script_identifier)

--needed parameters:
FileList=[[
c:/Ultraschall-Hackversion_3.2_US_beta_2_9/Data/track_icons/amp_combo.png
c:/Ultraschall-Hackversion_3.2_US_beta_2_9/Data/track_icons/folder.png
c:/Ultraschall-Hackversion_3.2_US_beta_2_9/Data/track_icons/hihat.png
c:/Ultraschall-Hackversion_3.2_US_beta_2_9/Data/track_icons/meter.png
c:/Ultraschall-Hackversion_3.2_US_beta_2_9/Data/track_icons/ac_guitar.png
c:/Ultraschall-Hackversion_3.2_US_beta_2_9/Data/track_icons/ac_guitar_full.png
c:/Ultraschall-Hackversion_3.2_US_beta_2_9/Data/track_icons/amp.png
]]

OutputDirectory=params[1]
filecount, files = ultraschall.CSV2IndividualLinesAsArray(params[2], "\n")
rectsize=tonumber(params[3])


--InputDirectory="c:\\quadrant\\pics\\"
--InputDirectory="c:\\mespotine\\"
--InputDirectory="c:\\pics\\"
--InputDirectory="c:\\mespotine\\website-backup\\wordpress\\pics"
--OutputDirectory="c:\\temp\\A2"

--filecount, files = ultraschall.GetAllFilenamesInPath(InputDirectory)
--dirscount, dirs, filecount, files = ultraschall.GetAllRecursiveFilesAndSubdirectories(InputDirectory)
counter=1

xoffset=-40
yoffset=35

thumbnail_offset=350


retval, hwnd = ultraschall.GFX_Init("Create Thumbnails", 350+rectsize, 70+rectsize, 0, nil, 70)
retval, style = reaper.JS_Window_SetStyle(hwnd, "CAPTION")
gfx.set(0)
gfx.rect(-100,-100,9000,9000,1)
X1, Y1 = gfx.clienttoscreen(xoffset, yoffset)
X1=math.floor(X1)
Y1=math.floor(Y1)

if reaper.GetOS():match("Other")~=nil then 
--  gfx.setfont(1,"Arial",100,0)
  gfx.setfont(2,"Arial",13,66)
elseif reaper.GetOS():match("Win")~=nil then
--  gfx.setfont(1,"Arial",110,0)
  gfx.setfont(2,"Arial",16,66)
else
--  gfx.setfont(1,"Arial",100,0)
  gfx.setfont(2,"Arial",14,66)
end


percentage=""

function atexit()
  gfx.quit()
--  reaper.SetExtState("ultraschall", "ChapterMarkerPictures_thumbnailsgenerator", "done", false)
  retval = ultraschall.SetScriptReturnvalues(caller_script_identifier, "Done")
  reaper.SetExtState("ultraschall_thumbnails", "Done", "Done", false)
end

progress=0

function main()
--    if counter>0 and doit==true then ultraschall.CaptureScreenAreaAsPNG(OutputDirectory.."/"..(counter-1)..".png", X1, Y1, rectsize, rectsize) end
    if counter>0 and doit==true then 
      if counter<1000 then zero="0" end
      if counter<100 then zero="00" end
      if counter<10 then zero="000" end
      retval = ultraschall.CaptureWindowAsPNG(hwnd, OutputDirectory.."/"..zero..(counter-1)..".png", xoffset+thumbnail_offset+4,yoffset+27, rectsize, rectsize, false) end
    doit=false
    gfx.set(0.2,0.2,0.2)
    gfx.rect(0,0,1000,1000)
    gfx.set(1,1,1,1)
    Key=gfx.getchar(65536)
    A,B,C,D,E=ultraschall.PrintProgressBar(false, 257, filecount, counter, true, 0)
    if D~=nil then progress=D end
    gfx.set(1,1,1)
    gfx.rect(xoffset+73, yoffset+23, 261, 22, 0)
    gfx.set(0.5, 0.5, 0.5)
    gfx.rect(xoffset+75, yoffset+25, progress, 18, 1)
    gfx.set(1,1,1)    
    gfx.x=xoffset+75
    gfx.y=yoffset-1
    if C~=nil then percentage=C.." %" end
    gfx.drawstr("Creating Thumbnails for Chapterimages:")
    gfx.x=xoffset+190
    gfx.y=yoffset+26
    
    gfx.drawstr(percentage)
    if Key&2~=0 then
      retval=gfx.loadimg(1, files[counter])
      if retval~=-1 then
        doit=true
        xx,yy=gfx.getimgdim(1)
        
        ratiox=((100/xx)*rectsize)/100
        ratioy=((100/yy)*rectsize)/100
        
        if xx>=yy then Scalestart=ratiox else Scalestart=ratioy end
        
        Pix=xx*Scalestart
        Piy=yy*Scalestart
        
        if Pix<rectsize then Xcenter=(rectsize-Pix)/2 else Xcenter=0 end
        if Piy<rectsize then Ycenter=(rectsize-Piy)/2 else Ycenter=0 end
        
        if ratiox<ratioy then 
          ratio=ratiox
        else 
          ratio=ratioy
        end
  
        gfx.x=xoffset+Xcenter+thumbnail_offset
        gfx.y=yoffset+Ycenter+4
        gfx.set(0)
        gfx.rect(xoffset+thumbnail_offset,yoffset+4,rectsize,rectsize,1)
        gfx.blit(1,ratio,0)        
      end
      counter=counter+1
  end
  gfx.set(1)
  gfx.rect(xoffset+thumbnail_offset,yoffset+4,rectsize,rectsize,0)
  if counter<=filecount then reaper.defer(main) end
end


function initialize()
  reaper.JS_Window_SetForeground(hwnd)
  reaper.defer(main)
end


reaper.atexit(atexit)
initialize()

