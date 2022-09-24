function get_script_path(script_name)
    local path = debug.getinfo(2, "S").source:sub(2)
    local res_windows = path:match("(.*[/\\])")
    local res_unix = path:match("(.*/)")

    if res_windows ~= nil then
        return res_windows .. script_name
    elseif res_unix ~= nil then
        return res_unix .. script_name
    else
        return script_name
    end
end

require(get_script_path("main"))
luaunit = require("luaunit")

TestExprEval = {}
function TestExprEval:test_simple()
    luaunit.skip("Feature and tests not yet implemented")
end
function TestExprEval:test_brackets()
    luaunit.skip("Feature and tests not yet implemented")
end
function TestExprEval:test_complex()
    luaunit.skip("Feature and tests not yet implemented")
end

-- Start unit testing and close with status code
os.exit(luaunit.LuaUnit:run(), false)
