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
      allow(possible_pawn).to receive(:discard_related_squares).with(possible_move).and_return(possible_move)
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

    context 'when there are 2 possible moves but one of them has square with Piece the same color as calling Pawn' do
      it 'returns an array with 1 possible legal move' do
        returned_array = [possible_move, impossible_move].flatten
        allow(possible_pawn).to receive(:discard_related_squares).with(returned_array).and_return(possible_move)
        allow(possible_pawn).to receive(:diagonal_move).with(chess_board, 1).and_return(possible_move)
        allow(possible_pawn).to receive(:diagonal_move).with(chess_board, -1).and_return(impossible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to match_array(possible_move)
      end
    end

    context 'when there is 1 possible move on square with Piece the same color as calling Pawn' do
      it 'returns empty array' do
        empty_array = []
        allow(possible_pawn).to receive(:discard_related_squares).with(impossible_move).and_return(empty_array)
        allow(possible_pawn).to receive(:vertical_move).with(chess_board).and_return(impossible_move)
        result = possible_pawn.possible_moves(chess_board)
        expect(result).to be_empty
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

  describe '#promotion_move' do
    context 'when called on :white Pawn { x: 2, y: 7 }' do
      let(:start_square_27) { instance_double(Square, position: { x: 2, y: 7 }) }
      subject(:wht_pawn_27) { described_class.new(start_square_27, :white) }
      let(:black_piece) { instance_double(Piece, color: :black) }

      context 'when x = 0' do
        let(:x) { 0 }

        context 'when square { x: 2, y: 8 } isn\'t taken' do
          let(:square_28) { instance_double(Square, position: { x: 2, y: 8 }, taken?: false) }

          it 'returns square { x: 2, y: 8 }' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_27, y: 1).and_return(square_28)
            result = wht_pawn_27.promotion_move(chess_board, x)
            expect(result).to match_array([square_28])
          end
        end

        context 'when square { x: 2, y: 8 } is taken' do
          let(:square_28) { instance_double(Square, position: { x: 2, y: 8 }, taken?: true) }

          it 'returns empty array' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_27, y: 1).and_return(square_28)
            result = wht_pawn_27.promotion_move(chess_board, x)
            expect(result).to be_empty
          end
        end
      end

      context 'when x = 1' do
        let(:x) { 1 }

        context 'when square { x: 3, y: 8 } is taken by enemy' do
          let(:square_38) { instance_double(Square, position: { x: 3, y: 8 }, taken?: true, piece: black_piece) }

          it 'returns square { x: 3, y: 8 }' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_27, x: 1, y: 1).and_return(square_38)
            allow(wht_pawn_27).to receive(:discard_related_squares).with([square_38]).and_return([square_38])
            result = wht_pawn_27.promotion_move(chess_board, x)
            expect(result).to match_array([square_38])
          end
        end

        context 'when square { x: 3, y: 8 } isn\'t taken' do
          let(:square_38) { instance_double(Square, position: { x: 3, y: 8 }, taken?: false) }

          it 'returns square empty array' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_27, x: 1, y: 1).and_return(square_38)
            result = wht_pawn_27.promotion_move(chess_board, x)
            expect(result).to be_empty
          end
        end
      end

      context 'when x = -1' do
        let(:x) { -1 }

        context 'when square { x: 1, y: 8 } is taken by enemy' do
          let(:square_18) { instance_double(Square, position: { x: 1, y: 8 }, taken?: true, piece: black_piece) }

          it 'returns square { x: 1, y: 8 }' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_27, x: -1, y: 1).and_return(square_18)
            allow(wht_pawn_27).to receive(:discard_related_squares).with([square_18]).and_return([square_18])
            result = wht_pawn_27.promotion_move(chess_board, x)
            expect(result).to match_array([square_18])
          end
        end

        context 'when square { x: 1, y: 8 } isn\'t taken' do
          let(:square_18) { instance_double(Square, position: { x: 1, y: 8 }, taken?: false) }

          it 'returns empty array' do
            allow(chess_board).to receive(:get_relative_square).with(start_square_27, x: -1, y: 1).and_return(square_18)
            result = wht_pawn_27.promotion_move(chess_board, x)
            expect(result).to be_empty
          end
        end
      end
    end

    context 'when x = 1 and obtained square is occupied by Piece with the same color as Pawn' do
      let(:start_square_27) { instance_double(Square, position: { x: 2, y: 7 }) }
      subject(:wht_pawn_27) { described_class.new(start_square_27, :white) }
      let(:white_piece) { instance_double(Piece, color: :white) }
      let(:square_38) { instance_double(Square, position: { x: 3, y: 8 }, taken?: true, piece: white_piece) }

      it 'returns empty array' do
        allow(chess_board).to receive(:get_relative_square).with(start_square_27, x: 1, y: 1).and_return(square_38)
        allow(wht_pawn_27).to receive(:discard_related_squares).with([square_38]).and_return([])
        result = wht_pawn_27.promotion_move(chess_board, 1)
        expect(result).to be_empty
      end
    end
  end

  describe '#piece_input' do
    subject(:promotion_pawn) { described_class.new }
    # run method that shows the things to click you know
    # return input symbol
    # else output error message

    context 'when given correct input on the first try' do
      it 'doesn\'t output error message' do
        error_message = 'Wrong input!'
        allow(promotion_pawn).to receive(:input).and_return(2)
        expect(promotion_pawn).not_to receive(:puts).with(error_message)
        promotion_pawn.piece_input
      end
    end

    context 'when given correct input on the third try' do
      it 'outputs error message 2 times' do
        error_message = 'Wrong input!'
        allow(promotion_pawn).to receive(:input).and_return(5, -1, 3)
        expect(promotion_pawn).to receive(:puts).with(error_message).twice
        promotion_pawn.piece_input
      end
    end
  end

  describe '#verify_piece' do
    subject(:verify_pawn) { described_class.new }

    context 'when input is: 0' do
      it 'returns :bishop symbol' do
        input = 0
        expected = :bishop
        expect(verify_pawn.verify_piece(input)).to eq(expected)
      end
    end

    context 'when input is: 1' do
      it 'returns :knight symbol' do
        input = 1
        expected = :knight
        expect(verify_pawn.verify_piece(input)).to eq(expected)
      end
    end

    context 'when input is: 2' do
      it 'returns :queen symbol' do
        input = 2
        expected = :queen
        expect(verify_pawn.verify_piece(input)).to eq(expected)
      end
    end

    context 'when input is: 3' do
      it 'returns :rook symbol' do
        input = 3
        expected = :rook
        expect(verify_pawn.verify_piece(input)).to eq(expected)
      end
    end

    context 'when input is lower than 0' do
      it 'returns nil' do
        input = -1
        expect(verify_pawn.verify_piece(input)).to be_nil
      end
    end

    context 'when input bigger than 3' do
      it 'returns nil' do
        input = 4
        expect(verify_pawn.verify_piece(input)).to be_nil
      end
    end
  end

  describe '#promote' do
    let(:color) { :white }
    let(:start_square_27) { instance_double(Square, position: { x: 2, y: 7 }) }
    subject(:wht_pawn_27) { described_class.new(start_square_27, color) }
    let(:attributes) { [start_square_27, color] }
    let(:new_piece) { instance_double(Piece) }
    let(:chosen_square) { instance_double(Square) }

    before do
      allow(wht_pawn_27).to receive(:create_instance).and_return(new_piece)
      allow(start_square_27).to receive(:update_piece)
      allow(new_piece).to receive(:move)
    end

    context 'when piece argument has the default value' do
      before do
        allow(wht_pawn_27).to receive(:piece_input).and_return(:bishop)
      end

      it 'calls #create_instance with new piece symbol and Pawn\'s location and color in array' do
        expect(wht_pawn_27).to receive(:create_instance).with(:bishop, attributes)
        wht_pawn_27.promote(chosen_square, chess_board)
      end

      it 'calls #piece_input' do
        expect(wht_pawn_27).to receive(:piece_input)
        wht_pawn_27.promote(chosen_square, chess_board)
      end

      it 'sends :update_piece message to Pawn\'s location with returned new piece object from #create_instance' do
        expect(start_square_27).to receive(:update_piece).with(new_piece)
        wht_pawn_27.promote(chosen_square, chess_board)
      end

      it 'sends :move message to new piece object with chosen_square and board arguments' do
        expect(new_piece).to receive(:move).with(chosen_square, chess_board)
        wht_pawn_27.promote(chosen_square, chess_board)
      end
    end

    context 'when explicitly specified piece argument' do
      it 'doesn\'t call #piece_input' do
        expect(wht_pawn_27).not_to receive(:piece_input)
        wht_pawn_27.promote(chosen_square, chess_board, :bishop)
      end
    end
  end

  describe '#move' do
    let(:start_square) { instance_double(Square) }
    subject(:pawn) { described_class.new(start_square) }
    let(:square) { instance_double(Square) }
    let(:move_array) { [start_square, square] }

    before do
      allow(pawn).to receive(:promotion_move)
    end

    context 'when promotion is available' do
      let(:input_piece) { :bishop }

      before do
        allow(pawn).to receive(:piece_input).and_return(input_piece)
        allow(pawn).to receive(:promote)
      end

      context 'when specified move square is in array returned by #promotion_move with x = 0' do

        before do
          allow(pawn).to receive(:promotion_move).with(chess_board, 0).and_return(square)
        end

        after do
          pawn.move(square, chess_board)
        end

        it 'calls #promote with default Piece parameter' do
          expect(pawn).to receive(:promote).with(square, chess_board)
        end

        it 'doesn\'t send :add_move message to Board' do
          expect(chess_board).not_to receive(:add_move).with(move_array)
        end

        it 'doesn\'t send :update_piece message given square' do
          expect(square).not_to receive(:update_piece).with(pawn)
        end

        it 'doesn\'t send :update_piece message to self location' do
          expect(start_square).not_to receive(:update_piece).with(no_args)
        end

        it 'doesn\'t call #update_location ' do
          expect(pawn).not_to receive(:update_location)
        end
      end

      context 'when specified move square is in array returned by #promotion_move with x = 1' do

        before do
          allow(pawn).to receive(:promotion_move).with(chess_board, 1).and_return(square)
        end

        after do
          pawn.move(square, chess_board)
        end

        it 'calls #promote with default Piece parameter' do
          expect(pawn).to receive(:promote).with(square, chess_board)
        end

        it 'doesn\'t send :add_move message to Board' do
          expect(chess_board).not_to receive(:add_move).with(move_array)
        end

        it 'doesn\'t send :update_piece message given square' do
          expect(square).not_to receive(:update_piece).with(pawn)
        end

        it 'doesn\'t send :update_piece message to self location' do
          expect(start_square).not_to receive(:update_piece).with(no_args)
        end

        it 'doesn\'t call #update_location ' do
          expect(pawn).not_to receive(:update_location)
        end
      end

      context 'when specified move square is in array returned by #promotion_move with x = -1' do

        before do
          allow(pawn).to receive(:promotion_move).with(chess_board, 1).and_return(square)
        end

        after do
          pawn.move(square, chess_board)
        end

        it 'calls #promote with default Piece parameter' do
          expect(pawn).to receive(:promote).with(square, chess_board)
        end

        it 'doesn\'t send :add_move message to Board' do
          expect(chess_board).not_to receive(:add_move).with(move_array)
        end

        it 'doesn\'t send :update_piece message given square' do
          expect(square).not_to receive(:update_piece).with(pawn)
        end

        it 'doesn\'t send :update_piece message to self location' do
          expect(start_square).not_to receive(:update_piece).with(no_args)
        end

        it 'doesn\'t call #update_location ' do
          expect(pawn).not_to receive(:update_location)
        end
      end
    end

    context 'when promotion is unavailable' do

      before do
        allow(square).to receive(:update_piece).with(pawn)
        allow(start_square).to receive(:update_piece)
        allow(chess_board).to receive(:add_move).with(move_array)
        allow(pawn).to receive(:update_location)
        allow(pawn).to receive(:take_enemy_pawn)
        allow(pawn).to receive(:en_passant_move)
      end

      context 'when specified move square is in array returned by #en_passant_move with x = 1' do
        it 'calls #take_enemy_pawn with that square and board argument' do
          allow(pawn).to receive(:en_passant_move).with(chess_board, 1).and_return(square)
          expect(pawn).to receive(:take_enemy_pawn).with(square, chess_board)
          pawn.move(square, chess_board)
        end
      end

      context 'when specified move square is in array returned by #en_passant_move with x = -1' do
        it 'calls #take_enemy_pawn with that square and board argument' do
          allow(pawn).to receive(:en_passant_move).with(chess_board, -1).and_return(square)
          expect(pawn).to receive(:take_enemy_pawn).with(square, chess_board)
          pawn.move(square, chess_board)
        end
      end

      it 'sends :add_move message to Board with [location, square] argument' do
        expect(chess_board).to receive(:add_move).with(move_array)
        pawn.move(square, chess_board)
      end

      it 'sends :update_piece message with self to given square' do
        expect(square).to receive(:update_piece).with(pawn)
        pawn.move(square, chess_board)
      end

      it 'sends :update_piece message without any args to self location' do
        expect(start_square).to receive(:update_piece).with(no_args)
        pawn.move(square, chess_board)
      end

      it 'calls #update_location method with given square as an argument' do
        expect(pawn).to receive(:update_location).with(square)
        pawn.move(square, chess_board)
      end
    end
  end
end
