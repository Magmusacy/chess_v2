# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/square'

describe Game do
  let(:chess_board) { instance_double(Board) }
  subject(:game) { described_class.new(nil, nil, chess_board) }

  describe '#create_game' do
    let(:player1) { instance_double(Player, color: :white) }
    let(:player2) { instance_double(Player, color: :black) }

    before do
      players_array = [player1, player2]
      allow(game).to receive(:create_players).and_return(players_array)
      allow(game).to receive(:create_pieces)
      allow(chess_board).to receive(:setup_board)
    end

    it 'assigns @player_white instance variable to first item from #create_players' do
      exp_player = player1
      expect { game.create_game }.to change { game.player_white }.to(exp_player)
    end

    it 'assigns @player_black instance variable to second item from #create_players' do
      exp_player = player2
      expect { game.create_game }.to change { game.player_black }.to(exp_player)
    end

    it 'assigns @players instance variable to an [@player_white, @player_black] array' do
      exp_players = [player1, player2]
      expect { game.create_game }.to change { game.instance_variable_get(:@players) }.to(exp_players)
    end

    it 'sends :setup_board message to @chess_board with white_pieces and black_pieces' do
      white_pieces = game.create_pieces(player1)
      black_pieces = game.create_pieces(player2)
      expect(chess_board).to receive(:setup_board).with(white_pieces, black_pieces)
      game.create_game
    end
  end

  describe '#player_move' do
    context 'when given player is :human' do
      let(:human_player) { instance_double(Player, type: :human) }

      it 'sends :human_move message to Player object' do
        expect(human_player).to receive(:human_move).with(chess_board, game)
        game.player_move(human_player)
      end
    end

    context 'when given player is :ai' do
      let(:ai_player) { instance_double(Player, type: :ai) }

      it 'sends :ai_move message to Player object' do
        expect(ai_player).to receive(:ai_move).with(chess_board)
        game.player_move(ai_player)
      end
    end
  end

  describe '#game_loop' do
    context 'when given players array with two elements: [player1, player2]' do
      let(:player1) { instance_double(Player, color: :white) }
      let(:player2) { instance_double(Player, color: :black) }
      let(:players) { [player1, player2] }
      subject(:loop_game) { described_class.new(player1, player2, chess_board) }

      before do
        loop_game.instance_variable_set(:@players, players)
        allow(loop_game).to receive(:puts).with(`clear`)
        allow(player1).to receive(:in_check?)
        allow(player1).to receive(:in_checkmate?)
        allow(player1).to receive(:in_stalemate?)
        allow(player2).to receive(:in_check?)
        allow(player2).to receive(:in_checkmate?)
        allow(player2).to receive(:in_stalemate?)
        allow(loop_game).to receive(:player_move)
      end

      context 'when player1 is checkmated' do
        before do
          allow(player1).to receive(:in_checkmate?).with(chess_board).and_return(false, true)
        end

        it 'doesn\'t rotate @players array globally' do
          players = loop_game.instance_variable_get(:@players)
          expect { loop_game.game_loop }.not_to(change { players })
        end
      end

      context 'when player1 is in stalemate' do
        before do
          allow(player1).to receive(:in_stalemate?).with(chess_board).and_return(false, true)
        end

        it 'doesn\'t rotate @players array globally' do
          players = loop_game.instance_variable_get(:@players)
          expect { loop_game.game_loop }.not_to(change { players })
        end
      end

      context 'when player2 is checkmated' do
        before do
          allow(player2).to receive(:in_checkmate?).with(chess_board).and_return(false, true)
        end

        it 'rotates @players array globally' do
          players = loop_game.instance_variable_get(:@players)
          rotated_array = players.rotate
          expect { loop_game.game_loop }.to change { players }.to(rotated_array)
        end
      end

      context 'when player2 is in stalemate' do
        before do
          allow(player2).to receive(:in_stalemate?).with(chess_board).and_return(false, true)
        end

        it 'rotates @players array globally' do
          players = loop_game.instance_variable_get(:@players)
          rotated_array = players.rotate
          expect { loop_game.game_loop }.to change { players }.to(rotated_array)
        end
      end

      context 'when player1 is checkmated on 2nd move' do
        before do
          allow(player1).to receive(:in_checkmate?).with(chess_board).and_return(false, true)
        end

        it 'calls #player_move with player1 once' do
          expect(loop_game).to receive(:player_move).with(player1).once
          loop_game.game_loop
        end

        it 'calls #player_move with player2 once' do
          expect(loop_game).to receive(:player_move).with(player2).once
          loop_game.game_loop
        end
      end

      context 'when player2 is checkmated on 3rd move' do
        before do
          allow(player2).to receive(:in_checkmate?).with(chess_board).and_return(false, true)
          allow(players).to receive(:rotate).and_return(players.rotate(1))
        end

        it 'calls #player_move with player1 twice' do
          expect(loop_game).to receive(:player_move).with(player1).twice
          loop_game.game_loop
        end

        it 'calls #player_move with player2 once' do
          expect(loop_game).to receive(:player_move).with(player2).once
          loop_game.game_loop
        end
      end

      context 'when player2 is checkmated on 5th move' do
        before do
          allow(player2).to receive(:in_checkmate?).with(chess_board).and_return(false, false, true)
        end

        it 'calls #player_move with player1 three times' do
          expect(loop_game).to receive(:player_move).with(player1).exactly(3).times
          loop_game.game_loop
        end

        it 'calls #player_move with player2 twice' do
          expect(loop_game).to receive(:player_move).with(player2).twice
          loop_game.game_loop
        end
      end

      context 'when player1 is in stalemate on 4th move' do
        before do
          allow(player1).to receive(:in_stalemate?).with(chess_board).and_return(false, false, true)
        end

        it 'calls #player_move with player1 twice' do
          expect(loop_game).to receive(:player_move).with(player1).twice
          loop_game.game_loop
        end

        it 'calls #player_move with player2 twice' do
          expect(loop_game).to receive(:player_move).with(player2).twice
          loop_game.game_loop
        end
      end

      context 'when player2 is in stalemate on 3rd move' do
        before do
          allow(player2).to receive(:in_stalemate?).with(chess_board).and_return(false, true)
        end

        it 'calls #player_move with player1 twice' do
          expect(loop_game).to receive(:player_move).with(player1).twice
          loop_game.game_loop
        end

        it 'calls #player_move with player2 once' do
          expect(loop_game).to receive(:player_move).with(player2).once
          loop_game.game_loop
        end
      end

      context 'when player1 is in check on 2nd move and is checkmated on 4th move' do
        before do
          allow(player1).to receive(:in_check?).with(chess_board).and_return(false, true)
          allow(player1).to receive(:in_checkmate?).with(chess_board).and_return(false, false, true)
        end

        it 'outputs message for player1 about the check once' do
          message = "#{player1.color} player is in check!"
          expect(loop_game).to receive(:puts).with(message).once
          loop_game.game_loop
        end
      end

      context 'when player2 is in check on 3nd move and is checkmated on 5th move' do
        before do
          allow(player2).to receive(:in_check?).with(chess_board).and_return(false, true)
          allow(player2).to receive(:in_checkmate?).with(chess_board).and_return(false, false, true)
        end

        it 'outputs message for player2 about the check once' do
          message = "#{player2.color} player is in check!"
          expect(loop_game).to receive(:puts).with(message).once
          loop_game.game_loop
        end
      end
    end
  end

  describe '#announce_winner' do
    let(:player1) { instance_double(Player, color: :white) }
    let(:player2) { instance_double(Player, color: :black) }
    let(:players) { [player1, player2] }

    context 'when @players array is equal to [player1, player2]' do
      before do
        game.instance_variable_set(:@players, players)
        allow(player1).to receive(:in_checkmate?)
        allow(player1).to receive(:in_stalemate?)
      end

      context 'when player1 is checkmated by player2' do
        before do
          allow(player1).to receive(:in_checkmate?).with(chess_board).and_return(true)
        end

        it 'outputs winner message for :black player' do
          message = 'black player won by a checkmate!'
          expect(game).to receive(:puts).with(message).once
          game.announce_winner
        end
      end

      context 'when player1 is in stalemate' do
        before do
          allow(player1).to receive(:in_stalemate?).with(chess_board).and_return(true)
        end

        it 'outputs draw message' do
          message = 'white player is in stalemate, the game is a draw!'
          expect(game).to receive(:puts).with(message).once
          game.announce_winner
        end
      end
    end

    context 'when @players array is equal to [player2, player1]' do
      before do
        game.instance_variable_set(:@players, players.rotate)
        allow(player2).to receive(:in_checkmate?)
        allow(player2).to receive(:in_stalemate?)
      end

      context 'when player2 is checkmated by player1' do
        before do
          allow(player2).to receive(:in_checkmate?).with(chess_board).and_return(true)
        end

        it 'outputs winner message for :white player' do
          message = 'white player won by a checkmate!'
          expect(game).to receive(:puts).with(message).once
          game.announce_winner
        end
      end

      context 'when player2 is in stalemate' do
        before do
          allow(player2).to receive(:in_stalemate?).with(chess_board).and_return(true)
        end

        it 'outputs draw message' do
          message = 'black player is in stalemate, the game is a draw!'
          expect(game).to receive(:puts).with(message).once
          game.announce_winner
        end
      end
    end
  end

  describe '#load_save?' do
    context 'when player inputted \'y\' the first time' do
      it 'returns true' do
        allow(game).to receive(:load_choice).and_return('y')
        result = game.load_save?
        expect(result).to be true
      end
    end

    context 'when player inputted \'n\' the first time' do
      it 'returns false' do
        allow(game).to receive(:load_choice).and_return('n')
        result = game.load_save?
        expect(result).to be false
      end
    end

    context 'when player provided wrong input 3 times' do
      it 'displays error message 3 times' do
        allow(game).to receive(:load_choice).and_return('d', '2', 'w', 'n')
        expect(game).to receive(:puts).with('Wrong input!').exactly(3).times
        game.load_save?
      end
    end
  end

  describe '#any_existing_save?' do
    context 'when saved game exists' do
      it 'returns true' do
        stub_const('SaveLoad::SAVES', [:s])
        result = game.any_existing_save?
        expect(result).to be true
      end
    end

    context 'when saved game does not exist' do
      it 'returns false' do
        stub_const('SaveLoad::SAVES', [])
        result = game.any_existing_save?
        expect(result).to be false
      end
    end
  end

  describe '#verify_load' do
    before do
      saves = %i[save save save]
      stub_const('SaveLoad::SAVES', saves)
    end

    context 'when given correct load input' do
      it 'returns true' do
        load_input = '2'
        result = game.verify_load(load_input)
        expect(result).to be true
      end
    end

    context 'when given incorrect load input' do
      it 'returns nil' do
        load_input = 'sus'
        result = game.verify_load(load_input)
        expect(result).to be nil
      end
    end
  end

  describe '#load_game' do
    context 'when given correct input on first try' do
      let(:c_input) { '2' }

      before do
        allow(game).to receive(:load_input).and_return(c_input)
        allow(game).to receive(:verify_load).with(c_input).and_return(true)
      end

      it 'calls #setup_load with correct index and breaks the loop' do
        expect(game).to receive(:setup_load).with(c_input.to_i)
        game.load_game
      end
    end

    context 'when given correct input on third try' do
      before do
        w_input1 = 'dw'
        w_input2 = '4'
        c_input = '1'
        allow(game).to receive(:load_input).and_return(w_input1, w_input2, c_input)
        allow(game).to receive(:verify_load).and_return(false, false, true)
        allow(game).to receive(:setup_load)
      end

      it 'displays error message 2 times' do
        expect(game).to receive(:puts).twice
        game.load_game
      end
    end
  end

  describe '#setup_load' do
    let(:save1) { 'saves/save1.yaml' }
    let(:yaml_string) { 'amogus' }
    let(:attributes) { [:at1] }

    before do
      stub_const('SaveLoad::SAVES', [save1])
      allow(File).to receive(:read).and_return(yaml_string)
      allow(YAML).to receive(:load_stream).and_return(attributes)
      allow(game).to receive(:setup_attributes)
    end

    it 'reads correct save file' do
      index = 0
      expect(File).to receive(:read).with(save1)
      game.setup_load(index)
    end

    it 'loads correct YAML file stream' do
      index = 0
      expect(YAML).to receive(:load_stream).with(yaml_string)
      game.setup_load(index)
    end

    it 'calls #setup_attributes with correct argument' do
      index = 0
      expect(game).to receive(:setup_attributes).with(attributes)
      game.setup_load(index)
    end
  end

  describe '#setup_attributes' do
    let(:player_white) { instance_double(Player, color: :white) }
    let(:player_black) { instance_double(Player, color: :black) }
    let(:new_board) { instance_double(Board) }
    let(:players) { [player_white, player_black] }
    let(:attributes) { [player_white, player_black, new_board, %i[white black]] }

    it 'changes @player_white attribute' do
      expect { game.setup_attributes(attributes) }.to change { game.player_white }.to attributes[0]
    end

    it 'changes @player_black attribute' do
      expect { game.setup_attributes(attributes) }.to change { game.player_black }.to attributes[1]
    end

    it 'changes @chess_board attribute' do
      expect { game.setup_attributes(attributes) }.to change { game.chess_board }.to attributes[2]
    end

    it 'changes @players attribute' do
      expect { game.setup_attributes(attributes) }.to change { game.players }.to players
    end
  end

  describe '#save_game' do
    let(:player_white) { instance_double(Player, color: :white) }
    let(:player_black) { instance_double(Player, color: :black) }
    let(:chess_board) { instance_double(Board) }
    let(:players) { [player_white, player_black] }
    let(:dumped_string) { :ds }

    before do
      game.instance_variable_set(:@player_white, player_white)
      game.instance_variable_set(:@player_black, player_black)
      game.instance_variable_set(:@chess_board, chess_board)
      game.instance_variable_set(:@players, players)
      allow(YAML).to receive(:dump_stream).and_return(dumped_string)
      allow(File).to receive(:write)
      allow(game).to receive(:puts)
    end

    it 'stream YAML dumps correct attributes' do
      players_colors = players.map(&:color)
      expect(YAML).to receive(:dump_stream).with(player_white, player_black, chess_board, players_colors)
      game.save_game
    end

    it 'writes attributes to correct file' do
      file_name = "saves/#{Time.now.strftime('%d-%m-%Y %H:%M:%S')}.yaml"
      expect(File).to receive(:write).with(file_name, dumped_string)
      game.save_game
    end
  end
end
