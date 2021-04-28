# frozen_string_literal: true

require_relative 'modules/square_accessor'

# Creating board that keeps track of individual squares
class Board
  include SquareAccessor
  attr_accessor :board

  def initialize(board = nil)
    @board = board
  end

  def setup_board(white_pieces, black_pieces)
    @board = create_square_array(Array(1..8).product(Array(1..8)))
    assign_pieces(white_pieces)
    assign_pieces(black_pieces)
  end

  def create_square(position)
    Square.new(position)
  end

  def create_square_array(array)
    array.map { |pos| create_square(pos) }
  end

  def assign_pieces(pieces)
    pieces.each do |piece|
      square = get_square(piece.position)
      square.update_piece(piece)
      piece.update_position(square)
    end
  end

  def square_taken?(square_position)
    !get_square(square_position).piece.is_a?(String)
  end
end
