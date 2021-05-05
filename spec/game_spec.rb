require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/square'

describe Game do
  describe '#player_move' do
    subject(:player_game) { described_class.new }

    context 'when given player is :human' do
      let(:human_player) { instance_double(Player, type: :human) }

      before do
        allow(player_game).to receive(:human_move).with(human_player)
      end

      it 'calls #human_move method' do
        expect(player_game).to receive(:human_move).with(human_player)
        player_game.player_move(human_player)
      end
    end

    context 'when given player is :ai' do
      let(:ai_player) { instance_double(Player, type: :ai) }

      before do
        allow(player_game).to receive(:ai_move).with(ai_player)
      end

      it 'calls #ai_move method' do
        expect(player_game).to receive(:ai_move).with(ai_player)
        player_game.player_move(ai_player)
      end
    end
  end

  describe '#correct_input?' do
    let(:chess_board) { instance_double(Board) }
    subject(:move_game) { described_class.new(nil, nil, chess_board) }
    context 'when player color is :white' do
      let(:wht_player) { instance_double(Player, color: :white) }
      let(:wht_square1) { instance_double(Square, position: { x: 4, y: 4 }) }
      let(:wht_square2) { instance_double(Square, position: { x: 5, y: 4 }) }
      context 'when square with given input position has :white Piece' do
        it 'returns true' do
          allow(chess_board).to receive(:squares_taken_by).with(wht_player.color).and_return([wht_square1, wht_square2])
          result = move_game.correct_input?(wht_player, wht_square1)
          expect(result).to be true
        end
      end

      context 'when square with given input position has :black Piece' do
        let(:blk_square) { instance_double(Square, position: { x: 2, y: 6 }) }
        it 'returns false' do
          allow(chess_board).to receive(:squares_taken_by).with(wht_player.color).and_return([wht_square1, wht_square2])
          result = move_game.correct_input?(wht_player, blk_square)
          expect(result).to be false
        end
      end
    end
  end

  describe '#correct_move?' do
    let(:given_move) { instance_double(Square) }
    let(:square_piece) { instance_double(Piece) }
    let(:curr_square) { instance_double(Square, piece: square_piece) }
    let(:chess_board) { instance_double(Board) }
    subject(:move_game) { described_class.new(nil, nil, chess_board) }

    context 'when given square\'s Piece #legal_moves include given move' do

      it 'returns true' do
        allow(square_piece).to receive(:legal_moves).with(chess_board).and_return([given_move])
        result = move_game.correct_move?(curr_square, given_move)
        expect(result).to be true
      end
    end

    context 'when given square\'s Piece #legal_moves doesn\'t include given move' do

      it 'returns false' do
        allow(square_piece).to receive(:legal_moves).with(chess_board).and_return([])
        result = move_game.correct_move?(curr_square, given_move)
        expect(result).to be false
      end
    end
  end

  describe '#get_correct_square' do
    let(:chess_board) { instance_double(Board) }
    subject(:get_game) { described_class.new(nil, nil, chess_board) }

    context 'when given given correct input for :white Player' do
      let(:wht_player) { instance_double(Player, color: :white) }
      let(:square_input) { instance_double(Square, position: { x: 4, y: 4 }) }

      before do
        input = { x: 4, y: 4 }
        allow(wht_player).to receive(:input).and_return(input)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_input)
        allow(get_game).to receive(:correct_input?).with(wht_player, square_input).and_return(true)
      end

      it 'returns that square with that input as a position' do
        result = get_game.get_correct_square(wht_player)
        expect(result).to eq(square_input)
      end
    end

    context 'when given wrong input 2 times for :black Player' do
      let(:blk_player) { instance_double(Player, color: :black) }
      let(:square_input) { instance_double(Square, position: { x: 6, y: 4 }) }

      before do
        input = { x: 6, y: 4 }
        allow(blk_player).to receive(:input).and_return(input)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_input)
        allow(get_game).to receive(:correct_input?).with(blk_player, square_input).and_return(false, false, true)
      end

      it 'displays error message 2 times' do
        error_message = "Wrong square, you can only choose black pieces"
        expect(get_game).to receive(:puts).with(error_message).twice
        result = get_game.get_correct_square(blk_player)
      end
    end

    context 'when given wrong input 1 time for :white Player' do
      let(:wht_player) { instance_double(Player, color: :white) }
      let(:square_input) { instance_double(Square, position: { x: 6, y: 4 }) }

      before do
        input = { x: 6, y: 4 }
        allow(wht_player).to receive(:input).and_return(input)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_input)
        allow(get_game).to receive(:correct_input?).with(wht_player, square_input).and_return(false, true)
      end

      it 'displays error message 1 time' do
        error_message = "Wrong square, you can only choose white pieces"
        expect(get_game).to receive(:puts).with(error_message).once
        result = get_game.get_correct_square(wht_player)
      end
    end
  end

  describe '#human_move' do

    let(:piece) { instance_double(Piece) }
    let(:initial_square) { instance_double(Square, piece: piece) }
    let(:square_move) { instance_double(Square, position: { x: 6, y: 4 }) }
    let(:human_player) { instance_double(Player) }
    let(:chess_board) { instance_double(Board) }
    subject(:human_game) { described_class.new(nil, nil, chess_board) }

    context 'when specified correct move input' do
      before do
        input = { x: 6, y: 4 }
        allow(chess_board).to receive(:display)
        allow(human_game).to receive(:get_correct_square).with(human_player).and_return(initial_square)
        allow(human_game).to receive(:correct_move?).with(initial_square, square_move).and_return(true)
        allow(human_player).to receive(:input).and_return(input)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_move)
      end

      it 'sends :move message with correct square to Piece on given square' do
        expect(piece).to receive(:move).with(square_move, chess_board)
        human_game.human_move(human_player)
      end
    end

    context 'when specified wrong move input 2 times' do
      before do # refactor
        input = { x: 6, y: 4 }
        allow(chess_board).to receive(:display)
        allow(human_player).to receive(:input).and_return(input)
        allow(piece).to receive(:move)
        allow(human_game).to receive(:get_correct_square).with(human_player).and_return(initial_square)
        allow(human_game).to receive(:correct_move?).with(initial_square, square_move).and_return(false, false, true)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_move)
      end

      it 'displays error message 2 times' do
        error_message = 'Wrong move!'
        expect(human_game).to receive(:puts).with(error_message).twice
        human_game.human_move(human_player)
      end
    end
  end

  describe '#ai_move' do # contains logic for player movement if type == :ai
    let(:chess_board) { double('chess_board') }
    let(:ai_game) { described_class.new(nil, nil, chess_board) }
    let(:ai_player) { instance_double(Player, type: :ai) }
    let(:ai_piece) { instance_double(Piece) }
    let(:ai_picked_square) { instance_double(Square, piece: ai_piece) }
    let(:legal_moves) { [ instance_double(Square) ] }

    before do
      allow(ai_player).to receive(:ai_pick_square).with(chess_board).and_return(ai_picked_square)
      allow(ai_piece).to receive(:legal_moves).with(chess_board).and_return(legal_moves)
      allow(ai_player).to receive(:ai_pick_legal_move).with(legal_moves).and_return(legal_moves[0])
    end

    it 'sends :move message to random piece with random legal move' do
      expect(ai_piece).to receive(:move).with(legal_moves[0], chess_board)
      ai_game.ai_move(ai_player)
    end
  end

  describe '#game_loop' do
    let(:chess_board) { instance_double(Board) }

    context 'when given players array with two elements: [player_1, player_2]' do
      let(:player_1) { double('Playesr', color: :white) }
      let(:player_2) { instance_double(Player, color: :black) }
      subject(:loop_game) { described_class.new(player_1, player_2, chess_board) }

      before do
        allow(loop_game).to receive(:check?)
        allow(loop_game).to receive(:player_move)
        allow(loop_game).to receive(:checkmate?)
        allow(loop_game).to receive(:stalemate?)
      end

      context 'when player_1 is checkmated' do
        before do
          allow(loop_game).to receive(:checkmate?).with(chess_board, player_1.color, player_2.color).and_return(false, true)
        end

        it 'doesn\'t rotate @players array globally' do
            players = loop_game.instance_variable_get(:@players)
            expect { loop_game.game_loop }.not_to change { players }
        end
      end

      context 'when player_1 is in stalemate' do
        before do
          allow(loop_game).to receive(:stalemate?).with(chess_board, player_1.color, player_2.color).and_return(false, true)
        end

        it 'doesn\'t rotate @players array globally' do
            players = loop_game.instance_variable_get(:@players)
            expect { loop_game.game_loop }.not_to change { players }
        end
      end

      context 'when player_2 is checkmated' do
        before do
          allow(loop_game).to receive(:checkmate?).with(chess_board, player_2.color, player_1.color).and_return(false, true)
        end

        it 'rotates @players array globally' do
            players = loop_game.instance_variable_get(:@players)
            rotated_array = players.rotate
            expect { loop_game.game_loop }.to change { players }.to(rotated_array)
        end
      end

      context 'when player_2 is in stalemate' do
        before do
          allow(loop_game).to receive(:stalemate?).with(chess_board, player_2.color, player_1.color).and_return(false, true)
        end

        it 'rotates @players array globally' do
            players = loop_game.instance_variable_get(:@players)
            rotated_array = players.rotate
            expect { loop_game.game_loop }.to change { players }.to(rotated_array)
        end
      end

      context 'when player_1 is checkmated on 2nd move' do
        before do
          allow(loop_game).to receive(:checkmate?).with(chess_board, player_1.color, player_2.color).and_return(false, true)
        end

        it 'calls #player_move with player_1 once' do
          expect(loop_game).to receive(:player_move).with(player_1).once
          loop_game.game_loop
        end

        it 'calls #player_move with player_2 once' do
          expect(loop_game).to receive(:player_move).with(player_2).once
          loop_game.game_loop
        end
      end

      context 'when player_2 is checkmated on 3rd move' do
        let(:players) { loop_game.instance_variable_get(:@players) }
        before do
          allow(loop_game).to receive(:checkmate?).with(chess_board, player_2.color, player_1.color).and_return(false, true)
          allow(players).to receive(:rotate).and_return(players.rotate(1))
        end

        it 'calls #player_move with player_1 twice' do
          expect(loop_game).to receive(:player_move).with(player_1).twice
          loop_game.game_loop
        end

        it 'calls #player_move with player_2 once' do
          expect(loop_game).to receive(:player_move).with(player_2).once
          loop_game.game_loop
        end
      end

      context 'when player_2 is checkmated on 5th move' do

        before do
          allow(loop_game).to receive(:checkmate?).with(chess_board, player_1.color, player_2.color).and_return(false, false, false)
          allow(loop_game).to receive(:checkmate?).with(chess_board, :black, :white).and_return(false, false, true)
        end

        it 'calls #player_move with player_1 three times' do
          expect(loop_game).to receive(:player_move).with(player_1).exactly(3).times
          loop_game.game_loop
        end

        it 'calls #player_move with player_2 twice' do
          expect(loop_game).to receive(:player_move).with(player_2).twice
          loop_game.game_loop
        end
      end

      context 'when player_1 is in stalemate on 4th move' do
        before do
          allow(loop_game).to receive(:checkmate?).with(chess_board, player_1.color, player_2.color).and_return(false, false, true)
        end

        it 'calls #player_move with player_1 twice' do
          expect(loop_game).to receive(:player_move).with(player_1).twice
          loop_game.game_loop
        end

        it 'calls #player_move with player_2 twice' do
          expect(loop_game).to receive(:player_move).with(player_2).twice
          loop_game.game_loop
        end
      end

      context 'when player_2 is in stalemate on 3rd move' do
        before do
          allow(loop_game).to receive(:stalemate?).with(chess_board, player_2.color, player_1.color).and_return(false, true)
        end

        it 'calls #player_move with player_1 twice' do
          expect(loop_game).to receive(:player_move).with(player_1).twice
          loop_game.game_loop
        end

        it 'calls #player_move with player_2 once' do
          expect(loop_game).to receive(:player_move).with(player_2).once
          loop_game.game_loop
        end
      end

      context 'when player_1 is in check on 2nd move and is checkmated on 4th move' do
        before do
          allow(loop_game).to receive(:check?).with(chess_board, player_1.color, player_2.color).and_return(false, true)
          allow(loop_game).to receive(:checkmate?).with(chess_board, player_1.color, player_2.color).and_return(false, false, true)
        end

        it 'outputs message about the check once' do
          message = "#{player_1.color} player is in check!"
          expect(loop_game).to receive(:puts).with(message).once
          loop_game.game_loop
        end
      end
    end
  end

  describe '#announce_winner' do
    let(:chess_board) { instance_double(Board) }
    let(:player_1) { double('Playesr', color: :white) }
    let(:player_2) { instance_double(Player, color: :black) }
    subject(:winner_game) { described_class.new(player_1, player_2, chess_board) }

    context 'when @players array is equal to [player_1, player_2]' do
      before do
        allow(winner_game).to receive(:checkmate?)
        allow(winner_game).to receive(:stalemate?)
      end

      context 'when player_1 is checkmated by player_2' do
        before do
          allow(winner_game).to receive(:checkmate?).with(chess_board, player_1.color, player_2.color).and_return(true)
        end

        it 'outputs winner message for :black player' do
          message = 'black player won by a checkmate!'
          expect(winner_game).to receive(:puts).with(message).once
          winner_game.announce_winner
        end
      end

      context 'when player_1 is in stalemate' do
        before do
          allow(winner_game).to receive(:stalemate?).with(chess_board, player_1.color, player_2.color).and_return(true)
        end

        it 'outputs draw message' do
          message = 'white player is in stalemate, the game is a draw!'
          expect(winner_game).to receive(:puts).with(message).once
          winner_game.announce_winner
        end
      end
    end

    context 'when @players array is equal to [player_2, player_1]' do
      before do
        players = winner_game.instance_variable_get(:@players)
        winner_game.instance_variable_set(:@players, players.rotate)
        allow(winner_game).to receive(:checkmate?)
        allow(winner_game).to receive(:stalemate?)
      end

      context 'when player_2 is checkmated by player_1' do
        before do
          allow(winner_game).to receive(:checkmate?).with(chess_board, player_2.color, player_1.color).and_return(true)
        end

        it 'outputs winner message for :white player' do
          message = 'white player won by a checkmate!'
          expect(winner_game).to receive(:puts).with(message).once
          winner_game.announce_winner
        end
      end

      context 'when player_2 is in stalemate' do
        before do
          allow(winner_game).to receive(:stalemate?).with(chess_board, player_2.color, player_1.color).and_return(true)
        end

        it 'outputs draw message' do
          message = 'black player is in stalemate, the game is a draw!'
          expect(winner_game).to receive(:puts).with(message).once
          winner_game.announce_winner
        end
      end
    end
  end
end