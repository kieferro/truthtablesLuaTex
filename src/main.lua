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

function evaluateExpression(expr, values)
    expressionParts = {}
    currentStr = ""
    level = 0

    for i = 1, #expr do
        currentChar = expr:sub(i, i)

        if currentChar == "(" then
            if level == 0 and #currentStr > 0 then
                expressionParts[#expressionParts + 1] = currentStr
                currentStr = "("
            end

            level = level + 1
        elseif currentChar == ")" then
            currentStr = currentStr .. ")"

            if level == 1 then
                expressionParts[#expressionParts + 1] = currentStr
                currentStr = ""
            end

            level = level - 1
        elseif currentChar == " " then
            if level == 0 and #currentStr > 0 then
                expressionParts[#expressionParts + 1] = currentStr
                currentStr = ""
            end

            if #currentStr > 0 then
                currentStr = currentStr .. " "
            end
        else
            currentStr = currentStr .. currentChar
        end

        assert(level >= 0)
    end

    for i = 1, #expressionParts do
        print(expressionParts[i])
    end

    return true
end
