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

  describe '#possible_moves' do
    subject(:possible_rook) { described_class.new(nil, :white) }
    let(:white_piece) { double('Piece', color: :white) }
    let(:impossible_move) { [double('square', taken?: true, piece: white_piece)] }
    let(:possible_move) { [double('square', taken?: false)] }

    before do
      allow(possible_rook).to receive(:vertical_move).and_return([])
      allow(possible_rook).to receive(:horizontal_move).and_return([])
    end

    context 'when only #horizontal_move with x = 1 returns a possible and legal move' do
      before do
        allow(possible_rook).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #horizontal_move with x = -1 returns a possible and legal move' do
      before do
        allow(possible_rook).to receive(:horizontal_move).with(chess_board, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #vertical_move with y = 1 returns a possible and legal move' do
      before do
        allow(possible_rook).to receive(:vertical_move).with(chess_board, 1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #vertical_move with y = -1 returns a possible and legal move' do
      before do
        allow(possible_rook).to receive(:vertical_move).with(chess_board, -1).and_return(possible_move)
      end

      it 'returns an array with 1 legal move' do
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when there are 2 possible moves but one of them has square with Piece the same color as given Rook' do
      it 'returns an array with 1 possible legal move' do
        allow(possible_rook).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
        allow(possible_rook).to receive(:vertical_move).with(chess_board, -1).and_return(impossible_move)
        result = possible_rook.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end
  end

  describe '#horizontal_move' do
    context 'when Rook is on square { x: 4, y: 4 }' do
      let(:start_square_44) { double('square', position: { x: 4, y: 4 }) }
      subject(:rook_44) { described_class.new(start_square_44) }

      context 'when given x = 1' do
        let(:x) { 1 }

        context 'when it doesn\'t encounter any taken square' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 4 }, taken?: false),
              double('Square', position: { x: 6, y: 4 }, taken?: false),
              double('Square', position: { x: 7, y: 4 }, taken?: false),
              double('Square', position: { x: 8, y: 4 }, taken?: false)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 4).and_return(exp_sqr[3])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 5)
          end

          it 'returns 4 squares { x: 5, y: 4 }, { x: 6, y: 4 }, { x: 7, y: 4 }, { x: 8, y: 4 }' do
            result = rook_44.horizontal_move(chess_board, x)
            expect(result).to match_array(exp_sqr)
          end
        end
      end


      context 'when given x = -1' do
        let(:x) { -1 }

        context 'when it doesn\'t encounter any taken square' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 3, y: 4 }, taken?: false),
              double('Square', position: { x: 2, y: 4 }, taken?: false),
              double('Square', position: { x: 1, y: 4 }, taken?: false),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: -4)
          end

          it 'returns 4 squares { x: 3, y: 4 }, { x: 2, y: 4 }, { x: 1, y: 4 }' do
            result = rook_44.horizontal_move(chess_board, x)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when there is taken square that Rook can pass through' do
        let(:exp_sqr) do
          [
            double('Square', position: { x: 5, y: 4 }, taken?: false),
            double('Square', position: { x: 6, y: 4 }, taken?: false),
            double('Square', position: { x: 7, y: 4 }, taken?: true)
          ]
        end

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 2).and_return(exp_sqr[1])
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 3).and_return(exp_sqr[2])
        end

        it 'returns an array of squares passed by Rook until it encountered taken square, including it' do
          x = 1
          expected = exp_sqr
          result = rook_44.horizontal_move(chess_board, x)
          expect(result).to match_array(expected)
        end
      end
    end
  end

  describe '#vertical_move' do
    context 'when Rook is on square { x: 4, y: 4 }' do
      let(:start_square_44) { double('square', position: { x: 4, y: 4 }) }
      subject(:rook_44) { described_class.new(start_square_44) }

      context 'when given y = 1' do
        let(:y) { 1 }

        context 'when it doesn\'t encounter any taken square' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 5 }, taken?: false),
              double('Square', position: { x: 4, y: 6 }, taken?: false),
              double('Square', position: { x: 4, y: 7 }, taken?: false),
              double('Square', position: { x: 4, y: 8 }, taken?: false)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 4).and_return(exp_sqr[3])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 5)
          end

          it 'returns 4 squares with x: 4 and y: { 5, 6, 7, 8 } respectively' do
            result = rook_44.vertical_move(chess_board, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when given y = -1' do
        let(:y) { -1 }

        context 'when it doesn\'t encounter any taken square' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 3 }, taken?: false),
              double('Square', position: { x: 4, y: 2 }, taken?: false),
              double('Square', position: { x: 4, y: 1 }, taken?: false),
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -1).and_return(exp_sqr[0])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -2).and_return(exp_sqr[1])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -3).and_return(exp_sqr[2])
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: -4)
          end

          it 'returns 3 squares with x: 4 and y: { 3, 2, 1 } respectively' do
            result = rook_44.vertical_move(chess_board, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when there is taken square that Rook can pass through' do
        let(:exp_sqr) do
          [
            double('Square', position: { x: 4, y: 5 }, taken?: false),
            double('Square', position: { x: 4, y: 6 }, taken?: false),
            double('Square', position: { x: 4, y: 7 }, taken?: true)
          ]
        end

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 2).and_return(exp_sqr[1])
          allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 3).and_return(exp_sqr[2])
        end

        it 'returns an array of squares passed by Rook until it encountered taken square, including it' do
          y = 1
          expected = exp_sqr
          result = rook_44.vertical_move(chess_board, y)
          expect(result).to match_array(expected)
        end
      end
    end
  end
end