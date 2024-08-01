# Użycie Ubuntu jako bazowego obrazu
FROM ubuntu:latest

# Instalowanie paczek
RUN apt-get update && \
    apt-get install -y \
        curl \
        gnupg2 \
        openssl \
        build-essential \
        libreadline-dev \
        zlib1g-dev \
        libncurses5-dev \
        libssl-dev \
        libsqlite3-dev \
        libxml2-dev \
        libgdbm-dev \
        libgmp-dev \
        libnss3-dev \
        libffi-dev \
        libncursesw5-dev \
        autoconf \
        automake \
        libtool \
        sqlite3 \
        pkg-config \
        libyaml-dev \
        gawk \
        bison && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Dodanie usera hosting
RUN useradd -ms /bin/bash hosting

# Przełączenie na hosting
USER hosting

# Ustalenie katalogu roboczego
WORKDIR /home/hosting

# Instalacja RVM i Ruby
# dodanie rvm do .bashrc
# bez autolibów
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-fail && \  
    /bin/bash -l -c "echo 'source /home/hosting/.rvm/scripts/rvm' >> /home/hosting/.bashrc && rvm install 3.3.4 && rvm use 3.3.4 --default"

RUN mkdir -p /home/hosting/volume1


# Domyślna komenda to bash
CMD ["bash", "-l"]