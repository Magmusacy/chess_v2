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

  describe '#diagonal_move' do
    context 'when given Bishop on square { x: 4, y: 4 }' do
      let(:start_sqr_44) { double('Square', position: { x: 4, y: 4 }) }
      subject(:bishop_44) { described_class.new(start_sqr_44) }

      context 'when given x = 1, y = 1' do
        let(:x) { 1 }
        let(:y) { 1 }

        context 'when only Piece on Board is given Bishop' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 5 }, taken?: false),
              double('Square', position: { x: 6, y: 6 }, taken?: false),
              double('Square', position: { x: 7, y: 7 }, taken?: false),
              double('Square', position: { x: 8, y: 8 }, taken?: false)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 1, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 2, y: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 3, y: 3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 4, y: 4).and_return(exp_sqr[3])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 5, y: 5)
          end

          it 'returns 4 squares { x: 5, y: 5 }, { x: 6, y: 6 }, { x: 7, y: 7 }, { x: 8, y: 8 }' do
            result = bishop_44.diagonal_move(chess_board, x, y)
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
              double('Square', position: { x: 3, y: 5 }, taken?: false),
              double('Square', position: { x: 2, y: 6 }, taken?: false),
              double('Square', position: { x: 1, y: 7 }, taken?: false),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -1, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -2, y: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -3, y: 3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -4, y: 4)
          end

          it 'returns 3 squares { x: 3, y: 5 }, { x: 2, y: 6 }, { x: 1, y: 7 }' do
            result = bishop_44.diagonal_move(chess_board, x, y)
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
              double('Square', position: { x: 5, y: 3 }, taken?: false),
              double('Square', position: { x: 6, y: 2 }, taken?: false),
              double('Square', position: { x: 7, y: 1 }, taken?: false),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 1, y: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 2, y: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 3, y: -3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 4, y: -4)
          end

          it 'returns 3 squares { x: 5, y: 3 }, { x: 6, y: 2 }, { x: 7, y: 1 }' do
            result = bishop_44.diagonal_move(chess_board, x, y)
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
              double('Square', position: { x: 3, y: 3 }, taken?: false),
              double('Square', position: { x: 2, y: 2 }, taken?: false),
              double('Square', position: { x: 1, y: 1 }, taken?: false),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -1, y: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -2, y: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -3, y: -3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: -4, y: -4)
          end

          it 'returns 3 squares { x: 3, y: 3 }, { x: 2, y: 2 }, { x: 1, y: 1 }' do
            result = bishop_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when there is taken square that Bishop can pass through' do
        let(:x) { 1 }
        let(:y) { 1 }
        let(:blk_piece) { double('piece', color: :black) }
        let(:exp_sqr) do
          [
            double('Square', position: { x: 5, y: 5 }, taken?: false),
            double('Square', position: { x: 6, y: 6 }, taken?: false),
            double('Square', position: { x: 7, y: 7 }, taken?: true)
          ]
        end

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 1, y: 1).and_return(exp_sqr[0])
          allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 2, y: 2).and_return(exp_sqr[1])
          allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 3, y: 3).and_return(exp_sqr[2])
        end

        it 'returns an array of squares passed by Bishop until it encountered taken square, including it' do
          expected = exp_sqr
          result = bishop_44.diagonal_move(chess_board, x, y)
          expect(result).to match_array(expected)
        end
      end
    end
  end
end