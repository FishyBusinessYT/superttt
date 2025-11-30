--- This test depends on no other test
print('Testing the GameState\'s initial state and getter methods')

local gameState = require('gameState')()
local ensure = require('test.ensure')

-- X should be the first player to play
ensure(gameState.isXsTurn, true, 'X goes first')

-- Neither player should have won any board
for b = 1, 9 do
    if gameState.getBoardOwner(b) ~= nil then
        error('Board number ' .. b .. ' is taken!')
    end

    -- Or placed any marks, for that matter
    for c = 1, 9 do
        if gameState.getCellOwner({ b, c }) then
            error('Cell b' .. b .. 'c' .. c .. ' is taken!')
        end
    end
end
