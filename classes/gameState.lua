local BU = require('binUtils')

---@return GameState
return function()
    ---@class GameState
    ---@field xmarks integer[]
    ---@field omarks integer[]
    ---@field xwon integer
    ---@field owon integer
    ---@field isXsTurn boolean
    ---@field lastPickedCell integer Isn't this also stored in moveHistory now?
    ---@field moveHistory table<integer, integer>[]
    ---
    ---@field getBoardOwner function(board: integer): integer?
    ---@field getCellOwner function(board: integer, cell: integer): integer?
    ---@field placeMark function(board: integer, cell: integer): nil
    ---@field undoMove function(): nil
    ---@field checkBoards function()
    local self = {}

    self.xmarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.omarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.xwon = 0
    self.owon = 0
    self.isXsTurn = true
    self.lastPickedCell = nil
    self.moveHistory = {}

    local checkBoards = function()
        self.owon = 0
        self.xwon = 0

        -- stylua: ignore start
        local masks = {
            292, 146, 73, --Columns
            448, 56, 7, --Rows
            273, 84, --Diagonals
        }
        -- stylua: ignore end

        for idx = 1, 9 do
            for _, mask in ipairs(masks) do
                if self.omarks[idx] & mask == mask then
                    self.owon = BU.setBit(self.owon, idx, 1)
                    break
                elseif self.xmarks[idx] & mask == mask then
                    self.xwon = BU.setBit(self.xwon, idx, 1)
                    break
                end
            end
        end

        assert(
            self.owon & self.xwon == 0,
            'The same board has somehow been won by both players'
        )
    end

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
    self.placeMark = function(board, cell)
        if self.getCellOwner(board, cell) or self.getBoardOwner(board) then
            error('Illegal move made', 2)
        end

        if self.isXsTurn then --Place X mark
            self.xmarks[board] = BU.setBit(self.xmarks[board], cell, 1)
        else --Place O mark
            self.omarks[board] = BU.setBit(self.omarks[board], cell, 1)
        end

        self.isXsTurn = not self.isXsTurn
        self.lastPickedCell = cell

        checkBoards()
    end

    ---Restore game state to what it was before the last move was played
    self.undoMove = function()
        if #self.moveHistory == 0 then error('No moves to undo', 2) end

        local move = table.remove(self.moveHistory)
        local board, cell = move[1], move[2]
        local owner = self.getCellOwner(board, cell)

        if owner == 1 then -- Remove X mark
            self.xmarks[board] = BU.setBit(self.xmarks[board], cell, 0)
        elseif owner == 2 then -- Remove O mark
            self.omarks[board] = BU.setBit(self.omarks[board], cell, 0)
        end

        self.lastPickedCell = self.moveHistory[#self.moveHistory][2]
        checkBoards()
    end

    ---Get all valid moves from the current board position
    ---@return table moves List of valid moves
    self.getLegalMoves = function()
        local moves = {}

        local function addEmptyCells(board)
            for cell = 1, 9 do
                if not self.getCellOwner(board, cell) then
                    table.insert(moves, { board, cell })
                end
            end
        end

        if
            self.lastPickedCell and not self.getBoardOwner(self.lastPickedCell)
        then
            addEmptyCells(self.lastPickedCell)
            return moves
        end

        for board = 1, 9 do
            if not self.getBoardOwner(board) then addEmptyCells(board) end
        end

        return moves
    end

    return self
end
