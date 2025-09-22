class MYCLASS
feature
    x := 5
    y := x + 10
    main do
        if x then
            y := y + 1
        else
            y := y - 1
        end
    end
end