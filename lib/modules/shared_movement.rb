# frozen_string_literal: true

# SharedMovement contains Rook movement logic as well as Bishop movement logic to be used in their classes and in Queen
module SharedMovement
  # RookMovement contains logic for Rook movement
  module RookMovement
    include SharedMovement

    def horizontal_move(board, x_shift, ary = [])
      move_square = board.get_relative_square(location, x: x_shift)
      return [] if move_square.nil?

      ary << move_square
      return ary if move_square.taken?

      horizontal_move(board, next_value(x_shift), ary)
      ary
    end

    def vertical_move(board, y_shift, ary = [])
      move_square = board.get_relative_square(location, y: y_shift)
      return [] if move_square.nil?

      ary << move_square
      return ary if move_square.taken?

      vertical_move(board, next_value(y_shift), ary)
      ary
    end
  end

  # BishopMovement contains logic for Bishop movement
  module BishopMovement
    include SharedMovement

    def diagonal_move(board, x_shift, y_shift, ary = [])
      move_square = board.get_relative_square(location, x: x_shift, y: y_shift)
      return [] if move_square.nil?

      ary << move_square
      return ary if move_square.taken?

      diagonal_move(board, next_value(x_shift), next_value(y_shift), ary)
      ary
    end
  end

  private

  def next_value(value)
    value.negative? ? value - 1 : value + 1
  end
end
