local board = require('ui.board')()
local GS = require('engine.gameState')
package.path = './?/init.lua;' .. package.path

WINHEIGHT = 900
WINWIDTH = 900

local gameState = GS()

function love.load()
    love.window.setMode(WINHEIGHT, WINWIDTH, { fullscreen = false })
    love.graphics.setBackgroundColor(1, 1, 1)

    --gameState.placeMark({ 1, 2 })
    --gameState.placeMark({ 2, 1 })
    --gameState.placeMark({ 1, 3 })
    --gameState.placeMark({ 3, 1 })
    --gameState.placeMark({ 1, 1 })

    gameState.placeMark({5, 1})
    gameState.placeMark({1, 5})
    gameState.placeMark({5, 2})
    gameState.placeMark({2, 5})
    gameState.placeMark({5, 3})

    gameState.placeMark({3, 8})
    gameState.placeMark({8, 1})
    gameState.placeMark({1, 9})
    gameState.placeMark({9, 1})
    gameState.placeMark({1, 1})
end

function love.draw() board.draw(gameState) end

function love.textinput(t)
    if t == ' ' then gameState.placeMark({ 9, 1 }) end
end
