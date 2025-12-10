---@return Board
return function()
    ---@class Board
    local self = {}

    local cell_size = 100
    local xIcon = love.graphics.newImage('assets/xIcon.png')
    local oIcon = love.graphics.newImage('assets/oIcon.png')

    ---Takes an X and Y value and returns the corresponding CellPos
    ---@param x integer
    ---@param y integer
    ---@return [integer, integer]
    local function XYtoCellPos(x, y)
        local b = math.ceil(x / 3) + 3 * (math.ceil(y / 3) - 1)
        local c = ((x - 1) % 3) + 1 + 3 * ((y - 1) % 3)
        return { b, c }
    end

    ---Draw this board to the screen
    ---@param gameState GameState
    self.draw = function(gameState)
        love.graphics.setColor(0, 0, 0)
        for y = 0, 8 do
            love.graphics.line(0, y * cell_size, 9 * cell_size, y * cell_size)
            love.graphics.line(y * cell_size, 0, y * cell_size, 9 * cell_size)

            for x = 0, 8 do
                local owner = gameState.getCellOwner(XYtoCellPos(x + 1, y + 1))

                if owner == 1 then
                    love.graphics.draw(xIcon, x * cell_size, y * cell_size)
                elseif owner == 2 then
                    love.graphics.draw(oIcon, x * cell_size, y * cell_size)
                end
            end
        end
    end

    return self
end
