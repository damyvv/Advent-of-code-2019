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
        @requires_input = false
        [*start_input].each {|i| @input.push(i) }
    end

    def add_input(input)
        @input.push(input)
        @requires_input = false
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
                    @requires_input = true
                    return output
                end
                input_val = @input.pop
                @code[first_i] = input_val
                @pc += 2
            elsif (operation == 4)
                output = (@code[first_i] || 0)
                @pc += 2
                if @input.length == 0
                    @requires_input = true
                end
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

    def requiresInput?
        @requires_input
    end
end

$pos = {x: 0, y: 0}
$tiles = {$pos => 1}

$scoreProgress = {}

def printTiles()
    minX = $tiles.map {|k,v| k[:x] }.min
    maxX = $tiles.map {|k,v| k[:x] }.max
    minY = $tiles.map {|k,v| k[:y] }.min
    maxY = $tiles.map {|k,v| k[:y] }.max
    (minY..maxY).each do |y|
        (minX..maxX).each do |x|
            pos = {x: x, y: y}
            if pos == $pos
                printf("D")
            elsif $tiles[pos].nil?
                printf(" ")
            elsif $tiles[pos] == 0
                printf("#")
            elsif $tiles[pos] == 1
                printf(".")
            elsif $tiles[pos] == 2
                printf("X")
            end
        end
        puts ""
    end
    puts ""
end

comp = Computer.new(INPUT)

loop do
    printTiles()
    
    invalidInput = true
    while invalidInput
        movX = 0
        movY = 0
        invalidInput = false
        user_in = gets.strip
        # user_in = "a"
        if user_in == "w"
            move = 1
            movY = -1
        elsif user_in == "s"
            move = 2
            movY = 1
        elsif user_in == "a"
            move = 3
            movX = -1
        elsif user_in == "d"
            move = 4
            movX = 1
        else
            invalidInput = true
            puts "Invalid input"
        end
    end
    
    comp.add_input(move)
    status = comp.execute()
    puts status
    newPos = {x: $pos[:x] + movX, y: $pos[:y] + movY}
    $tiles[newPos] = status
    if status != 0
        $pos = newPos
    end
end

puts "End"
$scoreProgress.each do |k|
    printf("%u, %u;\n", k[0], k[1])
end
