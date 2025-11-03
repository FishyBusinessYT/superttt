local BU = require('binUtils')

---@return GameState
return function()
    ---@class GameState
    ---@field xmarks integer[]
    ---@field omarks integer[]
    ---@field xwon integer
    ---@field owon integer
    ---@field isXsTurn boolean
    ---@field lastPickedCell integer
    ---@field getBoardOwner function(board: integer): integer?
    ---@field getCellOwner function(board: integer, cell: integer): integer?
    local self = {}

    self.xmarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.omarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.xwon = 0
    self.owon = 0
    self.isXsTurn = true
    self.lastPickedCell = nil

    ---Check who's won this board
    ---@param board integer 1-9
    ---@return integer? 1 for X, 2 for O, nil for neither
    self.getBoardOwner = function(board)
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
    self.getCellOwner = function(board, cell)
        if
            BU.getBit(self.xmarks[board], cell) == 1
            --or BU.getBit(self.xwon, board) == 1
        then
            return 1
        elseif
            BU.getBit(self.omarks[board], cell) == 1
            --or BU.getBit(self.owon, board) == 1
        then
            return 2
        end
    end

    ---Place a mark on the specified cell
    ---@param board integer
    ---@param cell integer
    self.markCell = function(board, cell)
        if self.getCellOwner(board, cell) or self.getBoardOwner(board) then
            error('Illegal move made', 2)
        end

        if self.isXsTurn then --Place X mark
            self.xmarks[board] = BU.setBit(self.xmarks[board], cell, 1)
        else --Place O mark
            self.omarks[board] = BU.setBit(self.omarks[board], cell, 1)
        end

        self.checkBoards()
    end

    ---Remove the mark from the specified cell
    ---@param board integer
    ---@param cell integer
    self.removeMark = function(board, cell)
        local owner = self.getCellOwner(board, cell)
        if not owner then
            error('Tried to remove nonexistent mark', 2)
        elseif owner == 1 then -- Remove X mark
            self.xmarks[board] = BU.setBit(self.xmarks[board], cell, 0)
        elseif owner == 2 then -- Remove O mark
            self.omarks[board] = BU.setBit(self.omarks[board], cell, 0)
        end

        self.checkBoards()
    end

    return self
end
