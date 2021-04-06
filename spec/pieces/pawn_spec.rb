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

  describe '#y_axis_moves' do
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
          result = wht_pawn.y_axis_moves(board_y3_y4, 1)
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
          result = wht_pawn.y_axis_moves(board_y4, 1)
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
          result = wht_pawn.y_axis_moves(board_zero, 1)
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
          result = wht_pawn.y_axis_moves(board_y6, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end
    end
  end

  describe '#diagonal_moves' do
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
          result = wht_pawn.diagonal_moves(board_zero, 1)
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
          result = wht_pawn.diagonal_moves(board_y3, 1)
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
          result = wht_pawn.diagonal_moves(board_x1_x3, 1)
          expect(result).to match_array(exp_sqrs)
        end
      end
    end

    context 'when given black Pawn on square: { x: 1, y: 7 }' do
      let(:start_square) { double('Square', position: { x: 1, y: 7 }) }
      let(:blk_pawn) { described_class.new(:black, '♙', start_square) }

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
          result = blk_pawn.diagonal_moves(board_x2y6, -1)
          expect(result).to match_array(exp_sqrs)
        end
      end
    end
  end

  describe '#en_passant' do
    context 'when given white Pawn { x: 5, y: 5 } and black Pawn { x: 6, y: 5 } that has just moved' do
      let(:start_square) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn) { described_class.new(:white, '♙', start_square) }
      let(:blk_pawn) { instance_double(Pawn, color: :black) }

      let(:en_passant_board) { double('board', board: position_array) }
      before do
        en_passant_board.board.map! do |sqr|
          if sqr == [6, 5]
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: blk_pawn)
          else
            instance_double(Square, position: { x: sqr.first, y: sqr.last }, piece: '   ')
          end
        end
      end

      it 'returns square { x: 6, y: 6 }' do
        square_board = en_passant_board.board
        exp_sqrs = en_passant_board.board.select do |sqr|
          [{ x: 5, y: 6 },
           { x: 6, y: 7 }].include?(sqr.position)
        end
        expect(pawn.legal_moves(square_board)).to match_array(exp_sqrs)
      end
    end
  end
end

#  describe '#move' do
#    context '' do
#      it 'blahblahblah' do
#      end
#    end
#  end
# end
