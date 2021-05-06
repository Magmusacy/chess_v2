require_relative 'special_conditions'

module DiscardIllegalMoves
  include SpecialConditions

  def discard_illegal_moves(chess_board, opponent_color, possible_moves)
    possible_moves.reject do |move_square|
      board_clone = clone_move(chess_board, self, move_square)
      illegal?(board_clone, opponent_color)
    end
  end

  def illegal?(board_clone, opponent_color)
    enemy_pieces = board_clone.squares_taken_by(opponent_color).map(&:piece)
    king_square = board_clone.get_king_square(@color)
    enemy_pieces.any? { |piece| piece.possible_moves(board_clone).include?(king_square) }
  end

  def clone_move(real_board, real_piece, real_square)
    clone_board = Marshal.load(Marshal.dump(real_board))
    clone_piece = Marshal.load(Marshal.dump(real_piece))
    clone_square = Marshal.load(Marshal.dump(real_square))
    clone_piece.move(clone_square, clone_board)
    clone_board
  end
end