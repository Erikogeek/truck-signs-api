FROM python:3.12-slim

WORKDIR /app

# install netcat for database

# Use a lightweight Python 3.12 image
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Install netcat to wait for the database connection
RUN apt-get update \
    && apt-get install -y --no-install-recommends netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy the dependency list into the container
COPY requirements.txt /app/requirements.txt

# Install the Python dependencies
RUN python -m pip install --no-cache-dir -r /app/requirements.txt

# Copy the application files into the container
COPY . /app

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# The port used by Gunicorn inside the container
EXPOSE 8000

# Start the application through the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
