require_relative 'lib/hanoi'

class MainApp
  def run
    n = ARGV.empty? ? getData : getArgument
    hanoi = Hanoi.new(n)
    hanoi.solve
  end

  # Metoda pomocnicza do pobierania rozmiaru wieży z konsoli. 
  # Jeśli nie da się przekonwertować getsa na int to ponownie drukuje prośbę
  private
  def getData
    puts "Podaj rozmiar wieży (UWAGA: od 7 w górę ucina wizualizacje pierwszych kroków)"
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
  def getArgument
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