# frozen_string_literal: true

WRITES = {
  1 => [2],
  2 => [2],
  3 => [0],
  4 => [],
  5 => [],
  6 => [],
  7 => [2],
  8 => [2],
}.freeze

def read_program(path)
  path.read.split(',').map(&:to_i)
end

class Intcode
  attr_reader :program, :inputs, :outputs

  def initialize(program, inputs = nil)
    @program = program.dup
    @inputs = inputs || []

    @outputs = []
    @instruction_pointer = 0
  end

  def self.read(path, inputs = nil)
    Intcode(path.read.split(',').map(&:to_i), inputs)
  end

  def execute
    loop do
      #puts state
      opcode, modes = opcode_and_modes

      return self if opcode == 99

      operation = method("do_#{opcode}".to_sym)
      if operation.nil?
        raise ArgumentError, "Unrecognized opcode #{opcode} at address #{instruction_pointer}"
      end

      move = operation.call(*parameters(opcode, operation.arity, modes))

      move.nil? ? @instruction_pointer += operation.arity + 1 : @instruction_pointer = move
    end
  end

  def state
    opcode, modes = opcode_and_modes
    operation = method("do_#{opcode}".to_sym)
    if operation.nil?
      raise ArgumentError, "Unrecognized opcode #{opcode} at address #{@instruction_pointer}"
    end

    [
      "in#{@instruction_pointer}",
      "op#{opcode}",
      "i#{@inputs}",
      "o#{@outputs}",
      "m#{modes}",
      "r#{raw_parameters(operation.arity)}",
      "p#{parameters(opcode, operation.arity, modes)}",
      "prog#{@program}",
    ].join(' ')
  end

  def opcode_and_modes
    instruction = @program[@instruction_pointer].to_s
    if instruction.length <= 2
      opcode = instruction.to_i
      modes = []
    else
      opcode = instruction[-2, 2].to_i
      modes = instruction[0...-2].reverse.chars.map(&:to_i)
    end
    [opcode, modes]
  end

  def raw_parameters(num_parameters)
    @program[@instruction_pointer + 1, num_parameters]
  end

  def parameters(opcode, num_parameters, modes)
    raw_parameters(num_parameters)
      .zip(modes)
      .each.with_index.map do |(raw_param, mode), param_idx|
      case mode
        when 0, nil
          WRITES[opcode].include?(param_idx) ? raw_param : @program[raw_param]
        when 1
          raw_param
        else
          raise ArgumentError, "Unrecognized mode #{mode} for instruction #{@instruction_pointer}"
      end
    end
  end

  # OPERATIONS

  # add
  def do_1(a, b, target)
    @program[target] = a + b
    nil
  end

  # multiply
  def do_2(a, b, target)
    @program[target] = a * b
    nil
  end

  # input
  def do_3(target)
    @program[target] = @inputs.shift
    nil
  end

  # output
  def do_4(target)
    @outputs << target
    nil
  end

  # jump-if-true
  def do_5(test, pointer)
    test.nonzero? ? pointer : nil
  end

  # jump-if-false
  def do_6(test, pointer)
    test.zero? ? pointer : nil
  end

  # less-than
  def do_7(left, right, target)
    @program[target] = left < right ? 1 : 0
    nil
  end

  # equals
  def do_8(left, right, target)
    @program[target] = left == right ? 1 : 0
    nil
  end

  # break (dummy method, actually implemented in execute)
  def do_99
  end
end
