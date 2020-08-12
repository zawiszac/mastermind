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
    'P' => 'Purple',
    'X' => 'Blank'
  }.freeze

  def initialize(number_of_guesses)
    self.gameboard = Board.new(number_of_guesses)
    self.opponent = Ai.new(COLORS)
    self.round_number = 0
  end

  private

  attr_accessor :gameboard, :opponent, :round_number

  def prompt
    puts 'R: red, O: orange, Y: yellow, G: green, B: blue, P: purple, X: blank'
    print 'Enter 4 of the above letters (no spaces) to guess the code: '
  end

  def place_peg(new_peg, row, col)
    hole = gameboard.hole_at(row, col)
    hole.peg = new_peg
  end

  def build_guess_pegs(guess)
    guess_pegs = []
    guess.each { |color| guess_pegs << Peg.new(COLORS[color]) }
    guess_pegs
  end

  def add_guess(guess)
    new_holes = guess.map { |peg| Hole.new(peg) }
    gameboard.holes[round_number] = new_holes
  end

  def add_clue(clue)
    gameboard.mini_holes[round_number] = clue
  end

  public

  def play_round
    prompt
    guess = gets.chomp.upcase.split(//)
    guess_pegs = build_guess_pegs(guess)
    add_guess(guess_pegs)
    clue = opponent.give_clue(guess_pegs)
    add_clue(clue)
    self.round_number += 1
    gameboard.display
  end
end
