class COUNTER
feature
    value: INTEGER
    
    inc
        do
            value := value + 1
        end
end

class MAIN
feature
    make
        local
            c: COUNTER
        do
            create c
            c.value := 5
            c.inc
            print(c.value)
        end
end