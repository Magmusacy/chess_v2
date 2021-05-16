require_relative 'piece'
require_relative '../modules/shared_movement'

class Rook < Piece
  include SharedMovement::RookMovement

  def possible_moves(board)
    moves = [horizontal_move(board, 1), horizontal_move(board, -1),
             vertical_move(board, 1), vertical_move(board, -1)].flatten

    discard_related_squares(moves)
  end
end