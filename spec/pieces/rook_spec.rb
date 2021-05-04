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

  describe '#legal_moves' do
    subject(:rook_moves) { described_class.new(nil, :white) }
    let(:moves) { [double('square'), double('square')] }
    let(:enemy_color) { :black }
    let(:illegal) { [moves.first] }
    let(:legal) { [moves.last] }

    before do
      allow(rook_moves).to receive(:vertical_move).and_return([])
      allow(rook_moves).to receive(:horizontal_move).and_return([])
    end

    context 'when all move methods returned 2 moves and only 1 of them is legal' do
      before do
        allow(rook_moves).to receive(:horizontal_move).with(chess_board, 1).and_return(illegal)
        allow(rook_moves).to receive(:vertical_move).with(chess_board, -1).and_return(legal)
        allow(rook_moves).to receive(:discard_illegal_moves).with(chess_board, enemy_color, moves).and_return(legal)
      end

      it 'returns only that 1 legal move' do
        result = rook_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end

    context 'when all move methods returned 1 move and that move is not legal' do
      before do
        allow(rook_moves).to receive(:horizontal_move).with(chess_board, 1).and_return(illegal)
        allow(rook_moves).to receive(:discard_illegal_moves).with(chess_board, enemy_color, illegal).and_return([])
      end

      it 'returns empty array' do
        result = rook_moves.legal_moves(chess_board)
        expect(result).to be_empty
      end
    end

    context 'when only #horizontal_move with x = 1 returns a possible and legal move' do
      before do
        x = 1
        allow(rook_moves).to receive(:horizontal_move).with(chess_board, x).and_return(legal)
        allow(rook_moves).to receive(:discard_illegal_moves).and_return(legal)
      end

      it 'returns an array with 1 legal move' do
        result = rook_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end

    context 'when only #horizontal_move with x = -1 returns a possible and legal move' do
      before do
        x = -1
        allow(rook_moves).to receive(:horizontal_move).with(chess_board, x).and_return(legal)
        allow(rook_moves).to receive(:discard_illegal_moves).and_return(legal)
      end

      it 'returns an array with 1 legal move' do
        result = rook_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end

    context 'when only #vertical_move with y = 1 returns a possible and legal move' do
      before do
        y = 1
        allow(rook_moves).to receive(:vertical_move).with(chess_board, y).and_return(legal)
        allow(rook_moves).to receive(:discard_illegal_moves).and_return(legal)
      end

      it 'returns an array with 1 legal move' do
        result = rook_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end

    context 'when only #vertical_move with y = -1 returns a possible and legal move' do
      before do
        y = -1
        allow(rook_moves).to receive(:vertical_move).with(chess_board, y).and_return(legal)
        allow(rook_moves).to receive(:discard_illegal_moves).and_return(legal)
      end

      it 'returns an array with 1 legal move' do
        result = rook_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end
  end

  describe '#horizontal_move' do
    before do
      allow(chess_board).to receive(:get_relative_square)
    end

    context 'when :white Rook is on square { x: 4, y: 4 }' do
      let(:start_square_44) { double('square', position: { x: 4, y: 4 }) }
      subject(:wht_rook_44) { described_class.new(start_square_44, :white) }

      context 'when given x = 1' do
        let(:x) { 1 }

        context 'when only that one Rook piece is on Board' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 4 }, taken?: false, piece: nil),
              double('Square', position: { x: 6, y: 4 }, taken?: false, piece: nil),
              double('Square', position: { x: 7, y: 4 }, taken?: false, piece: nil),
              double('Square', position: { x: 8, y: 4 }, taken?: false, piece: nil)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 4).and_return(exp_sqr[3])
          end

          it 'returns 4 squares { x: 5, y: 4 }, { x: 6, y: 4 }, { x: 7, y: 4 }, { x: 8, y: 4 }' do
            result = wht_rook_44.horizontal_move(chess_board, x)
            expect(result).to match_array(exp_sqr)
          end
        end
      end


      context 'when given x = -1' do
        let(:x) { -1 }

        context 'when only that one Rook piece is on Board' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 3, y: 4 }, taken?: false, piece: nil),
              double('Square', position: { x: 2, y: 4 }, taken?: false, piece: nil),
              double('Square', position: { x: 1, y: 4 }, taken?: false, piece: nil),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -3).and_return(exp_sqr[2])
          end

          it 'returns 4 squares { x: 3, y: 4 }, { x: 2, y: 4 }, { x: 1, y: 4 }' do
            result = wht_rook_44.horizontal_move(chess_board, x)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when there is :black Piece on square that Rook can pass through' do
        let(:blk_piece) { double('piece', color: :black) }
        let(:exp_sqr) do
          [
            double('Square', position: { x: 5, y: 4 }, taken?: false, piece: nil),
            double('Square', position: { x: 6, y: 4 }, taken?: false, piece: nil),
            double('Square', position: { x: 7, y: 4 }, taken?: true, piece: blk_piece)
          ]
        end

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 2).and_return(exp_sqr[1])
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 3).and_return(exp_sqr[2])
        end

        it 'returns an array of squares passed by Rook until it encountered :black Piece, including it' do
          x = 1
          expected = exp_sqr
          result = wht_rook_44.horizontal_move(chess_board, x)
          expect(result).to match_array(expected)
        end
      end

      context 'when there is another :white Piece on square that Rook can pass through' do
        let(:wht_piece) { double('piece', color: :white) }

        context 'when Rook has already passed a few squares' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 4 }, taken?: false, piece: nil),
              double('Square', position: { x: 6, y: 4 }, taken?: false, piece: nil),
              double('Square', position: { x: 7, y: 4 }, taken?: true, piece: wht_piece)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 3).and_return(exp_sqr[2])
          end

          it 'returns an array of squares passed by Rook until it encountered another :white Piece, excluding it' do
            x = 1
            expected = exp_sqr.first(2)
            result = wht_rook_44.horizontal_move(chess_board, x)
            expect(result).to match_array(expected)
          end
        end

        context 'when Rook hasn\'t made any move yet before encountering that square' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 4 }, taken?: true, piece: wht_piece),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
          end

          it 'returns an empty array' do
            x = 1
            result = wht_rook_44.horizontal_move(chess_board, x)
            expect(result).to be_empty
          end
        end
      end
    end
  end

  describe '#vertical_move' do
    before do
      allow(chess_board).to receive(:get_relative_square)
    end

    context 'when :white Rook is on square { x: 4, y: 4 }' do
      let(:start_square_44) { double('square', position: { x: 4, y: 4 }) }
      subject(:wht_rook_44) { described_class.new(start_square_44, :white) }

      context 'when given y = 1' do
        let(:y) { 1 }

        context 'when only that one Rook piece is on Board' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 5 }, taken?: false, piece: nil),
              double('Square', position: { x: 4, y: 6 }, taken?: false, piece: nil),
              double('Square', position: { x: 4, y: 7 }, taken?: false, piece: nil),
              double('Square', position: { x: 4, y: 8 }, taken?: false, piece: nil)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 4).and_return(exp_sqr[3])
          end

          it 'returns 4 squares with x: 4 and y: { 5, 6, 7, 8 } respectively' do
            result = wht_rook_44.vertical_move(chess_board, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when given y = -1' do
        let(:y) { -1 }

        context 'when only that one Rook piece is on Board' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 3 }, taken?: false, piece: nil),
              double('Square', position: { x: 4, y: 2 }, taken?: false, piece: nil),
              double('Square', position: { x: 4, y: 1 }, taken?: false, piece: nil),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -3).and_return(exp_sqr[2])
          end

          it 'returns 3 squares with x: 4 and y: { 3, 2, 1 } respectively' do
            result = wht_rook_44.vertical_move(chess_board, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when there is :black Piece on square that Rook can pass through' do
        let(:blk_piece) { double('piece', color: :black) }
        let(:exp_sqr) do
          [
            double('Square', position: { x: 4, y: 5 }, taken?: false, piece: nil),
            double('Square', position: { x: 4, y: 6 }, taken?: false, piece: nil),
            double('Square', position: { x: 4, y: 7 }, taken?: true, piece: blk_piece)
          ]
        end

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 2).and_return(exp_sqr[1])
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 3).and_return(exp_sqr[2])
        end

        it 'returns an array of squares passed by Rook until it encountered :black Piece, including it' do
          y = 1
          expected = exp_sqr
          result = wht_rook_44.vertical_move(chess_board, y)
          expect(result).to match_array(expected)
        end
      end

      context 'when there is another :white Piece on square that Rook can pass through' do
        let(:wht_piece) { double('piece', color: :white) }

        context 'when Rook has already passed a few squares' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 5 }, taken?: false, piece: nil),
              double('Square', position: { x: 4, y: 6 }, taken?: false, piece: nil),
              double('Square', position: { x: 4, y: 7 }, taken?: true, piece: wht_piece)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 3).and_return(exp_sqr[2])
          end

          it 'returns an array of squares passed by Rook until it encountered another :white Piece, excluding it' do
            y = 1
            expected = exp_sqr.first(2)
            result = wht_rook_44.vertical_move(chess_board, y)
            expect(result).to match_array(expected)
          end
        end

        context 'when Rook hasn\'t made any move yet before encountering that square' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 5 }, taken?: true, piece: wht_piece),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
          end

          it 'returns an empty array' do
            y = 1
            result = wht_rook_44.vertical_move(chess_board, y)
            expect(result).to be_empty
          end
        end
      end
    end
  end
end