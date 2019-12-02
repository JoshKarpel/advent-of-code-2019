# frozen_string_literal: true

require 'pathname'

def read_codes
  (Pathname(__dir__).parent / 'data' / 'day_02.txt').read.split(',').map(&:to_i)
end

def execute(codes)
  executing = codes.dup
  (0..executing.size).step(4) do |opcode_position|
    case executing[opcode_position]
    when 1
      executing[executing[opcode_position + 3]] = executing[executing[opcode_position + 1]] + executing[executing[opcode_position + 2]]
    when 2
      executing[executing[opcode_position + 3]] = executing[executing[opcode_position + 1]] * executing[executing[opcode_position + 2]]
    when 99
      break
    end
  end
  puts executing.to_s
  executing
end

def part_one(codes)
  codes[1] = 12
  codes[2] = 2
  executed = execute(codes)
  executed[0]
end

def part_two(codes)
  ;
end

if $PROGRAM_NAME == __FILE__
  codes = read_codes
  puts "Part One: #{part_one(codes)}"
  puts "Part Two: #{part_two(codes)}"
end
