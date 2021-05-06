require_relative 'special_conditions'

module DiscardIllegalMoves
  include SpecialConditions

  def discard_illegal_moves(chess_board, opponent_color, possible_moves)
    possible_moves.reject do |move_square|
      board_clone = clone_move(chess_board, self, move_square)
      check?(board_clone, @color, opponent_color)
    end
  end

  def clone_move(real_board, real_piece, real_square)
    clone_board = Marshal.load(Marshal.dump(real_board))
    clone_piece = Marshal.load(Marshal.dump(real_piece))
    clone_square = Marshal.load(Marshal.dump(real_square))
    clone_piece.move(clone_square, clone_board)
    clone_board
  end
end