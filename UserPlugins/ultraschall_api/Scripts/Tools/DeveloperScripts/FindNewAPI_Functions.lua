-- written by Meo-Ada Mespotine
-- licensed under MIT license

-- missing SWS and other extensions

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

DocsFile=ultraschall.ReadFullFile("C:/Users/Meo/AppData/Local/Temp/reascripthelp.html")

Funcs=DocsFile:match("<td></td></tr>\n</table></code>\n<br><br>(.*)")
slugs, titles = ultraschall.Docs_GetAllReaperApiFunctionnames()
 
API_Funcs={}
for v in string.gmatch(Funcs, "name=\"(.-)\"><hr>") do
  API_Funcs[#API_Funcs+1]={}
  API_Funcs[#API_Funcs]["func"]=v
end

for i=1, #slugs do
  if slugs[i]:match("runloop") then
    --print2(i, slugs[i])
  end
end

API_Funcs2={}
found=false
for i=#API_Funcs, 1, -1 do
  for a=1, #slugs do
    if API_Funcs[i]["func"]==slugs[a] then
      found=true
      break
    end
  end
  if found==false then 
    API_Funcs2[#API_Funcs2+1]={}
    API_Funcs2[#API_Funcs2]["func"]=API_Funcs[i]["func"] 
  end
  found=false
end


function main()
  for A=1, 100 do
    i=i+1
    if API_Funcs2[i]==nil then break end
    Chunk=Funcs:match("(<a name=\""..API_Funcs2[i]["func"]..".-)\n<a name=")
    API_Funcs2[i]["chunk"]=Chunk
  end
  if API_Funcs2[i]~=nil then reaper.defer(main) else main2() end
end

i=0

function main2()
  for i=1, #API_Funcs2 do
    chunk=API_Funcs2[i]["chunk"]
    cpp=chunk:match("C: </span><code>(.-)</code>")
    
    eel=chunk:match("EEL2: </span><code>(.-)</code>")
    if eel==nil then eel=chunk:match("EEL2: </span><code>(.-)</code>") end
    eel=chunk:match("EEL2: <code>(.-)</code>")
    if eel~=nil then
      if eel:match("<i><font") then
        eel=eel:match("(.-) <i><font")
      end
    end
    lua=chunk:match("Lua: </span><code>(.-)</code>")
    if lua~=nil then
      lua=string.gsub(lua, "<.->", "")
    end
    
    python=chunk:match("Python: </span><code>(.-)</code>")
    if python~=nil then
      python=string.gsub(python, "<.->", "")
    end
    
    desc=chunk:match(".*<br></div>\n(.*)")
    if desc==nil then desc=chunk:match(".*<BR><BR>(.*)<BR><BR>") end
    if desc==nil then desc="" end
    desc=string.gsub(desc, "<.->", "")
    
    local retvals={}
    if lua~=nil then
      lua2=lua:match("(.-) = reaper.")
      if lua2==nil then lua2=lua:match("(.-) reaper.") end
      if lua2~=nil then
        for k in string.gmatch(lua2..", =", "(.-), ") do
          lua3=lua2..", ="
          retvals[#retvals+1]=k.." - "
        end
        retvals[#retvals]=string.gsub(retvals[#retvals], "  ", " ")
      end
    end

    local params={}
    if lua~=nil then
      lua2_p=lua:match("%((.-)%)")
      if lua2_p:len()>0 then
        for k in string.gmatch(lua2_p..", ", "(.-), ") do
          lua3=lua2_p..", ="
          params[#params+1]=k.." - "
        end
        params[#params]=string.gsub(params[#params], "  ", " ")
      end
    end
    
    -- TODO: SWS, other extensions
    if API_Funcs2[i]["func"]:match("ImGui")~=nil then
      requires="ReaImGui="..reaper.ImGui_GetVersion()
      context="ReaImGui"
    elseif API_Funcs2[i]["func"]:match("osara")~=nil then
      requires="Osara="..reaper.osara_getVersion()
      context="Osara"
    elseif API_Funcs2[i]["func"]:match("JS_")~=nil then
      requires="JS="..reaper.JS_ReaScriptAPI_Version()
      context="JS"
    else
      requires="Reaper="..reaper.GetAppVersion():match("(.-)/")
      context=""
    end

    API_Funcs2[i]["USDocBloc"]=[[
    <US_DocBloc version="1.0" spok_lang="en" prog_lang="lua">
        <slug>]]..API_Funcs2[i]["func"]..[[</slug>
        <title>]]..API_Funcs2[i]["func"]..[[</title>
]]
        
if cpp~=nil then
API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"]..[[
        <functioncall prog_lang="cpp">]]..cpp..[[</functioncall>
]]
end
if eel~=nil then
API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"]..[[
        <functioncall prog_lang="eel">]]..eel..[[</functioncall>
]]
end
if lua~=nil then
API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"]..[[
        <functioncall prog_lang="lua">]]..lua..[[</functioncall>
]]
end
if python~=nil then
API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"]..[[
        <functioncall prog_lang="python">]]..python..[[</functioncall>
]]
end

API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"]..[[
        <requires>
            ]]..requires.."\n"..[[
        </requires>
        <description indent="default">
]]..string.gsub("\n"..desc, "\n", "\n            "):sub(2,-1)..[[

        </description>
]]
        if #retvals>0 then
          API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"].."        <retvals>\n"
          for a=1, #retvals do
            API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"].."            "..string.gsub(retvals[a].."\n", " =", "")
          end
          API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"].."        </retvals>\n"
        end
        
        if #params>0 then
          API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"].."        <parameters>\n"
          for a=1, #params do
            API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"].."            "..params[a].."\n"
          end
          API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"].."        </parameters>\n"
        end
        
        --[[
        <retvals>
            int retval - true, if succeded
        </retvals>
        <parameters>
            function function - the function to be called
        </parameters>
        --]]
API_Funcs2[i]["USDocBloc"]=API_Funcs2[i]["USDocBloc"]..[[
        <target_document>Reaper_Api_Documentation</target_document>
        <source_document>Reaper_Api_Documentation.USDocML</source_document>
        <chapter_context>
        
        </chapter_context>
        <tags></tags>
        <changelog>
            ]]..string.gsub(requires, "=", " ")..[[ - added to API
        </changelog>
    </US_DocBloc>
]]
  end
  
  USDocBloc=""
  for i=1, #API_Funcs2 do
    USDocBloc=USDocBloc..API_Funcs2[i]["USDocBloc"].."\n\n"
  end
  print3(USDocBloc)
end

main()
