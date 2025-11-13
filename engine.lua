local M = {}

---Get all valid moves from the current board position
---@param gs GameState 1-9
---@return table moves List of valid moves
M.getLegalMoves = function(gs)
    local moves = {}

    local function addEmptyCells(board)
        for cell = 1, 9 do
            if not gs.getCellOwner(board, cell) then
                table.insert(moves, { board, cell })
            end
        end
    end

    if gs.lastPickedCell and not gs.getBoardOwner(gs.lastPickedCell) then
        addEmptyCells(gs.lastPickedCell)
        return moves
    end

    for board = 1, 9 do
        if not gs.getBoardOwner(board) then addEmptyCells(board) end
    end

    return moves
end

return M
