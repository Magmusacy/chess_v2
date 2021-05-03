# This needs refactor btw
module SharedMovement
  def next_value(value)
    value < 0 ? value - 1 : value + 1
  end

  def reject_related_squares(squares_ary)
    squares_ary.reject { |sqr| sqr.taken? && sqr.piece.color == color }
  end

  module RookMovement
    include SharedMovement

    def horizontal_move(board, x, ary = [])
      move_square = [board.get_relative_square(location, x: x)].compact
      return [] if move_square.empty?
      ary << move_square
      horizontal_move(board, next_value(x), ary)
      reject_related_squares(ary.flatten)
    end

    def vertical_move(board, y, ary = [])
      move_square = [board.get_relative_square(location, y: y)].compact
      return [] if move_square.empty?
      ary << move_square
      vertical_move(board, next_value(y), ary)
      reject_related_squares(ary.flatten)
    end
  end

  module BishopMovement
    include SharedMovement

    def diagonal_move(board, x, y, ary = [])
      move_square = [board.get_relative_square(location, x: x, y: y)].compact
      return [] if move_square.empty?
      ary << move_square
      diagonal_move(board, next_value(x), next_value(y), ary)
      reject_related_squares(ary.flatten)
    end
  end
end