# frozen_string_literal: true

# DiscardIllegalMoves contains logic for discarding moves that either result in King being checked or taking our piece
module DiscardIllegalMoves
  # The piece that Pawn will turn into is negligible here,
  # rook is just here so that the prompt won't pop up during legal move evaluation
  PROMOTE_PIECE = :rook

  def discard_illegal_moves(chess_board, possible_moves)
    possible_moves.reject do |move_square|
      clone_board, clone_piece, clone_square = clone_objects(chess_board, move_square)
      if pawn_promotion?(chess_board, move_square)
        clone_piece.promote(clone_square, clone_board, PROMOTE_PIECE)
      else
        clone_piece.move(clone_square, clone_board)
      end
      illegal?(clone_board)
    end
  end

  def discard_related_squares(squares)
    squares.reject { |sqr| sqr.taken? && sqr.piece.color == color }
  end

  def illegal?(board_clone, untouchable_square = nil)
    enemy_pieces = board_clone.squares_taken_by(opponent_color).map(&:piece)
    untouchable_square = board_clone.get_king_square(@color) if untouchable_square.nil?
    enemy_pieces.any? do |piece|
      move = piece.is_a?(King) ? piece.basic_moves(board_clone) : piece.possible_moves(board_clone)
      move.include?(untouchable_square)
    end
  end

  def clone_objects(real_board, real_square)
    clone_board = Marshal.load(Marshal.dump(real_board))
    piece_position = location.position
    clone_piece = clone_board.get_square(piece_position).piece
    clone_square = clone_board.get_square(real_square.position)
    [clone_board, clone_piece, clone_square]
  end

  private

  def pawn_promotion?(chess_board, square)
    return unless is_a?(Pawn)

    [promotion_move(chess_board, 1),
     promotion_move(chess_board, 0),
     promotion_move(chess_board, -1)].flatten.include?(square)
  end

  def opponent_color
    color == :white ? :black : :white
  end
end
