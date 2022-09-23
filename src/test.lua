luaunit = require("luaunit")

function test()
    luaunit.assertEquals(1,1)
end

-- Start unit testing and close with status code
os.exit(luaunit.LuaUnit:run(), false)
