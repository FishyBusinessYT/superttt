local BU = require('binUtils')

---@return GameState
return function()
    ---@class GameState
    ---@field xmarks integer[]
    ---@field omarks integer[]
    ---@field xwon integer
    ---@field owon integer
    ---@field isXsTurn boolean
    local self = {}

    self.xmarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.omarks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.xwon = 0
    self.owon = 0
    self.isXsTurn = true

    local moveHistory = {}

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

    ---Check who's won this board.
    ---@param board integer Must be any integer 1-9
    ---@return integer? owner 1 for X, 2 for O, nil for neither
    self.getBoardOwner = function(board)
        if BU.getBit(self.xwon, board) == 1 then
            return 1
        elseif BU.getBit(self.owon, board) == 1 then
            return 2
        end
    end

    ---Check who's taken this cell.
    ---@param cellPos [integer, integer]
    ---@return integer? owner 1 for X, 2 for O, nil for neither
    self.getCellOwner = function(cellPos)
        local board, cell = cellPos[1], cellPos[2]
        if BU.getBit(self.xmarks[board], cell) == 1 then
            return 1
        elseif BU.getBit(self.omarks[board], cell) == 1 then
            return 2
        end
    end

    ---Place a mark on the specified cell. The cell must be unoccupied and its
    ---board must not be taken for this move to be allowed.
    ---@param cellPos [integer, integer]
    self.placeMark = function(cellPos)
        local board, cell = cellPos[1], cellPos[2]
        assert(board > 0 and board <= 9)
        assert(cell > 0 and cell <= 9)

        if #moveHistory ~= 0 then -- Every move after the first needs validation
            local forcedBoard = moveHistory[#moveHistory][2]
            if self.getCellOwner(cellPos) then
                error('That cell is unoccupied')
            elseif self.getBoardOwner(board) then
                error('That board has already been won')
            elseif
                not self.getBoardOwner(forcedBoard) and board ~= forcedBoard
            then
                error('Must play inside board #' .. forcedBoard)
            end
        end

        if self.isXsTurn then
            --Place X mark
            self.xmarks[board] = BU.setBit(self.xmarks[board], cell, 1)
        else
            --Place O mark
            self.omarks[board] = BU.setBit(self.omarks[board], cell, 1)
        end

        self.isXsTurn = not self.isXsTurn
        table.insert(moveHistory, { board, cell })

        checkBoards()
    end

    ---Undo the last move made
    self.undoMove = function()
        if #moveHistory == 0 then error('No moves to undo') end

        local move = table.remove(moveHistory)
        local board, cell = move[1], move[2]

        if self.isXsTurn then -- The last mark was placed by O
            self.omarks[board] = BU.setBit(self.omarks[board], cell, 0)
        elseif not self.isXsTurn then -- The last mark was placed by X
            self.xmarks[board] = BU.setBit(self.xmarks[board], cell, 0)
        end

        self.isXsTurn = not self.isXsTurn

        checkBoards()
    end

    ---Get all valid moves from the current board position
    ---@return table moves List of valid moves
    self.getLegalMoves = function()
        local moves = {}

        local function addEmptyCells(board)
            for cell = 1, 9 do
                if not self.getCellOwner({ board, cell }) then
                    table.insert(moves, { board, cell })
                end
            end
        end

        local lastMove = moveHistory[#moveHistory]
        if lastMove and not self.getBoardOwner(lastMove[1]) then
            addEmptyCells(moveHistory[#moveHistory][2])
            return moves
        end

        for board = 1, 9 do
            if not self.getBoardOwner(board) then addEmptyCells(board) end
        end

        return moves
    end

    return self
end
