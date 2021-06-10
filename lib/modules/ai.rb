# frozen_string_literal: true

require_relative 'promotion_move'

# Contains logic for picking correct square as an AI
module AI
  def pick_square(board)
    possible_squares = board.squares_taken_by(color)
    possible_squares.reject { |sqr| sqr.piece.legal_moves(board).empty? }.sample
  end

  def pick_move(legal_moves)
    legal_moves.sample
  end

  def ai_move(board)
    square = ai_pick(board)
    move = ai_pick(board, square)
    piece = square.piece
    if pawn_promotion?(piece, board, move)
      piece.promote(move, board, random_new_piece)
    else
      piece.move(move, board)
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

  private

  def ai_pick(board, chosen_square = :deafult)
    if chosen_square == :deafult
      board.display(color, type)
      pick_square(board)
    else
      legal_moves = chosen_square.piece.legal_moves(board)
      board.display(color, type, chosen_square, legal_moves)
      pick_move(legal_moves)
    end
  end
end
