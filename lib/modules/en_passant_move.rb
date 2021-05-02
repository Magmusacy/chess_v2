# frozen_string_literal: true

# Contains logic for executing en passant move
module EnPassantMove
  def en_passant_move(board, y_shift = y_axis_shift)
    ary = []
    new_positions = [board.get_relative_square(location, x: -1), board.get_relative_square(location, x: 1)].compact

    new_positions.length.times do |i|
      next unless new_positions[i].taken?

      if en_passantable?(new_positions[i], board.recorded_moves.last)
        ary << board.get_relative_square(location, y: y_shift)
      end
    end
    ary
  end

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
    board.get_relative_square(chosen_square, y: -y_axis_shift)
  end

  def take_enemy_piece(chosen_square, board)
    enemy_pawn_square(chosen_square, board).update_piece
  end

  def move(chosen_square, board)
    take_enemy_piece(chosen_square, board) if en_passant_move(board).include?(chosen_square)

    super
  end
end
