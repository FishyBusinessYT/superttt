local gameState = require('gameState')()

---Just a more descriptive assert function
---@param value any The value being tested
---@param expected any The value it's being compared against
---@param name string The test name
local function ensure(value, expected, name)
    print('Running assertion: ' .. name)
    print('Value: ' .. tostring(value))
    print('Expected: ' .. tostring(expected))

    assert(value == expected)
    print('Success! \n\n')
end

--- Test initial state
local function testInitialState()
    -- X should be the first player to play
    ensure(gameState.isXsTurn, true, 'X goes first')

    -- Neither player should have won any board
    ensure(gameState.xwon, 0, 'X owns no boards initially')
    ensure(gameState.owon, 0, 'O owns no boards initially')

    -- Or placed any marks, for that matter
    for i = 1, 9 do
        ensure(gameState.xmarks[i], 0, 'X has no marks initially (' .. i .. ')')
        ensure(gameState.omarks[i], 0, 'O has no marks initially (' .. i .. ')')
    end

    -- getLegalMoves should return a list of 9*9 = 81 legal moves right at the
    -- start, as X can pick any of the board's cells as their first move.
    local legalMoves = gameState.getLegalMoves()
    ensure(#legalMoves, 81, 'Move generation initially generates 81 moves')

    -- Verify every move is present and in the correct order, starting from
    -- {1, 1} up to {9, 9}
    local boardCounter = 1
    local cellCounter = 1

    for _, move in ipairs(legalMoves) do
        if cellCounter == 10 then
            boardCounter = boardCounter + 1
            cellCounter = 1
        end

        ensure(move[1], boardCounter, 'Moves have the correct board value')
        ensure(move[2], cellCounter, 'Moves have the corect cell value')

        cellCounter = cellCounter + 1
    end
end

testInitialState()

--- Test moving as X
-- First mark can be placed anywhere
ensure(pcall(gameState.placeMark, { 1, 1 }), true, 'placeMark can be called')

ensure(gameState.isXsTurn, false, 'Turn changes after placing a mark')
ensure(gameState.xmarks[1], 1, 'The mark is saved')

-- Trying to place a mark on any board other than 1 should raise an exception
-- and not change the game state
for i = 2, 9 do
    ensure(
        pcall(gameState.placeMark, { i, 1 }),
        false,
        'placeMark disallows playing on boards other than 1'
    )
    ensure(
        gameState.isXsTurn,
        false,
        'Turn does not change after a failed move'
    )
    ensure(gameState.omarks[i], 0, 'Mark is not saved after a failed move')
end

-- Then again, making the same move twice should not be allowed either
assert(not pcall(gameState.placeMark, { 1, 1 }))
assert(not gameState.isXsTurn)
assert(gameState.omarks[1] == 0)

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

--- Test move generation again
local legalMoves2 = gameState.getLegalMoves()

-- The list should only contain all 9 cells of board 2.
assert(#legalMoves2 == 9)
for cell, move in ipairs(legalMoves2) do
    assert(move[1] == 2)
    assert(move[2] == cell)
end

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

--- Test board checking
-- Let's have X take the first row of cells of the first board
assert(pcall(gameState.placeMark, { 1, 2 })) -- X1
assert(not gameState.isXsTurn)
assert(gameState.xmarks[1] == 2)

assert(pcall(gameState.placeMark, { 2, 1 })) -- O2
assert(gameState.isXsTurn)
assert(gameState.omarks[2] == 1)

assert(pcall(gameState.placeMark, { 1, 3 })) -- X3
assert(not gameState.isXsTurn)
assert(gameState.xmarks[1] == 6)

assert(pcall(gameState.placeMark, { 3, 1 })) -- O4
assert(gameState.isXsTurn)
assert(gameState.omarks[3] == 1)

assert(pcall(gameState.placeMark, { 1, 1 })) -- X5
assert(not gameState.isXsTurn)
assert(gameState.xmarks[1] == 7)

-- If board checking works properly, X should have taken the first board by now
assert(gameState.xwon == 1)

-- Now let's have O take the top-center board
assert(pcall(gameState.placeMark, { 2, 3 })) -- O6
assert(gameState.isXsTurn)
assert(gameState.omarks[2] == 5)

assert(pcall(gameState.placeMark, { 3, 2 })) -- X7
assert(not gameState.isXsTurn)
assert(gameState.xmarks[3] == 2)

assert(pcall(gameState.placeMark, { 2, 2 })) -- O8
assert(gameState.isXsTurn)
assert(gameState.omarks[2] == 7)

-- If board checks work properly, O should have now taken the second board
assert(gameState.owon == 2)

--[[
This is what the board looks like right now. Every mark is labeled according
to the order in which they were placed:

    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    |  X  |  X  |  X  | |  O  |  O  |  O  | |  O  |  X  |     |
    |  5  |  1  |  3  | |  2  |  8  |  6  | |  4  |  7  |     |
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    |     |     |     | |     |     |     | |     |     |     |
    |     |     |     | |     |     |     | |     |     |     |
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    |     |     |     | |     |     |     | |     |     |     |
    |     |     |     | |     |     |     | |     |     |     |
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    |     |     |     | |     |     |     | |     |     |     |
    |     |     |     | |     |     |     | |     |     |     |
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    |     |     |     | |     |     |     | |     |     |     |
    |     |     |     | |     |     |     | |     |     |     |
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    |     |     |     | |     |     |     | |     |     |     |
    |     |     |     | |     |     |     | |     |     |     |
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    |     |     |     | |     |     |     | |     |     |     |
    |     |     |     | |     |     |     | |     |     |     |
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    |     |     |     | |     |     |     | |     |     |     |
    |     |     |     | |     |     |     | |     |     |     |
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
    |     |     |     | |     |     |     | |     |     |     |
    |     |     |     | |     |     |     | |     |     |     |
    +-----+-----+-----+ +-----+-----+-----+ +-----+-----+-----+
]]

--- Test move generation when boards have been won.

-- The board that would be forced (board 2) is also already won by O. Thus, X
-- should be able to place a mark on any board, as long as that board is not
-- won by either player and move generation should reflect that.
local legalMoves3 = gameState.getLegalMoves()

-- The list should contain the other 7 cells on board 3, and every cell on
-- boards 4-9. That amounts to 6*9+7 = 61 possible moves.
assert(#legalMoves3 == 61)

-- Make sure the first seven moves on the list are cells 3-9 on board 3
for i = 1, 7 do
    local move = legalMoves3[i]
    assert(move[1] == 3)
    assert(move[2] == i + 2)
end

-- Then iterate through the rest to make sure that they're all there.
local cell, board = 1, 4
for i = 8, 61 do
    local move = legalMoves3[i]
    assert(move[1] == board)
    assert(move[2] == cell)
    cell = cell + 1
    if cell == 10 then
        cell = 1
        board = board + 1
    end
end

--- Trying to place a mark on a board that's already been taken should raise an
--- exception and not change the game state
assert(not pcall(gameState.placeMark, { 1, 5 }))
assert(gameState.isXsTurn)
assert(gameState.xmarks[1] == 7)

--- CHECK GAME WIN STATE
--- CHECK GAME DRAWS (HIGHLY UNLIKELY THOUGH)
--- CHECK MOVES IN BOARDS/CELLS OUTSIDE OF RANGE
