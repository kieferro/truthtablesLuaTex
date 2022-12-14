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
                currentStr = strip(currentStr)

                -- Append string as part
                if #currentStr > 0 then
                    splitExpr[#splitExpr + 1] = currentStr
                end

                currentStr = currentChar
            else
                currentStr = currentStr .. currentChar
            end
        elseif currentChar == ")" then
            level = level - 1

            -- If this closes level one
            if level == 0 then
                currentStr = strip(currentStr .. ")")

                -- Append string as part
                if #currentStr > 0 then
                    splitExpr[#splitExpr + 1] = currentStr
                end

                currentStr = ""
            else
                currentStr = currentStr .. currentChar
            end
        elseif currentChar == " " and level == 0 then
            currentStr = strip(currentStr)

            -- Append string as part
            if #currentStr > 0 then
                splitExpr[#splitExpr + 1] = currentStr
            end

            currentStr = currentChar
        else
            currentStr = currentStr .. currentChar
        end

        assert(level >= 0, "Too many closed brackets (Error-ID=001)")
    end

    currentStr = strip(currentStr)

    if #currentStr > 0 then
        splitExpr[#splitExpr + 1] = currentStr
    end

    assert(level == 0, "Too few closed brackets (Error-ID=002)")
    return splitExpr
end

-- Function to check if a given and a searched operator match.
function operatorMatch(op1, op2)
    OperationConvert = { ["&"] = "and",
                         ["&&"] = "and",
                         ["|"] = "or",
                         ["||"] = "or",
                         ["!"] = "not",
                         ["~"] = "not",
                         ["=>"] = "if",
                         ["<="] = "rif",
                         ["<=>"] = "equ",
                         ["<->"] = "equ",
                         ["^"] = "xor", }

    -- Convert to text
    if OperationConvert[op1] ~= nil then
        op1 = OperationConvert[op1]
    end
    if OperationConvert[op2] ~= nil then
        op2 = OperationConvert[op2]
    end

    return op1:lower() == op2:lower()
end

function evaluateExpression(expr, values)
    return true
end
