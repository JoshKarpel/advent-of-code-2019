# frozen_string_literal: true

def monotonically_increasing(p)
  p.chars.each_cons(2).all? { |a, b| b.nil? || a <= b }
end

def two_adjacent_characters_match(p)
  p.chars.each_cons(2).any? { |a, b| a == b }
end

def part_one(passwords)
  (passwords.select do |p|
    two_adjacent_characters_match(p) && monotonically_increasing(p)
  end).length
end

def exactly_two_adjacent_characters_match(p)
  # This only works in conjunction with the other condition!
  # Otherwise, p[i - 1] != p[i] checks that the start and end of the string are the same when i = 0.
  # But that can't be the case if you also only want two characters to match, because it would imply
  # that the whole string is just that character.
  # Thus, this hack!
  (0...p.length - 1).each do |i|
    return true if p[i] == p[i + 1] && p[i - 1] != p[i] && p[i + 2] != p[i + 1]
  end
  false
end

def part_two(passwords)
  (passwords.select do |p|
    exactly_two_adjacent_characters_match(p) && monotonically_increasing(p)
  end).length
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/4'

  passwords = '134792'..'675810'
  puts "Part One: #{part_one(passwords)}"
  puts "Part Two: #{part_two(passwords)}"
end
