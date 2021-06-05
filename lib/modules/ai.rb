# frozen_string_literal: true

require_relative 'promotion_move'

# Contains logic for picking correct square as an AI
module AI
  def pick_square(board)
    sleep 0.15
    possible_squares = board.squares_taken_by(color)
    possible_squares.reject { |sqr| sqr.piece.legal_moves(board).empty? }.sample
  end

  def pick_move(legal_moves)
    sleep 0.15
    legal_moves.sample
  end

  def ai_move(board)
    board.display
    square = pick_square(board)
    legal_moves = square.piece.legal_moves(board)
    board.display(square, legal_moves)
    move = pick_move(legal_moves)
    if pawn_promotion?(square.piece, board, move)
      square.piece.promote(move, board, random_new_piece)
    else
      square.piece.move(move, board)
    end
  end

  def pawn_promotion?(piece, board, square)
    return unless piece.is_a?(Pawn)

    [piece.promotion_move(board, 1),
     piece.promotion_move(board, 0),
     piece.promotion_move(board, -1)].flatten.include?(square)
  end

  def random_new_piece
    PromotionMove::PROMOTION_PIECES.sample
  end
end
