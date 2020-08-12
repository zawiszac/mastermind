# frozen_string_literal: true

class Hole
  def initialize(peg = Peg.new(' '))
    self.peg = peg
  end

  attr_accessor :peg
end
