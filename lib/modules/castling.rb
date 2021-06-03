require_relative '../pieces/rook'

module Castling
  def castling_move(board, x)
    if initial_king?(board) && initial_rook?(board, x) && empty_columns?(board, x)
      return board.get_relative_square(location, x: x * 2) unless columns_attacked?(board, x)
    end
    []
  end

  def get_rook(board, x)
    rook_piece = board.get_square(rook_position(x)).piece
    return rook_piece if rook_piece.is_a?(Rook) && rook_piece.color == color
  end

  private

  def empty_columns?(board, x)
    get_columns(board, x).none? { |col| col.taken? }
  end

  def columns_attacked?(board, x)
    columns = get_columns(board, x)
    enemy_pieces = board.squares_taken_by(opponent_color).map(&:piece)
    columns.any? do |columns|
      enemy_pieces.any? { |piece| piece.possible_moves(board).include?(columns) }
    end
  end

  def get_columns(board, x)
    columns = x == -1 ? [-1, -2, -3] : [1, 2]
    columns.map { |col| board.get_relative_square(location, x: col) }
  end

  def initial_king?(board)
    !board.recorded_moves.flatten.include?(location)
  end

  def initial_rook?(board, x)
    moved_pieces = board.recorded_moves.flatten.map(&:piece)
    moved_rooks = moved_pieces.select { |piece| piece.is_a?(Rook) && piece.color == color }
    correct_rook = get_rook(board, x)
    return true if !correct_rook.nil? && !moved_rooks.include?(correct_rook)
  end

  def rook_position(x)
    row = location.position[:y]
    column = x == -1 ? 1 : 8
    { x: column, y: row }
  end
end