require './aoc_input'

require 'benchmark'

include AOCInput

class Computer
    def initialize(code, start_input = [])
        @code = Hash[(0...code.size).zip code]
        @halted = false
        @pc = 0
        @base = 0
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
            
            first_i = c_mode == 2 ? (@base+@code[@pc+1]) : (c_mode == 1 ? @pc+1 : @code[@pc+1])
            second_i = b_mode == 2 ? (@base+@code[@pc+2]) : (b_mode == 1 ? @pc+2 : @code[@pc+2])
            dest_i = a_mode == 2 ? (@base+@code[@pc+3]) : (a_mode == 1 ? @pc+3 : @code[@pc+3])

            if (operation == 1)
                @code[dest_i] = (@code[first_i] || 0) + (@code[second_i] || 0)
                @pc += 4
            elsif (operation == 2)
                @code[dest_i] = (@code[first_i] || 0) * (@code[second_i] || 0)
                @pc += 4
            elsif (operation == 3)
                if @input.length == 0
                    return output
                end
                input_val = @input.pop
                @code[first_i] = input_val
                @pc += 2
            elsif (operation == 4)
                output = (@code[first_i] || 0)
                @pc += 2
                return output
            elsif (operation == 5)
                if (@code[first_i] != 0)
                    @pc = (@code[second_i] || 0)
                else
                    @pc += 3
                end
            elsif (operation == 6)
                if (@code[first_i] == 0)
                    @pc = (@code[second_i] || 0)
                else
                    @pc += 3
                end
            elsif (operation == 7)
                @code[dest_i] = (@code[first_i] || 0) < (@code[second_i] || 0) ? 1 : 0
                @pc += 4
            elsif (operation == 8)
                @code[dest_i] = (@code[first_i] || 0) == (@code[second_i] || 0) ? 1 : 0
                @pc += 4
            elsif (operation == 9)
                @base += (@code[first_i] || 0)
                @pc += 2
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

panels = {}

comp = Computer.new(INPUT)
pos = {x: 0, y: 0}
dir = 0 # 0: up, 1: right, 2: down, 3: left
panels[pos] = 1
until comp.hasHalted?
    color = panels[pos] || 0
    comp.add_input(color)
    panels[pos] = comp.execute()
    rot = comp.execute()
    if (rot == 0)
        dir -= 1
        if (dir < 0)
            dir += 4
        end
    else
        dir = (dir + 1) % 4
    end
    if (dir & 1 == 1)
        pos = { x: pos[:x] - dir+2, y: pos[:y] }
    else
        pos = { x: pos[:x], y: pos[:y] + dir-1}
    end
end

puts panels.length

xmin = 0
xmax = 0
ymin = 0
ymax = 0

panels.each_key do |k|
    xmin = [xmin, k[:x]].min
    xmax = [xmax, k[:x]].max
    ymin = [ymin, k[:y]].min
    ymax = [ymax, k[:y]].max
end

(ymin..ymax).each do |y|
    (xmin..xmax).each do |x|
        col = panels[{x: x, y: y}] || 0
        if (col == 0)
            printf(".")
        else
            printf("#")
        end
    end
    printf("\n")
end
