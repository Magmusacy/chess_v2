# frozen_string_literal: true

require_relative 'shared_piece_spec'
require_relative '../../lib/pieces/pawn'
# require_relative '../../lib/pieces/board'
require_relative '../../lib/pieces/square'

describe Pawn do
  let(:position_array) { Array(1..8).product(Array(1..8)) }

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
      subject(:pawn) { described_class.new(:black, nil) }

      it 'returns -1' do
        result = pawn.y_axis_shift
        expect(result).to eq(-1)
      end
    end

    context 'when @color is :white' do
      subject(:pawn) { described_class.new(:white, nil) }

      it 'returns 1' do
        result = pawn.y_axis_shift
        expect(result).to eq(1)
      end
    end
  end

  describe '#y_axis_move' do
    context 'when given Pawn object with square position: { x: 2, y: 2 }' do
      let(:start_square) { instance_double(Square, position: { x: 2, y: 2 }) }
      subject(:wht_pawn) { described_class.new(:white, '♙', start_square) }

      context 'when square with position: { x: 2, y: 3 } and { x: 2, y: 4 } are empty' do
        let(:board_y3_y4) { double('board', board: position_array) }
        before do
          board_y3_y4.board.map! do |sqr|
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
          end

          allow(board_y3_y4).to receive(:square_taken?).and_return(false)
        end

        it 'returns array with two square objects with position: { x: 2, y: 3 } and with position: { x: 2, y: 4 }' do
          exp_sqrs = board_y3_y4.board.select do |sqr|
            [{ x: 2, y: 3 }, { x: 2, y: 4 }].include?(sqr.position)
          end

          allow(board_y3_y4).to receive(:get_square).with(exp_sqrs[0].position).and_return(exp_sqrs[0])
          allow(board_y3_y4).to receive(:get_square).with(exp_sqrs[1].position).and_return(exp_sqrs[1])
          result = wht_pawn.y_axis_move(board_y3_y4, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end

      context 'when square with position: { x: 2, y: 4 } is taken by enemy' do
        let(:enemy_piece) { instance_double(Piece, color: :black) }
        let(:board_y4) { double('board', board: position_array) }

        before do
          board_y4.board.map! do |sqr|
            if sqr[2, 4]
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: enemy_piece)
            else
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
            end
          end

          allow(board_y4).to receive(:square_taken?).and_return(false)
          allow(board_y4).to receive(:square_taken?).with({ x: 2, y: 4 }).and_return(true)
        end

        it 'returns square with position: { x: 2, y: 3 }' do
          exp_sqrs = board_y4.board.select do |sqr|
            [{ x: 2, y: 3 }].include?(sqr.position)
          end

          allow(board_y4).to receive(:get_square).with(exp_sqrs[0].position).and_return(exp_sqrs[0])
          result = wht_pawn.y_axis_move(board_y4, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end

      context 'when square with position: { x: 2, y: 3 } is taken' do
        let(:enemy_piece) { instance_double(Piece, color: :black) }
        let(:board_zero) { double('board', board: position_array) }

        before do
          board_zero.board.map! do |sqr|
            if sqr[2, 3]
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: enemy_piece)
            else
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: ' ')
            end
          end

          allow(board_zero).to receive(:square_taken?).and_return(false)
          allow(board_zero).to receive(:square_taken?).with({ x: 2, y: 3 }).and_return(true)
        end

        it 'returns empty array' do
          result = wht_pawn.y_axis_move(board_zero, 1)
          expect(result).to be_empty
        end
      end
    end

    context 'when given white Pawn object with square position: { x: 2, y: 5 }' do
      let(:start_square) { instance_double(Square, position: { x: 2, y: 5 }) }
      subject(:wht_pawn) { described_class.new(:white, '♙', start_square) }

      context 'when square: { x: 2, y: 6 } has default @piece' do
        let(:board_y6) { double('board', board: position_array) }
        before do
          board_y6.board.map! do |sqr|
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
          end

          allow(board_y6).to receive(:square_taken?).and_return(false)
        end

        it 'returns square with position: { x: 2,  y: 6 }' do
          exp_sqrs = board_y6.board.select do |sqr|
            [{ x: 2, y: 6 }].include?(sqr.position)
          end

          allow(board_y6).to receive(:get_square).with(exp_sqrs[0].position).and_return(exp_sqrs[0])
          result = wht_pawn.y_axis_move(board_y6, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end
    end
  end

  describe '#diagonal_move' do
    context 'when given white Pawn object with square position: { x: 2, y: 2 }' do
      let(:start_square) { instance_double(Square, position: { x: 2, y: 2 }) }
      subject(:wht_pawn) { described_class.new(:white, '♙', start_square) }

      context 'when two white Pieces are on squares { x: 1, y: 3 }, { x: 3, y: 3 }' do
        let(:my_piece) { instance_double(Piece, color: :white) }
        let(:board_zero) { double('board', board: position_array) }

        before do
          board_zero.board.map! do |sqr|
            if [[1, 3], [3, 3]].include?(sqr)
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: my_piece)
            else
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
            end
          end

          allow(board_zero).to receive(:square_taken?)
          allow(board_zero).to receive(:square_taken?).with({ x: 1, y: 3 }).and_return(true)
          allow(board_zero).to receive(:square_taken?).with({ x: 3, y: 3 }).and_return(true)
        end

        it 'returns empty array' do
          exp_sqrs = board_zero.board.select do |sqr|
            [{ x: 1, y: 3 },
             { x: 3, y: 3 }].include?(sqr.position)
          end

          allow(board_zero).to receive(:get_square)
          allow(board_zero).to receive(:get_square).with(exp_sqrs[0].position).and_return(exp_sqrs[0])
          allow(board_zero).to receive(:get_square).with(exp_sqrs[1].position).and_return(exp_sqrs[1])
          result = wht_pawn.diagonal_move(board_zero, 1)
          expect(result).to be_empty
        end
      end

      context 'when only black piece is on square with position: { x: 1, y: 3 }' do
        let(:enemy_piece) { instance_double(Piece, color: :black) }
        let(:board_y3) { double('board', board: position_array) }

        before do
          board_y3.board.map! do |sqr|
            if sqr == [1, 3]
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: enemy_piece)
            else
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: ' ')
            end
          end

          allow(board_y3).to receive(:square_taken?)
          allow(board_y3).to receive(:square_taken?).with({ x: 1, y: 3 }).and_return(true)
        end

        it 'returns 1 square with position: { x: 1, y: 3}' do
          exp_sqrs = board_y3.board.select do |sqr|
            [{ x: 1, y: 3 }].include?(sqr.position)
          end

          allow(board_y3).to receive(:get_square).with(exp_sqrs[0].position).and_return(exp_sqrs[0])
          result = wht_pawn.diagonal_move(board_y3, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end

      context 'when only two black pieces are on squares with position: { x: 1, y: 3 } and { x: 3, y: 3 }' do
        let(:enemy_piece) { instance_double(Piece, color: :black) }
        let(:board_x1_x3) { double('board', board: position_array) }

        before do
          board_x1_x3.board.map! do |sqr|
            if [[1, 3], [3, 3]].include?(sqr)
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: enemy_piece)
            else
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: ' ')
            end
          end

          allow(board_x1_x3).to receive(:square_taken?).with({ x: 1, y: 3 }).and_return(true)
          allow(board_x1_x3).to receive(:square_taken?).with({ x: 3, y: 3 }).and_return(true)
        end

        it 'returns 2 squares with positions: { x: 1, y: 3}, { x: 3, y: 3 }' do
          exp_sqrs = board_x1_x3.board.select do |sqr|
            [{ x: 1, y: 3 },
             { x: 3, y: 3 }].include?(sqr.position)
          end

          allow(board_x1_x3).to receive(:get_square).with(exp_sqrs[0].position).and_return(exp_sqrs[0])
          allow(board_x1_x3).to receive(:get_square).with(exp_sqrs[1].position).and_return(exp_sqrs[1])
          result = wht_pawn.diagonal_move(board_x1_x3, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end
    end

    context 'when given black Pawn on square: { x: 1, y: 7 }' do
      let(:start_square) { double('Square', position: { x: 1, y: 7 }) }
      let(:blk_pawn) { described_class.new(:black, '♟︎', start_square) }

      context 'when given white enemy Piece on square: { x: 2, y: 6 }' do
        let(:enemy_piece) { double('Piece', color: :white) }
        let(:board_x2y6) { double('board', board: position_array) }

        before do
          board_x2y6.board.map! do |sqr|
            if sqr == [2, 6]
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: enemy_piece)
            else
              instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
            end
          end

          allow(board_x2y6).to receive(:square_taken?).and_return(false)
          allow(board_x2y6).to receive(:square_taken?).with({ x: 2, y: 6 }).and_return(true)
        end

        it 'returns square: { x: 2, y: 6 }' do
          exp_sqrs = board_x2y6.board.select do |sqr|
            [{ x: 2, y: 6 }].include?(sqr.position)
          end

          allow(board_x2y6).to receive(:get_square).with(exp_sqrs[0].position).and_return(exp_sqrs[0])
          result = blk_pawn.diagonal_move(board_x2y6, -1)
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
      subject(:wht_pawn) { described_class.new(:white, '♙', start_square) }

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
      subject(:wht_pawn) { described_class.new(:white, '♙', start_square) }

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
      subject(:blk_pawn) { described_class.new(:black, '♟︎', start_square) }

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
      subject(:wht_pawn) { described_class.new(:white, '♙', start_square) }

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
      subject(:wht_pawn) { described_class.new(:white, '♙', start_square) }

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
      subject(:wht_pawn) { described_class.new(:white, '♙', start_square) }

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

      it 'returns empty array' do
        expect(wht_pawn.en_passant_move(en_passant_board, 1)).to be_empty
      end
    end
  end
end
