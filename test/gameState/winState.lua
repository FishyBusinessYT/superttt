print('Testing GameState win state checkin')

local gameState = require('test.utils').GS()
local ensure = require('test.utils').ensure

gameState.placeMark({ 1, 3 }) -- X
gameState.placeMark({ 3, 1 }) -- O

gameState.placeMark({ 1, 6 }) -- X
gameState.placeMark({ 6, 1 }) -- O

gameState.placeMark({ 1, 9 }) -- X takes board 1
gameState.placeMark({ 9, 4 }) -- O

gameState.placeMark({ 4, 3 }) -- X
gameState.placeMark({ 3, 4 }) -- O

gameState.placeMark({ 4, 6 }) -- X
gameState.placeMark({ 6, 4 }) -- O

gameState.placeMark({ 4, 9 }) -- X takes board 2
gameState.placeMark({ 9, 7 }) -- O

gameState.placeMark({ 7, 3 }) -- X
gameState.placeMark({ 3, 7 }) -- O takes board 3

gameState.placeMark({ 7, 6 }) -- X
gameState.placeMark({ 6, 7 }) -- O takes board 6

gameState.placeMark({ 7, 9 }) -- X wins taking board 7

ensure(gameState.winner, 1, 'Win state check test 1')
gameState.undoMove() -- Undo winning move
ensure(gameState.winner, nil, 'Win state can be undone 1')

-- Some more setup to let O take the last board without having X win in the process
gameState.placeMark({ 7, 5 }) -- X
gameState.placeMark({ 5, 8 }) -- O
gameState.placeMark({ 8, 9 }) -- X

gameState.placeMark({ 9, 1 }) -- O wins taking board 9
ensure(gameState.winner, 2, 'Win state check test 2')
gameState.undoMove() -- Undo winning move again
ensure(gameState.winner, nil, 'Win state can be undone 2')
