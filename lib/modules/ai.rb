# frozen_string_literal: true

# Contains logic for picking correct square as an AI
module AI
  def ai_pick_square(board)
    possible_squares = board.select { |sqr| !sqr.piece.is_a?(String) && sqr.piece.color == color }
    possible_squares.reject! { |sqr| sqr.piece.legal_moves.empty? }
    possible_squares.sample
  end

  # It might not be needed at all but we'll see
  def ai_pick_legal_move(legal_moves)
    legal_moves.sample
  end
end
