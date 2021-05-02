require_relative '../../lib/pieces/piece'
require_relative '../../lib/square'
require_relative '../../lib/board'

describe Piece do
  let(:board) { instance_double(Board) }

  describe '#move' do
    let(:start_square) { instance_double(Square) }
    subject(:piece) { described_class.new(start_square) }
    let(:square) { instance_double(Square) }
    let(:move_array) { [start_square, square] }

    before do
      allow(square).to receive(:update_piece).with(piece)
      allow(start_square).to receive(:update_piece)
      allow(board).to receive(:add_new_move).with(move_array)
      allow(piece).to receive(:update_location)
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

    it 'calls #update_location method with given square as an argument' do
      expect(piece).to receive(:update_location).with(square)
      piece.move(square, board)
    end
  end

  describe '#update_location' do
    context 'when given square object' do
      subject(:piece) { described_class.new }
      let(:new_square) { instance_double(Square) }

      it 'updates @location variable to that given square' do
        expect { piece.update_location(new_square) }.to change { piece.location }.to(new_square)
      end
    end
  end

  describe '#reject_related_squares' do
    context 'when given an array of squares' do
      subject(:piece) { described_class.new(nil, :white, nil) }

      let(:piece_wht) { instance_double(Piece, color: :white) }
      let(:piece_blk) { instance_double(Piece, color: :black) }
      let(:square_wht1) { instance_double(Square, piece: piece_wht, taken?: true) }
      let(:square_wht2) { instance_double(Square, piece: piece_wht, taken?: true) }
      let(:square_blk1) { instance_double(Square, piece: piece_blk, taken?: true) }
      let(:square_blk2) { instance_double(Square, piece: piece_blk, taken?: true) }

      it 'returns modified array without squares that have the same @piece.color as the calling object' do
        squares = [square_wht1, square_wht2, square_blk1, square_blk2]
        result = piece.reject_related_squares(squares)
        expected = [square_blk1, square_blk2]
        expect(result).to match_array(expected)
      end
    end
  end
end