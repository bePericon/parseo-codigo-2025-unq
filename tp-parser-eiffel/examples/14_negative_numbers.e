class MAIN
feature
    make
        local
            positive, negative: INTEGER
            x: INTEGER
        do

            positive := 100
            negative := -30
            x := -25

            print(positive) -- 100
            print(negative) -- -30
            print(x - negative) -- (-25) - (-30) = 5
            print(x - positive) -- (-25) - 100 = -125 
        end
end