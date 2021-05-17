require_relative 'pieces_creator'

module PromotionMove
  include PiecesCreator

  def promotion_move(board, x)
    return [] unless last_move?
    x.zero? ? vertical_promotion(board) : diagonal_promotion(board, x)
  end

  def promote(chosen_square, board, piece = nil)
    piece ||= promotion_input
    self_attributes = [location, color]
    new_piece = create_instance(piece, self_attributes)
    location.update_piece(new_piece)
    new_piece.move(chosen_square, board)
  end

  def promotion_input
    loop do
      show_pieces
      input = gets.to_i
      verified_piece = verify_piece(input - 1)
      return verified_piece unless verified_piece.nil?

      puts 'Wrong input!'
    end
  end

  def verify_piece(input)
    return unless [0, 1, 2, 3].include?(input)
    [:bishop, :knight, :queen, :rook][input]
  end

  private

  def vertical_promotion(board)
    move = [board.get_relative_square(location, y: y_shift)]
    return move unless move.first.taken?
    []
  end

  def diagonal_promotion(board, x)
    move = [board.get_relative_square(location, x: x, y: y_shift)]
    return [] unless move.first.taken?
    discard_related_squares(move)
  end

  def last_move?
    y = location.position[:y]
    return true if color == :black && y == 2
    return true if color == :white && y == 7
  end

  def show_pieces
    puts 'Type one of the below numbers to pick piece associated with it:'
    puts '1 - Bishop'
    puts '2 - Knight'
    puts '3 - Queen'
    puts '4 - Rook'
  end
end

