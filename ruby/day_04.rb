# frozen_string_literal: true

require 'set'

require_relative 'utils'

def monotonically_increasing?(p)
  p.chars.sort == p.chars
end

def at_least_two_characters_match?(p)
  p.chars.tally.values.any? { |v| v >= 2 }
end

def exactly_two_characters_match?(p)
  p.chars.tally.values.any? { |v| v == 2 }
end

# NB: the criteria that the matching digits are NEXT TO EACH OTHER is entirely implicit!
# If the string is monotonic, and some digits match, those matching digits must be next to each other!

def part_one(passwords)
  (passwords.select do |p|
    monotonically_increasing?(p) && at_least_two_characters_match?(p)
  end).length
end

def part_two(passwords)
  (passwords.select do |p|
    monotonically_increasing?(p) && exactly_two_characters_match?(p)
  end).length
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/4'

  passwords = '134792'..'675810'
  puts "Part One: #{part_one(passwords)}"
  puts "Part Two: #{part_two(passwords)}"
end
