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
    passwd \
    vcgencmd \
    || apt-get install -y libraspberrypi-bin \
    && rm -rf /var/lib/apt/lists/*

# (Optional) Ensure vcgencmd is in the PATH if installed in /opt/vc/bin
ENV PATH="/opt/vc/bin:${PATH}"

# Grant www-data access to the video group (required for vcgencmd)
RUN usermod -aG video www-data

# Allow www-data to run shutdown/reboot via sudo (optional feature)
RUN echo "www-data ALL=(ALL) NOPASSWD: /sbin/shutdown" >> /etc/sudoers

# Enable Apache mod_rewrite (not strictly required but good practice)
RUN a2enmod rewrite

# Copy project files into Apache web root
COPY . /var/www/html/

# Remove the installer script from the web root (not needed at runtime)
RUN rm -f /var/www/html/installer.sh

# Copy and prepare the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Fix ownership of the whole project
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html

EXPOSE 80

# Use custom entrypoint to seed + symlink local.config before Apache starts
ENTRYPOINT ["/entrypoint.sh"]
