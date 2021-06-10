# frozen_string_literal: true

require_relative 'piece'

# Contains logic for Knight movement
class Knight < Piece
  def possible_moves(board)
    moves = [knight_move(board, 2, 1), knight_move(board, -2, 1), knight_move(board, -2, -1),
             knight_move(board, 2, -1), knight_move(board, 1, 2), knight_move(board, 1, -2),
             knight_move(board, -1, 2), knight_move(board, -1, -2)].flatten

    discard_related_squares(moves)
  end

  def knight_move(board, x_shift, y_shift)
    board.get_relative_square(location, x: x_shift, y: y_shift) || []
  end
end
