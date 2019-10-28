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

-- Ultraschall-API demoscript by Meo Mespotine 29.10.2018
-- 
-- render a project to numerous audio-file-formats(in this example: flac, opus, mp3, wav)
-- see Functions-Reference for more details on the parameter-settings, given to the functions,
-- as well as other formats
--
-- opens file-dialog to select project-file. after selection, it will show an input-box, where you enter
-- the render-filename with path. file-extensions will be given by Reaper's rendering-process automatically

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- Select Input and Output-files
retval, projectfilename_with_path=reaper.GetUserFileNameForRead("", "Select Project-File", "*.rpp")
if retval==true then
  retval2, renderfilename_with_path=reaper.GetUserInputs("Please give filename+path of the target-render-file.", 1, "", "")
  else
  reaper.MB("No projectfile selected. Quitting now.", "No projectfile Selected", 0)
  return
end

if retval2==true then
  -- Create Renderstrings first, for Flac, Opus, MP3(Maxquality) and Wav
  render_cfg_string_Flac = ultraschall.CreateRenderCFG_FLAC(0, 5)
  render_cfg_string_Opus = ultraschall.CreateRenderCFG_Opus2(2, 128, 10, false, false)
  render_cfg_string_MP3_maxquality = ultraschall.CreateRenderCFG_MP3MaxQuality()
  render_cfg_string_Wav = ultraschall.CreateRenderCFG_WAV(1, 0, 0, 0, false)
  
  -- Render the files. Will automatically increment filenames(if already existing) and close the rendering-window after render.
  retval, renderfilecount, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderCFG(projectfilename_with_path, renderfilename_with_path, -2, -2, false, true, true, render_cfg_string_Flac)
  renderfile1=Filearray[1]
  retval, renderfilecount, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderCFG(projectfilename_with_path, renderfilename_with_path, -2, -2, false, true, true, render_cfg_string_Opus)
  renderfile2=Filearray[1]
  retval, renderfilecount, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderCFG(projectfilename_with_path, renderfilename_with_path, -2, -2, false, true, true, render_cfg_string_MP3_maxquality)
  renderfile3=Filearray[1]
  retval, renderfilecount, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderCFG(projectfilename_with_path, renderfilename_with_path, -2, -2, false, true, true, render_cfg_string_Wav)
  renderfile4=Filearray[1]
  
  -- show the filenames of the rendered files
  reaper.MB("The rendered files are:\n\n1: "..renderfile1.."\n2: "..renderfile2.."\n3: "..renderfile3.."\n4: "..renderfile4, "Rendered Files",0) 
else
  reaper.MB("No outputfile Chosen. Quitting now.", "No outputfile Selected", 0)
end

--ultraschall.ShowLastErrorMessage() 