def isValid(pass)
    arr = pass.to_s.split("")
    return false if (arr.sort != arr)
    arr.inject(Hash.new(0)) { |total, key| total[key] += 1; total }.values.include?(2)
end
valid_count = 0
(359282...820401).each { |i| valid_count += 1 if isValid(i) }
puts valid_count

