# frozen_string_literal: true

require_relative 'piece'
require_relative '../modules/shared_movement'

# Contains logic for Bishop movement
class Bishop < Piece
  include SharedMovement::BishopMovement
  def possible_moves(board)
    moves = [diagonal_move(board, 1, 1), diagonal_move(board, 1, -1),
             diagonal_move(board, -1, 1), diagonal_move(board, -1, -1)].flatten

    discard_related_squares(moves)
  end
end
