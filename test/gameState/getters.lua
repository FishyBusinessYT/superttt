print('Testing GameState\'s getter methods')

local gameState = require('test.utils').GS()
local ensure = require('test.utils').ensure

-- Ensure these functions can take b and c values from 1-9
for b = 1, 9 do
    for c = 1, 9 do
        ensure(
            pcall(gameState.getCellOwner, { b, c }),
            true,
            'GetCellOwner accepts all 81 cell coordinates'
        )
    end
    ensure(
        pcall(gameState.getBoardOwner, b),
        true,
        'GetBoardOwner accepts all 9 boards'
    )
end

-- And that they raise exceptions for numbers outside of that range
ensure(
    pcall(gameState.getCellOwner, { 0, 0 }),
    false,
    'GetCellOwner raises an exception for out-of-range values'
)
ensure(
    pcall(gameState.getCellOwner, { 10, 0 }),
    false,
    'GetCellOwner raises an exception for out-of-range values'
)
ensure(
    pcall(gameState.getCellOwner, { 0, 10 }),
    false,
    'GetCellOwner raises an exception for out-of-range values'
)
ensure(
    pcall(gameState.getCellOwner, { 10, 10 }),
    false,
    'GetCellOwner raises an exception for out-of-range values'
)
ensure(
    pcall(gameState.getBoardOwner, 0),
    false,
    'GetBoardOwner raises an exception for out-of-range values'
)
ensure(
    pcall(gameState.getBoardOwner, 10),
    false,
    'GetBoardOwner raises an exception for out-of-range values'
)
