#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'

def part_one(program)
  Intcode.new(program, [1]).execute!.outputs.last
end

def part_two(program)
  Intcode.new(program, [2]).execute!.outputs.last
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/9'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_09.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
