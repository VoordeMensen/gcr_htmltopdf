#Import the image with basic ubuntu system and php along with extensions installed.
FROM sandymadaan/php7.3-docker

# Copy local code to the container image.
COPY . /var/www/html/

# Use the PORT environment variable in Apache configuration files.
RUN sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Authorise .htaccess files
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/var/www/html/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# install libssl
RUN apt-get -y update
RUN apt-get -y install xvfb build-essential libssl-dev libfontconfig1 libxrender1 fontconfig libjpeg62-turbo xfonts-75dpi xfonts-base

# better wktohtml
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.stretch_amd64.deb 
RUN dpkg -i wkhtmltox_0.12.6-1.stretch_amd64.deb
RUN apt -f install

RUN composer install -n --prefer-dist --ignore-platform-reqs

EXPOSE 8080

# Restart apache2
RUN service apache2 restart
