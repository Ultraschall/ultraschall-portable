local testFiles = {
  ["/test"] = {
    files = {
      "it.exe",
      "was.exe",
      "the.txt",
      "best.txt",
      "of.dll",
      "times.dll",
    },
    folders = {
      "things",
      "stuff",
      "other-stuff",
    }
  },
  ["/test/things"] = {
    files = {
      "apples.dll",
      "bananas.cpp",
      "cherries.txt",
    },
    folders = {
      "one",
      "two",
      "three",
    },
  },
  ["/test/things/two"] = {
    files = {
      "four.lua",
      "six.lua",
      "eight.md",
      "ten.txt",
    },
    folders = {},
  },
}

local expected = {
  all = {
    "/test/it.exe",
    "/test/was.exe",
    "/test/the.txt",
    "/test/best.txt",
    "/test/of.dll",
    "/test/times.dll",
    "/test/things/apples.dll",
    "/test/things/bananas.cpp",
    "/test/things/cherries.txt",
    "/test/things/two/four.lua",
    "/test/things/two/six.lua",
    "/test/things/two/eight.md",
    "/test/things/two/ten.txt",
  },
  startsWithT = {
    "/test/the.txt",
    "/test/times.dll",
    "/test/things/two/ten.md",
  },
  txt = {
    "/test/the.txt",
    "/test/best.txt",
    "/test/things/cherries.txt",
    "/test/things/two/ten.txt",
  }
}

local File = requireWithMocks("public.file", {
  reaper = {
    EnumerateFiles = function(path, idx) return testFiles[path] and testFiles[path].files and testFiles[path].files[idx + 1] end,
    EnumerateSubdirectories = function(path, idx) return testFiles[path] and testFiles[path].folders and testFiles[path].folders[idx + 1] end,
  },
})

describe("File.files", function()
  test("", function()
    local count = 0
    for _, file in File.files("/test") do
      count = count + 1
      expect(testFiles["/test"].files).toInclude(file)
    end

    expect(count).toEqual(#testFiles["/test"].files)
  end)
end)

describe("File.folders", function()
  test("", function()
    local count = 0
    for _, folder in File.folders("/test") do
      count = count + 1
      expect(testFiles["/test"].folders).toInclude(folder)
    end

    expect(count).toEqual(#testFiles["/test"].folders)
  end)
end)

describe("File.getFiles", function()
  test("without a filter", function()
    local files = File.getFiles("/test/things")

    for _, file in pairs(files) do
      expect(testFiles["/test/things"].files).toInclude(file.name)
    end

    expect(#files).toEqual(#testFiles["/test/things"].files)
  end)

  test("with a filter", function()
    local files = File.getFiles(
      "/test/things",
      function(name) return name:match("banana") end
    )

    expect(#files).toEqual(1)
    expect(files[1].name).toEqual("bananas.cpp")
  end)
end)

describe("File.getFolders", function()
  test("without a filter", function()
    local folders = File.getFolders("/test/things")

    for _, folder in pairs(folders) do
      expect(testFiles["/test/things"].folders).toInclude(folder.name)
    end

    expect(#folders).toEqual(#testFiles["/test/things"].folders)
  end)

  test("with a filter", function()
    local folders = File.getFolders(
      "/test/things",
      function(name) return name:match("three") end
    )

    expect(#folders).toEqual(1)
    expect(folders[1].name).toEqual("three")
  end)
end)

describe("File.getFilesRecursive", function()
  test("without a filter", function()
    local files = File.getFilesRecursive("/test")

    for _, file in pairs(files) do
      expect(expected.all).toInclude(file.path)
    end

    expect(#files).toEqual(#expected.all)
  end)

  test("with a filter", function()

    local files = File.getFilesRecursive("/test", function(file, _, isFolder) return isFolder or file:match("%.txt") end)

    for _, file in pairs(files) do
      Msg(file.path)
      expect(expected.txt).toInclude(file.path)
    end

    expect(#files).toEqual(#expected.txt)
  end)
end)
