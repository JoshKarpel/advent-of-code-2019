#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'set'

require_relative 'intcode'
require_relative 'utils'

EAST = 1 + 0i
WEST = -1 + 0i
SOUTH = 0 - 1i
NORTH = 0 + 1i
HIT_WALL = 0
MOVED = 1
OXYGEN = 2

MOVE_CMDS = {
  NORTH => 1,
  SOUTH => 2,
  WEST => 3,
  EAST => 4,
}.freeze

CORRIDOR = ' '
DROID = 'D'
WALL = '#'
UNKNOWN = '~'

def draw(m)
  min_x = m.keys.map(&:first).min
  max_x = m.keys.map(&:first).max
  min_y = m.keys.map(&:last).min
  max_y = m.keys.map(&:last).max

  # loop in reverse because it turns out the image drawn from the top left,
  # so all the coordinates are negative
  msg = []
  (min_y..(max_y + 1)).reverse_each do |y|
    (min_x..(max_x + 1)).each do |x|
      msg << m[[x, y]]
    end
    msg << "\n"
  end
  msg.join
end

def complex_to_coord(c)
  [c.real, c.imag]
end

def explore(program, callback)
  droid = Intcode.new(program)
  start = 0 + 0i
  position = 0 + 0i

  map = Hash.new('~')
  oxygen = nil
  dir = NORTH

  loop do
    droid.inputs << MOVE_CMDS[dir]
    droid.execute!(true)
    output = droid.outputs.shift

    if output == HIT_WALL
      map[complex_to_coord(position + dir)] = WALL
      dir *= -1i
    else
      map[complex_to_coord(position)] = CORRIDOR
      position += dir
      dir *= 1i
      if output == OXYGEN
        # when we have visited the oxygen twice, we have explored the whole maze,
        # and should execute the callback to find the answer
        return send(callback, map, oxygen, start) unless oxygen.nil?

        oxygen = position.dup
      end
    end

    map[complex_to_coord(position)] = DROID
    map[complex_to_coord(oxygen)] = 'X' unless oxygen.nil?

    puts "moved #{dir} output #{output} | position #{position}".ljust(80)
    d = draw(map)
    puts d
    puts "\033[#{d.split("\n").length + 2}A\r"
  end
end

def backtrack(map, oxygen, start)
  puts 'Backtracking to start...'.ljust(80)
  search_map = map.map { |k, v| [k[0] + 1i * k[1], v] }.to_h
  search = Set[oxygen]
  1.step do |depth|
    search.dup.each do |elem|
      MOVE_CMDS.keys.each do |dir|
        search << elem + dir if search_map[elem + dir] == CORRIDOR
      end
    end

    search.each do |coord|
      map[complex_to_coord(coord)] = 'S'
    end

    d = draw(map)
    puts d
    return depth if search.include?(start)

    puts "\033[#{d.split("\n").length + 1}A\r"
  end
end

def fill(map, oxygen, _start)
  puts 'Filling with oxygen...'.ljust(80)
  search_map = map.map { |k, v| [k[0] + 1i * k[1], v] }.to_h
  search = Set[oxygen]
  prev_filled = 0
  1.step do |depth|
    search.dup.each do |elem|
      MOVE_CMDS.keys.each do |dir|
        search << elem + dir if search_map[elem + dir] == CORRIDOR
      end
    end

    search.each do |coord|
      map[complex_to_coord(coord)] = 'O'
    end

    d = draw(map)
    puts d

    return depth - 1 if search.length == prev_filled # the previous step was the one where it became filled

    prev_filled = search.length

    puts "\033[#{d.split("\n").length + 1}A\r"
  end
end

def part_one(program)
  explore(program, :backtrack)
end

def part_two(program)
  explore(program, :fill)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/15'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_15.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
