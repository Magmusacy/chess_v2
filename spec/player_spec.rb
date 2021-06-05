# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/square'
require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/modules/special_conditions'

describe Player do
  let(:chess_board) { instance_double(Board) }
  let(:game) { instance_double(Game) }
  subject(:human) { described_class.new(:white, :human) }

  describe '#human_move' do
    let(:piece) { instance_double(Piece) }
    let(:square) { instance_double(Square, piece: piece) }
    let(:move) { instance_double(Square, position: { x: 6, y: 4 }) }

    context 'when moving Piece' do
      before do
        allow(chess_board).to receive(:display)
        allow(chess_board).to receive(:squares_taken_by).with(:white).and_return(square)
        allow(piece).to receive(:legal_moves).with(chess_board).and_return(move)
        allow(piece).to receive(:move)
        allow(human).to receive(:select_square).and_return(square, move)
      end

      it 'does not raise an error' do
        expect { human.human_move(chess_board, game) }.not_to raise_error
      end

      it 'stops loop and sends :move message with correct square to Piece on chosen square' do
        expect(piece).to receive(:move).with(move, chess_board)
        human.human_move(chess_board, game)
      end
    end

    context 'when chosen wrong square twice' do
      before do
        allow(chess_board).to receive(:display)
        allow(chess_board).to receive(:squares_taken_by).with(:white).and_return(square)
        allow(piece).to receive(:legal_moves).with(chess_board).once.and_return(move)
        allow(piece).to receive(:move)
        allow(human).to receive(:select_square).and_return(nil, nil, square, move)
      end

      it 'displays an error message 2 times' do
        error_message = 'Chosen wrong square, try again'
        expect(human).to receive(:puts).with(error_message).twice
        human.human_move(chess_board, game)
      end
    end

    context 'when chosen wrong move twice' do
      let(:return_values) { [:raise, :raise, true] }

      before do
        allow(chess_board).to receive(:display)
        allow(chess_board).to receive(:squares_taken_by).with(:white).and_return(square)
        allow(piece).to receive(:legal_moves).with(chess_board).and_return(move)
        allow(human).to receive(:select_square).and_return(square, nil, square, nil, square, move)
        # Since move is called on Piece double, we need to manually raise the error
        # using this method the error will be raised 2 times as expected
        allow(piece).to receive(:move)
      end

      it 'displays an error message 2 times' do
        error_message = 'Chosen wrong square, try again'
        expect(human).to receive(:puts).with(error_message).twice
        human.human_move(chess_board, game)
      end
    end
  end

  describe '#select_square' do
    let(:correct_square) { instance_double(Square, position: { x: 2, y: 3 }) }

    context 'when square with the chosen position is inside of squares array' do
      before do
        input_position = { x: 2, y: 3 }
        allow(human).to receive(:input_hub).and_return(input_position)
      end

      it 'returns correct square object' do
        squares = [correct_square]
        result = human.select_square(squares, game)
        expect(result).to eq(correct_square)
      end
    end

    context 'when square with the chosen position isn\'t inside of squares array' do
      let(:correct_square) { instance_double(Square, position: { x: 5, y: 7 }) }

      before do
        input_position = { x: 5, y: 3 }
        allow(human).to receive(:input_hub).and_return(input_position)
      end

      it 'returns nil' do
        squares = [correct_square]
        result = human.select_square(squares, game)
        expect(result).to be_nil
      end
    end

    context 'when chosen position is nil' do
      before do
        allow(human).to receive(:input_hub).and_return(nil)
      end

      it 'returns nil' do
        result = human.select_square([], game)
        expect(result).to be_nil
      end
    end
  end

  describe '#input_hub' do
    context 'when #basic_input returned :s symbol' do
      it 'sends :save_game message to Game object' do
        allow(human).to receive(:basic_input).and_return(:s)
        expect(game).to receive(:save_game)
        human.input_hub(game)
      end

      it 'returns nil' do
        allow(human).to receive(:basic_input).and_return(:s)
        allow(game).to receive(:save_game)
        result = human.input_hub(game)
        expect(result).to be_nil
      end
    end

    context 'when #basic_input returned a square position' do
      it 'returns that position' do
        position = { x: 2, y: 3 }
        allow(human).to receive(:basic_input).and_return(position)
        result = human.input_hub(game)
        expect(result).to eq(position)
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
