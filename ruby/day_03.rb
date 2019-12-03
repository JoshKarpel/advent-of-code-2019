# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'

def read_wire_instructions
  (Pathname(__dir__).parent / 'data' / 'day_03.txt').readlines.map do |line|
    line.split(',').map { |instruction| [instruction[0], instruction[1..-1].to_i] }
  end
end

def manhattan_distance(p, q)
  p.zip(q).reduce(0) { |acc, (r, s)| acc + (r - s).abs }
end

def part_one(wire_instructions)
  trajectories = wire_instructions.map do |instructions|
    position = [0, 0]
    trajectory = [position]

    instructions.each do |direction, distance|
      case direction
        when 'U'
          position[1] += distance
        when 'D'
          position[1] -= distance
        when 'R'
          position[0] += distance
        when 'L'
          position[0] -= distance
      end
      trajectory << position.dup
    end

    trajectory
  end

  intersections = []
  trajectory_a, trajectory_b = trajectories
  (0...trajectory_a.length - 1).each do |idx_a|
    a_1, a_2 = trajectory_a[idx_a, 2]
    (0...trajectory_b.length - 1).each do |idx_b|
      b_1, b_2 = trajectory_b[idx_b, 2]
      if a_1[0] == a_2[0] && b_1[1] == b_2[1] # a vertical, b horizontal
        if b_1[1].between?(*[a_1[1], a_2[1]].sort!) && a_1[0].between?(*[b_1[0], b_2[0]].sort!)
          intersections << [a_1[0], b_1[1]]
        end
      elsif a_1[1] == a_2[1] && b_1[0] == b_2[0] # a horizontal, b vertical
        if a_1[1].between?(*[b_1[1], b_2[1]].sort!) && b_1[0].between?(*[a_1[0], a_2[0]].sort!)
          intersections << [b_1[0], a_1[1]]
        end
      end
    end
  end

  (intersections.map { |intersection| manhattan_distance(intersection, [0, 0]) }).min
end

def part_two(instructions)
end

if $PROGRAM_NAME == __FILE__
  wire_instructions = read_wire_instructions
  puts "Part One: #{part_one(wire_instructions)}"
  puts "Part Two: #{part_two(wire_instructions)}"
end
