require './aoc_input'

include AOCInput

class Computer
    def initialize(code)
        @code = code
    end

    def execute
        pc = 0
        until pc > @code.length
            operation = @code[pc]
            if (operation == 1)
                @code[@code[pc+3]] = @code[@code[pc+1]] + @code[@code[pc+2]]
            elsif (operation == 2)
                @code[@code[pc+3]] = @code[@code[pc+1]] * @code[@code[pc+2]]
            elsif (operation == 99)
                return
            else
                raise 'Unknown operation'
            end

            pc += 4
        end
        raise 'Program did not terminate!'
    end

    def readMem(addr)
        @code[addr]
    end
end

a = 0
loop do
    copy = INPUT.clone
    a += 1
    copy[1] = a / 100
    copy[2] = a % 100
    comp = Computer.new(copy)
    comp.execute
    if (comp.readMem(0) == 19690720)
        puts a
        break
    end
end