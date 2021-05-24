require_relative 'special_conditions'

module DiscardIllegalMoves
  include SpecialConditions

  def discard_illegal_moves(chess_board, possible_moves)
    possible_moves.reject do |move_square|
      clone_board, clone_piece, clone_square = clone_objects(chess_board, self, move_square)
      board_clone = clone_board_move(clone_board, clone_piece, clone_square)
      illegal?(board_clone)
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
    clone_piece = Marshal.load(Marshal.dump(real_piece))
    clone_square = Marshal.load(Marshal.dump(real_square))
    [clone_board, clone_piece, clone_square]
  end

  def clone_board_move(board, piece, square)
    piece.move(square, board)
    board
  end

  private

  def opponent_color
    color == :white ? :black : :white
  end
end