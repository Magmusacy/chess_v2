# frozen_string_literal: true

require_relative 'piece'
require_relative '../modules/shared_movement'

# Contains logic for Queen movement
class Queen < Piece
  include SharedMovement::RookMovement
  include SharedMovement::BishopMovement

  def possible_moves(board)
    moves = [horizontal_move(board, 1), horizontal_move(board, -1),
             vertical_move(board, 1), vertical_move(board, -1),
             diagonal_move(board, 1, 1), diagonal_move(board, 1, -1),
             diagonal_move(board, -1, 1), diagonal_move(board, -1, -1)].flatten

    discard_related_squares(moves)
  end
end
