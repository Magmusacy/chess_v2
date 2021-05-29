require_relative '../../lib/pieces/knight'

describe Knight do
  let(:chess_board) { double('Cess_board') }

  describe '#possible_moves' do
    subject(:possible_knight) { described_class.new(nil, :white) }
    let(:white_piece) { double('Piece', color: :white) }
    let(:impossible_move) { [double('square', taken?: true, piece: white_piece)] }
    let(:possible_move) { [double('square', taken?: false)] }
# 90% sure that reject_related_squares should be public but then we have to test maybe shared test
# that every piece calls reject_related squares and
# we havew to stub reject_related_sqares in each you know thing and ju know
  end

  describe '#possible_moves' do
    subject(:possible_knight) { described_class.new(nil, :white) }
    let(:white_piece) { double('Piece', color: :white) }
    let(:impossible_move) { [double('square', taken?: true, piece: white_piece)] }
    let(:possible_move) { [double('square', taken?: false)] }

    before do
      allow(possible_knight).to receive(:knight_move).and_return([])
    end

    context 'when all possible moves are legal' do
      let(:possible_moves) { Array.new(8) { double('Square', taken?: false) } }

      before do
        moves = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [-2, -1], [2, -1]]
        moves.each_with_index do |m, i|
          allow(possible_knight).to receive(:knight_move).with(chess_board, m[0], m[1]).and_return(possible_moves[i])
        end
      end

      it 'returns an array with 8 possible legal moves' do
        result = possible_knight.possible_moves(chess_board)
        expect(result).to match_array(possible_moves)
      end
    end

    context 'when there are 2 possible moves but one of them has square with Piece the same color as Knight' do
      before do
        allow(possible_knight).to receive(:knight_move).and_return([])
      end
      it 'returns an array with 1 possible legal move' do
        returned_array = [possible_move, impossible_move].flatten
        allow(possible_knight).to receive(:knight_move).with(chess_board, 1, 2).and_return(possible_move)
        allow(possible_knight).to receive(:knight_move).with(chess_board, 2, 1).and_return(impossible_move)
        result = possible_knight.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when there is 1 possible move on square with Piece the same color as Knight' do
      it 'returns empty array' do
        empty_array = []
        allow(possible_knight).to receive(:knight_move).with(chess_board, 1, 2).and_return(impossible_move)
        result = possible_knight.possible_moves(chess_board)
        expect(result).to be_empty
      end
    end
  end

  describe '#knight_move' do
    context 'when Knight is on square { x: 4, y: 4 }' do
      let(:start_square_44) { double('Square', position: { x: 4, y: 4 }) }
      subject(:knight_44) { described_class.new(start_square_44) }
      let(:move_square) { [double('square')] }

      context 'when given x = 1, y = 2' do
        it 'returns square { x: 5, y: 6 }' do
          x = 1
          y = 2
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1, y: 2).and_return(move_square)
          result = knight_44.knight_move(chess_board, x, y)
          expect(result).to match_array(move_square)
        end
      end

      context 'when given x = -1, y = 2' do
        it 'returns square { x: 3, y: 6 }' do
          x = -1
          y = 2
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -1, y: 2).and_return(move_square)
          result = knight_44.knight_move(chess_board, x, y)
          expect(result).to match_array(move_square)
        end
      end

      context 'when given x = 1, y = -2' do
        it 'returns square { x: 5, y: 2 }' do
          x = 1
          y = -2
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1, y: -2).and_return(move_square)
          result = knight_44.knight_move(chess_board, x, y)
          expect(result).to match_array(move_square)
        end
      end

      context 'when given x = -1, y = -2' do
        it 'returns square { x: 3, y: 2 }' do
          x = -1
          y = -2
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -1, y: -2).and_return(move_square)
          result = knight_44.knight_move(chess_board, x, y)
          expect(result).to match_array(move_square)
        end
      end

      context 'when given x = 2, y = 1' do
        it 'returns square { x: 6, y: 5 }' do
          x = 2
          y = 1
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 2, y: 1).and_return(move_square)
          result = knight_44.knight_move(chess_board, x, y)
          expect(result).to match_array(move_square)
        end
      end

      context 'when given x = -2, y = 1' do
        it 'returns square { x: 2, y: 5 }' do
          x = -2
          y = 1
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -2, y: 1).and_return(move_square)
          result = knight_44.knight_move(chess_board, x, y)
          expect(result).to match_array(move_square)
        end
      end

      context 'when given x = 2, y = -1' do
        it 'returns square { x: 6, y: 3 }' do
          x = 2
          y = -1
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 2, y: -1).and_return(move_square)
          result = knight_44.knight_move(chess_board, x, y)
          expect(result).to match_array(move_square)
        end
      end

      context 'when given x = -2, y = -1' do
        it 'returns square { x: 2, y: 3 }' do
          x = -2
          y = -1
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -2, y: -1).and_return(move_square)
          result = knight_44.knight_move(chess_board, x, y)
          expect(result).to match_array(move_square)
        end
      end
    end

    context 'when given move results in nil' do
      let(:start_square_44) { double('Square', position: { x: 4, y: 4 }) }
      subject(:knight_44) { described_class.new(start_square_44) }
      let(:move_square) { [double('square')] }

      it 'returns empty array' do
          x = -2
          y = -1
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -2, y: -1).and_return(nil)
          result = knight_44.knight_move(chess_board, x, y)
          expect(result).to be_empty
      end
    end
  end
end