# frozen_string_literal: true

require_relative 'modules/ai'

# Contains logic for getting, veryfing and trasnlating player input
class Player
  include AI
  attr_reader :color, :type

  def initialize(color, type)
    @color = color
    @type = type
  end

  def input
    loop do
      player_input = gets.chomp
      verified_input = verify_input(player_input)
      return translate_input(verified_input) unless verified_input.nil?

      puts 'Wrong square specified, to specify square type first it\'s column, then it\'s row like: b2'
    end
  end

  def verify_input(input_pos)
    return unless input_pos.length == 2
    # RegEx might be better a solution here
    return input_pos if input_pos[0].between?('a', 'h') && input_pos[1].between?('1', '8')
  end

  def translate_input(str_input)
    x = (str_input[0].ord - 'a'.ord) + 1
    y = str_input[1].to_i
    { x: x, y: y }
  end
end
