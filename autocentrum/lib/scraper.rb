# frozen_string_literal: true

require 'concurrent-ruby'
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'csv'
require 'wicked_pdf'

# Klasa odpowiadająca za funkcjonalność scrapera
class Scraper

  # Konstruktor, który automatycznie pobiera opdowiednie adresy i pola do przesukiwania z plików w folderze 'assets'
  def initialize()
    @links = File.readlines('assets/links.txt', chomp: true)
    @fields = File.read('assets/fields.txt',  encoding: 'UTF-8').split(',')
  end

  # Metoda do scrapowania wybranej strony samochodu
  #
  # @param [String] url - strona do zescrapowania
  # @param [Integer] retries - maksymalna ilość powtórnych zapytań 
  #
  # @return [Array<String>] Metoda zwraca tablicę zescrapowanych danych w kolejności zgodnej z formatem csv
  def scrape_car(url, retries = 3)
    value_array = []
    
    begin
      html = URI.open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER).read
      noko_doc = Nokogiri::HTML(html)
      url_segments = url.split('/') # Podział url strony na segmenty

      value_array << url_segments[4].gsub('-',' ')  # Dodanie do pola 'marka' nazwy marki wyciętej z adresu strony
      value_array << url_segments[5] # Dodanie do pola 'model' nazwy modelu wyciętej z adresu strony
      value_array << noko_doc.search("h1.site-title").text.gsub('Dane techniczne ', '') # Dodanie do pola 'pełna nazwa' zawartości nagłówka strony
      
      # Pomija scrapowanie jeśli przez przypadek otrzymał niefinalną stronę danego auta
      if value_array[2].include?("wybierz silnik")
        return []
      end
      
      # Dodaje wartości pól do tablicy, jeśli nie ma takiego pola lub wartości to dodaje 'brak danych' 
      @fields[3..-1].each do |field|
        result = noko_doc.xpath("//div[@data-label='#{field}']/following-sibling::div[1]//div[1]/following-sibling::span[1]").text
        if result == '' 
          result = 'brak danych'
        end 
        value_array << result
      end
      return value_array
    
    # W przypadku problemu wypisuje go do tablicy i próbuje nawiązać ponownie zakończenie dozwoloną ilość razy
    rescue StandardError => e
      if retries > 0
        sleep(2)
        scrape_car(url, retries - 1)
      else
        puts "Failed to connect after retries: #{e.message}"
        return []
      end
    end
  end

  # Metoda do scrapowania wszystkich aut i wrzucania na bierząco do pliku CSV
  #
  # @return [Void]
  def scrape_all()
    final_array = []
    progress = 0
    max_percentage = -1
    mutex = Mutex.new

    # Otwiera plik csv i tworzy pulę wątków
    CSV.open('output/dane_aut.csv', 'w', col_sep: ',', write_headers: true, headers: @fields, force_quotes: true, encoding: 'UTF-8') do |csv|
      pool = Concurrent::FixedThreadPool.new(50)
      
      # Dla każdego adresu url skrapuje stronę osobnym wątkiem i przy użyciu mutexu wrzuca wyniki do csv
      # w sposób zsynchronizowany, inkrementuje licznik postępu oraz wywołuje metodę do jego drukowania.
      @links.each do |link|
        pool.post do
          scraped = scrape_car(link)
          mutex.synchronize do
            progress += 1
            max_percentage = loading_screen(progress, max_percentage)
            if !(scraped.empty?)
              begin
                csv << scraped
              rescue StandardError => e
                puts e
              end
            end
          end
        end
      end
      pool.shutdown
      pool.wait_for_termination
    end
  end


  # Metoda do drukowania aktualnego postępu w procentach.
  # W tym przypadku nie czyści na bieżąco konsoli, aby nie usuwać potencjalnych drukowanych błędów.
  # Oblicza aktualny postęp w procentach, i jeśli jest większy o przynajmniej 1% od wcześniej wydrukowanego,
  # to go drukuje i zwraca jego wartość
  #
  # @param [Integer] progress - ilość zescrapowanych stron dotychczas
  # @param [Integer] max_percentage - maksymalna dotychczas wartość procentowa postępu
  #
  # @return [Integer] zwraca stare lub potencjalnie nowe maksimum postępu
  def loading_screen(progress, max_percentage)
    percentage = (progress * 100 / @links.size)
    if percentage > max_percentage
      puts "#{percentage}%"
      return percentage
    end
    return max_percentage
  end

end
