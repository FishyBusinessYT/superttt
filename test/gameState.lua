local gameState = require('gameState')()

--- Test initial state
local function testInitialState()
    -- X should be the first player to play
    assert(gameState.isXsTurn)

    -- Neither player should have won any board
    assert(gameState.xwon == 0)
    assert(gameState.owon == 0)

    -- Or placed any marks, for that matter
    for i = 1, 9 do
        assert(gameState.xmarks[i] == 0)
        assert(gameState.omarks[i] == 0)
    end

    -- getLegalMoves should return a list of 9*9 = 81 legal moves right at the
    -- start, as X can pick any of the board's cells as their first move.
    local legalMoves = gameState.getLegalMoves()
    assert(#legalMoves == 81)

    -- Verify every move is present and in the correct order, starting from
    -- {1, 1} up to {9, 9}
    local boardCounter = 1
    local cellCounter = 1

    for _, move in ipairs(legalMoves) do
        if cellCounter == 10 then
            boardCounter = boardCounter + 1
            cellCounter = 1
        end

        assert(move[1] == boardCounter and move[2] == cellCounter)

        cellCounter = cellCounter + 1
    end
end
testInitialState()

--- Test moves TODO TEST MOVING AS O AS WELL
-- First mark can be placed anywhere
assert(pcall(gameState.placeMark, { 1, 1 }))

assert(gameState.xmarks[1] == 1)
assert(not gameState.isXsTurn)

-- Trying to place a mark on any board other than 5 should raise an exception
-- and not change the game state
for i = 2, 9 do
    local succeeded = pcall(gameState.placeMark, { i, 1 })

    assert(not succeeded)
    assert(not gameState.isXsTurn)
    assert(gameState.omarks[i] == 0)
end

--- Test move undo
-- Logically, undoing the first ever move should restore the game to its
-- original state.
gameState.undoMove()
testInitialState()

-- Undoing another move should raise an exception and not change the game state
-- at all.
assert(not pcall(gameState.undoMove))
testInitialState()
