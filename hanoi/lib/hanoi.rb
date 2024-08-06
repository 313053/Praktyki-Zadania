class Hanoi

  # pobiera od użytkownika n i na podstawie tego tworzy warunki początkowe problemu
  def initialize(n)
    @n = n
    @rodA = Array.new(n) { |i| n - i }
    @rodB = []
    @rodC = []
  end

  # n - ilość krążków do przełożenia
  # rodA,rodB,C listy odpowiadające za kolejno słupek źródłowy, bufor, oraz docelowy
  def solve
    moves = 2**@n

    # Referencje do słupków, żeby w wypadku swapowania nie zmienić
    # rzeczywistej kolejności słupków (co by popsuło drukowanie)
    source = @rodA
    auxiliary = @rodB
    target = @rodC

    # Jeśli ilość krążków do przełożenia jest parzysta to algorytm
    # działa odwrotnie względem pomocniczego i docelowego słupka
    if @n.even?
      auxiliary, target = target, auxiliary
    end
    
    # Pętla wykonująca algorytm przekładania krążków w 3 powtarzalnych krokach
    # 1 krok - przeniesienie krążków między źrodłem i celem
    # 2 krok - między źródłem i pomocnikiem
    # 3 krok - między pomocnikiem i celem 
    moves.times do |i|
      puts "\nKROK #{i}"
      self.printHanoi
      from, to = case i % 3
        when 0 then [source, target]
        when 1 then [source, auxiliary]
        when 2 then [auxiliary, target]
        end

      moveDisk(from, to)
    end
  end

  # Funkcja wykonująca przenoszenie krążków między from i to.
  # Jeśli źrodło jest puste lub ma większy krążek od docelowego
  # to transakcja następuje odwrotnie.
  private
  def moveDisk(from, to)
    if from.empty?
      if to.empty?  # ważne, bo przez to w testach występował błąd (zamiast .empty było [nil])
        return      # pomimo faktu że nie zmieniało to w żaden sposób pożądanego wyniku
      end
      disk = to.pop
      from.push(disk)
    elsif to.empty?
      disk = from.pop
      to.push(disk)
    elsif from.last < to.last
      disk = from.pop
      to.push(disk)
    else
      disk = to.pop
      from.push(disk)
    end
  end

  # Funkcja drukująca aktualną wieżę hanoi.
  # area - obszar każdego słupka, czyli szerokość największego globalnego krążka
  # height - wysokość płótna, czyli suma wszystkich krążków plus jeden
  # rods - lista słupków
  # roof - zakropkowany sufit i podłoga danego rysunku
  private
  def printHanoi
    rods = [@rodA, @rodB, @rodC]
    area = [@rodA.max || 0, @rodB.max || 0, @rodC.max || 0].max
    height = @rodA.size + @rodB.size + @rodC.size + 1
    roof ="." * (((area+2)*3)+6)

    puts roof

    # Dla każdego wiersza tworzy tablicę stringów 'canvas', która zawiera trzy
    # stringi kolejno odpowiadającę za słupki A, B i C.
    # Na podstawie wielkości znajdującego się na danej wysokości klocka na słupku oblicza
    # ilość znaków w stringu odpowiadających za lewy i prawy padding, klocek "=", oraz słupek "|".
    # Po skończeniu wiersza drukuje canvas ze ścianami ":" po bokach, a na sam koniec drukuje podłogę.
    height.times do |i|
      row = height - 1 - i
      canvas = rods.map do |rod|
        block = rod[row] || 1
        totalSpaces = area - block
        leftSpace = totalSpaces / 2
        rightSpace = totalSpaces - leftSpace
        if rod[row].nil?
          " " * leftSpace + "|" + " " * rightSpace
        else
          " " * leftSpace + "=" * block + " " * rightSpace
        end
      end.join("   ")
      puts ":  " + canvas + "  :"
    end
    puts roof + "\n\n"
  end
end



