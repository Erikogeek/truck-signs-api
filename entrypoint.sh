#!/usr/bin/env bash
set -e

# Use the appropriate project folder
cd /app/src

# Set default database connection values if they are not provided
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-5432}"

echo "Waiting for PostgreSQL to connect ..."

# Check the database connection every five seconds
while ! nc -z "$DB_HOST" "$DB_PORT"; do
    echo "PostgreSQL is not ready yet. Retrying in 5 seconds."
    sleep 5
done

echo "PostgreSQL is active."

# Apply database migrations before starting the application
python manage.py migrate --noinput

echo "Database migrations completed."

# Create the superuser only when all required variables are configured.
if [ -n "${DJANGO_SUPERUSER_USERNAME:-}" ] && [ -n "${DJANGO_SUPERUSER_EMAIL:-}" ] && [ -n "${DJANGO_SUPERUSER_PASSWORD:-}" ]; then

    # Check whether the user already exists.
    if python manage.py shell -c "import os; from django.contrib.auth import get_user_model; User = get_user_model(); raise SystemExit(0 if User.objects.filter(username=os.environ['DJANGO_SUPERUSER_USERNAME']).exists() else 1)"; then
        echo "Superuser already exists."
    else
        # Create the superuser with the configured password.
        python manage.py shell -c "import os; from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser(username=os.environ['DJANGO_SUPERUSER_USERNAME'], email=os.environ['DJANGO_SUPERUSER_EMAIL'], password=os.environ['DJANGO_SUPERUSER_PASSWORD']); print('Superuser created.')"
    fi
else
    echo "Superuser creation skipped: required environment variables are missing."
fi

# Collect static files for production
python manage.py collectstatic --noinput

# Start Gunicorn and forward container signals to it
exec gunicorn tsa_app.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 4