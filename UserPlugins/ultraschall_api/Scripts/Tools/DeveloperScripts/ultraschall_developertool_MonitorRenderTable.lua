  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2022 Ultraschall (http://ultraschall.fm)
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

-- Monitor changes in the RenderTable for the currently opened project
-- Meo-Ada Mespotine 4th of September 2022 - MIT-license

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end


C={}

function main()
  A=ultraschall.GetRenderTable_Project()
  D={}  
  Output=""
  for k,v in pairs(A) do
    if C[k]~=A[k] then
      dif=true
      D[k]=true
    end
  end

  if dif==true then
    reaper.ClearConsole()
    print(reaper.time_precise())
    B={}
    
    for k in pairs(A) do B[#B+1]=k end
    table.sort(B)
  
    for i=1, #B do
      k=B[i]
      v=A[B[i]]
      if D[B[i]]==true and firststart==false then k=">"..k else k=" "..k end
      if k:len()<=33 then
        for i=k:len(), 33 do
          k=k.." "
        end
      end
      
      Output=Output..k..tostring(v).."\n"
    end
  end
  C=A
  if dif==true then print_update(Output) end
  dif=false
  firststart=false
  --reaper.defer(main)
  retval, defer_identifier = ultraschall.Defer(main, "o", 2, 1, false)
  SLEM()
end  

main()
