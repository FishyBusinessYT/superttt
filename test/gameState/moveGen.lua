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
gameState.placeMark({ 1, 1 })
testMoveGen(1, 2, 1, 9, gameState.getLegalMoves())

-- Undo the move and test previous case again
gameState.undoMove()
testMoveGen(1, 1, 9, 9, gameState.getLegalMoves())
gameState.placeMark({ 1, 1 })

-- Now, the list should only contain all 9 cells of board 2.
gameState.placeMark({ 1, 2 })
testMoveGen(2, 1, 2, 9, gameState.getLegalMoves())

--Undo and retest
gameState.undoMove()
testMoveGen(1, 2, 1, 9, gameState.getLegalMoves())

-- Let's have board 1 be taken by X
gameState.undoMove()

gameState.placeMark({ 1, 2 }) -- X
gameState.placeMark({ 2, 1 }) -- O
gameState.placeMark({ 1, 3 }) -- X
gameState.placeMark({ 3, 1 }) -- O
gameState.placeMark({ 1, 1 }) -- X takes board 1

-- Now, the board that would be forced is also taken, so O should be free
-- to place a mark wherever they like:
-- gameState.placeMark({ 2, 3 })

-- In this case, the legal moves are not continuous, so we need 2 tests
-- First, cells 2-9 of board 2:
testMoveGen(2, 2, 2, 9, { table.unpack(gameState.getLegalMoves(), 1, 8) })

-- Then, every other cell from b3c2 to b9c9:
testMoveGen(3, 2, 9, 9, { table.unpack(gameState.getLegalMoves(), 9) })

--Now we'll make a move, undo it and retest
gameState.placeMark({ 2, 3 })
gameState.undoMove()

testMoveGen(2, 2, 2, 9, { table.unpack(gameState.getLegalMoves(), 1, 8) })
testMoveGen(3, 2, 9, 9, { table.unpack(gameState.getLegalMoves(), 9) })
