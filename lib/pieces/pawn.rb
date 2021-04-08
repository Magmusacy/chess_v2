# frozen_string_literal: true

require_relative 'piece'

# Contains logic for Pawn movement
class Pawn < Piece
  def legal_moves(board)
    y_axis_move(board, y_axis_shift)
    diagonal_move(board, y_axis_shift)
    en_passant_move(board, y_axis_shift)
  end

  def y_axis_move(board, y_shift) # zmien w testach z moves na move w tych metodach jo
    ary = []
    new_pos = clone_position(y: y_shift)
    ary << board.get_square(new_pos) unless board.square_taken?(new_pos)
    if [2, 7].include?(location.position[:y]) && !ary.empty?
      new_pos[:y] += 1
      ary << board.get_square(new_pos) unless board.square_taken?(new_pos)
    end
    ary
  end

  def diagonal_move(board, y_shift)
    ary = []
    new_positions = [clone_position(x: -1, y: y_shift),
                     clone_position(x: 1, y: y_shift)]
    2.times do |i|
      if board.square_taken?(new_positions[i])
        new_sqr = board.get_square(new_positions[i])
        ary << new_sqr unless new_sqr.piece.color == color
      end
    end
    ary
  end

  def y_axis_shift
    color == :white ? 1 : -1
  end
end
