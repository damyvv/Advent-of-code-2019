require './aoc_input'

include AOCInput

WIDTH = 25
HEIGHT = 6

arr = INPUT.scan(/.{#{WIDTH}}/)
count = Array.new(arr.length/HEIGHT, 0)
arr.each_with_index do |s, i|
    count[i/HEIGHT] += s.count('0')
end

minIndex = count.each_with_index.min[1]

ones = 0
twos = 0
layerStart = HEIGHT * minIndex
(layerStart..(layerStart + HEIGHT - 1)).each do |i|
    ones += arr[i].count('1')
    twos += arr[i].count('2')
end

p ones*twos 

image = Array.new(HEIGHT) {Array.new(WIDTH, -1)}
arr.each_with_index do |v,i|
    row = i % HEIGHT
    v.split("").each_with_index do |c,col|
        if image[row][col] == -1 && c.to_i < 2
            image[row][col] = c.to_i
        end
    end
end

image.each do |r| 
    r.each {|v| printf("%s", v == 0 ? " " : "B") }
    printf("\n")
end