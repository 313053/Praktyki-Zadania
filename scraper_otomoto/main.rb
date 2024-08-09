# frozen_string_literal: true

require_relative './lib/scraper'

# Klasa Aplikacji
class MainApp

  # Metoda odpowiadająca za przebieg programu. Najpierw pobiera argumenty, potem tworzy obiekt
  # klasy 'scraper' i przy użyciu argumentów scrapuje dane i wrzuca je do pdf oraz csv.
  #
  # @return [Void]
  def run
    brand = ARGV.empty? ? get_data('brand') : ARGV[0]
    model = ARGV[1].nil? ? get_data('model') : ARGV[1]
    pages = ARGV[2].nil? ? get_data('pages') : get_int_argument
    scraper = Scraper.new(brand, model, pages)
    scraped_data = scraper.scrape
    scraper.to_pdf(scraped_data)
    #scraper.to_csv(scraped_data)
  end

  # Metoda do pobierania poszczegółnych inputów z konsoli, w przypadku 'pages',
  # czyli Inta pobiera w pętli aż nie dostanie dodatniej liczby całkowitej
  # @param [String] var - rodzaj parametru do pobrania
  #
  # @return [Integer, String] zwraca Inta lub Stringa w zależności od obsługiwanego argumentu
  def get_data(var)
    case var
    when 'pages'
      puts 'Podaj ilość stron do przeszukania:'
      loop do
        input = gets.chomp
        begin
          pages = Integer(input)
          if pages <= 0
            puts 'Wymagana jest liczba dodania!'
            next
          end
          return pages
        rescue StandardError
          puts 'Wymagana jest liczba całkowita!'
        end
      end
    when 'brand'
      puts 'Podaj nazwę marki:'
    when 'model'
      puts 'Podaj nazwę modelu:'
    end
    input = gets.chomp
    return unless input.length.positive? && input != [nil]

    input
  end

  # Metoda do pobrania intowego argumentu podanego przy wywołaniu skryptu
  #
  # @return [Integer]
  def get_int_argument
    arg = ARGV[2]

    begin
      Integer(arg).abs
    rescue StandardError
      puts "'#{arg}' nie jest liczbą całkowitą!"
      exit 1
    end
  end
end

app = MainApp.new
app.run