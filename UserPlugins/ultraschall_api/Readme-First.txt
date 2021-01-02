Ultraschall Lua-Api for Reaper(reaper.fm)

1. Install Reaper, SWS, JS-extension(latest version)
2. Put the contents of the repository into the "UserPlugins"-folder in the ressources-folder of Reaper
3. Start Reaper and create a new script
4. Type in the following lines:

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
ultraschall.ApiTest()

4. A messagebox appears in which you can see, which parts of the API work
5. If it appears, it is correctly installed.

6. Look into 
    Documentation\Ultraschall-Api-Docs.html
   for a functions-reference for the API.
   
   
Written by Meo Mespotine(mespotine.de) with contributions from Udo Sauer(https://twitter.com/rstockm) and Ralf Stockmann(https://twitter.com/rstockm)

Other contributions by anton9, Edgemeal, X-Raym, lokasenna, Amagalma and other people in the Reaper and Podcast-community

more information about the Ultraschall podcast extension at: ultraschall.fm
more information on Reaper: reaper.fm


License:
################################################################################
# 
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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

Reaper and the Reaper-Logo are trademarks of Cockos inc and can be found at reaper.fm

The SWS-logo has been taken from the SWS-extension-project, which can be found at sws-extension.org

The Lua-logo and the reference-manual has been taken from lua.org