require_relative 'piece'
require_relative '../modules/castling'

class King < Piece
  include Castling

  def possible_moves(board)
    moves = [horizontal_move(board, 1), horizontal_move(board, -1),
             vertical_move(board, 1), vertical_move(board, -1),
             diagonal_move(board, 1, 1), diagonal_move(board, 1, -1),
             diagonal_move(board, -1, 1), diagonal_move(board, -1, -1),
            castling_move(board, 1), castling_move(board, -1)].flatten

    discard_related_squares(moves)
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

  def move(chosen_square, board)
    [1, -1].each do |direction|
      if chosen_square == castling_move(board, direction)
        rook_square = board.get_relative_square(location, x: direction)
        get_rook(board, direction).move(rook_square, board)
      end
    end

    super
  end
end