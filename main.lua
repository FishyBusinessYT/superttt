package.path = './?/init.lua;' .. package.path

local board = require('ui.board')()
local bar = require('ui.bar')()
local gameState = require('engine.gameState')()

WINHEIGHT = 1200
WINWIDTH = 1920

function love.load()
    love.window.setMode(WINWIDTH, WINHEIGHT, { fullscreen = true })
    love.graphics.setBackgroundColor(1, 0.9, 1)
end

function love.draw()
    bar.draw(gameState.isXsTurn, gameState.winner)
    board.draw(gameState)
end

function love.textinput(t)
    if t == ' ' then gameState.placeMark({ 7, 9 }) end
end
