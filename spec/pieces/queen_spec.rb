require_relative 'shared_piece_spec'
require_relative '../../lib/pieces/queen'

describe Queen do
  let(:chess_board) { double('Board') }

  # Check if it's possible to use tests for possible moves from shared tests
  describe '#possible_moves' do
    subject(:possible_queen) { described_class.new(nil, :white) }
    let(:white_piece) { double('Piece', color: :white) }
    let(:impossible_move) { [double('square', taken?: true, piece: white_piece)] }
    let(:possible_move) { [double('square', taken?: false)] }

    before do
      allow(possible_queen).to receive(:vertical_move).and_return([])
      allow(possible_queen).to receive(:horizontal_move).and_return([])
      allow(possible_queen).to receive(:diagonal_move).and_return([])
      allow(possible_queen).to receive(:discard_related_squares).with(possible_move).and_return(possible_move)
    end

    context 'when only #horizontal_move with x = 1 returns a possible and legal move' do
      before do
        allow(possible_queen).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_queen.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #horizontal_move with x = -1 returns a possible and legal move' do
      before do
        allow(possible_queen).to receive(:horizontal_move).with(chess_board, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_queen.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #vertical_move with y = 1 returns a possible and legal move' do
      before do
        allow(possible_queen).to receive(:vertical_move).with(chess_board, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_queen.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #vertical_move with y = -1 returns a possible and legal move' do
      before do
        allow(possible_queen).to receive(:vertical_move).with(chess_board, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_queen.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #diagonal_move with x = 1, y = 1 returns a possible and legal move' do
      before do
        allow(possible_queen).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_queen.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #diagonal_move with x = 1, y = -1 returns a possible and legal move' do
      before do
        allow(possible_queen).to receive(:diagonal_move).with(chess_board, 1, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_queen.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #diagonal_move with x = -1, y = 1 returns a possible and legal move' do
      before do
        allow(possible_queen).to receive(:diagonal_move).with(chess_board, -1, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_queen.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #diagonal_move with x = -1, y = -1 returns a possible and legal move' do
      before do
        allow(possible_queen).to receive(:diagonal_move).with(chess_board, -1, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_queen.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when there are 2 possible moves but one of them has square with Piece the same color as calling Queen' do
      it 'returns an array with 1 possible legal move' do
        returned_array = [possible_move, impossible_move].flatten
        allow(possible_queen).to receive(:discard_related_squares).with(returned_array).and_return(possible_move)
        allow(possible_queen).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
        allow(possible_queen).to receive(:vertical_move).with(chess_board, -1).and_return(impossible_move)
        result = possible_queen.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when there is 1 possible move on square with Piece the same color as calling Queen' do
      it 'returns empty array' do
        empty_array = []
        allow(possible_queen).to receive(:discard_related_squares).with(impossible_move).and_return(empty_array)
        allow(possible_queen).to receive(:vertical_move).with(chess_board, -1).and_return(impossible_move)
        result = possible_queen.possible_moves(chess_board)
        expect(result).to be_empty
      end
    end
  end

  context 'when given Piece is Queen' do
    include_examples '#horizontal_move method'
    include_examples '#vertical_move method'
    include_examples '#diagonal_move method'
  end
end