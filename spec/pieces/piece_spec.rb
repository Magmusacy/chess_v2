require_relative '../../lib/pieces/piece'
require_relative '../../lib/square'
require_relative '../../lib/board'

describe Piece do
  let(:board) { instance_double(Board) }

  describe '#move' do
    let(:start_square) { instance_double(Square) }
    subject(:piece) { described_class.new(start_square) }
    let(:square) { instance_double(Square) }
    let(:move_array) { [start_square, square] }

    before do
      allow(square).to receive(:update_piece).with(piece)
      allow(start_square).to receive(:update_piece)
      allow(board).to receive(:add_move).with(move_array)
      allow(piece).to receive(:update_location)
    end

    it 'sends :add_move message to Board with [location, square] argument' do
      expect(board).to receive(:add_move).with(move_array)
      piece.move(square, board)
    end

    it 'sends :update_piece message with self to given square' do
      expect(square).to receive(:update_piece).with(piece)
      piece.move(square, board)
    end

    it 'sends :update_piece message without any args to self location' do
      expect(start_square).to receive(:update_piece).with(no_args)
      piece.move(square, board)
    end

    it 'calls #update_location method with given square as an argument' do
      expect(piece).to receive(:update_location).with(square)
      piece.move(square, board)
    end
  end

  describe '#update_location' do
    context 'when given square object' do
      subject(:piece) { described_class.new }
      let(:new_square) { instance_double(Square) }

      it 'updates @location variable to that given square' do
        expect { piece.update_location(new_square) }.to change { piece.location }.to(new_square)
      end
    end
  end

  describe '#clone_move' do
    let(:clone_board) { instance_double(Board) }
    let(:real_board) { instance_double(Board) }
    let(:clone_square) { instance_double(Square, piece: nil) }
    let(:real_square) { instance_double(Square, piece: nil) }
    let(:clone_piece) { instance_double(Piece) }
    subject(:real_piece) { described_class.new(nil, :white, nil) }

    # self note:
    # #clone method only changes the object itself without it's attributes,
    # whereas Marshalling changes object and it's attributes

    before do
      allow(Marshal).to receive(:dump).with(real_piece).and_return(clone_piece)
      allow(Marshal).to receive(:load).with(clone_piece).and_return(clone_piece)
      allow(Marshal).to receive(:dump).with(real_square).and_return(clone_square)
      allow(Marshal).to receive(:load).with(clone_square).and_return(clone_square)
      allow(Marshal).to receive(:dump).with(real_board).and_return(clone_board)
      allow(Marshal).to receive(:load).with(clone_board).and_return(clone_board)
      allow(clone_piece).to receive(:move).with(clone_square, clone_board)
    end

    it 'sends :dump message to Marshal class 3 times' do
      expect(Marshal).to receive(:dump).exactly(3).times
      real_piece.clone_move(real_board, real_piece, real_square)
    end

    it 'sends :load message to Marshal class 3 times' do
      expect(Marshal).to receive(:load).exactly(3).times
      real_piece.clone_move(real_board, real_piece, real_square)
    end

    it 'sends :move message to cloned piece, with cloned square and cloned board' do
      expect(clone_piece).to receive(:move).with(clone_square, clone_board)
      real_piece.clone_move(real_board, real_piece, real_square)
    end

    it 'returns cloned board' do
      result = real_piece.clone_move(real_board, real_piece, real_square)
      expect(result).to eq(clone_board)
    end
  end

  describe '#discard_illegal_moves' do
    let(:opponent_color) { :black }
    let(:real_color) { :white }
    let(:real_board) { instance_double(Board) }
    subject(:real_piece) { described_class.new(nil, real_color, nil) }

    context 'when possible_moves has 1 move' do
    let(:real_square1) { instance_double(Square, piece: nil) }
    let(:possible_moves) { [real_square1] }
    let(:clone_board1) { instance_double(Board) }

      context 'when after that 1 move there is check condition' do
        before do
          allow(real_piece).to receive(:clone_move).with(real_board, real_piece, real_square1).and_return(clone_board1)
          allow(real_piece).to receive(:check?).with(clone_board1, real_color, opponent_color).and_return(true)
        end

        it 'returns empty array' do
          result = real_piece.discard_illegal_moves(real_board, opponent_color, possible_moves)
          expect(result).to be_empty
        end
      end
    end

    context 'when possible_moves has 2 moves' do
      let(:real_square1) { instance_double(Square, piece: nil) }
      let(:real_square2) { instance_double(Square, piece: nil) }
      let(:clone_board1) { instance_double(Board) }
      let(:clone_board2) { instance_double(Board) }
      let(:possible_moves) { [real_square1, real_square2] }

      context 'when after first move there is a check condition, but after the second move there is not' do
        before do
          allow(real_piece).to receive(:clone_move).with(real_board, real_piece, real_square1).and_return(clone_board1)
          allow(real_piece).to receive(:clone_move).with(real_board, real_piece, real_square2).and_return(clone_board2)
          allow(real_piece).to receive(:check?).with(clone_board1, real_color, opponent_color).and_return(true)
          allow(real_piece).to receive(:check?).with(clone_board2, real_color, opponent_color).and_return(false)
        end

        it 'returns array with only second move' do
          result = real_piece.discard_illegal_moves(real_board, opponent_color, possible_moves)
          expect(result).to eq([real_square2])
        end
      end
    end
  end
end