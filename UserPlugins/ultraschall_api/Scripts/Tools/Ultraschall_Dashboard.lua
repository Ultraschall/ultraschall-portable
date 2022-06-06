if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

gfx.init()

-- useful values, maybe put these into Dashes-table
Byte=1/255        -- get the minimum-value of one of the color-values; only in here to minimize divisions(speed improvements)
Destination=10    -- debug, which framebuffer shall be shown?
dragpointsize=5   -- size of the dragging-points for resizing

-- Testentries
Dashes={}
Dashes["refresh"]=true -- refresh the dashboard
Dashes["count"]=3      -- number of dashes available
Dashes["focused"]=1    -- currently focused element
Dashes["oldx"]=nil     -- for drag, old x position
Dashes["oldy"]=nil     -- for drag, old y position
Dashes["dragwhat"]=0   -- which dragging point is currently hovered?
Dashes["hover"]=0      -- which element is currently hoveres?

Dashes[1]={}           -- create new element
Dashes[1]["x"]=10      -- x-position of the dash
Dashes[1]["y"]=10      -- y-position of the dash
Dashes[1]["x2"]=100    -- right-side-position of the dash
Dashes[1]["y2"]=100    -- bottom-position of the dash
Dashes[2]={}
Dashes[2]["x"]=200
Dashes[2]["y"]=200
Dashes[2]["x2"]=250
Dashes[2]["y2"]=250
Dashes[3]={}
Dashes[3]["x"]=20
Dashes[3]["y"]=20
Dashes[3]["x2"]=30
Dashes[3]["y2"]=30


function DrawDashed()
  -- initialize size of buffers to current window-height
  gfx.setimgdim(10, gfx.w, gfx.h)
  gfx.setimgdim(11, gfx.w, gfx.h)
  
  -- if content shall be refreshed
  if Dashes["refresh"]==true then
    -- first, initialize framebuffers
    gfx.dest=10 -- drawing-dash-buffer
    gfx.set(0)
    gfx.rect(0,0,gfx.w,gfx.h,1)
    
    gfx.dest=11 -- z-buffer
    gfx.set(0)
    gfx.rect(0,0,gfx.w,gfx.h,1)
    
    for i=1, Dashes["count"] do
      -- draw dashboard
      gfx.dest=10
      if Dashes["dragwhat"]~=0 and i==Dashes["hover"] then
        -- let's draw dragging-points, if mouse is hovering above them
        E=reaper.time_precise() -- debug
        gfx.set(1,1,1,0.8)
        gfx.rect(Dashes[i]["x"], Dashes[i]["y"], dragpointsize, dragpointsize, 1)
        gfx.rect(Dashes[i]["x"], Dashes[i]["y2"]-dragpointsize, dragpointsize, dragpointsize, 1)
        gfx.rect(Dashes[i]["x2"]-dragpointsize, Dashes[i]["y2"]-dragpointsize, dragpointsize, dragpointsize, 1)
        gfx.rect(Dashes[i]["x2"]-dragpointsize, Dashes[i]["y"], dragpointsize, dragpointsize, 1)
      end
      -- draw rectangle of the dash
      gfx.set(1)
      gfx.rect(Dashes[i]["x"], Dashes[i]["y"],
               Dashes[i]["x2"]-Dashes[i]["x"], Dashes[i]["y2"]-Dashes[i]["y"], 0)
               
      -- draw z-sortbuffer
      gfx.dest=11
      
      -- make dash-index into color for z-buffer; r and g index the element, g the dragging-points
      -- I should limit it to 300 dashes to not run out of buffers, 
      -- as every dash shall have three components:
      --   1. drawn-dash - which will be shown
      --   2. velocity map - which allows for individual clicking areas, optional for clickable elements
      --   3. icon - an optionally shown icon(to the left of the dash)
      -- I guess, I can use up to 950 buffers safely, which means up to 317 dashes when used in full.
      -- Shall I request further buffers? Or shall I dynamically set them, so dashes w/o icon and velocity
      -- map just eat up one slot, while dashes with all of them eat three slots.
      --
      -- Do people actually use for than 300 dashes? I mean, how much screenestate can someone actually have?
      Byte1, Byte2, Byte3, Byte4 = ultraschall.SplitIntegerIntoBytes(i)
      Byte1=Byte*Byte1
      Byte2=Byte*Byte2
      
      -- draw the rectangle with color r,g being the index and b=0
      gfx.set(Byte1, Byte2, 0)
      gfx.rect(Dashes[i]["x"], Dashes[i]["y"],
               Dashes[i]["x2"]-Dashes[i]["x"], Dashes[i]["y2"]-Dashes[i]["y"], 1)
      -- draw the dragging-points with color r,g being the index and b=index of the dragging-point
      gfx.set(Byte1, Byte2, Byte)
      gfx.rect(Dashes[i]["x"], Dashes[i]["y"], dragpointsize, dragpointsize, 1)
      gfx.set(Byte1, Byte2, Byte+Byte)
      gfx.rect(Dashes[i]["x"], Dashes[i]["y2"]-dragpointsize, dragpointsize, dragpointsize, 1)
      gfx.set(Byte1, Byte2, Byte+Byte+Byte)
      gfx.rect(Dashes[i]["x2"]-dragpointsize, Dashes[i]["y2"]-dragpointsize, dragpointsize, dragpointsize, 1)
      gfx.set(Byte1, Byte2, Byte+Byte+Byte+Byte)
      gfx.rect(Dashes[i]["x2"]-dragpointsize, Dashes[i]["y"], dragpointsize, dragpointsize, 1)
    end
    gfx.dest=-1
  end
  Dashes["refresh"]=false -- prevent further refresh until it is deliberatily requested by any event like click, drag, dash-updated
end

function GetDashedClicked()
  clickstate, specific_clickstate, mouse_cap, click_x, click_y, dragx, dragy, mouse_wheel, mouse_hwheel = ultraschall.GFX_GetMouseCap()
  -- first, gethover for dragging-points
  gfx.dest=11
  gfx.x=gfx.mouse_x
  gfx.y=gfx.mouse_y
  local R,G,B=gfx.getpixel()
  R=math.tointeger(R*255)
  G=math.tointeger(G*255)
  B=math.tointeger(B*255)
  if Dashes["dragwhat"]~=B then Dashes["refresh"]=true end
  Dashes["dragwhat"]=B
  Dashes["hover"] = ultraschall.CombineBytesToInteger(0,R,G,0)

  -- set focused dash, if anything is clicked
  if clickstate=="CLK" and specific_clickstate~="DRAG" then
    Dashes["dragwhat"]=B
    Dashes["focused"] = ultraschall.CombineBytesToInteger(0,R,G,0)
    Dashes["refresh"]=true
  elseif clickstate~="CLK" and B==0 then
    Dashes["dragwhat"]=0
  end

  -- drag dash around; dragging points for resizing still must be implemented, look into Dashed["dragwhat"] for the clicked dragpoint
  if specific_clickstate=="DRAG" and Dashes["focused"]>0 then
    Dashes["hover"]=Dashes["focused"] -- while dragging, the hovered shall be the focused one;
                                      -- to prevent shown draggingpoints of other dashes, when mouse is 
                                      -- hovering above them while dragging the focused around
                                      -- otherwise it will go down the z-buffer-order
    -- x-dragging
    if Dashes["dragwhat"]==0 then
      if Dashes["oldx"]==nil then Dashes["oldx"]=dragx end
      if Dashes["oldy"]==nil then Dashes["oldy"]=dragy end
      if dragx~=Dashes["oldx"] then 
        Dashes["refresh"]=true
        Dashes[Dashes["focused"]]["x"]  = Dashes[Dashes["focused"]]["x"] -(Dashes["oldx"]-dragx)
        Dashes[Dashes["focused"]]["x2"] = Dashes[Dashes["focused"]]["x2"]-(Dashes["oldx"]-dragx)
        Dashes["oldx"]=dragx
      end
      
      --y-dragging
      if dragy~=Dashes["oldy"] then 
        Dashes["refresh"]=true
        Dashes[Dashes["focused"]]["y"]  = Dashes[Dashes["focused"]]["y"] -(Dashes["oldy"]-dragy)
        Dashes[Dashes["focused"]]["y2"] = Dashes[Dashes["focused"]]["y2"]-(Dashes["oldy"]-dragy)
        Dashes["oldy"]=dragy
      end
      -- show dragging points while dragging as visual clue; comment this out, to avoid that
      Dashes["dragwhat"]=-1
    elseif Dashes["dragwhat"]==1 then -- left/uppper draggingpoint-dragging
    elseif Dashes["dragwhat"]==2 then -- left/bottom draggingpoint-dragging
    elseif Dashes["dragwhat"]==3 then -- right/bottom draggingpoint-dragging
    elseif Dashes["dragwhat"]==4 then -- right/upper draggingpoint-dragging
    end
  else
    -- resed old dragging-coordinates, when dragging stops
    Dashes["oldx"]=nil
    Dashes["oldy"]=nil
  end
  gfx.dest=-1
end

function main()
  -- debug
  A=gfx.getchar()
  if A==65 then Dashes["refresh"]=true end -- A - refresh
  if A==49 then Destination=10 end         -- 1 - dash-drawing
  if A==50 then Destination=11 end         -- 2 - z-buffer-drawing
  
  -- manage the dashboard
  GetDashedClicked()  -- get clickstates and react
  DrawDashed()        -- update the dashboard
  --print_update(Dashes["dragwhat"])

  -- blit the dashboard
  gfx.x=1
  gfx.y=1
  gfx.blit(Destination,1,0)

  reaper.defer(main)
end


main()
