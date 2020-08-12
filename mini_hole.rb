# frozen_string_literal: true

class MiniHole
  def initialize(arr = [nil, nil, nil])
    self.pegs = arr
  end

  attr_accessor :pegs
end
