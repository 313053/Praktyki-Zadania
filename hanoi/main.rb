require_relative 'lib/hanoi'

# Klasa aplikacji 
class MainApp
  # Metoda rozpoczynająca działanie programu. 
  # Wykorzystuje liczbę całkowitą n pobraną w argumencie programu lub z konsoli
  #
  # @return [void]
  def run
    n = ARGV.empty? ? get_data : get_argument
    hanoi = Hanoi.new(n)
    hanoi.solve
  end

  # Metoda pomocnicza do pobierania rozmiaru wieży z konsoli. 
  # Jeśli nie da się przekonwertować getsa na int to ponownie drukuje prośbę
  #
  # @return [Integer] n - ilość klocków na wieży 
  def get_data
    puts "Podaj rozmiar wieży (UWAGA: od 13 w górę proces znacznie się wydłuża)"
    loop do
      input = gets.chomp
      begin
        n = Integer(input)
        if n <= 0
          puts "Wymagana jest liczba dodania!"
          next
        end
        return n
      rescue 
        puts "Wymagana jest liczba całkowita!"
      end
    end    
  end

  # Metoda pomocnicza do pobierania rozmiaru wieży z argumentu skryptu
  # Jeśli nie da się przekonwertować ARGV[0] na int to kończy program
  #
  # @return [Integer] n - ilość klocków na wieży 
  def get_argument
    arg = ARGV[0]

    begin
      n = Integer(arg).abs
      puts "Rozmiar wieży: #{n}."
      return n
    rescue
      puts "'#{arg}' nie jest liczbą całkowitą!"
      exit 1
    end
  end
end

main = MainApp.new
main.run