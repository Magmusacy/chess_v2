# frozen_string_literal: true

require_relative '../lib/modules/square_accessor'
require_relative '../lib/board'
require_relative '../lib/square'
require_relative '../lib/pieces/piece'

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
      let(:blk_square) { instance_double(Square, position: { x: 7, y: 2 }) }

      before do
        allow(chess_board).to receive(:get_square).with({ x: 7, y: 2 }).and_return(blk_square)
        allow(blk_square).to receive(:update_piece).with(black_piece)
        allow(black_piece).to receive(:update_position)
        chess_board.board = [blk_square]
      end

      it 'sends :update_piece message with Piece argument to Square with the same default position' do
        expect(blk_square).to receive(:update_piece).with(black_piece)
        chess_board.assign_pieces([black_piece])
      end

      it 'sends :update_position message with Square object for Piece that is being assigned to the Square' do
        expect(black_piece).to receive(:update_position).with(blk_square)
        chess_board.assign_pieces([black_piece])
      end
    end
  end

  describe '#get_square' do
    context 'when given position { x: 2, y: 2 }' do
      let(:exp_sqr_22) { instance_double(Square, position: { x: 2, y:2 }) }
      subject(:chess_board) { described_class.new([exp_sqr_22]) }

      it 'returns only one square with given position' do
        position = { x: 2, y: 2 }
        result = chess_board.get_square(position)
        expect(result).to eq(exp_sqr_22)
      end
    end
  end

  describe '#get_relative_square' do
    context 'when given initial_square { x: 2, y: 2 } and x: 1, y: 1' do
      let(:initial_square_22) { instance_double(Square, position: { x: 2, y: 2 }) }
      let(:expected_square_33) { instance_double(Square, position: { x: 3, y: 3 }) }

      it 'returns square { x: 3, y: 3 }' do
        allow(chess_board).to receive(:get_square).with({ x: 3, y: 3 }).and_return(expected_square_33)
        result = chess_board.get_relative_square(initial_square_22, x: 1, y: 1)
        expect(result).to eq(expected_square_33)
      end
    end

    context 'when given initial_square { x: 1, y: 4 } and x: 4, y: -2' do
      let(:initial_square_14) { instance_double(Square, position: { x: 1, y: 4 }) }
      let(:expected_square_52) { instance_double(Square, position: { x: 5, y: 2 }) }

      it 'returns square { x: 5, y: 2 }' do
        allow(chess_board).to receive(:get_square).with({ x: 5, y: 2 }).and_return(expected_square_52)
        result = chess_board.get_relative_square(initial_square_14, x: 4, y: -2)
        expect(result).to eq(expected_square_52)
      end
    end
  end

  describe '#squares_taken_by' do
    let(:wht_piece) { instance_double(Piece, color: :white) }
    let(:blk_piece) { instance_double(Piece, color: :black) }
    let(:wht_squares) do
      [
        instance_double(Square, piece: wht_piece),
        instance_double(Square, piece: wht_piece)
      ]
    end
    let(:blk_squares) do
      [
        instance_double(Square, piece: blk_piece),
        instance_double(Square, piece: blk_piece)
      ]
    end
    let(:empty_squares) do
      [
        instance_double(Square, piece: '   '),
        instance_double(Square, piece: '   ')
      ]
    end
    let(:board) { [wht_squares, blk_squares, empty_squares].flatten }
    subject(:chess_board) { described_class.new(board) }

    context 'when given :black as an argument' do
      it 'returns all squares with :black pieces on them' do
        color = :black
        result = chess_board.squares_taken_by(color)
        expect(result).to match_array(blk_squares)
      end
    end

    context 'when given :white as an argument' do
      it 'returns all squares with :white pieces on them' do
        color = :white
        result = chess_board.squares_taken_by(color)
        expect(result).to match_array(wht_squares)
      end
    end
  end

  describe '#square_taken?' do
    context 'when given square with position: { x: 2, y: 2 } has @piece attribute not equal to String object' do
      let(:piece) { double('piece') }
      let(:taken_square) { instance_double(Square, position: { x: 2, y: 2 }, piece: piece) }

      it 'returns true' do
        allow(chess_board).to receive(:get_square).and_return(taken_square)
        position = { x: 2, y: 2 }
        result = chess_board.square_taken?(position)
        expect(result).to be true
      end
    end

    context 'when given square with position: { x: 2, y: 3 } has @piece attr equal to String object' do
      let(:free_square) { instance_double(Square, position: { x: 2, y: 2 }, piece: ' ') }

      it 'returns false' do
        allow(chess_board).to receive(:get_square).and_return(free_square)
        position = { x: 2, y: 3 }
        result = chess_board.square_taken?(position)
        expect(result).to be false
      end
    end
  end
end
