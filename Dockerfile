FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
# get composer installed
RUN apt update -y && apt-get install git composer -y
# install apache2
RUN apt install apache2 -y
# EXPOSE the service
EXPOSE 80
# use /var/www/html as workdir
WORKDIR /var/www/html/
# git clone the repo 
RUN git clone https://github.com/f1amy/laravel-realworld-example-app.git
# change work dir
WORKDIR /var/www/html/laravel-realworld-example-app
# install the dependencies
RUN apt install php libapache2-mod-php php8.1-mysql php8.1-common php8.1-mysql php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-dev php8.1-imap php8.1-mbstring php8.1-opcache php8.1-soap php8.1-zip php8.1-intl -y
# composer install
RUN composer install --no-interaction
# copy a sample of .env
COPY .env.example .env
# generate the key
RUN php artisan key:generate
# give necessary permission
RUN chown -R :www-data /var/www/html/laravel-realworld-example-app/ && chmod -R 775 /var/www/html/laravel-realworld-example-app/ && chmod -R 775 /var/www/html/laravel-realworld-example-app/storage/
# copy conf file
COPY laravel-realworld-example-app.conf /etc/apache2/sites-available/
COPY routes/web.php routes/web.php
# configure apache properly
RUN a2dissite 000-default.conf 
RUN a2ensite laravel-realworld-example-app.conf 
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
