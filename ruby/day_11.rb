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
  0 + 1i => Vector[0, 1],
  -1 + 0i => Vector[-1, 0],
  0 - 1i => Vector[0, -1],
}.freeze

def paint_hull(program, starting_color)
  brain = Intcode.new(program)
  hull = Hash.new(0)
  position = Vector[0, 0]
  hull[position] = starting_color
  facing = 1i

  loop do
    brain.inputs << hull[position]

    brain.execute(stop_on_output: true)
    break if brain.halted

    brain.execute(stop_on_output: true)
    color, turn = brain.outputs.shift(2)

    hull[position] = color
    facing *= FACING[turn]
    position -= MOVE[facing] # TODO: inverted moves for some reason?
  end

  hull.map { |k, v| [k.to_a, v] }.to_h
end

def part_one(program)
  paint_hull(program, 0).keys.length
end

CHAR = {
  0 => '░',
  1 => '█',
}.freeze

def part_two(program)
  hull = paint_hull(program, 1)
  min_x = hull.keys.map(&:first).min
  max_x = hull.keys.map(&:first).max
  min_y = hull.keys.map(&:last).min
  max_y = hull.keys.map(&:last).max

  msg = []
  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      msg << CHAR[hull[[x, y]] || 0]
    end
    msg << "\n"
  end
  "\n" + msg.join
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/9'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_11.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
