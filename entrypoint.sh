#!/usr/bin/env bash
set -e

# Use the appropriate project folder
cd /app/src

# set defauft database connection values if they are not provided
DB_HOST="${DB_HOST:-db}
DB_PORT="${DB_PORT:-5432}

echo "Waiting for postgres to connect ..."

# Check the database connection every five seconds
while ! nc -z "$DB_HOST" "$DB_PORT"; do
    echo "PostgresSQL is not ready yet. Retrying in 5 seconds"
    sleep(5)
done

echo "PostgreSQL is active."

# Apply database migrations before starting the application.
python manage.py migrate --noinput

echo "Database migrations completed."

# Create the superuser only when all required variables are configured
# and a user with the specified username does not already exist.

if [ -n "${DJANGO_SUPERUSER_USERNAME:-}" ] \
    && [ -n "${DJANGO_SUPERUSER_EMAIL:-}" ] \
    && [ -n "${DJANGO_SUPERUSER_PASSWORD:-}" ]; then

    if ! python manage.py shell -c \
        "import os; from django.contrib.auth import get_user_model; User = get_user_model(); raise SystemExit(0 if User.objects.filter(username=os.environ['DJANGO_SUPERUSER_USERNAME']).exists() else 1)"
    then
        python manage.py createsuperuser --noinput
        echo "Superuser created."
    else
        echo "Superuser already exists."
    fi
fi

# Collect static files for production.
python manage.py collectstatic --noinput

# Start Gunicorn once and forward container signals to it.
exec gunicorn tsa_app.wsgi:application --bind 0.0.0.0:8000 --workers 4
