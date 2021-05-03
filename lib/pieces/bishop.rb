require_relative 'piece'
require_relative '../modules/shared_movement'

class Bishop < Piece
  include SharedMovement::BishopMovement

  def legal_moves(board)
    [diagonal_move(board, 1, 1), diagonal_move(board, 1, -1),
     diagonal_move(board, -1, 1), diagonal_move(board, -1, -1)].flatten
  end
end