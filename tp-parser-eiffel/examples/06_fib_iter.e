class MAIN
feature
    make
        local
            a, b, t, i, n: INTEGER
        do
            n := 6
            a := 0
            b := 1
            from
                i := 0
            until
                i = n
            loop
                print(a)
                t := a + b
                a := b
                b := t
                i := i + 1
            end
        end
end