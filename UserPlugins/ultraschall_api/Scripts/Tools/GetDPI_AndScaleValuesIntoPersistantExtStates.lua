i2=-0.001
--a=0

function main()
  i2=i2+.001
  ultraschall.SetUIScale(i2)
  print2("")
  retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)
  if olddpi~=dpi then
    print_alt(i2, dpi)
    scale=tostring(i2).."00"
    scale2=scale:match(".-%....")
    if scale2==nil then scale:match(".*%...") end
    if scale2==nil then scale:match(".*%..") end
    if scale2==nil then scale:match(".*%.") end
    if scale2==nil then scale2="ERROR" end

    
    reaper.SetExtState("DPI", dpi, scale2, true)
  end
  olddpi=dpi
  
  --A,B=ultraschall.GetScaleRangeFromDpi(tonumber(dpi))
  --C=ultraschall.GetDpiFromScale(tonumber(i))
  
  if i2<2005 then reaper.defer(main) end
end


--main()