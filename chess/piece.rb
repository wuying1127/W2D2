require "singleton"
require_relative 'board'

class Piece
  attr_reader :color, :board
  attr_accessor :pos, :symbol

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  # def to_s
  #   symbol
  # end
  #


end

class NullPiece < Piece
  include Singleton

  def initialize
    @color = nil
  end

  def symbol
    "   "
  end

  def moves
  end

end

module SlidingPiece
  def moves
    moves = []
    row, col = pos
    move_dirs.each do |dir|
      x, y = dir
      new_pos = [row + x, col + y]
      while board.valid_pos?(new_pos)
        piece = board[new_pos]
        if piece.is_a?(NullPiece)
          moves << new_pos
          new_row, new_col = new_pos
          new_pos = [new_row + x, new_col + y]
        else
          moves << new_pos if piece.color != self.color
          break
        end
      end
    end

    moves
  end

end

module SteppingPiece
  def moves
    moves = []
    row, col = pos
    move_set.each do |diff|
      x, y = diff
      new_pos = [row + x, col + y]
      if board.valid_pos?(new_pos) && board[new_pos].color != self.color
        moves << new_pos
      end
    end

    moves
  end
end

class King < Piece
  include SteppingPiece

  def symbol
    " K "
  end

  def move_set
    [
      [ 0,  1],
      [ 0, -1],
      [ 1,  0],
      [ 1,  1],
      [ 1, -1],
      [-1,  0],
      [-1,  1],
      [-1, -1]
    ]
  end
end

class Queen < Piece
  include SlidingPiece

  def symbol
    " Q "
  end

  def move_dirs
    [
      [ 0, -1],
      [ 0,  1],
      [-1,  0],
      [ 1,  0],
      [-1, -1],
      [-1,  1],
      [ 1, -1],
      [ 1,  1]
    ]
  end
end

class Bishop < Piece
  include SlidingPiece

  def symbol
    " B "
  end

  def move_dirs
    [
      [-1, -1],
      [-1,  1],
      [ 1, -1],
      [ 1,  1]
    ]
  end
end

class Rook < Piece
  include SlidingPiece

  def symbol
    " R "
  end

  def move_dirs
    [
      [ 0, -1],
      [ 0,  1],
      [-1,  0],
      [ 1,  0]
    ]
  end
end

class Knight < Piece
  include SteppingPiece

  def symbol
    " N "
  end

  def move_set
    [
      [ 1,  2],
      [ 1, -2],
      [-1,  2],
      [-1, -2],
      [ 2,  1],
      [ 2, -1],
      [-2,  1],
      [-2, -1],
    ]
  end

end

class Pawn < Piece
  include SteppingPiece

  def symbol
    " P "
  end

  def move_set
    move_set = []
    diff = (color == :black ? 1 : -1)

    # if pos[0] == 1 && color == :black || pos[0] == 6 && color == :white
    #   move_set << [ 2 * diff, 0]
    # end

    forward = [pos[0] + diff, pos[1]]
    diag_right = [pos[0] + diff, pos[1] + 1]
    diag_left = [pos[0] + diff, pos[1] - 1]
    move_set << [diff, 0] if board[forward].is_a?(NullPiece)
    move_set << [diff, 1] if is_enemy_piece?(diag_right)
    move_set << [diff, -1] if is_enemy_piece?(diag_left)

    move_set
  end

  def is_enemy_piece?(pos)
    !board[pos].nil? && board[pos].color != self.color
  end

end
