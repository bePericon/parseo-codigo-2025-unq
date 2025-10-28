class MAIN
feature
   make
      local
         x, y: INTEGER
      do
         x := 5 + 3
         if x > 3 and x < 6 then
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
            i := i + 1
         end
      end
end
