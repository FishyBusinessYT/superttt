local board = require('ui.board')()
local GS = require('engine.gameState')
package.path = './?/init.lua;' .. package.path

WINHEIGHT = 900
WINWIDTH = 900

local gameState = GS()

function love.load()
    love.window.setMode(WINHEIGHT, WINWIDTH, { fullscreen = false })
    love.graphics.setBackgroundColor(1, 1, 1)

    gameState.placeMark({ 1, 2 })
    gameState.placeMark({ 2, 7 })
    gameState.placeMark({ 7, 9 })
end

function love.draw() board.draw(gameState) end

function love.textinput(t)
    if t == ' ' then gameState.placeMark({ 9, 1 }) end
end
