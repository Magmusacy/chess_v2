# frozen_string_literal: true

require_relative 'piece'
require_relative '../modules/castling'

# Contains logic for King movement
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

  def horizontal_move(board, x_shift)
    [board.get_relative_square(location, x: x_shift)].compact
  end

  def vertical_move(board, y_shift)
    [board.get_relative_square(location, y: y_shift)].compact
  end

  def diagonal_move(board, x_shift, y_shift)
    [board.get_relative_square(location, x: x_shift, y: y_shift)].compact
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
