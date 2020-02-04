require './aoc_input'

include AOCInput

class Wire
    def initialize(wire)
        @segments = {}
        i = 0
        points = wire.split(",")
        pos = {x: 0, y: 0}
        points.each do |point|
            prev = pos.clone
            if point[0] == 'R'
                pos[:x] += point[1..-1].to_i
            elsif point[0] == 'L'
                pos[:x] -= point[1..-1].to_i
            elsif point[0] == 'U'
                pos[:y] += point[1..-1].to_i
            elsif point[0] == 'D'
                pos[:y] -= point[1..-1].to_i
            else raise 'Invalid point'
            end
            @segments[i] = { from: prev, to: pos.clone }
            i += 1
        end
    end

    def getSegments
        @segments
    end
end

wire_a = Wire.new(INPUT_A)
wire_b = Wire.new(INPUT_B)

# Calculate intersection
closest = 1/0.0
minsteps = 1/0.0
a_steps = 0

wire_a.getSegments().each_pair do |k1,seg_a|
    b_steps = 0
    wire_b.getSegments().each_pair do |k2,seg_b|
        check_collision = false
        if seg_a[:from][:x] == seg_a[:to][:x] && seg_b[:from][:y] == seg_b[:to][:y]
            # Vertical A segment
            vert = seg_a
            hori = seg_b
            check_collision = true
        elsif seg_a[:from][:y] == seg_a[:to][:y] && seg_b[:from][:x] == seg_b[:to][:x]
            # Horizontal A segment
            vert = seg_b
            hori = seg_a
            check_collision = true
        end

        if check_collision && vert[:from][:x] > [hori[:from][:x],hori[:to][:x]].min  &&
            vert[:from][:x] < [hori[:from][:x],hori[:to][:x]].max &&
            hori[:from][:y] > [vert[:from][:y],vert[:to][:y]].min &&
            hori[:from][:y] < [vert[:from][:y],vert[:to][:y]].max
            # We have a collision
            closest = [closest, hori[:from][:y].abs + vert[:from][:x].abs].min
            minsteps = [minsteps, a_steps + b_steps + (vert[:from][:x] - hori[:from][:x]).abs + (hori[:from][:y] - vert[:from][:y]).abs].min
        end
        b_steps += (seg_b[:from][:x] - seg_b[:to][:x] + seg_b[:from][:y] - seg_b[:to][:y]).abs
    end
    a_steps += (seg_a[:from][:x] - seg_a[:to][:x] + seg_a[:from][:y] - seg_a[:to][:y]).abs
end

puts "Min Manhatten: #{closest}, min steps: #{minsteps}"
