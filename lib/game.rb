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
  include AI

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
      check_condition = player.in_check?(chess_board)
      break if player.in_checkmate?(chess_board, check_condition) || player.in_stalemate?(chess_board, check_condition)

      puts "#{player.color} player is in check!" if check_condition
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
    player.type == :human ? player.human_move(chess_board, self) : player.ai_move(chess_board)
  end
end
