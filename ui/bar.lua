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
        bar = { 0.6, 0.7, 0.8 },
    }

    self.draw = function(isXsTurn, winner)
        love.graphics.setColor(color.bar)
        love.graphics.rectangle('fill', 0, 1100, WINWIDTH, WINHEIGHT)

        love.graphics.setColor(color.text)
        local currentText
        if winner then
            currentText = winner == 1 and text.xWinner or text.oWinner
        else
            currentText = isXsTurn and text.xTurn or text.oTurn
        end

        local textX = (WINWIDTH - currentText:getWidth()) / 2
        local textY = WINHEIGHT - (100 - currentText:getHeight())
        love.graphics.draw(currentText, textX, textY)
    end
    return self
end
