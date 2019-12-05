# frozen_string_literal: true

OPERATIONS = {
  1 =>
    lambda do |program, _inputs, _outputs, a, b, target|
      program[target] = a + b
    end,
  2 =>
    lambda do |program, _inputs, _outputs, a, b, target|
      program[target] = a * b
    end,
  3 =>
    lambda do |program, inputs, _outputs, target|
      program[target] = inputs.shift
    end,
  4 =>
    lambda do |_program, _inputs, outputs, target|
      outputs << target
    end,
}.freeze
# opcode 99 is special-cased during execute

WRITES = {
  1 => [2],
  2 => [2],
  3 => [0],
  4 => [],
}.freeze

def execute(program, inputs = nil)
  program = program.dup
  inputs ||= []
  outputs = []

  instruction_pointer = 0
  loop do
    instruction = program[instruction_pointer].to_s
    if instruction.length <= 2
      opcode = instruction.to_i
      modes = []
    else
      opcode = instruction[-2, 2].to_i
      modes = instruction[0...-2].reverse.chars.map(&:to_i)
    end

    return program, inputs, outputs if opcode == 99

    operation = OPERATIONS[opcode]
    if operation.nil?
      raise ArgumentError, "Unrecognized opcode #{opcode} at address #{instruction_pointer}"
    end

    num_parameters = operation.arity - 3
    raw_parameters = program[instruction_pointer + 1, num_parameters]
    parameters = raw_parameters.zip(modes).each.with_index.map do |(raw_param, mode), param_idx|
      case mode
        when 0, nil
          (WRITES[opcode].include? param_idx) ? raw_param : program[raw_param]
        when 1
          raw_param
        else
          raise ArgumentError, "Unrecognized mode #{mode} at address #{instruction_pointer}"
      end
    end

    #puts "#{instruction_pointer} op#{opcode} i#{inputs} o#{outputs} m#{modes} r#{raw_parameters} p#{parameters} #{program}"
    operation.call(program, inputs, outputs, *parameters)

    instruction_pointer += num_parameters + 1
  end
end

def read_program(path)
  path.read.split(',').map(&:to_i)
end
