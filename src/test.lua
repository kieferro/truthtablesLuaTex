-- Function to get the path to a script from the compile directory
function get_script_path(scriptName)
    -- The path to this test.lua file is read from the debug info and
    -- matched with the patterns for windows and unix
    local path = debug.getinfo(2, "S").source:sub(2)
    local resultWindows = path:match("(.*[/\\])")
    local resultUnix = path:match("(.*/)")

    if resultWindows ~= nil then
        return resultWindows .. scriptName
    elseif resultUnix ~= nil then
        return resultUnix .. scriptName
    else
        return scriptName
    end
end

-- Include main file and luaunit
require(get_script_path("main"))
luaunit = require("luaunit")

-- Test strip() function
TestStrip = {}
function TestStrip:test()
    input = { " a",
              "a",
              "  b    ",
              "  b    d",
              " c d e  ",
              "ab",
              "ab " }
    expectedOutput = { "a",
                       "a",
                       "b",
                       "b    d",
                       "c d e",
                       "ab",
                       "ab" }

    for i = 1, #input do
        luaunit.assertEquals(strip(input[i]), expectedOutput[i])
    end
end

-- Test evaluateExpression() function
TestExprEval = {}
function TestExprEval:test_simple()
    luaunit.skip("Feature and test not yet implemented")
end
function TestExprEval:test_brackets()
    luaunit.skip("Feature and test not yet implemented")
end
function TestExprEval:test_complex()
    luaunit.skip("Feature and test not yet implemented")
end
function TestExprEval:test_lowercase_operators()
    luaunit.skip("Feature and test not yet implemented")
end
function TestExprEval:test_invalid_expression()
    luaunit.skip("Feature and test not yet implemented")
end

-- Start unit testing and close with status code
os.exit(luaunit.LuaUnit:run(), false)
