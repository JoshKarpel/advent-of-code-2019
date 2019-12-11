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
  gcd = dy.gcd dx
  return [dy, dx] if gcd.zero?

  [dy / gcd, dx / gcd]
end

def asteroid_positions(asteroids)
  cols = asteroids.length
  rows = asteroids[0].length

  positions = block_given? ? nil : []
  rows.times do |x|
    cols.times do |y|
      next if asteroids[y][x] == '.'

      if block_given?
        yield [x, y]
      else
        positions << [x, y]
      end
    end
  end
  positions
end

def visible_asteroids(asteroids, position)
  asteroids_by_angle = Hash.new { |h, k| h[k] = [] }

  asteroid_positions(asteroids) do |target|
    next if position == target

    asteroids_by_angle[angle(position, target)] << target
  end

  asteroids_by_angle.each do |_, v|
    v.sort_by! { |e| manhattan(e, position) }
  end

  asteroids_by_angle
end

def find_best_location(asteroids)
  asteroid_positions(asteroids).max_by do |monitor|
    visible_asteroids(asteroids, monitor).keys.length
  end
end

def part_one(asteroids)
  best_location = find_best_location(asteroids)
  visible_asteroids(asteroids, best_location).keys.length
end

def part_two(asteroids)
  laser = find_best_location(asteroids)

  asteroids_by_angle = visible_asteroids(asteroids, laser).map do |a, k|
    [Math.atan2(*a), k]
  end
  asteroids_by_angle.sort_by!(&:first)
  new_start = asteroids_by_angle.map(&:first).find_index { |angle| angle >= Math::PI / 2 }
  roids = asteroids_by_angle.map(&:last).rotate(new_start)

  destruction_order = []
  while roids.map(&:length).any?(&:positive?)
    roids.filter { |r| !r.length.zero? }.each do |r|
      destruction_order << r.shift
    end
  end

  x, y = destruction_order[199]
  (x * 100) + y
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/10'

  asteroids = read_asteroids

  puts "Part One: #{part_one(asteroids)}"
  puts "Part Two: #{part_two(asteroids)}"
end
