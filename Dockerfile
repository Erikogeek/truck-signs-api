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


# Convert the entrypoint script to Unix line endings
RUN sed -i 's/\r$//' /app/entrypoint.sh

# Make the entrypoint script executable
RUN chmod 755 /app/entrypoint.sh

# The port used by Gunicorn inside the container
EXPOSE 8000

# Start the application through the entrypoint script
ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
