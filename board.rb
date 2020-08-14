# frozen_string_literal: true

require_relative 'hole.rb'
require_relative 'clue_hole.rb'

# A representation of a mastermind board.
# Implements methods for displaying the board to the players and retrieving a hole object at a specified location
class Board
  BOARD_WIDTH = 25

  def initialize(number_of_rows)
    self.number_of_rows = number_of_rows
    self.holes = Array.new(number_of_rows) { Array.new(4) { Hole.new } }
    self.clue_holes = Array.new(number_of_rows) { ClueHole.new }
  end

  attr_accessor :holes, :clue_holes, :number_of_rows

  def print_column_line
    print '  |  '
  end

  def print_row_line
    print '  '
    BOARD_WIDTH.times { |_i| print '-' }
    puts "\n"
  end

  def print_hole_cell(hole)
    print_column_line
    print hole.peg.to_s
  end

  def print_clue_holes(index)
    print_column_line
    print '   '
    print '{'
    clue_holes[index].pegs.each { |peg| print peg.to_s }
    print '}'
    puts "\n"
  end

  def hole_at(row, col)
    holes[row][col]
  end

  def display
    puts "\n\n\n"
    print_row_line
    holes.each_with_index do |row, index|
      row.each { |hole| print_hole_cell(hole) }
      print_clue_holes(index)
      print_row_line
    end
    puts "\n\n\n"
  end
end
