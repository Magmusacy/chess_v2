require_relative '../lib/game'
require_relative '../lib/player'

describe Game do
  describe '#input_setting' do
    subject(:input_game) { described_class.new }

    context 'when given input 2' do
      it 'returns 2' do
        input = '2'
        allow(input_game).to receive(:gets).and_return(input)
        result = input_game.input_setting
        expect(result).to eq(2)
      end
    end

    context 'when given wrong settings option 2 times' do

      before do
        wrong_input1 = '0'
        wrong_input2 = '4'
        good_input = '1'
        allow(input_game).to receive(:gets).and_return(wrong_input1, wrong_input2, good_input)
      end

      it 'displays error message 2 times' do
        error_message = 'Wrong input! Try again'
        expect(input_game).to receive(:puts).with(error_message).twice
        result = input_game.input_setting
      end
    end
  end

  describe '#initialize_player' do
    subject(:player_game) { described_class.new }

    context 'when given :white color and :human type' do
      it 'sends :new message to Player class with :white and :human arguments' do
        color = :white
        type = :human
        expect(Player).to receive(:new).with(color, type)
        player_game.initialize_player(color, type)
      end
    end

    context 'when given :black color and :ai type' do
      it 'sends :new message to Player class with :black and :ai arguments' do
        color = :black
        type = :ai
        expect(Player).to receive(:new).with(color, type)
        player_game.initialize_player(color, type)
      end
    end
  end

  describe '#game_mode' do
    subject(:game) { described_class.new }

    context 'when given setting 1' do
      let(:player1) { instance_double(Player, color: :white, type: :human) }
      let(:player2) { instance_double(Player, color: :black, type: :human) }

      before do
        allow(game).to receive(:initialize_player).with(:white, :human).and_return(player1)
        allow(game).to receive(:initialize_player).with(:black, :human).and_return(player2)
      end

      it 'returns array with :white :human player and :black :human player' do
        setting = 1
        result = game.game_mode(setting)
        expected = [player1, player2]
        expect(result).to match_array(expected)
      end
    end

    context 'when given setting 2' do
      let(:player1) { instance_double(Player, color: :white, type: :human) }
      let(:player2) { instance_double(Player, color: :black, type: :ai) }

      before do
        allow(game).to receive(:initialize_player).with(:white, :human).and_return(player1)
        allow(game).to receive(:initialize_player).with(:black, :ai).and_return(player2)
      end

      it 'returns array with :white :human player and :black :ai player' do
        setting = 2
        result = game.game_mode(setting)
        expected = [player1, player2]
        expect(result).to match_array(expected)
      end
    end

    context 'when given setting 3' do
      let(:player1) { instance_double(Player, color: :white, type: :ai) }
      let(:player2) { instance_double(Player, color: :black, type: :ai) }

      before do
        allow(game).to receive(:initialize_player).with(:white, :ai).and_return(player1)
        allow(game).to receive(:initialize_player).with(:black, :ai).and_return(player2)
      end

      it 'returns array with :white :ai player and :black :ai player' do
        setting = 3
        result = game.game_mode(setting)
        expected = [player1, player2]
        expect(result).to match_array(expected)
      end
    end
  end
end