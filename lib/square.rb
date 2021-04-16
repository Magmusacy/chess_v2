# frozen_string_literal: true

# this class is used to instantiate each square on the board
class Square
  attr_reader :position, :piece

  def initialize(position, piece = '   ')
    @position = { x: position.first, y: position.last }
    @piece = piece
  end

  def update_piece(new_piece = '   ')
    @piece = new_piece
  end

  def taken?
    !piece.is_a?(String)
  end
end
