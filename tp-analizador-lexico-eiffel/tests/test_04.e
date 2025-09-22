class LOOP_EXAMPLE

feature
    counter: INTEGER

    count_to_five
        do
            from
                counter := 1
            until
                counter > 5
            loop
                print (counter)
                counter := counter + 1
            end
        end
end
