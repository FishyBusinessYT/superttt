package.path = './?/init.lua;' .. package.path

local board = require('ui.board')()
local bar = require('ui.bar')()

local gameState = require('engine.gameState')()
local player1 = nil -- Instantiate an AI
local player2 = nil -- Instantiate another AI

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
    if t == ' ' then
        if gameState.isXsTurn then
            local chosenCellPos = player1.getMove(self.gameState)
            gameState.placeMark(chosenCellPos)
        else
            local chosenCellPos = player2.getMove(self.gameState)
            gameState.placeMark(chosenCellPos)
        end
    end
end
