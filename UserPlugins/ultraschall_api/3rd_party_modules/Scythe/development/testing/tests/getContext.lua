describe("Scythe.getContext", function()
  local context
  it("should get the script context", function()
    context = Scythe.getContext()

    expect(type(context.filename)).toEqual("string")
    expect(type(context.midiValue)).toEqual("number")
  end)

  it("should return the same values", function()
    expect(Scythe.getContext()).toEqual(context)
  end)
end)
