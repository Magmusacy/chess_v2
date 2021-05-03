# frozen_string_literal: true

require_relative '../modules/discard_illegal_moves'

# Superclass of each piece, contains logic for movement and finding relative square
class Piece
  attr_reader :color, :icon, :location
  include DiscardIllegalMoves

  def initialize(location = nil, color = nil, icon = nil)
    @location = location
    @color = color
    @icon = icon
  end

  def legal_moves(board); end

  # this method is 100% not supposed to be there. It violates SRP
  def reject_related_squares(squares)
    squares.reject { |sqr| sqr.taken? && sqr.piece.color == color }
  end

  def update_location(new_square)
    @location = new_square
  end

  def move(new_square, board)
    board.add_move([location, new_square])
    new_square.update_piece(self)
    location.update_piece
    update_location(new_square)
  end
end
