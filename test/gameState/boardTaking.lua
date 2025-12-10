print('Testing board taking')

local gameState = require('test.utils').GS()
local ensure = require('test.utils').ensure

-- First let's have X take board 1
gameState.placeMark({ 1, 2 }) -- X
gameState.placeMark({ 2, 1 }) -- O
gameState.placeMark({ 1, 3 }) -- X
gameState.placeMark({ 3, 1 }) -- O
gameState.placeMark({ 1, 1 }) -- X takes board 1

ensure(
    gameState.getBoardOwner(1),
    1,
    'Board checking marks board 1 as taken by X'
)

-- Now let's see if it properly updates after the move is undone
gameState.undoMove()
ensure(
    gameState.getBoardOwner(1),
    nil,
    'Board checking updates correctly after undone moves (1)'
)

-- Undo the rest of the moves
for _ = 1, 4 do
    gameState.undoMove()
end

-- Now let's have O take board 2
gameState.placeMark({ 4, 2 }) -- X
gameState.placeMark({ 2, 1 }) -- O
gameState.placeMark({ 1, 2 }) -- X
gameState.placeMark({ 2, 3 }) -- O
gameState.placeMark({ 3, 2 }) -- X
gameState.placeMark({ 2, 2 }) -- O Takes board 2

ensure(
    gameState.getBoardOwner(2),
    2,
    'Board checking marks board 2 as taken by O'
)

-- Now let's see if it properly updates after the move is undone
gameState.undoMove()
ensure(
    gameState.getBoardOwner(1),
    nil,
    'Board checking updates correctly after undone moves (2)'
)
