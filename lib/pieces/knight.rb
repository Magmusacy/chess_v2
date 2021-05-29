require_relative 'piece'

class Knight < Piece
  def possible_moves(board)
    moves = [knight_move(board, 2, 1), knight_move(board, -2, 1), knight_move(board, -2, -1),
             knight_move(board, 2, -1), knight_move(board, 1, 2), knight_move(board, 1, -2),
             knight_move(board, -1, 2), knight_move(board, -1, -2)].flatten

    discard_related_squares(moves)
  end

  def knight_move(board, x, y)
    board.get_relative_square(location, x: x, y: y) || []
  end
end