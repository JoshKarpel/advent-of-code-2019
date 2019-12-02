# frozen_string_literal: true

PARAMETER_COUNTS = {1 => 3, 2 => 3, 99 => 0}.freeze

def execute(codes)
  codes = codes.dup

  instruction_pointer = 0
  loop do
    instruction = codes[instruction_pointer]

    num_parameters = PARAMETER_COUNTS[instruction]
    if num_parameters.nil?
      raise ArgumentError, "Unrecognized opcode #{instruction} at address #{instruction_pointer}"
    end

    parameters = codes[instruction_pointer + 1, num_parameters]

    #puts "#{instruction} #{parameters} #{codes}"

    case instruction
    when 1
      codes[parameters[2]] = codes[parameters[0]] + codes[parameters[1]]
    when 2
      codes[parameters[2]] = codes[parameters[0]] * codes[parameters[1]]
    when 99
      return codes
    end

    instruction_pointer += num_parameters + 1
  end
end
