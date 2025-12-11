---@return Bar
return function()
    ---@class Bar
    local self = {}
    local font = love.graphics.newFont(30) -- 30 is just the font size

    local text = {
        xTurn = love.graphics.newText(font, 'Player X\'s turn'),
        oTurn = love.graphics.newText(font, 'Player O\'s turn'),
    }
    local color = {
        text = { 0, 0, 0 },
        bar = { 0.6, 0.7, 0.8 },
    }

    self.draw = function(isXsTurn)
        love.graphics.setColor(color.bar)
        love.graphics.rectangle('fill', 0, 900, 900, 100)

        love.graphics.setColor(color.text)
        love.graphics.draw(isXsTurn and text.xTurn or text.oTurn, 10, 935)
    end
    return self
end
