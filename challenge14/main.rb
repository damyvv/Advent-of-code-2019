require './aoc_input'

include AOCInput

$reactions = []

INPUT.each do |l|
    r = { :input => [] }
    io = l.split("=>")
    io[0].split(",").each do |s|
        ss = s.split(" ")
        r[:input].push({ss[1] => ss[0].to_i})
    end
    out = io[1].split(" ")
    r[:output] = { out[1] => out[0].to_i }
    $reactions.push(r)
end
puts $reactions
puts ""

def calculate_needed(chem, amount)
    return {need: {chem => amount}, left_over: 0} if chem == "ORE"
    $reactions.each do |r|
        next if r[:output].keys[0] != chem
        times = (amount + r[:output].values[0] - 1) / r[:output].values[0]
        needed = {}
        r[:input].each do |hm|
            needed[hm.keys[0]] = hm.values[0]*times
        end
        return {need: needed, left_over: r[:output].values[0]*times - amount}
    end
    raise "Chem not found!"
end

# Part 1
# need = {"FUEL" => 1}
# left_over = {}

# while need.any? { |k,v| k != "ORE" }
#     puts need
#     new_need = {}
#     need.each do |k,v|
#         # We can have some left over
#         chem_need = calculate_needed(k, v)
#         new_need.update(chem_need[:need]) { |k2, v1, v2| v1 + v2 }
#         left_over.update({k => chem_need[:left_over]}) { |k2, v1, v2| v1 + v2 }
#     end
#     left_over.each do |k,v|
#         next if v == 0
#         if new_need[k] || 0 > 0
#             use = [v, new_need[k]].min
#             left_over[k] -= use
#             new_need[k] -= use
#         end
#     end
#     need = new_need
# end
# puts need

# ore_needed = need.first[1]
# puts "Final ore needed: #{ore_needed}"

# Part 2
def create_fuel(amount)
    left_over = {}
    need = {"FUEL" => amount}
    while need.any? { |k,v| k != "ORE" }
        new_need = {}
        need.each do |k,v|
            # We can have some left over
            chem_need = calculate_needed(k, v)
            new_need.update(chem_need[:need]) { |k2, v1, v2| v1 + v2 }
            left_over.update({k => chem_need[:left_over]}) { |k2, v1, v2| v1 + v2 }
        end
        left_over.each do |k,v|
            next if v == 0
            if new_need[k] || 0 > 0
                use = [v, new_need[k]].min
                left_over[k] -= use
                new_need[k] -= use
            end
        end
        need = new_need
    end
    return need["ORE"]
end

fuel = 1
ore_cargo = 1000000000000
ore_min_fuel = create_fuel(1)

loop do
    ore_required = create_fuel(fuel)
    ore_left = ore_cargo - ore_required
    fuel += ore_left / ore_min_fuel
    if ore_cargo - ore_required < ore_min_fuel
        break
    end
end

puts "Can create #{fuel} Fuel"
