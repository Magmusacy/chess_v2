require 'yaml'

module SaveLoad
  SAVES = Dir.glob('saves/*.yaml')

  def save_game
    file_name = "saves/#{Time.now.strftime("%d-%m-%Y %H:%M:%S")}.yaml"
    players_colors = players.map { |p| p.color }
    file_contents = YAML.dump_stream(player_white, player_black, chess_board, players_colors)
    File.write(file_name, file_contents)
    puts "Successfully saved game in a file \"#{file_name}\""
  end

  def load_game
    loop do
      input = load_input
      return setup_load(input.to_i) if verify_load(input)

      puts 'Wrong input!'
    end
  end

  def setup_load(index)
    file = SAVES[index]
    attributes = YAML.load_stream(File.read(file))
    setup_attributes(attributes)
  end

  def setup_attributes(attributes)
    @player_white, @player_black, @chess_board, @players = attributes
    @players.map! { |clr| clr == @player_white.color ? @player_white : @player_black }
  end

  def verify_load(input)
    return true if input.to_i.to_s == input && SAVES[input.to_i]
  end

  def load_save?
    choice = { y: true, n: false }[load_choice.to_sym]
    return choice unless choice.nil?
    puts 'Wrong input!'
    return load_save?
  end

  def any_existing_save?
    !SAVES.empty?
  end

  private

  def load_input
    SAVES.each_with_index do |s, i|
      puts "#{i} - #{s.split('.').first.sub('saves/', '')}"
    end
    puts 'Type the number associated with the save you want.'
    gets.chomp
  end

  def load_choice
    puts 'It appears that you have existing saves. Would you like to load one? (y/n)'
    gets.chomp
  end
end