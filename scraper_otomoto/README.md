### Zadanie 3: Scraper Otomoto

### INSTRUKCJA

Aby uruchomić program wystarczy będąc w katalogu scraper_otomoto po zainstalowaniu gemów bundlerem wpisać komendę "ruby main.rb" z argumentami, lub bez.

Skrypt pobiera dane od użytkownika na dwa możliwe sposoby:

1) Jako argumenty przy wywoływaniu funkcji (np "ruby main.rb Toyota Corolla 4")

2) Jako argumenty podawane w konsoli

Jeśli użytkownik nie poda argumentów przy wywołaniu skryptu, to automatycznie wybierany jest sposób nr 2.

Po wykonaniu skryptu generowany w folderze output jest pdf oraz csv.


### TESTY

W rspecu zrobiony jest także jeden test sprawdzający poprawne działanie głównego algorytmu scrapowania.
Aby rozpocząć test należy jedynie wpisać w konsoli "rspec" będąc w folderze scraper_otomoto. Plik testu znajduje się w katalogu rspec.
