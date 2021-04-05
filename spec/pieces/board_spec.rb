# frozen_string_literal: true

require_relative '../../lib/pieces/board'
require_relative '../../lib/pieces/square'
require_relative '../../lib/pieces/piece'

describe Board do
  subject(:chess_board) { described_class.new }

  describe '#create_square' do
    before do
      allow(chess_board).to receive(:create_square_array)
    end

    it 'creates square object with given position' do
      position = [2, 2]
      expect(Square).to receive(:new).with(position)
      chess_board.create_square(position)
    end
  end

  describe '#create_square_array' do
    it 'returns an array with 64 individual square objects' do
      array = (Array(1..8).product Array(1..8))
      result = chess_board.create_square_array(array)
      expect(result.length).to eq(64)
      expect(result).to all(be_an(Square))
    end
  end

  describe '#assign_pieces' do
    context 'when initialized board with black_pieces' do
      let(:white_piece) { double('Piece', position: { x: 2, y: 2 }) }
      let(:black_piece) { double('Piece', position: { x: 7, y: 2 }) }
      let(:square_dbl) { instance_double(Square, position: { x: 7, y: 2 }) }

      before do
        allow(square_dbl).to receive(:update_piece).with(black_piece)
        allow(black_piece).to receive(:update_position)
        chess_board.board = [square_dbl]
      end

      it 'assigns pieces with their default position to correct squares' do
        expect(square_dbl).to receive(:update_piece).with(black_piece)
        chess_board.assign_pieces([black_piece])
      end

      it 'invokes #update_position with square object for each piece that is being assigned to the square' do
        expect(black_piece).to receive(:update_position).with(square_dbl)
        chess_board.assign_pieces([black_piece])
      end
    end
  end

  describe '#get_square' do
    context 'when given { x: 2, y: 5 } as an argument' do
      let(:square_dbl) { instance_double(Square, position: { x: 2, y: 5 }) }
      let(:board) { [square_dbl] }

      subject(:chess_board) { described_class.new(board) }

      it 'returns square object with position: { x: 2, y: 5 }' do
        position = { x: 2, y: 5 }
        square_object = chess_board.get_square(position)
        expect(square_object.position).to eq({ x: 2, y: 5 })
      end
    end
  end
end
