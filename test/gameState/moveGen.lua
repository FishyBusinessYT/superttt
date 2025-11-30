--- This test assumes GameState.placeMark and GameState.undoMove work as they
--- should, and that the initial state is correct
print('Testing GameState.getLegalMoves')

local gameState = require('gameState')()
local ensure = require('test.ensure')

---Helper function to reduce code repetition when testing move generation
---@param fb integer The board to start counting at
---@param fc integer The cell to start counting at
---@param lb integer The board to stop counting at
---@param lc integer The cell to stop counting at
---@param legalMoves [integer, integer][]
local function testMoveGen(fb, fc, lb, lc, legalMoves)
    local cellPosStr1 = 'b' .. fb .. 'c' .. fc
    local cellPosStr2 = 'b' .. lb .. 'c' .. lc
    print(
        'Ensuring moveGen returns all cells from '
            .. cellPosStr1
            .. ' to '
            .. cellPosStr2
    )

    local length = 9 * (lb - fb + 1) - (8 - lc + fc)
    ensure(#legalMoves, length, 'Ensuring legalMoves has the correct length')

    local board, cell = fb, fc
    local missingMove = {}

    for _, move in ipairs(legalMoves) do
        if move[1] ~= board or move[2] ~= cell then
            missingMove = { board, cell }
        end

        cell = cell + 1
        if cell == 10 then
            board = board + 1
            cell = 1
        end
    end

    ensure(#missingMove, 0, 'All moves are present and in the correct order')
end



-- getLegalMoves should return a list of all 81 cells in the board at the start
testMoveGen(1, 1, 9, 9, gameState.getLegalMoves())

-- After placing a mark on b1c1, the list should only contain the other 8 cells
-- from that board.
gameState.placeMark({1, 1})
testMoveGen(1, 2, 1, 9, gameState.getLegalMoves())


-- When they're different
-- When a board is forced by lc
-- When the forced board is already taken
-- When empty cells are not continuous
-- Every case works even after making a move and undoing it
