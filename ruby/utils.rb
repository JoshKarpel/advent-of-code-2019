# frozen_string_literal: true

def manhattan(p, q = nil)
  q = Array.new(p.length, 0) if q.nil?
  p.zip(q).reduce(0) { |acc, (r, s)| acc + (r - s).abs }
end

module Enumerable
  def tally
    tally = Hash.new(0)
    each { |element| tally[element] += 1 }
    tally
  end
end

class Array
  def tally
    self.each.tally
  end
end
