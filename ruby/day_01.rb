# frozen_string_literal: true

require 'pathname'

def read_module_masses
  (Pathname(__dir__).parent / 'data' / 'day_01.txt').readlines.map(&:to_i)
end

def calculate_module_fuel(mass)
  (mass / 3).truncate - 2
end

def part_one(masses)
  (masses.map { |m| calculate_module_fuel(m) }).sum
end

def calculate_total_module_fuel(mass)
  # this is the module itself
  extra_fuel = calculate_module_fuel(mass)
  fuel = extra_fuel

  # extra fuel for the extra fuel
  while (extra_fuel = calculate_module_fuel(extra_fuel)).positive?
    fuel += extra_fuel
  end

  fuel
end

def part_two(masses)
  (masses.map { |m| calculate_total_module_fuel(m) }).sum
end

if $PROGRAM_NAME == __FILE__
  masses = read_module_masses
  puts "Part One: #{part_one(masses)}"
  puts "Part Two: #{part_two(masses)}"
end
