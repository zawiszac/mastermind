# frozen_string_literal: true

require 'pry'

require_relative 'board.rb'
require_relative 'ai.rb'
require_relative 'peg.rb'

class Game
  # COLORS = %w[red orange yellow green blue purple blank].freeze
  COLORS = {
    'R' => 'Red',
    'O' => 'Orange',
    'Y' => 'Yellow',
    'G' => 'Green',
    'B' => 'Blue',
    'P' => 'Purple'
  }.freeze

  def initialize(number_of_guesses)
    self.number_of_guesses = number_of_guesses
    self.gameboard = Board.new(number_of_guesses)
    self.opponent = Ai.new(COLORS)
    self.current_row = 0
  end

  private

  attr_accessor :gameboard, :opponent, :current_row, :number_of_guesses

  def prompt(guess_arr = [])
    until guess_arr.length == 4
      puts 'R: red, O: orange, Y: yellow, G: green, B: blue, P: purple'
      print 'Enter 4 of the above letters (no spaces) to guess the code: '
      guess_arr = gets.chomp.upcase.split(//)
      puts 'Error: must enter exactly 4 colors' if guess_arr.length != 4
    end
    guess_arr
  end

  def build_guess_pegs(guess_arr)
    guess_pegs = []
    guess_arr.each { |color| guess_pegs << Peg.new(COLORS[color]) }
    guess_pegs
  end

  def place_pegs(pegs, clue_pegs = false)
    if clue_pegs
      clue_hole_to_fill = gameboard.clue_holes[current_row]
      clue_hole_to_fill.pegs = pegs
    else
      holes_to_fill_arr = gameboard.holes[current_row]
      holes_to_fill_arr.each_with_index do |hole, index|
        hole.peg = pegs[index]
      end
    end
  end

  def game_over?(clue_pegs)
    if clue_pegs.all? { |peg| peg.color == 'Black' }
      [true, 'win!']
    elsif current_row == number_of_guesses
      [true, 'lose!']
    else
      [false, '']
    end
  end

  public

  def play_round
    guess_pegs = build_guess_pegs(prompt)
    place_pegs(guess_pegs)
    clue_pegs = opponent.give_clue(guess_pegs)
    place_pegs(clue_pegs, true)
    self.current_row += 1
    gameboard.display
    game_over?(clue_pegs)
  end
end
