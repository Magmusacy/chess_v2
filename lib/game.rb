# frozen_string_literal: true

require_relative 'modules/pieces_creator'
require_relative 'modules/player_creator'
require_relative 'modules/special_conditions'
require_relative 'modules/save_load'
require_relative 'board'
require_relative 'player'

# Class that is responsible game loop
class Game
  include PiecesCreator
  include PlayerCreator
  include SaveLoad

  attr_reader :player_white, :player_black, :chess_board, :players

  def initialize(player_white = nil, player_black = nil, chess_board = Board.new)
    @player_white = player_white
    @player_black = player_black
    @chess_board = chess_board
    @players = nil
  end

  def create_game
    @player_white, @player_black = create_players
    white_pieces = create_pieces(player_white)
    black_pieces = create_pieces(player_black)
    @players = [@player_white, @player_black]
    chess_board.setup_board(white_pieces, black_pieces)
  end

  def setup_game
    any_existing_save? && load_save? ? load_game : create_game
  end

  def play_game
    setup_game
    game_loop
    announce_winner
  end

  def game_loop
    loop do
      player = @players.first
      break if player.in_checkmate?(chess_board) || player.in_stalemate?(chess_board)

      puts "#{player.color} player is in check!" if player.in_check?(chess_board)
      player_move(player)
      @players.rotate!
    end
  end

  def announce_winner
    player = @players.first
    puts "#{@players[1].color} player won by a checkmate!" if player.in_checkmate?(chess_board)
    puts "#{@players[0].color} player is in stalemate, the game is a draw!" if player.in_stalemate?(chess_board)
  end

  def player_move(player)
    player.type == :human ? human_move(player) : ai_move(player)
  end

  def human_move(player)
    loop do
      begin
        square = pick(player)
        move = pick(player, square)
        raise NoMethodError if move.nil?

        return square.piece.move(move, chess_board)
      rescue NoMethodError
        puts 'Chosen wrong square, try again'
      end
    end
  end

  def select_square(squares)
    position = input_hub
    return squares.find { |sqr| sqr.position == position } unless position.nil?
  end

  def ai_move(player)
    chess_board.display
    square = player.ai_pick_square(chess_board)
    legal_moves = square.piece.legal_moves(chess_board)
    chess_board.display(square, legal_moves)
    move = player.ai_pick_legal_move(legal_moves)
    square.piece.move(move, chess_board)
  end

  def input_hub
    input = basic_input
    input == :s ? save_game : input
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

  def pick(player, chosen_square = :deafult, legal_moves = [])
    if chosen_square == :deafult
      chess_board.display
      available_squares = chess_board.squares_taken_by(player.color)
    else
      available_squares = chosen_square.piece.legal_moves(chess_board)
      chess_board.display(chosen_square, available_squares)
    end
    select_square(available_squares)
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
