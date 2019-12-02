# frozen_string_literal: true

OPERATIONS = {
  1 => [
    3,
    proc do |codes, parameters|
      codes[parameters[2]] = codes[parameters[0]] + codes[parameters[1]]
    end,
  ],
  2 => [
    3,
    proc do |codes, parameters|
      codes[parameters[2]] = codes[parameters[0]] * codes[parameters[1]]
    end,
  ],
}.freeze

def execute(codes)
  codes = codes.dup

  instruction_pointer = 0
  loop do
    instruction = codes[instruction_pointer]

    # not sure how to not special-case this...
    return codes if instruction == 99

    unless OPERATIONS.key? instruction
      raise ArgumentError, "Unrecognized opcode #{instruction} at address #{instruction_pointer}"
    end

    num_parameters, operation = OPERATIONS[instruction]

    #puts "#{instruction} #{parameters} #{codes}"

    parameters = codes[instruction_pointer + 1, num_parameters]
    operation.call(codes, parameters)

    instruction_pointer += num_parameters + 1
  end
end
