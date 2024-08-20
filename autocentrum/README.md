### Zadanie 4: Scraper Autocentrum

### INSTRUKCJA

Aby uruchomić program wystarczy będąc w katalogu autocentrum po zainstalowaniu gemów bundlerem wpisać komendę "ruby main.rb".

Program pobiera adresy stron do przeszukania z pliku links.txt znajdującego się w folderze assets (lub z własnoręcznie podanego w kodzie url pliku).
Poszukiwane pola do scrapowania są zawarte w tym samym folderze co linki, w pliku fields.txt.

Po wykonaniu skryptu generowany w folderze output jest plik csv.

Jeśli sprawdzenie wszystkich linków jest zbyt czasochłonne (u mnie trwało ok. godzinę) to wystarczy zmiejszyć ilość linków w pliku
links.txt lub zwiększyć liczbę wątków w kodzie (na własną odpowiedzialność!)



### TESTY

W rspecu zrobione są także dwa testy sprawdzające poprawne działanie scrapowania pojedyńczych stron oraz wszytkich linków.
Aby rozpocząć testy należy jedynie wpisać w konsoli "rspec" będąc w folderze autocentrum. Plik testu znajduje się w katalogu rspec.
