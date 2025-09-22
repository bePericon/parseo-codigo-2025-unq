class LOOP_TEST

feature
    n: INTEGER

    factorial
        local
            result: INTEGER
        do
            from
                result := 1
            until
                n = 0
            loop
                result := result * n
                n := n - 1
            end
            print (result)
        end
end
