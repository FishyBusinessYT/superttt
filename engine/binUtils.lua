local M = {}

M.printBin = function(num)
    num = num or 0
    local result = ''

    while num > 0 do
        local b = bit.band(num, 1)
        result = b .. result
        num = bit.rshift(num, 1)
    end

    print(string.format('%09d', tonumber(result) or 0))
end

M.getBit = function(num, index)
    return bit.band((bit.rshift(num, index-1)), 1)
end

M.setBit = function(num, index, value)
    index = index - 1
    if value == 1 then
        -- Set the bit to 1
        return bit.bor(num, bit.lshift(1, index))
    else
        -- Set the bit to 0
        return bit.band(num, bit.bnot(bit.lshift(1, index)))
    end
end

return M
