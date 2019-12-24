#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'utils'

def read_shuffles(path)
  path.readlines.map(&:chomp)
end

def track_position(shuffles, position, num_cards)
  shuffles.each do |shuffle|
    if shuffle =~ /deal into new stack/
      position = num_cards - position - 1
    elsif !(match = /cut (-?\d+)/.match(shuffle)).nil?
      position -= match[1].to_i
    elsif !(match = /deal with increment (\d+)/.match(shuffle)).nil?
      position *= match[1].to_i
    end
    position %= num_cards
  end

  position
end

def part_one(shuffles)
  track_position(shuffles, 2019, 10_007)
end

def part_two(shuffles)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/22'

  shuffles = read_shuffles Pathname(__dir__).parent / 'data' / 'day_22.txt'

  puts "Part One: #{part_one(shuffles)}"
  puts "Part Two: #{part_two(shuffles)}"
end
