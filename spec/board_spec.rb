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

  describe '#add_move' do
    context 'when given moves array' do
      let(:moves) { [instance_double(Square), instance_double(Square)] }
      let(:new_moves) { [instance_double(Square), instance_double(Square)] }

      it 'adds that array to @recorded_moves instance variable' do
        start_moves = [moves]
        expected_array = [moves, new_moves]
        chess_board.instance_variable_set(:@recorded_moves, start_moves)
        expect { chess_board.add_move(new_moves) }.to change { chess_board.recorded_moves }.from(start_moves).to (expected_array)
      end
    end
  end

  describe '#assign_pieces' do
    context 'when initialized board with black_pieces' do
      let(:white_piece) { instance_double(Piece, location: { x: 2, y: 2 }) }
      let(:black_piece) { instance_double(Piece, location: { x: 7, y: 2 }) }
      let(:blk_square) { instance_double(Square, position: { x: 7, y: 2 }) }

      before do
        allow(chess_board).to receive(:get_square).with({ x: 7, y: 2 }).and_return(blk_square)
        allow(blk_square).to receive(:update_piece).with(black_piece)
        allow(black_piece).to receive(:update_location)
        chess_board.board = [blk_square]
      end

      it 'sends :update_piece message with Piece argument to Square with the same default position' do
        expect(blk_square).to receive(:update_piece).with(black_piece)
        chess_board.assign_pieces([black_piece])
      end

      it 'sends :update_location message with Square object for Piece that is being assigned to the Square' do
        expect(black_piece).to receive(:update_location).with(blk_square)
        chess_board.assign_pieces([black_piece])
      end
    end
  end

  describe '#get_square' do
    context 'when given position { x: 2, y: 2 }' do
      let(:board) { [instance_double(Square, position: { x: 2, y:2 })] }
      subject(:chess_board) { described_class.new(board) }

      it 'returns only one square with given position' do
        position = { x: 2, y: 2 }
        result = chess_board.get_square(position)
        expect(result).to eq(exp_sqr_22)
      end
    end
  end

  describe '#get_relative_square' do
    subject(:chess_board) { described_class.new }

    context 'when given initial_square { x: 2, y: 2 } and x: 1, y: 1' do
      let(:initial_square_22) { instance_double(Square, position: { x: 2, y: 2 }) }
      let(:expected_square_33) { instance_double(Square, position: { x: 3, y: 3 }) }
      let(:board) { [initial_square_22, expected_square_33] }

      it 'returns square { x: 3, y: 3 }' do
        chess_board.instance_variable_set(:@board, board)
        result = chess_board.get_relative_square(initial_square_22, x: 1, y: 1)
        expect(result).to eq(expected_square_33)
      end
    end

    context 'when given initial_square { x: 1, y: 4 } and x: 4, y: -2' do
      let(:initial_square_14) { instance_double(Square, position: { x: 1, y: 4 }) }
      let(:expected_square_52) { instance_double(Square, position: { x: 5, y: 2 }) }
      let(:board) { [initial_square_14, expected_square_52] }

      it 'returns square { x: 5, y: 2 }' do
        chess_board.instance_variable_set(:@board, board)
        result = chess_board.get_relative_square(initial_square_14, x: 4, y: -2)
        expect(result).to eq(expected_square_52)
      end
    end
  end

  let(:black_king) { instance_double(King, color: :black) }
  let(:white_king) { instance_double(King, color: :white) }
  let(:black_square) { instance_double(Square, taken?: true, piece: black_king) }
  let(:white_square) { instance_double(Square, taken?: true, piece: white_king) }
  let(:board) { [black_square, white_square] }
  subject(:chess_board) { described_class.new(board) }

  describe '#squares_taken_by' do
    context 'when given :black as an argument' do
      it 'returns all squares with :black pieces on them' do
        color = :black
        result = chess_board.squares_taken_by(color)
        expect(result).to match_array([black_square])
      end
    end

    context 'when given :white as an argument' do
      it 'returns all squares with :white pieces on them' do
        color = :white
        result = chess_board.squares_taken_by(color)
        expect(result).to match_array([white_square])
      end
    end
  end

  describe '#get_king_square' do
    context 'when given :black color' do
      before do
        allow(black_king).to receive(:is_a?).and_return(true)
      end

      it 'returns square with :black King piece on it' do
        result = chess_board.get_king_square(:black)
        expect(result).to eq(black_king)
      end
    end

    context 'when given :white color' do
      before do
        allow(white_king).to receive(:is_a?).and_return(true)
      end

      it 'returns square with :white King piece on it' do
        result = chess_board.get_king_square(:white)
        expect(result).to eq(white_king)
      end
    end
  end
end
