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
    subject(:rook_moves) { described_class.new }
    let(:move_square) { double('square') }

    context 'when invoked #horizontal_move 2 times, with x = 1 and x = -1' do
      context 'when #horizontal_move returns 1 move square' do

        before do
          allow(rook_moves).to receive(:vertical_move).and_return([])
          allow(rook_moves).to receive(:horizontal_move).with(chess_board, 1).and_return(move_square)
          allow(rook_moves).to receive(:horizontal_move).with(chess_board, -1).and_return(move_square)
        end

        it 'returns an array with 2 move squares' do
          result = rook_moves.legal_moves(chess_board)
          expect(result).to match_array([move_square, move_square])
        end
      end
    end

    context 'when invoked #vertical_move 2 times, with y = 1 and y = -1' do
      context 'when #vertical_move returns 1 move square' do

        before do
          allow(rook_moves).to receive(:horizontal_move).and_return([])
          allow(rook_moves).to receive(:vertical_move).with(chess_board, 1).and_return(move_square)
          allow(rook_moves).to receive(:vertical_move).with(chess_board, -1).and_return(move_square)
        end

        it 'returns an array with 2 move squares' do
          result = rook_moves.legal_moves(chess_board)
          expect(result).to match_array([move_square, move_square])
        end
      end
    end
  end

  describe '#horizontal_move' do
    context 'when :white Rook is on square { x: 4, y: 4 }' do
      let(:start_square_44) { double('square', position: { x: 4, y: 4 }) }
      subject(:rook_44) { described_class.new(start_square_44, :white) }

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
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 4).and_return(exp_sqr[3])
          end

          it 'returns 4 squares with x: { 5, 6, 7, 8 } respectively and y: 4' do
            result = rook_44.horizontal_move(chess_board, x)
            expect(result).to match_array(exp_sqr)
          end
        end

        context 'when only square { x: 6, y: 4 } is taken by :black Piece' do
          let(:blk_piece) { double('piece', color: :black) }
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 4 }, taken?: false, piece: nil),
              double('Square', position: { x: 6, y: 4 }, taken?: true, piece: blk_piece)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 2).and_return(exp_sqr[1])
          end

          it 'returns 2 squares with x: { 5, 6 } respectively and y: 4' do
            result = rook_44.horizontal_move(chess_board, x)
            expect(result).to match_array(exp_sqr)
          end
        end

        context 'when square { x: 5, y: 4 } is taken by Piece with :white color' do
          let(:wht_piece) { double('piece', color: :white) }
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 4 }, taken?: true, piece: wht_piece),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
          end

          it 'returns empty array' do
            result = rook_44.horizontal_move(chess_board, x)
            expect(result).to be_empty
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
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -3).and_return(exp_sqr[2])
          end

          it 'returns 4 squares with x: { 3, 2, 1 } respectively and y: 4' do
            result = rook_44.horizontal_move(chess_board, x)
            expect(result).to match_array(exp_sqr)
          end
        end

        context 'when only square { x: 2, y: 4 } is taken by :black Piece' do
          let(:blk_piece) { double('piece', color: :black) }
          let(:exp_sqr) do
            [
              double('Square', position: { x: 3, y: 4 }, taken?: false, piece: nil),
              double('Square', position: { x: 2, y: 4 }, taken?: true, piece: blk_piece)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -2).and_return(exp_sqr[1])
          end

          it 'returns 2 squares with x: { 3, 2 } respectively and y: 4' do
            result = rook_44.horizontal_move(chess_board, x)
            expect(result).to match_array(exp_sqr)
          end
        end

        context 'when square { x: 3, y: 4 } is taken by Piece with :white color' do
          let(:wht_piece) { double('piece', color: :white) }
          let(:exp_sqr) do
            [
              double('Square', position: { x: 3, y: 4 }, taken?: true, piece: wht_piece),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -1).and_return(exp_sqr[0])
          end

          it 'returns empty array' do
            result = rook_44.horizontal_move(chess_board, x)
            expect(result).to be_empty
          end
        end
      end
    end
  end

  describe '#vertical_move' do
    context 'when :white Rook is on square { x: 4, y: 4 }' do
      let(:start_square_44) { double('square', position: { x: 4, y: 4 }) }
      subject(:rook_44) { described_class.new(start_square_44, :white) }

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
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 4).and_return(exp_sqr[3])
          end

          it 'returns 4 squares with x: 4 and y: { 5, 6, 7, 8 } respectively' do
            result = rook_44.vertical_move(chess_board, y)
            expect(result).to match_array(exp_sqr)
          end
        end

        context 'when only square { x: 4, y: 6 } is taken by :black Piece' do
          let(:blk_piece) { double('piece', color: :black) }
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 5 }, taken?: false, piece: nil),
              double('Square', position: { x: 4, y: 6 }, taken?: true, piece: blk_piece)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 2).and_return(exp_sqr[1])
          end

          it 'returns 2 squares with x: 4 and y: { 5, 6 } respectively' do
            result = rook_44.vertical_move(chess_board, y)
            expect(result).to match_array(exp_sqr)
          end
        end

        context 'when square { x: 4, y: 5 } is taken by Piece with :white color' do
          let(:wht_piece) { double('piece', color: :white) }
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 5 }, taken?: true, piece: wht_piece),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
          end

          it 'returns empty array' do
            result = rook_44.vertical_move(chess_board, y)
            expect(result).to be_empty
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
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -3).and_return(exp_sqr[2])
          end

          it 'returns 3 squares with x: 4 and y: { 3, 2, 1 } respectively' do
            result = rook_44.vertical_move(chess_board, y)
            expect(result).to match_array(exp_sqr)
          end
        end

        context 'when only square { x: 4, y: 2 } is taken by :black Piece' do
          let(:blk_piece) { double('piece', color: :black) }
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 3 }, taken?: false, piece: nil),
              double('Square', position: { x: 4, y: 2 }, taken?: true, piece: blk_piece)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -2).and_return(exp_sqr[1])
          end

          it 'returns 2 squares with x: 4 and y: { 3, 2 } respectively' do
            result = rook_44.vertical_move(chess_board, y)
            expect(result).to match_array(exp_sqr)
          end
        end

        context 'when square { x: 4, y: 3 } is taken by Piece with :white color' do
          let(:wht_piece) { double('piece', color: :white) }
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 3 }, taken?: true, piece: wht_piece),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square)
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -1).and_return(exp_sqr[0])
          end

          it 'returns empty array' do
            result = rook_44.vertical_move(chess_board, y)
            expect(result).to be_empty
          end
        end
      end
    end
  end
end