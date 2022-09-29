-- Function to remove spaces from start and end of string
function strip(string)
    -- Remove spaces at the end
    while string:sub(#string, #string) == " " do
        string = string:sub(1, #string - 1)
    end
    -- Remove spaces at the start
    while string:sub(1, 1) == " " do
        string = string:sub(2, #string)
    end

    return string
end

-- Function to split a given expression (string) into parts
-- Parts are separated by spaces and need to be bracketed correctly
function splitExpression(expr)
    splitExpr = {}
    currentStr = ""
    level = 0

    for i = 1, #expr do
        currentChar = expr:sub(i, i)

        if currentChar == "(" then
            level = level + 1

            -- If this starts level one
            if level == 1 then
                goto appendPart
            else
                goto addChar
            end
        elseif currentChar == ")" then
            level = level - 1

            -- If this closes level one
            if level == 0 then
                -- Set currentChar to empty string to reset currentStr
                currentChar = ""
                currentStr = currentStr .. ")"
                goto appendPart
            else
                goto addChar
            end
        elseif currentChar == " " and level == 0 then
            goto appendPart
        else
            goto addChar
        end

        :: appendPart ::
        currentStr = strip(currentStr)

        -- Append string as part
        if #currentStr > 0 then
            splitExpr[#splitExpr + 1] = currentStr
        end

        currentStr = currentChar

        :: addChar ::
        currentStr = currentStr .. currentChar

        :: continue ::
        assert(level >= 0, "Too many closed brackets (ID-sE01)")
    end

    currentStr = strip(currentStr)

    if #currentStr > 0 then
        splitExpr[#splitExpr + 1] = currentStr
    end

    assert(level == 0, "Too few closed brackets (ID-sE02)")
    return splitExpr
end

function evaluateExpression(expr, values)
    return true
end
