require_relative 'lib/scraper'

# Klasa odpowiedzialna za działanie programu
#
# @return [Void]
class Main
  
  # Metoda tworząca obiekt skrapera i inicjująca scrapowanie
  #
  # @return [Void]
  def run()
    scraper = Scraper.new
    scraper.scrape_all
  end
end


app = Main.new
app.run