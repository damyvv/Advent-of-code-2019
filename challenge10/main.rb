require './aoc_input'

include AOCInput

asteroids = []

INPUT.each_with_index {|l,y| l.split('').each_with_index {|a,x| asteroids.push({x: x, y: y}) if a == '#' }}

ymax = INPUT.length
xmax = INPUT[0].length

mostSeen = 0
bestPos = nil
asteroids.each do |pos|
    field = asteroids.map do |a|
        next if a == pos
        x = a[:x]-pos[:x]
        y = a[:y]-pos[:y]
        div = x.gcd(y)
        x /= div
        y /= div
        {x: x, y: y}
    end
    field.delete(pos)
    canSee = field.to_set.length
    if canSee > mostSeen
        mostSeen = canSee
        bestPos = pos
    end
end

puts "Best pos: #{bestPos}, can see #{mostSeen} astroids"

# Part 2

def calc_angle(x, y)
    if x == 0 && y < 0
        angle = 3.0/2.0 * Math::PI
    elsif x == 0
        angle = Math::PI / 2.0
    else
        angle = Math.atan(y/x)
        if x < 0 && y < 0
            angle += Math::PI
        elsif y < 0
            angle += 2*Math::PI
        elsif x < 0
            angle += Math::PI
        end
    end
    angle
end

asteroids.delete(bestPos)
asteroids.map! do |a|
    x = a[:x]-bestPos[:x]
    y = a[:y]-bestPos[:y]
    angle = calc_angle(-y.to_f, x.to_f)
    { x: x, y: y, angle: angle, destroyed: 0 }
end
asteroids.sort_by!{|a| [a[:angle], a[:x], -a[:y]]}
asteroids.map! do |a|
    { x: a[:x] + bestPos[:x], y: a[:y] + bestPos[:y], angle: a[:angle], destroyed: a[:destroyed] }
end
# puts asteroids

destroyed = 0
lastAngle = -1
index = 0
loop do
    a = asteroids[index]
    next if a[:destroyed] > 0
    if a[:angle] != lastAngle
        lastAngle = a[:angle]
        destroyed += 1
        a[:destroyed] = destroyed
        if destroyed == 200
            puts a
            puts a[:x]*100 + a[:y]
            break
        end
    end

    index = (index + 1) % asteroids.length
end
