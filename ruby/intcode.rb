# frozen_string_literal: true

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

      op = operation opcode
      move = op.call(*parameters(op, modes))

      move.nil? ? @instruction_pointer += op.arity + 1 : @instruction_pointer = move
    end
  end

  def operation(opcode)
    op = method("do_#{opcode}".to_sym)
    if op.nil?
      raise ArgumentError, "Unrecognized opcode #{opcode} at address #{@instruction_pointer}"
    end

    op
  end

  def state
    opcode, modes = opcode_and_modes
    op = operation opcode

    [
      "in#{@instruction_pointer}",
      "op#{opcode}",
      "i#{@inputs}",
      "o#{@outputs}",
      "m#{modes}",
      "r#{raw_parameters(op)}",
      "p#{parameters(op, modes)}",
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

  def raw_parameters(op)
    @program[@instruction_pointer + 1, op.arity]
  end

  def parameters(operation, modes)
    raw_parameters(operation)
      .zip(modes, operation.parameters.map(&:last).map(&:to_s))
      .map do |raw_param, mode, param_name|
      next raw_param if param_name.start_with?('w_')

      case mode
        when 0, nil
          @program[raw_param]
        when 1
          raw_param
        else
          raise ArgumentError, "Unrecognized mode #{mode} for instruction #{@instruction_pointer}"
      end
    end
  end

  # OPERATIONS

  # add
  def do_1(a, b, w_target)
    @program[w_target] = a + b
    nil
  end

  # multiply
  def do_2(a, b, w_target)
    @program[w_target] = a * b
    nil
  end

  # input
  def do_3(w_target)
    @program[w_target] = @inputs.shift
    nil
  end

  # output
  def do_4(output)
    @outputs << output
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
  def do_7(left, right, w_target)
    @program[w_target] = left < right ? 1 : 0
    nil
  end

  # equals
  def do_8(left, right, w_target)
    @program[w_target] = left == right ? 1 : 0
    nil
  end

  # break (dummy method, actually implemented in #execute, just here for #state)
  def do_99
  end
end
