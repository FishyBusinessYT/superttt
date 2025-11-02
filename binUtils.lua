local M = {}

M.printBin = function(num)
    num = num or 0
    local result = ''

    while num > 0 do
        local b = num & 1
        result = b .. result
        num = num >> 1
    end

    print(result)
end

M.getBit = function(num, index)
    return (num >> (index-1)) & 1
end

M.setBit = function(num, index, value)
    index = index - 1
    if value == 1 then
        -- Set the bit to 1
        return num | (1 << index)
    else
        -- Set the bit to 0
        return num & ~(1 << index)
    end
end

return M
