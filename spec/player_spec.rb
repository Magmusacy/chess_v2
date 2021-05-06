# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/square'
require_relative '../lib/board'
require_relative '../lib/modules/special_conditions'

describe Player do
  subject(:player_human) { described_class.new(:black, :human) }

  describe '#input' do
    context 'when player is human' do
      context 'when given input is invalid' do
        before do
          allow(player_human).to receive(:gets).and_return('taco')
          allow(player_human).to receive(:translate_input)
          allow(player_human).to receive(:verify_input).and_return(nil, 'b2')
        end

        it 'outputs error message' do
          error_msg = 'Wrong square specified, to specify square type first it\'s column, then it\'s row like: b2'
          expect(player_human).to receive(:puts).with(error_msg).once
          player_human.input
        end
      end

      context 'when given input is valid' do
        before do
          allow(player_human).to receive(:gets).and_return('b2')
          allow(player_human).to receive(:translate_input)
          allow(player_human).to receive(:verify_input).and_return({ x: 2, y: 2 })
        end

        it 'doesn\'t output error message' do
          error_msg = 'Wrong square specified, to specify square type first it\'s column, then it\'s row like: b2'
          expect(player_human).not_to receive(:puts).with(error_msg)
          player_human.input
        end
      end
    end
  end

  describe '#verify_input' do
    context 'when given input string \'b2\'' do
      it 'returns given input' do
        input = 'b2'
        result = player_human.verify_input(input)
        expect(result).to eq(input)
      end
    end

    context 'when given input string length is not 2' do
      it 'returns nil' do
        input = 'bb2'
        result = player_human.verify_input(input)
        expect(result).to eq(nil)
      end
    end

    context 'when given input string first character is not between(\'a\'..\'h\')' do
      it 'returns nil' do
        input = 'j2'
        result = player_human.verify_input(input)
        expect(result).to eq(nil)
      end
    end

    context 'when given input string second character is not between(\'1\'..\'8\')' do
      it 'returns nil' do
        input = 'a9'
        result = player_human.verify_input(input)
        expect(result).to eq(nil)
      end
    end
  end

  describe '#translate_input' do
    context 'when given string \'a3\'' do
      it 'returns hash { x: 1, y: 3 }' do
        input = 'a3'
        result = player_human.translate_input(input)
        expected = { x: 1, y: 3 }
        expect(result).to eq(expected)
      end
    end
  end

  describe '#ai_pick_square' do
    let(:chess_board) { instance_double(Board) }

    context 'when AI player color is :black' do
      let(:color) { :black }
      let(:black_piece) { instance_double(Piece, color: color) }
      let(:black_square) { double('square', piece: black_piece) }
      let(:move_squares) { [double('square')] }
      subject(:player_ai) { described_class.new(color, :ai) }

      context 'when AI has only one Piece with legal moves' do
        before do
          allow(chess_board).to receive(:squares_taken_by).with(color).and_return([black_square])
          allow(black_piece).to receive(:legal_moves).and_return(move_squares)
        end

        it 'returns square with that Piece' do
          result = player_ai.ai_pick_square(chess_board)
          expect(result).to eq(black_square)
        end
      end
    end

    context 'when AI player color is :white' do
      let(:color) { :white }
      let(:white_piece) { instance_double(Piece, color: color) }
      let(:white_square) { double('square', piece: white_piece) }
      let(:move_squares) { [double('square')] }
      subject(:player_ai) { described_class.new(color, :ai) }

      context 'when AI has only one Piece with legal moves' do
        before do
          allow(chess_board).to receive(:squares_taken_by).with(color).and_return([white_square])
          allow(white_piece).to receive(:legal_moves).and_return(move_squares)
        end

        it 'returns square with that Piece' do
          result = player_ai.ai_pick_square(chess_board)
          expect(result).to eq(white_square)
        end
      end
    end
  end

  describe '#ai_pick_legal_move' do
    subject(:player_ai) { described_class.new(:black, :ai) }

    context 'when given not empty #legal_moves array' do
      let(:legal_moves) { [instance_double(Square), instance_double(Square), instance_double(Square)] }

      it 'returns square from #legal_moves' do
        expect(legal_moves).to include(player_ai.ai_pick_legal_move(legal_moves))
      end
    end
  end

  describe '#in_check?' do
    let(:chess_board) { instance_double(Board) }

    context 'when method called on :white player' do
      let(:wht_king) { instance_double(King) }
      let(:wht_square) { instance_double(Square, piece: wht_king) }
      let(:blk_piece) { instance_double(Piece) }
      let(:blk_square) { instance_double(Square, piece: blk_piece) }
      subject(:checked_player) { described_class.new(:white, nil) }

      context 'when any :black player\'s piece attack :white player\'s king' do
        before do
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([wht_square])
          allow(chess_board).to receive(:get_king_square).with(:white).and_return(wht_square)
          allow(chess_board).to receive(:squares_taken_by).with(:black).and_return([blk_square])
        end

        it 'returns true' do
          result = checked_player.in_check?(chess_board)
          expect(result).to be true
        end
      end

      context 'when none of :black player\'s pieces attack :white player\'s king' do
        before do
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
          allow(chess_board).to receive(:get_king_square).with(:white).and_return(wht_square)
          allow(chess_board).to receive(:squares_taken_by).with(:black).and_return([blk_square])
        end

        it 'returns false' do
          result = checked_player.in_check?(chess_board)
          expect(result).to be false
        end
      end
    end

    context 'when method called on :black player' do
      let(:blk_king) { instance_double(King) }
      let(:wht_piece) { instance_double(Piece) }
      let(:blk_square) { instance_double(Square, piece: blk_king) }
      let(:wht_square) { instance_double(Square, piece: wht_piece) }
      subject(:checked_player) { described_class.new(:black, nil) }

      context 'when any :white player\'s pieces attack :black player\'s king' do
        before do
          allow(wht_piece).to receive(:legal_moves).with(chess_board).and_return([blk_square])
          allow(chess_board).to receive(:get_king_square).with(:black).and_return(blk_square)
          allow(chess_board).to receive(:squares_taken_by).with(:white).and_return([wht_square])
        end

        it 'returns true' do
          result = checked_player.in_check?(chess_board)
          expect(result).to be true
        end
      end

      context 'when none of :white player\'s pieces attack :black player\'s king' do
        before do
          allow(wht_piece).to receive(:legal_moves).with(chess_board).and_return([])
          allow(chess_board).to receive(:get_king_square).with(:black).and_return(blk_square)
          allow(chess_board).to receive(:squares_taken_by).with(:white).and_return([wht_square])
        end

        it 'returns false' do
          result = checked_player.in_check?(chess_board)
          expect(result).to be false
        end
      end
    end

  end

  describe '#in_checkmate?' do
    let(:chess_board) { instance_double(Board) }

    context 'when method called on :white player' do
      let(:player_color) { :white }
      let(:opponent_color) { :black }
      let(:blk_piece) { instance_double(Piece) }
      let(:blk_square) { instance_double(Square, piece: blk_piece) }
      subject(:checkmated_player) { described_class.new(player_color, nil) }

      context 'when :white player is in check, and all of his pieces have no legal moves' do
        before do
          allow(checkmated_player).to receive(:in_check?).with(chess_board).and_return(true)
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
        end

        it 'returns true' do
          result = checkmated_player.in_checkmate?(chess_board)
          expect(result).to be true
        end
      end

      context 'when :white player is not in check, and all of his pieces have no legal moves' do
        before do
          allow(checkmated_player).to receive(:in_check?).with(chess_board).and_return(false)
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
        end

        it 'returns false' do
          result = checkmated_player.in_checkmate?(chess_board)
          expect(result).to be false
        end
      end

      context 'when :white player is in check, and some of his pieces have legal moves' do
        let(:move_square) { instance_double(Square) }

        before do
          allow(checkmated_player).to receive(:in_check?).with(chess_board).and_return(true)
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([move_square])
        end

        it 'returns false' do
          result = checkmated_player.in_checkmate?(chess_board)
          expect(result).to be false
        end
      end
    end

    context 'when method called on :black player' do
      let(:player_color) { :black }
      let(:opponent_color) { :white }
      let(:blk_piece) { instance_double(Piece) }
      let(:blk_square) { instance_double(Square, piece: blk_piece) }
      subject(:checkmated_player) { described_class.new(player_color, nil) }

      context 'when :black player is in check, and all of his pieces have no legal moves' do
        before do
          allow(checkmated_player).to receive(:in_check?).with(chess_board).and_return(true)
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
        end

        it 'returns true' do
          result = checkmated_player.in_checkmate?(chess_board)
          expect(result).to be true
        end
      end

      context 'when :black player is not in check, and all of his pieces have no legal moves' do
        before do
          allow(checkmated_player).to receive(:in_check?).with(chess_board).and_return(false)
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
        end

        it 'returns false' do
          result = checkmated_player.in_checkmate?(chess_board)
          expect(result).to be false
        end
      end

      context 'when :black player is in check, and some of his pieces have legal moves' do
        let(:move_square) { instance_double(Square) }

        before do
          allow(checkmated_player).to receive(:in_check?).with(chess_board).and_return(true)
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([move_square])
        end

        it 'returns false' do
          result = checkmated_player.in_checkmate?(chess_board)
          expect(result).to be false
        end
      end
    end
  end

  describe '#in_stalemate?' do
    let(:chess_board) { instance_double(Board) }

    context 'when method called on :white player' do
      let(:player_color) { :white }
      let(:opponent_color) { :black }
      let(:blk_piece) { instance_double(Piece) }
      let(:blk_square) { instance_double(Square, piece: blk_piece) }
      subject(:stalemated_player) { described_class.new(player_color, nil) }

      context 'when :white player is not in check, and all of his pieces have no legal moves' do
        before do
          allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(false)
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
        end

        it 'returns true' do
          result = stalemated_player.in_stalemate?(chess_board)
          expect(result).to be true
        end
      end

      context 'when :white player is in check, and all of his pieces have no legal moves' do
        before do
          allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(true)
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
        end

        it 'returns false' do
          result = stalemated_player.in_stalemate?(chess_board)
          expect(result).to be false
        end
      end

      context 'when :white player is not in check, and all some of his pieces have legal moves' do
        let(:move_square) { instance_double(Square) }

        before do
          allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(false)
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([move_square])
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
        end

        it 'returns false' do
          result = stalemated_player.in_stalemate?(chess_board)
          expect(result).to be false
        end
      end
    end

    context 'when method called on :black player' do
      let(:player_color) { :black }
      let(:opponent_color) { :white }
      let(:blk_piece) { instance_double(Piece) }
      let(:blk_square) { instance_double(Square, piece: blk_piece) }
      subject(:stalemated_player) { described_class.new(player_color, nil) }

      context 'when :black player is not in check, and all of his pieces have no legal moves' do
        before do
          allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(false)
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
        end

        it 'returns true' do
          result = stalemated_player.in_stalemate?(chess_board)
          expect(result).to be true
        end
      end

      context 'when :black player is in check, and all of his pieces have no legal moves' do
        before do
          allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(true)
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
        end

        it 'returns false' do
          result = stalemated_player.in_stalemate?(chess_board)
          expect(result).to be false
        end
      end

      context 'when :black player is not in check, and all some of his pieces have legal moves' do
        let(:move_square) { instance_double(Square) }

        before do
          allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(false)
          allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([move_square])
          allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([blk_square])
        end

        it 'returns false' do
          result = stalemated_player.in_stalemate?(chess_board)
          expect(result).to be false
        end
      end
    end
  end
end
