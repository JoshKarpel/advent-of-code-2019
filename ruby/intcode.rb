# frozen_string_literal: true

def read_program(path)
  path.read.split(',').map(&:to_i)
end

module ParameterMode
  POSITION = 0
  IMMEDIATE = 1
  RELATIVE = 2
end

class Intcode
  attr_reader :memory, :inputs, :outputs, :halted

  def initialize(program, inputs = nil)
    @memory = Hash.new(0)
    program.each.with_index { |int, idx| @memory[idx] = int }
    @inputs = inputs || []

    @outputs = []
    @instruction_pointer = 0
    @relative_base = 0
    @halted = false
  end

  def execute(stop_on_output = false)
    loop do
      #puts state
      opcode, modes = opcode_and_modes
      op = operation opcode
      move = op.call(*parameters(op, modes))

      move.nil? ? @instruction_pointer += op.arity + 1 : @instruction_pointer = move

      return self if @halted || (stop_on_output && opcode == 4)
    end
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
      "rb#{@relative_base}",
      "r#{raw_parameters(op)}",
      "p#{parameters(op, modes)}",
      "prog#{@memory}",
    ].join(' ')
  end

  private

    def operation(opcode)
      op = method("do_#{opcode}".to_sym)
      if op.nil?
        raise ArgumentError, "Unrecognized opcode #{opcode} at address #{@instruction_pointer}"
      end

      op
    end

    def opcode_and_modes
      instruction = @memory[@instruction_pointer].to_s
      if instruction.length <= 2
        opcode = instruction.to_i
        modes = []
      else
        opcode = instruction[-2, 2].to_i
        modes = instruction[0...-2].reverse.chars.map(&:to_i)
      end
      [opcode, modes]
    end

    def parameters(operation, modes)
      raw_parameters(operation)
        .zip(modes, operation.parameters.map(&:last).map(&:to_s))
        .map do |raw_param, mode, param_name|
        parameter_value(mode, param_name, raw_param)
      end
    end

    def raw_parameters(op)
      op.arity.times.map { |idx| @memory[@instruction_pointer + 1 + idx] || 0 }
    end

    def parameter_value(mode, param_name, raw_param)
      return raw_param if mode == ParameterMode::IMMEDIATE

      raw_param += @relative_base if mode == ParameterMode::RELATIVE

      # semantics of POSITION and RELATIVE are the same at this point

      return raw_param if param_name.start_with?('w_')

      @memory[raw_param]
    end

    # OPERATIONS

    # add
    def do_1(a, b, w_target)
      @memory[w_target] = a + b
      nil
    end

    # multiply
    def do_2(a, b, w_target)
      @memory[w_target] = a * b
      nil
    end

    # input
    def do_3(w_target)
      @memory[w_target] = @inputs.shift
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
      @memory[w_target] = left < right ? 1 : 0
      nil
    end

    # equals
    def do_8(left, right, w_target)
      @memory[w_target] = left == right ? 1 : 0
      nil
    end

    # adjust relative base
    def do_9(adjustment)
      @relative_base += adjustment
      nil
    end

    # break
    def do_99
      @halted = true
    end
end
