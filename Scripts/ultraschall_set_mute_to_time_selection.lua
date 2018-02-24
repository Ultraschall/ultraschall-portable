--[[
 * ReaScript Name: Set flat points value in time selection
 * Description: A pop up to let you put offset values for selected item points. 
 * Instructions: Write values you want. Use "+" sign for relative value (the value is added to the original), no sign for absolute Exemple: -6 is absolute, or +-6 is relative. Don't use percentage. Example: writte "60" for 60%.
 * Author: X-Raym
 * Author URI: http://extremraym.com
 * Repository: GitHub > X-Raym > EEL Scripts for Cockos REAPER
 * Repository URI: https://github.com/X-Raym/REAPER-EEL-Scripts
 * File URI: 
 * Licence: GPL v3
 * Forum Thread: ReaScript: Set/Offset selected envelope points values
 * Forum Thread URI: http://forum.cockos.com/showthread.php?p=1487882#post1487882
 * REAPER: 5.0 pre 9
 * Extensions: SWS 2.6.3 #0
 * Version: 1.6
]]
 
--[[
 * Changelog:
 * v1.6 (2015-09-09)
  + Fader scaling support
 * v1.5 (2015-07-11)
  + Send support
 * v1.4 (2015-06-25)
  # Dual pan track support
 * v1.3 (2015-05-26)
  # bug fix when pop up is cancelled
 * v1.0.1 (2015-05-07)
  # Time selection bug fix
 * v1.0 (2015-03-21)
  + Initial Release
]]

--[[ ----- DEBUGGING ===>
function get_script_path()
  if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
    return debug.getinfo(1,'S').source:match("(.*".."\\"..")"):sub(2) -- remove "@"
  end
    return debug.getinfo(1,'S').source:match("(.*".."/"..")"):sub(2)
end

package.path = package.path .. ";" .. get_script_path() .. "?.lua"
require("X-Raym_Functions - console debug messages")

debug = 1 -- 0 => No console. 1 => Display console messages for debugging.
clean = 1 -- 0 => No console cleaning before every script execution. 1 => Console cleaning before every script execution.

--msg_clean()
]]-- <=== DEBUGGING -----

-- ----- CONFIG ====>

preserve_edges = true -- True will insert points à time selection edges before the action.

-- <==== CONFIG -----

-- INIT
time = {}
valueSource = {}
shape = {}
tension = {}
selectedOut = {}

function main() -- local (i, j, item, take, track)

  -- GET LOOP
  start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
  
  -- IF LOOP ?
  if start_time ~= end_time then
    time_selection = true
  end

  if time_selection == true then

    -- retval, user_input_str = reaper.GetUserInputs("Set point value", 1, "Value ?", "") -- We suppose that the user know the scale he want
    retval = true
    user_input_str = "0"

    -- IF USER PASTE A VALUE
    if retval ~= false then

      user_input_num = tonumber(user_input_str)

      -- GET SELECTED ENVELOPE
      sel_env = reaper.GetSelectedEnvelope(0)
      
      if sel_env ~= nil then
        env_point_count = reaper.CountEnvelopePoints(sel_env)
        retval, env_name = reaper.GetEnvelopeName(sel_env, "")

        -- LOOP TRHOUGH SELECTED TRACKS
        selected_tracks_count = reaper.CountSelectedTracks(0)
        for j = 0, selected_tracks_count-1  do
          
          -- GET THE TRACK
          track = reaper.GetSelectedTrack(0, j) -- Get selected track i

          env_count = reaper.CountTrackEnvelopes(track)
          
          for m = 0, env_count-1 do

            -- GET THE ENVELOPE
            env_dest = reaper.GetTrackEnvelope(track, m)
            retval, env_name_dest = reaper.GetEnvelopeName(env_dest, "")
            
            if env_name_dest == env_name then

              -- IF VISIBLE AND ARMED
              br_env = reaper.BR_EnvAlloc(env_dest, false)
              active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)
              if visible == true and armed == true then
              
                retval3, valueOut3, dVdSOutOptional3, ddVdSOutOptional3, dddVdSOutOptional3 = reaper.Envelope_Evaluate(env_dest, start_time, 0, 0)
                retval4, valueOut4, dVdSOutOptional4, ddVdSOutOptional4, dddVdSOutOptional4 = reaper.Envelope_Evaluate(env_dest, end_time, 0, 0)
                
                start_time_temp = math.floor(start_time * 100000000+0.5)/100000000
                end_time_temp = math.floor(end_time * 100000000+0.5)/100000000

                start_point = reaper.GetEnvelopePointByTime(env_dest, start_time+0.000000001)
                retval, start_point_time, valueOut, shape, tension, selectedOut = reaper.GetEnvelopePoint(env_dest,start_point-1)
                
                start_point_time = math.floor(start_point_time * 100000000+0.5)/100000000
                
                if start_point_time == start_time_temp then
                  valueOut3 = valueOut
                end

                reaper.DeleteEnvelopePointRange(env_dest, start_time-0.000000001, end_time+0.000000001)
              
                valueIn = 0 -- mute is always 0

                -- PRESERVE EDGES INSERTION
                if preserve_edges == true then
                  
                  reaper.InsertEnvelopePoint(env_dest, start_time, valueOut3, 0, 0, true, true) -- INSERT startLoop point
                  reaper.InsertEnvelopePoint(env_dest, start_time, valueIn, 0, 0, true, true) -- INSERT startLoop point
                  reaper.InsertEnvelopePoint(env_dest, end_time, valueIn, 0, 0, true, true) -- INSERT startLoop point
                  reaper.InsertEnvelopePoint(env_dest, end_time, valueOut4, 0, 0, true, true) -- INSERT startLoop point
                
                else

                  reaper.InsertEnvelopePoint(env_dest, start_time, valueIn, 0, 0, true, true) -- INSERT startLoop point
                  reaper.InsertEnvelopePoint(env_dest, end_time, valueIn, 0, 0, true, true) -- INSERT startLoop point

                end

                reaper.BR_EnvFree(br_env, 0)
                reaper.Envelope_SortPoints(env_dest)

              end -- ENDIF envelope passed
            
            end -- ENDIF envelope with same name selected

          end -- ENDLOOP selected tracks envelope
        
        end -- ENDLOOP selected tracks

        
      end
    end
  end
end -- end main()



--msg_start() -- Display characters in the console to show you the begining of the script execution.
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
main() -- Execute your main function
reaper.Undo_EndBlock("Set flat points value in time selection", 0) -- End of the undo block. Leave it at the bottom of your main function.
reaper.UpdateArrange() -- Update the arrangement (often needed)

--msg_end() -- Display characters in the console to show you the end of the script execution.
