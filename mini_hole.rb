# frozen_string_literal: true

class MiniHole
  def initialize(arr = [Peg.new(' '), Peg.new(' '), Peg.new(' '), Peg.new(' ')])
    self.pegs = arr
  end

  attr_accessor :pegs
end
