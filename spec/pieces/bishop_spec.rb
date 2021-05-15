require_relative 'shared_piece_spec'
require_relative '../../lib/pieces/bishop'

describe Bishop do
  let(:chess_board) { double('Board') }

  context 'when Bishop is a child class of Piece' do
    subject(:Bishop) { described_class.new }
    include_examples 'base class methods names'
  end

  context 'when Bishop has the same method name' do
    subject(:Bishop) { described_class.new }
    include_examples 'shared method names'
  end

  describe '#possible_moves' do
    subject(:possible_bishop) { described_class.new(nil, :white) }
    let(:white_piece) { double('Piece', color: :white) }
    let(:impossible_move) { [double('square', taken?: true, piece: white_piece)] }
    let(:possible_move) { [double('square', taken?: false)] }

    before do
      allow(possible_bishop).to receive(:diagonal_move).and_return([])
    end

    context 'when only #diagonal_move with x = 1, y = 1 returns a possible and legal move' do
      before do
        allow(possible_bishop).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_bishop.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #diagonal_move with x = 1, y = -1 returns a possible and legal move' do
      before do
        allow(possible_bishop).to receive(:diagonal_move).with(chess_board, 1, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_bishop.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #diagonal_move with x = -1, y = 1 returns a possible and legal move' do
      before do
        allow(possible_bishop).to receive(:diagonal_move).with(chess_board, -1, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_bishop.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #diagonal_move with x = -1, y = -1 returns a possible and legal move' do
      before do
        allow(possible_bishop).to receive(:diagonal_move).with(chess_board, -1, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_bishop.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when there are 2 possible moves but one of them has square with Piece the same color as given Bishop' do
      it 'returns an array with 1 possible legal move' do
        allow(possible_bishop).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(possible_move)
        allow(possible_bishop).to receive(:diagonal_move).with(chess_board, -1, 1).and_return(impossible_move)
        result = possible_bishop.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end
  end

  context 'when given Piece is Bishop' do
    include_examples '#diagonal_move method'
  end
end