# frozen_string_literal: true

require 'pry'

require_relative 'board.rb'
require_relative 'ai.rb'
require_relative 'peg.rb'

class Game
  COLORS = %w[red orange yellow green blue purple blank].freeze

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
    guess.each_with_index do |color, index|
      case color
      when 'R'
        guess_pegs[index] = Peg.new('Red')
      when 'O'
        guess_pegs[index] = Peg.new('Orange')
      when 'Y'
        guess_pegs[index] = Peg.new('Yellow')
      when 'G'
        guess_pegs[index] = Peg.new('Green')
      when 'B'
        guess_pegs[index] = Peg.new('Blue')
      when 'P'
        guess_pegs[index] = Peg.new('Purple')
      when 'X'
        guess_pegs[index] = Peg.new('')
      end
    end
    guess_pegs
  end

  def add_guess(guess)
    new_holes = guess.map { |peg| Hole.new(peg)}
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
