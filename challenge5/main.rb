require './aoc_input'

include AOCInput

class Computer
    def initialize(code)
        @code = code
    end

    def execute(input)
        pc = 0
        until pc > @code.length
            operation = @code[pc] % 100
            c_mode = (@code[pc] / 100) % 10
            b_mode = (@code[pc] / 1000) % 10
            a_mode = (@code[pc] / 10000) % 10
            
            if (operation == 1)
                first_i = c_mode == 1 ? pc+1 : @code[pc+1]
                second_i = b_mode == 1 ? pc+2 : @code[pc+2]
                dest_i = a_mode == 1 ? pc+3 : @code[pc+3]
                @code[dest_i] = @code[first_i] + @code[second_i]
                pc += 4
            elsif (operation == 2)
                first_i = c_mode == 1 ? pc+1 : @code[pc+1]
                second_i = b_mode == 1 ? pc+2 : @code[pc+2]
                dest_i = a_mode == 1 ? pc+3 : @code[pc+3]
                @code[dest_i] = @code[first_i] * @code[second_i]
                pc += 4
            elsif (operation == 3)
                @code[@code[pc+1]] = input
                pc += 2
            elsif (operation == 4)
                puts @code[@code[pc+1]]
                pc += 2
            elsif (operation == 5)
                first_i = c_mode == 1 ? pc+1 : @code[pc+1]
                second_i = b_mode == 1 ? pc+2 : @code[pc+2]
                if (@code[first_i] != 0)
                    pc = @code[second_i]
                else
                    pc += 3
                end
            elsif (operation == 6)
                first_i = c_mode == 1 ? pc+1 : @code[pc+1]
                second_i = b_mode == 1 ? pc+2 : @code[pc+2]
                if (@code[first_i] == 0)
                    pc = @code[second_i]
                else
                    pc += 3
                end
            elsif (operation == 7)
                first_i = c_mode == 1 ? pc+1 : @code[pc+1]
                second_i = b_mode == 1 ? pc+2 : @code[pc+2]
                dest_i = a_mode == 1 ? pc+3 : @code[pc+3]
                @code[dest_i] = @code[first_i] < @code[second_i] ? 1 : 0
                pc += 4
            elsif (operation == 8)
                first_i = c_mode == 1 ? pc+1 : @code[pc+1]
                second_i = b_mode == 1 ? pc+2 : @code[pc+2]
                dest_i = a_mode == 1 ? pc+3 : @code[pc+3]
                @code[dest_i] = @code[first_i] == @code[second_i] ? 1 : 0
                pc += 4
            elsif (operation == 99)
                return
            else
                raise "Unknown operation: #{operation}"
            end

        end
        raise 'Program did not terminate!'
    end

    def readMem
        @code
    end
end

comp = Computer.new(INPUT.clone)
comp.execute(5)
