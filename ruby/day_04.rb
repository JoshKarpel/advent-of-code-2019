# frozen_string_literal: true

def monotonically_increasing(x)
  (1...x.length).each do |i|
    return false unless x[i] >= x[i - 1]
  end
end

def two_adjacent_same(x)
  (0...x.length - 1).each do |i|
    return true if x[i] == x[i + 1]
  end
  false
end

def part_one(range)
  (range.select { |r| two_adjacent_same(r) && monotonically_increasing(r) }).length
end

def exactly_two_adjacent_same(x)
  (0...x.length - 1).each do |i|
    return true if x[i] == x[i + 1] && x[i - 1] != x[i] && x[i + 2] != x[i + 1]
  end
  false
end

def part_two(range)
  (range.select { |r| exactly_two_adjacent_same(r) && monotonically_increasing(r) }).length
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/4'

  range = '134792'..'675810'
  puts "Part One: #{part_one(range)}"
  puts "Part Two: #{part_two(range)}"
end
