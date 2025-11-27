---Just a more descriptive assert function
---@param value any The value being tested
---@param expected any The value it's being compared against
---@param name string The test name
return function(value, expected, name)
    print('Test: ' .. name)

    if value == expected then
        print('Success! \n')
    else
        local errmsg = 'Value: '
            .. tostring(value)
            .. '\nExpected: '
            .. tostring(expected)
        error(errmsg)
    end
end
