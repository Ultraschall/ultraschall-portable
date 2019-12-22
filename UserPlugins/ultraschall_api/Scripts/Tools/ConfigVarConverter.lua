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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

A=ultraschall.ReadFullFile("c:/Reaper-Internal-Docs/Reaper-ConfigVariables-Documentation.txt")
A=A:match("(__numcpu.*)#")

Entry="<USDocML>\n"

Slug=""
Title=""
Description=""
Parameters=""


function main()
  Temp, offset=A:match("(.-)\n()%a")

  Temp2, Temp3=ultraschall.SplitStringAtLineFeedToArray(Temp)
  if Temp2~=-1 then
    Slug=Temp3[1] Title=Temp3[1]
    for i=2, Temp2 do
      if Temp3[i]:match("^        ")~=nil then 
        Description=Description.."               "..Temp3[i]:match("^        (.*)").."\n"
      elseif Temp3[i]:match("^    ")~=nil then 
        Description=Description.."          "..Temp3[i]:match("^    (.*)").."\n"
      else
      end
    end
    
    Entry=Entry.."    <US_DocBloc version=\"1.0\" spok_lang=\"en\" prog_lang=\"*\">\n"
    Entry=Entry.."      <slug>"..Slug.."</slug>\n"
    Entry=Entry.."      <title>"..Slug.."</title>\n"
    Entry=Entry.."      <description>\n"..Description.."      </description>\n"
    Entry=Entry.."      <chapter_context>\n         Config Variables\n      </chapter_context>\n"
    Entry=Entry.."      <target_document>Reaper_Config_Variables</target_document>\n"
    Entry=Entry.."    </US_DocBloc>\n\n"
  end
  if offset~=nil then A=A:sub(offset,-1) Slug="" Title="" Description="" reaper.defer(main) else Entry=Entry.."</USDocML>\n" reaper.CF_SetClipboard(Entry) end
end

main()
