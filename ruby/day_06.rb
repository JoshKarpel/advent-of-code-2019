#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'set'

def read_orbits
  (Pathname(__dir__).parent / 'data' / 'day_06.txt').readlines.map(&:chomp)
end

def child_to_parent
  orbits = {}
  read_orbits.each do |line|
    parent, child = line.split ')'
    orbits[child] = parent
  end
  orbits
end

def path_to_com(orbits, body)
  path = [body]
  path << orbits[path[-1]] while path.last != 'COM'
  path
end

def part_one(orbits)
  # -1 because we don't want to include the starting body
  (orbits.keys.map { |body| path_to_com(orbits, body).length - 1 }).sum
end

def part_two(orbits)
  up_from_you = Set.new(path_to_com(orbits, 'YOU'))
  up_from_san = Set.new(path_to_com(orbits, 'SAN'))

  # all of the elements from both sets that are not in the other
  unordered_path = up_from_you ^ up_from_san

  unordered_path.length - 2 # -2 because we want to count the edges, not the nodes
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/6'

  orbits = child_to_parent

  puts "Part One: #{part_one(orbits)}"
  puts "Part Two: #{part_two(orbits)}"
end
