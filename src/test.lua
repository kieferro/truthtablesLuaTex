-- Function to get the path to a script from the compile directory
function getScriptPath(scriptName)
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
require(getScriptPath("main"))
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
TestSplitExpr = {}
function TestSplitExpr:testSimple()
    luaunit.skip("Feature and test not yet implemented")
end
function TestSplitExpr:testUnbalancedBrackets()
    -- Test for expressions with a different number of open and closed brackets
    unbalanced = { "a OR b AND (",
                   "(((a OR b))",
                   "(",
                   "a OR (b AND (c OR c OR c) XOR (d)",
                   "( " }

    for i = 1, #unbalanced do
        luaunit.assertErrorMsgContains("ID-sE02", splitExpression, unbalanced[i])
    end
end
function TestSplitExpr:testInvalidBrackets()
    -- Test for expressions with invalid brackets:
    -- 1. More closed brackets than open ones
    -- 2. Closing a bracket that has not been opened
    invalid = { ")",
                "())",
                "a OR (b))",
                "a OR b)",
                "a OR )(",
                "))((",
                "a OR (b AND (c OR c OR c))) XOR (d" }

    for i = 1, #invalid do
        luaunit.assertErrorMsgContains("ID-sE01", splitExpression, invalid[i])
    end
end
function TestSplitExpr:testComplex()
    luaunit.skip("Feature and test not yet implemented")
end

-- Test evaluateExpression() function
TestEvaluateExpr = {}
function TestEvaluateExpr:testLowercaseOperators()
    luaunit.skip("Feature and test not yet implemented")
end
function TestSplitExpr:testInvalidExpression()
    luaunit.skip("Feature and test not yet implemented")
end

-- Start unit testing and close with status code
os.exit(luaunit.LuaUnit:run(), false)
