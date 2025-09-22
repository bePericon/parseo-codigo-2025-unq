class PERSON

feature
    name: STRING
    age: INTEGER

    set_age (new_age: INTEGER)
        do
            age := new_age
        end

    is_adult: BOOLEAN
        do
            if age >= 18 then
                Result := True
            else
                Result := False
            end
        end
end
