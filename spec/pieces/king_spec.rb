require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'
require_relative '../../lib/square'

describe King do
  let(:chess_board) { instance_double(Board) }

  describe '#legal_moves' do
    context 'when given King { x: 4, y: 4 }' do
    subject(:king_moves) { described_class.new(nil, :white) }
    let(:moves) { [instance_double(Square), instance_double(Square)] }
    let(:enemy_color) { :black }
    let(:illegal) { [moves.first] }
    let(:legal) { [moves.last] }

    before do
      allow(king_moves).to receive(:horizontal_move).and_return([])
      allow(king_moves).to receive(:vertical_move).and_return([])
      allow(king_moves).to receive(:diagonal_move).and_return([])
    end

    context 'when all move methods returned 2 moves and only 1 of them is legal' do
      before do
        allow(king_moves).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(illegal)
        allow(king_moves).to receive(:diagonal_move).with(chess_board, -1, -1).and_return(legal)
        allow(king_moves).to receive(:discard_illegal_moves).with(chess_board, enemy_color, moves).and_return(legal)
      end

      it 'returns only that 1 legal move' do
        result = king_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end

    context 'when all move methods returned only 1 possible move and that move is not legal' do
      before do
        allow(king_moves).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(illegal)
        allow(king_moves).to receive(:discard_illegal_moves).with(chess_board, enemy_color, illegal).and_return([])
      end

      it 'returns empty array' do
        result = king_moves.legal_moves(chess_board)
        expect(result).to be_empty
      end
    end

      context 'when all horizontal moves are possible' do
        let(:legal_moves) { [legal, legal] }

        before do
          allow(king_moves).to receive(:horizontal_move).with(chess_board, -1).and_return(legal)
          allow(king_moves).to receive(:horizontal_move).with(chess_board, 1).and_return(legal)
          allow(king_moves).to receive(:discard_illegal_moves).and_return(legal_moves)
        end

        it 'returns array of 2 legal horizontal moves' do
          result = king_moves.legal_moves(chess_board)
          expect(result).to match_array(legal_moves)
        end
      end

      context 'when all vertical moves are possible' do
        let(:legal_moves) { [legal, legal] }

        before do
          allow(king_moves).to receive(:vertical_move).with(chess_board, -1).and_return(legal)
          allow(king_moves).to receive(:vertical_move).with(chess_board, 1).and_return(legal)
          allow(king_moves).to receive(:discard_illegal_moves).and_return(legal_moves)
        end

        it 'returns array of 2 legal vertical moves' do
          result = king_moves.legal_moves(chess_board)
          expect(result).to match_array(legal_moves)
        end
      end

      context 'when all diagonal moves are possible' do
        let(:legal_moves) { [legal, legal, legal, legal] }

        before do
          allow(king_moves).to receive(:diagonal_move).with(chess_board, -1, -1).and_return(legal)
          allow(king_moves).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(legal)
          allow(king_moves).to receive(:diagonal_move).with(chess_board, -1, 1).and_return(legal)
          allow(king_moves).to receive(:diagonal_move).with(chess_board, 1, -1).and_return(legal)
          allow(king_moves).to receive(:discard_illegal_moves).and_return(legal_moves)
        end

        it 'returns array of 4 legal diagonal moves' do
          result = king_moves.legal_moves(chess_board)
          expect(result).to match_array(legal_moves)
        end
      end
    end
  end

  describe '#horizontal_move' do
    context 'when given only King on square { x: 5, y: 3 }' do
      let(:start_square_53) { instance_double(Square, position: { x: 5, y: 3 }) }
      subject(:king_53) { described_class.new(start_square_53, nil, nil) }

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

    context 'when given :white King and x = -1' do
      subject(:wht_king_54) { described_class.new(start_square_54, :white, nil) }
      let(:x) { -1 }

      context 'when move x = -1 results in square occupied by :white piece' do
        let(:start_square_54) { instance_double(Square, position: { x: 5, y: 4 }) }
        let(:white_piece) { instance_double(Piece, color: :white) }
        let(:square_44) { instance_double(Square, position: { x: 4, y: 4 }, piece: white_piece, taken?: true) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_54, x: -1).and_return(square_44)
        end

        it 'returns empty array' do
          result = wht_king_54.horizontal_move(chess_board, x)
          expect(result).to be_empty
        end
      end

      context 'when move x = -1 results in square occupied by :black piece' do
        let(:start_square_54) { instance_double(Square, position: { x: 5, y: 4 }) }
        let(:black_piece) { instance_double(Piece, color: :black) }
        let(:square_44) { instance_double(Square, position: { x: 4, y: 4 }, piece: black_piece, taken?: true) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_54, x: -1).and_return(square_44)
        end

        it 'returns array with that square inside' do
          result = wht_king_54.horizontal_move(chess_board, x)
          expected = [square_44]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when x = -1 results in move that is not on the board' do
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

    context 'when given only King on square { x: 5, y: 3 }' do
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

    context 'when given :white King and y = -1' do
      subject(:wht_king_54) { described_class.new(start_square_54, :white, nil) }
      let(:y) { -1 }

      context 'when move y = -1 results in square occupied by :white Piece' do
        let(:start_square_54) { instance_double(Square, position: { x: 5, y: 4 }) }
        let(:white_piece) { instance_double(Piece, color: :white) }
        let(:square_53) { instance_double(Square, position: { x: 5, y: 3 }, piece: white_piece, taken?: true) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_54, y: -1).and_return(square_53)
        end

        it 'returns empty array' do
          result = wht_king_54.vertical_move(chess_board, y)
          expect(result).to be_empty
        end
      end

      context 'when move y = -1 results in square occupied by :black piece' do
        let(:start_square_54) { instance_double(Square, position: { x: 5, y: 4 }) }
        let(:black_piece) { instance_double(Piece, color: :black) }
        let(:square_53) { instance_double(Square, position: { x: 5, y: 3 }, piece: black_piece, taken?: true) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_54, y: -1).and_return(square_53)
        end

        it 'returns array with that square inside' do
          result = wht_king_54.vertical_move(chess_board, y)
          expected = [square_53]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when y = -1 results in move that is not on the board' do
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
          allow(diagonal_king_44).to receive(:reject_related_squares).and_return([square_55])
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
          allow(diagonal_king_44).to receive(:reject_related_squares).and_return([square_53])
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
          allow(diagonal_king_44).to receive(:reject_related_squares).and_return([square_35])
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
          allow(diagonal_king_44).to receive(:reject_related_squares).and_return([square_33])
        end

        it 'returns square { x: 3, y: 3 }' do
          result = diagonal_king_44.diagonal_move(chess_board, -1, -1)
          expected = [square_33]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when given :white King { x: 3, y: 3 }' do
      let(:start_square_33) { instance_double(Square, position: { x: 3, y: 3 }) }
      subject(:wht_king_33) { described_class.new(start_square_33, :white) }

      before do
        allow(chess_board).to receive(:get_relative_square).with(start_square_33, x: -1, y: -1).and_return(square_22)
      end

      context 'when move x = -1, y = -1 results in a square occupied by :white Piece' do
        let(:wht_piece) { instance_double(Piece, color: :white) }
        let(:square_22) { instance_double(Square, position: { x: 2, y: 2 }, piece: wht_piece, taken?: true) }

        it 'returns empty array' do
          result = wht_king_33.diagonal_move(chess_board, -1, -1)
          expect(result).to be_empty
        end
      end

      context 'when move x = -1, y = -1 results in a square occupied by :black Piece' do
        let(:blk_piece) { instance_double(Piece, color: :black) }
        let(:square_22) { instance_double(Square, position: { x: 2, y: 2 }, piece: blk_piece, taken?: true) }

        it 'returns an array with that square inside' do
          result = wht_king_33.diagonal_move(chess_board, -1, -1)
          expected = [square_22]
          expect(result).to match_array(expected)
        end
      end
    end
  end
end