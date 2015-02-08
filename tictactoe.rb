require 'matrix'
class SquareAlreadyTakenError < StandardError; end

class Cell
  attr_accessor :value
  def to_s
    value||" "
  end

  def value=(value)
    if @value
      raise SquareAlreadyTakenError
    else
      @value = value
    end
  end
end

class Grid
  def initialize
    @cells = [
      [Cell.new, Cell.new, Cell.new],
      [Cell.new, Cell.new, Cell.new],
      [Cell.new, Cell.new, Cell.new]
    ]
    @lastmove = "O"
  end

  def nextmove
    @lastmove == "X" ? "O" : "X"
  end

  def move(x, y, value)
    @lastmove = value
    @cells[x][y].value = value
  end

  def full?
    @cells.flatten.all?{|cell| cell.value }
  end

  def winner?(value)
    if three_in_a_row?(@cells, value)
      true
    elsif three_in_a_row?([[@cells[0][0], @cells[1][1], @cells[2][2]], [@cells[0][2], @cells[1][1], @cells[2][0]]], value)
      true
    elsif three_in_a_row?(Matrix::columns(@cells).to_a, value)
      true
    else
      false
    end
  end

  def to_s
    @cells.map { |row| row.map(&:to_s).join("|") }.join("\n#{'–'*5}\n")
  end

private
  def three_in_a_row?(cells, value)
    cells.any? { |row| row.all? { |cell| cell.value == value } }
  end
end

grid = Grid.new
puts grid

while(true) do
  current_move = grid.nextmove
  begin
    puts "Your move, #{current_move}"
    print "row> "
    row = gets.to_i
    print "column> "
    column = gets.to_i
    grid.move(row, column, current_move)
  rescue SquareAlreadyTakenError
    puts "Whoops! that square is already taken"
    retry
  end

  puts
  puts grid
  if grid.winner?(current_move)
    puts "Game over, #{current_move} wins."
    break
  end
  if grid.full?
    puts "Game over, draw"
    break
  end
end
