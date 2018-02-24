--[[
################################################################################
# 
# Copyright (c) 2014-2017 Ultraschall (http://ultraschall.fm)
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
]]


-- Print Message to console (debugging)
function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

-- Used to escape "'s by toCSV
--function escapeCSV (s)
--  _, count = string.gsub(s, "\"", "\"")
--  if count==nil then count=0 end
--  if math.fmod(count,2)==1 then --if we have a odd number of " replace them with "" 
--    if string.find(s, '["]') then
--      s = '"' .. string.gsub(s, '"', '""') .. '"'
--    end
--  elseif string.find(s,",")~=nil then
--    s="\""..s.."\""
--  end
--  return s
--end

function notes2csv ()
  local csv = ""
  local array = {}
  local count=0
  notes = reaper.GetSetProjectNotes(0, false, "")
    for line in notes:gmatch"[^\n]*" do
    count=count+1
      csv = csv .. "," .. line --escapeCSV(line)
      array[count]=line
    end
    
    retval= string.sub(csv, 2) -- remove first ","
    
  return retval, count, array
end



function csv2lines (line)
    title = line:match("(.-),")
    artist= line:match(".-,(.-),")
    album = line:match(".-,.-,(.-),")
    year  = line:match(".-,.-,.-,(.-),")
    genre =   line:match(".-,.-,.-,.-,(.-),")
    comment = line:match(".-,.-,.-,.-,.-,(.*)")
--[[  pos=0
  pos_old=1
  clean=""
  for i=1, 5,1 do
    pos=string.find(result,",",pos_old)
    substring=string.sub(line,pos_old,pos-1)
    clean=clean..substring.."\n"
    pos_old=pos+1
  end
  --check field 6
  substring=string.sub(line,pos_old)
  clean=clean..substring
  ]]
  return title.."\n"..artist.."\n"..album.."\n"..year.."\n"..genre.."\n"..comment
end

function checkevencharacters(string,character)
  local count=0
  local even=true
  for i=1, string.len(string) do
    if string:sub(i,i)==character then       
      if even==true then even=false
      else even=true
      end
    end
  end
  return even
end

--reaper.ShowConsoleMsg("") --clear console
dialog_ret_vals, count, dialog_retvals_array = notes2csv() --default values

retval, result = reaper.GetUserInputs("Edit ID3 Podcast Metadata", 6, "Title (no comma allowed):,Artist (no comma allowed):,Podcast (no comma allowed):,Year (no comma allowed):,Genre (no comma allowed):,Comment:", dialog_ret_vals)

count=0
temp=-1
old_pos=0
pos=0
if retval == true then
  pos=result:match(".-,.-,.-,.-,.-,()")
  firstvals=result:sub(1,pos-1)
  restvals=result:sub(pos,-1)
  pos=restvals:match(".-,()")
  if pos~=nil then restvals="\""..restvals.."\"" end
  if restvals:match("\"\".*\"\"")~=nil then restvals=restvals:sub(2,-2) end
  
  
  even=checkevencharacters(firstvals:match(".-,"),"\"")
  if even==false then firstvals=firstvals:match("(.-),").."\""..firstvals:match(".-(,.*)") end

  even=checkevencharacters(firstvals:match(".-,(.-,)"),"\"")
  if even==false then firstvals=firstvals:match("(.-,.-),").."\""..firstvals:match(".-,.-(,.*)") end

  even=checkevencharacters(firstvals:match(".-,.-,(.-,)"),"\"")
  if even==false then firstvals=firstvals:match("(.-,.-,.-),").."\""..firstvals:match(".-,.-,.-(,.*)") end

  even=checkevencharacters(firstvals:match(".-,.-,.-,(.-,)"),"\"")
  if even==false then firstvals=firstvals:match("(.-,.-,.-,.-),").."\""..firstvals:match(".-,.-,.-,.-(,.*)") end
  
  even=checkevencharacters(firstvals:match(".-,.-,.-,.-,(.-,)"),"\"")
  if even==false then firstvals=firstvals:match("(.-,.-,.-,.-,.-),").."\""..firstvals:match(".-,.-,.-,.-,.-(,.*)") end
  
  even=checkevencharacters(restvals,"\"")
  if even==false then restvals=restvals.."\"" end
  
  notes = reaper.GetSetProjectNotes(0, true, csv2lines(firstvals..restvals)) -- write new notes  
end

--[[
if retval == true then
  --step through field 1-5 and check if the numer of " is even. Add a " to the end if needed.
  pos=0
  pos_old=1
  clean=""
  for i=1, 5,1 do
    pos=string.find(result,",",pos_old)
    substring=string.sub(result,pos_old,pos-1)
    _, count = string.gsub(substring, "\"", "\"")
    if math.fmod(count,2)==1 then substring=substring.."\"" end
    clean=clean..substring..","
    pos_old=pos+1
  end
  --check field 6
  substring=string.sub(result,pos_old)
  _, count = string.gsub(substring, "\"", "\"")
  if math.fmod(count,2)==1 then substring=substring.."\"" end
  clean=clean..substring
  result=clean
  
  -- if more than  "," 5 then escape the comment field (surround with ")
  _, count = string.gsub(result, ",", ",")
  if count>5 then 
    pos=0
    for i=1, 5,1 do
      pos=string.find(result,",",pos+1)
    end
    temp=string.sub(result,pos+1,-1)
    if temp:match("\"\".*\"\"")~=nil then newresult=string.sub(result,1,pos)..temp:sub(2,-2)
    else newresult=string.sub(result,1,pos)..string.sub(result,pos+1)
    end
    reaper.MB(newresult,result,0)
    result=newresult
    --reaper.MB(string.sub(result,pos+1,-1),"",0)
  end



  notes = reaper.GetSetProjectNotes(0, true, csv2lines(result)) -- write new notes
end
--]]
