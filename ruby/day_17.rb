#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'
require_relative 'utils'

def part_one(program)
  camera = Intcode.new(program).execute

  view = camera.outputs.map(&:chr)
  puts view.join

  scores = []
  screen_by_row = view.join.split("\n")
  screen_by_row.length.times do |r|
    screen_by_row[0].length.times do |c|
      next unless [screen_by_row[r][c] == '#',
                   screen_by_row[r][c] == (screen_by_row[r + 1] && screen_by_row[r + 1][c]),
                   screen_by_row[r][c] == (screen_by_row[r - 1] && screen_by_row[r - 1][c]),
                   screen_by_row[r][c] == screen_by_row[r][c + 1],
                   screen_by_row[r][c] == screen_by_row[r][c - 1]].all?

      scores << r * c
    end
  end
  scores.sum
end

def as_ascii(commands)
  commands.join(',').each_char.map { |c| c.is_a?(Integer) ? c : c.ord } + ["\n".ord]
end

def part_two(program)
  # MAIN
  main = %w[A B C B]
  # A
  #a = [5]
  a = ['L', 8, 'R', 10, 'L', 'L']
  # B
  b = ['R', 8, 'R', 8]
  # C
  c = ['L', 12, 'R', 8]
  # VIDEO
  video = ['n']

  program[0] = 2
  inputs = [main, a, b, c, video].map { |c| as_ascii(c) }.flatten
  puts inputs.to_s
  camera = Intcode.new(program, inputs)

  loop do
    camera.execute(true)
    break if camera.outputs[-1] > 256 || camera.halted

    print camera.outputs[-1].chr
  end

  camera.outputs[-1]
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/17'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_17.txt'

  #puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
