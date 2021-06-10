# frozen_string_literal: true

require_relative 'shared_piece_spec'
require_relative '../../lib/board'
require_relative '../../lib/square'

describe King do
  let(:chess_board) { instance_double(Board) }

  context 'when King is a child class of Piece' do
    subject(:king) { described_class.new }
    include_examples 'base class methods names'
  end

  context 'when King has the same method name' do
    subject(:king) { described_class.new }
    include_examples 'shared method names'
  end

  describe '#possible_moves' do # possible moves calluje ten no castling
    context 'when given King { x: 4, y: 4 }' do
      subject(:possible_king) { described_class.new(nil, :white) }
      let(:white_piece) { instance_double(Piece, color: :white) }
      let(:impossible_move) { [instance_double(Square, taken?: true, piece: white_piece)] }
      let(:possible_move) { [instance_double(Square, taken?: false)] }

      before do
        allow(possible_king).to receive(:horizontal_move).and_return([])
        allow(possible_king).to receive(:vertical_move).and_return([])
        allow(possible_king).to receive(:diagonal_move).and_return([])
        allow(possible_king).to receive(:castling_move).and_return([])
      end

      context 'when only #horizontal_move with x = -1 and x = 1 return a possible legal move' do
        before do
          allow(possible_king).to receive(:horizontal_move).with(chess_board, -1).and_return(possible_move)
          allow(possible_king).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
        end

        it 'returns an array with 2 possible moves' do
          expected = [possible_move, possible_move].flatten
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(expected)
        end
      end

      context 'when only #vertical_move with y = -1 and y = 1 return a possible legal move' do
        before do
          allow(possible_king).to receive(:vertical_move).with(chess_board, -1).and_return(possible_move)
          allow(possible_king).to receive(:vertical_move).with(chess_board, 1).and_return(possible_move)
        end

        it 'returns an array with 2 possible moves' do
          expected = [possible_move, possible_move].flatten
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(expected)
        end
      end

      context 'when all diagonal moves are available' do
        before do
          allow(possible_king).to receive(:diagonal_move).with(chess_board, 1, 1).and_return(possible_move)
          allow(possible_king).to receive(:diagonal_move).with(chess_board, 1, -1).and_return(possible_move)
          allow(possible_king).to receive(:diagonal_move).with(chess_board, -1, -1).and_return(possible_move)
          allow(possible_king).to receive(:diagonal_move).with(chess_board, -1, 1).and_return(possible_move)
        end

        it 'returns an array with 4 possible moves' do
          expected = [possible_move, possible_move, possible_move, possible_move].flatten
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(expected)
        end
      end

      context 'when only #castling_move with x = 1 and x = -1 are possible' do
        before do
          allow(possible_king).to receive(:castling_move).with(chess_board, 1).and_return(possible_move)
          allow(possible_king).to receive(:castling_move).with(chess_board, -1).and_return(possible_move)
        end

        it 'returns an array with 2 possible move' do
          result = possible_king.possible_moves(chess_board)
          expected = [possible_move, possible_move].flatten
          expect(result).to match_array(expected)
        end
      end

      context 'when there are 2 possible moves but one of them has square with Piece the same color as calling Queen' do
        it 'returns an array with 1 possible legal move' do
          allow(possible_king).to receive(:horizontal_move).with(chess_board, 1).and_return(possible_move)
          allow(possible_king).to receive(:vertical_move).with(chess_board, -1).and_return(impossible_move)
          result = possible_king.possible_moves(chess_board)
          expect(result).to match_array(possible_move)
        end
      end

      context 'when there is 1 possible move on square with Piece the same color as calling Queen' do
        it 'returns empty array' do
          allow(possible_king).to receive(:vertical_move).with(chess_board, -1).and_return(impossible_move)
          result = possible_king.possible_moves(chess_board)
          expect(result).to be_empty
        end
      end
    end
  end

  describe '#horizontal_move' do
    context 'when given King on square { x: 5, y: 3 }' do
      let(:start_square53) { instance_double(Square, position: { x: 5, y: 3 }) }
      subject(:king53) { described_class.new(start_square53, :nil) }

      context 'when x = 1' do
        let(:square63) { instance_double(Square, position: { x: 6, y: 3 }, taken?: false) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square53, x: 1).and_return(square63)
        end

        it 'returns square { x: 6, y: 3 }' do
          x = 1
          result = king53.horizontal_move(chess_board, x)
          expected = [square63]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = -1' do
        let(:square43) { instance_double(Square, position: { x: 6, y: 3 }, taken?: false) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square53, x: -1).and_return(square43)
        end

        it 'returns square { x: 4, y: 3 }' do
          x = -1
          result = king53.horizontal_move(chess_board, x)
          expected = [square43]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when move results in square that is not on the board' do
      let(:start_square12) { instance_double(Square, position: { x: 1, y: 2 }) }
      subject(:king12) { described_class.new(start_square12, nil) }

      before do
        allow(chess_board).to receive(:get_relative_square).with(start_square12, x: -1).and_return(nil)
      end

      it 'returns empty array' do
        x = -1
        result = king12.horizontal_move(chess_board, x)
        expect(result).to be_empty
      end
    end
  end

  describe '#vertical_move' do
    context 'when given King on square { x: 5, y: 3 }' do
      let(:start_square53) { instance_double(Square, position: { x: 5, y: 3 }) }
      subject(:king53) { described_class.new(start_square53, nil) }

      context 'when y = 1' do
        let(:square54) { instance_double(Square, position: { x: 5, y: 4 }, taken?: false) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square53, y: 1).and_return(square54)
        end

        it 'returns square { x: 5, y: 4 }' do
          y = 1
          result = king53.vertical_move(chess_board, y)
          expected = [square54]
          expect(result).to match_array(expected)
        end
      end

      context 'when y = -1' do
        let(:square52) { instance_double(Square, position: { x: 5, y: 2 }, taken?: false) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square53, y: -1).and_return(square52)
        end

        it 'returns square { x: 5, y: 2 }' do
          y = -1
          result = king53.vertical_move(chess_board, y)
          expected = [square52]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when move results in square that is not on the board' do
      let(:start_square51) { instance_double(Square, position: { x: 5, y: 1 }) }
      subject(:king51) { described_class.new(start_square51, nil) }

      before do
        allow(chess_board).to receive(:get_relative_square).with(start_square51, y: -1).and_return(nil)
      end

      it 'returns empty array' do
        y = -1
        result = king51.vertical_move(chess_board, y)
        expect(result).to be_empty
      end
    end
  end

  describe '#diagonal_move' do
    context 'when given only King on square { x: 4, y: 4 }' do
      let(:start_square44) { instance_double(Square, position: { x: 4, y: 4 }) }
      subject(:diagonal_king44) { described_class.new(start_square44) }

      context 'when x = 1, y = 1' do
        let(:square55) { instance_double(Square, position: { x: 5, y: 5 }) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square44, x: 1, y: 1).and_return(square55)
        end

        it 'returns square { x: 5, y: 5 }' do
          result = diagonal_king44.diagonal_move(chess_board, 1, 1)
          expected = [square55]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = 1, y = -1' do
        let(:square53) { instance_double(Square, position: { x: 5, y: 3 }) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square44, x: 1, y: -1).and_return(square53)
        end

        it 'returns square { x: 5, y: 3 }' do
          result = diagonal_king44.diagonal_move(chess_board, 1, -1)
          expected = [square53]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = -1, y = 1' do
        let(:square35) { instance_double(Square, position: { x: 3, y: 5 }) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square44, x: -1, y: 1).and_return(square35)
        end

        it 'returns square { x: 3, y: 5 }' do
          result = diagonal_king44.diagonal_move(chess_board, -1, 1)
          expected = [square35]
          expect(result).to match_array(expected)
        end
      end

      context 'when x = -1, y = -1' do
        let(:square33) { instance_double(Square, position: { x: 3, y: 3 }) }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square44, x: -1, y: -1).and_return(square33)
        end

        it 'returns square { x: 3, y: 3 }' do
          result = diagonal_king44.diagonal_move(chess_board, -1, -1)
          expected = [square33]
          expect(result).to match_array(expected)
        end
      end
    end

    context 'when move results in square that is not on the board' do
      let(:start_square51) { instance_double(Square, position: { x: 5, y: 1 }) }
      subject(:king51) { described_class.new(start_square51, nil) }

      before do
        allow(chess_board).to receive(:get_relative_square).with(start_square51, x: 1, y: -1).and_return(nil)
      end

      it 'returns empty array' do
        x = 1
        y = -1
        result = king51.diagonal_move(chess_board, x, y)
        expect(result).to be_empty
      end
    end
  end

  describe '#castling_move' do
    let(:start_square51) { instance_double(Square, position: { x: 5, y: 1 }) }
    subject(:castling_king) { described_class.new(start_square51, :white) }
    let(:empty_square) { instance_double(Square, taken?: false) }
    let(:wht_rook) { instance_double(Rook, color: :white, is_a?: true) }
    let(:rook_square) { instance_double(Square, position: { x: 8, y: 1 }, taken?: true, piece: wht_rook) }
    let(:enemy_piece) { instance_double(Piece) }
    let(:enemy_square) { instance_double(Square, taken?: true, piece: enemy_piece) }
    let(:square71) { instance_double(Square, position: { x: 7, y: 1 }, taken?: false) }

    before do
      allow(castling_king).to receive(:get_rook).and_return(wht_rook)
      allow(chess_board).to receive(:recorded_moves).and_return([])
      allow(chess_board).to receive(:get_relative_square).with(start_square51, x: 1).and_return(empty_square)
      allow(chess_board).to receive(:get_relative_square).with(start_square51, x: 2).and_return(square71)
      allow(chess_board).to receive(:squares_taken_by).and_return([enemy_square])
      allow(enemy_piece).to receive(:possible_moves).with(chess_board).and_return([])
    end

    context 'when :white King on initial square { x: 5, y: 1 }' do
      context 'when castling with x = 1 is available' do
        before do
          columns = [empty_square, square71]
          allow(castling_king).to receive(:discard_illegal_moves).and_return(columns)
        end

        it 'returns Square { x: 7, y: 1 }' do
          x = 1
          result = castling_king.castling_move(chess_board, x)
          expect(result).to be(square71)
        end
      end

      context 'when with x = -1 is available' do
        let(:square31) { instance_double(Square, position: { x: 3, y: 1 }, taken?: false) }

        before do
          columns = [empty_square, square31, empty_square]
          allow(castling_king).to receive(:discard_illegal_moves).and_return(columns)
          allow(chess_board).to receive(:get_relative_square).with(start_square51, x: -1).and_return(empty_square)
          allow(chess_board).to receive(:get_relative_square).with(start_square51, x: -2).and_return(square31)
          allow(chess_board).to receive(:get_relative_square).with(start_square51, x: -3).and_return(empty_square)
        end

        it 'returns Square { x: 3, y: 1 }' do
          x = -1
          result = castling_king.castling_move(chess_board, x)
          expect(result).to be(square31)
        end
      end

      context 'when King has to move through attacked square' do
        let(:attacked_square) { instance_double(Square, taken?: false) }

        before do
          allow(chess_board).to receive(:squares_taken_by).and_return([enemy_square])
          allow(enemy_piece).to receive(:possible_moves).with(chess_board).and_return([attacked_square])
          allow(castling_king).to receive(:discard_illegal_moves).and_return([empty_square])
          allow(chess_board).to receive(:get_relative_square).with(start_square51, x: 1).and_return(attacked_square)
        end

        it 'returns empty array' do
          x = 1
          result = castling_king.castling_move(chess_board, x)
          expect(result).to be_empty
        end
      end

      context 'when there is no correct Rook on the specified side' do
        let(:attacked_square) { instance_double(Square, taken?: false) }
        let(:enemy_piece) { instance_double(Piece) }
        let(:square71) { instance_double(Square, position: { x: 7, y: 1 }, taken?: false) }
        before do
          columns = [empty_square, square71]
          allow(castling_king).to receive(:discard_illegal_moves).and_return(columns)
          allow(castling_king).to receive(:get_rook).and_return(nil)
        end

        it 'returns empty array' do
          x = 1
          result = castling_king.castling_move(chess_board, x)
          expect(result).to be_empty
        end
      end

      context 'when Rook on the specified side has made a move before' do
        let(:attacked_square) { instance_double(Square, taken?: false) }
        let(:enemy_piece) { instance_double(Piece) }
        let(:square71) { instance_double(Square, position: { x: 7, y: 1 }, taken?: false) }

        before do
          columns = [empty_square, square71]
          allow(castling_king).to receive(:discard_illegal_moves).and_return(columns)
          allow(chess_board).to receive(:recorded_moves).and_return([[rook_square]])
        end

        it 'returns empty array' do
          x = 1
          result = castling_king.castling_move(chess_board, x)
          expect(result).to be_empty
        end
      end
    end

    context 'when King has made a move before' do
      before do
        columns = [empty_square, square71]
        allow(castling_king).to receive(:discard_illegal_moves).and_return(columns)
        allow(chess_board).to receive(:recorded_moves).and_return([[start_square51]])
      end

      it 'returns empty array' do
        x = 1
        result = castling_king.castling_move(chess_board, x)
        expect(result).to be_empty
      end
    end
  end

  describe '#get_rook' do
    let(:start_square51) { instance_double(Square, position: { x: 5, y: 1 }) }
    subject(:rook_king) { described_class.new(start_square51, :white) }
    let(:wht_rook) { instance_double(Rook, color: :white, is_a?: true) }
    let(:rook_square) { instance_double(Square) }

    context 'when x = 1' do
      context 'when square with position x: 8 has Rook Piece with the same color as King on it' do
        it 'returns correct Rook piece' do
          allow(rook_square).to receive(:piece).and_return(wht_rook)
          allow(chess_board).to receive(:get_square).with({ x: 8, y: 1 }).and_return(rook_square)
          x = 1
          result = rook_king.get_rook(chess_board, x)
          expect(result).to be(wht_rook)
        end
      end

      context 'when square with position x: 8 does not have Rook Piece with the same color as King on it' do
        let(:blk_rook) { instance_double(Rook, color: :black, is_a?: true) }

        it 'return nil' do
          allow(rook_square).to receive(:piece).and_return(blk_rook)
          allow(chess_board).to receive(:get_square).with({ x: 8, y: 1 }).and_return(rook_square)
          x = 1
          result = rook_king.get_rook(chess_board, x)
          expect(result).to be_nil
        end
      end
    end

    context 'when x = -1' do
      context 'when square with position x: 1 has Rook Piece with the same color as King on it' do
        it 'returns correct Rook piece' do
          allow(rook_square).to receive(:piece).and_return(wht_rook)
          allow(chess_board).to receive(:get_square).with({ x: 1, y: 1 }).and_return(rook_square)
          x = -1
          result = rook_king.get_rook(chess_board, x)
          expect(result).to be(wht_rook)
        end
      end

      context 'when square with position x: 1 does not have Rook Piece with the same color as King on it' do
        let(:blk_piece) { instance_double(Piece, color: :black, is_a?: false) }

        it 'return nil' do
          allow(rook_square).to receive(:piece).and_return(blk_piece)
          allow(chess_board).to receive(:get_square).with({ x: 1, y: 1 }).and_return(rook_square)
          x = -1
          result = rook_king.get_rook(chess_board, x)
          expect(result).to be_nil
        end
      end
    end
  end

  describe '#move' do
    let(:start_square51) { instance_double(Square, position: { x: 5, y: 1 }) }
    subject(:castling_king) { described_class.new(start_square51, :white) }
    let(:empty_square) { instance_double(Square, taken?: false) }
    let(:taken_square) { instance_double(Square, taken?: true) }
    let(:wht_rook) { instance_double(Rook, color: :white, is_a?: true) }
    let(:rook_square) { instance_double(Square, position: { x: 8, y: 1 }, taken?: true, piece: wht_rook) }
    let(:square71) { instance_double(Square, position: { x: 7, y: 1 }) }
    let(:square61) { instance_double(Square, position: { x: 6, y: 1 }) }
    let(:move_array) { [start_square51, square71] }

    before do
      allow(square71).to receive(:update_piece).with(castling_king)
      allow(start_square51).to receive(:update_piece)
      allow(chess_board).to receive(:add_move).with(move_array)
      allow(castling_king).to receive(:update_location)
      allow(castling_king).to receive(:castling_move)
    end

    it 'sends :add_move message to Board with [location, square] argument' do
      expect(chess_board).to receive(:add_move).with(move_array)
      castling_king.move(square71, chess_board)
    end

    it 'sends :update_piece message with self to given square' do
      expect(square71).to receive(:update_piece).with(castling_king)
      castling_king.move(square71, chess_board)
    end

    it 'sends :update_piece message without any args to self location' do
      expect(start_square51).to receive(:update_piece).with(no_args)
      castling_king.move(square71, chess_board)
    end

    it 'calls #update_location method with given square as an argument' do
      expect(castling_king).to receive(:update_location).with(square71)
      castling_king.move(square71, chess_board)
    end

    context 'when new_square is the same as the square returned from #castling_move with x = 1' do
      before do
        allow(castling_king).to receive(:castling_move).with(chess_board, 1).and_return(square71)
        allow(chess_board).to receive(:get_relative_square).with(start_square51, x: 1).and_return(square61)
        allow(castling_king).to receive(:get_rook).with(chess_board, 1).and_return(wht_rook)
        allow(wht_rook).to receive(:move)
      end

      it 'sends correct :move message to correct Rook' do
        expect(wht_rook).to receive(:move).with(square61, chess_board)
        castling_king.move(square71, chess_board)
      end
    end

    context 'when new_square is the same as the square returned from #castling_move with x = -1' do
      let(:square31) { instance_double(Square, position: { x: 3, y: 1 }) }
      let(:square41) { instance_double(Square, position: { x: 4, y: 1 }) }
      let(:move_array) { [start_square51, square31] }

      before do
        allow(square31).to receive(:update_piece).with(castling_king)
        allow(castling_king).to receive(:castling_move).with(chess_board, -1).and_return(square31)
        allow(chess_board).to receive(:get_relative_square).with(start_square51, x: -1).and_return(square41)
        allow(castling_king).to receive(:get_rook).with(chess_board, -1).and_return(wht_rook)
        allow(wht_rook).to receive(:move)
      end

      it 'sends correct :move message to correct Rook' do
        expect(wht_rook).to receive(:move).with(square41, chess_board)
        castling_king.move(square31, chess_board)
      end
    end
  end
end
