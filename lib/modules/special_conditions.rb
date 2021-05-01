# Module responsible for logic behind chess' 3 special rules (check, checkmate, stalemate)
module SpecialConditions
  def check?(chess_board, checked_color, opponent_color)
    enemy_pieces = chess_board.squares_taken_by(opponent_color).map(&:piece)
    king_square = chess_board.get_king_square(checked_color)
    enemy_pieces.any? { |piece| piece.legal_moves(chess_board).include?(king_square) }
  end

  def checkmate?(chess_board, checked_color, opponent_color)
    return true if check?(chess_board, checked_color, opponent_color) && no_legal_moves?(checked_color)

    false
  end

  def stalemate?(chess_board, stalemated_color, opponent_color)
    return true if !check?(chess_board, stalemated_color, opponent_color) && no_legal_moves?(stalemated_color)

    false
  end

  private

  def no_legal_moves?(color)
    checked_pieces = chess_board.squares_taken_by(color).map(&:piece)
    checked_pieces.all? { |piece| piece.legal_moves(chess_board).empty? }
  end
end