#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'set'

def read_asteroids
  (Pathname(__dir__).parent / 'data' / 'day_10.txt').readlines.map(&:chomp)
end

def angle(p, q)
  dx = p[0] - q[0]
  dy = p[1] - q[1]
  if dx.zero?
    return :up if dy.positive?
    return :down if dy.negative?
  end
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
  most_angles.length
end

def part_two(asteroids)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/10'

  asteroids = read_asteroids

  puts "Part One: #{part_one(asteroids)}"
  puts "Part Two: #{part_two(asteroids)}"
end
