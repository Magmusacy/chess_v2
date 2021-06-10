# frozen_string_literal: true

require_relative 'board'
require_relative 'square'
require_relative 'player'
require_relative 'pieces/piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'game'

Game.new.play_game
