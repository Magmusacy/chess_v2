require_relative 'shared_piece_spec'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/square'
require_relative '../../lib/board'

describe Piece do
  let(:chess_board) { instance_double(Board) }

  describe '#move' do
    let(:start_square) { instance_double(Square) }
    subject(:piece) { described_class.new(start_square) }
    let(:square) { instance_double(Square) }
    let(:move_array) { [start_square, square] }

    before do
      allow(square).to receive(:update_piece).with(piece)
      allow(start_square).to receive(:update_piece)
      allow(chess_board).to receive(:add_move).with(move_array)
      allow(piece).to receive(:update_location)
    end

    it 'sends :add_move message to Board with [location, square] argument' do
      expect(chess_board).to receive(:add_move).with(move_array)
      piece.move(square, chess_board)
    end

    it 'sends :update_piece message with self to given square' do
      expect(square).to receive(:update_piece).with(piece)
      piece.move(square, chess_board)
    end

    it 'sends :update_piece message without any args to self location' do
      expect(start_square).to receive(:update_piece).with(no_args)
      piece.move(square, chess_board)
    end

    it 'calls #update_location method with given square as an argument' do
      expect(piece).to receive(:update_location).with(square)
      piece.move(square, chess_board)
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

  describe '#clone_objects' do
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
      allow(Marshal).to receive(:dump)
      allow(Marshal).to receive(:load)
    end

    context 'when marshalling Piece object' do
      it 'sends :dump message to Marshal class with Piece object' do
        expect(Marshal).to receive(:dump).with(real_piece).and_return(clone_piece)
        real_piece.clone_objects(real_board, real_piece, real_square)
      end

      it 'sends :load message to Marshal class with the result of dumping Piece object' do
        allow(Marshal).to receive(:dump).with(real_piece).and_return(clone_piece)
        expect(Marshal).to receive(:load).with(clone_piece)
        real_piece.clone_objects(real_board, real_piece, real_square)
      end
    end

    context 'when marshalling Square object' do
      it 'sends :dump message to Marshal class with Square object' do
        expect(Marshal).to receive(:dump).with(real_square).and_return(clone_square)
        real_piece.clone_objects(real_board, real_piece, real_square)
      end

      it 'sends :load message to Marshal class with the result of dumping Square object' do
        allow(Marshal).to receive(:dump).with(real_square).and_return(clone_square)
        expect(Marshal).to receive(:load).with(clone_square)
        real_piece.clone_objects(real_board, real_piece, real_square)
      end
    end

    context 'when marshalling Board object' do
      it 'sends :dump message to Marshal class with Board object' do
        expect(Marshal).to receive(:dump).with(real_board)
        real_piece.clone_objects(real_board, real_piece, real_square)
      end

      it 'sends :load message to Marshal class with the result of dumping Board object' do
        allow(Marshal).to receive(:dump).with(real_board).and_return(clone_board)
        expect(Marshal).to receive(:load).with(clone_board)
        real_piece.clone_objects(real_board, real_piece, real_square)
      end
    end
  end

  describe '#illegal?' do
    context 'when Piece object has :white color' do
      let(:opponent_color) { :black }
      let(:piece_color) { :white }
      subject(:illegal_piece) { described_class.new(nil, piece_color, nil) }

      context 'when given Board on which :white King is under attack' do
        let(:wht_king) { double('King', color: :white, piece: nil) }
        let(:enemy_piece1) { double('Piece') }
        let(:enemy_squares) { [double('Square', taken?: true, piece: enemy_piece1)] }

        before do
          allow(enemy_piece1).to receive(:possible_moves).with(chess_board).and_return([wht_king])
          allow(chess_board).to receive(:squares_taken_by).with(opponent_color).and_return(enemy_squares)
          allow(chess_board).to receive(:get_king_square).with(piece_color).and_return(wht_king)
        end

        it 'returns true' do
          result = illegal_piece.illegal?(chess_board)
          expect(result).to be true
        end
      end

      context 'when given Board on which :white King is not under attack' do
        let(:wht_king) { double('King', color: :white, piece: nil) }
        let(:enemy_piece1) { double('Piece') }
        let(:enemy_squares) { [double('Square', taken?: true, piece: enemy_piece1)] }

        before do
          allow(enemy_piece1).to receive(:possible_moves).with(chess_board).and_return([])
          allow(chess_board).to receive(:squares_taken_by).with(opponent_color).and_return(enemy_squares)
          allow(chess_board).to receive(:get_king_square).with(piece_color).and_return(wht_king)
        end

        it 'returns false' do
          result = illegal_piece.illegal?(chess_board)
          expect(result).to be false
        end
      end
    end
  end

  describe '#clone_board_move' do
    let(:move_square) { instance_double(Square, piece: nil) }
    let(:dbl_piece) { instance_double(Piece) }
    subject(:piece) { described_class.new(nil, :white, nil) }

    it 'sends correct :move message to Piece object' do
      expect(dbl_piece).to receive(:move).with(move_square, chess_board)
      piece.clone_board_move(chess_board, dbl_piece, move_square)
    end

    it 'returns Board object' do
      allow(dbl_piece).to receive(:move).with(move_square, chess_board)
      result = piece.clone_board_move(chess_board, dbl_piece, move_square)
      expect(result).to eq(chess_board)
    end
  end

  describe '#discard_illegal_moves' do
    subject(:real_piece) { described_class.new(nil, :white, nil) }

    context 'when possible_moves has 1 move' do
    let(:real_square_1) { instance_double(Square, piece: nil) }
    let(:possible_moves) { [real_square_1] }
    let(:clone_board_1) { instance_double(Board) }

      context 'when that move is illegal' do
        before do
          allow(real_piece).to receive(:clone_objects).and_return(clone_board_1)
          allow(real_piece).to receive(:clone_board_move).and_return(clone_board_1)
          allow(real_piece).to receive(:illegal?).with(clone_board_1).and_return(true)
        end

        it 'returns empty array' do
          result = real_piece.discard_illegal_moves(chess_board, possible_moves)
          expect(result).to be_empty
        end
      end
    end

    context 'when possible_moves has 2 moves' do
      let(:real_square_1) { instance_double(Square, piece: nil) }
      let(:real_square_2) { instance_double(Square, piece: nil) }
      let(:clone_board_1) { instance_double(Board) }
      let(:clone_board_2) { instance_double(Board) }
      let(:possible_moves) { [real_square_1, real_square_2] }

      context 'when only the first move is illegal' do
        before do
          allow(real_piece).to receive(:clone_objects).and_return(clone_board_1, clone_board_2)
          allow(real_piece).to receive(:clone_board_move).and_return(clone_board_1, clone_board_2)
          allow(real_piece).to receive(:illegal?).with(clone_board_1).and_return(true)
          allow(real_piece).to receive(:illegal?).with(clone_board_2).and_return(false)
        end

        it 'returns array with only second move' do
          result = real_piece.discard_illegal_moves(chess_board, possible_moves)
          expect(result).to eq([real_square_2])
        end
      end
    end
  end

  describe '#discard_related_squares' do
    let(:white_piece_dbl) { double('Piece', color: :white) }
    let(:black_piece_dbl) { double('Piece', color: :black) }

    context 'when given :white Piece' do
      subject(:wht_piece) { described_class.new(nil, :white) }
      let(:empty_square) { double('Square', taken?: false) }
      let(:related_square) { double('Square', taken?: true, piece: white_piece_dbl) }
      let(:opponent_square) { double('Square', taken?: true, piece: black_piece_dbl) }

      context 'when given an array with 2 squares (white_piece, white_piece)' do
        let(:squares_array) { [related_square, related_square] }

        it 'returns empty array' do
          result = wht_piece.discard_related_squares(squares_array)
          expect(result).to be_empty
        end
      end

      context 'when given an array with 2 squares (white_piece, empty)' do
        let(:squares_array) { [related_square, empty_square] }

        it 'returns array with (empty) square' do
          result = wht_piece.discard_related_squares(squares_array)
          expect(result).to match_array([empty_square])
        end
      end

      context 'when given an array with 2 squares (black_piece, empty)' do
        let(:squares_array) { [opponent_square, empty_square] }

        it 'returns array with squares (black_piece, empty)' do
          result = wht_piece.discard_related_squares(squares_array)
          expect(result).to match_array([opponent_square, empty_square])
        end
      end
    end

    context 'when given :black Piece' do
      subject(:blk_piece) { described_class.new(nil, :black) }
      let(:empty_square) { double('Square', taken?: false) }
      let(:related_square) { double('Square', taken?: true, piece: black_piece_dbl) }
      let(:opponent_square) { double('Square', taken?: true, piece: white_piece_dbl) }

      context 'when given an array with 2 squares (white_piece, white_piece)' do
        let(:squares_array) { [opponent_square, opponent_square] }

        it 'returns array with squares (white_piece, white_piece)' do
          result = blk_piece.discard_related_squares(squares_array)
          expect(result).to match_array([opponent_square, opponent_square])
        end
      end

      context 'when given an array with 2 squares (black_piece, empty)' do
        let(:squares_array) { [related_square, empty_square] }

        it 'returns array with (empty) square' do
          result = blk_piece.discard_related_squares(squares_array)
          expect(result).to match_array([empty_square])
        end
      end

      context 'when given an array with 2 squares (black_piece, black_piece)' do
        let(:squares_array) { [related_square, related_square] }

        it 'returns empty array' do
          result = blk_piece.discard_related_squares(squares_array)
          expect(result).to be_empty
        end
      end
    end
  end
end