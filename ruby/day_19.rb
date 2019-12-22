#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'
require_relative 'utils'

def in_beam?(x, y, program)
  Intcode.new(program, [x, y]).execute!.outputs.first == 1
end

def part_one(program)
  (0..49).to_a.repeated_permutation(2).map do |x, y|
    in_beam?(x, y, program)
  end.count(true)
end

def display(x, y, w, program)
  lines = []
  (y..y + w).step do |y|
    line = []
    (x..x + w).step do |x|
      line << if in_beam?(x, y, program)
        '#'
      else
        '.'
      end
    end
    lines << line.join('')
  end
  puts lines.join("\n")
end

def part_two(program)
  x = 0
  w = 99 # advance by 99 to get 100 in a row
  0.step do |y|
    x += 1 until in_beam?(x, y, program)

    return (x * 10_000) + (y - w) if in_beam?(x + w, y - w, program)
  end
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/19'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_19.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
