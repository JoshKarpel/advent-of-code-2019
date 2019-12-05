# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'

def part_one(program)
  program[1, 2] = [12, 2]
  program, = execute(program)
  program.first
end

def part_two(program, target)
  noun, verb = (0..99).to_a.permutation(2) do |noun_and_verb|
    test = program.dup
    test[1, 2] = noun_and_verb
    p, = execute test
    break noun_and_verb if p.first == target
  end
  (100 * noun) + verb
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/2'

  program = read_program(Pathname(__dir__).parent / 'data' / 'day_02.txt')

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program, 19_690_720)}"
end
