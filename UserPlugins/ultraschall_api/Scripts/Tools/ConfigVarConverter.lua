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
