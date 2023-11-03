# Use an official PHP runtime as a parent image
FROM php:8.2-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install necessary packages
RUN apt-get update && \
    apt-get install -y gnupg unixodbc unixodbc-dev libtool libltdl-dev gcc g++ make autoconf pkg-config

# Import the Microsoft repository GPG keys
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Add the Microsoft SQL Server repository
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Update package lists and install the SQL Server ODBC Driver
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Install libltdl library
RUN apt-get install -y libltdl7

# Create a symbolic link for libltdl
RUN ln -sf /usr/lib/x86_64-linux-gnu/libltdl.so.7 /usr/lib/x86_64-linux-gnu/libltdl.so

# Install necessary PHP extensions with compatible versions
RUN pecl install sqlsrv-5.10.0 pdo_sqlsrv-5.10.0 && \
    docker-php-ext-enable sqlsrv pdo_sqlsrv
# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variables
ENV MYSQL_HOST culturebook
ENV MYSQL_USER cultureb_cb
ENV MYSQL_PASSWORD CHIjenny@1991
ENV SQLSRV_DATABASE cultureb_cb

# Start Apache when the container launches
CMD ["apache2-foreground"]
