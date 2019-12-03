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
  U: [1, 1],
  D: [1, -1],
  R: [0, 1],
  L: [0, -1],
}.freeze

def calculate_trajectory_and_delays(instructions)
  delay = 0
  delays = {}
  position = [0, 0]
  trajectory = [position.dup]

  instructions.each do |direction, distance|
    idx, sign = DIRECTION_TO_IDX_AND_SIGN[direction]
    distance.times do
      position[idx] += sign
      delay += 1

      p = position.dup
      trajectory << p
      delays[p] ||= delay
    end
  end

  [trajectory, delays]
end

def part_one(intersections)
  (intersections.map { |intersection| manhattan_distance(intersection, [0, 0]) }).min
end

def part_two(intersections, delays)
  (intersections.map { |intersection| (delays.map { |d| d[intersection] }).sum }).min
end

if $PROGRAM_NAME == __FILE__
  wire_1_instructions, wire_2_instructions = read_wire_instructions
  wire_1_trajectory, wire_1_delays = calculate_trajectory_and_delays wire_1_instructions
  wire_2_trajectory, wire_2_delays = calculate_trajectory_and_delays wire_2_instructions

  intersections = (wire_1_trajectory & wire_2_trajectory) - [[0, 0]]

  puts "Part One: #{part_one(intersections)}"
  puts "Part Two: #{part_two(intersections, [wire_1_delays, wire_2_delays])}"
end
