module SharedMovement
  module RookMovement
    include SharedMovement

    def horizontal_move(board, x, ary = [])
      move_square = board.get_relative_square(location, x: x)
      return [] if move_square.nil?
      ary << move_square
      return if move_square.taken?
      horizontal_move(board, next_value(x), ary)
      ary.flatten
    end

    def vertical_move(board, y, ary = [])
      move_square = board.get_relative_square(location, y: y)
      return [] if move_square.nil?
      ary << move_square
      return if move_square.taken?
      vertical_move(board, next_value(y), ary)
      ary.flatten
    end
  end

  module BishopMovement
    include SharedMovement

    def diagonal_move(board, x, y, ary = [])
      move_square = board.get_relative_square(location, x: x, y: y)
      return [] if move_square.nil?
      ary << move_square
      return if move_square.taken?
      diagonal_move(board, next_value(x), next_value(y), ary)
      ary.flatten
    end
  end

  private

  def next_value(value)
    value < 0 ? value - 1 : value + 1
  end
end