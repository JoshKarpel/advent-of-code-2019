#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'
require_relative 'utils'

def part_one(program)
  screen = Intcode.new program
  screen.execute.outputs.each_slice(3).map(&:last).tally[2]
end

def part_two(program)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/13'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_13.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
