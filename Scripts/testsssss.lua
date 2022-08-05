dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

gfx.init("")
function DisplayImage(x,y,imgwidth,imgheight,image,functioncall)
  -- display newly selected image, scaled and centered

  gfx.dest=-1
  local width, height=gfx.getimgdim(image)
  local size=width
  if width>imgwidth then size=width end
  if height>imgheight and height>size then size=height end
  local scale=imgheight/size
  gfx.rect(x-1,y-1,imgwidth+2,imgheight+2,0)
  local retval = ultraschall.GFX_BlitImageCentered(image, x+math.floor(imgwidth/2), y+math.floor(imgheight/2), scale, 0)
  if gfx.mouse_cap&1==1 and gfx.mouse_x>=x and gfx.mouse_x<=x+width and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    functioncall()
  end
end

function LoadImage(filename, image)
  gfx.loadimg(image, filename)
end

--LoadImage("c:\\tempvideo2-2.png", 4)
--DisplayImage(10,10,100,100,4)
