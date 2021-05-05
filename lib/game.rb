# frozen_string_literal: true

require_relative 'modules/pieces_creator'
require_relative 'modules/player_creator'
require_relative 'modules/special_conditions'
require_relative 'board'
require_relative 'player'

# Class that is responsible game loop
class Game
  include PiecesCreator
  include PlayerCreator
  include SpecialConditions

  attr_reader :player_white, :player_black, :chess_board

  def initialize(player_white = nil, player_black = nil, chess_board = Board.new)
    @player_white = player_white
    @player_black = player_black
    @chess_board = chess_board
    @players = nil
  end

  def play_game
    @player_white, @player_black = create_players
    white_pieces = create_pieces(player_white)
    black_pieces = create_pieces(player_black)
    @players = [@player_white, @player_black]
    chess_board.setup_board(white_pieces, black_pieces)
    game_loop
    announce_winner
  end

  def game_loop
    loop do
      color_1, color_2 = @players.map(&:color)
      break if checkmate?(chess_board, color_1, color_2) == true || stalemate?(chess_board, color_1, color_2)
      display_check(color_1) if check?(chess_board, color_1, color_2)
      player_move(@players.first)
      @players.rotate!
    end
  end

  def announce_winner
    color_1, color_2 = @players.map(&:color)
    puts "#{color_2} player won by a checkmate!" if checkmate?(chess_board, color_1, color_2)
    puts "#{color_1} player is in stalemate, the game is a draw!" if stalemate?(chess_board, color_1, color_2)
  end

  def player_move(player)
    player.type == :human ? human_move(player) : ai_move(player)
  end

  def human_move(player)
    loop do
      chess_board.display
      chosen_square = get_correct_square(player)
      move_square = chess_board.get_square(player.input)
      return chosen_square.piece.move(move_square, chess_board) if correct_move?(chosen_square, move_square)

      puts 'Wrong move!'
    end
  end

  def ai_move(player)
    square = player.ai_pick_square(chess_board)
    legal_moves = square.piece.legal_moves(chess_board)
    move_square = player.ai_pick_legal_move(legal_moves)
    square.piece.move(move_square, chess_board)
  end

  def get_correct_square(player)
    loop do
      square = chess_board.get_square(player.input)
      return square if correct_input?(player, square)

      puts "Wrong square, you can only choose #{player.color} pieces"
    end
  end

  def correct_input?(player, input_square)
    chess_board.squares_taken_by(player.color).include?(input_square)
  end

  def correct_move?(square, input_move)
    square.piece.legal_moves(chess_board).include?(input_move)
  end

  private

  def display_check(color)
    puts "#{color} player is in check!"
  end
end