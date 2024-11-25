FROM dunglas/frankenphp

# add additional extensions here:
RUN install-php-extensions \
	opcache \
	gd \
    curl \
	intl \
    json \
    mbstring \
    openssl \
    pcntl \
	pdo_pgsql \
    session \
    fileinfo \
    xml \
	zip

ENV http_proxy=""
ENV https_proxy=""
ENV no_proxy=""

# Install npm and Node
RUN apt-get update --fix-missing && \
    apt-get install -y npm nodejs
    
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Laravel installer
RUN composer global require laravel/installer

# Add composer to PATH
ENV PATH="/config/composer/vendor/bin:${PATH}"

# Set the working directory
WORKDIR /app

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Start command
CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]