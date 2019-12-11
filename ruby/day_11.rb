#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'matrix'

require_relative 'intcode'

FACING = {
  0 => -1i,
  1 => +1i,
}.freeze
MOVE = {
  1 + 0i => Vector[1, 0],
  1i => Vector[0, 1],
  -1 + 0i => Vector[-1, 0],
  -1i => Vector[0, -1],
}.freeze

def part_one(program)
  brain = Intcode.new(program)
  hull = Hash.new(0)
  position = Vector[0, 0]
  facing = 1i

  loop do
    brain.inputs << hull[position]

    brain.execute(stop_on_output: true)
    break if brain.halted

    brain.execute(stop_on_output: true)
    color, turn = brain.outputs.shift(2)

    hull[position] = color
    facing *= FACING[turn]
    position += MOVE[facing]
  end

  hull.keys.length
end

def part_two(program)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/9'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_11.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
