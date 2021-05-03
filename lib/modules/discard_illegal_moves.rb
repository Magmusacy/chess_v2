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
    clone_board = real_board.clone
    clone_piece = real_piece.clone
    clone_square = real_square.clone
    clone_piece.move(clone_square, clone_board)
    clone_board
  end
end