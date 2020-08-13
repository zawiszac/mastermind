# frozen_string_literal: true

require 'pry'

class Ai
  def initialize(_colors)
    # self.secret_code = colors.sample(4)
    self.secret_code = %w[Red Orange Yellow Green]
  end

  attr_accessor :secret_code

  def add_black_pegs(guess_pegs, color_frequency, clue_pegs)
    guess_pegs.each_with_index do |peg, index|
      if peg.color == secret_code[index]
        clue_pegs[index] = Peg.new('Black')
        color_frequency[peg.color] -= 1
      end
    end
  end

  def add_white_pegs(guess_pegs, color_frequency, clue_pegs)
    guess_pegs.each_with_index do |peg, index|
      next if clue_pegs[index].color == 'Black'

      if secret_code.include?(peg.color) && color_frequency[peg.color].positive?
        clue_pegs[index] = Peg.new('White')
        color_frequency[peg.color] -= 1
      end
    end
  end

  def build_color_frequency(guess_pegs)
    color_frequency = Hash.new(0)
    guess_pegs.each { |peg| color_frequency[peg.color] += 1 }
    color_frequency
  end

  def give_clue(guess_pegs)
    clue_pegs = Array.new(4) { Peg.new(' ') }
    color_frequency = build_color_frequency(guess_pegs)
    add_black_pegs(guess_pegs, color_frequency, clue_pegs)
    add_white_pegs(guess_pegs, color_frequency, clue_pegs)
    clue_pegs
  end
end
