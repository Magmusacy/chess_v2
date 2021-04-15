# frozen_string_literal: true

require_relative 'shared_piece_spec'
require_relative '../../lib/pieces/pawn'
# require_relative '../../lib/board'
require_relative '../../lib/pieces/square'

describe Pawn do
  let(:chess_board) { double('chess board') }

  context 'when Pawn is a child class of Piece' do
    subject(:pawn) { described_class.new(nil, nil) }
    include_examples 'base class methods names'
  end

  context 'when Pawn has the same method name' do
    subject(:pawn) { described_class.new(nil, nil) }
    include_examples 'shared method names'
  end

  describe '#y_axis_shift' do
    context 'when @color is :black' do
      subject(:pawn) { described_class.new(nil, :black) }

      it 'returns -1' do
        result = pawn.y_axis_shift
        expect(result).to eq(-1)
      end
    end

    context 'when @color is :white' do
      subject(:pawn) { described_class.new(nil, :white) }

      it 'returns 1' do
        result = pawn.y_axis_shift
        expect(result).to eq(1)
      end
    end
  end

  describe '#y_axis_move' do
    context 'when given Pawn object with square position: { x: 2, y: 2 }' do
      let(:start_square_22) { instance_double(Square, position: { x: 2, y: 2 }) }
      subject(:wht_pawn_22) { described_class.new(start_square_22, :white) }

      context 'when squares { x: 2, y: 3 } and { x: 2, y: 4 } are empty' do
        let(:square_23) { instance_double(Square, position: { x: 2, y: 3 }, taken?: false) }
        let(:square_24) { instance_double(Square, position: { x: 2, y: 4 }, taken?: false) }

        before do
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, y: 1).and_return(square_23)
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, y: 2).and_return(square_24)
        end

        it 'returns array with two square objects with position: { x: 2, y: 3 } and with position: { x: 2, y: 4 }' do
          exp_sqrs = [square_23, square_24]
          result = wht_pawn_22.y_axis_move(chess_board, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end

      context 'when square with position: { x: 2, y: 4 } is taken by enemy' do
        let(:square_23) { instance_double(Square, position: { x: 2, y: 3 }, taken?: false) }
        let(:square_24) { instance_double(Square, position: { x: 2, y: 4 }, taken?: true) }

        before do
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, y: 1).and_return(square_23)
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, y: 2).and_return(square_24)
        end

        it 'returns square with position: { x: 2, y: 3 }' do
          exp_sqrs = [square_23]
          result = wht_pawn_22.y_axis_move(chess_board, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end

      context 'when only square with position: { x: 2, y: 3 } is taken' do
        let(:square_23) { instance_double(Square, position: { x: 2, y: 3 }, taken?: true) }
        let(:square_24) { instance_double(Square, position: { x: 2, y: 4 }, taken?: false) }

        before do
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, y: 1).and_return(square_23)
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, y: 2).and_return(square_24)
        end

        it 'returns empty array' do
          result = wht_pawn_22.y_axis_move(chess_board, 1)
          expect(result).to be_empty
        end
      end
    end

    context 'when given white Pawn object with square position: { x: 2, y: 5 }' do
      let(:start_square_25) { instance_double(Square, position: { x: 2, y: 5 }) }
      subject(:wht_pawn_25) { described_class.new(start_square_25, :white) }

      context 'when square: { x: 2, y: 6 } has default @piece' do
        let(:square_26) { instance_double(Square, position: { x: 2, y: 6 }, taken?: false) }

        before do
          allow(wht_pawn_25).to receive(:find_relative_square).with(chess_board, y: 1).and_return(square_26)
        end

        it 'returns square with position: { x: 2,  y: 6 }' do
          exp_sqrs = [square_26]
          result = wht_pawn_25.y_axis_move(chess_board, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end
    end
  end

  describe '#diagonal_move' do
    context 'when given white Pawn object with square position: { x: 2, y: 2 }' do
      let(:start_square_22) { instance_double(Square, position: { x: 2, y: 2 }) }
      subject(:wht_pawn_22) { described_class.new(start_square_22, :white) }

      context 'when two white Pieces are on squares { x: 1, y: 3 }, { x: 3, y: 3 }' do
        let(:wht_piece_13) { instance_double(Piece, color: :white) }
        let(:wht_piece_33) { instance_double(Piece, color: :white) }
        let(:square_13) { instance_double(Square, position: { x: 1, y: 3 }, taken?: true, piece: wht_piece_13) }
        let(:square_33) { instance_double(Square, position: { x: 3, y: 3 }, taken?: true, piece: wht_piece_33) }

        before do
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, x: -1, y: 1).and_return(square_13)
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, x: 1, y: 1).and_return(square_33)
        end

        it 'returns empty array' do
          exp_sqrs = [square_13, square_33]
          result = wht_pawn_22.diagonal_move(chess_board, 1)
          expect(result).to be_empty
        end
      end

      context 'when only black piece is on square with position: { x: 1, y: 3 }' do
        let(:blk_piece_13) { instance_double(Piece, color: :black) }
        let(:square_13) { instance_double(Square, position: { x: 1, y: 3 }, taken?: true, piece: blk_piece_13) }
        let(:square_33) { instance_double(Square, position: { x: 3, y: 3 }, taken?: false) }

        before do
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, x: -1, y: 1).and_return(square_13)
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, x: 1, y: 1).and_return(square_33)
        end

        it 'returns 1 square with position: { x: 1, y: 3}' do
          exp_sqrs = [square_13]
          result = wht_pawn_22.diagonal_move(chess_board, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end

      context 'when only two black pieces are on squares with position: { x: 1, y: 3 } and { x: 3, y: 3 }' do
        let(:blk_piece_13) { instance_double(Piece, color: :black) }
        let(:blk_piece_33) { instance_double(Piece, color: :black) }
        let(:square_13) { instance_double(Square, position: { x: 1, y: 3 }, taken?: true, piece: blk_piece_13) }
        let(:square_33) { instance_double(Square, position: { x: 3, y: 3 }, taken?: true, piece: blk_piece_33) }

        before do
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, x: -1, y: 1).and_return(square_13)
          allow(wht_pawn_22).to receive(:find_relative_square).with(chess_board, x: 1, y: 1).and_return(square_33)
        end

        it 'returns 2 squares with positions: { x: 1, y: 3}, { x: 3, y: 3 }' do
          exp_sqrs = [square_13, square_33]
          result = wht_pawn_22.diagonal_move(chess_board, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end
    end

    context 'when given black Pawn on square: { x: 1, y: 7 }' do
      let(:start_square_17) { double('Square', position: { x: 1, y: 7 }) }
      let(:blk_pawn_17) { described_class.new(start_square_17, :black) }

      context 'when given white enemy Piece on square: { x: 2, y: 6 }' do
        let(:wht_piece_26) { instance_double(Piece, color: :white) }
        let(:square_26) { instance_double(Square, position: { x: 2, y: 6 }, taken?: true, piece: wht_piece_26) }
        let(:square_06) { nil }

        before do
          allow(blk_pawn_17).to receive(:find_relative_square).with(chess_board, x: -1, y: -1).and_return(square_26)
          allow(blk_pawn_17).to receive(:find_relative_square).with(chess_board, x: 1, y: -1).and_return(square_06)
        end

        it 'returns square: { x: 2, y: 6 }' do
          exp_sqrs = [square_26]
          result = blk_pawn_17.diagonal_move(chess_board, -1)
          expect(result).to match_array(exp_sqrs)
        end
      end
    end
  end

  describe '#en_passant_move' do
    context 'when given white Pawn { x: 5, y: 5 } and black Pawn { x: 6, y: 5 } that has just moved from { x: 6, y: 7 }' do
      let(:en_passant_board) { double('board', board: position_array) }
      let(:blk_pawn) { instance_double(Pawn, color: :black) }
      let(:blk_pawn_sqr) { instance_double(Square, position: { x: 6, y: 5 }, piece: blk_pawn) }
      let(:prev_blk_pawn_sqr) { instance_double(Square, position: { x: 6, y: 7 }) }
      let(:start_square) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn) { described_class.new(start_square, :white) }

      before do
        en_passant_board.board.map! do |sqr|
          if sqr == [6, 5]
            blk_pawn_sqr
          else
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
          end
        end

        allow(en_passant_board).to receive(:square_taken?).with({ x: 4, y: 5 }).and_return(false)
        allow(en_passant_board).to receive(:square_taken?).with({ x: 6, y: 5 }).and_return(true)
        allow(en_passant_board).to receive(:get_square).with({ x: 6, y: 5 }).and_return(blk_pawn_sqr)
        allow(blk_pawn).to receive(:is_a?).and_return(true)
        allow(en_passant_board).to receive(:recorded_moves).and_return([[prev_blk_pawn_sqr, blk_pawn_sqr]])
      end

      it 'returns square { x: 6, y: 6 }' do
        exp_sqrs = en_passant_board.board.select do |sqr|
          [{ x: 6, y: 6 }].include?(sqr.position)
        end
        allow(en_passant_board).to receive(:get_square).with({ x: 6, y: 6 }).and_return(exp_sqrs[0])
        expect(wht_pawn.en_passant_move(en_passant_board, 1)).to match_array(exp_sqrs)
      end
    end

    context 'when given white Pawn { x: 5, y: 5 } and black Pawn { x: 4, y: 5 } that has just moved from { x: 4, y: 7 }' do
      let(:en_passant_board) { double('board', board: position_array) }
      let(:blk_pawn) { instance_double(Pawn, color: :black) }
      let(:blk_pawn_sqr) { instance_double(Square, position: { x: 4, y: 5 }, piece: blk_pawn) }
      let(:prev_blk_pawn_sqr) { instance_double(Square, position: { x: 4, y: 7 }) }
      let(:start_square) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn) { described_class.new(start_square, :white) }

      before do
        en_passant_board.board.map! do |sqr|
          if sqr == [4, 5]
            blk_pawn_sqr
          else
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
          end
        end

        allow(en_passant_board).to receive(:square_taken?).with({ x:4, y:5 }).and_return(true)
        allow(en_passant_board).to receive(:square_taken?).with({ x:6, y:5 }).and_return(false)
        allow(en_passant_board).to receive(:get_square).with({ x:4, y:5 }).and_return(blk_pawn_sqr)
        allow(blk_pawn).to receive(:is_a?).and_return(true)
        allow(en_passant_board).to receive(:recorded_moves).and_return([[prev_blk_pawn_sqr, blk_pawn_sqr]])
      end

      it 'returns square { x: 4, y: 6 }' do
        exp_sqrs = en_passant_board.board.select do |sqr|
          [{ x: 4, y: 6 }].include?(sqr.position)
        end
        allow(en_passant_board).to receive(:get_square).with({ x: 4, y: 6 }).and_return(exp_sqrs[0])
        expect(wht_pawn.en_passant_move(en_passant_board, 1)).to match_array(exp_sqrs)
      end
    end

    context 'when given black Pawn { x: 1, y: 4 } and white Pawn { x: 2, y: 4 } that has just moved from { x: 2, y: 2 }' do
      let(:en_passant_board) { double('board', board: position_array) }
      let(:wht_pawn) { instance_double(Pawn, color: :white) }
      let(:wht_pawn_sqr) { instance_double(Square, position: { x: 2, y: 4 }, piece: wht_pawn) }
      let(:prev_wht_pawn_sqr) { instance_double(Square, position: { x: 2, y: 2 }) }
      let(:start_square) { instance_double(Square, position: { x: 1, y: 4 }) }
      subject(:blk_pawn) { described_class.new(start_square, :black) }

      before do
        en_passant_board.board.map! do |sqr|
          if sqr == [2, 4]
            wht_pawn_sqr
          else
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
          end
        end

        allow(en_passant_board).to receive(:square_taken?).with({ x: 0, y: 4 }).and_return(false)
        allow(en_passant_board).to receive(:square_taken?).with({ x: 2, y: 4 }).and_return(true)
        allow(en_passant_board).to receive(:get_square).with({ x: 2, y: 4 }).and_return(wht_pawn_sqr)
        allow(wht_pawn).to receive(:is_a?).and_return(true)
        allow(en_passant_board).to receive(:recorded_moves).and_return([[prev_wht_pawn_sqr, wht_pawn_sqr]])
      end

      it 'returns square { x: 2, y: 3 }' do
        exp_sqrs = en_passant_board.board.select do |sqr|
          [{ x: 2, y: 3 }].include?(sqr.position)
        end
        allow(en_passant_board).to receive(:get_square).with({ x: 2, y: 3 }).and_return(exp_sqrs[0])
        expect(blk_pawn.en_passant_move(en_passant_board, -1)).to match_array(exp_sqrs)
      end
    end

    context 'when given white Pawn { x: 5, y: 5 } and black Pawn { x: 6, y: 5 } that has just moved from { x: 6, y: 6 }' do
      let(:en_passant_board) { double('board', board: position_array) }
      let(:blk_pawn) { instance_double(Pawn, color: :black) }
      let(:blk_pawn_sqr) { instance_double(Square, position: { x: 6, y: 5 }, piece: blk_pawn) }
      let(:prev_blk_pawn_sqr) { instance_double(Square, position: { x: 6, y: 6 }) }
      let(:start_square) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn) { described_class.new(start_square, :white) }

      before do
        en_passant_board.board.map! do |sqr|
          if sqr == [6, 5]
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: blk_pawn)
          else
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
          end
        end

        allow(en_passant_board).to receive(:square_taken?).with({ x: 4, y: 5 }).and_return(false)
        allow(en_passant_board).to receive(:square_taken?).with({ x: 6, y: 5 }).and_return(true)
        allow(en_passant_board).to receive(:get_square).with({ x: 6, y: 5 }).and_return(blk_pawn_sqr)
        allow(blk_pawn).to receive(:is_a?).and_return(true)
        allow(en_passant_board).to receive(:recorded_moves).and_return([[prev_blk_pawn_sqr, blk_pawn_sqr]])
      end

      it 'returns empty array' do
        expect(wht_pawn.en_passant_move(en_passant_board, 1)).to be_empty
      end
    end

    context 'when given white Pawn { x: 5, y: 5 } and black Piece (not Pawn) { x: 6, y: 5 } that has just moved from { x: 6, y: 7 }' do
      let(:en_passant_board) { double('board', board: position_array) }
      let(:blk_piece) { instance_double(Piece, color: :black) }
      let(:blk_piece_sqr) { instance_double(Square, position: { x: 6, y: 5 }, piece: blk_piece) }
      let(:prev_blk_piece_sqr) { instance_double(Square, position: { x: 6, y: 7 }) }
      let(:start_square) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn) { described_class.new(start_square, :white) }

      before do
        en_passant_board.board.map! do |sqr|
          if sqr == [6, 5]
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: blk_piece)
          else
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
          end
        end

        allow(en_passant_board).to receive(:square_taken?).with({ x: 4, y: 5 }).and_return(false)
        allow(en_passant_board).to receive(:square_taken?).with({ x: 6, y: 5 }).and_return(true)
        allow(en_passant_board).to receive(:get_square).with({ x: 6, y: 5 }).and_return(blk_piece_sqr)
        allow(blk_piece).to receive(:is_a?).and_return(false)
        allow(en_passant_board).to receive(:recorded_moves).and_return([[prev_blk_piece_sqr, blk_piece_sqr]])
      end

      it 'returns empty array' do
        expect(wht_pawn.en_passant_move(en_passant_board, 1)).to be_empty
      end
    end

    context 'when given white Pawn { x: 5, y: 4 } and another white Pawn { x: 6, y: 4 } that has just moved from { x: 6, y: 2 }' do
      let(:en_passant_board) { double('board', board: position_array) }
      let(:wht_pawn_dbl) { instance_double(Pawn, color: :white) }
      let(:wht_pawn_dbl_sqr) { instance_double(Square, position: { X: 6, y: 4 }, piece: wht_pawn_dbl) }
      let(:prev_wht_pawn_dbl_sqr) { instance_double(Square, position: { x: 6, y: 2 }) }
      let(:start_square) { instance_double(Square, position: { x: 5, y: 4 }) }
      subject(:wht_pawn) { described_class.new(start_square, :white) }

      before do
        en_passant_board.board.map! do |sqr|
          if sqr == [6, 4]
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: wht_pawn_dbl)
          else
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
          end
        end

        allow(en_passant_board).to receive(:square_taken?).with({ x: 4, y: 4 }).and_return(false)
        allow(en_passant_board).to receive(:square_taken?).with({ x: 6, y: 4 }).and_return(true)
        allow(en_passant_board).to receive(:get_square).with({ x: 6, y: 4 }).and_return(wht_pawn_dbl_sqr)
        allow(wht_pawn_dbl).to receive(:is_a?).and_return(true)
        allow(en_passant_board).to receive(:recorded_moves).and_return([[prev_wht_pawn_dbl_sqr, wht_pawn_dbl_sqr]])
      end

      it 'doesn\' work with pieces of the same color' do
        expect(wht_pawn.en_passant_move(en_passant_board, 1)).to be_empty
      end
    end
  end
end
