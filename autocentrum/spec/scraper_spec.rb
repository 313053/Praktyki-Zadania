require_relative '../lib/scraper'
require 'csv'

# Test sprawdza, czy scraper poprawnie zwraca dane.
RSpec.describe Scraper do

  # Test sprawdzający scrapowanie podanej strony, porównuje wynik scrapowania do sprawdzonych danych
  # i jeśli jest taka potrzeba to pokazuje które elementy nie pasują do siebie
  describe '#scrape' do
    it "scrapuje informacje o samochodzie" do
      scraper = Scraper.new('assets/test_assets/links_test.txt')
      scraped_data = scraper.scrape_car('https://www.autocentrum.pl/dane-techniczne/fiat/500/iii/hatchback/silnik-elektryczny-23.8kwh-95km-od-2022/')
      expected_data = ["fiat","500","Fiat 500 III Hatchback 23.8kWh 95KM 70kW od 2022","3632 mm","1683 mm","1900 mm","1527 mm","2322 mm","brak danych","brak danych","120 mm","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","3","4","9.7 m","4.8 m","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","550 l","185 l","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","od 2022 roku","brak danych","elektryczny","95 KM (70 kW)","220 Nm","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","przekładnia zębatkowa ze wspomaganiem elektrycznym","185/65 R15","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","tarczowe wentylowane","bębnowe","brak danych","brak danych","22 mm","28 mm","257 mm","203 mm","niezależne typu McPherson, sprężyny śrubowe","belka skrętna","gazowe","automatyczna","brak danych","na przednią oś","brak danych","hydrokinetyczne","135 km/h","9.5 s","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","1256 kg","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","brak danych","1"]
      expect(scraped_data.size).to eq(expected_data.size)
      
      scraped_data.each_with_index do |item, index|
        expect(item).to eq(expected_data[index]), "Mismatch at index #{index}: expected #{expected_data[index].inspect}, got #{item.inspect}"
      end
    end
  end
  
  # Test sprawdzający scrapowanie wszystkich stron z pliku i tworzenie csv
  describe '#scrape_all' do
    
    # Po ukończeniu testu usuwa plik który stworzył na jego potrzeby
    after do
      path = 'output/test_output/scraped_data.csv'
      File.delete(path) if File.exist?(path)
    end
    
    # Wykonuje metodę scrap_all z ręcznie sprawdzonymi linkami po czym porównuje utworzony plik csv
    # z kontrolnym ręcznie utworzonym w formie tablic.  
    it "scrapuje informacje o samochodach z linków podanych w pliku" do
      scraper = Scraper.new('assets/test_assets/links_test.txt')
      scraper.scrape_all('test_output/scraped_data.csv')

      # Sortuje pliki csv, ponieważ przy wielowątkowości może wystąpić minimalna zmiana kolejności
      csv_new = CSV.read('output/test_output/scraped_data.csv', headers: true).sort_by { |row| row[0] }.map(&:to_a)
      csv_expected = CSV.read('output/test_output/test.csv', headers: true).sort_by { |row| row[0] }.map(&:to_a)
      
      expect(csv_new).to eq(csv_expected)
    end
  end
end