require_relative 'special_conditions'

module DiscardIllegalMoves
  include SpecialConditions

  def discard_illegal_moves(chess_board, possible_moves)
    possible_moves.reject do |move_square|
      clone_board, clone_piece, clone_square = clone_objects(chess_board, self, move_square)
      clone_piece.move(clone_square, clone_board)
      illegal?(clone_board)
    end
  end

  def discard_related_squares(squares)
    squares.reject { |sqr| sqr.taken? && sqr.piece.color == color }
  end

  def illegal?(board_clone)
    enemy_pieces = board_clone.squares_taken_by(opponent_color).map(&:piece)
    king_square = board_clone.get_king_square(@color)
    enemy_pieces.any? { |piece| piece.possible_moves(board_clone).include?(king_square) }
  end

  def clone_objects(real_board, real_piece, real_square)
    clone_board = Marshal.load(Marshal.dump(real_board))
    piece_position = self.location.position
    clone_piece = clone_board.get_square(piece_position).piece
    clone_square = clone_board.get_square(real_square.position)
    [clone_board, clone_piece, clone_square]
  end

  private

  def opponent_color
    color == :white ? :black : :white
  end
end