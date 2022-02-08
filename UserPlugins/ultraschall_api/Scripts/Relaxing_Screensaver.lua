-- Screensaver - Meo-Ada Mespotine 20th of December 2021
-- licensed under MIT-license

MaxStars=2521












gfx.init("Nirvana Screensaver")
Stars={}
UseStars=1200
Saturation=255
circlesize=20
Help=true

for i=1, MaxStars do
  Stars[i]={}
  Stars[i]["count"]=math.random(255)/255
  Stars[i]["x"]=math.random(1000)-gfx.w/2
  Stars[i]["y"]=math.random(1000)-gfx.h/2
  Stars[i]["deltax"]=math.random(3)
  Stars[i]["deltay"]=math.random(3)
  Stars[i]["dirx"]=math.random(5)-1
  if Stars[i]["dirx"]==0 then Stars[i]["dirx"]=Stars[i]["dirx"]+1 end
  Stars[i]["diry"]=math.random(5)-1
  if Stars[i]["diry"]==0 then Stars[i]["diry"]=Stars[i]["diry"]+1 end
  Stars[i]["r"]=math.random(255)/Saturation
  Stars[i]["g"]=math.random(255)/Saturation
  Stars[i]["b"]=math.random(255)/Saturation
  Stars[i]["a"]=math.random(255)/Saturation
end

centerx=gfx.w/2
centery=gfx.h/2

function main()
  x,y=gfx.screentoclient(gfx.mouse_x, gfx.mouse_y)
  centerx=gfx.w/2
  centery=gfx.h/2
  x=x-centerx
  y=y-centery
  gfx.mode=1
  for i=1, UseStars-1 do
    Stars[i]["count"]=Stars[i]["count"]+0.001
    gfx.set(Stars[i]["r"], Stars[i]["g"], Stars[i]["b"], Stars[i]["a"])
    gfx.rect(Stars[i]["x"]+centerx, Stars[i]["y"]+centery, 2, 2, true)
    gfx.arc(Stars[i]["x"]+centerx, Stars[i]["y"]+centery, Stars[i]["count"]*circlesize,30,20,1)
    gfx.set(Stars[i]["r"], Stars[i]["g"], Stars[i]["b"], 0.3)
    gfx.line(Stars[i]["x"]+centerx, Stars[i]["y"]+centery, Stars[i+1]["x"]+centerx, Stars[i+1]["y"]+centery,1)
    if (Stars[i]["x"]>gfx.w+centerx and Stars[i]["y"]>gfx.h+centery) or (Stars[i]["x"]<-centerx*2 or Stars[i]["y"]<-centerx*2) then
      Stars[i]["x"]=x/2
      Stars[i]["y"]=y/2

      Stars[i]["dirx"]=math.random(3)-3
      if Stars[i]["dirx"]==0 then Stars[i]["dirx"]=Stars[i]["dirx"]+1 end
      Stars[i]["diry"]=math.random(3)-3
      if Stars[i]["diry"]==0 then Stars[i]["diry"]=Stars[i]["diry"]+1 end
      Stars[i]["count"]=math.random(255)/255
      Stars[i]["r"]=math.random(Saturation)/Saturation
      Stars[i]["g"]=math.random(Saturation)/Saturation
      Stars[i]["b"]=math.random(Saturation)/Saturation
      Stars[i]["a"]=math.random(Saturation)/Saturation
    end
    Stars[i]["x"]=Stars[i]["x"]+(Stars[i]["deltax"]*Stars[i]["dirx"])*0.8
    Stars[i]["y"]=Stars[i]["y"]+(Stars[i]["deltay"]*Stars[i]["diry"])*0.8

  end
  gfx.x=0
  gfx.y=0
  gfx.blurto(gfx.w,gfx.h)
  A=gfx.getchar()
  Up=30064
  Down=1685026670.0
  -- Number of Elements
  if A==30064 then UseStars=UseStars+10 if UseStars>MaxStars then UseStars=MaxStars end gfx.x=gfx.w-200 gfx.set(1) gfx.y=gfx.h-gfx.texth gfx.drawstr("Num Elements: "..UseStars) end
  if A==1685026670.0 then UseStars=UseStars-10 if UseStars<21 then UseStars=21 end gfx.x=gfx.w-200 gfx.set(1) gfx.y=gfx.h-gfx.texth gfx.drawstr("Num Elements: "..UseStars) end
  
  if A==1919379572.0 then Saturation=Saturation+10 if Saturation>255 then Saturation=255 end gfx.x=gfx.w-200 gfx.set(1) gfx.y=gfx.h-gfx.texth gfx.drawstr("Saturation: "..Saturation) end
  if A==1818584692.0 then Saturation=Saturation-10 if Saturation<1 then Saturation=1 end gfx.x=gfx.w-200 gfx.set(1) gfx.y=gfx.h-gfx.texth gfx.drawstr("Saturation: "..Saturation) end

  
  if A==43 then circlesize=circlesize+1 gfx.x=gfx.w-200 gfx.set(1) gfx.y=gfx.h-gfx.texth gfx.drawstr("Circlesize: "..circlesize) end
  if A==45 then circlesize=circlesize-1 gfx.x=gfx.w-200 gfx.set(1) gfx.y=gfx.h-gfx.texth gfx.drawstr("Circlesize: "..circlesize) end
  
  if A==104 and Help==true then Help=false elseif A==104 and Help==false then Help=true end
  
  if Help~=false then
    gfx.set(1,1,1,0.6)
    gfx.x=180
    gfx.y=330
    gfx.drawstr([[
    Use H to toggle this help.
    
    Move mouse around to influence the patterns.
    
    
    +/- influence circle-size
    
    up/down influence the number of shown elements
    
    left/right influence the saturation of shown elements
    
    
    Have fun in Nirvana... - Meo-Ada Mespotine 2021
    ]])
  end
  
  gfx.rect(gfx.mouse_x, gfx.mouse_y, 4,4,1)
  if A~=-1 then
    reaper.defer(main)
  end
end

main()
