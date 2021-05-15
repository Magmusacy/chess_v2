require_relative 'shared_piece_spec'
require_relative '../../lib/pieces/rook'

describe Rook do
  let(:chess_board) { double('Board') }

  context 'when Rook is a child class of Piece' do
    subject(:rook) { described_class.new(nil, nil) }
    include_examples 'base class methods names'
  end

  context 'when Rook has the same method name' do
    subject(:rook) { described_class.new(nil, nil) }
    include_examples 'shared method names'
  end

  describe '#possible_moves' do
    subject(:possible_rook) { described_class.new(nil, :white) }
    let(:white_piece) { double('Piece', color: :white) }
    let(:impossible_move) { [double('square', taken?: true, piece: white_piece)] }
    let(:possible_move) { [double('square', taken?: false)] }

    before do
      allow(possible_rook).to receive(:vertical_move).and_return([])
      allow(possible_rook).to receive(:horizontal_move).and_return([])
    end

    context 'when only #horizontal_move with x = 1 returns a possible and legal move' do
      before do
        allow(possible_rook).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #horizontal_move with x = -1 returns a possible and legal move' do
      before do
        allow(possible_rook).to receive(:horizontal_move).with(chess_board, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #vertical_move with y = 1 returns a possible and legal move' do
      before do
        allow(possible_rook).to receive(:vertical_move).with(chess_board, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #vertical_move with y = -1 returns a possible and legal move' do
      before do
        allow(possible_rook).to receive(:vertical_move).with(chess_board, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when there are 2 possible moves but one of them has square with Piece the same color as given Rook' do
      it 'returns an array with 1 possible legal move' do
        allow(possible_rook).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
        allow(possible_rook).to receive(:vertical_move).with(chess_board, -1).and_return(impossible_move)
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end
  end

  context 'when given Piece is Rook' do
    include_examples '#horizontal_move method'
    include_examples '#vertical_move method'
  end
end