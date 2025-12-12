---@return Bar
return function()
    ---@class Bar
    local self = {}
    local font = love.graphics.newFont(30) -- 30 is just the font size

    local text = {
        xTurn = love.graphics.newText(font, 'Player X\'s turn'),
        oTurn = love.graphics.newText(font, 'Player O\'s turn'),
        xWinner = love.graphics.newText(font, 'Player X has won!'),
        oWinner = love.graphics.newText(font, 'Player O has won!'),
    }
    local color = {
        text = { 0, 0, 0 },
        xTurn = { 1, 0.5, 0.5 },
        oTurn = { 0.5, 0.5, 1 },
        xWinner = { 1, 0.5, 0.5 },
        oWinner = { 0.5, 0.5, 1 },
    }

    self.draw = function(isXsTurn, winner)
        local barText
        local barColor
        if winner then
            barText = winner == 1 and text.xWinner or text.oWinner
            barColor = winner == 1 and color.xWinner or color.oWinner
        else
            barText = isXsTurn and text.xTurn or text.oTurn
            barColor = isXsTurn and color.xTurn or color.oTurn
        end

        local textX = (WINWIDTH - barText:getWidth()) / 2
        local textY = WINHEIGHT - (100 - barText:getHeight())

        love.graphics.setColor(barColor)
        love.graphics.rectangle('fill', 0, 1100, WINWIDTH, WINHEIGHT)

        love.graphics.setColor(color.text)
        love.graphics.draw(barText, textX, textY)
    end
    return self
end
