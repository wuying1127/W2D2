require 'colorize'
require 'colorized_string'
require_relative 'cursor'
require_relative 'board'
require_relative 'piece'

class Display
  attr_reader :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    board.grid.each_with_index do |row, r|
      display_row = row.map.with_index do |piece, c|
        symbol, pos = piece.symbol, [r, c]
        if pos == cursor.cursor_pos
          symbol.colorize(:background => cursor.color)
        elsif pos.all?(&:even?) || pos.all?(&:odd?)
          symbol.colorize(:color => :light_black, :background => :light_white)
        else
          symbol.colorize(:color => :light_white, :background => :light_black)
        end
      end

      puts display_row.join('')
    end
  end

  def demo_play
    loop do
      system("clear")
      render
      cursor.get_input
    end
  end

end

# board = Board.new
# display = Display.new(board)
# display.demo_play
