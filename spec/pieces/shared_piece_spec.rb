RSpec.shared_examples 'base class methods names' do
  context 'when method is from the base class' do
    it 'responds to #move' do
      expect(subject).to respond_to(:move)
    end

    it 'responds to #discard_illegal_moves' do
      expect(subject).to respond_to(:discard_illegal_moves)
    end
  end
end

RSpec.shared_examples 'shared method names' do
  context 'when method names are the same' do
    it 'responds to #legal_moves' do
      expect(subject).to respond_to(:legal_moves)
    end
  end
end

RSpec.shared_examples '#horizontal_move method' do
  describe '#horizontal_move' do
    context 'when given Piece is on square { x: 4, y: 4 }' do
      let(:start_square_44) { double('square', position: { x: 4, y: 4 }) }
      subject(:piece_44) { described_class.new(start_square_44) }

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
            result = piece_44.horizontal_move(chess_board, x)
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
            result = piece_44.horizontal_move(chess_board, x)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when there is taken square that Piece can pass through' do
        context 'when that taken square is first square that Piece can pass through' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 4 }, taken?: true)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, x: 1).and_return(exp_sqr[0])
          end

          it 'returns that first square' do
            x = 1
            expected = exp_sqr
            result = piece_44.horizontal_move(chess_board, x)
            expect(result).to match_array(expected)
          end
        end

        context 'when Piece has already passed the first square' do
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

          it 'returns an array of squares passed by Piece until it encountered taken square, including it' do
            x = 1
            expected = exp_sqr
            result = piece_44.horizontal_move(chess_board, x)
            expect(result).to match_array(expected)
          end
        end
      end

    end
  end
end

RSpec.shared_examples '#vertical_move method' do
  describe '#vertical_move' do
    context 'when Piece is on square { x: 4, y: 4 }' do
      let(:start_square_44) { double('square', position: { x: 4, y: 4 }) }
      subject(:piece_44) { described_class.new(start_square_44) }

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
            result = piece_44.vertical_move(chess_board, y)
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
            result = piece_44.vertical_move(chess_board, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when there is taken square that Piece can pass through' do
        context 'when that taken square is first square that Piece can pass through' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 4, y: 5 }, taken?: true)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_square_44, y: 1).and_return(exp_sqr[0])
          end

          it 'returns that first square' do
            y = 1
            expected = exp_sqr
            result = piece_44.vertical_move(chess_board, y)
            expect(result).to match_array(expected)
          end
        end

        context 'when Piece has already passed the first square' do
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

          it 'returns an array of squares passed by Piece until it encountered taken square, including it' do
            y = 1
            expected = exp_sqr
            result = piece_44.vertical_move(chess_board, y)
            expect(result).to match_array(expected)
          end
        end
      end
    end
  end
end

RSpec.shared_examples '#diagonal_move method' do
  describe '#diagonal_move' do
    context 'when given Piece on square { x: 4, y: 4 }' do
      let(:start_sqr_44) { double('Square', position: { x: 4, y: 4 }) }
      subject(:piece_44) { described_class.new(start_sqr_44) }

      context 'when given x = 1, y = 1' do
        let(:x) { 1 }
        let(:y) { 1 }

        context 'when it doesn\'t encounter any taken square' do
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
            result = piece_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when given x = -1, y = 1' do
        let(:x) { -1 }
        let(:y) { 1 }

        context 'when it doesn\'t encounter any taken square' do
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
            result = piece_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when given x = 1, y = -1' do
        let(:x) { 1 }
        let(:y) { -1 }

        context 'when it doesn\'t encounter any taken square' do
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
            result = piece_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when given x = -1, y = -1' do
        let(:x) { -1 }
        let(:y) { -1 }

        context 'when it doesn\'t encounter any taken square' do
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
            result = piece_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(exp_sqr)
          end
        end
      end

      context 'when there is taken square that Piece can pass through' do
        context 'when that taken square is first square that Piece can pass through' do
          let(:exp_sqr) do
            [
              double('Square', position: { x: 5, y: 5 }, taken?: true)
            ]
          end

          before do
            allow(chess_board).to receive(:get_relative_square).with(start_sqr_44, x: 1, y: 1).and_return(exp_sqr[0])
          end

          it 'returns that first square' do
            x = 1
            y = 1
            expected = exp_sqr
            result = piece_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(expected)
          end
        end

        context 'when Piece has already passed the first square' do
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

          it 'returns an array of squares passed by Piece until it encountered taken square, including it' do
            x = 1
            y = 1
            expected = exp_sqr
            result = piece_44.diagonal_move(chess_board, x, y)
            expect(result).to match_array(expected)
          end
        end
      end
    end
  end
end