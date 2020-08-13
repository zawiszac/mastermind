# frozen_string_literal: true

require 'pry'

require_relative 'board.rb'
require_relative 'ai.rb'
require_relative 'peg.rb'
require_relative 'player.rb'

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

  def initialize(number_of_guesses, user_choice)
    self.number_of_guesses = number_of_guesses
    self.gameboard = Board.new(number_of_guesses)
    self.opponent = Ai.new(COLORS)
    self.user = Player.new
    self.codemaker = (user_choice == 'y') ? user : opponent
    self.current_row = 0
    self.code_exists = false
  end

  private

  attr_accessor :gameboard, :opponent, :current_row, :number_of_guesses, :user, :codemaker, :code_exists

  def prompt_codemaker
    secret_code = []
    until secret_code.length == 4
      puts 'R: red, O: orange, Y: yellow, G: green, B: blue, P: purple'
      print "Enter 4 of the above letters to create your secret code (no spaces): "
      secret_code = gets.chomp.upcase.split(//)
      puts 'Error: must enter exactly 4 colors' if secret_code.length != 4
    end
    code_exists = true
    secret_code
  end

  def prompt_codebreaker
    guess_arr = []
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
      [true, 'codebreaker']
    elsif current_row == number_of_guesses
      [true, 'codemaker']
    else
      [false, '']
    end
  end

  def last_clue
    gameboard.clue_holes[current_row - 1] if current_row > 0
  end

  def last_guess
    gameboard.holes[current_row - 1].map { |hole| hole.peg } if current_row > 0
  end

  def set_code
    user.set_secret_code(prompt_codemaker.map { |color| Peg.new(COLORS[color])})
    self.code_exists = true
  end

  public

  def play_round
    set_code unless code_exists || codemaker == opponent

    if codemaker == opponent
      guess_pegs = build_guess_pegs(prompt_codebreaker)
      place_pegs(guess_pegs)
      clue_pegs = opponent.give_clue(guess_pegs, opponent.color_frequency)
    else
      guess_pegs = opponent.guess(last_clue, last_guess)
      place_pegs(guess_pegs)
      clue_pegs = user.give_clue(guess_pegs, user.color_frequency)
      sleep(3)
    end
    place_pegs(clue_pegs, true)
    self.current_row += 1
    gameboard.display
    game_over?(clue_pegs)
  end
end
