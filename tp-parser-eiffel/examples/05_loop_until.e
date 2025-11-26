class MAIN
feature
    make
        local
            i: INTEGER
        do
            i := 0
            from
                i := 0
            until
                i = 3
            loop
                print(i)
                i := i + 1
            end
        end
end