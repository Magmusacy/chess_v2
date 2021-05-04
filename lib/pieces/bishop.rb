require_relative 'piece'
require_relative '../modules/shared_movement'

class Bishop < Piece
  include SharedMovement::BishopMovement

  def legal_moves(board)
    moves = [diagonal_move(board, 1, 1), diagonal_move(board, 1, -1),
             diagonal_move(board, -1, 1), diagonal_move(board, -1, -1)].flatten
    discard_illegal_moves(board, opponent_color, moves)
  end
end