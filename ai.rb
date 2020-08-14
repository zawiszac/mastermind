# frozen_string_literal: true

require_relative 'clues.rb'

require 'pry'

class Ai
  include Clues
  def initialize(colors)
    self.guess_colors = colors.dup
    self.secret_code = [Peg.new(colors.values.sample),
                        Peg.new(colors.values.sample),
                        Peg.new(colors.values.sample),
                        Peg.new(colors.values.sample)]
    self.color_frequency = build_color_frequency(secret_code)
    self.colors_arr = guess_colors.values
    self.next_guess_indices = { 0 => 0, 1 => 0, 2 => 0, 3 => 0 }
  end

  attr_accessor :secret_code, :color_frequency, :guess_colors, :colors_arr, :next_guess_indices

  def build_color_frequency(secret_code)
    color_frequency = Hash.new(0)
    secret_code.each { |peg| color_frequency[peg.color] += 1 }
    color_frequency
  end

  def repeat_correct_pegs(clue_hole, new_guess_pegs, last_guess_pegs, incorrectly_positioned_colors)
    clue_hole.pegs.each_with_index do |clue_peg, i|
      new_guess_pegs[i].color = last_guess_pegs[i].color if clue_peg.color == 'Black'
      incorrectly_positioned_colors[i] = [last_guess_pegs[i].color, false] if clue_peg.color == 'White'
    end
  end

  def reposition_incorrect_pegs(new_guess_pegs, incorrectly_positioned_colors)
    new_guess_pegs.each_with_index do |peg, i|
      incorrectly_positioned_colors.each do |previous_position, color_and_reposition_status|
        if peg.color == ' ' && previous_position != i && !color_and_reposition_status[1]
          new_guess_pegs[i].color = color_and_reposition_status[0]
          color_and_reposition_status[1] = true
        end
      end
    end
  end

  def guess_strategy1(clue_hole, last_guess_pegs)
    new_guess_pegs = Array.new(4) { Peg.new(' ') }
    incorrectly_positioned_colors = {}
    return Array.new(4) { Peg.new(guess_colors.values.sample) } unless clue_hole

    repeat_correct_pegs(clue_hole, new_guess_pegs, last_guess_pegs, incorrectly_positioned_colors)
    reposition_incorrect_pegs(new_guess_pegs, incorrectly_positioned_colors)
    new_guess_pegs.each { |peg| peg.color = guess_colors.values.sample if peg.color == ' ' }
  end

  def guess_strategy2(clue_hole, last_guess_pegs)
    new_guess_pegs = []
    
    unless clue_hole
      new_guess_pegs = Array.new(4){Peg.new(colors_arr[0])}
      return new_guess_pegs
    end

    clue_hole.pegs.each_with_index do |peg, i|
      if peg.color == 'Black'
        new_guess_pegs[i] = Peg.new(last_guess_pegs[i].color)
      else
        self.next_guess_indices[i] += 1
        color_index = next_guess_indices[i]
        new_guess_pegs[i] =  Peg.new(colors_arr[color_index])
      end
    end
    new_guess_pegs
  end
end
