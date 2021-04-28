# frozen_string_literal: true

# Superclass of each piece, contains logic for movement and finding relative square
class Piece
  attr_reader :color, :icon, :location

  def initialize(location = nil, color = nil, icon = nil)
    @location = location
    @color = color
    @icon = icon
  end

  def to_s
    " #{icon} "
  end

  def legal_moves(board); end

  # this method is 100% not supposed to be there. It violates SRP
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
