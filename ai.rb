# frozen_string_literal: true

require 'pry'

class Ai
  def initialize(colors)
    self.secret_code = [Peg.new(colors.values.sample),
                        Peg.new(colors.values.sample),
                        Peg.new(colors.values.sample),
                        Peg.new(colors.values.sample)]
    self.color_frequency = build_color_frequency(secret_code)
  end

  attr_accessor :secret_code, :color_frequency

  def add_black_pegs(guess_pegs, clue_pegs)
    guess_pegs.each_with_index do |peg, index|
      if peg.color == secret_code[index].color
        clue_pegs[index] = Peg.new('Black')
        color_frequency[peg.color] -= 1
      end
    end
  end

  def add_white_pegs(guess_pegs, clue_pegs)
    guess_pegs.each_with_index do |peg, index|
      next if clue_pegs[index].color == 'Black'

      if secret_code.any? { |secret_peg| secret_peg.color == peg.color } && color_frequency[peg.color] > 0
        clue_pegs[index] = Peg.new('White')
        color_frequency[peg.color] -= 1
      end
    end
  end

  def build_color_frequency(secret_code)
    color_frequency = Hash.new(0)
    secret_code.each { |peg| color_frequency[peg.color] += 1 }
    color_frequency
  end

  def give_clue(guess_pegs)
    clue_pegs = Array.new(4) { Peg.new(' ') }
    add_black_pegs(guess_pegs, clue_pegs)
    add_white_pegs(guess_pegs, clue_pegs)
    clue_pegs
  end
end
