class MAIN
feature
    make
        local
            x: INTEGER
        do
            x := 4
            if x > 0 then
                print("positivo")
            else
                print("no positivo")
            end
        end
end