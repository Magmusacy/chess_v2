# frozen_string_literal: true

require_relative 'shared_piece_spec'
require_relative '../../lib/pieces/pawn'
require_relative '../../lib/board'
require_relative '../../lib/square'

describe Pawn do
  let(:chess_board) { instance_double(Board) }

  context 'when Pawn is a child class of Piece' do
    subject(:pawn) { described_class.new(nil, nil) }
    include_examples 'base class methods names'
  end

  context 'when Pawn has the same method name' do
    subject(:pawn) { described_class.new(nil, nil) }
    include_examples 'shared method names'
  end

  describe '#possible_moves' do
    subject(:possible_pawn) { described_class.new(nil, :white) }
    let(:white_piece) { instance_double(Piece, color: :white) }
    let(:possible_move) { [instance_double(Square, taken?: false)] }
    let(:impossible_move) { [instance_double(Square, taken?: true, piece: white_piece)] }

    before do
      allow(possible_pawn).to receive(:vertical_move).and_return([])
      allow(possible_pawn).to receive(:diagonal_move).and_return([])
      allow(possible_pawn).to receive(:en_passant_move).and_return([])
      allow(possible_pawn).to receive(:promotion_move).and_return([])
    end

    context 'when only #vertical_move returns a possible legal move' do
      it 'returns an array with 1 possible move' do
        allow(possible_pawn).to receive(:vertical_move).with(chess_board).and_return(possible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #diagonal_move with x = 1 returns a possible legal move' do
      it 'returns an array with 1 possible move' do
        allow(possible_pawn).to receive(:diagonal_move).with(chess_board, 1).and_return(possible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #diagonal_move with x = -1 returns a possible legal move' do
      it 'returns an array with 1 possible move' do
        allow(possible_pawn).to receive(:diagonal_move).with(chess_board, -1).and_return(possible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #en_passant_move with x = 1 returns a possible legal move' do
      it 'returns an array with 1 possible move' do
        allow(possible_pawn).to receive(:en_passant_move).with(chess_board, 1).and_return(possible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #en_passant_move with x = -1 returns a possible legal move' do
      it 'returns an array with 1 possible move' do
        allow(possible_pawn).to receive(:en_passant_move).with(chess_board, -1).and_return(possible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #promotion_move with x = 0 returns a possible legal move' do
      it 'returns an array with 1 possible move' do
        allow(possible_pawn).to receive(:promotion_move).with(chess_board, 0).and_return(possible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #promotion_move with x = 1 returns a possible legal move' do
      it 'returns an array with 1 possible move' do
        allow(possible_pawn).to receive(:promotion_move).with(chess_board, 1).and_return(possible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when only #promotion_move with x = -1 returns a possible legal move' do
      it 'returns an array with 1 possible move' do
        allow(possible_pawn).to receive(:promotion_move).with(chess_board, -1).and_return(possible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when there are 2 possible moves but one of them has square with Piece the same color as given Pawn' do
      it 'returns an array with 1 possible legal move' do
        allow(possible_pawn).to receive(:diagonal_move).with(chess_board, 1).and_return(possible_move)
        allow(possible_pawn).to receive(:diagonal_move).with(chess_board, -1).and_return(impossible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end
  end

  describe '#vertical_move' do
    context 'when given :white Pawn on square { x: 2, y: 2 }' do
      let(:start_square_22) { instance_double(Square, position: { x: 2, y: 2 }) }
      subject(:wht_pawn_22) { described_class.new(start_square_22, :white) }

      context 'when squares { x: 2, y: 3 } and { x: 2, y: 4 } are empty' do
        let(:square_23) { instance_double(Square, position: { x: 2, y: 3 }, taken?: false) }
        let(:square_24) { instance_double(Square, position: { x: 2, y: 4 }, taken?: false) }

        it 'returns array with two squares: { x: 2, y: 3 }, { x: 2, y: 4 }' do
          allow(chess_board).to receive(:get_relative_square).with(start_square_22, y: 1).and_return(square_23)
          allow(chess_board).to receive(:get_relative_square).with(start_square_22, y: 2).and_return(square_24)
          expected = [square_23, square_24]
          result = wht_pawn_22.vertical_move(chess_board)
          expect(result).to match_array(expected)
        end
      end

      context 'when square { x: 2, y: 4 } is taken' do
        let(:square_23) { instance_double(Square, position: { x: 2, y: 3 }, taken?: false) }
        let(:square_24) { instance_double(Square, position: { x: 2, y: 4 }, taken?: true) }

        it 'returns square: { x: 2, y: 3 }' do
          allow(chess_board).to receive(:get_relative_square).with(start_square_22, y: 1).and_return(square_23)
          allow(chess_board).to receive(:get_relative_square).with(start_square_22, y: 2).and_return(square_24)
          expected = [square_23]
          result = wht_pawn_22.vertical_move(chess_board)
          expect(result).to match_array(expected)
        end
      end

      context 'when square { x: 2, y: 3 } is taken' do
        let(:square_23) { instance_double(Square, position: { x: 2, y: 3 }, taken?: true) }

        it 'returns empty array' do
          allow(chess_board).to receive(:get_relative_square).with(start_square_22, y: 1).and_return(square_23)
          result = wht_pawn_22.vertical_move(chess_board)
          expect(result).to be_empty
        end
      end
    end

    context 'when given :black Pawn on square: { x: 2, y: 7 }' do
      let(:start_square_27) { instance_double(Square, position: { x: 2, y: 7 }) }
      subject(:blk_pawn_27) { described_class.new(start_square_27, :black) }
      let(:square_26) { instance_double(Square, position: { x: 2, y: 6 }, taken?: false) }
      let(:square_25) { instance_double(Square, position: { x: 2, y: 5 }, taken?: false) }

      before do
        allow(chess_board).to receive(:get_relative_square).with(start_square_27, y: -1).and_return(square_26)
        allow(chess_board).to receive(:get_relative_square).with(start_square_27, y: -2).and_return(square_25)
      end

      context 'when squares { x: 2, y: 6 } and { x: 2, y: 5 } are empty' do
        it 'returns array with two squares: { x: 2, y: 6 }, { x: 2, y: 5 }' do
          expected = [square_26, square_25]
          result = blk_pawn_27.vertical_move(chess_board)
          expect(result).to match_array(expected)
        end
      end

      context 'when square { x: 2, y: 5 } is taken' do
        let(:square_25) { instance_double(Square, position: { x: 2, y: 5 }, taken?: true) }

        it 'returns square: { x: 2, y: 6 }' do
          expected = [square_26]
          result = blk_pawn_27.vertical_move(chess_board)
          expect(result).to match_array(expected)
        end
      end

      context 'when square { x: 2, y: 6 } is taken' do
        let(:square_26) { instance_double(Square, position: { x: 2, y: 6 }, taken?: true) }

        it 'returns empty array' do
          result = blk_pawn_27.vertical_move(chess_board)
          expect(result).to be_empty
        end
      end
    end

    context 'when given :white Pawn on square { x: 2, y: 7 } and { x: 2, y: 8 } isn\'t taken' do
      let(:start_square_27) { instance_double(Square, position: { x: 2, y: 7 }) }
      subject(:wht_pawn_27) { described_class.new(start_square_27, :white) }
      let(:square_28) { instance_double(Square, position: { x: 2, y: 8 }, taken?: false) }

      it 'returns array with only square { x: 2, y: 8 }' do
        allow(chess_board).to receive(:get_relative_square).with(start_square_27, y: 1).and_return(square_28)
        result = wht_pawn_27.vertical_move(chess_board)
        expect(result).to match_array([square_28])
      end
    end

    context 'when given :black Pawn on square { x: 2, y: 2 } and { x: 2, y: 1 } isn\'t taken' do
      let(:start_square_22) { instance_double(Square, position: { x: 2, y: 2 }) }
      subject(:blk_pawn_22) { described_class.new(start_square_22, :black) }
      let(:square_21) { instance_double(Square, position: { x: 2, y: 1 }, taken?: false) }

      it 'returns array with only square { x: 2, y: 1 }' do
        allow(chess_board).to receive(:get_relative_square).with(start_square_22, y: -1).and_return(square_21)
        result = blk_pawn_22.vertical_move(chess_board)
        expect(result).to match_array([square_21])
      end
    end
  end

  describe '#diagonal_move' do
    context 'when given :white Pawn object with square position: { x: 2, y: 2 }' do
      let(:start_square_22) { instance_double(Square, position: { x: 2, y: 2 }) }
      subject(:wht_pawn_22) { described_class.new(start_square_22, :white) }

      context 'when given x = 1' do
        let(:x) { 1 }

        context 'when square { x: 3, y: 3 } is taken' do
          let(:square_33) { instance_double(Square, position: { x: 3, y: 3 }, taken?: true) }

          it 'returns array with square { x: 3, y: 3 }' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_22, x: 1, y: 1).and_return(square_33)
            result = wht_pawn_22.diagonal_move(chess_board, x)
            expect(result).to match_array([square_33])
          end
        end
      end

      context 'when given x = -1' do
        let(:x) { -1 }

        context 'when square { x: 1, y: 3 } is taken' do
          let(:square_13) { instance_double(Square, position: { x: 1, y: 3 }, taken?: true) }

          it 'returns array with square { x: 1, y: 3 }' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_22, x: -1, y: 1).and_return(square_13)
            result = wht_pawn_22.diagonal_move(chess_board, x)
            expect(result).to match_array([square_13])
          end
        end
      end
    end

    context 'when given :black Pawn object with square position: { x: 2, y: 7 }' do
      let(:start_square_27) { instance_double(Square, position: { x: 2, y: 7 }) }
      subject(:blk_pawn_27) { described_class.new(start_square_27, :black) }

      context 'when given x = 1' do
        let(:x) { 1 }

        context 'when square { x: 3, y: 6 } is taken' do
          let(:square_36) { instance_double(Square, position: { x: 3, y: 6 }, taken?: true) }

          it 'returns array with square { x: 3, y: 6 }' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_27, x: 1, y: -1).and_return(square_36)
            result = blk_pawn_27.diagonal_move(chess_board, x)
            expect(result).to match_array([square_36])
          end
        end
      end

      context 'when given x = -1' do
        let(:x) { -1 }

        context 'when square { x: 1, y: 3 } is taken' do
          let(:wht_piece_16) { instance_double(Piece, color: :white) }
          let(:square_16) { instance_double(Square, position: { x: 1, y: 6 }, taken?: true) }

          it 'returns array with square { x: 1, y: 3 }' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_27, x: -1, y: -1).and_return(square_16)
            result = blk_pawn_27.diagonal_move(chess_board, x)
            expect(result).to match_array([square_16])
          end
        end
      end
    end

    context 'when move results in a square that is not taken' do
      let(:start_square_12) { instance_double(Square, position: { x: 1, y: 2 }) }
      let(:empty_square) { instance_double(Square, position: { x: 2, y: 3 }, taken?: false) }
      subject(:invalid_piece) { described_class.new(start_square_12, :white) }

      it 'returns empty array' do
        allow(chess_board).to receive(:get_relative_square).with(start_square_12, x: 1, y: 1).and_return(empty_square)
        result = invalid_piece.diagonal_move(chess_board, 1)
        expect(result).to be_empty
      end
    end

    context 'when move results in a square that is not on the board' do
      let(:start_square_12) { instance_double(Square, position: { x: 1, y: 2 }) }
      subject(:invalid_piece) { described_class.new(start_square_12, :white) }

      it 'returns empty array' do
        allow(chess_board).to receive(:get_relative_square).with(start_square_12, x: -1, y: 1).and_return(nil)
        result = invalid_piece.diagonal_move(chess_board, -1)
        expect(result).to be_empty
      end
    end
  end

  describe '#en_passant_move' do
    let(:chess_board) { instance_double(Board, recorded_moves: []) }

    context 'when given :white Pawn { x: 5, y: 5 }' do
      let(:start_square_55) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn_55) { described_class.new(start_square_55, :white) }

      context 'when x = 1' do
        let(:x) { 1 }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_55, x: 1).and_return(square_65)
          allow(chess_board).to receive(:get_relative_square).with(start_square_55, x: 1, y: 1).and_return(square_66)
        end

        context 'when :black Pawn { x: 6, y: 5 } has just moved from { x: 6, y: 7 }' do
          let(:blk_pawn_65) { instance_double(Pawn, color: :black) }
          let(:start_square_67) { instance_double(Square, position: { x: 6, y: 7 }, taken?: false) }
          let(:square_65) { instance_double(Square, position: { x: 6, y: 5 }, taken?: true, piece: blk_pawn_65) }
          let(:square_66) { instance_double(Square, position: { x: 6, y: 6 }, taken?: false) }
          let(:latest_move) { [start_square_67, square_65] }

          before do
            allow(chess_board).to receive(:recorded_moves).and_return([latest_move])
            allow(blk_pawn_65).to receive(:is_a?).with(Pawn).and_return(true)
          end

          it 'returns square { x: 6, y: 6 }' do
            exp_sqrs = [square_66]
            result = wht_pawn_55.en_passant_move(chess_board, x)
            expect(result).to match_array(exp_sqrs)
          end
        end
      end

      context 'when x = -1' do
        let(:x) { -1 }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_55, x: -1).and_return(square_45)
          allow(chess_board).to receive(:get_relative_square).with(start_square_55, x: -1, y: 1).and_return(square_46)
        end

        context 'when :black Pawn { x: 4, y: 5 } has just moved from { x: 4, y: 7 }' do
          let(:blk_pawn_45) { instance_double(Pawn, color: :black) }
          let(:start_square_47) { instance_double(Square, position: { x: 4, y: 7 }, taken?: false) }
          let(:square_45) { instance_double(Square, position: { x: 4, y: 5 }, taken?: true, piece: blk_pawn_45) }
          let(:square_46) { instance_double(Square, position: { x: 4, y: 6 }, taken?: false) }
          let(:latest_move) { [start_square_47, square_45] }

          before do
            allow(chess_board).to receive(:recorded_moves).and_return([latest_move])
            allow(blk_pawn_45).to receive(:is_a?).with(Pawn).and_return(true)
          end

          it 'returns square { x: 4, y: 6 }' do
            exp_sqrs = [square_46]
            result = wht_pawn_55.en_passant_move(chess_board, x)
            expect(result).to match_array(exp_sqrs)
          end
        end
      end

      context 'when adjacent square is occupied by :white Piece' do
        let(:wht_piece_45) { instance_double(Pawn, color: :white) }
        let(:start_square_47) { instance_double(Square, position: { x: 4, y: 7 }, taken?: false) }
        let(:square_45) { instance_double(Square, position: { x: 4, y: 5 }, taken?: true, piece: wht_piece_45) }

        it 'returns empty array' do
          allow(chess_board).to receive(:get_relative_square).with(start_square_55, x: -1).and_return(square_45)
          result = wht_pawn_55.en_passant_move(chess_board, -1)
          expect(result).to be_empty
        end
      end
    end

    context 'when given :black Pawn { x: 5, y: 4 }' do
      let(:start_square_54) { instance_double(Square, position: { x: 5, y: 4 }) }
      subject(:blk_pawn_54) { described_class.new(start_square_54, :black) }

      context 'when x = 1' do
        let(:x) { 1 }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_54, x: 1).and_return(square_64)
          allow(chess_board).to receive(:get_relative_square).with(start_square_54, x: 1, y: -1).and_return(square_63)
        end

        context 'when :white Pawn { x: 6, y: 4 } has just moved from { x: 6, y: 2 }' do
          let(:wht_pawn_64) { instance_double(Pawn, color: :white) }
          let(:start_square_62) { instance_double(Square, position: { x: 6, y: 2 }, taken?: false) }
          let(:square_64) { instance_double(Square, position: { x: 6, y: 4 }, taken?: true, piece: wht_pawn_64) }
          let(:square_63) { instance_double(Square, position: { x: 6, y: 3 }, taken?: false) }
          let(:latest_move) { [start_square_62, square_64] }

          before do
            allow(chess_board).to receive(:recorded_moves).and_return([latest_move])
            allow(wht_pawn_64).to receive(:is_a?).with(Pawn).and_return(true)
          end

          it 'returns square { x: 6, y: 3 }' do
            exp_sqrs = [square_63]
            result = blk_pawn_54.en_passant_move(chess_board, x)
            expect(result).to match_array(exp_sqrs)
          end
        end
      end

      context 'when x = -1' do
        let(:x) { -1 }

        before do
          allow(chess_board).to receive(:get_relative_square).with(start_square_54, x: -1).and_return(square_44)
          allow(chess_board).to receive(:get_relative_square).with(start_square_54, x: -1, y: -1).and_return(square_43)
        end

        context 'when :black Pawn { x: 4, y: 4 } has just moved from { x: 4, y: 2 }' do
          let(:wht_pawn_44) { instance_double(Pawn, color: :white) }
          let(:start_square_42) { instance_double(Square, position: { x: 4, y: 2 }, taken?: false) }
          let(:square_44) { instance_double(Square, position: { x: 4, y: 4 }, taken?: true, piece: wht_pawn_44) }
          let(:square_43) { instance_double(Square, position: { x: 4, y: 3 }, taken?: false) }
          let(:latest_move) { [start_square_42, square_44] }

          before do
            allow(chess_board).to receive(:recorded_moves).and_return([latest_move])
            allow(wht_pawn_44).to receive(:is_a?).with(Pawn).and_return(true)
          end

          it 'returns square { x: 4, y: 3 }' do
            exp_sqrs = [square_43]
            result = blk_pawn_54.en_passant_move(chess_board, x)
            expect(result).to match_array(exp_sqrs)
          end
        end
      end

      context 'when adjacent square is occupied by :black Piece' do
        let(:blk_piece_44) { instance_double(Pawn, color: :white) }
        let(:square_44) { instance_double(Square, position: { x: 4, y: 4 }, taken?: true, piece: blk_piece_44) }

        it 'returns empty array' do
          allow(chess_board).to receive(:get_relative_square).with(start_square_54, x: -1).and_return(square_44)
          result = blk_pawn_54.en_passant_move(chess_board, -1)
          expect(result).to be_empty
        end
      end
    end



    context 'when adjacent square is an enemy Piece (not pawn)' do
      let(:start_square_55) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn_55) { described_class.new(start_square_55, :white) }
      let(:blk_piece_65) { instance_double(Pawn, color: :black) }
      let(:start_square_47) { instance_double(Square, position: { x: 6, y: 7 }, taken?: false) }
      let(:square_65) { instance_double(Square, position: { x: 6, y: 5 }, taken?: true, piece: blk_piece_65) }

      it 'returns empty array' do
        allow(chess_board).to receive(:get_relative_square).with(start_square_55, x: 1).and_return(square_65)
        allow(blk_piece_65).to receive(:is_a?).with(Pawn).and_return(false)
        result = wht_pawn_55.en_passant_move(chess_board, 1)
        expect(result).to be_empty
      end
    end

    context 'when last move doesn\'t include enemy Pawn' do
      let(:start_square_55) { instance_double(Square, position: { x: 5, y: 5 }) }
      subject(:wht_pawn_55) { described_class.new(start_square_55, :white) }
      let(:blk_pawn_45) { instance_double(Pawn, color: :black) }
      let(:start_square_47) { instance_double(Square, position: { x: 4, y: 7 }, taken?: false) }
      let(:square_45) { instance_double(Square, position: { x: 4, y: 5 }, taken?: true, piece: blk_pawn_45) }
      let(:square_24) { instance_double(Square, position: { x: 2, y: 4 }, taken?: false) }
      let(:square_22) { instance_double(Square, position: { x: 2, y: 2 }, taken?: false) }
      let(:latest_move) { [square_24, square_22] }
      let(:previous_move) { [start_square_47, square_45] }

      before do
        allow(chess_board).to receive(:recorded_moves).and_return([previous_move, latest_move])
        allow(blk_pawn_45).to receive(:is_a?).with(Pawn).and_return(true)
      end

      it 'returns empty array' do
        allow(chess_board).to receive(:get_relative_square).with(start_square_55, x: -1).and_return(square_45)
        result = wht_pawn_55.en_passant_move(chess_board, -1)
        expect(result).to be_empty
      end
    end
  end

  describe '#take_enemy_pawn' do
    let(:chess_board) { instance_double(Board) }

    context 'when given square { x: 3, y: 6 }' do
      subject(:wht_pawn) { described_class.new(nil, :white) }
      let(:square_36) { instance_double(Square, position: { x: 3, y: 6 }) }
      let(:square_35) { instance_double(Square, position: { x: 3, y: 5 }) }

      it 'sends :update_piece message to { x: 3, y: 5}' do
        allow(wht_pawn).to receive(:enemy_pawn_square).with(square_36, chess_board).and_return(square_35)
        expect(square_35).to receive(:update_piece)
        wht_pawn.take_enemy_pawn(square_36, chess_board)
      end
    end
  end
end
