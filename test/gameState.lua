local GS = require('classes.gameState')

local gameState = GS()

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

for _ = 1, 4 do
    local legalMoves = gameState.getLegalMoves()
    local pickedMove = math.random(1, #legalMoves)
    local move = legalMoves[pickedMove]

    gameState.placeMark(move[1], move[2])

    if math.random(1, 2) == 2 then
        print(_)
        printable(gameState)

        gameState.undoMove()
        gameState.placeMark(move[1], move[2])

        printable(gameState)
    end
end

return gameState
