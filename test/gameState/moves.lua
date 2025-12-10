print('Testing GameState.placeMark and GameState.undoMove')

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

    if shouldWork then
        ensure(pcall(gameState.placeMark, { board, cell }), true, ensureMsg)
        ensure(gameState.isXsTurn, not isXMark, 'Verify turn change')

        ensure(
            gameState.getCellOwner({ board, cell }),
            isXMark and 1 or 2,
            'Verify mark is saved'
        )
        return
    end

    local isOutOfRange = board > 9 or cell > 9 or board < 1 or cell < 1
    local prevCellOwner

    if not isOutOfRange then
        prevCellOwner = gameState.getCellOwner({ board, cell })
    end

    ensure(pcall(gameState.placeMark, { board, cell }), false, ensureMsg)
    ensure(gameState.isXsTurn, isXMark, 'Verify turn does not change')

    if not isOutOfRange then
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

-- Only accept numbers between 1 and 9, including both end points
testMove(0, 0, true, false)
testMove(10, 0, true, false)
testMove(0, 10, true, false)
testMove(10, 10, true, false)

-- First mark (X's) can be placed anywhere
testMove(1, 1, true, true)

-- Undo and redo the first move
testUndo(1, 1)
testMove(1, 1, true, true)

-- placeMark should disallow playing on any board other than b1,
-- while preserving the game state
for i = 2, 9 do
    testMove(i, 1, false, false)
end

-- placeMark should disallow playing over an occupied cell as well
testMove(1, 1, false, false)

-- O should be able to place a mark on board 1
testMove(1, 2, false, true)

-- Undo the move and redo previous tests
testUndo(1, 2)

for i = 2, 9 do
    testMove(i, 1, false, false)
end
testMove(1, 1, false, false)
testMove(1, 2, false, true)
