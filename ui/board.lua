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

    ---Draw the grid to the screen
    local function drawGrid()
        for i = 1, 8 do
            --Every third line is thicker to separate boards
            love.graphics.setLineWidth(i % 3 == 0 and 5 or 1)

            --Draw a horizontal line
            love.graphics.line(0, i * cell_size, 9 * cell_size, i * cell_size)
            --Draw a vertical line
            love.graphics.line(i * cell_size, 0, i * cell_size, 9 * cell_size)
        end
    end

    ---Draw all placed marks to the grid
    ---@param gameState GameState
    local function drawMarks(gameState)
        for y = 0, 8 do
            for x = 0, 8 do
                local owner = gameState.getCellOwner(XYtoCellPos(x + 1, y + 1))

                if owner then
                    love.graphics.draw(
                        owner == 1 and xIcon or oIcon,
                        x * cell_size,
                        y * cell_size
                    )
                end
            end
        end
    end

    ---Highlight the boards that have been taken by either player
    ---@param gameState GameState
    local function highlightTaken(gameState)
        for i = 0, 8 do
            local owner = gameState.getBoardOwner(i + 1)
            local x = (i % 3) * cell_size * 3
            local y = math.floor(i / 3) * cell_size * 3

            if owner then
                love.graphics.setColor(
                    owner == 1 and { 0.5, 0, 0, 0.5 } or { 0, 0, 0.5, 0.5 }
                )
                love.graphics.rectangle(
                    'fill',
                    x,
                    y,
                    cell_size * 3,
                    cell_size * 3
                )
            end
        end
    end

    ---Draw this board to the screen
    ---@param gameState GameState
    self.draw = function(gameState)
        love.graphics.setColor(0, 0, 0)

        drawGrid()
        drawMarks(gameState)
        highlightTaken(gameState)
        --highlightLegalMoves(gameState)
    end

    return self
end
