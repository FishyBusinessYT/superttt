local gameState = require('gameState')()

--- Test initial state
local function testInitialState()
    assert(gameState.isXsTurn)
    assert(gameState.xwon == 0)
    assert(gameState.owon == 0)

    for i = 1, 9 do
        assert(gameState.xmarks[i] == 0)
        assert(gameState.omarks[i] == 0)
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

