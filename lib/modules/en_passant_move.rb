# frozen_string_literal: true

# Contains logic for executing en passant move
module EnPassantMove
  def en_passant_move(board, x_shift)
    adjacent_square = [board.get_relative_square(location, x: x_shift)].compact
    return [] if adjacent_square.empty? || !adjacent_square.first.taken?

    if en_passantable?(adjacent_square.first, board.recorded_moves.last)
      [board.get_relative_square(location, x: x_shift, y: y_shift)]
    else
      []
    end
  end

  def take_enemy_pawn(chosen_square, board)
    enemy_pawn_square(chosen_square, board).update_piece
  end

  private

  def en_passantable?(square, last_move)
    return true if enemy_pawn?(square) && last_move.include?(square) && move_difference_is_two?(last_move)

    false
  end

  def move_difference_is_two?(moves)
    (moves.first.position[:y] - moves.last.position[:y]).abs == 2
  end

  def enemy_pawn?(square)
    return true if square.piece.is_a?(Pawn) && square.piece.color != color

    false
  end

  def enemy_pawn_square(chosen_square, board)
    board.get_relative_square(chosen_square, y: -y_shift)
  end
end
