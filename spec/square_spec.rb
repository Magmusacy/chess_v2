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
  end
end
