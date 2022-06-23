-- Moonlander - Meo Mespotine Juli 2019

-- the game is licensed under an MIT-license
-- radio-communication, lunar-module-photo by NASA during the Apollo program and are public domain
-- svoe.mp3 and kkst10.mp3 are by Meo Mespotine from the Klangkonstellation-project and
-- is licensed under a creative-commons-license cc-by-nc
-- find more from Klangkonstellation at https://klangkonstellation.bandcamp.com/

-- TODO:
-- when changing length of window, the landscape doesn't move accordingly, unlike Apollo11
-- crash, thruster-sounds still missing
-- endless starfield, earth, sound, better collision detection, tilting the apollo-module when sideway-movements, endless lunar surface(currently ends at some point)

AA,BB,CC,DD=reaper.get_action_context()
Path=BB:match("(.*)[/\\]").."/"

if reaper.JS_Window_Find==nil or reaper.Xen_StopSourcePreview==nil then reaper.MB("Sorry, you need to have JS-extension 0.989 or higher installed", "Error", 0) return end

function atexit()
  reaper.Xen_StopSourcePreview(-1)
end

reaper.atexit(atexit)

gfx.init("Moonlander", 1000, 600)

scale=1
AAaA=string.match(reaper.GetOS(), "OS")
if string.match( reaper.GetOS(), "OS")~=nil then
  scale = 1--math.floor(1 * 0.8)
  macoffset=-16
  winoffset=0
  font="times"
else
  macoffset=3
  winoffset=10
  scale=1
  font="times"
end


gfx.setfont(1,"arial",math.floor(17*scale),0)
gfx.setfont(2,font,math.floor(80*scale),98)
gfx.setfont(3,"arial",math.floor(20*scale),73)
gfx.setfont(4,"arial",math.floor(15*scale),0)
gfx.setfont(5,"arial",math.floor(15*scale),0)

  PCM_sourcebgm1=reaper.PCM_Source_CreateFromFile(Path.."/moonlander/svoe.mp3")
  PCM_source2bgm=reaper.Xen_StartSourcePreview(PCM_sourcebgm1, 0.2, false)
  PCM_sourcebgm=reaper.PCM_Source_CreateFromFile(Path.."/moonlander/kkst10.mp3")
  PCM_source2bgm=reaper.Xen_StartSourcePreview(PCM_sourcebgm, 0.15, true)

  PCM_sourcebgm=reaper.PCM_Source_CreateFromFile(Path.."/moonlander/onesmallstepforman.mp3")
  PCM_source2bgm=reaper.Xen_StartSourcePreview(PCM_sourcebgm, 0.1, false)


AAA=gfx.loadimg(11, Path.."/moonlander/apollo11.png")
AAA2=gfx.loadimg(15, Path.."/moonlander/us.png")

gfx.setimgdim(12,800,800)
gfx.dest=12
gfx.x=350
gfx.y=350
gfx.blit(11,1,0)
gfx.dest=-1
gfx.x=1
gfx.y=1

lasttime=reaper.time_precise()

side=-20000.0
thrust=-1.0
fall=0
bottom=0.0
top=0.0
left=0.0
right=0.0
fuel=1000
level=1

function comp(a,b)
  if a>b then return true else return false end
end

function Highscore()
  Table={}
  for i=1, 10 do
    Table[i]=reaper.GetExtState("Mespotine's Moonlander", "Place"..i)
    if Table[i]==nil then Table[i]="000," end
  end
  Add=0
  temp=tonumber(Table[10]:match("(.-),"))
  if temp==nil then temp=0 end
  if temp<level then
    a,b=reaper.GetUserInputs("Enter your name, stranger", 1, "Name", "")

    if b==nil then b="" end
    if level<10 then nuller="00"
    elseif level<100 then nuller="0"
    else nuller=""
    end
    Table[11]=nuller..level..","..b
    Add=1
  end

  table.sort(Table)
  textstring="Level\t\tName"
  count=0
  for i=10+Add, 1+Add, -1 do
    count=count+1
    local a=Table[i]:match("(.-),")
    local b=Table[i]:match(",(.*)")
    if a==nil then a="" end
    if b==nil then b="" end

    textstring=textstring.."\n"..a.."\t...\t"..b
    reaper.SetExtState("Mespotine's Moonlander", "Place"..count, Table[i], true)
  end
  Creditcounter=1
  reaper.MB(textstring,"Highscore!!!!",0)
end

function restart_game()
  fuel=fuel+40
  if fuel>1000 then fuel=1000 end
  side=-20000.0
  thrust=-1+math.floor(1)
  fall=0+math.floor(1)
  bottom=0.0+math.floor(1)
  top=0.0+math.floor(1)
  left=0.0+math.floor(1)
  right=0.0+math.floor(1)
  endit=false
  if fuel<=0 or crash==true then crash=false Highscore() val=1 delta=0 titlerotate=-1 Titlemain() endit=true fuel=1000 level=1 else level=level+1 end
  GenerateNewLandscape()
  reaper.JS_Window_SetFocus(reaper.JS_Window_Find("Moonlander", true))
  --main()
end

function GenerateNewLandscape()
  Landscape={}

  for i=1, 20000 do
    Landscape[i]=math.random(150)
    if i>1 and math.random(100)>60+level then Landscape[i]=Landscape[i-1] end
  end

  Starfield={}
  for i=-100000, 100000 do
    Starfield[i]={}
    Starfield[i][1]=math.random(15000)
    Starfield[i][2]=math.random(500)
    Starfield[i][3]=math.random(10)
    if i>1 and math.random(100)>99 then Starfield[i]=Starfield[i-1] end
  end
end

function starfield()
  for a=1+math.floor(side/6000), 8000+math.floor(side/6000) do
    if Starfield[a][1]+side*(Starfield[a][3]*0.009)>0 and Starfield[a][1]+side*(Starfield[a][3]*0.009)<gfx.w then
      if Starfield[a][2]<floorbg2 and Starfield[a][2]<floorbg then
        gfx.x=Starfield[a][1]+side*(Starfield[a][3]*0.009)
        gfx.y=Starfield[a][2]
        drownout=Starfield[a][2]*0.023
        gfx.setpixel((Starfield[a][3]-drownout)*0.1,(Starfield[a][3]-drownout)*0.1,(Starfield[a][3]-drownout)*0.1)
      end
    end
  end
end

function crashed()
  endit=true
  crash=true
  PCM_source_landed=reaper.PCM_Source_CreateFromFile(Path.."/moonlander/wehadaproblem2.mp3")
  PCM_source2=reaper.Xen_StartSourcePreview(PCM_source_landed, 0.1, false)
  reaper.MB("Crashed","",0)
  restart_game()
end

function lostinspace()
  endit=true
  crash=true
  PCM_source_landed=reaper.PCM_Source_CreateFromFile(Path.."/moonlander/wehadaproblem.mp3")
  PCM_source2=reaper.Xen_StartSourcePreview(PCM_source_landed, 0.1, false)
  reaper.MB("Lost in Space","",0)
  thrust=-1.0
  restart_game()
end

function landed()
  endit=true
  PCM_source_landed=reaper.PCM_Source_CreateFromFile(Path.."/moonlander/apollo11.mp3")
  PCM_source2=reaper.Xen_StartSourcePreview(PCM_source_landed, 0.1, false)
  reaper.MB("The Eagle Has Landed","",0)
  restart_game()
end


function drawapollo()
  gfx.set(0.7)
  gfx.x=gfx.w/2-14
  gfx.y=fall-20
  gfx.blit(11,0.14,0+shiprotate)
  gfx.set(1)
  if fuel>0 then
    if bottom > 0 then
      gfx.triangle((gfx.w/2)+7, fall+10,(gfx.w/2)+2, fall+10,(gfx.w/2)+5, fall+bottom+10)
    end
    if left > 0 then
      gfx.rect((gfx.w/2)+15, fall+3, left, 4)
    end
    if right> 0 then
      gfx.rect((gfx.w/2)-right-5, fall+3, right, 4)
    end
    gfx.set(1)
  end

end

function collisiondetection()
-- still buggy with slopes, hits even, if it didn't hit the slopes, if it's lower than the top point
-- need to find the "face" of the slope and detect, if it crossed the face.
-- if its y-lower than top and x further than half between the two of them, then detect crash
-- if it's lower than top and bottom, then detect crash
  x=gfx.w/2+6
  y=fall+12
      --[[
        gfx.x=x
        gfx.y=y
        gfx.drawstr(x)
        --]]

  x2=gfx.w/2
  y2=fall+12

  --debug points
  --gfx.rect(x,y,4,4,1)
  --gfx.rect(x2,y2,4,4,1)

  if floor==floor2 then
    if y>=floor then
      if thrust<-0.2 and sidethrust<0.3 then landed() else crashed() end
    else
      C="flying equal"..y.." "..(floor).." "..fall
    end
  else
    if y>=floor or y>=floor2 then
    -- Buggy, when having slopes, it will not correctly recognize
    -- the slopes, but rather, if top or bottom has been surpassed.
      crashed()
    else
      C="flying inequal"..y.." "..(floor).." "..fall
    end
  end
  --    C=(y)
  --    D=(floor)-fall+offset
  --    E=C>=D
end

function drawosd()
  gfx.x=gfx.w-150
  gfx.y=10
  thrust=thrust+0.0
  gfx.drawstr("Level:"..(level)..
              "\n\nFuel:  "..
              math.floor(fuel)..
              "\nSpeed: "..
              tostring(thrust+1):match(".-%.%d")
                )

end

function drawlandscape()
  a=1
  offset=250
  for i=200, 9000 do
    a=a+20
    if a+side>0 then
      gfx.set(1)
      gfx.line(a+side, Landscape[i-1]+150-fall/1.8+offset, a+20+side, Landscape[i]+150-fall/1.8+offset)
      gfx.set(0.5)
      gfx.line((a+side)/2, Landscape[i-100]/2+100-fall/2.3-50+offset, (a+20+side)/2, Landscape[i-99]/2+100-fall/2.3-50+offset)
      gfx.line((a+side)*2, Landscape[i-100]*2.5+350-fall+offset, (a+20+side)*2, Landscape[i-99]*2.5+350-fall+offset)

      if a+side>(gfx.w/2)-10 and a+side<(gfx.w/2)+10 then
        floor=Landscape[i-1]+150-fall/1.8+offset floor2=Landscape[i]+150-fall/1.8+offset
        floorbg=Landscape[i-100]/2+100-fall/2.3-50+offset floorbg2=Landscape[i-99]*2.5+350-fall+offset
      end

    end
    if (a+side*2)>gfx.w then break end
  end
end

sidethrust=0
shiprotate=0


function main()
  A=gfx.getchar()
--  if A~=0 then reaper.CF_SetClipboard(A) end
  if A==1818584692.0 and fuel>0 then side=side+0.00010 left=left+0.3 shiprotate=shiprotate-0.01 sidethrust=sidethrust+0.1 end
  if A==1919379572.0 and fuel>0 then side=side-0.00010 right=right+0.3 shiprotate=shiprotate+0.01 sidethrust=sidethrust-0.1 end
  if A==30064.0 and fuel>0 then thrust=thrust-.065 bottom=bottom+0.8 end
  if A==27 then gfx.quit() end
  shiprotate=0
  thrust=thrust+.005
  bottom=bottom-0.05
  top=top-0.2
  right=right-0.2
  left=left-0.2
  if bottom<0 then bottom=0.0 end
  if bottom>8 then bottom=6.0 end
  if top<0 then top=0.0 end
  if top>7 then top=6.0 end
  if left<0 then left=0.0 end
  if left>8 then left=6.0 end
  if right<0 then right=0.0 end
  if right>8 then right=6.0 end
  if fall<-100 and thrust<-3 then lostinspace() end

  if bottom>4 or top>4 or left>4 or right>4 then
   fuel=fuel-(0.1*(bottom+(0.5*top+left+right)))
  end
  if fuel<0 then fuel=0 end
  fall=(fall+1)+thrust*0.9

  side=side+sidethrust
  drawlandscape()
  drawapollo()
  drawosd()
  collisiondetection() -- still buggy
  starfield()
  gfx.update()
  if A~=-1 and endit~=true then reaper.defer(main) end
end

val=1
delta=0
deltadir=-1
deltay=0

function Titledrawstars()
  if TitleStars==nil then
    TitleStars={}
    for i=1, 1000 do
      TitleStars[i]={}
      TitleStars[i]["y"]=math.random(gfx.h)
      TitleStars[i]["x"]=math.random(gfx.w*20)
      TitleStars[i]["speed"]=math.random(10)
    end
  end
  for i=1, 1000 do
    gfx.x=TitleStars[i]["x"]
    gfx.y=TitleStars[i]["y"]
    gfx.setpixel(TitleStars[i]["speed"]/10, TitleStars[i]["speed"]/10, TitleStars[i]["speed"]/10)
    TitleStars[i]["x"]=TitleStars[i]["x"]-TitleStars[i]["speed"]
    if TitleStars[i]["x"]<0 then
      TitleStars[i]["y"]=math.random(gfx.h)
      TitleStars[i]["x"]=gfx.w
      TitleStars[i]["speed"]=math.random(10)
    end
  end
end

Credits={
"",
"written and composed by Meo Mespotine",
"Photo of Apollo Lunar Module by Michael Collins.",
"\"The Eagle Has Landed\" \n   and \n\"It's one small step for (a) man...\"\n   said by Neil Armstrong on the moon.",
"\"Ok Houston, we had a problem here\" \n   and \n\"Houston we had a problem\"\n   by the Astronauts of Apollo 13.",
"Music",
"Klangkonstellation\n  \"selected views on earth\"\nwritten by Meo Mespotine",
"Klangkonstellation IX:\n  \"A Scanner Darkly pt.1\"\nexcerpts\nwritten by Meo Mespotine",
"Klangkonstellation can be found at\nhttps://klangkonstellation.bandcamp.com/",
"Ultraschall-logo designed by \nGraphorama\nhttp://www.graphorama.de/",
"find more about Ultraschall at\nultraschall.fm",
"",
"Your goal is to successfully soft-land on a plateau\non the moon.",
"Control Lunar-Lander using left/right and up.",
"Every such maneuver costs fuel.\nWith every new level, you get some more fuel.",
"The game is over when crashing, flying into space\nor if the fuel is empty.",
""
}

Creditcounter=0
Creditbrightness=0
speculator=1

function GetHighscores()
  local text="Highscore:\n        Level\t      Name"
  for i=1, 10 do
    local a=reaper.GetExtState("Mespotine's Moonlander", "Place"..i):match("(.-),")
    local b=reaper.GetExtState("Mespotine's Moonlander", "Place"..i):match(",(.*)")
    if a==nil then a="" end
    if b==nil then b="" end
    text=text.."\n          "..a.."      "..b
  end
  return text
end

function TitleCredits()
  if Creditbrightness<=0 then Creditbrightness=Creditbrightness+0.1 Creditcounter=Creditcounter+1 speculator=1 if Credits[Creditcounter-1]==nil and Credits[Creditcounter]==nil then Creditcounter=1 end end
  gfx.x=560
  gfx.y=350

  if Credits[Creditcounter]~=nil then
    Creditbrightness=Creditbrightness+(0.01*speculator)
  else
    Creditbrightness=Creditbrightness+(0.005*speculator)
  end

  if Creditbrightness>=1 then speculator=-1 end
  gfx.set(Creditbrightness)
  if Credits[Creditcounter]~=nil then
    gfx.drawstr(Credits[Creditcounter])
  else
    gfx.drawstr(GetHighscores())
  end
end

function Titlemain()
  if reaper.time_precise()>=lasttime+130 then
    PCM_sourcebgm3=reaper.PCM_Source_CreateFromFile(Path.."/moonlander/svoe.mp3")
    PCM_source2bgm=reaper.Xen_StartSourcePreview(PCM_sourcebgm3, 0.1, false)
    pingopongo="svoe"
    lasttime=reaper.time_precise()
  else
    pingo=lasttime+130-reaper.time_precise()
  end

  Titledrawstars()
  gfx.set(0.8)
  gfx.x=-titlerotate*300+gfx.w/2
  gfx.y=100-titlerotate*50+delta+deltay
  if gfx.x<=-300 or gfx.y<=-350 or gfx.y>gfx.h+100 then titlerotate=-3 delta=math.random(math.floor(gfx.h*0.2))-300
    deltay=math.random(10)
    deltadir=math.random(3)-1.9
  end
  titlerotate=titlerotate+0.015+(deltay*0.00001)
  deltay=deltay+(2*deltadir)
  gfx.blit(12,0.5,titlerotate)
  gfx.x=96+macoffset
  gfx.y=250+winoffset
  gfx.set(0)
  gfx.drawstr("Meo Mespotine's",1,500,600)
  gfx.x=98+macoffset
  gfx.y=252+winoffset
  gfx.set(1)
  gfx.drawstr("Meo Mespotine's",1,500,600)
  gfx.set(1)
  gfx.x=-70
  gfx.y=250
  gfx.setfont(2)
  gfx.set(0)
  gfx.drawstr("Moonlander",1,800,600)
  gfx.x=-72
  gfx.y=252
  gfx.set(1)
  gfx.setfont(2)
  gfx.drawstr("Moonlander",1,800,600)
  gfx.setfont(4)
  val=val+0.03
  if val>1 then val=-0.7 end
  if val<0 then val2=-val else val2=val*2 end
  gfx.x=gfx.w-30
  gfx.y=gfx.h-29
  gfx.set(0.6)
  gfx.drawstr(".fm")
  gfx.setfont(1)
  gfx.set(val2)
  gfx.x=400
  gfx.y=330
  gfx.drawstr(" - Hit Enter To Play - ")
  gfx.x=gfx.w-127
  gfx.y=gfx.h-80
  gfx.blit(15,0.5,0)
  TitleCredits()
  A=gfx.getchar()
  if A~=-1 and A~=13 and A~=27 then reaper.defer(Titlemain) elseif A==27 then gfx.quit() else endit=false TitleStars=nil gfx.setfont(1) reaper.defer(main) end
end

titlerotate=-1

GenerateNewLandscape()
Titlemain()
