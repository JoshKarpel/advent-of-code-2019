# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'

def read_codes
  (Pathname(__dir__).parent / 'data' / 'day_02.txt').read.split(',').map(&:to_i)
end

def part_one(codes)
  codes[1] = 12
  codes[2] = 2
  executed = execute(codes)
  executed[0]
end

def find_valid_program(codes, target)
  (0..99).each do |noun|
    (0..99).each do |verb|
      test = codes.dup
      test[1] = noun
      test[2] = verb
      executed = execute(test)
      return [noun, verb] if executed[0] == target
    end
  end
end

def part_two(codes, target)
  noun, verb = find_valid_program(codes, target)
  (100 * noun) + verb
end

if $PROGRAM_NAME == __FILE__
  codes = read_codes
  puts "Part One: #{part_one(codes)}"
  puts "Part Two: #{part_two(codes, 19_690_720)}"
end
