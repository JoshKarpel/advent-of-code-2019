# frozen_string_literal: true

require 'pathname'

require_relative 'intcode2'

def part_one(program)
  program, inputs, outputs = execute(program, [1])
  outputs.last
end

def part_two(program)
  program, inputs, outputs = execute(program, [5])
  outputs.last
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/5'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_05.txt'
  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
