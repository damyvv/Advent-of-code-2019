require './aoc_input'

include AOCInput

def calcFuel(mass)
    required_fuel = [0, mass/3-2].max
    if (required_fuel > 0)
        return required_fuel + calcFuel(required_fuel)
    end
    return required_fuel
end

sum = 0;
INPUT.each do |mod| 
    sum += calcFuel(mod)
end
puts sum