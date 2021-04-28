require_relative 'piece'

class King < Piece
  def legal_moves(board)
    moves = [horizontal_move(board, 1), horizontal_move(board, -1),
             vertical_move(board, 1), vertical_move(board, -1),
             diagonal_move(board, 1, 1), diagonal_move(board, 1, -1),
             diagonal_move(board, -1, 1), diagonal_move(board, -1, -1)].flatten
  end

  def horizontal_move(board, x)
    move_square = [board.get_relative_square(location, x: x)].compact
    reject_related_squares(move_square)
  end

  def vertical_move(board, y)
    move_square = [board.get_relative_square(location, y: y)].compact
    reject_related_squares(move_square)
  end

  def diagonal_move(board, x, y)
    move_square = [board.get_relative_square(location, x: x, y: y)]
    reject_related_squares(move_square)
  end
end