#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'utils'

def read_signal(path)
  path.read.chomp.split('').map(&:to_i)
end

def last_digit(number)
  number.to_s[-1].to_i
end

def pattern(index)
  position = index + 1
  (Array.new(position, 0) + Array.new(position, 1) + Array.new(position, 0) + Array.new(position, -1)).cycle
end

def part_one(signal)
  100.times do
    signal = signal.each_with_index.map do |_, index|
      p = pattern(index).take(signal.length + 1)[1..-1]
      last_digit(signal.zip(p).reduce(0) do |acc, sp|
        s, p = sp
        acc + (s * p)
      end)
    end
  end
  signal.join[0, 8]
end

def part_two(signal)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/16'

  signal = read_signal Pathname(__dir__).parent / 'data' / 'day_16.txt'

  puts "Part One: #{part_one(signal)}"
  puts "Part Two: #{part_two(signal)}"
end
