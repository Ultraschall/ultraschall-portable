dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


A1,B1=reaper.GetProjectPath()

A1=string.gsub(A1, "\\", "/"):match("(.*)/")
A,B=ultraschall.GetSetChapterMarker_Attributes(false, 1, "chap_image_path", "")
B=string.gsub(B, "\\", "/"):match("(.*)/")

gfx.init()
C=gfx.loadimg(1, A1.."/"..B)
D=reaper.file_exists(A1.."/"..B)
retval = ultraschall.GFX_BlitImageCentered(1, 100, 100, 1, 0)
