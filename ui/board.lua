---@return Board
return function()
    ---@class Board
    local self = {}

    local cell_size = 100
    local xIcon = love.graphics.newImage('assets/xIcon.png')
    local oIcon = love.graphics.newImage('assets/oIcon.png')
    local startX, startY = (1920 - 900) / 2, 100

    ---Takes an X and Y value and returns the corresponding CellPos
    ---@param x integer
    ---@param y integer
    ---@return [integer, integer]
    local function XYtoCellPos(x, y)
        local b = math.ceil(x / 3) + 3 * (math.ceil(y / 3) - 1)
        local c = ((x - 1) % 3) + 1 + 3 * ((y - 1) % 3)
        return { b, c }
    end

    ---Takes a cellPos and returns the corresponding X and Y values
    ---@param cellPos [integer, integer]
    ---@return integer
    ---@return integer
    local function cellPosToXY(cellPos)
        local b = cellPos[1]
        local c = cellPos[2]

        local x = ((c - 1) % 3) + 3 * ((b - 1) % 3)
        local y = math.ceil(c / 3) + 3 * (math.ceil(b / 3) - 1) - 1
        return x, y
    end

    ---Draw the grid to the screen
    local function drawGrid()
        love.graphics.setColor(0, 0, 0)
        for i = 0, 9 do
            --Every third line is thicker to separate boards
            love.graphics.setLineWidth(i % 3 == 0 and 5 or 1)

            local hLine = {
                startX,
                startY + i * cell_size,
                startX + 9 * cell_size,
                startY + i * cell_size,
            }
            local vLine = {
                startX + i * cell_size,
                startY,
                startX + i * cell_size,
                startY + 9 * cell_size,
            }

            love.graphics.line(hLine)
            love.graphics.line(vLine)

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
                        startX + x * cell_size,
                        startY + y * cell_size
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
                    startX + x,
                    startY + y,
                    cell_size * 3,
                    cell_size * 3
                )
            end
        end
    end

    ---Highlight all cells where a mark can be placed by the next player
    ---@param gameState GameState
    local function highlightLegalMoves(gameState)
        local legalMoves = gameState.getLegalMoves()
        for _, move in ipairs(legalMoves) do
            local x, y = cellPosToXY(move)

            love.graphics.setColor({ 0, 0.5, 0, 0.5 })
            love.graphics.rectangle(
                'fill',
                startX + x * cell_size,
                startY + y * cell_size,
                cell_size,
                cell_size
            )
        end
    end

    ---Draw this board to the screen
    ---@param gameState GameState
    self.draw = function(gameState)

        drawGrid()
        drawMarks(gameState)
        highlightTaken(gameState)
        highlightLegalMoves(gameState)
    end

    return self
end
