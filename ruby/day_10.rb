#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'set'

require_relative 'utils'

def read_asteroids
  (Pathname(__dir__).parent / 'data' / 'day_10.txt').readlines.map(&:chomp)
end

def angle(p, q)
  dx = p[0] - q[0]
  dy = p[1] - q[1]
  #if dx.zero?
  #  return [1, 0] if dy.positive?
  #  return [-1, 0] if dy.negative?
  #end
  lcm = dy.gcd dx
  return [dy, dx] if lcm.zero?

  [dy / lcm, dx / lcm]
end

def part_one(asteroids)
  cols = asteroids.length
  rows = asteroids[0].length

  angles = Hash.new { |h, k| h[k] = Set.new }
  rows.times do |x|
    cols.times do |y|
      next if asteroids[y][x] == '.'

      rows.times do |x2|
        cols.times do |y2|
          next if asteroids[y2][x2] == '.' || (x == x2 && y == y2)

          angles[[x, y]] << angle([x, y], [x2, y2])
        end
      end
    end
  end
  _, most_angles = angles.max_by { |_, a| a.length }
  puts _.to_s
  most_angles.length
end

def part_two(asteroids, laser)
  cols = asteroids.length
  rows = asteroids[0].length

  angles = Hash.new { |h, k| h[k] = [] }
  rows.times do |x2|
    cols.times do |y2|
      next if asteroids[y2][x2] == '.' || (laser[0] == x2 && laser[1] == y2)

      angles[angle(laser, [x2, y2])] << [x2, y2]
    end
  end

  ordered_angles = angles.map { |a, k| [(Math.atan2(*a) - (Math::PI / 2)), k.sort_by { |z| manhattan(z, laser) }] }.sort_by! { |a, _| a }

  first_angle_idx = ordered_angles.find_index { |a, _| a.positive? }
  ordered_angles = ordered_angles[(first_angle_idx - 1)..-1] + ordered_angles[0...first_angle_idx - 1]

  ordered_asteroids = []
  while ordered_angles.map(&:last).map(&:length).any?(&:positive?)
    ordered_angles.each do |_k, v|
      next if v.length.zero?

      ordered_asteroids << v.shift
    end
  end

  x, y = ordered_asteroids[199]
  (x * 100) + y
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/10'

  asteroids = read_asteroids

  puts "Part One: #{part_one(asteroids)}"
  puts "Part Two: #{part_two(asteroids, [11, 11])}"
end
