class BOOLEAN_EXAMPLE

feature
    flag: BOOLEAN

    check_flag
        do
            if flag then
                print ("Flag is True%N")
            else
                print ("Flag is False%N")
            end
        end
end
