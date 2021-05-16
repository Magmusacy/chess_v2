# frozen_string_literal: true

require_relative 'piece'
require_relative '../modules/en_passant_move'
require_relative '../modules/promotion_move'

# Contains logic for Pawn movement
class Pawn < Piece
  include EnPassantMove
  include PromotionMove

  def possible_moves(board)
    moves = [vertical_move(board), diagonal_move(board, 1), diagonal_move(board, -1),
             en_passant_move(board, 1), en_passant_move(board, -1),
             promotion_move(board, 0), promotion_move(board, 1),
             promotion_move(board, -1)].flatten

    discard_related_squares(moves)
  end

  def vertical_move(board)
    moves = [board.get_relative_square(location, y: y_shift)]
    return [] if moves.first.taken?
    moves << double_vertical_move(board) if first_move?
    moves.compact
  end

  def diagonal_move(board, x)
    moves = [board.get_relative_square(location, x: x, y: y_shift)].compact
    return [] if moves.empty? || !moves.first.taken?
    #  return [] if moves.nil? || !moves.taken? # takie cos
    moves
  end

  def move(chosen_square, board)
    possible_promotion = [promotion_move(board, 1), promotion_move(board, 0), promotion_move(board, -1)].flatten
    unless possible_promotion.include?(chosen_square)
      possible_en_passant = [en_passant_move(board, 1), en_passant_move(board, -1)].flatten
      take_enemy_pawn(chosen_square, board) if possible_en_passant.include?(chosen_square)

      super
    else
      promote(promotion_input, chosen_square, board)
    end
  end

  private

  def double_vertical_move(board)
    square = board.get_relative_square(location, y: y_shift * 2)
    return square unless square.taken?
  end

  def first_move?
    y = location.position[:y]
    return true if color == :white && y == 2
    return true if color == :black && y == 7
  end

  def y_shift
    color == :white ? 1 : -1
  end
end
