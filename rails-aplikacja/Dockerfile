# Użycie Ubuntu jako bazowego obrazu
FROM ubuntu:22.04

# Aby uniknąć zapytań podczas instalacji
ENV DEBIAN_FRONTEND=noninteractive

# Instalowanie paczek
RUN apt-get update && \
    apt-get install -y \
        curl \
        gnupg2 \
        openssl \
        wkhtmltopdf \
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
        libpq-dev \
        imagemagick \
        autoconf \
        automake \
        libtool \
        postgresql-client \
        sqlite3 \
        pkg-config \
        libyaml-dev \
        gawk \
        git \
        bison && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


EXPOSE 3000

# Dodanie usera hosting
RUN useradd -ms /bin/bash hosting

# Przełączenie na hosting
USER hosting

# Ustalenie katalogu roboczego
WORKDIR /home/hosting


# Instalacja Nodejs
RUN curl -o- https://nodejs.org/dist/v16.20.1/node-v16.20.1-linux-x64.tar.xz | tar -xJ && \
    mv node-v16.20.1-linux-x64 /home/hosting/node && \
    echo 'export PATH=$HOME/node/bin:$PATH' >> /home/hosting/.bashrc

ENV PATH="/home/hosting/node/bin:${PATH}"

# Instalacja Yarn
RUN /bin/bash -l -c "curl -o- -L https://yarnpkg.com/install.sh | bash"

# Instalacja RVM i Ruby
# dodanie rvm do .bashrc
# bez autolibów! bo nie root
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-fail && \  
    /bin/bash -l -c "echo 'source /home/hosting/.rvm/scripts/rvm' >> /home/hosting/.bashrc && rvm install 3.3.4 && rvm use 3.3.4 --default"

# Instalacja bundlera i railsów
RUN /bin/bash -l -c "gem install bundler rails"


RUN mkdir -p /home/hosting/zadanie


# Domyślna komenda to bash
CMD ["bash", "-l"]