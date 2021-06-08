# frozen_string_literal: true

require_relative '../pieces/rook'

# Contains logic for determining if castling move is possible or not
module Castling
  def castling_move(board, x_shift)
    if initial_pieces?(board, x_shift) && correct_columns?(board, x_shift)
      board.get_relative_square(location, x: x_shift * 2)
    else
      []
    end
  end

  def get_rook(board, x_shift)
    rook_piece = board.get_square(rook_position(x_shift)).piece
    return rook_piece if rook_piece.is_a?(Rook) && rook_piece.color == color
  end

  private

  def initial_pieces?(board, x_shift)
    true if initial_king?(board) && initial_rook?(board, x_shift)
  end

  def correct_columns?(board, x_shift)
    true if empty_columns?(board, x_shift) && !columns_attacked?(board, x_shift)
  end

  def empty_columns?(board, x_shift)
    get_columns(board, x_shift).none?(&:taken?)
  end

  def columns_attacked?(board, x_shift)
    columns = get_columns(board, x_shift)
    # It has to reject enemy King to ensure that infinite loop will not happen. Rejecting King also means that
    # this method is not going to work properly when enemy king attacks any of the columns (maybe fix that later)
    enemy_pieces = board.squares_taken_by(opponent_color).map(&:piece).reject { |p| p.is_a?(King) }
    columns.any? do |column|
      enemy_pieces.any? { |piece| piece.possible_moves(board).include?(column) }
    end
  end

  def get_columns(board, x_shift)
    columns = x_shift == -1 ? [-1, -2, -3] : [1, 2]
    columns.map { |col| board.get_relative_square(location, x: col) }
  end

  def initial_king?(board)
    !board.recorded_moves.flatten.include?(location)
  end

  def initial_rook?(board, x_shift)
    moved_pieces = board.recorded_moves.flatten.map(&:piece)
    moved_rooks = moved_pieces.select { |piece| piece.is_a?(Rook) && piece.color == color }
    correct_rook = get_rook(board, x_shift)
    return true if !correct_rook.nil? && !moved_rooks.include?(correct_rook)
  end

  def rook_position(x_shift)
    row = location.position[:y]
    column = x_shift == -1 ? 1 : 8
    { x: column, y: row }
  end
end
