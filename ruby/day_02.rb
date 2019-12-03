# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'

def read_program
  (Pathname(__dir__).parent / 'data' / 'day_02.txt').read.split(',').map(&:to_i)
end

def part_one(program)
  program[1] = 12
  program[2] = 2
  executed = execute(program)
  executed[0]
end

def find_valid_program(program, target)
  (0..99).each do |noun|
    (0..99).each do |verb|
      test = program.dup
      test[1] = noun
      test[2] = verb
      executed = execute(test)
      return [noun, verb] if executed[0] == target
    end
  end
end

def part_two(program, target)
  noun, verb = find_valid_program(program, target)
  (100 * noun) + verb
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/2'

  program = read_program
  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program, 19_690_720)}"
end
