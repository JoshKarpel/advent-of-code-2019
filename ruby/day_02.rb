#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'

def part_one(program)
  program[1] = 12
  program[2] = 2
  Intcode.new(program).execute!.memory[0]
end

def part_two(program, target)
  noun, verb = (0..99).to_a.permutation(2) do |noun, verb|
    test = program.dup
    program[1] = noun
    program[2] = verb
    break noun, verb if Intcode.new(test).execute!.memory[0] == target
  end
  (100 * noun) + verb
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/2'

  program = read_program(Pathname(__dir__).parent / 'data' / 'day_02.txt')

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program, 19_690_720)}"
end
