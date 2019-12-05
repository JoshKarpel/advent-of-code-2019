# frozen_string_literal: true

OPERATIONS = {
  1 =>
    lambda do |program, a, b, target|
      program[target] = program[a] + program[b]
    end,
  2 =>
    lambda do |program, a, b, target|
      program[target] = program[a] * program[b]
    end,
}.freeze
# opcode 99 is special-cased during execute

def execute(program)
  program = program.dup

  instruction_pointer = 0
  loop do
    opcode = program[instruction_pointer]

    return program[0] if opcode == 99

    operation = OPERATIONS[opcode]
    raise ArgumentError, "Unrecognized opcode #{opcode} at address #{instruction_pointer}" if operation.nil?

    operation.call(program, *program[instruction_pointer + 1, operation.arity - 1])

    instruction_pointer += operation.arity
  end
end

def read_program(path)
  path.read.split(',').map(&:to_i)
end
