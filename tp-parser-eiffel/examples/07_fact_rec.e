class FACT
feature
    factorial (n: INTEGER): INTEGER
        do
            if n = 0 then
                Result := 1
            else
                Result := n * factorial(n - 1)
            end
        end
end

class MAIN
feature
    make
        local
            f: FACT
        do
            create f
            print(f.factorial(5))
        end
end