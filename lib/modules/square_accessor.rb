# rubocop:disable Naming/MethodParameterName
# frozen_string_literal: true

require_relative '../pieces/king'

# Contains logic for accessing different squares from @board
module SquareAccessor
  def get_square(square_position)
    @board.find { |square| square.position == square_position }
  end

  def get_relative_square(initial_square, x: 0, y: 0)
    relative_square = initial_square.position.clone
    relative_square[:x] += x
    relative_square[:y] += y
    get_square(relative_square)
  end

  def squares_taken_by(color)
    @board.select { |sqr| sqr.taken? && sqr.piece.color == color }
  end

  def get_king_square(color)
    squares_taken_by(color).find { |square| square.piece.is_a?(King) }
  end
end
# rubocop:enable Naming/MethodParameterName
