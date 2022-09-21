function evaluateExpression (exp)
    return true
end

logicalExpression = "((NOT (NOT p)) OR (q AND b))"
print(evaluateExpression(logicalExpression))
