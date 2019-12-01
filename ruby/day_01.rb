# frozen_string_literal: true

require 'pathname'

def read_data
  (Pathname(__dir__).parent / 'data' / 'day_01.txt').readlines.map(&:to_i)
end

def calculate_module_fuel(mass)
  (mass / 3).truncate - 2
end

def part_one(data)
  (data.map { |m| calculate_module_fuel(m) }).sum
end

def calculate_total_module_fuel(mass)
  fuels = [calculate_module_fuel(mass)]
  loop do
    extra_fuel = calculate_module_fuel(fuels[-1])
    extra_fuel.positive? ? fuels << extra_fuel : break
  end
  fuels.sum
end

def part_two(data)
  (data.map { |m| calculate_total_module_fuel(m) }).sum
end

if $PROGRAM_NAME == __FILE__
  data = read_data
  puts "Part One: #{part_one(data)}"
  puts "Part Two: #{part_two(data)}"
end
