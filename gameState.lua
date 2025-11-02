local BU = require('binUtils')

return function()
    local self = {}

    self.xmarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.omarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.xwon = 0
    self.owon = 0

    ---Check who's won this board
    ---@param board integer 1-9
    ---@return integer? 1 for X, 2 for O, nil for neither
    self.isBoardTaken = function(board)
        if BU.getBit(self.xwon, board) == 1 then
            return 1
        elseif BU.getBit(self.owon, board) == 1 then
            return 2
        end
    end

    ---Check who's taken this cell
    ---@param board integer 1-9
    ---@param cell integer 1-9
    ---@return integer? 1 for X, 2 for O, nil for neither
    self.isCellTaken = function(board, cell)
        if BU.getBit(self.xmarks[board], cell) == 1 then
            return 1
        elseif BU.getBit(self.omarks[board], cell) == 1 then
            return 2
        end
    end

    return self
end
