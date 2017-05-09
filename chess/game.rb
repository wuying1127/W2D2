require_relative 'board'
require_relative 'cursor'
require_relative 'display'
require_relative 'piece'


class Game
  attr_reader :board, :display, :start_pos

  def initialize
    @board = Board.new
    @display = Display.new(board)
    @start_pos = nil
  end

  def play
    loop do
      play_turn
    end
  end

  def play_turn
    system('clear')
    display.render
    input = display.cursor.get_input
    unless input.nil?
      unless @start_pos.nil?
        board.move_piece(@start_pos, input)
        @start_pos = nil
      end
      @start_pos = input if @start_pos.nil?
    end
  end
end

game = Game.new
game.play
