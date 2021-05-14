# frozen_string_literal: true

require_relative '../modules/discard_illegal_moves'

# Superclass of each piece, contains logic for movement and finding relative square
class Piece
  attr_reader :color, :icon, :location
  include DiscardIllegalMoves

  def initialize(location = nil, color = nil, icon = nil)
    @location = location
    @color = color
  end

  def legal_moves(board)
    moves = possible_moves(board)
    discard_illegal_moves(board, opponent_color, moves)
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

  private

  def opponent_color
    color == :white ? :black : :white
  end

  def reject_related_squares(squares)
    squares.reject { |sqr| sqr.taken? && sqr.piece.color == color }
  end
end
