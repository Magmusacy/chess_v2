# frozen_string_literal: true

# Module responsible for logic behind chess' 3 special rules (check, checkmate, stalemate)
module SpecialConditions
  def in_check?(chess_board)
    enemy_pieces = chess_board.squares_taken_by(opponent_color).map(&:piece)
    king_square = chess_board.get_king_square(color)
    enemy_pieces.any? { |piece| piece.legal_moves(chess_board).include?(king_square) }
  end

  def in_checkmate?(chess_board, check_condition = false)
    return true if check_condition && no_legal_moves?(chess_board)

    false
  end

  def in_stalemate?(chess_board, check_condition = false)
    return true if !check_condition && no_legal_moves?(chess_board) || only_kings_left?(chess_board)

    false
  end

  private

  def only_kings_left?(chess_board)
    white_pieces = chess_board.squares_taken_by(:white).map(&:piece)
    black_pieces = chess_board.squares_taken_by(:black).map(&:piece)
    true if white_pieces.all? { |piece| piece.is_a?(King) } && black_pieces.all? { |piece| piece.is_a?(King) }
  end

  def no_legal_moves?(chess_board)
    checked_pieces = chess_board.squares_taken_by(color).map(&:piece)
    checked_pieces.all? { |piece| piece.legal_moves(chess_board).empty? }
  end

  def opponent_color
    color == :white ? :black : :white
  end
end
