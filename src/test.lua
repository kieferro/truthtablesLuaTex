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

function test()
    luaunit.assertEquals(true, evaluateExpression(""))
end

-- Start unit testing and close with status code
os.exit(luaunit.LuaUnit:run(), false)
