require './aoc_input'

include AOCInput

orbits = {}

INPUT.each { |orbit| orbits.merge!([orbit.split(')').reverse].to_h) }

numOrbits = 0
orbits.each_pair do |key, value|
    while orbits.has_key?(key)
        key = value
        value = orbits[key]
        numOrbits += 1
    end
end

transfers_needed = 0
you = orbits["YOU"]
found = false
you_steps = 0
while (orbits.has_key?(you) && !found)
    san = orbits["SAN"]
    santa_steps = 0
    while (orbits.has_key?(san) && !found)
        if (you == san)
            found = true
            transfers_needed = santa_steps + you_steps
        else
            san = orbits[san];
            santa_steps += 1
        end
    end
    you = orbits[you]
    you_steps += 1
end

puts "Orbits: #{numOrbits}, Transfers: #{transfers_needed}"
