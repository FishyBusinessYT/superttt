local board = require('ui.board')()
local GS = require('engine.gameState')
package.path = './?/init.lua;' .. package.path

WINHEIGHT = 900
WINWIDTH = 900

local gameState = GS()
function love.load()
    love.window.setMode(WINHEIGHT, WINWIDTH, { fullscreen = false })
    gameState.placeMark({1, 2})
    gameState.placeMark({2, 1})
end


function love.draw()
    board.draw(gameState)
end
