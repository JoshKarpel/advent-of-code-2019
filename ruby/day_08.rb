# frozen_string_literal: true

require 'pathname'

require_relative 'utils'

def read_raw_image
  (Pathname(__dir__).parent / 'data' / 'day_08.txt').read.chomp.split('').map(&:to_i)
end

def parse_image(raw_image, width, height)
  layers = []
  layers << raw_image.shift(width * height) while raw_image.length.positive?
  layers
end

def part_one(layers)
  fewest_0s = layers.map(&:tally).min_by do |tally|
    tally[0]
  end
  fewest_0s[1] * fewest_0s[2]
end

def part_two(layers, width, height)
  image = Array.new(width * height, 2)
  layers.each do |layer|
    layer.each_with_index do |pixel, idx|
      image[idx] = pixel if image[idx] == 2
    end
  end

  msg = []
  height.times do |y|
    width.times do |x|
      pixel = image[x + (y * width)]
      msg << case pixel
        when 2
          ' '
        when 1
          '█'
        when 0
          '░'
      end
    end
    msg << "\n"
  end
  "\n" + msg.join
end

if $PROGRAM_NAME == __FILE__
  puts 'https://adventofcode.com/2019/day/8'

  width, height = 25, 6

  layers = parse_image(read_raw_image, width, height)

  puts "Part One: #{part_one(layers)}"
  puts "Part Two: #{part_two(layers, width, height)}"
end
