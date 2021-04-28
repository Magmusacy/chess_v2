module SquareAccessor
  def get_square(square_position)
    board.find { |square| square.position == square_position }
  end

  def get_relative_square(initial_square, x: 0, y: 0)
    relative_square = initial_square.position.clone
    relative_square[:x] += x
    relative_square[:y] += y
    get_square(relative_square)
  end

  def squares_taken_by(color)
    board.select { |sqr| !sqr.piece.is_a?(String) && sqr.piece.color == color }
  end
end