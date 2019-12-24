#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'utils'

def read_shuffles(path)
  path.readlines.map(&:chomp)
end

NUM_CARDS = 10_007

def part_one(shuffles)
  deck = (0...NUM_CARDS).to_a

  shuffles.each do |shuffle|
    if shuffle =~ /deal into new stack/
      deck.reverse!
    elsif !(match = /cut (-?\d+)/.match(shuffle)).nil?
      deck.rotate!(count = match[1].to_i)
    elsif !(match = /deal with increment (\d+)/.match(shuffle)).nil?
      increment = match[1].to_i
      new_deck = Array.new(NUM_CARDS)
      target = 0
      deck.each do |card|
        new_deck[target] = card
        target += increment
        target %= NUM_CARDS
      end
      deck = new_deck
    end
  end

  deck.find_index { |card| card == 2019 }
end

def part_two(shuffles)

end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/22'

  shuffles = read_shuffles Pathname(__dir__).parent / 'data' / 'day_22.txt'

  puts "Part One: #{part_one(shuffles)}"
  puts "Part Two: #{part_two(shuffles)}"
end
