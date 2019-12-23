#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'set'

require_relative 'intcode'
require_relative 'utils'

SLEEP_DURATION = 0.001

def spawn_computer(program, addr, input_queue, router)
  Thread.new do
    computer = Intcode.new(program, [addr])
    loop do
      sleep SLEEP_DURATION

      computer.execute!(true, true)

      if computer.outputs.size == 1 # send
        computer.execute!(true).execute!(true)
        router << computer.outputs.shift(3)
      elsif input_queue.size.positive?
        computer.inputs << input_queue.pop
        computer.inputs << input_queue.pop
      else
        computer.inputs << -1
      end
    end
  end
end

def part_one(program)
  router = Queue.new

  inputs = 50.times.map { |_| Queue.new }

  nics = inputs.each_with_index.map do |input_queue, addr|
    spawn_computer(program, addr, input_queue, router)
  end

  loop do
    sleep SLEEP_DURATION

    addr, x, y = router.pop

    if addr == 255
      nics.map(&:kill)
      return y
    else
      inputs[addr] << x
      inputs[addr] << y
    end
  end
end

def part_two(program)
  router = Queue.new

  inputs = 50.times.map { |_| Queue.new }

  nics = inputs.each_with_index.map do |input_queue, addr|
    spawn_computer(program, addr, input_queue, router)
  end

  nat = [nil, nil]
  idle_count = 0
  last_y_sent = nil
  loop do
    sleep SLEEP_DURATION

    begin
      packet = router.pop(true)
    rescue ThreadError
      idle_count += 1

      # if no inputs to be processed and the router has been idle for 10 cycles, fire the NAT
      if inputs.all?(&:empty?) && idle_count > 10
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
