FROM php:8.2-apache

LABEL maintainer="femto-code"
LABEL description="Raspberry Pi Dashboard - Dockerized"

# Install system utilities the dashboard uses via shell_exec / exec
RUN apt-get update && apt-get install -y \
    procps \
    usbutils \
    util-linux \
    lsb-release \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Allow www-data to run shutdown/reboot via sudo (optional feature)
RUN echo "www-data ALL=(ALL) NOPASSWD: /sbin/shutdown" >> /etc/sudoers

# Enable Apache mod_rewrite (not strictly required but good practice)
RUN a2enmod rewrite

# Copy project files into Apache web root
COPY . /var/www/html/

# Remove the installer script from the web root (not needed at runtime)
RUN rm -f /var/www/html/installer.sh

# Seed local.config with a valid empty PHP array so `require` returns []
# (an empty file returns 1 in PHP, which breaks array_replace_recursive)
RUN printf '<?php\nreturn array();\n?>\n' > /var/www/html/local.config \
    && chown www-data:www-data /var/www/html/local.config \
    && chmod 664 /var/www/html/local.config

# Fix ownership of the whole project
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html

EXPOSE 80
