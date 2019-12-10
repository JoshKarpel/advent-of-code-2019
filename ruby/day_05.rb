#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'

def part_one(program)
  Intcode.new(program, [1]).execute.outputs.last
end

def part_two(program)
  Intcode.new(program, [5]).execute.outputs.last
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/5'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_05.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
