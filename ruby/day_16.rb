#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'utils'

def read_signal(path)
  path.read.chomp.split('').map(&:to_i)
end

def last_digit(number)
  number.abs % 10
end

def pattern(index)
  position = index + 1
  [0, 1, 0, -1].map { |v| Array.new(position, v) }.sum([]).cycle
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
  offset = signal[0, 7].join.to_i
  # the offset is far past the midpoint, so we can just do the array from there onwards
  signal = signal.cycle(10_000).to_a[offset..-1]
  100.times do
    sum = signal.sum
    signal = signal.map do |s|
      sum -= s
      sum + s
    end
    signal = signal.map { |s| last_digit(s) }
  end
  signal.join[0, 8]
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/16'

  signal = read_signal Pathname(__dir__).parent / 'data' / 'day_16.txt'

  puts "Part One: #{part_one(signal)}"
  puts "Part Two: #{part_two(signal)}"
end
