dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

path="c:\\Ultraschall-US_API_4.1.001\\ColorThemes\\Default_6.0_unpacked"
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(path)

String=""
Contexts={}
Contexts["envcp"]="Envelope Control Panel(envcp)"
Contexts["folder"]="Folder"
Contexts["gen"]="Generic ui-elements"
Contexts["global"]="Global automation"
Contexts["item"]="MediaItem contexts"

Contexts["lane"]="Lanes"
Contexts["mcp"]="Mixer Control Panel(mcp)"
Contexts["meter"]="Meters"
Contexts["midi"]="Midi editor contexts"
Contexts["mixer"]="Mixer"
Contexts["monitor"]="Monitoring FX"
Contexts["piano"]="Piano Roll"

Contexts["scrollbar"]="Scrollbars"
Contexts["scrollbar.png"]="Scrollbars"
Contexts["table"]="Media Item Properties-buttons"
Contexts["tcp"]="Track Control Panel(tcp)"
Contexts["toolbar"]="Toolbars"
Contexts["toosmall"]="Too Small UI-elements"
Contexts["track"]="MediaTracks"
Contexts["transport"]="Transport-areas"


for i=1, found_files do
  if files_array[i]:sub(-4,-1)==".png" then
    slug=files_array[i]:sub(path:len()+2, -1)
    context=nil
    context2=nil
    addcontext=nil
    context=slug:match("(.-)_")
    if context==nil then context=slug:match(".*/(.-)_") end
    if context==nil then context=slug:match("(.*)") end
    context2=slug:match(".*/(.-)_")
    if context2==nil then context2=slug:match("(.-)_") end
    if context2==nil then context2="scrollbar" end
    if Contexts[context2]==nil then 
      print_alt(slug, tostring(context2)) 
    end
    --Contexts[context]=context
    if context:match("150/")~=nil then addcontext=" for 150% scaling" end
    if context:match("200/")~=nil then addcontext=" for 200% scaling" end
    if addcontext==nil then addcontext="" end
    context=Contexts[context2]
    String=String..[[
    <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
        <slug>]]..slug..[[</slug>
        <title>]]..slug..[[</title>
        <requires>
            Reaper=6.64
        </requires>
        <description>
          This image is used in ]]..Contexts[context2]..addcontext..[[.
          
          ImageFile: <img src="gfx/ThemeImagesDocs/]]..slug..[[">
          Context: <img src="gfx/ThemeImagesDocs/]]..slug:sub(1,-5)..[[-context.png">
        </description>
        <chapter_context>
          ]]..context..[[

        </chapter_context>
        <target_document>Reaper_Theme_Images_Reference</target_document>
        <source_document>Reaper_Theme_Images_Reference.USDocML</source_document>
      </US_DocBloc>
      
  ]]
    target=files_array[i]:match("(.*)%.png").."-context.png"
    if target==nil then print(files_array[i]) end
    --retval = ultraschall.MakeCopyOfFile_Binary(files_array[i], target)
  end
end

SLEM()

print3(String)
