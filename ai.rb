# frozen_string_literal: true

require 'pry'

require_relative 'clues.rb'

class Ai
  include Clues
  def initialize(colors)
    self.guess_colors = colors
    # self.secret_code = [Peg.new(colors.values.sample),
    #                     Peg.new(colors.values.sample),
    #                     Peg.new(colors.values.sample),
    #                     Peg.new(colors.values.sample)]
    self.secret_code = [Peg.new("Orange"), Peg.new("Yellow"), Peg.new("Yellow"), Peg.new("Orange")]
    self.color_frequency = build_color_frequency(secret_code)
  end

  attr_accessor :secret_code, :color_frequency, :guess_colors

  def build_color_frequency(secret_code)
    color_frequency = Hash.new(0)
    secret_code.each { |peg| color_frequency[peg.color] += 1 }
    color_frequency
  end

  def repeat_correct_pegs(clue_hole, new_guess_pegs, last_guess_pegs, incorrectly_positioned_colors)
    clue_hole.pegs.each_with_index do |clue_peg, index|
      new_guess_pegs[index].color = last_guess_pegs[index].color if clue_peg.color == "Black"
      incorrectly_positioned_colors[index] = [last_guess_pegs[index].color, false] if clue_peg.color == "White"
    end
  end

  def reposition_incorrect_pegs(new_guess_pegs, incorrectly_positioned_colors)
    new_guess_pegs.each_with_index do |peg, index|
      incorrectly_positioned_colors.each do |previous_position, color_and_reposition_status|
        if peg.color == ' ' && previous_position != index && color_and_reposition_status[previous_position][1] == false
          new_guess_pegs[index].color = color_and_reposition_status[previous_position][0]
          color_and_reposition_status[previous_position][1] = true
        end
      end
    end
  end

  def guess(clue_hole, last_guess_pegs)
    new_guess_pegs = Array.new(4){Peg.new(' ')}
    incorrectly_positioned_colors = {}
    return Array.new(4){Peg.new(guess_colors.values.sample)} unless clue_hole

    repeat_correct_pegs(clue_hole, new_guess_pegs, last_guess_pegs, incorrectly_positioned_colors)
    reposition_incorrect_pegs(new_guess_pegs, incorrectly_positioned_colors)
    new_guess_pegs.each { |peg| peg.color = guess_colors.values.sample if peg.color == ' ' }
  end
end
