  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2021 Ultraschall (http://ultraschall.fm)
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

-- Meo-Ada Mespotine 12th of April 2021
-- Looking for duplicates of lines and displays them in ReaScript-Console, including line and number of appearances.
-- All duplicates will be shown, so if a line is at line 1 and at line 332, it will show both being duplicates, 
-- not only the first duplicate appearing. That way, you know, where all the duplicates are located.

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

-- get string from clipboard
A=FromClip()

-- split newlines into individual entries
newline=""
A=string.gsub(A, "\r", "") -- get rid of carriage return(on Windows)
count, individual_values = ultraschall.CSV2IndividualLinesAsArray(A..newline, "\n")

for i=1, count do
  counter=0
  for a=1, count do
    -- look for duplicate lines
    if individual_values[i]==individual_values[a] then
      counter=counter+1
    end
  end
--  print2(counter, string.byte(individual_values[i]:sub(-1,-1)), ultraschall.ConvertAscii2Hex(individual_values[i]))
  if counter>1 then 
    -- if duplicates are found for this entry, show them:
    if bool~=true then bool=true print("\n") end -- show newline once at the beginning, when script finds duplicate
    print("Line "..i.." appears "..counter.." times:"..individual_values[i]) 
  end
end

