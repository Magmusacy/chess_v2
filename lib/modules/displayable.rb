# frozen_string_literal: true

# Displays the board and the Pieces on it
module Displayable
  def display(player_color, player_type, square = nil, legal_moves = [])
    player_type_display(player_color, player_type)
    row_colors = [40, 43, 40, 43, 40, 43, 40, 43]
    board_copy = create_display_board
    8.times do |i|
      print "#{(i - 8).abs} "
      row = board_copy.shift(8)
      display_row(row.reverse, row_colors.rotate!, square, legal_moves)
      puts
    end
    puts '   a  b  c  d  e  f  g  h'
  end

  private

  def display_row(array, row_colors, player_square, legal_moves)
    array.each_with_index do |curr_sqr, idx|
      if legal_move_displayable?(legal_moves, curr_sqr)
        print colorize(square_to_string(curr_sqr), 46)
      elsif player_square_displayable?(curr_sqr, player_square)
        print colorize(square_to_string(curr_sqr), 44)
      else
        print colorize(square_to_string(curr_sqr), row_colors[idx])
      end
    end
  end

  def colorize(string, color_code)
    "\e[#{color_code}m#{string}\e[0m"
  end

  def player_type_display(player_color, player_type)
    player_type == :human ? nil : sleep(0.15)
    puts "#{player_color.capitalize} player turn"
  end

  def square_to_string(square)
    square.taken? ? " #{choose_icon(square.piece.class, square.piece.color)} " : '   '
  end

  def legal_move_displayable?(legal_moves, square)
    true if legal_moves.include?(square)
  end

  def player_square_displayable?(square, player_square)
    true if !player_square.nil? && player_square.position == square.position
  end

  def create_display_board
    @board.clone.sort_by { |h| h.position[:y] }.reverse
  end

  def choose_icon(piece, color)
    icons = { Rook => ['♜', '♖'],
              Knight => ['♞', '♘'],
              Bishop => ['♝', '♗'],
              Queen => ['♛', '♕'],
              King => ['♚', '♔'],
              Pawn => ['♟︎', '♙'] }
    i = color == :black ? 0 : 1
    icons[piece][i]
  end
end
