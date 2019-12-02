# frozen_string_literal: true

OPERATIONS = {
  1 =>
    proc do |codes, a, b, target|
      codes[target] = codes[a] + codes[b]
    end,
  2 =>
    proc do |codes, a, b, target|
      codes[target] = codes[a] * codes[b]
    end,
}.freeze

def execute(codes)
  codes = codes.dup

  instruction_pointer = 0
  loop do
    opcode = codes[instruction_pointer]

    # not sure how to not special-case this...
    return codes if opcode == 99

    operation = OPERATIONS[opcode]
    if operation.nil?
      raise ArgumentError, "Unrecognized opcode #{opcode} at address #{instruction_pointer}"
    end

    num_parameters = operation.arity - 1
    parameters = codes[instruction_pointer + 1, num_parameters]

    operation.call(codes, *parameters)

    instruction_pointer += num_parameters + 1
  end
end
