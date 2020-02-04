require './aoc_input'

include AOCInput

moons = INPUT.map {|m| {x:m[:x], y:m[:y], z:m[:z], vel_x:0, vel_y:0, vel_z:0}}

# Part 1
# puts "Step 0:"
# moons.each {|m| puts m}
# puts ""
#
# (1..1000).each do |i|
#     # Update velocity
#     moons.each do |m|
#         moons.each do |o|
#             next if m == o
#             m[:vel_x] += 1 if m[:x] < o[:x]
#             m[:vel_x] -= 1 if m[:x] > o[:x]
#             m[:vel_y] += 1 if m[:y] < o[:y]
#             m[:vel_y] -= 1 if m[:y] > o[:y]
#             m[:vel_z] += 1 if m[:z] < o[:z]
#             m[:vel_z] -= 1 if m[:z] > o[:z]
#         end
#     end
#     # Update position
#     # puts "Step #{i}:"
#     moons.each do |m|
#         m[:x] += m[:vel_x]
#         m[:y] += m[:vel_y]
#         m[:z] += m[:vel_z]
#         # puts "#{m}"
#     end
#     # puts ""
# end
#
# puts moons.map {|m| ((m[:x].abs) + (m[:y].abs) + (m[:z].abs)) * ((m[:vel_x].abs) + (m[:vel_y].abs) + (m[:vel_z].abs)) }.sum

# Part 2
steps = Array.new(3, 0)
input = INPUT.map {|m| {x:m[:x], y:m[:y], z:m[:z], vel_x:0, vel_y:0, vel_z:0}}
moons = Marshal.load(Marshal.dump(input))

i = 0
loop do
    i += 1
    # Update velocity
    moons.each do |m|
        moons.each do |o|
            next if m == o
            m[:vel_x] += 1 if m[:x] < o[:x]
            m[:vel_x] -= 1 if m[:x] > o[:x]
            m[:vel_y] += 1 if m[:y] < o[:y]
            m[:vel_y] -= 1 if m[:y] > o[:y]
            m[:vel_z] += 1 if m[:z] < o[:z]
            m[:vel_z] -= 1 if m[:z] > o[:z]
        end
    end
    # Update position
    moons.each do |m|
        m[:x] += m[:vel_x]
        m[:y] += m[:vel_y]
        m[:z] += m[:vel_z]
    end
    syms = [:x, :y, :z, :vel_x, :vel_y, :vel_z]
    (0..2).each do |k|
        next if steps[k] != 0
        equal = true
        moons.each_with_index do |m, j|
            if m[syms[k]] != input[j][syms[k]] || m[syms[k+3]] != input[j][syms[k+3]]
                equal = false
            end
        end
        if equal
            puts syms[k]
            puts i
            steps[k] = i
        end
    end
    # puts "Step #{i}:"
    # moons.each {|m| puts m}
    puts i if i % 10000 == 0
    break if steps.all? {|j| j != 0}
end

puts steps
puts steps.reduce(1, :lcm)
