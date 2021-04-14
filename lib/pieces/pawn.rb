# frozen_string_literal: true

require_relative 'piece'
require_relative '../modules/en_passant_move'

# Contains logic for Pawn movement
class Pawn < Piece
  include EnPassantMove
  def legal_moves(board)
    y_axis_move(board)
    diagonal_move(board)
    en_passant_move(board)
  end

  def y_axis_move(board, y_shift = y_axis_shift)
    ary = []
    new_pos = clone_position(y: y_shift)
    ary << board.get_square(new_pos) unless board.square_taken?(new_pos)
    if [2, 7].include?(location.position[:y]) && !ary.empty?
      new_pos[:y] += y_shift
      ary << board.get_square(new_pos) unless board.square_taken?(new_pos)
    end
    ary
  end

  def diagonal_move(board, y_shift = y_axis_shift)
    ary = []
    new_positions = [clone_position(x: -1, y: y_shift), clone_position(x: 1, y: y_shift)]
    2.times do |i|
      next unless board.square_taken?(new_positions[i])

      new_sqr = board.get_square(new_positions[i])
      ary << new_sqr unless new_sqr.piece.color == color
    end
    ary
  end

  def y_axis_shift
    color == :white ? 1 : -1
  end
end
