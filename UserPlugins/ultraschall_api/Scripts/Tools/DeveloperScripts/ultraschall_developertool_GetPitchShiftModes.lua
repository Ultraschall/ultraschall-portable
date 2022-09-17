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

-- Gets all pitchshiftmodes and their corresponding id-number, as used in configvar defpitchcfg as well as in
-- ProjectStateChunks(entry DEFPITCHMODE) and ItemStateChunks(entry PLAYRATE) and puts them into the clipboard
if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

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
      P=P.."   "..ultraschall.CombineBytesToInteger(0, A1, A2, I1).." - "..str2:sub(1,-2).."\n"
    end
  end
end

print3(P)

--2ndpass, which formats the Rubber Band Library-modes, who are otherwise hard to read
i=0
P2=""

PP,PP2=P:match("Rubber Band Library:\n(.*)(\nRrreeeaaa:.*)")
print3(PP)

for k in string.gmatch(PP, ".-\n") do
  num, modes = k:match("(%d.....)%s%-%s(.*)")
  if modes==nil then modes="nil" end
  if num==nil then num="nil" end

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
    P2=P2.."\nRubber Band Library: - "..transients
  end
  oldtransients=transients
  P2=P2.."   "..num.." - "..modes2.."\n"
end
PP=string.gsub(P2,"\n,\n", "\n")..PP2

print3(P:match("(.-)Rubber")..PP)
-- put them into the clipboard
--print3(P:match("(.-)Rubber Band Library:\n"))

