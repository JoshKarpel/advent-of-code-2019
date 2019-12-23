#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'
require_relative 'utils'

def part_one(program)
  camera = Intcode.new(program).execute!

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

def find_path(program)
  camera = Intcode.new(program).execute!

  view = camera.outputs.map(&:chr)
  puts view.join

  screen_by_row = view.join.split("\n")

  start_r, start_c = find_start(screen_by_row)

  cmds = [0]
  total = view.tally['#']
  puts total
  visited = 1
  while visited < total

  end

  puts [start_r, start_c].to_s
end

def find_start(screen_by_row)
  screen_by_row.length.times do |r|
    screen_by_row[0].length.times do |c|
      return [r, c] if screen_by_row[r][c] == '^'
    end
  end
end

def as_ascii(commands)
  commands.join(',').each_char.map { |c| c.is_a?(Integer) ? c : c.ord } + ["\n".ord]
end

def part_two(program)
  find_path(program)

end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/17'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_17.txt'

  #puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
