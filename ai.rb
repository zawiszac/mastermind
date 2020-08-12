# frozen_string_literal: true

require 'pry'

class Ai
  def initialize(colors)
    # self.code = colors.sample(4)
    self.code = ["Red", "Orange", "Yellow", "Green"]
  end

  attr_accessor :code

  def add_black_pegs(guess, guess_hash, clue)
    guess.each_with_index do |peg, index|
      clue[index] = Peg.new('Black') if peg.color == code[index]
      guess_hash[peg.color] -= 1
    end
  end

  def add_white_pegs(guess, guess_hash, clue)
    guess.each_with_index do |peg, index|
      next if clue[index].color == "Black"
      clue[index] = Peg.new('White') if code.include?(peg.color) && guess_hash.key?(peg.color)
    end
  end

  def build_guess_hash(guess)
    guess_hash= {}
    guess.each do |peg|
      if guess_hash.key?(peg.color)
        guess_hash[peg.color] += 1
      else
        guess_hash[peg.color] = 1
      end
    end
    guess_hash
  end

  def give_clue(guess)
    clue = [nil, nil, nil, nil]
    guess_hash = build_guess_hash(guess)
    add_black_pegs(guess, guess_hash, clue)
    add_white_pegs(guess, guess_hash, clue)
    new_mini_hole = MiniHole.new(clue)
    new_mini_hole
  end
end
