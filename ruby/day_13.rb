#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pathname'
require 'matrix'

require_relative 'intcode'
require_relative 'utils'

def part_one(program)
  game = Intcode.new program
  game.execute.outputs.each_slice(3).map(&:last).tally[2]
end

CHARS = {
  0 => ' ',
  1 => '█',
  2 => '▒',
  3 => '_',
  4 => '.',
}.freeze


class Screen
  def initialize(rows, cols)
    @screen = Matrix.zero(rows, cols)
  end

  def []=(x, y, tile)
    @screen[y, x] = tile
  end

  def display_lines
    @screen.transpose.row_vectors.map do |row|
      row.to_a.map { |e| CHARS[e] }.join
    end
  end

  def find(tile)
    @screen.each_with_index { |e, row, col| return [row, col] if e == tile }
    nil
  end
end

def part_two(program)
  program[0] = 2
  game = Intcode.new program

  score = 0
  screen = Screen.new(40, 25)

  1.step do |tick|
    game.execute(false, true)

    game.outputs.each_slice(3) do |x, y, tile|
      if x == -1
        score = tile
      else
        screen[y, x] = tile
      end
    end
    game.outputs.clear

    paddle = screen.find(3)
    ball = screen.find(4)

    d = ball[0] - paddle[0]
    game.inputs << (d.zero? ? 0 : d / d.abs)

    puts screen.display_lines.join("\n")
    puts "Score: #{score} | Tick: #{tick} | Ball: #{ball} | Paddle: #{paddle}".ljust(80)

    return score if screen.find(2).nil?

    puts "\033[#{screen.display_lines.length + 2}A\r"
    sleep 0.001
  end
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/13'

  program = read_program Pathname(__dir__).parent / 'data' / 'day_13.txt'

  puts "Part One: #{part_one(program)}"
  puts "Part Two: #{part_two(program)}"
end
