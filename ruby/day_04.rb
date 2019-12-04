# frozen_string_literal: true

require 'pathname'

require_relative 'utils'

def read_
  (Pathname(__dir__).parent / 'data' / 'day_04.txt')
end

def two_adjacent_same(x)
  (0...x.length - 1).each do |i|
    return true if x[i] == x[i + 1]
  end
  false
end

def monotonically_increasing(x)
  (1...x.length).each do |i|
    return false unless x[i] >= x[i - 1]
  end
end

def part_one(range)
  valid = range.select do |r|
    two_adjacent_same(r) && monotonically_increasing(r)
  end
  valid.length
end

def part_two(range)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/4'

  range = '134792'..'675810'
  puts "Part One: #{part_one(range)}"
  puts "Part Two: #{part_two(range)}"
end
