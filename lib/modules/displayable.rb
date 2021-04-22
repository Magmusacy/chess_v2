# frozen_string_literal: true

# Displays the board and the Pieces on it
module Displayable
  def display_board(legal_moves = [])
    row_colors = [45, 43, 45, 43, 45, 43, 45, 43]
    board_copy = chess_board.board.clone.reverse
    8.times do |i|
      print "#{(i - 8).abs} "
      display_row(board_copy.shift(8), row_colors.rotate!)
      puts
    end
    puts '   a  b  c  d  e  f  g  h'
  end

  def display_row(array, row_colors, legal_moves = [])
    array.each_with_index do |sqr, idx|
      if legal_moves.include?(sqr)
        print colorize(sqr.piece, 41)
      else
        print colorize(sqr.piece, row_colors[idx])
      end
    end
  end

  def colorize(string, color_code)
    "\e[#{color_code}m#{string}\e[0m"
  end
end
