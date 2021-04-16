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

        before do
          allow(blk_pawn_17).to receive(:find_relative_square).with(chess_board, x: -1, y: -1).and_return(square_26)
          allow(blk_pawn_17).to receive(:find_relative_square).with(chess_board, x: 1, y: -1).and_return(nil)
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
    let(:chess_board) { double('chess board', recorded_moves: []) }

    context 'when given white Pawn { x: 5, y: 5 } and black Pawn { x: 6, y: 5 } that has just moved from { x: 6, y: 7 }' do
      let(:square_65) { instance_double(Square, position: { x: 6, y: 5 }, taken?: true) }
      let(:square_45) { instance_double(Square, position: { x: 4, y: 5 }, taken?: false) }
      let(:square_66) { instance_double(Square, position: { x: 6, y: 6 }, taken?: false) }
      let(:start_square_55) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn_55) { described_class.new(start_square_55, :white) }

      before do
        allow(wht_pawn_55).to receive(:find_relative_square).with(chess_board, x: -1).and_return(square_45)
        allow(wht_pawn_55).to receive(:find_relative_square).with(chess_board, x: 1).and_return(square_65)
        allow(wht_pawn_55).to receive(:find_relative_square).with(chess_board, y: 1, initial_square: square_65).and_return(square_66)
        allow(wht_pawn_55).to receive(:en_passantable?).and_return(true)
      end

      it 'returns square { x: 6, y: 6 }' do
        exp_sqrs = [square_66]
        result = wht_pawn_55.en_passant_move(chess_board, 1)
        expect(result).to match_array(exp_sqrs)
      end
    end

    context 'when given white Pawn { x: 5, y: 5 } and black Pawn { x: 4, y: 5 } that has just moved from { x: 4, y: 7 }' do
      let(:square_45) { instance_double(Square, position: { x: 4, y: 5 }, taken?: true) }
      let(:square_65) { instance_double(Square, position: { x: 6, y: 5 }, taken?: false) }
      let(:start_square_55) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn_55) { described_class.new(start_square_55, :white) }
      let(:square_46) { instance_double(Square, position: { x: 4, y: 6 }, taken?: false) }


      before do
        allow(wht_pawn_55).to receive(:find_relative_square).with(chess_board, x: -1).and_return(square_45)
        allow(wht_pawn_55).to receive(:find_relative_square).with(chess_board, x: 1).and_return(square_65)
        allow(wht_pawn_55).to receive(:find_relative_square).with(chess_board, y: 1, initial_square: square_45).and_return(square_46)
        allow(wht_pawn_55).to receive(:en_passantable?).and_return(true)
      end

      it 'returns square { x: 4, y: 6 }' do
        exp_sqrs = [square_46]
        result = wht_pawn_55.en_passant_move(chess_board, 1)
        expect(result).to match_array(exp_sqrs)
      end
    end

    context 'when given black Pawn { x: 1, y: 4 } and white Pawn { x: 2, y: 4 } that has just moved from { x: 2, y: 2 }' do
      let(:square_24) { instance_double(Square, position: { x: 2, y: 4 }, taken?: true) }
      let(:start_square_14) { instance_double(Square, position: { x: 1, y: 4 }) }
      subject(:blk_pawn_14) { described_class.new(start_square_14, :black) }
      let(:square_23) { instance_double(Square, position: { x: 2, y: 3 }, taken?: false) }

      before do
        allow(blk_pawn_14).to receive(:find_relative_square).with(chess_board, x: -1).and_return(nil)
        allow(blk_pawn_14).to receive(:find_relative_square).with(chess_board, x: 1).and_return(square_24)
        allow(blk_pawn_14).to receive(:find_relative_square).with(chess_board, y: -1, initial_square: square_24).and_return(square_23)
        allow(blk_pawn_14).to receive(:en_passantable?).and_return(true)
      end

      it 'returns square { x: 2, y: 3 }' do
        exp_sqrs = [square_23]
        result = blk_pawn_14.en_passant_move(chess_board, -1)
        expect(result).to match_array(exp_sqrs)
      end
    end

    context 'when given white Pawn { x: 5, y: 5 } and black Pawn { x: 6, y: 5 } that has just moved from { x: 6, y: 6 }' do
      let(:square_65) { instance_double(Square, position: { x: 6, y: 5 }, taken?: true) }
      let(:square_45) { instance_double(Square, position: { x: 6, y: 5 }, taken?: false) }
      let(:start_square_55) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn_55) { described_class.new(start_square_55, :black) }

      before do
        allow(wht_pawn_55).to receive(:find_relative_square).with(chess_board, x: -1).and_return(square_45)
        allow(wht_pawn_55).to receive(:find_relative_square).with(chess_board, x: 1).and_return(square_65)
        allow(wht_pawn_55).to receive(:en_passantable?).and_return(false)
      end

      it 'returns empty array' do
        result = wht_pawn_55.en_passant_move(chess_board, 1)
        expect(result).to be_empty
      end
    end
  end

  describe '#en_passantable?' do
    subject(:wht_pawn) { described_class.new(nil, :white) }
    let(:enemy_square) { instance_double(Square) }
    let(:last_move) { [enemy_square] }

    context 'when given #enemy_pawn? is true, #move_difference_is_two? is true, and that piece is the last move' do
      it 'returns true' do
        allow(wht_pawn).to receive(:enemy_pawn?).and_return(true)
        allow(wht_pawn).to receive(:move_difference_is_two?).and_return(true)
        result = wht_pawn.en_passantable?(enemy_square, last_move)
        expect(result).to be true
      end
    end

    context 'when #enemy_pawn? is false' do
      it 'return false' do
        allow(wht_pawn).to receive(:enemy_pawn?).and_return(false)
        result = wht_pawn.en_passantable?(enemy_square, last_move)
        expect(result).to be false
      end
    end

    context 'when last_move ary doesn\'t include enemy square' do
      let(:last_move) { [nil] }
      it 'returns false' do
        allow(wht_pawn).to receive(:enemy_pawn?).and_return(true)
        result = wht_pawn.en_passantable?(enemy_square, last_move)
        expect(result).to be false
      end
    end

    context 'when #move_difference_is_two? is false' do
      it 'return false' do
        allow(wht_pawn).to receive(:enemy_pawn?).and_return(true)
        allow(wht_pawn).to receive(:move_difference_is_two?).and_return(false)
        result = wht_pawn.en_passantable?(enemy_square, last_move)
        expect(result).to be false
      end
    end
  end

  describe '#enemy_pawn?' do
    context 'when invoked on white Pawn' do
      subject(:wht_pawn) { described_class.new(nil, :white) }
      context 'when given black Pawn' do
        let(:enemy_pawn) { instance_double(Pawn, color: :black) }
        let(:enemy_square) { instance_double(Square, piece: enemy_pawn) }

        it 'returns true' do
          allow(enemy_pawn).to receive(:is_a?).and_return(true)
          result = wht_pawn.enemy_pawn?(enemy_square)
          expect(result).to be true
        end
      end

      context 'when given black Piece (not Pawn)' do
        let(:enemy_piece) { instance_double(Piece, color: :black) }
        let(:enemy_square) { instance_double(Square, piece: enemy_piece) }

        it 'returns false' do
          allow(enemy_piece).to receive(:is_a?).and_return(false)
          result = wht_pawn.enemy_pawn?(enemy_square)
          expect(result).to be false
        end
      end

      context 'when given white Pawn' do
        let(:friendly_pawn) { instance_double(Pawn, color: :white) }
        let(:friendly_square) { instance_double(Square, piece: friendly_pawn) }

        it 'returns false' do
          allow(friendly_pawn).to receive(:is_a?).and_return(true)
          result = wht_pawn.enemy_pawn?(friendly_square)
          expect(result).to be false
        end
      end
    end
  end

  describe '#enemy_pawn_square' do
    let(:chess_board) { double('Board') }

    context 'when given square { x: 4, y: 6 } with white Pawn' do
      subject(:wht_pawn) { described_class.new(nil, :white) }
      let(:given_square) { instance_double(Square, position: { x: 4, y: 6 }) }
      let(:expected_square) { instance_double(Square, position: { x: 4, y: 5 }) }

      it 'returns square { x: 4, y: 5 } with enemy Pawn on it' do
        allow(wht_pawn).to receive(:find_relative_square).with(chess_board, y: -1, initial_square: given_square).and_return(expected_square)
        result = wht_pawn.enemy_pawn_square(given_square, chess_board)
        expect(result).to eq(expected_square)
      end
    end
  end

  describe '#take_enemy_piece' do
    let(:chess_board) { double('Board') }

    context 'when given square { x: 3, y: 6 }' do
      subject(:wht_pawn) { described_class.new(nil, :white) }
      let(:square_36) { instance_double(Square, position: { x: 3, y: 6 }) }
      let(:square_35) { instance_double(Square, position: { x: 3, y: 5 }) }

      it 'sends :update_piece message to { x: 3, y: 5}' do
        allow(wht_pawn).to receive(:enemy_pawn_square).with(square_36, chess_board).and_return(square_35)
        expect(square_35).to receive(:update_piece)
        wht_pawn.take_enemy_piece(square_36, chess_board)
      end
    end
  end
end
