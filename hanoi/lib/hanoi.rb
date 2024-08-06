# klasa odpowiadająca za funkcjonalność wieży hanoi 
class Hanoi

  # Konstruktor pobierający od użytkownika n i na podstawie tego
  # tworzący warunki początkowe problemu.
  #
  # @param [Integer] n - liczba klocków do zainicjowania
  # @return [Hanoi] nowa instancja klasy Hanoi
  def initialize(n)
    @n = n
    @rod_A = Array.new(n) { |i| n - i }
    @rod_B = []
    @rod_C = []
  end


  # Metoda rozwiązująca problem wieży hanoi z wizualizacją
  # 
  # @return [void]
  def solve
    moves = 2**@n

    # Referencje do słupków, żeby w wypadku swapowania nie zmienić
    # rzeczywistej kolejności słupków (co by popsuło drukowanie)
    source = @rod_A
    auxiliary = @rod_B
    target = @rod_C

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
      case
      when @n < 6     # animacja, której FPS zależy od liczby klocków do przestawienia 
        sleep(0.1)
      when @n < 8
        sleep(0.05)
      when @n < 10
        sleep(0.01)
      when @n < 12
        sleep(0.005)
      end
      system("clear")
      self.print_Hanoi
      from, to = case i % 3
        when 0 then [source, target]
        when 1 then [source, auxiliary]
        when 2 then [auxiliary, target]
        end

      move_disk(from, to)
    end
  end

  # Funkcja wykonująca przenoszenie krążków między from i to.
  # Jeśli źrodło jest puste lub ma większy krążek od docelowego
  # to transakcja następuje odwrotnie.
  #
  # @param [Array<Integer>] from - pierwszy słupek (domyślnie źrodłowy)
  # @param [Array<Integer>] to - drugi słupek (domyślnie docelowy)
  #
  # @return [void]
  def move_disk(from, to)
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
  #
  # @return [void]
  def print_Hanoi
    rods = [@rod_A, @rod_B, @rod_C]
    area = [@rod_A.max || 0, @rod_B.max || 0, @rod_C.max || 0].max
    height = @rod_A.size + @rod_B.size + @rod_C.size + 1
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
        total_spaces = area - block
        left_space = total_spaces / 2
        right_space = total_spaces - left_space
        if rod[row].nil?
          " " * left_space + "|" + " " * right_space
        else
          " " * left_space + "=" * block + " " * right_space
        end
      end.join("   ")
      puts ":  " + canvas + "  :"
    end
    puts roof + "\n\n"
  end
end



