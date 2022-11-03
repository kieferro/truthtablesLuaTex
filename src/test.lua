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
    local input = { " a",
                    "a",
                    "  b    ",
                    "  b    d",
                    " c d e  ",
                    "ab",
                    "ab " }
    local expectedOutput = { "a",
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

-- Test splitExpression() function
TestSplitExpr = {}
function TestSplitExpr:testSimple()
    local input = { "a OR b AND (C ^ D)",
                    "NOT C || B && ((A OR C))",
                    "NOT NOT NOT C",
                    "NOT C OR NOT B OR A OR C",
                    "~ ~ (A OR (B AND C)) OR (B AND C)" }
    local expectedOutput = { { "a", "OR", "b", "AND", "(C ^ D)" },
                             { "NOT", "C", "||", "B", "&&", "((A OR C))" },
                             { "NOT", "NOT", "NOT", "C" },
                             { "NOT", "C", "OR", "NOT", "B", "OR", "A", "OR", "C" },
                             { "~", "~", "(A OR (B AND C))", "OR", "(B AND C)" } }
    for i = 1, #input do
        luaunit.assertEquals(splitExpression(input[i]), expectedOutput[i])
    end
end
function TestSplitExpr:testUnbalancedBrackets()
    -- Test for expressions with a different number of open and closed brackets
    local unbalanced = { "a OR b AND (",
                         "(((a OR b))",
                         "(",
                         "a OR (b AND (c OR c OR c) XOR (d)",
                         "( " }

    for i = 1, #unbalanced do
        luaunit.assertErrorMsgContains("Error-ID=002", splitExpression, unbalanced[i])
    end
end
function TestSplitExpr:testInvalidBrackets()
    -- Test for expressions with invalid brackets:
    -- 1. More closed brackets than open ones
    -- 2. Closing a bracket that has not been opened
    local invalid = { ")",
                      "())",
                      "a OR (b))",
                      "a OR b)",
                      "a OR )(",
                      "))((",
                      "a OR (b AND (c OR c OR c))) XOR (d" }

    for i = 1, #invalid do
        luaunit.assertErrorMsgContains("Error-ID=001", splitExpression, invalid[i])
    end
end
function TestSplitExpr:testComplex()
    luaunit.skip("Feature and test not yet implemented")
end
function TestSplitExpr:testSeveralSpaces()
    local input = { "a   OR b      AND (C  ^ D)",
                    "NOT    C || B &&   ((A OR C))",
                    "     NOT NOT NOT C   ",
                    "NOT C OR NOT B OR A OR   C ",
                    "~ ~ (A OR (B AND C)) OR    (B    AND    C)",
                    "   NOT   A   " }
    local expectedOutput = { { "a", "OR", "b", "AND", "(C  ^ D)" },
                             { "NOT", "C", "||", "B", "&&", "((A OR C))" },
                             { "NOT", "NOT", "NOT", "C" },
                             { "NOT", "C", "OR", "NOT", "B", "OR", "A", "OR", "C" },
                             { "~", "~", "(A OR (B AND C))", "OR", "(B    AND    C)" },
                             { "NOT", "A" } }
    for i = 1, #input do
        luaunit.assertEquals(splitExpression(input[i]), expectedOutput[i])
    end
end
function TestSplitExpr:testNoSpaces()
    local input = { "a OR b AND(C ^ D)",
                    "NOT C || B &&((A OR C))OR C",
                    "NOT NOT NOT C",
                    "NOT C OR NOT B OR A OR C",
                    "~ ~(A OR(B AND C))OR(B AND C)",
                    "A OR(B OR G)OR(H AND C)AND Z" }
    local expectedOutput = { { "a", "OR", "b", "AND", "(C ^ D)" },
                             { "NOT", "C", "||", "B", "&&", "((A OR C))", "OR", "C" },
                             { "NOT", "NOT", "NOT", "C" },
                             { "NOT", "C", "OR", "NOT", "B", "OR", "A", "OR", "C" },
                             { "~", "~", "(A OR(B AND C))", "OR", "(B AND C)" },
                             { "A", "OR", "(B OR G)", "OR", "(H AND C)", "AND", "Z" } }
    for i = 1, #input do
        luaunit.assertEquals(splitExpression(input[i]), expectedOutput[i])
    end
end
function TestSplitExpr:testAll()
    luaunit.skip("Feature and test not yet implemented")
end

-- Test operatorMatch() function
TestOperatorMatch = {}
function TestOperatorMatch:testEqual()
    luaunit.assertTrue(operatorMatch("and", "and"))
    luaunit.assertTrue(operatorMatch("or", "or"))
    luaunit.assertTrue(operatorMatch("nor", "nor"))
    luaunit.assertTrue(operatorMatch("some_operator", "some_operator"))
end
function TestOperatorMatch:testUppercaseLowercase()
    luaunit.assertTrue(operatorMatch("AND", "and"))
    luaunit.assertTrue(operatorMatch("and", "AND"))
    luaunit.assertTrue(operatorMatch("and", "AnD"))
    luaunit.assertTrue(operatorMatch("aNd", "AnD"))
end
function TestOperatorMatch:testDifferent()
    luaunit.assertFalse(operatorMatch("and", "or"))
    luaunit.assertFalse(operatorMatch("and", "nand"))
    luaunit.assertFalse(operatorMatch("xor", "NOT"))
    luaunit.assertFalse(operatorMatch("operator1", "operator2"))
end
function TestOperatorMatch:testSymbolText()
    luaunit.assertTrue(operatorMatch("&", "and"))
    luaunit.assertTrue(operatorMatch("&&", "and"))
    luaunit.assertTrue(operatorMatch("!", "not"))
    luaunit.assertTrue(operatorMatch("~", "not"))
    luaunit.assertTrue(operatorMatch("|", "or"))
    luaunit.assertTrue(operatorMatch("||", "or"))
    luaunit.assertTrue(operatorMatch("=>", "if"))
    luaunit.assertTrue(operatorMatch("<=", "rif"))
    luaunit.assertTrue(operatorMatch("<=>", "equ"))
    luaunit.assertTrue(operatorMatch("<->", "equ"))
    luaunit.assertTrue(operatorMatch("^", "xor"))
end
function TestOperatorMatch:testTextSymbol()
    luaunit.assertTrue(operatorMatch("and", "&"))
    luaunit.assertTrue(operatorMatch("and", "&&"))
    luaunit.assertTrue(operatorMatch("not", "!"))
    luaunit.assertTrue(operatorMatch("not", "~"))
    luaunit.assertTrue(operatorMatch("or", "|"))
    luaunit.assertTrue(operatorMatch("or", "||"))
    luaunit.assertTrue(operatorMatch("if", "=>"))
    luaunit.assertTrue(operatorMatch("rif", "<="))
    luaunit.assertTrue(operatorMatch("equ", "<=>"))
    luaunit.assertTrue(operatorMatch("equ", "<->"))
    luaunit.assertTrue(operatorMatch("xor", "^"))
end
function TestOperatorMatch:testSymbolSymbol()
    luaunit.assertTrue(operatorMatch("&", "&"))
    luaunit.assertTrue(operatorMatch("&&", "&"))
    luaunit.assertTrue(operatorMatch("|", "|"))
    luaunit.assertTrue(operatorMatch("|", "||"))
    luaunit.assertTrue(operatorMatch("~", "!"))
    luaunit.assertTrue(operatorMatch("^", "^"))
end
function TestOperatorMatch:testNoMatchMixed()
    luaunit.assertFalse(operatorMatch("&", "or"))
    luaunit.assertFalse(operatorMatch("<", "not"))
    luaunit.assertFalse(operatorMatch("|", "and"))
    luaunit.assertFalse(operatorMatch("foo", "bar"))
    luaunit.assertFalse(operatorMatch("!&&", "xor"))
    luaunit.assertFalse(operatorMatch("<=>", "not"))
    luaunit.assertFalse(operatorMatch("~", "and"))
end

-- Test evaluateExpression() function
TestEvaluateExpr = {}
function TestEvaluateExpr:testLowercaseOperators()
    luaunit.skip("Feature and test not yet implemented")
end
function TestSplitExpr:testInvalidExpression()
    luaunit.skip("Feature and test not yet implemented")
end
function TestSplitExpr:testBrackets()
    luaunit.skip("Feature and test not yet implemented")
end
function TestSplitExpr:testOrder()
    luaunit.skip("Feature and test not yet implemented")
end


-- Start unit testing and close with status code
os.exit(luaunit.LuaUnit:run(), false)
