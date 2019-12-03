# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'

def read_wire_instructions
  (Pathname(__dir__).parent / 'data' / 'day_03.txt').readlines.map do |line|
    line.split(',').map { |instruction| [instruction[0].to_sym, instruction[1..-1].to_i] }
  end
end

def manhattan_distance(p, q)
  p.zip(q).reduce(0) { |acc, (r, s)| acc + (r - s).abs }
end

DIRECTION_TO_IDX_AND_SIGN = {
  :U => [1, 1],
  :D => [1, -1],
  :R => [0, 1],
  :L => [0, -1]
}.freeze

def part_one(wire_instructions)
  trajectories = wire_instructions.map do |instructions|
    position = [0, 0]
    trajectory = [position.dup]

    instructions.each do |direction, distance|
      idx, sign = DIRECTION_TO_IDX_AND_SIGN[direction]
      distance.times do
        position[idx] += sign
        trajectory << position.dup
      end
    end

    trajectory
  end

  intersections = (trajectories[1] & trajectories[0]) - [[0, 0]]

  (intersections.map { |intersection| manhattan_distance(intersection, [0, 0]) }).min
end

def part_two(instructions)
end

if $PROGRAM_NAME == __FILE__
  wire_instructions = read_wire_instructions
  puts "Part One: #{part_one(wire_instructions)}"
  puts "Part Two: #{part_two(wire_instructions)}"
end
