FROM php:8.4-apache

ARG NEW_UID
ARG NEW_GID

WORKDIR /var/www/html

RUN a2enmod rewrite
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Configure Apache to log errors to stderr
RUN sed -i 's|ErrorLog .*|ErrorLog /dev/stderr|' /etc/apache2/apache2.conf \
    && sed -i 's|CustomLog .*|CustomLog /dev/stdout combined|' /etc/apache2/apache2.conf

RUN apt-get update && apt-get install -y --no-install-recommends \
    zip \
    unzip \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.8.2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN npm install -g npm@10.9.0

COPY ./services/dvp /var/www/html

RUN usermod -u $NEW_UID www-data && groupmod -g $NEW_GID www-data \
    && mkdir -p /var/www/html/node_modules /var/www/.npm /var/www/html/public/build /var/www/.composer \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/node_modules /var/www/.npm /var/www/html/public/build /var/www/.composer \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/node_modules /var/www/.npm /var/www/html/public/build /var/www/.composer


# Configure PHP to log errors to stderr
RUN echo "error_log = /dev/stderr" >> /usr/local/etc/php/conf.d/docker-php-error-log.ini \
    && echo "log_errors = On" >> /usr/local/etc/php/conf.d/docker-php-error-log.ini

EXPOSE 80

COPY ./docker/dvp/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER www-data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
