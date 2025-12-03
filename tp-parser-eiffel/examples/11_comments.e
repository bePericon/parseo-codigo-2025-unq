class MAIN
feature
    make
        local -- Section to declaration variables
            a, b, c: INTEGER
        do
            a := 10
            b := 20
            c := a + b
            print(c) -- This line should to print: "30"
        end
end