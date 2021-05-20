require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/square'

describe Game do
  let(:chess_board) { instance_double(Board) }

  describe '#create_game' do
    subject(:game_create) { described_class.new(nil, nil, chess_board) }
    let(:player_1) { double('player1', color: :white) }
    let(:player_2) { double('player2', color: :black) }

    before do
      players_array = [player_1, player_2]
      allow(game_create).to receive(:create_players).and_return(players_array)
      allow(game_create).to receive(:create_pieces)
      allow(chess_board).to receive(:setup_board)
    end

    it 'assigns @player_white instance variable to first item from #create_players' do
      exp_player = player_1
      expect { game_create.create_game }.to change { game_create.player_white }.to(exp_player)
    end

    it 'assigns @player_black instance variable to second item from #create_players' do
      exp_player = player_2
      expect { game_create.create_game }.to change { game_create.player_black }.to(exp_player)
    end

    it 'assigns @players instance variable to an [@player_white, @player_black] array' do
      exp_players = [player_1, player_2]
      expect { game_create.create_game }.to change { game_create.instance_variable_get(:@players) }.to(exp_players)
    end

    it 'sends :setup_board message to @chess_board with white_pieces and black_pieces' do
      white_pieces = game_create.create_pieces(player_1)
      black_pieces = game_create.create_pieces(player_2)
      expect(chess_board).to receive(:setup_board).with(white_pieces, black_pieces)
      game_create.create_game
    end
  end

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

  describe '#human_move' do
    let(:piece) { instance_double(Piece) }
    let(:square) { instance_double(Square, piece: piece) }
    let(:move) { instance_double(Square, position: { x: 6, y: 4 }) }
    let(:player) { instance_double(Player, color: :white) }
    subject(:human_game) { described_class.new(nil, nil, chess_board) }

    context 'when moving Piece' do
      before do
        allow(chess_board).to receive(:display)
        allow(chess_board).to receive(:squares_taken_by).with(:white).and_return(square)
        allow(piece).to receive(:legal_moves).with(chess_board).and_return(move)
        allow(piece).to receive(:move)
        allow(human_game).to receive(:select_square).and_return(square, move)
      end

      it 'does not raise an error' do
        expect { human_game.human_move(player) }.not_to raise_error
      end

      it 'stops loop and sends :move message with correct square to Piece on chosen square' do
        expect(piece).to receive(:move).with(move, chess_board)
        human_game.human_move(player)
      end
    end

    context 'when chosen wrong square twice' do
      before do
        allow(chess_board).to receive(:display)
        allow(chess_board).to receive(:squares_taken_by).with(:white).and_return(square)
        allow(piece).to receive(:legal_moves).with(chess_board).once.and_return(move)
        allow(piece).to receive(:move)
        allow(human_game).to receive(:select_square).and_return(nil, nil, square, move)
      end

      it 'displays an error message 2 times' do
        error_message = 'Chosen wrong square, try again'
        expect(human_game).to receive(:puts).with(error_message).twice
        human_game.human_move(player)
      end
    end

    context 'when chosen wrong move twice' do
      let(:return_values) { [:raise, :raise, true] }

      before do
        allow(chess_board).to receive(:display)
        allow(chess_board).to receive(:squares_taken_by).with(:white).and_return(square)
        allow(piece).to receive(:legal_moves).with(chess_board).and_return(move)
        allow(human_game).to receive(:select_square).and_return(square, nil, square, nil, square, move)
        # Since move is called on Piece double, we need to manually raise the error
        # using this method the error will be raised 2 times as expected
        allow(piece).to receive(:move).exactly(3).times do
          return_value = return_values.shift
          return_value == :raise ? raise(NoMethodError) : return_value
        end
      end

      it 'displays an error message 2 times' do
        error_message = 'Chosen wrong square, try again'
        expect(human_game).to receive(:puts).with(error_message).twice
        human_game.human_move(player)
      end
    end
  end

  describe '#select_square' do
    subject(:square_game) { described_class.new(nil, nil, chess_board) }
    let(:correct_square) { instance_double(Square, position: { x: 2, y: 3 }) }

    context 'when square with the chosen position is inside of squares array' do
      before do
        input_position = { x: 2, y: 3 }
        allow(square_game).to receive(:input_hub).and_return(input_position)
      end

      it 'returns correct square object' do
        squares = [correct_square]
        result = square_game.select_square(squares)
        expect(result).to eq(correct_square)
      end
    end

    context 'when square with the chosen position isn\'t inside of squares array' do
      let(:correct_square) { instance_double(Square, position: { x: 5, y: 7 }) }

      before do
        input_position = { x: 5, y: 3 }
        allow(square_game).to receive(:input_hub).and_return(input_position)
      end

      it 'returns nil' do
        squares = [correct_square]
        result = square_game.select_square(squares)
        expect(result).to be_nil
      end
    end

    context 'when chosen position is nil' do
      before do
        allow(square_game).to receive(:input_hub).and_return(nil)
      end

      it 'returns nil' do
        result = square_game.select_square([])
        expect(result).to be_nil
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
      allow(chess_board).to receive(:display)
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
    context 'when given players array with two elements: [player_1, player_2]' do
      let(:player_1) { double('Playesr', color: :white) }
      let(:player_2) { instance_double(Player, color: :black) }
      let(:players) { [player_1, player_2] }
      subject(:loop_game) { described_class.new(player_1, player_2, chess_board) }

      before do
        loop_game.instance_variable_set(:@players, players)
        allow(player_1).to receive(:in_check?)
        allow(player_1).to receive(:in_checkmate?)
        allow(player_1).to receive(:in_stalemate?)
        allow(player_2).to receive(:in_check?)
        allow(player_2).to receive(:in_checkmate?)
        allow(player_2).to receive(:in_stalemate?)
        allow(loop_game).to receive(:player_move)
      end

      context 'when player_1 is checkmated' do
        before do
          allow(player_1).to receive(:in_checkmate?).with(chess_board).and_return(false, true)
        end

        it 'doesn\'t rotate @players array globally' do
            players = loop_game.instance_variable_get(:@players)
            expect { loop_game.game_loop }.not_to change { players }
        end
      end

      context 'when player_1 is in stalemate' do
        before do
          allow(player_1).to receive(:in_stalemate?).with(chess_board).and_return(false, true)
        end

        it 'doesn\'t rotate @players array globally' do
            players = loop_game.instance_variable_get(:@players)
            expect { loop_game.game_loop }.not_to change { players }
        end
      end

      context 'when player_2 is checkmated' do
        before do
          allow(player_2).to receive(:in_checkmate?).with(chess_board).and_return(false, true)
        end

        it 'rotates @players array globally' do
            players = loop_game.instance_variable_get(:@players)
            rotated_array = players.rotate
            expect { loop_game.game_loop }.to change { players }.to(rotated_array)
        end
      end

      context 'when player_2 is in stalemate' do
        before do
          allow(player_2).to receive(:in_stalemate?).with(chess_board).and_return(false, true)
        end

        it 'rotates @players array globally' do
            players = loop_game.instance_variable_get(:@players)
            rotated_array = players.rotate
            expect { loop_game.game_loop }.to change { players }.to(rotated_array)
        end
      end

      context 'when player_1 is checkmated on 2nd move' do
        before do
          allow(player_1).to receive(:in_checkmate?).with(chess_board).and_return(false, true)
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
        #let(:players) { loop_game.instance_variable_get(:@players) }

        before do
          allow(player_2).to receive(:in_checkmate?).with(chess_board).and_return(false, true)
          allow(players).to receive(:rotate).and_return(players.rotate(1)) # idk
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
          allow(player_2).to receive(:in_checkmate?).with(chess_board).and_return(false, false, true)
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
          allow(player_1).to receive(:in_stalemate?).with(chess_board).and_return(false, false, true)
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
          allow(player_2).to receive(:in_stalemate?).with(chess_board).and_return(false, true)
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
          allow(player_1).to receive(:in_check?).with(chess_board).and_return(false, true)
          allow(player_1).to receive(:in_checkmate?).with(chess_board).and_return(false, false, true)
        end

        it 'outputs message for player_1 about the check once' do
          message = "#{player_1.color} player is in check!"
          expect(loop_game).to receive(:puts).with(message).once
          loop_game.game_loop
        end
      end

      context 'when player_2 is in check on 3nd move and is checkmated on 5th move' do
        before do
          allow(player_2).to receive(:in_check?).with(chess_board).and_return(false, true)
          allow(player_2).to receive(:in_checkmate?).with(chess_board).and_return(false, false, true)
        end

        it 'outputs message for player_2 about the check once' do
          message = "#{player_2.color} player is in check!"
          expect(loop_game).to receive(:puts).with(message).once
          loop_game.game_loop
        end
      end
    end
  end

  describe '#announce_winner' do
    let(:player_1) { double('Playesr', color: :white) }
    let(:player_2) { instance_double(Player, color: :black) }
    let(:players) { [player_1, player_2] }
    subject(:winner_game) { described_class.new(nil, nil, chess_board) }

    context 'when @players array is equal to [player_1, player_2]' do
      before do
        winner_game.instance_variable_set(:@players, players)
        allow(player_1).to receive(:in_checkmate?)
        allow(player_1).to receive(:in_stalemate?)
      end

      context 'when player_1 is checkmated by player_2' do
        before do
          allow(player_1).to receive(:in_checkmate?).with(chess_board).and_return(true)
        end

        it 'outputs winner message for :black player' do
          message = 'black player won by a checkmate!'
          expect(winner_game).to receive(:puts).with(message).once
          winner_game.announce_winner
        end
      end

      context 'when player_1 is in stalemate' do
        before do
          allow(player_1).to receive(:in_stalemate?).with(chess_board).and_return(true)
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
        winner_game.instance_variable_set(:@players, players.rotate)
        allow(player_2).to receive(:in_checkmate?)
        allow(player_2).to receive(:in_stalemate?)
      end

      context 'when player_2 is checkmated by player_1' do
        before do
          allow(player_2).to receive(:in_checkmate?).with(chess_board).and_return(true)
        end

        it 'outputs winner message for :white player' do
          message = 'white player won by a checkmate!'
          expect(winner_game).to receive(:puts).with(message).once
          winner_game.announce_winner
        end
      end

      context 'when player_2 is in stalemate' do
        before do
          allow(player_2).to receive(:in_stalemate?).with(chess_board).and_return(true)
        end

        it 'outputs draw message' do
          message = 'black player is in stalemate, the game is a draw!'
          expect(winner_game).to receive(:puts).with(message).once
          winner_game.announce_winner
        end
      end
    end
  end

  describe '#input_hub' do
    subject(:input_game) { described_class.new(nil, nil, chess_board) }

    context 'when #basic_input returned :s symbol' do
      it 'invokes #save_game method' do
        allow(input_game).to receive(:basic_input).and_return(:s)
        expect(input_game).to receive(:save_game)
        input_game.input_hub
      end

      it 'returns nil' do
        allow(input_game).to receive(:basic_input).and_return(:s)
        allow(input_game).to receive(:save_game)
        result = input_game.input_hub
        expect(result).to be_nil
      end
    end

    context 'when #basic_input returned a square position' do
      it 'returns that position' do
        position = { x: 2, y: 3 }
        allow(input_game).to receive(:basic_input).and_return(position)
        result = input_game.input_hub
        expect(result).to eq(position)
      end
    end
  end

  describe '#basic_input' do
    subject(:input_game) { described_class.new(nil, nil, chess_board) }

    context 'when given correct input on first try' do
      it 'doesn\'t send error message' do
        allow(input_game).to receive(:gets).and_return('h6')
        error_message = 'Wrong input!'
        expect(input_game).not_to receive(:puts).with(error_message)
        input_game.basic_input
      end
    end

    context 'when given correct input on third try' do
      it 'sends error message 2 times' do
        allow(input_game).to receive(:gets).and_return('w', 'a0', 's')
        error_message = 'Wrong input!'
        expect(input_game).to receive(:puts).with(error_message).twice
        input_game.basic_input
      end
    end

    context 'when given correct input' do
      it 'returns #verify_input method' do
        input = 'h2'
        allow(input_game).to receive(:gets).and_return(input)
        verified_input = input_game.verify_input(input)
        result = input_game.basic_input
        expect(result).to eq(verified_input)
      end
    end
  end

  describe '#verify_input' do
    subject(:input_game) { described_class.new(nil, nil, chess_board) }

    context 'when given input is equal to \'s\'' do
      it 'returns symbol :s' do
        input = 's'
        expected = :s
        result = input_game.verify_input(input)
        expect(result).to eq(expected)
      end
    end

    context 'when given input is 2 characters long string with characters in correct range' do
      let(:square) { double('Square', position: { x: 2, y: 2 }) }

      it 'returns translated input' do
        input = 'b2'
        result = input_game.verify_input(input)
        expected = { x: 2, y: 2 }
        expect(result).to eq(expected)
      end
    end

    context 'when given input is not valid' do
      it 'returns nil' do
        input = 'dw'
        result = input_game.verify_input(input)
        expect(result).to be_nil
      end
    end
  end

  describe '#load_save?' do
    subject(:load_game) { described_class.new(nil, nil, chess_board) }

    context 'when player inputted \'y\' the first time' do
      it 'returns true' do
        allow(load_game).to receive(:load_choice).and_return('y')
        result = load_game.load_save?
        expect(result).to be true
      end
    end

    context 'when player inputted \'n\' the first time' do
      it 'returns false' do
        allow(load_game).to receive(:load_choice).and_return('n')
        result = load_game.load_save?
        expect(result).to be false
      end
    end

    context 'when player provided wrong input 3 times' do
      it 'displays error message 3 times' do
        allow(load_game).to receive(:load_choice).and_return('d', '2', 'w', 'n')
        expect(load_game).to receive(:puts).with('Wrong input!').exactly(3).times
        result = load_game.load_save?
      end
    end
  end
end