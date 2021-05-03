require_relative 'piece'
require_relative '../modules/shared_movement'

class Rook < Piece
  include SharedMovement::RookMovement

  def legal_moves(board)
    [horizontal_move(board, 1), horizontal_move(board, -1),
     vertical_move(board, 1), vertical_move(board, -1)].flatten
  end
end