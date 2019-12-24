#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'matrix'
require 'set'

require_relative 'utils'

def read_state(path)
  Matrix.rows(path.readlines.map(&:chomp).map { |row| row.each_char.map { |e| e == '#' ? 1 : 0 } })
end

def display(state)
  lines = []
  state.to_a.each do |row|
    lines << row.join('')
  end
  puts lines.join("\n")
end

def evolve(state)
  Matrix.build(state.row_count, state.column_count) do |row, col|
    e = state[row, col]
    adj = [
      state[row + 1, col],
      (row - 1) >= 0 ? state[row - 1, col] : nil,
      state[row, col + 1],
      (col - 1) >= 0 ? state[row, col - 1] : nil,
    ]
    num_adj = adj.map { |e| e || 0 }.sum

    if e == 1 && num_adj != 1
      0
    elsif e == 0 && (num_adj == 1 || num_adj == 2)
      1
    else
      e
    end
  end
end

def biodiversity(state)
  state.map.with_index.reduce(0) { |acc, (e, idx)| acc + e * (2 ** idx) }
end

def part_one(state)
  previous_states = Set[state]

  first_repeat = loop do
    state = evolve(state)
    break state if previous_states.add?(state.dup).nil?
  end

  biodiversity first_repeat
end

def part_two(state)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/24'

  state = read_state Pathname(__dir__).parent / 'data' / 'day_24.txt'

  puts "Part One: #{part_one(state)}"
  puts "Part Two: #{part_two(state)}"
end
