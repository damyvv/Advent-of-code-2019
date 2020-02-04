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

$tiles = {}

$scoreProgress = {}

def printTiles()
    # (0..21).each do |y|
    #     (0..43).each do |x|
    #         pos = {x: x, y: y}
    #         tile_id = $tiles[pos]
    #         case tile_id
    #         when 0
    #             printf(" ")
    #         when 1
    #             printf("X")
    #         when 2
    #             printf("=")
    #         when 3
    #             printf("-")
    #         when 4
    #             printf("o")
    #         else 
    #             printf("%u", tile_id)
    #         end
    #     end
    #     printf("\n")
    # end
    pos = { x: -1, y: 0 }
    score = $tiles[pos] || 0
    printf("\n%u\n", score)
    blocks = 0
    $tiles.each do |k|
        blocks += 1 if k[1] == 2
    end
    $scoreProgress[blocks] = score
    puts "Rem: #{blocks}"
    printf("\n")
end

INPUT[0] = 2
comp = Computer.new(INPUT)

until comp.hasHalted?
    until comp.requiresInput? || comp.hasHalted?
        x = comp.execute()
        y = comp.execute()
        pos = {x: x, y: y}
        $tiles[pos] = comp.execute()
    end
    # break if comp.hasHalted?
    printTiles()

    ballPos = $tiles.key(4)[:x]
    playerPos = $tiles.key(3)[:x]
    if ballPos < playerPos
        movX = -1
    elsif ballPos > playerPos
        movX = 1
    else
        movX = 0
    end

    # Draw
    comp.add_input(movX)
end

puts "End"
$scoreProgress.each do |k|
    printf("%u, %u;\n", k[0], k[1])
end
