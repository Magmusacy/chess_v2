# frozen_string_literal: true

require_relative '../lib/square'

describe Square do
  describe '#update_piece' do
    context 'when given instance of a piece as an argument' do
      subject(:square_piece) { described_class.new([2, 2]) }
      let(:piece) { double('piece') }

      it 'changes @piece attribute to that instance' do
        square_piece.update_piece(piece)
        updated_piece = square_piece.piece
        expect(updated_piece).to be(piece)
      end
    end

    context 'when given no argument' do
      subject(:default_piece) { described_class.new([1, 1]) }

      it 'changes @piece attribute to \'   \'' do
        default_piece.update_piece
        updated_piece = default_piece.piece
        expect(updated_piece).to eq('   ')
      end
    end
  end

  describe '#taken?' do
    context 'when @piece attr is not a string' do
      subject(:taken_square) { described_class.new([1, 1], nil) }

      it 'returns true if @piece attr is not string' do
        expect(taken_square.taken?).to be true
      end
    end
    context 'when @piece attr is a string' do
      subject(:free_square) { described_class.new([1, 1]) }

      it 'returns false if @piece attr is a string' do
        expect(free_square.taken?).to be false
      end
    end
  end
end
