require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'
require_relative '../../lib/square'

describe King do
  let(:chess_board) { instance_double(Board) }

  describe '#legal_moves' do
    context 'when given King { x: 4, y: 4 }' do
    let(:start_square_44) { instance_double(Square, position: { x: 4, y: 4 }) }
    subject(:king) { described_class.new(start_square_44, nil, nil) }

    before do
      allow(king).to receive(:horizontal_move).and_return([])
      allow(king).to receive(:vertical_move).and_return([])
      allow(king).to receive(:diagonal_move).and_return([])
    end

      context 'when all horizontal moves are available' do
        let(:sqr_left) { instance_double(Square, position: { x: 3, y: 4 }) }
        let(:sqr_right) { instance_double(Square, position: { x: 5, y: 4 }) }

        before do
          allow(king).to receive(:horizontal_move).with(chess_board, -1).and_return([sqr_left])
          allow(king).to receive(:horizontal_move).with(chess_board, 1).and_return([sqr_right])
        end

        it 'returns array of 2 different horizontal squares' do
          result = king.legal_moves(chess_board)
          expected = [sqr_left, sqr_right]
          expect(result).to match_array(expected)
        end
      end

      context 'when all vertical moves are available' do
        let(:sqr_up) { instance_double(Square, position: { x: 4, y: 5 }) }
        let(:sqr_down) { instance_double(Square, position: { x: 4, y: 3 }) }

        before do
          allow(king).to receive(:vertical_move).with(chess_board, -1).and_return([sqr_down])
          allow(king).to receive(:vertical_move).with(chess_board, 1).and_return([sqr_up])
        end

        it 'returns array of 2 different vertical squares' do
          result = king.legal_moves(chess_board)
          expected = [sqr_up, sqr_down]
          expect(result).to match_array(expected)
        end
      end

      context 'when all diagonal moves are available' do
        let(:sqr_left_up) { instance_double(Square, position: { x: 3, y: 5 }) }
        let(:sqr_left_down) { instance_double(Square, position: { x: 3, y: 3 }) }
        let(:sqr_right_up) { instance_double(Square, position: { x: 5, y: 5 }) }
        let(:sqr_right_down) { instance_double(Square, position: { x: 5, y: 3 }) }

        before do
          allow(king).to receive(:diagonal_move).with(chess_board, -1, -1).and_return([sqr_left_down])
          allow(king).to receive(:diagonal_move).with(chess_board, 1, 1).and_return([sqr_right_up])
          allow(king).to receive(:diagonal_move).with(chess_board, -1, 1).and_return([sqr_left_up])
          allow(king).to receive(:diagonal_move).with(chess_board, 1, -1).and_return([sqr_right_down])
        end

        it 'returns array of 4 different diagonal squares' do
          result = king.legal_moves(chess_board)
          expected = [sqr_left_up, sqr_left_down, sqr_right_up, sqr_right_down]
          expect(result).to match_array(expected)
        end
      end
    end
  end

  describe '#horizontal_move' do
    context 'when given only King on square { x: 5, y: 3 } and x = 1' do
      let(:start_square_53) { instance_double(Square, position: { x: 5, y: 3 }) }
      subject(:king_53) { described_class.new(start_square_53, nil, nil) }
      let(:square_63) { instance_double(Square, position: { x: 6, y: 3 }, taken?: false) }

      before do
        allow(king_53).to receive(:find_relative_square).with(chess_board, x: 1).and_return(square_63)
        allow(king_53).to receive(:reject_related_squares).and_return([square_63])
      end

      it 'returns square { x: 6, y: 3 }' do
        result = king_53.horizontal_move(chess_board, 1)
        expected = [square_63]
        expect(result).to match_array(expected)
      end
    end

    context 'when given only King on square { x: 5, y: 3 } and x = -1' do
      let(:start_square_53) { instance_double(Square, position: { x: 5, y: 3 }) }
      subject(:king_53) { described_class.new(start_square_53, nil, nil) }
      let(:square_43) { instance_double(Square, position: { x: 6, y: 3 }, taken?: false) }

      before do
        allow(king_53).to receive(:find_relative_square).with(chess_board, x: -1).and_return(square_43)
        allow(king_53).to receive(:reject_related_squares).and_return([square_43])
      end

      it 'returns square { x: 4, y: 3 }' do
        result = king_53.horizontal_move(chess_board, -1)
        expected = [square_43]
        expect(result).to match_array(expected)
      end
    end

    context 'when given :white King and x = -1' do
      context 'when move x = -1 results in square occupied by :white piece' do
        let(:start_square_54) { instance_double(Square, position: { x: 5, y: 4 }) }
        subject(:wht_king_54) { described_class.new(start_square_54, :white, nil) }
        let(:white_piece) { instance_double(Piece, color: :white) }
        let(:square_44) { instance_double(Square, position: { x: 4, y: 4 }, piece: white_piece, taken?: true) }

        before do
          allow(wht_king_54).to receive(:find_relative_square).with(chess_board, x: -1).and_return(square_44)
          allow(wht_king_54).to receive(:reject_related_squares).with([square_44]).and_return([])
        end

        it 'returns empty array' do
          result = wht_king_54.horizontal_move(chess_board, -1)
          expected = []
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when given :black King and x = -1' do
      context 'when move x = -1 results in square occupied by :white piece' do
        let(:start_square_63) { instance_double(Square, position: { x: 6, y: 3 }) }
        subject(:blk_king_63) { described_class.new(start_square_63, :black, nil) }
        let(:white_piece) { instance_double(Piece, color: :white) }
        let(:square_53) { instance_double(Square, position: { x: 5, y: 3 }, piece: white_piece, taken?: true) }

        before do
          allow(blk_king_63).to receive(:find_relative_square).with(chess_board, x: -1).and_return(square_53)
          allow(blk_king_63).to receive(:reject_related_squares).and_return([square_53])
        end

        it 'returns that square with :white Piece on it' do
          result = blk_king_63.horizontal_move(chess_board, -1)
          expected = [square_53]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when x = -1 results in move that is not on the board' do
      let(:start_square_12) { instance_double(Square, position: { x: 1, y: 2 }) }
      subject(:king_12) { described_class.new(start_square_12, nil, nil) }
      let(:square_02) { nil }

      before do
        allow(king_12).to receive(:find_relative_square).with(chess_board, x: -1).and_return(square_02)
        allow(king_12).to receive(:reject_related_squares).with([]).and_return([])
      end

      it 'returns empty array' do
        result = king_12.horizontal_move(chess_board, -1)
        expected = []
        expect(result).to match_array(expected)
      end
    end
  end

  describe '#vertical_move' do
    context 'when given only King on square { x: 5, y: 3 } and y = 1' do
      let(:start_square_53) { instance_double(Square, position: { x: 5, y: 3 }) }
      subject(:king_53) { described_class.new(start_square_53, nil, nil) }
      let(:square_54) { instance_double(Square, position: { x: 5, y: 4 }, taken?: false) }

      before do
        allow(king_53).to receive(:find_relative_square).with(chess_board, y: 1).and_return(square_54)
        allow(king_53).to receive(:reject_related_squares).and_return([square_54])
      end

      it 'returns square { x: 5, y: 4 }' do
        result = king_53.vertical_move(chess_board, 1)
        expected = [square_54]
        expect(result).to match_array(expected)
      end
    end

    context 'when given only King on square { x: 5, y: 3 } and y = -1' do
      let(:start_square_53) { instance_double(Square, position: { x: 5, y: 3 }) }
      subject(:king_53) { described_class.new(start_square_53, nil, nil) }
      let(:square_52) { instance_double(Square, position: { x: 5, y: 2 }, taken?: false) }

      before do
        allow(king_53).to receive(:find_relative_square).with(chess_board, y: -1).and_return(square_52)
        allow(king_53).to receive(:reject_related_squares).and_return([square_52])
      end

      it 'returns square { x: 5, y: 2 }' do
        result = king_53.vertical_move(chess_board, -1)
        expected = [square_52]
        expect(result).to match_array(expected)
      end
    end

    context 'when given :white King and y = -1' do
      context 'when move y = -1 results in square occupied by :white Piece' do
        let(:start_square_54) { instance_double(Square, position: { x: 5, y: 4 }) }
        subject(:wht_king_54) { described_class.new(start_square_54, :white, nil) }
        let(:white_piece) { instance_double(Piece, color: :white) }
        let(:square_53) { instance_double(Square, position: { x: 5, y: 3 }, piece: white_piece, taken?: true) }

        before do
          allow(wht_king_54).to receive(:find_relative_square).with(chess_board, y: -1).and_return(square_53)
          allow(wht_king_54).to receive(:reject_related_squares).with([square_53]).and_return([])
        end

        it 'returns empty array' do
          result = wht_king_54.vertical_move(chess_board, -1)
          expected = []
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when y = -1 results in move that is not on the board' do
      let(:start_square_51) { instance_double(Square, position: { x: 5, y: 1 }) }
      subject(:king_51) { described_class.new(start_square_51, nil, nil) }

      before do
        allow(king_51).to receive(:find_relative_square).with(chess_board, y: -1).and_return(nil)
        allow(king_51).to receive(:reject_related_squares).with([]).and_return([])
      end

      it 'returns empty array' do
        result = king_51.vertical_move(chess_board, -1)
        expected = []
        expect(result).to match_array(expected)
      end
    end
  end

  describe '#diagonal_move' do
    context 'when given only King on square { x: 4, y: 4 }' do
      let(:start_square_44) { instance_double(Square, position: { x: 4, y: 4 }) }
      subject(:diagonal_king_44) { described_class.new(start_square_44) }

      context 'x = 1, y = 1' do
        let(:square55) { instance_double(Square, position: { x: 5, y: 5 }) }

        before do
          allow(diagonal_king_44).to receive(:find_relative_square).with(chess_board, x: 1, y: 1).and_return(square55)
          allow(diagonal_king_44).to receive(:reject_related_squares).and_return([square55])
        end

        it 'returns square { x: 5, y: 5 }' do
          result = diagonal_king_44.diagonal_move(chess_board, 1, 1)
          expected = [square55]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = 1, y = -1' do
        let(:square53) { instance_double(Square, position: { x: 5, y: 3 }) }

        before do
          allow(diagonal_king_44).to receive(:find_relative_square).with(chess_board, x: 1, y: -1).and_return(square53)
          allow(diagonal_king_44).to receive(:reject_related_squares).and_return([square53])
        end

        it 'returns square { x: 5, y: 3 }' do
          result = diagonal_king_44.diagonal_move(chess_board, 1, -1)
          expected = [square53]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = -1, y = 1' do
        let(:square35) { instance_double(Square, position: { x: 3, y: 5 }) }

        before do
          allow(diagonal_king_44).to receive(:find_relative_square).with(chess_board, x: -1, y: 1).and_return(square35)
          allow(diagonal_king_44).to receive(:reject_related_squares).and_return([square35])
        end

        it 'returns square { x: 3, y: 5 }' do
          result = diagonal_king_44.diagonal_move(chess_board, -1, 1)
          expected = [square35]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = -1, y = -1' do
        let(:square33) { instance_double(Square, position: { x: 3, y: 3 }) }

        before do
          allow(diagonal_king_44).to receive(:find_relative_square).with(chess_board, x: -1, y: -1).and_return(square33)
          allow(diagonal_king_44).to receive(:reject_related_squares).and_return([square33])
        end

        it 'returns square { x: 3, y: 3 }' do
          result = diagonal_king_44.diagonal_move(chess_board, -1, -1)
          expected = [square33]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when given :white King { x: 3, y: 3 } and x = -1, y = -1' do
      let(:start_square_33) { instance_double(Square, position: { x: 3, y: 3 }) }
      subject(:wht_king_33) { described_class.new(start_square_33, :white) }

      context 'when :black Piece is on square that King moves to' do
        let(:blk_piece) { instance_double(Piece, color: :black) }
        let(:square22) { instance_double(Square, position: { x: 2, y: 2 }, piece: blk_piece, taken?: true) }

        before do
          allow(wht_king_33).to receive(:find_relative_square).with(chess_board, x: -1, y: -1).and_return(square22)
          allow(wht_king_33).to receive(:reject_related_squares).with([square22]).and_return([square22])
        end

        it 'returns that square with :black Piece' do
          result = wht_king_33.diagonal_move(chess_board, -1, -1)
          expected = [square22]
          expect(result).to match_array(expected)
        end
      end

      context 'when another :white Piece is on square that King moves to' do
        let(:wht_piece) { instance_double(Piece, color: :white) }
        let(:square22) { instance_double(Square, position: { x: 2, y: 2 }, piece: wht_piece, taken?: true) }

        before do
          allow(wht_king_33).to receive(:find_relative_square).with(chess_board, x: -1, y: -1).and_return(square22)
          allow(wht_king_33).to receive(:reject_related_squares).with([square22]).and_return([])
        end

        it 'returns empty array' do
          result = wht_king_33.diagonal_move(chess_board, -1, -1)
          expected = []
          expect(result).to match_array(expected)
        end
      end
    end
  end
end