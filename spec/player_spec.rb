# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/square'
require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/pieces/pawn'
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

  subject(:ai) { described_class.new(:white, :ai) }

  describe '#ai_move' do
    let(:chess_board) { double('chess_board') }
    let(:ai_game) { described_class.new(nil, nil, chess_board) }
    let(:ai_player) { instance_double(Player, type: :ai) }
    let(:piece) { instance_double(Piece) }
    let(:ai_picked_square) { instance_double(Square) }
    let(:legal_moves) { [instance_double(Square)] }
    let(:pawn) { instance_double(Pawn) }

    before do
      allow(chess_board).to receive(:display)
      allow(ai).to receive(:pick_square).with(chess_board).and_return(ai_picked_square)
      allow(piece).to receive(:legal_moves).with(chess_board).and_return(legal_moves)
      allow(ai).to receive(:pick_move).with(legal_moves).and_return(legal_moves[0])
    end

    context 'when Piece is not a Pawn with promotion move' do
      it 'sends :move message to correct piece with legal move chosen by AI' do
        allow(ai_picked_square).to receive(:piece).and_return(piece)
        allow(ai).to receive(:pawn_promotion?).and_return(false)
        expect(piece).to receive(:move).with(legal_moves[0], chess_board)
        ai.ai_move(chess_board)
      end
    end

    context 'when Piece is a Pawn with promotion move' do
      it 'sends :promote message to Piece with legal move and random new piece' do
        random_piece_symbol = :rook
        allow(ai).to receive(:random_new_piece).and_return(random_piece_symbol)
        allow(ai_picked_square).to receive(:piece).and_return(pawn)
        allow(ai).to receive(:pawn_promotion?).and_return(true)
        allow(pawn).to receive(:legal_moves).with(chess_board).and_return(legal_moves)
        expect(pawn).to receive(:promote).with(legal_moves[0], chess_board, random_piece_symbol)
        ai.ai_move(chess_board)
      end
    end
  end

  describe '#pawn_promotion?' do
    let(:move) { instance_double(Square) }

    context 'when piece is Pawn' do
      let(:pawn) { instance_double(Pawn, is_a?: true) }

      before do
        allow(pawn).to receive(:promotion_move)
      end

      context 'when move square is in #promotion_move with x = 1' do
        it 'returns true' do
          allow(pawn).to receive(:promotion_move).with(chess_board, 1).and_return(move)
          result = ai.pawn_promotion?(pawn, chess_board, move)
          expect(result).to be true
        end
      end

      context 'when move square is in #promotion_move with x = 0' do
        it 'returns true' do
          allow(pawn).to receive(:promotion_move).with(chess_board, 0).and_return(move)
          result = ai.pawn_promotion?(pawn, chess_board, move)
          expect(result).to be true
        end
      end

      context 'when move square is in #promotion_move with x = -1' do
        it 'returns true' do
          allow(pawn).to receive(:promotion_move).with(chess_board, -1).and_return(move)
          result = ai.pawn_promotion?(pawn, chess_board, move)
          expect(result).to be true
        end
      end

      context 'when move square is not in any #promotion_move' do
        it 'returns false' do
          result = ai.pawn_promotion?(pawn, chess_board, move)
          expect(result).to be false
        end
      end
    end

    context 'when piece is not Pawn' do
      let(:piece) { instance_double(Piece, is_a?: false) }

      it 'returns nil' do
        result = ai.pawn_promotion?(piece, chess_board, move)
        expect(result).to be nil
      end
    end
  end

  describe '#random_new_piece' do
    it 'selects correct random new Piece symbol' do
      promotion_pieces = %i[bishop knight queen rook]
      result = ai.random_new_piece
      expect(promotion_pieces).to include(result)
    end
  end

  describe '#pick_square' do
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
          result = player_ai.pick_square(chess_board)
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
          result = player_ai.pick_square(chess_board)
          expect(result).to eq(white_square)
        end
      end
    end
  end

  describe '#pick_move' do
    subject(:player_ai) { described_class.new(:black, :ai) }

    context 'when given not empty #legal_moves array' do
      let(:legal_moves) { [instance_double(Square), instance_double(Square), instance_double(Square)] }

      it 'returns square from #legal_moves' do
        move = player_ai.pick_move(legal_moves)
        expect(legal_moves).to include(move)
      end
    end
  end

  describe '#in_check?' do
    let(:chess_board) { instance_double(Board) }
    let(:wht_king) { instance_double(King) }
    let(:wht_square) { instance_double(Square, piece: wht_king) }
    let(:blk_piece) { instance_double(Piece) }
    let(:blk_square) { instance_double(Square, piece: blk_piece) }
    subject(:checked_player) { described_class.new(:white, nil) }

    context 'when any opponent\'s piece attack player\'s king' do
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

    context 'when none of opponent\'s pieces attack player\'s king' do
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

  describe '#in_checkmate?' do
    let(:chess_board) { instance_double(Board) }

    let(:player_color) { :white }
    let(:opponent_color) { :black }
    let(:blk_piece) { instance_double(Piece) }
    let(:blk_square) { instance_double(Square, piece: blk_piece) }
    subject(:checkmated_player) { described_class.new(player_color, nil) }

    context 'when player is in check, and all of his pieces have no legal moves' do
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

    context 'when player is not in check, and all of his pieces have no legal moves' do
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

    context 'when player is in check, and some of his pieces have legal moves' do
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

  describe '#in_stalemate?' do
    let(:chess_board) { instance_double(Board) }
    let(:player_color) { :black }
    let(:opponent_color) { :white }
    let(:player_piece) { instance_double(Piece) }
    let(:player_square) { instance_double(Square, piece: player_piece) }
    let(:move_square) { instance_double(Square) }
    subject(:stalemated_player) { described_class.new(player_color, nil) }

    before do
      allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([])
      allow(chess_board).to receive(:squares_taken_by).with(opponent_color).and_return([])
    end

    context 'when player is white' do
      before do
        allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(false)
        allow(player_piece).to receive(:legal_moves).with(chess_board).and_return([])
        allow(chess_board).to receive(:squares_taken_by).with(:white).and_return([player_square])
      end

      it 'works correctly' do
        stalemated_player.instance_variable_set(:@color, :white)
        result = stalemated_player.in_stalemate?(chess_board)
        expect(result).to be true
      end
    end

    context 'when player is :black' do
      before do
        allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(false)
        allow(player_piece).to receive(:legal_moves).with(chess_board).and_return([])
        allow(chess_board).to receive(:squares_taken_by).with(:black).and_return([player_square])
      end

      it 'works correctly' do
        stalemated_player.instance_variable_set(:@color, :black)
        result = stalemated_player.in_stalemate?(chess_board)
        expect(result).to be true
      end
    end

    context 'when player is not in check, and all of his pieces have no legal moves' do
      before do
        allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(false)
        allow(player_piece).to receive(:legal_moves).with(chess_board).and_return([])
        allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([player_square])
      end

      it 'returns true' do
        result = stalemated_player.in_stalemate?(chess_board)
        expect(result).to be true
      end
    end

    context 'when player is in check, and all of his pieces have no legal moves' do
      before do
        allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(true)
        allow(player_piece).to receive(:legal_moves).with(chess_board).and_return([])
        allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([player_square])
      end

      it 'returns false' do
        result = stalemated_player.in_stalemate?(chess_board)
        expect(result).to be false
      end
    end

    context 'when player is not in check, and all some of his pieces have legal moves' do
      before do
        allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(false)
        allow(player_piece).to receive(:legal_moves).with(chess_board).and_return([move_square])
        allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([player_square])
      end

      it 'returns false' do
        result = stalemated_player.in_stalemate?(chess_board)
        expect(result).to be false
      end
    end

    context 'when player\'s only piece is king and enemy only piece is king' do
      let(:player_king) { instance_double(King, is_a?: true) }
      let(:enemy_king) { instance_double(King, is_a?: true) }
      let(:player_king_square) { instance_double(Square, piece: player_king) }
      let(:enemy_king_square) { instance_double(Square, piece: enemy_king) }

      before do
        allow(player_king).to receive(:legal_moves).with(chess_board).and_return([move_square])
        allow(stalemated_player).to receive(:in_check?).with(chess_board).and_return(false)
        allow(chess_board).to receive(:squares_taken_by).with(player_color).and_return([player_king_square])
        allow(chess_board).to receive(:squares_taken_by).with(opponent_color).and_return([enemy_king_square])
      end

      it 'returns true' do
        result = stalemated_player.in_stalemate?(chess_board)
        expect(result).to be true
      end
    end
  end
end
