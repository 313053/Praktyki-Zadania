# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'csv'
require 'wicked_pdf'
# require 'wkhtmltopdf-binary'

# Klasa odpowiadająca za scrapera przy użyciu Nokogiri
class Scraper

  # Konstruktor scrapera. W parametrach przyjmuje nazwę marki, modelu i liczbę stron do przeszukania,
  # po czym formatuje nazwy i tworzy z nich adres podstrony w otomoto.pl
  #
  # @param [String] brand - nazwa marki samochodu
  # @param [String] model - nazwa modelu samochodu
  # @param [Integer] pages - nazwa marki samochodu
  #
  # @return [Void]
  def initialize(brand, model, pages)
    @brand = brand.include?(' ') ? brand.gsub(' ', '-').downcase : brand.downcase
    @model = model.include?(' ') ? model.gsub(' ', '-').downcase : model.downcase
    @pages = pages
    @url = "https://www.otomoto.pl/osobowe/#{@brand}/#{@model}"
  end

  # Metoda odpowiadająca za funkcjonalność scrapera. Iteruje po podanej liczbie stron, pobierając
  # z dynamicznie tworzonego linku stronę html, konwertując ją na dokument Nokogiri, pobierając z niego 
  # odpowiednie dane przy użyciu filtrów na bazie xpath, oraz dodając te dane do tablicy w odpowiednim formacie. 
  #
  # @return [Array<String>] zescrapowane dane
  def scrape()
    final_array = []

    (1..@pages).each do |page|
      page_url = @url + "?page=#{page}"
      html = URI.open(page_url.to_s).read
      noko_doc = Nokogiri::HTML(html)

      # Wyszukiwanie xpathem po lokacji, bo nazwy klas mogą się często zmieniać jeśli są generowane automatycznie
      xpath_name = "//article[@data-orientation='horizontal']//section//div[2]//h1"
      xpath_mileage = "//article[@data-orientation='horizontal']//section//div[3]//dl[1]//dd[@data-parameter='mileage']"
      xpath_fuel = "//article[@data-orientation='horizontal']//section//div[3]//dl[1]//dd[@data-parameter='fuel_type']"
      xpath_gearbox = "//article[@data-orientation='horizontal']//section//div[3]//dl[1]//dd[@data-parameter='gearbox']"
      xpath_year = "//article[@data-orientation='horizontal']//section//div[3]//dl[1]//dd[@data-parameter='year']"
      xpath_photo = "//article[@data-orientation='horizontal']//section//div[1]//img"

      noko_doc.xpath(xpath_name).each_with_index do |element, index|
        temp_array = []
        element = element.text
        temp_array << @brand.capitalize
        temp_array << element[@brand.length + 1..]
        [xpath_mileage, xpath_fuel, xpath_gearbox, xpath_year].each do |parameter|
          temp_array << noko_doc.xpath(parameter)[index].text
        end
        temp_array << noko_doc.xpath(xpath_photo)[index]['src']

        final_array << temp_array
      end
    end
    final_array.sort
  end

  # Metoda odpowiedzialna za spakowanie zescrapowanych danych do pliku csv
  #
  # @param [Array<Array<String>>] data_array - tablica 2D wszystkich danych zescrapowanych ze strony
  #
  # @return [Void]
  def to_csv(data_array)
    path = 'output/otomoto.csv'
    csv_options = { col_sep: ',', write_headers: true,
                    headers: ['Marka', 'Model', 'Przebieg', 'Rodzaj Paliwa', 'Skrzynia Biegów', 'Rok Produkcji', 'Zdjęcie'], force_quotes: true }

    CSV.open(path, 'w', **csv_options) do |csv|
      data_array.each do |line|
        csv << line
      end
    end
  end

  # Metdoda odpowiedzialna za tworzenie HTMLa z zescrapowanych danych. Dane dodawane są z tablicy w div'ach.
  #
  # @param [Array<Array<String>>] data_array - tablica wszystkich danych zescrapowanych ze strony
  #
  # @return [String] zwraca string zawierający utworzony HTML
  def to_html(data_array)
    html_content = <<-HTML.encode('UTF-8')
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <title>otomoto</title>
        <style>
          body {
            background-image: url('https://raw.githubusercontent.com/313053/Praktyki-Zadania/main/assets/watermark2.png');
            background-repeat: repeat;
            background-position: relative;
            background-size: cover;
            width: 210mm;
            height: 297mm;
            margin: 0;
            padding: 0;
          }
          table {
            width: 100%;
            border-collapse: collapse;
            margin: auto
          }     
          th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
          }
          th {
            background-color: #dbdbdb;
          }
          img {
            max-width: 150px;
            height: auto;
          }
        </style>
      </head>
      <body>
        <table>
          <thead>
            <tr>
              <th>Marka</th>
              <th>Model</th>
              <th>Przebieg</th>
              <th>Napęd</th>
              <th>Skrzynia</th>
              <th>Rok</th>
              <th>Zdjęcie</tr>
            </tr>    
          </thead>
          <tbody>
    HTML

    data_array.each_with_index do |_element, index|
      html_content += '     <tr>'
      data_array[index][0...-1].each do |text|
        html_content += '<td>' + text + '</td>'
      end
      html_content += "<td><img src=\"#{data_array[index][-1]}\" alt=\"zdjęcie samochodu\"></td>"
      html_content += '</tr>'
    end

    html_content += <<-HTML.encode('UTF-8')
        </tbody>
      </table>
      </body>
      </html>
    HTML

    html_content
  end

  # Metoda konwertująca zescrapowane dane do pdf używając wicked_pdf i metody to_html
  #
  # @param [Array<Array<String>>] data_array - tablica wszystkich danych zescrapowanych ze strony
  #
  # @return [Void]
  def to_pdf(data_array)
    path = 'output/otomoto.pdf'
    html_content = to_html(data_array)
    pdf = WickedPdf.new
    pdf_file = pdf.pdf_from_string(html_content)

    File.open(path, 'w') do |file|
      file << pdf_file
    end
  end
end

