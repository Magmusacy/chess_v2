# frozen_string_literal: true

# Contains logic for creating Players with their type being read from terminal
module PlayerCreator
  def create_players
    player_settings
    game_mode(input_setting)
  end

  def game_mode(setting)
    case setting
    when 1 then [initialize_player(:white, :human), initialize_player(:black, :human)]
    when 2 then [initialize_player(:white, :human), initialize_player(:black, :ai)]
    when 3 then [initialize_player(:white, :ai), initialize_player(:black, :ai)]
    end
  end

  def initialize_player(color, type)
    Player.new(color, type)
  end

  def input_setting
    loop do
      input = gets.to_i
      return input if [1, 2, 3].include?(input)

      puts 'Wrong input! Try again'
    end
  end

  private

  def player_settings
    puts 'Welcome to player creator, choose between 3 settings listed below:'
    puts '1 - Player VS Player'
    puts '2 - Player VS AI'
    puts '3 - AI VS AI'
  end
end
