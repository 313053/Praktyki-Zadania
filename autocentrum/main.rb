require_relative 'lib/scraper'

# Klasa odpowiedzialna za działanie programu
#
# @return [Void]
class Main
  
  # Metoda tworząca obiekt skrapera i inicjująca scrapowanie
  #
  # @param [String] link_file - lokalne url pliku z adresami stron do przeszukania
  #
  # @return [Void]
  def run(link_file)
    scraper = Scraper.new(link_file)
    scraper.scrape_all('dane_aut.csv')
  end
end


app = Main.new
app.run('assets/links.txt')