local M = {}

---Get all valid moves from the current board position
---@param gs GameState 1-9
---@return table moves List of valid moves
M.getLegalMoves = function(gs)
    local moves = {}

    local function addEmptyCells(board)
        for cell = 1, 9 do
            if gs.getCellOwner(board, cell) then goto nextCell end
            table.insert(moves, { board, cell })

            ::nextCell::
        end
    end

    if gs.lastPickedCell and not gs.getBoardOwner(gs.lastPickedCell) then
        addEmptyCells(gs.lastPickedCell)
        return moves
    end

    for board = 1, 9 do
        if gs.getBoardOwner(board) then goto nextBoard end
        addEmptyCells(board)

        ::nextBoard::
    end

    return moves
end

return M
