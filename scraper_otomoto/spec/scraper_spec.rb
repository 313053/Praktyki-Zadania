require_relative '../lib/scraper'

# Test sprawdza, czy scraper poprawnie zwraca dane.
# Ogłoszenia często się zmieniają, więc test sprawdza jedynie czy sprawdzane samochody
# Są zgodne z informacją wejściową
RSpec.describe Scraper, "#scrape" do
  it "scrapuje ogłoszenia z otomoto" do
    scraper = Scraper.new('Toyota','Corolla',1)
    scraped_data = scraper.scrape
    5.times do |index|
      expect(scraped_data[index][0]).to eq("Toyota")
      expect(scraped_data[index][1]).to include("Corolla")
    end
  end
end