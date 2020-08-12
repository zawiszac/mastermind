# frozen_string_literal: true

require_relative 'hole.rb'
require_relative 'mini_hole.rb'

# A representation of a mastermind board.
# Implements methods for displaying the board to the players and retrieving a hole object at a specified location
class Board
  BOARD_WIDTH = 25

  def initialize(number_of_rows)
    self.number_of_rows = number_of_rows
    self.holes = Array.new(number_of_rows) { Array.new(4, Hole.new) }
    self.mini_holes = Array.new(number_of_rows, MiniHole.new)
  end

  private

  attr_accessor :holes, :mini_holes, :number_of_rows

  def hole_at(row, col)
    board_arr[row][col]
  end

  def print_column_line
    print '  |   '
  end

  def print_row_line
    print '  '
    BOARD_WIDTH.times { |_i| print '-' }
    puts "\n"
  end

  def print_hole_cell(hole)
    print_column_line
    print hole.peg
  end

  def print_mini_holes(index)
    print_column_line
    print '   '
    puts mini_holes[index].pegs.join
  end

  public

  def display
    puts "\n\n\n"
    print_row_line
    holes.each_with_index do |row, index|
      row.each { |hole| print_hole_cell(hole) }
      print_mini_holes(index)
      print_row_line
    end
    puts "\n\n\n"
  end
end
