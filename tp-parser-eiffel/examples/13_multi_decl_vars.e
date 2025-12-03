class MAIN
feature
    make
        local
            str: STRING
            a, b: INTEGER
            bool: BOOLEAN
            c: INTEGER
        do
            str := "El resultado es: "

            c := 10
            b := 200

            bool := true

            print(str)
            if bool then
                a := b + c
                print(a)
            else
                a := b + 2 * c
                print(a)
            end
        end
end