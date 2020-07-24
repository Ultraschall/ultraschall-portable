  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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
  
  
-- Ultraschall-API demoscript by Meo Mespotine 30th of June 2020
-- 


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- This script scrolls a text through the name of the first plugin of the first track's fxchain.


-- the text to scroll through
String=[[               In the beginning, God created Earth. But the creation did not sound impressive and godlike. 
Thus He created FX-Chains for the perfect genesis-sound-experience. And then He created humans, as He forgot, 
impressive sound needs impressed audience. 
But humans ignored the earth and made stairways to heaven instead...   ]]


Length=20 -- the length of the actual shown text; you can set this, if you want. Minimum 1.
Speed=3   -- the higher, the slower the scrollspeed will be. Only positive integers allowed.

-- initial variables
Delay=0 -- a delay
A=0 -- the offset through the scrolltext


function main()
  Delay=Delay+1
  if Delay==Speed then
    -- iterate the offset and if we've passed the end of the scrollling string, we return the offset to the first character again
    A=A+1
    if A>String:len() then A=0 end
    
    -- let's get the string from offset to offset+Length
    ShowString=String:sub(A, A+Length)
    
    -- if the remaining part of the string is shorter than Length, we'll add it from the start of the scrollstring to fill it up
    if ShowString:len()<Length then ShowString=ShowString..String:sub(0,Length-ShowString:len()) end
    print_update(ultraschall.GetTrackFX_AlternativeName(1, 1, ShowString)) -- this shows the current string in the Reaper-Console
    ultraschall.SetTrackFX_AlternativeName(1, 1, ShowString)               -- this sets the scrolltext into the name of the FX
    Delay=0 -- reset the delay-counter
  end
  reaper.defer(main)
end

main()