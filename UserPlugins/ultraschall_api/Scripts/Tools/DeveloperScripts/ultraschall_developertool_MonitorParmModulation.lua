-- Meo-Ada Mespotine - GetParmModulation - demomonitoringsccript
-- licensed under MIT-license
if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

ParmTable={
"AUDIOCONTROL",
"AUDIOCONTROL_ATTACK",
"AUDIOCONTROL_CHAN",
"AUDIOCONTROL_DIRECTION",
"AUDIOCONTROL_MAXVOLUME",
"AUDIOCONTROL_MINVOLUME",
"AUDIOCONTROL_RELEASE",
"AUDIOCONTROL_STEREO",
"AUDIOCONTROL_STRENGTH",
"LFO",
"LFO_DIRECTION",
"LFO_PHASE",
"LFO_PHASERESET",
"LFO_SHAPE",
"LFO_SHAPEOLD",
"LFO_SPEED",
"LFO_STRENGTH",
"LFO_TEMPOSYNC",
"MIDIPLINK",
"MIDIPLINK_BUS",
"MIDIPLINK_CHANNEL",
"MIDIPLINK_MIDICATEGORY",
"MIDIPLINK_MIDINOTE",
"PARAM_NR",
"PARAM_TYPE",
"PARAMOD_BASELINE",
"PARAMOD_ENABLE_PARAMETER_MODULATION",
"PARMLINK",
"PARMLINK_LINKEDPARMIDX",
"PARMLINK_LINKEDPLUGIN",
"PARMLINK_LINKEDPLUGIN_RELATIVE", 
"PARMLINK_OFFSET",
"PARMLINK_SCALE",
"WINDOW_ALTERED",
"WINDOW_ALTEREDOPEN",
"WINDOW_BOTTOM",
"WINDOW_RIGHT",
"WINDOW_XPOS",
"WINDOW_YPOS",
"X2",
"Y2"}

gfx.init("Monitor ParmModTable - by Meo-Ada Mespotine", 350, 690)
gfx.setfont(1, "arial", 12,0)


A=0

tracknumber=1
fxindex=1
parmmodindex=1

Retval, TrackStateChunk = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber)
FXStateChunk           = ultraschall.GetFXStateChunk(TrackStateChunk)
OldParmModulationTable    = ultraschall.GetParmModTable_FXStateChunk(FXStateChunk, fxindex, parmmodindex)

function main()
  A=A+1
  if A==15 then
    Retval, TrackStateChunk = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber)
    FXStateChunk           = ultraschall.GetFXStateChunk(TrackStateChunk)
    ParmModulationTable    = ultraschall.GetParmModTable_FXStateChunk(FXStateChunk, fxindex, parmmodindex)
--    print_update(FXStateChunk)
    gfx.x=0
    gfx.y=10
    gfx.set(1)
    gfx.drawstr("Track: "..tracknumber.." FXIdx: "..fxindex.." ParmIDX: "..parmmodindex.."\nClick to select new track, fx and modulation\n\nCURRENT VALUES:")
    gfx.y=gfx.y+gfx.texth+3
    for i=1, #ParmTable do
      gfx.x=0
      gfx.y=gfx.y+gfx.texth+3
      if ParmModulationTable~=nil and OldParmModulationTable~=nil and ParmModulationTable[ParmTable[i]]~=OldParmModulationTable[ParmTable[i]] then
        gfx.set(1,0,1)
      else
        gfx.set(1)
      end
      if ParmModulationTable==nil then CurVal=nil else CurVal=ParmModulationTable[ParmTable[i]] end
      gfx.drawstr(ParmTable[i]..": "..tostring(CurVal))
    end
    if ParmModulationTable~=nil then
      OldParmModulationTable=ParmModulationTable
    end
    A=0
  end  
  P=gfx.getchar()
  if gfx.mouse_cap&1==1 then
    retval,vals=reaper.GetUserInputs("", 3, "Tracknumber,fxindex,parameterindex", tracknumber..","..fxindex..","..parmmodindex)
    if retval==true then
      local A,B,C=vals:match("(.-),(.-),(.*)")
      A=tonumber(A)
      B=tonumber(B)
      C=tonumber(C)
      if A~=nil and B~=nil and C~=nil then
        tracknumber=A
        fxindex=B
        parmmodindex=C
        Retval, TrackStateChunk = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber)
        FXStateChunk           = ultraschall.GetFXStateChunk(TrackStateChunk)
        OldParmModulationTable    = ultraschall.GetParmModTable_FXStateChunk(FXStateChunk, fxindex, parmmodindex)
      else
        reaper.MB("Only numbers are allowed!", "Error", 0)
      end
    end
  end
  if P~=-1 and P~=27 then reaper.defer(main) else gfx.quit() end
end

main()

--SLEM()

