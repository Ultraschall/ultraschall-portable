-- Gets all pitchshiftmodes and their corresponding id-number, as used in configvar defpitchcfg as well as in
-- ProjectStateChunks(entry DEFPITCHMODE) and ItemStateChunks(entry PLAYRATE) and puts them into the clipboard
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

P=""

-- first pass, which gets all pitchshiftmodes and submodes
for i=0, 10000 do
  retval, str = reaper.EnumPitchShiftModes(i)
  if retval==false then break end
  if str~=nil then
    P=P.."\n"..str..":\n"
    for a=0, 10000 do
      str2=reaper.EnumPitchShiftSubModes(i, a)
      if str2==nil then break end
      str2=str2..","
      sub=str:match(".-,(.*)")
      A1,A2,A3,A4=ultraschall.SplitIntegerIntoBytes(a)
      I1,I2,I3,I4=ultraschall.SplitIntegerIntoBytes(i)
      P=P.."    "..ultraschall.CombineBytesToInteger(0, A1, A2, I1).." - "..str2:sub(1,-2).."\n"
    end
  end
end


--2ndpass, which formats the Rubber Band Library-modes, who are otherwise hard to read
i=0
P2=""
PP=P:match("Rubber Band Library:\n(.*)")

for k in string.gmatch(PP, ".-\n") do
  num, modes = k:match("(%d.....)%s%-%s(.*)")
  modes=modes..","

  if modes:match("Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing")~=nil then
    modes2="Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Mid/Side, Independent Phase, Time Domain Smoothing")~=nil then
    modes2="Mid/Side, Independent Phase, Time Domain Smoothing"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Preserve Formants, Independent Phase, Time Domain Smoothing")~=nil then
    modes2="Preserve Formants, Independent Phase, Time Domain Smoothing"
    transients=string.gsub(modes, modes2..", ", "")
  
  elseif modes:match("Independent Phase, Time Domain Smoothing")~=nil then
    modes2="Independent Phase, Time Domain Smoothing"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Preserve Formants, Mid/Side, Time Domain Smoothing")~=nil then
    modes2="Preserve Formants, Mid/Side, Time Domain Smoothing"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Mid/Side, Time Domain Smoothing")~=nil then
    modes2="Mid/Side, Time Domain Smoothing"
    transients=string.gsub(modes, modes2..", ", "")
    
  elseif modes:match("Preserve Formants, Time Domain Smoothing")~=nil then
    modes2="Preserve Formants, Time Domain Smoothing"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Time Domain Smoothing")~=nil then
    modes2="Time Domain Smoothing"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Preserve Formants, Mid/Side, Independent Phase")~=nil then
    modes2="Preserve Formants, Mid/Side, Independent Phase"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Mid/Side, Independent Phase")~=nil then
    modes2="Mid/Side, Independent Phase"
    transients=string.gsub(modes, modes2..", ", "")
    
  elseif modes:match("Preserve Formants, Independent Phase")~=nil then
    modes2="Preserve Formants, Independent Phase"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Independent Phase")~=nil then
    modes2="Independent Phase"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Preserve Formants, Mid/Side")~=nil then
    modes2="Preserve Formants, Mid/Side"
    transients=string.gsub(modes, modes2..", ", "")
  elseif modes:match("Mid/Side")~=nil then
    modes2="Mid/Side"
    transients=string.gsub(modes, modes2..", ", "")
    
  elseif modes:match("Preserve Formants")~=nil then
    modes2="Preserve Formants"
    transients=string.gsub(modes, modes2..", ", "")
  else
    modes2="nothing"
    transients=modes
  end

  if transients==nil then transients=modes:sub(1,-3) modes2="Nothing" end

  if transients~=oldtransients then
    P2=P2.."\nRubber Band Library - "..transients.."\n"
  end
  oldtransients=transients
  P2=P2.."    "..num.." - "..modes2.."\n"
end

PP=string.gsub(P2,"\n,\n", "\n")

-- put them into the clipboard
print3(P:match("(.-)Rubber Band Library:\n")..PP)
