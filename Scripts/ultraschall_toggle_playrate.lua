--[[
################################################################################
# 
# Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
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
]]

-- toggle the playrate from 1.0 to a user defined value and back, preset is 1.5

reaper.Undo_BeginBlock()

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

len, AlternativeRate = ultraschall.GetUSExternalState("ultraschall_playrate", "AlternativeRate")

local old_val = reaper.Master_GetPlayRate(0) -- get the actual playrate

if old_val == 1 then 
	val = tonumber(AlternativeRate)
elseif old_val ~= tonumber(AlternativeRate) then -- someone changed the playrate via slider
	ultraschall.SetUSExternalState("ultraschall_playrate", "AlternativeRate", old_val)  --save state docked    
	val = 1.0
else
	val = 1.0
end

reaper.CSurf_OnPlayRateChange( val )  -- set new playrate
reaper.Undo_EndBlock( "Toggle Playrate", -1 )