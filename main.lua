package.path = './?/init.lua;' .. package.path

local board = require('ui.board')()
local bar = require('ui.bar')()
local gameState = require('engine.gameState')()

WINHEIGHT = 1200
WINWIDTH = 1920

function love.load()
    love.window.setMode(WINWIDTH, WINHEIGHT, { fullscreen = true })
    love.graphics.setBackgroundColor(1, 0, 1)
end

function love.draw()
    board.draw(gameState)
    bar.draw(gameState.isXsTurn)
end

function love.textinput(t)
    if t == ' ' then gameState.placeMark({ 2, 1 }) end
end
