require './aoc_input'

require 'benchmark'

include AOCInput

class Computer
    def initialize(code, start_input = [])
        @code = code
        @halted = false
        @pc = 0
        @input = Queue.new
        [*start_input].each {|i| @input.push(i) }
    end

    def add_input(input)
        @input.push(input)
    end

    def execute
        output = 0
        until @pc > @code.length
            operation = @code[@pc] % 100
            c_mode = (@code[@pc] / 100) % 10
            b_mode = (@code[@pc] / 1000) % 10
            a_mode = (@code[@pc] / 10000) % 10
            
            if (operation == 1)
                first_i = c_mode == 1 ? @pc+1 : @code[@pc+1]
                second_i = b_mode == 1 ? @pc+2 : @code[@pc+2]
                dest_i = a_mode == 1 ? @pc+3 : @code[@pc+3]
                @code[dest_i] = @code[first_i] + @code[second_i]
                @pc += 4
            elsif (operation == 2)
                first_i = c_mode == 1 ? @pc+1 : @code[@pc+1]
                second_i = b_mode == 1 ? @pc+2 : @code[@pc+2]
                dest_i = a_mode == 1 ? @pc+3 : @code[@pc+3]
                @code[dest_i] = @code[first_i] * @code[second_i]
                @pc += 4
            elsif (operation == 3)
                if @input.length == 0
                    return output
                end
                input_val = @input.pop
                @code[@code[@pc+1]] = input_val
                @pc += 2
            elsif (operation == 4)
                output = @code[@code[@pc+1]]
                @pc += 2
            elsif (operation == 5)
                first_i = c_mode == 1 ? @pc+1 : @code[@pc+1]
                second_i = b_mode == 1 ? @pc+2 : @code[@pc+2]
                if (@code[first_i] != 0)
                    @pc = @code[second_i]
                else
                    @pc += 3
                end
            elsif (operation == 6)
                first_i = c_mode == 1 ? @pc+1 : @code[@pc+1]
                second_i = b_mode == 1 ? @pc+2 : @code[@pc+2]
                if (@code[first_i] == 0)
                    @pc = @code[second_i]
                else
                    @pc += 3
                end
            elsif (operation == 7)
                first_i = c_mode == 1 ? @pc+1 : @code[@pc+1]
                second_i = b_mode == 1 ? @pc+2 : @code[@pc+2]
                dest_i = a_mode == 1 ? @pc+3 : @code[@pc+3]
                @code[dest_i] = @code[first_i] < @code[second_i] ? 1 : 0
                @pc += 4
            elsif (operation == 8)
                first_i = c_mode == 1 ? @pc+1 : @code[@pc+1]
                second_i = b_mode == 1 ? @pc+2 : @code[@pc+2]
                dest_i = a_mode == 1 ? @pc+3 : @code[@pc+3]
                @code[dest_i] = @code[first_i] == @code[second_i] ? 1 : 0
                @pc += 4
            elsif (operation == 99)
                @halted = true
                return output
            else
                raise "Unknown operation: #{operation}"
            end

        end
        raise 'Program did not terminate!'
    end

    def hasHalted?
        @halted
    end

    def readMem
        @code
    end
end

def calculate(comp, input)
    comp.add_input(input)
    comp.execute()
end

comp = Computer.new(INPUT.clone)
maxOut = 0
(5..9).to_a.permutation.each do |perm|
    comp_a = Computer.new(INPUT.clone, perm[0])
    comp_b = Computer.new(INPUT.clone, perm[1])
    comp_c = Computer.new(INPUT.clone, perm[2])
    comp_d = Computer.new(INPUT.clone, perm[3])
    comp_e = Computer.new(INPUT.clone, perm[4])
    eout = 0
    while !comp_e.hasHalted?
        aout = calculate(comp_a, eout)
        bout = calculate(comp_b, aout)
        cout = calculate(comp_c, bout)
        dout = calculate(comp_d, cout)
        eout = calculate(comp_e, dout)
    end
    maxOut = [maxOut, eout].max
end
puts "#{maxOut}"
