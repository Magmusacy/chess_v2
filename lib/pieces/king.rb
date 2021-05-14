require_relative 'piece'

class King < Piece
  def possible_moves(board)
    moves = [horizontal_move(board, 1), horizontal_move(board, -1),
             vertical_move(board, 1), vertical_move(board, -1),
             diagonal_move(board, 1, 1), diagonal_move(board, 1, -1),
             diagonal_move(board, -1, 1), diagonal_move(board, -1, -1)].flatten

    reject_related_squares(moves)
  end

  def horizontal_move(board, x)
    move_square = [board.get_relative_square(location, x: x)].compact
  end

  def vertical_move(board, y)
    move_square = [board.get_relative_square(location, y: y)].compact
  end

  def diagonal_move(board, x, y)
    move_square = [board.get_relative_square(location, x: x, y: y)].compact
  end
end