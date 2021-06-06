# frozen_string_literal: true

require_relative 'pieces_creator'

# PromotionMove contains logic for promotion move for Pawn class
module PromotionMove
  include PiecesCreator
  PROMOTION_PIECES = %i[bishop knight queen rook].freeze

  def promotion_move(board, x_shift)
    return [] unless last_move?

    x_shift.zero? ? vertical_promotion(board) : diagonal_promotion(board, x_shift)
  end

  def promote(chosen_square, board, piece = nil)
    piece ||= piece_input
    self_attributes = [location, color]
    new_piece = create_instance(piece, self_attributes)
    location.update_piece(new_piece)
    new_piece.move(chosen_square, board)
  end

  def piece_input
    loop do
      verified_piece = verify_piece(input - 1)
      return verified_piece unless verified_piece.nil?

      puts 'Wrong input!'
    end
  end

  def verify_piece(input)
    return unless [0, 1, 2, 3].include?(input)

    PROMOTION_PIECES[input]
  end

  private

  def vertical_promotion(board)
    move = [board.get_relative_square(location, y: y_shift)].compact
    return [] if move.empty? || move.first.taken?

    move
  end

  def diagonal_promotion(board, x_shift)
    move = [board.get_relative_square(location, x: x_shift, y: y_shift)].compact
    return [] if move.empty? || !move.first.taken?

    discard_related_squares(move)
  end

  def last_move?
    y = location.position[:y]
    true if (color == :black && y == 2) || (color == :white && y == 7)
  end

  def input
    puts 'Type one of the below numbers to pick piece associated with it:'
    puts '1 - Bishop'
    puts '2 - Knight'
    puts '3 - Queen'
    puts '4 - Rook'
    gets.to_i
  end
end
