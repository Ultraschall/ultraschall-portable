Ultraschall Lua-Api for Reaper(reaper.fm)

1. Put the contents of the repository into the "UserPlugins"-folder in the ressources-folder of Reaper
2. Start Reaper and create a new script
3. Type in the following lines:

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
ultraschall.ApiTest()

4. A messagebox appears in which you can see, which parts of the API work
5. If it appears, it is correctly installed.

6. Look into 
    Documentation\US_Api_Documentation.html
   for a functions-reference for the API, which will also be added automatically to your actionlist after the first time you used the API.

Requires at least Reaper 6.20 and SWS 2.10.0.1 and reaper_js_ReaScriptAPI64 1.215
   
Written by Meo Mespotine(mespotine.de) with contributions from Udo Sauer(https://twitter.com/fernsehmuell) and Ralf Stockmann(https://twitter.com/rstockm)
MakeCopyOfTable-function adapted from Tyler Neylon's (twitter.com/tylerneylon) function, found at [Stack Overflow](https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value/26367080#26367080)
Thanks for allowing me to use it :)

Kudos to lokasenna, who suggested some cool things, that made some functions much faster and sparkled new ones. Cheers!

more information about the Ultraschall podcast extension at: ultraschall.fm
more information on Reaper: reaper.fm


License:

 
 Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

Reaper and the Reaper-Logo are trademarks of Cockos inc and can be found at reaper.fm

The SWS-logo has been taken from the SWS-extension-project, which can be found at sws-extension.org