require_relative '../../lib/modules/pieces_creator'
require_relative '../../lib/player'
require_relative '../../lib/pieces/bishop'
require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/knight'
require_relative '../../lib/pieces/pawn'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/pieces/queen'
require_relative '../../lib/pieces/rook'

RSpec.configure do |c|
  c.include PiecesCreator
end

describe '#select_y_positions' do
  context 'when player color is :white' do
    let(:player_wht) { instance_double(Player, color: :white) }

    it 'returns [1, 2]' do
      color = player_wht.color
      result = select_y_positions(color)
      expected = [1, 2]
      expect(result).to match_array(expected)
    end
  end

  context 'when player color is :black' do
    let(:player_blk) { instance_double(Player, color: :black) }

    it 'returns [8, 7]' do
      color = player_blk.color
      result = select_y_positions(color)
      expected = [8, 7]
      expect(result).to match_array(expected)
    end
  end
end

describe '#select_attributes' do
  context 'when player color is :white' do
    let(:player_wht) { instance_double(Player, color: :white) }

    it 'returns correct attributes for :white player' do
      color = player_wht.color
      y_pos = [1, 2]
      result = select_attributes(color, y_pos)
      expected = [
                   [{ x: 1, y: 1 }, :white], [{ x: 2, y: 1 }, :white],
                   [{ x: 3, y: 1 }, :white], [{ x: 4, y: 1 }, :white],
                   [{ x: 5, y: 1 }, :white], [{ x: 6, y: 1 }, :white],
                   [{ x: 7, y: 1 }, :white], [{ x: 8, y: 1 }, :white],
                   [{ x: 1, y: 2 }, :white], [{ x: 2, y: 2 }, :white],
                   [{ x: 3, y: 2 }, :white], [{ x: 4, y: 2 }, :white],
                   [{ x: 5, y: 2 }, :white], [{ x: 6, y: 2 }, :white],
                   [{ x: 7, y: 2 }, :white], [{ x: 8, y: 2 }, :white]
                 ]
      expect(result).to match_array(expected)
    end
  end

  context 'when player color is :black' do
    let(:player_blk) { instance_double(Player, color: :black) }

    it 'returns correct attributes for :black player' do
      color = player_blk.color
      y_pos = [8, 7]
      result = select_attributes(color, y_pos)
      expected = [
                   [{ x: 1, y: 8 }, :black], [{ x: 2, y: 8 }, :black],
                   [{ x: 3, y: 8 }, :black], [{ x: 4, y: 8 }, :black],
                   [{ x: 5, y: 8 }, :black], [{ x: 6, y: 8 }, :black],
                   [{ x: 7, y: 8 }, :black], [{ x: 8, y: 8 }, :black],
                   [{ x: 1, y: 7 }, :black], [{ x: 2, y: 7 }, :black],
                   [{ x: 3, y: 7 }, :black], [{ x: 4, y: 7 }, :black],
                   [{ x: 5, y: 7 }, :black], [{ x: 6, y: 7 }, :black],
                   [{ x: 7, y: 7 }, :black], [{ x: 8, y: 7 }, :black]
                 ]
      expect(result).to match_array(expected)
    end
  end
end

describe '#create_instance' do
  context 'when given :rook and [{ x: 1, y: 1 }, :white] arguments' do
    before do
      allow(Rook).to receive(:new).with({ x: 1, y: 1 }, :white)
    end

    it 'sends :new message to Rook class with ({ x: 1, y: 1 }, :white) parameters' do
      piece = :rook
      attributes = [{ x: 1, y: 1 }, :white]
      expect(Rook).to receive(:new).with({ x: 1, y: 1 }, :white)
      create_instance(piece, attributes)
    end
  end

  context 'when given :knight and [{ x: 2, y: 1 }, :white] arguments' do
    before do
      allow(Knight).to receive(:new).with({ x: 2, y: 1 }, :white)
    end

    it 'sends :new message to Knight class with ({ x: 1, y: 2 }, :white) parameters' do
      piece = :knight
      attributes = [{ x: 2, y: 1 }, :white]
      expect(Knight).to receive(:new).with({ x: 2, y: 1 }, :white)
      create_instance(piece, attributes)
    end
  end

  context 'when given :bishop and [{ x: 3, y: 1 }, :white] arguments' do
    before do
      allow(Bishop).to receive(:new).with({ x: 3, y: 1 }, :white)
    end

    it 'sends :new message to Bishop class with ({ x: 3, y: 1 }, :white) parameters' do
      piece = :bishop
      attributes = [{ x: 3, y: 1 }, :white]
      expect(Bishop).to receive(:new).with({ x: 3, y: 1 }, :white)
      create_instance(piece, attributes)
    end
  end

  context 'when given :queen and [{ x: 4, y: 1 }, :white] arguments' do
    before do
      allow(Queen).to receive(:new).with({ x: 4, y: 1 }, :white)
    end

    it 'sends :new message to Queen class with ({ x: 4, y: 1 }, :white) parameters' do
      piece = :queen
      attributes = [{ x: 4, y: 1 }, :white]
      expect(Queen).to receive(:new).with({ x: 4, y: 1 }, :white)
      create_instance(piece, attributes)
    end
  end

  context 'when given :king and [{ x: 5, y: 1 }, :white] arguments' do
    before do
      allow(King).to receive(:new).with({ x: 5, y: 1 }, :white)
    end

    it 'sends :new message to King class with ({ x: 5, y: 1 }, :white) parameters' do
      piece = :king
      attributes = [{ x: 5, y: 1 }, :white]
      expect(King).to receive(:new).with({ x: 5, y: 1 }, :white)
      create_instance(piece, attributes)
    end
  end

  context 'when given :pawn and [{ x: 1, y: 2 }, :white] arguments' do
    before do
      allow(Pawn).to receive(:new).with({ x: 1, y: 2 }, :white)
    end

    it 'sends :new message to Pawn class with ({ x: 1, y: 2 }, :white) parameters' do
      piece = :pawn
      attributes = [{ x: 1, y: 2 }, :white]
      expect(Pawn).to receive(:new).with({ x: 1, y: 2 }, :white)
      create_instance(piece, attributes)
    end
  end

  context 'when given :pawn and [{ x: 2, y: 7 }, :black] arguments' do
    before do
      allow(Pawn).to receive(:new).with({ x: 2, y: 7 }, :black)
    end

    it 'sends :new message to Pawn class with ({ x: 2, y: 7 }, :black) parameters' do
      piece = :pawn
      attributes = [{ x: 2, y: 7 }, :black]
      expect(Pawn).to receive(:new).with({ x: 2, y: 7 }, :black)
      create_instance(piece, attributes)
    end
  end
end

describe '#create_instances' do
  context 'when given attributes of :white player' do
    let(:wht_attributes) do
      [
        [{ x: 1, y: 1 }, :white], [{ x: 2, y: 1 }, :white],
        [{ x: 3, y: 1 }, :white], [{ x: 4, y: 1 }, :white],
        [{ x: 5, y: 1 }, :white], [{ x: 6, y: 1 }, :white],
        [{ x: 7, y: 1 }, :white], [{ x: 8, y: 1 }, :white],
        [{ x: 1, y: 2 }, :white], [{ x: 2, y: 2 }, :white],
        [{ x: 3, y: 2 }, :white], [{ x: 4, y: 2 }, :white],
        [{ x: 5, y: 2 }, :white], [{ x: 6, y: 2 }, :white],
        [{ x: 7, y: 2 }, :white], [{ x: 8, y: 2 }, :white]
      ]
    end

    let(:piece_instance) do
      [
        [instance_double(Rook, location: { x: 1, y: 1 }, color: :white)],
        [instance_double(Knight, location: { x: 2, y: 1 }, color: :white)],
        [instance_double(Bishop, location: { x: 3, y: 1 }, color: :white)],
        [instance_double(Queen, location: { x: 4, y: 1 }, color: :white)],
        [instance_double(King, location: { x: 5, y: 1 }, color: :white)],
        [instance_double(Bishop, location: { x: 6, y: 1 }, color: :white)],
        [instance_double(Knight, location: { x: 7, y: 1 }, color: :white)],
        [instance_double(Rook, location: { x: 8, y: 1 }, color: :white)],
        [instance_double(Pawn, location: { x: 1, y: 2 }, color: :white)],
        [instance_double(Pawn, location: { x: 2, y: 2 }, color: :white)],
        [instance_double(Pawn, location: { x: 3, y: 2 }, color: :white)],
        [instance_double(Pawn, location: { x: 4, y: 2 }, color: :white)],
        [instance_double(Pawn, location: { x: 5, y: 2 }, color: :white)],
        [instance_double(Pawn, location: { x: 6, y: 2 }, color: :white)],
        [instance_double(Pawn, location: { x: 7, y: 2 }, color: :white)],
        [instance_double(Pawn, location: { x: 8, y: 2 }, color: :white)]
      ]
    end

    before do
      pieces = [:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook, :pawn]
      8.times do |i|
        allow(self).to receive(:create_instance).with(pieces[i], wht_attributes[i]).and_return(piece_instance[i])
      end
      (7..15).each do |i|
        allow(self).to receive(:create_instance).with(pieces[8], wht_attributes[i]).and_return(piece_instance[i])
      end
    end

    it 'returns correct array of all :white Pieces' do
      expected = piece_instance
      result = create_instances(wht_attributes)
      expect(result).to match_array(expected)
    end
  end

  context 'when given attributes of :black player' do
    let(:wht_attributes) do
      [
        [{ x: 1, y: 8 }, :black], [{ x: 2, y: 8 }, :black],
        [{ x: 3, y: 8 }, :black], [{ x: 4, y: 8 }, :black],
        [{ x: 5, y: 8 }, :black], [{ x: 6, y: 8 }, :black],
        [{ x: 7, y: 8 }, :black], [{ x: 8, y: 8 }, :black],
        [{ x: 1, y: 7 }, :black], [{ x: 2, y: 7 }, :black],
        [{ x: 3, y: 7 }, :black], [{ x: 4, y: 7 }, :black],
        [{ x: 5, y: 7 }, :black], [{ x: 6, y: 7 }, :black],
        [{ x: 7, y: 7 }, :black], [{ x: 8, y: 7 }, :black]
      ]
    end

    let(:piece_instance) do
      [
        [instance_double(Rook, location: { x: 1, y: 8 }, color: :white)],
        [instance_double(Knight, location: { x: 2, y: 8 }, color: :white)],
        [instance_double(Bishop, location: { x: 3, y: 8 }, color: :white)],
        [instance_double(Queen, location: { x: 4, y: 8 }, color: :white)],
        [instance_double(King, location: { x: 5, y: 8 }, color: :white)],
        [instance_double(Bishop, location: { x: 6, y: 8 }, color: :white)],
        [instance_double(Knight, location: { x: 7, y: 8 }, color: :white)],
        [instance_double(Rook, location: { x: 8, y: 8 }, color: :white)],
        [instance_double(Pawn, location: { x: 1, y: 7 }, color: :white)],
        [instance_double(Pawn, location: { x: 2, y: 7 }, color: :white)],
        [instance_double(Pawn, location: { x: 3, y: 7 }, color: :white)],
        [instance_double(Pawn, location: { x: 4, y: 7 }, color: :white)],
        [instance_double(Pawn, location: { x: 5, y: 7 }, color: :white)],
        [instance_double(Pawn, location: { x: 6, y: 7 }, color: :white)],
        [instance_double(Pawn, location: { x: 7, y: 7 }, color: :white)],
        [instance_double(Pawn, location: { x: 8, y: 7 }, color: :white)]
      ]
    end

    before do
      pieces = [:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook, :pawn]
      8.times do |i|
        allow(self).to receive(:create_instance).with(pieces[i], wht_attributes[i]).and_return(piece_instance[i])
      end
      (7..15).each do |i|
        allow(self).to receive(:create_instance).with(pieces[8], wht_attributes[i]).and_return(piece_instance[i])
      end
    end

    it 'returns correct array of all :black Pieces' do
      expected = piece_instance
      result = create_instances(wht_attributes)
      expect(result).to match_array(expected)
    end
  end
end