#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

def read_reactions
  reactions = {}
  (Pathname(__dir__).parent / 'data' / 'day_14.txt').readlines.map do |line|
    *inputs, output = line.sub('=>', ',').split(',').map { |x| x.split(' ') }
    reactions[output[1]] = [
      output[0].to_i,
      inputs.map { |qnt, name| [name, qnt.to_i] }.to_h,
    ]
  end
  reactions
end

def part_one(reactions)
  needed = Hash.new(0)
  needed['FUEL'] = 1
  spare = Hash.new(0)

  while needed.keys != ['ORE']
    needed.keys.each do |reagent|
      qnt = needed[reagent]
      reaction = reactions[reagent]
      next if reaction.nil?

      spare_to_use = [qnt, spare[reagent] || 0].min
      qnt -= spare_to_use
      spare[reagent] = [spare[reagent] - spare_to_use, 0].min

      reagent_made_per, inputs = reaction
      num_times_to_run = (qnt.to_f / reagent_made_per).ceil

      inputs.each do |input, amount|
        needed[input] += amount * num_times_to_run
      end
      spare[reagent] += (reagent_made_per * num_times_to_run) - qnt
      needed.delete(reagent)
    end
  end

  needed['ORE']
end

def part_two(reactions)
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/14'

  reactions = read_reactions

  puts "Part One: #{part_one(reactions)}"
  puts "Part Two: #{part_two(reactions)}"
end
