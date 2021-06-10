# frozen_string_literal: true

# Contains logic for creating every Piece with default array position
module PiecesCreator
  def create_pieces(player)
    color = player.color
    y_pos = select_y_positions(color)
    attributes = select_attributes(color, y_pos)
    create_instances(attributes)
  end

  def select_y_positions(color)
    color == :white ? [1, 2] : [8, 7]
  end

  def select_attributes(color, y_pos)
    ary = []
    8.times { |i| ary << [{ x: i + 1, y: y_pos.first }, color] }
    8.times { |i| ary << [{ x: i + 1, y: y_pos.last }, color] }
    ary
  end

  def create_instance(piece, attributes)
    position, color = attributes
    pieces_hash = { rook: Rook, knight: Knight, bishop: Bishop, king: King, queen: Queen, pawn: Pawn }
    pieces_hash[piece].new(position, color)
  end

  def create_instances(attributes)
    ary = []
    pieces = %i[rook knight bishop queen king bishop knight rook]
    attributes.each_with_index do |att, idx|
      piece = pieces[idx] || :pawn
      ary << create_instance(piece, att)
    end
    ary
  end
end
