# frozen_string_literal: true

require 'pathname'

require_relative 'utils'

def read_wire_instructions
  (Pathname(__dir__).parent / 'data' / 'day_03.txt').readlines.map do |line|
    line.split(',').map { |instruction| [instruction[0].to_sym, instruction[1..-1].to_i] }
  end
end

DIRECTION_TO_IDX_AND_SIGN = {
  U: [1, 1],
  D: [1, -1],
  R: [0, 1],
  L: [0, -1],
}.freeze

def path(instructions)
  path = []
  position = [0, 0]
  delay = 0

  instructions.each do |direction, distance|
    idx, sign = DIRECTION_TO_IDX_AND_SIGN[direction]
    distance.times do
      position[idx] += sign
      delay += 1

      path << position.dup
    end
  end

  path
end

def intersections(paths)
  (paths.reduce { |acc, path| acc & path }) - [[0, 0]]
end

def part_one(paths)
  (intersections(paths).map { |intersection| manhattan(intersection) }).min
end

def part_two(paths)
  (intersections(paths).map { |intersection| (paths.map { |path| path.index(intersection) }).sum }).min
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/3'

  paths = read_wire_instructions.map { |x| path(x) }
  puts "Part One: #{part_one(paths)}"
  puts "Part Two: #{part_two(paths)}"
end
