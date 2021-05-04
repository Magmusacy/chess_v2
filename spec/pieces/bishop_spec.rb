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

  describe '#legal_moves' do
    subject(:bishop_moves) { described_class.new(nil, :white) }
    let(:moves) { [double('square'), double('square')] }
    let(:enemy_color) { :black }
    let(:illegal) { [moves.first] }
    let(:legal) { [moves.last] }

    before do
      allow(bishop_moves).to receive(:diagonal_move).and_return([])
    end

    context 'when all move methods returned 2 moves and only 1 of them is legal' do
      before do
        allow(bishop_moves).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(illegal)
        allow(bishop_moves).to receive(:diagonal_move).with(chess_board, -1, -1).and_return(legal)
        allow(bishop_moves).to receive(:discard_illegal_moves).with(chess_board, enemy_color, moves).and_return(legal)
      end

      it 'returns only that 1 legal move' do
        result = bishop_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end

    context 'when all move methods returned 1 move and that move is not legal' do
      before do
        allow(bishop_moves).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(illegal)
        allow(bishop_moves).to receive(:discard_illegal_moves).with(chess_board, enemy_color, illegal).and_return([])
      end

      it 'returns empty array' do
        result = bishop_moves.legal_moves(chess_board)
        expect(result).to be_empty
      end
    end


    context 'when only #diagonal_move with x = 1, y = 1 returns a possible and legal move' do
      before do
        x = 1
        y = 1
        allow(bishop_moves).to receive(:diagonal_move).with(chess_board, x, y).and_return(legal)
        allow(bishop_moves).to receive(:discard_illegal_moves).and_return(legal)
      end

      it 'returns an array with 1 legal move' do
        result = bishop_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end

    context 'when only #diagonal_move with x = 1, y = -1 returns a possible and legal move' do
      before do
        x = 1
        y = -1
        allow(bishop_moves).to receive(:diagonal_move).with(chess_board, x, y).and_return(legal)
        allow(bishop_moves).to receive(:discard_illegal_moves).and_return(legal)
      end

      it 'returns an array with 1 legal move' do
        result = bishop_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end

    context 'when only #diagonal_move with x = -1, y = 1 returns a possible and legal move' do
      before do
        x = -1
        y = 1
        allow(bishop_moves).to receive(:diagonal_move).with(chess_board, x, y).and_return(legal)
        allow(bishop_moves).to receive(:discard_illegal_moves).and_return(legal)
      end

      it 'returns an array with 1 legal move' do
        result = bishop_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end

    context 'when only #diagonal_move with x = -1, y = -1 returns a possible and legal move' do
      before do
        x = -1
        y = -1
        allow(bishop_moves).to receive(:diagonal_move).with(chess_board, x, y).and_return(legal)
        allow(bishop_moves).to receive(:discard_illegal_moves).and_return(legal)
      end

      it 'returns an array with 1 legal move' do
        result = bishop_moves.legal_moves(chess_board)
        expect(result).to match_array(legal)
      end
    end
  end

  describe '#diagonal_move' do
    before do
      allow(chess_board).to receive(:get_relative_square)
    end

    context 'when given :white Bishop on square { x: 4, y: 4 }' do
      let(:start_sqr_44) { double('Square', position: { x: 4, y: 4 }) }
      subject(:wht_bishop_44) { described_class.new(start_sqr_44, :white) }

      context 'when given x = 1, y = 1' do
        let(:x) { 1 }
        let(:y) { 1 }

        context 'when only Piece on Board is given Bishop' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 5 }, taken?: false, piece: nil),
              double('Square', position: { x: 6, y: 6 }, taken?: false, piece: nil),
              double('Square', position: { x: 7, y: 7 }, taken?: false, piece: nil),
              double('Square', position: { x: 8, y: 8 }, taken?: false, piece: nil)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 1, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 2, y: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 3, y: 3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 4, y: 4).and_return(exp_sqr[3])
          end

          it 'returns 4 squares { x: 5, y: 5 }, { x: 6, y: 6 }, { x: 7, y: 7 }, { x: 8, y: 8 }' do
            result = wht_bishop_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when given x = -1, y = 1' do
        let(:x) { -1 }
        let(:y) { 1 }

        context 'when only Piece on Board is given Bishop' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 3, y: 5 }, taken?: false, piece: nil),
              double('Square', position: { x: 2, y: 6 }, taken?: false, piece: nil),
              double('Square', position: { x: 1, y: 7 }, taken?: false, piece: nil),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -1, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -2, y: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -3, y: 3).and_return(exp_sqr[2])
          end

          it 'returns 3 squares { x: 3, y: 5 }, { x: 2, y: 6 }, { x: 1, y: 7 }' do
            result = wht_bishop_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when given x = 1, y = -1' do
        let(:x) { 1 }
        let(:y) { -1 }
        context 'when only Piece on Board is given Bishop' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 3 }, taken?: false, piece: nil),
              double('Square', position: { x: 6, y: 2 }, taken?: false, piece: nil),
              double('Square', position: { x: 7, y: 1 }, taken?: false, piece: nil),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 1, y: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 2, y: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 3, y: -3).and_return(exp_sqr[2])
          end

          it 'returns 3 squares { x: 5, y: 3 }, { x: 6, y: 2 }, { x: 7, y: 1 }' do
            result = wht_bishop_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when given x = -1, y = -1' do
        let(:x) { -1 }
        let(:y) { -1 }
        context 'when only Piece on Board is given Bishop' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 3, y: 3 }, taken?: false, piece: nil),
              double('Square', position: { x: 2, y: 2 }, taken?: false, piece: nil),
              double('Square', position: { x: 1, y: 1 }, taken?: false, piece: nil),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -1, y: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -2, y: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -3, y: -3).and_return(exp_sqr[2])
          end

          it 'returns 3 squares { x: 3, y: 3 }, { x: 2, y: 2 }, { x: 1, y: 1 }' do
            result = wht_bishop_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when there is :black Piece on square that Bishop can pass through' do
        let(:blk_piece) { double('piece', color: :black) }
        let(:exp_sqr) do
          [
            double('Square', position: { x: 5, y: 5 }, taken?: false, piece: nil),
            double('Square', position: { x: 6, y: 6 }, taken?: false, piece: nil),
            double('Square', position: { x: 7, y: 7 }, taken?: true, piece: blk_piece)
          ]
        end

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 1, y: 1).and_return(exp_sqr[0])
          allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 2, y: 2).and_return(exp_sqr[1])
          allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 3, y: 3).and_return(exp_sqr[2])
        end

        it 'returns an array of squares passed by Bishop until it encountered :black Piece, including it' do
          x = 1
          y = 1
          expected = exp_sqr
          result = wht_bishop_44.diagonal_move(chess_board, x, y)
          expect(result).to match_array(expected)
        end
      end

      context 'when there is another :white Piece on square that Bishop can pass through' do
        let(:wht_piece) { double('piece', color: :white) }

        context 'when Bishop has already passed a few squares' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 5 }, taken?: false, piece: nil),
              double('Square', position: { x: 6, y: 6 }, taken?: false, piece: nil),
              double('Square', position: { x: 7, y: 7 }, taken?: true, piece: wht_piece)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 1, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 2, y: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 3, y: 3).and_return(exp_sqr[2])
          end

          it 'returns an array of squares passed by Bishop until it encountered another :white Piece, excluding it' do
            x = 1
            y = 1
            expected = exp_sqr.first(2)
            result = wht_bishop_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(expected)
          end
        end

        context 'when Bishop hasn\'t made any move yet before encountering that square' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 5 }, taken?: true, piece: wht_piece),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 1, y: 1).and_return(exp_sqr[0])
          end

          it 'returns an empty array' do
            x = 1
            y = 1
            result = wht_bishop_44.diagonal_move(chess_board, x, y)
            expect(result).to be_empty
          end
        end
      end
    end
  end
end