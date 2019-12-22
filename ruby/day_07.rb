#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'

require_relative 'intcode'

def part_one(program)
  outputs = (0..4).to_a.permutation.map do |phases|
    input = 0
    phases.each do |phase|
      input = Intcode.new(program, [phase, input]).execute!.outputs.first
    end
    input # the last input goes to the thrusters
  end
  outputs.max
end

def part_two(program)
  outputs = (5..9).to_a.permutation.map do |phases|
    input = 0
    programs = phases.map { |phase| Intcode.new(program, [phase]) }
    programs.each.cycle do |prog|
      prog.inputs << input
      input = prog.execute!(stop_on_output: true).outputs.last
      break if (prog == programs.last) && prog.halted
    end
    input # the last input goes to the thrusters
  end
  outputs.max
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/7'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_07.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
