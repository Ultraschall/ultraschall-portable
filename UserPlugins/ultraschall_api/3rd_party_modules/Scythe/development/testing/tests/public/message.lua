local msgStore = {}

local Message = requireWithMocks("public.message", {
  reaper = {
    ShowConsoleMsg = function(msg) msgStore[#msgStore+1] = msg end,
  }
})

local function initMsgStore() msgStore = {} end

describe("Message.Msg", function()
  test("prints messages", function()
    initMsgStore()
    Message.Msg("hello")
    Message.Msg("world")

    expect(msgStore).toShallowEqual({"hello\n", "world\n"})
  end)

  test("concatenates arguments", function()
    initMsgStore()
    Message.Msg("Me", "myself", "and I.")

    expect(msgStore[1]).toEqual("Me, myself, and I.\n")
  end)

  test("casts arguments to a string", function()
    initMsgStore()
    local t = {}
    Message.Msg(true)
    Message.Msg(t)

    expect(msgStore).toShallowEqual({
      "true\n",
      tostring(t).."\n"
    })
  end)
end)

describe("Message.queueMsg / printQueue", function()
  test("doesn't immediately print messages", function()
    initMsgStore()
    Message.queueMsg("hello")
    Message.queueMsg("world")

    expect(msgStore).toShallowEqual({})
  end)

  test("concatenates and prints queued messages", function()
    Message.printQueue()

    expect(msgStore).toShallowEqual({"hello\nworld\n"})
  end)
end)
