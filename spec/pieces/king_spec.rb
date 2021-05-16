require_relative 'shared_piece_spec'
require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'
require_relative '../../lib/square'

describe King do
  let(:chess_board) { instance_double(Board) }

  context 'when King is a child class of Piece' do
    subject(:king) { described_class.new }
    include_examples 'base class methods names'
  end

  context 'when King has the same method name' do
    subject(:king) { described_class.new }
    include_examples 'shared method names'
  end

  describe '#possible_moves' do
    context 'when given King { x: 4, y: 4 }' do
    subject(:possible_king) { described_class.new(nil, :white) }
    let(:white_piece) { instance_double(Piece, color: :white) }
    let(:impossible_move) { [instance_double(Square, taken?: true, piece: white_piece)] }
    let(:possible_move) { [instance_double(Square, taken?: false)] }

    before do
      allow(possible_king).to receive(:horizontal_move).and_return([])
      allow(possible_king).to receive(:vertical_move).and_return([])
      allow(possible_king).to receive(:diagonal_move).and_return([])
      allow(possible_king).to receive(:discard_related_squares).with(possible_move).and_return(possible_move)
    end

      context 'when only #horizontal_move with x = -1 returns a possible legal move' do
        before do
          allow(possible_king).to receive(:horizontal_move).with(chess_board, -1).and_return(possible_move)
        end

        it 'returns an array with 1 possible move' do
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when only #horizontal_move with x = 1 returns a possible legal move' do
        before do
          allow(possible_king).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
        end

        it 'returns an array with 1 possible move' do
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when only #vertical_move with y = -1 is possible' do
        before do
          allow(possible_king).to receive(:vertical_move).with(chess_board, -1).and_return(possible_move)
        end

        it 'returns an array with 1 possible move' do
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when only #vertical_move with y = 1 is possible' do
        before do
          allow(possible_king).to receive(:vertical_move).with(chess_board, 1).and_return(possible_move)
        end

        it 'returns an array with 1 possible move' do
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when only #diagonal_move with x = 1, y = 1 is possible' do
        before do
          allow(possible_king).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(possible_move)
        end

        it 'returns an array with 1 possible move' do
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when only #diagonal_move with x = 1, y = -1 is possible' do
        before do
          allow(possible_king).to receive(:diagonal_move).with(chess_board, 1, -1).and_return(possible_move)
        end

        it 'returns an array with 1 possible move' do
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when only #diagonal_move with x = -1, y = -1 is possible' do
        before do
          allow(possible_king).to receive(:diagonal_move).with(chess_board, -1, -1).and_return(possible_move)
        end

        it 'returns an array with 1 possible move' do
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when only #diagonal_move with x = -1, y = 1 is possible' do
        before do
          allow(possible_king).to receive(:diagonal_move).with(chess_board, -1, 1).and_return(possible_move)
        end

        it 'returns an array with 1 possible move' do
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when there are 2 possible moves but one of them has square with Piece the same color as calling Queen' do
        it 'returns an array with 1 possible legal move' do
          returned_array = [possible_move, impossible_move].flatten
          allow(possible_king).to receive(:discard_related_squares).with(returned_array).and_return(possible_move)
          allow(possible_king).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
          allow(possible_king).to receive(:vertical_move).with(chess_board, -1).and_return(impossible_move)
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when there is 1 possible move on square with Piece the same color as calling Queen' do
        it 'returns empty array' do
          empty_array = []
          allow(possible_king).to receive(:discard_related_squares).with(impossible_move).and_return(empty_array)
          allow(possible_king).to receive(:vertical_move).with(chess_board, -1).and_return(impossible_move)
          result = possible_king.possible_moves(chess_board)
          expect(result).to be_empty
        end
      end
    end
  end

  describe '#horizontal_move' do
    context 'when given King on square { x: 5, y: 3 }' do
      let(:start_square_53) { instance_double(Square, position: { x: 5, y: 3 }) }
      subject(:king_53) { described_class.new(start_square_53, :nil, nil) }

      context 'when x = 1' do
        let(:square_63) { instance_double(Square, position: { x: 6, y: 3 }, taken?: false) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_53, x: 1).and_return(square_63)
        end

        it 'returns square { x: 6, y: 3 }' do
          x = 1
          result = king_53.horizontal_move(chess_board, x)
          expected = [square_63]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = -1' do
        let(:square_43) { instance_double(Square, position: { x: 6, y: 3 }, taken?: false) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_53, x: -1).and_return(square_43)
        end

        it 'returns square { x: 4, y: 3 }' do
          x = -1
          result = king_53.horizontal_move(chess_board, x)
          expected = [square_43]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when move results in square that is not on the board' do
      let(:start_square_12) { instance_double(Square, position: { x: 1, y: 2 }) }
      subject(:king_12) { described_class.new(start_square_12, nil, nil) }

      before do
        allow(chess_board).to receive(:get_relative_square).with(start_square_12, x: -1).and_return(nil)
      end

      it 'returns empty array' do
        x = -1
        result = king_12.horizontal_move(chess_board, x)
        expect(result).to be_empty
      end
    end
  end

  describe '#vertical_move' do
    context 'when given King on square { x: 5, y: 3 }' do
      let(:start_square_53) { instance_double(Square, position: { x: 5, y: 3 }) }
      subject(:king_53) { described_class.new(start_square_53, nil, nil) }

      context 'when y = 1' do
        let(:square_54) { instance_double(Square, position: { x: 5, y: 4 }, taken?: false) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_53, y: 1).and_return(square_54)
        end

        it 'returns square { x: 5, y: 4 }' do
          y = 1
          result = king_53.vertical_move(chess_board, y)
          expected = [square_54]
          expect(result).to match_array(expected)
        end
      end

      context 'when y = -1' do
        let(:square_52) { instance_double(Square, position: { x: 5, y: 2 }, taken?: false) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_53, y: -1).and_return(square_52)
        end

        it 'returns square { x: 5, y: 2 }' do
          y = -1
          result = king_53.vertical_move(chess_board, y)
          expected = [square_52]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when move results in square that is not on the board' do
      let(:start_square_51) { instance_double(Square, position: { x: 5, y: 1 }) }
      subject(:king_51) { described_class.new(start_square_51, nil, nil) }

      before do
        allow(chess_board).to receive(:get_relative_square).with(start_square_51, y: -1).and_return(nil)
      end

      it 'returns empty array' do
        y = -1
        result = king_51.vertical_move(chess_board, y)
        expect(result).to be_empty
      end
    end
  end

  describe '#diagonal_move' do
    context 'when given only King on square { x: 4, y: 4 }' do
      let(:start_square_44) { instance_double(Square, position: { x: 4, y: 4 }) }
      subject(:diagonal_king_44) { described_class.new(start_square_44) }

      context 'when x = 1, y = 1' do
        let(:square_55) { instance_double(Square, position: { x: 5, y: 5 }) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1, y: 1).and_return(square_55)
        end

        it 'returns square { x: 5, y: 5 }' do
          result = diagonal_king_44.diagonal_move(chess_board, 1, 1)
          expected = [square_55]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = 1, y = -1' do
        let(:square_53) { instance_double(Square, position: { x: 5, y: 3 }) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1, y: -1).and_return(square_53)
        end

        it 'returns square { x: 5, y: 3 }' do
          result = diagonal_king_44.diagonal_move(chess_board, 1, -1)
          expected = [square_53]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = -1, y = 1' do
        let(:square_35) { instance_double(Square, position: { x: 3, y: 5 }) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -1, y: 1).and_return(square_35)
        end

        it 'returns square { x: 3, y: 5 }' do
          result = diagonal_king_44.diagonal_move(chess_board, -1, 1)
          expected = [square_35]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = -1, y = -1' do
        let(:square_33) { instance_double(Square, position: { x: 3, y: 3 }) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -1, y: -1).and_return(square_33)
        end

        it 'returns square { x: 3, y: 3 }' do
          result = diagonal_king_44.diagonal_move(chess_board, -1, -1)
          expected = [square_33]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when move results in square that is not on the board' do
      let(:start_square_51) { instance_double(Square, position: { x: 5, y: 1 }) }
      subject(:king_51) { described_class.new(start_square_51, nil, nil) }

      before do
        allow(chess_board).to receive(:get_relative_square).with(start_square_51, x: 1, y: -1).and_return(nil)
      end

      it 'returns empty array' do
        x = 1
        y = -1
        result = king_51.diagonal_move(chess_board, x, y)
        expect(result).to be_empty
      end
    end
  end
end