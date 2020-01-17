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
]]


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


function main()

  local message_count = tonumber(reaper.GetExtState("ultraschall_messages", "message_count"))

  if message_count ~= nil then
    -- print("count: "..message_count)

    local message_textbox = "\n"

    for i = 0, message_count-1, 1 do

      local message_id = "message_" .. tostring(i)


      -- print(reaper.GetExtState("ultraschall_messages", message_id))

      local Message = reaper.GetExtState("ultraschall_messages", message_id)
      Status, Context, MessageText = Message:match("(.-);(.-);(.*)")

      -- print(message_id)
      -- print(Status)
      -- print(Context)
      -- print(MessageText)

      if (Status) == "!" then
        message_textbox = message_textbox .. "WARNING: "
      elseif (Status) == "+" then
        message_textbox = message_textbox .. "SUCCESS: "
      elseif (Status) == "-" then
        message_textbox = message_textbox .. "FAILURE: "
      elseif (Status) == "?" then
        message_textbox = message_textbox .. "INFO: "
      end

      message_textbox = message_textbox .. MessageText .. "\n"
      -- print(message_textbox)
      reaper.DeleteExtState("ultraschall_messages", message_id, false)

    end

    reaper.DeleteExtState("ultraschall_messages", "message_count", false)
    reaper.ShowMessageBox(message_textbox, "Ultraschall Message", 0)


  end

  retval, defer_identifier = ultraschall.Defer20(main, 2, 1)

end

main()
