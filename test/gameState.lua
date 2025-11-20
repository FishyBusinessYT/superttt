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

--- Test moving as X
-- First mark can be placed anywhere
assert(pcall(gameState.placeMark, { 1, 1 }))

assert(not gameState.isXsTurn)
assert(gameState.xmarks[1] == 1)

-- Trying to place a mark on any board other than 5 should raise an exception
-- and not change the game state
for i = 2, 9 do
    assert(not pcall(gameState.placeMark, { i, 1 }))
    assert(not gameState.isXsTurn)
    assert(gameState.omarks[i] == 0)
end

-- Then again, making the same move twice should not be allowed either
assert(not pcall(gameState.placeMark, { 1, 1 }))
assert(not gameState.isXsTurn)
assert(gameState.omarks[1] == 1)

--- Test move generation
local legalMoves = gameState.getLegalMoves()

-- The list should only contain the other 8 cells on board 1.
assert(#legalMoves == 8)
for idx, move in ipairs(legalMoves) do
    local cell = idx + 1
    assert(move[1] == 1)
    assert(move[2] == cell)
end

--- Test moving as O
-- Only placing a mark on board 1 should be allowed
assert(pcall(gameState.placeMark, { 1, 2 }))
assert(gameState.isXsTurn)
assert(gameState.omarks[1] == 2)

--- Test move undo
-- Logically, undoing the first two moves should fully restore the game state.
gameState.undoMove()
assert(not gameState.isXsTurn)
assert(gameState.omarks[1] == 0)

gameState.undoMove()
testInitialState()

-- Undoing another move should raise an exception and not change the game state
-- at all.
assert(not pcall(gameState.undoMove))
testInitialState()
