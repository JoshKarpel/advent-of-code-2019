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
  orbits.keys.reduce(0) do |acc, body|
    acc + path_to_com(orbits, body).length - 1 # -1 because depth starts at 0
  end
end

def part_two(orbits)
  up_from_you = path_to_com(orbits, 'YOU')
  up_from_san = path_to_com(orbits, 'SAN')

  san_path_set = Set.new(up_from_san)

  you_idx = up_from_you.find_index { |x| san_path_set.include? x }

  san_idx = up_from_san.find_index(up_from_you[you_idx])

  you_idx + san_idx - 2 # -2 because we want the edges, not the nodes
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/6'

  orbits = child_to_parent
  puts "Part One: #{part_one(orbits)}"
  puts "Part Two: #{part_two(orbits)}"
end
