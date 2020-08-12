# frozen_string_literal: true

class Peg
  def initialize(color)
    self.color = color
  end

  def to_s
    color[0]
  end

  attr_accessor :color
end
