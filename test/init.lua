require('test.gameState')





local function printable(tbl, level)
    level = level or 0
    local indent = string.rep('\t', level)

    io.write(indent .. '{\n')
    for key, value in pairs(tbl) do
        if type(value) == 'table' then
            printable(value, level + 1)
        else
            io.write(indent .. string.format('[%s] = %s', key, value))
        end
        io.write(',\n')
    end
    io.write(indent .. '}\n')
end

