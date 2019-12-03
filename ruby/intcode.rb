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

def execute(program)
  program = program.dup

  instruction_pointer = 0
  loop do
    opcode = program[instruction_pointer]

    # not sure how to not special-case this...
    return program if opcode == 99

    operation = OPERATIONS[opcode]
    if operation.nil?
      raise ArgumentError, "Unrecognized opcode #{opcode} at address #{instruction_pointer}"
    end

    num_parameters = operation.arity - 1
    parameters = program[instruction_pointer + 1, num_parameters]

    operation.call(program, *parameters)

    instruction_pointer += num_parameters + 1
  end
end
