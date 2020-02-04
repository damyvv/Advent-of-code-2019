SITE_SIZE_X = 12
SITE_SIZE_Y = 12

(1..SITE_SIZE_Y).each do |y|
    printf("[")
    (1..SITE_SIZE_X).each do |x|
        printf("%i,", (rand()*10).floor()+5)
    end
    printf("],")
end
