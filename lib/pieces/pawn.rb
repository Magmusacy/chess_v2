# frozen_string_literal: true

require_relative 'piece'
require_relative '../modules/en_passant_move'

# Contains logic for Pawn movement
class Pawn < Piece
  include EnPassantMove
  def legal_moves(board)
    ary = []
    ary << y_axis_move(board)
    ary << diagonal_move(board)
    ary << en_passant_move(board)
    ary.compact
  end

  def y_axis_move(board, y_shift = y_axis_shift)
    ary = []
    new_pos = find_relative_square(board, y: y_shift)
    ary << new_pos unless new_pos.taken?
    if [2, 7].include?(location.position[:y]) && !ary.empty?
      # refactor
      new_pos = find_relative_square(board, y: y_shift*2)
      ary << new_pos unless new_pos.taken?
    end

    ary
  end

  def diagonal_move(board, y_shift = y_axis_shift)
    ary = []
    # refactor
    new_positions = [find_relative_square(board, x: -1, y: y_shift), find_relative_square(board, x: 1, y: y_shift)].compact
    new_positions.length.times do |i|
      next unless new_positions[i].taken?

      ary << new_positions[i] unless new_positions[i].piece.color == color
    end
    ary
  end

  def y_axis_shift
    color == :white ? 1 : -1
  end
end
