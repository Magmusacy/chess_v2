require_relative '../../lib/pieces/piece'
require_relative '../../lib/square'

describe Piece do
  let(:board) { double('board') }

  describe '#find_relative_square' do
    context 'when given x: 1, y: 1 and initial_square: square with position { x: 2, y: 2 }' do
      let(:initial_square_22) { instance_double(Square, position: { x: 2, y: 2 }) }
      let(:expected_square_33) { instance_double(Square, position: { x: 3, y: 3 }) }
      subject(:piece) { described_class.new }

      it 'returns square { x: 3, y: 3 }' do
        allow(board).to receive(:get_square).with({ x: 3, y: 3 }).and_return(expected_square_33)
        result = piece.find_relative_square(board, x: 1, y: 1, initial_square: initial_square_22)
        expect(result).to eq(expected_square_33)
      end
    end

    context 'when given x: 4, y: 2 and Piece is located on square { x: 1, y: 4 }' do
      let(:start_square_14) { instance_double(Square, position: { x: 1, y: 4 }) }
      let(:expected_square_56) { instance_double(Square, position: { x: 5, y: 6 }) }
      subject(:piece) { described_class.new(start_square_14) }

      it 'returns square { x: 5, y: 6 }' do
        allow(board).to receive(:get_square).with({ x: 5, y: 6 }).and_return(expected_square_56)
        result = piece.find_relative_square(board, x: 4, y: 2)
        expect(result).to eq(expected_square_56)
      end
    end
  end

  describe '#move' do
    let(:start_square) { instance_double(Square) }
    subject(:piece) { described_class.new(start_square) }
    let(:square) { instance_double(Square) }
    let(:move_array) { [start_square, square] }

    before do
      allow(square).to receive(:update_piece).with(piece)
      allow(start_square).to receive(:update_piece)
      allow(board).to receive(:add_new_move).with(move_array)
    end

    it 'sends :add_new_move message to Board with [location, square] argument' do
      expect(board).to receive(:add_new_move).with(move_array)
      piece.move(square, board)
    end

    it 'sends :update_piece message with self to given square' do
      expect(square).to receive(:update_piece).with(piece)
      piece.move(square, board)
    end

    it 'sends :update_piece message without any args to self location' do
      expect(start_square).to receive(:update_piece).with(no_args)
      piece.move(square, board)
    end

    it 'changes @location to given square' do
      expect { piece.move(square, board) }.to change { piece.location }.to(square)
    end
  end
end