# frozen_string_literal: true

require_relative 'modules/ai'
require_relative 'modules/special_conditions'

# Contains logic for getting move input from the player
class Player
  include AI
  include SpecialConditions
  attr_reader :color, :type

  def initialize(color, type)
    @color = color
    @type = type
  end

  def human_move(board, game)
    loop do
      begin
        square = pick(game, board)
        move = pick(game, board, square)
        raise NoMethodError if move.nil?

        return square.piece.move(move, board)
      rescue NoMethodError
        puts 'Chosen wrong square, try again'
      end
    end
  end

  def select_square(squares, game)
    position = input_hub(game)
    return squares.find { |sqr| sqr.position == position } unless position.nil?
  end

  def input_hub(game)
    input = basic_input
    input == :s ? game.save_game : input
  end

  def basic_input
    loop do
      player_input = gets.chomp
      verified_input = verify_input(player_input)
      return verified_input if verified_input

      puts 'Wrong input!'
    end
  end

  def verify_input(input)
    if input == 's'
      :s
    elsif square_input?(input)
      translate(input)
    end
  end

  private

  def pick(game, board, chosen_square = :deafult)
    if chosen_square == :deafult
      board.display(color, type)
      available_squares = board.squares_taken_by(color)
    else
      available_squares = chosen_square.piece.legal_moves(board)
      board.display(color, type, chosen_square, available_squares)
    end
    select_square(available_squares, game)
  end

  def square_input?(input)
    return true if input.length == 2 && input[0].between?('a', 'h') && input[1].between?('1', '8')
  end

  def translate(input)
    x = (input[0].ord - 'a'.ord) + 1
    y = input[1].to_i
    { x: x, y: y }
  end
end
