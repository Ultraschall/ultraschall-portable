dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

clipboard_string = ultraschall.GetStringFromClipboard_SWS()

count, split_string = ultraschall.SplitStringAtLineFeedToArray(clipboard_string)


for i=1, count do
  if split_string[i]:sub(1,1)~=";" and split_string[i]:match("%[")~=nil then
    sec=tostring(split_string[i]:match("%[.-%]"))
  end
  if sec~=nil and split_string[i]:sub(1,1)==";" then
    split_string[i]=tostring(split_string[i]:match(";(.-=)"))..sec..tostring(split_string[i]:match("=(.*)"))
  end
end

A=""
for i=1, count do
  A=A..split_string[i].."\n"
end

print3(A)
