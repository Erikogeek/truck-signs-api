FROM python:3.12-slim

WORKDIR /app

# install netcat for database
RUN apt-get update \
&& apt-get install -y --no-install-recommands netcat-openbsd\
&& rm -rf /var/lib/apt/list/*

COPY requirements.txt /app/requirements.txt

# install dependancies
RUN python -m pip install --no-cache-dir -r requirements.txt


COPY . /app

RUN chmod +x /app/entrypoint.sh


EXPOSE 8000

ENTRYPOINT ["/bin/sh" , "-c", "/app/entrypoint.sh"]
