# frozen_string_literal: true

# Superclass of each piece, contains logic for movement and finding relative square
class Piece
  attr_reader :color, :icon, :location

  def initialize(location = nil, color = nil, icon = nil)
    @location = location
    @color = color
    @icon = icon
  end

  def legal_moves(board); end

  # this is violating single responsibility principle i think
  def find_relative_square(board, x: 0, y: 0, initial_square: location)
    new_position = initial_square.position.clone
    new_position[:x] += x
    new_position[:y] += y
    board.get_square(new_position)
  end

  def reject_related_squares(squares)
    squares.reject { |sqr| sqr.taken? && sqr.piece.color == color }
  end

  def move(square, board)
    board.add_new_move([location, square])
    square.update_piece(self)
    location.update_piece
    @location = square
  end
end
