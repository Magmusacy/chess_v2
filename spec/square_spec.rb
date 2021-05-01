# frozen_string_literal: true

require_relative '../lib/square'
require_relative '../lib/pieces/piece'

describe Square do
  describe '#update_piece' do
    context 'when given instance of a piece as an argument' do
      subject(:square_piece) { described_class.new([2, 2]) }
      let(:piece) { instance_double(Piece) }

      it 'changes @piece attribute to that instance' do
        square_piece.update_piece(piece)
        updated_piece = square_piece.piece
        expect(updated_piece).to be(piece)
      end
    end

    context 'when given no argument' do
      subject(:default_piece) { described_class.new([1, 1]) }

      it 'changes @piece attribute to nil' do
        default_piece.update_piece
        updated_piece = default_piece.piece
        expect(updated_piece).to be nil
      end
    end
  end

  describe '#taken?' do
    context 'when @piece attr is not nil' do
      let(:dummy_piece) { instance_double(Piece) }
      subject(:taken_square) { described_class.new([1, 1], dummy_piece) }

      it 'returns true' do
        expect(taken_square.taken?).to be true
      end
    end
    context 'when @piece attr is nil' do
      subject(:free_square) { described_class.new([1, 1], nil) }

      it 'returns false' do
        expect(free_square.taken?).to be false
      end
    end
  end
end
