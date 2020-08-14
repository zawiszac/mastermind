# frozen_string_literal: true

class Player
  include Clues
  def initialize
    self.secret_code = Array.new(4) { Peg.new(' ') }
    self.color_frequency = build_color_frequency(secret_code)
  end

  def build_color_frequency(secret_code)
    color_frequency = Hash.new(0)
    secret_code.each { |peg| color_frequency[peg.color] += 1 }
    color_frequency
  end

  def set_secret_code(code)
    self.secret_code = code
    self.color_frequency = build_color_frequency(secret_code)
  end

  attr_accessor :secret_code, :color_frequency
end
