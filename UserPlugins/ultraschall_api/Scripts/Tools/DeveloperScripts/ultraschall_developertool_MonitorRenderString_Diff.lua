-- RenderString-tracker, shows diffs of the render-string(first render-format)
-- Meo-Ada Mespotine - licensed under MIT-license

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

function main()
  A,B = reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT", "", false)
  B=ultraschall.Base64_Decoder(B)
  if OldB==nil then OldB="" for i=1, B:len() do OldB=OldB.." " end end
  if B~=OldB then
    count=0
    num_integers, individual_integers = ultraschall.ConvertStringToIntegers(B, 1)
    num_integers2, individual_integers2 = ultraschall.ConvertStringToIntegers(OldB, 1)
    for i=0, #individual_integers do individual_integers[i]=individual_integers[i+1] end
    for i=0, #individual_integers2 do individual_integers2[i]=individual_integers2[i+1] end
    individual_integers[#individual_integers]=0
    individual_integers2[#individual_integers2]=0
    local newstring =B:match(".%a*"):reverse()..": 0: "
    for i=0, #individual_integers do
      if tostring(individual_integers[i]):len()==2 then space=" " elseif tostring(individual_integers[i]):len()==1 then space="  " else space="" end
      if individual_integers[i]~=individual_integers2[i] then
        use=" >"
      else
        use="  "
      end
      if i%10==0 and i~=0 then
        count=count+10
        newstring=newstring.."\n    :"..count..": "
      elseif i%5==0 and i~=0 then
        newstring=newstring.." "
      end
      newstring=newstring..use..individual_integers[i]..space
    end
    print("")
    print(newstring)
    print(newstring2)
  end
  OldB=B
  reaper.defer(main)
end

main()