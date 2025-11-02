local BU = require('binUtils')
local M = {}

M.newGameState = function()
    local self = {}

    self.xmarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.omarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.xwon = 0
    self.owon = 0

    ---Check who's won this board
    ---@param board integer 1-9
    ---@return integer? 1 for X, 2 for O, nil for neither
    self.isBoardTaken = function (board)
        if BU.getBit(M.xwon, board) == 1 then
            return 1
        elseif BU.getBit(M.owon, board) == 1 then
            return 2
        end
    end

    ---Check who's taken this cell
    ---@param board integer 1-9
    ---@param cell integer 1-9
    ---@return integer? 1 for X, 2 for O, nil for neither
    self.isCellTaken = function (board, cell)
        if BU.getBit(M.xmarks[board], cell) == 1 then
            return 1
        elseif BU.getBit(M.omarks[board], cell) == 1 then
            return 2
        end
    end

    ---Add the empty cells from `board` into `moves`
    ---@param board integer 1-9
    ---@param moves table The current list of valid moves
    local function addEmptyCells(board, moves)
        for cell = 1, 9 do
            if self.isCellTaken(board, cell) then goto nextCell end
            table.insert(moves, { board, cell })

            ::nextCell::
        end
    end

    ---Get all valid moves from the current board position
    ---@param lastPickedCell integer? 1-9
    ---@return table moves List of valid moves
    self.getLegalMoves = function(lastPickedCell)
        local moves = {}

        if lastPickedCell and ~self.isBoardTaken(lastPickedCell) then
            addEmptyCells(lastPickedCell, moves)
            return moves
        end

        for board = 1, 9 do
            if self.isBoardTaken(board) then goto nextBoard end
            addEmptyCells(board, moves)

            ::nextBoard::
        end

        return moves
    end

    return self
end

return M

