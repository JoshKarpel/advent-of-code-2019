#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'matrix'

def read_moon_positions
  (Pathname(__dir__).parent / 'data' / 'day_12.txt').readlines.map(&:chomp).map do |line|
    Vector.elements(/<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/.match(line)[1..3].map(&:to_i))
  end
end

class Moon
  attr_accessor :position, :velocity

  def initialize(position)
    @position = position.dup
    @velocity = Vector.zero(3)
  end

  def pulled_by(moon)
    dr = @position - moon.position
    @velocity -= dr.map { |e| e.zero? ? 0 : e / e.abs }
  end

  def move
    @position += @velocity
  end

  def energy
    @position.map(&:abs).sum * @velocity.map(&:abs).sum
  end

  def to_s
    "r=#{@position} v=#{@velocity}"
  end
end

def part_one(moon_positions)
  moons = moon_positions.map do |x|
    Moon.new(x)
  end

  1000.times do
    moons.permutation(2) do |a, b|
      a.pulled_by b
    end

    moons.each(&:move)
  end

  moons.map(&:energy).sum
end

def part_two(moon_positions)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/12'

  moon_positions = read_moon_positions

  puts "Part One: #{part_one(moon_positions)}"
  puts "Part Two: #{part_two(moon_positions)}"
end
