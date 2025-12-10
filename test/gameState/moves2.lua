print('Testing GameState.placeMark and GameState.undoMove with taken boards')

local gameState = require('test.utils').GS()
local ensure = require('test.utils').ensure

---One place to test placeMark under different circumstances
---@param board integer
---@param cell integer
---@param isXMark boolean
---@param shouldWork boolean
local function testMove(board, cell, isXMark, shouldWork)
    local cellPosStr = 'b' .. board .. 'c' .. cell
    local playerStr = isXMark and 'X' or 'O'

    -- This will end up looking something like:
    -- 'Ensure placeMark call by X on cellPos b1c1 succeeds'
    local ensureMsg = 'Ensure placeMark call by '
        .. playerStr
        .. ' on cellPos '
        .. cellPosStr
    ensureMsg = ensureMsg .. (shouldWork and ' succeeds' or ' fails')

    -- Needs to be stored before calling placeMark. See the else block below.
    local prevCellOwner = gameState.getCellOwner({ board, cell })

    ensure(pcall(gameState.placeMark, { board, cell }), shouldWork, ensureMsg)

    if shouldWork then
        ensure(gameState.isXsTurn, not isXMark, 'Verify turn change')

        ensure(
            gameState.getCellOwner({ board, cell }),
            isXMark and 1 or 2,
            'Verify mark is saved'
        )
    else
        ensure(gameState.isXsTurn, isXMark, 'Verify turn does not change')

        -- The actual cell owner can be any of { 1, 2, nil } as long as that's
        -- the value it held before calling placeMark.
        ensure(
            prevCellOwner,
            gameState.getCellOwner({ board, cell }),
            'Verify mark is not saved'
        )
    end
end

---One place to test undoMove without repeating code over and over
---@param board integer
---@param cell integer
local function testUndo(board, cell)
    local wasXsTurn = gameState.isXsTurn

    ensure(pcall(gameState.undoMove), true, 'Ensure undoMove call succeeds')

    ensure(gameState.isXsTurn, not wasXsTurn, 'Ensure undoMove updates turn')
    ensure(
        gameState.getCellOwner({ board or 1, cell or 1 }),
        nil,
        'Ensure undoMove properly removes the last placed mark'
    )
end

-- Some setup, after which board 1 will be taken by X
testMove(1, 2, true, true) -- X
testMove(2, 1, false, true) -- O
testMove(1, 3, true, true) -- X
testMove(3, 1, false, true) -- O
testMove(1, 1, true, true) -- X takes board 1

-- Now, board 1 is taken, so O should not be allowed to place marks on it.
for c = 1, 9 do
    testMove(1, c, false, false)
end

-- And it should be allowed to play on any other unoccupied cell
for c = 2, 9 do -- Boards 2 and 3 have their first cell occupied
    testMove(2, c, false, true)
    testUndo(2, c)
    testMove(3, c, false, true)
    testUndo(3, c)
end

for b = 4, 9 do
    for c = 1, 9 do
        testMove(b, c, false, true)
        testUndo(b, c)
    end
end

-- Now, board 2 will be taken by O
testMove(2, 3, false, true) -- O
testMove(3, 2, true, true) -- X
testMove(2, 2, false, true) -- O takes board 2

-- X should not be allowed to play on boards 1 or 2
for c = 1, 9 do
    testMove(1, c, true, false)
    testMove(2, c, true, false)
end

-- But cells 3-9 of board 3 should be fine
for c = 3, 9 do
    testMove(3, c, true, true)
    testUndo(3, c)
end

-- Same thing goes for the rest of the board
for b = 4, 9 do
    for c = 1, 9 do
        testMove(b, c, true, true)
        testUndo(b, c)
    end
end
