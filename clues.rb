# frozen_string_literal: true

require 'pry'

module Clues
  def add_black_pegs(guess_pegs, clue_pegs, color_frequency)
    guess_pegs.each_with_index do |peg, index|
      if peg.color == secret_code[index].color
        clue_pegs[index] = Peg.new('Black')
        color_frequency[peg.color] -= 1
      end
    end
  end

  def add_white_pegs(guess_pegs, clue_pegs, color_frequency)
    guess_pegs.each_with_index do |peg, index|
      next if clue_pegs[index].color == 'Black'
      if secret_code.any? { |secret_peg| secret_peg.color == peg.color } && color_frequency[peg.color] > 0
        clue_pegs[index] = Peg.new('White')
        color_frequency[peg.color] -= 1
      end
    end
  end

  def give_clue(guess_pegs, color_frequency)
    temp_color_frequency = color_frequency.clone
    clue_pegs = Array.new(4) { Peg.new(' ') }
    add_black_pegs(guess_pegs, clue_pegs, temp_color_frequency)
    add_white_pegs(guess_pegs, clue_pegs, temp_color_frequency)
    clue_pegs
  end
end