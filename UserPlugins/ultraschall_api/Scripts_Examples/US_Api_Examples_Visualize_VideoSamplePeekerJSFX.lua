-- Meo-Ada Mespotine - 11th of June 2021
-- licensed under MIT-license

-- Visualize Video Sample Peeker-sample-values in a gfx-window

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

gfx.init()

function main()

  -- read current sample-peeker-values
   PlayPos, BufSampleRate, NumChannels, 
  SampleBuf_NumValues, SampleBuf = ultraschall.GMem_GetValues_VideoSamplePeeker(10)

  -- set drawingbuffer to current window-size
  gfx.setimgdim(1, gfx.w, gfx.h)

  -- draw sample-buffer
  local a=0
  local astepsize=gfx.w/SampleBuf_NumValues
  for i=2, SampleBuf_NumValues do
    a=a+astepsize
    gfx.line(a-astepsize, 200+SampleBuf[i-1]*200, a, 200+SampleBuf[i]*200)
  end
  
  -- if window is closed, finish off script
  if gfx.getchar()==-1 then return end

  reaper.defer(main)
end

main()

 