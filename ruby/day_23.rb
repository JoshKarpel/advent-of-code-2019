#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'set'

require_relative 'intcode'
require_relative 'utils'

def part_one(program)
  router = Queue.new

  inputs = 50.times.map { |_| Queue.new }

  nics = inputs.each_with_index.map do |input_queue, addr|
    Thread.new do
      computer = Intcode.new(program, [addr])
      loop do
        sleep 0.01

        computer.execute!(true, true)

        if computer.outputs.size == 1 # send
          computer.execute!(true).execute!(true)
          router << computer.outputs.shift(3)
        else # empty receive
          if input_queue.size.positive?
            computer.inputs << input_queue.pop
            computer.inputs << input_queue.pop
          else
            computer.inputs << -1
          end
        end
      end
    end
  end

  loop do
    addr, x, y = router.shift
    if addr == 255
      nics.map(&:kill)
      return y
    end
    inputs[addr] << x
    inputs[addr] << y
  end
end

def part_two(program)
  router = Queue.new

  inputs = 50.times.map { |_| Queue.new }

  nics = inputs.each_with_index.map do |input_queue, addr|
    Thread.new do
      computer = Intcode.new(program, [addr])
      loop do
        sleep 0.001

        computer.execute!(true, true)

        if computer.outputs.size == 1 # send
          computer.execute!(true).execute!(true)
          router << computer.outputs.shift(3)
        else # empty receive
          if input_queue.size.positive?
            computer.inputs << input_queue.pop
            computer.inputs << input_queue.pop
          else
            computer.inputs << -1
          end
        end
      end
    end
  end

  nat = [nil, nil]
  idle_count = 0
  last_y_sent = nil
  loop do
    sleep 0.001

    begin
      packet = router.pop(true)
    rescue ThreadError
      idle_count += 1
      if inputs.all?(&:empty?) && idle_count > 100
        inputs[0] << nat[0]
        inputs[0] << nat[1]

        if last_y_sent == nat[1]
          nics.map(&:kill)
          return last_y_sent
        end

        last_y_sent = nat[1]
        idle_count = 0
      end
      next
    end

    addr, x, y = packet
    if addr == 255
      nat = [x, y]
    else
      inputs[addr] << x
      inputs[addr] << y
    end

    idle_count = 0
  end
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/23'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_23.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
