# frozen_string_literal: true

# Contains logic for picking correct square as an AI
module AI
  def ai_pick_square(board)
    possible_squares = board.squares_taken_by(color)
    possible_squares.reject { |sqr| sqr.piece.legal_moves(board).empty? }.sample
  end

  # It might not be needed at all but we'll see
  def ai_pick_legal_move(legal_moves)
    legal_moves.sample
  end
end
