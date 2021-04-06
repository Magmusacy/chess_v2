# frozen_string_literal: true

require_relative 'piece'

# Contains logic for Pawn movement
class Pawn < Piece
  def legal_moves(board)
    y_axis_moves(board, y_axis_shift)
    diagonal_moves(board, y_axis_shift)
    en_passant(board, y_axis_shift)
  end

  def y_axis_moves(board, y_shift)
    ary = []
    new_pos = clone_position(y: y_shift)
    ary << board.get_square(new_pos) unless board.square_taken?(new_pos)
    if [2, 7].include?(location.position[:y]) && !ary.empty?
      new_pos[:y] += 1
      ary << board.get_square(new_pos) unless board.square_taken?(new_pos)
    end
    ary
  end

  def diagonal_moves(board, y_shift); end

  def en_passant(board, y_shift); end

  def y_axis_shift
    color == :white ? 1 : -1
  end
end
