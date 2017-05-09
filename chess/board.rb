require_relative "piece"
require_relative "display"

class Board
  attr_reader :grid

  def self.empty_grid
    Array.new(8) {Array.new(8)}
  end

  def initialize
    @grid = Board.empty_grid
    create_pieces
  end

  def create_pieces
    create_black
    create_white
    create_null
  end

  def create_black
    create_pawns(1, :black)
    create_empire(0, :black)
  end

  def create_white
    create_pawns(6, :white)
    create_empire(7, :white)
  end

  def create_null
    (2..5).each do |row|
      @grid[row].map! { |pos| NullPiece.instance }
    end
  end

  def create_empire(i, color)
    @grid[i].map!.with_index do |pos, j|
      case j
      when 0, 7
        Rook.new([i, j], color, self)
      when 1, 6
        Knight.new([i, j], color, self)
      when 2, 5
        Bishop.new([i, j], color, self)
      when 3
        King.new([i, j], color, self)
      when 4
        Queen.new([i, j], color, self)
      end
    end
  end

  def create_pawns(i, color)
    @grid[i].map!.with_index {|pos,j| Pawn.new([i, j], color, self)}
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].nil?
      raise InvalidPosError.new("No piece exists at start position")
    elsif  !valid_pos?(end_pos)
      raise InvalidPosError.new("Please input valid position (ex. 0,0)")
    end

  rescue InvalidPosError
    puts "Fix this later"
  else
    self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
    self[end_pos].pos = end_pos
    self[start_pos] = NullPiece.instance
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end

  def valid_pos?(pos)
    pos.all? {|coordinate| coordinate.between?(0, 7)}
  end

  def king_pos(color)
    @grid.each do |row|
      row.each do |piece|
        return piece.pos if piece.is_a?(King) && piece.color == color
      end
    end
  end

  def in_check?(color)
    king_pos = king_pos(color)
    @grid.any? do |row|
      row.any? { |piece| piece.color != color && piece.moves.include?(king_pos)}
    end
  end

  def checkmate?(color)
    @grid.all? do |row|
      row.none? { |piece| piece.color == color && piece.valid_moves.size > 0 }
    end
  end
  #
  # def valid_moves
  #
  # end


end

class InvalidPosError < StandardError
end
