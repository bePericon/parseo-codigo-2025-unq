class MAIN
feature
   make
      do
         x := 5 + 3
         if x > 3 then
            print(x)
         else
            print("menor")
         end
         from
            i := 0
         until
            i = 3
         loop
            print(i)
            else
                print("ERROR")
            i := i + 1
         end
      end
end
