---@return Board
return function()
    ---@class Board
    ---@field cell_size number Size of each cell
    local self = {}

    self.cell_size = 100

    ---Takes an X and Y value and returns the corresponding CellPos
    ---@param x integer
    ---@param y integer
    ---@return [integer, integer]
    local function XYtoCellPos(x, y)
        local b = math.ceil(x / 3) + 3 * (math.ceil(y / 3) - 1)
        local c = ((x - 1) % 3) + 1 + 3 * ((y - 1) % 3)
        return { b, c }
    end

    local function drawXMark(x, y)
        love.graphics.setColor(1, 0, 0)

        love.graphics.line(
            x * self.cell_size,
            y * self.cell_size,
            (x + 1) * self.cell_size,
            (y + 1) * self.cell_size
        )
        love.graphics.line(
            (x + 1) * self.cell_size,
            y * self.cell_size,
            x * self.cell_size,
            (y + 1) * self.cell_size
        )
    end

    local function drawOMark(x, y)
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle(
            'line',
            x * self.cell_size + self.cell_size / 2,
            y * self.cell_size + self.cell_size / 2,
            self.cell_size / 2,
            12
        )
    end

    ---Draw this board to the screen
    ---@param gameState GameState
    self.draw = function(gameState)
        for y = 0, 8 do
            love.graphics.setColor(0, 0, 0)
            love.graphics.line(
                0,
                y * self.cell_size,
                9 * self.cell_size,
                y * self.cell_size
            )
            love.graphics.line(
                y * self.cell_size,
                0,
                y * self.cell_size,
                9 * self.cell_size
            )

            for x = 0, 8 do
                local owner = gameState.getCellOwner(XYtoCellPos(x + 1, y + 1))

                if owner == 1 then
                    drawXMark(x, y)
                elseif owner == 2 then
                    drawOMark(x, y)
                end
            end
        end
    end
    return self
end
