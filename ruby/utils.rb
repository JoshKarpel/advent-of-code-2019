# frozen_string_literal: true
# frozen_string_literal: true

def manhattan(p, q = nil)
  q = Array.new(p.length, 0) if q.nil?
  p.zip(q).reduce(0) { |acc, (r, s)| acc + (r - s).abs }
end
