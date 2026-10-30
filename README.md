<div align="center">

# Signs for Trucks

![Python version](https://img.shields.io/badge/Python-3.12.0-4c566a?logo=python&&longCache=true&logoColor=white&colorB=pink&style=flat-square&colorA=4c566a) ![Django version](https://img.shields.io/badge/Django-5.2.8-4c566a?logo=django&&longCache=truelogoColor=white&colorB=pink&style=flat-square&colorA=4c566a) ![Django-RestFramework](https://img.shields.io/badge/Django_Rest_Framework-3.16.1-red.svg?longCache=true&style=flat-square&logo=django&logoColor=white&colorA=4c566a&colorB=pink)

![Truck Signs](./src/screenshots/Truck_Signs_logo.png)

__Signs for Trucks__ is an online store to buy pre-designed vinyls with custom lines of letters (often call truck letterings).
The store also allows clients to upload their own designs and to customize them on the website as well.

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
    - [Overview](#Overview)
    - [The goal of this project](#The-goal-of-this-project)
    - [Project structure](#Project-structure)
    - [project status](#project-status)
    - [Prerequisites](#prerequisites)
    - [Quickstart](#quickstart)
    - [Usage](#usage)
    

## Overview
Truck Signs API v2 is a RESTful backend application designed to manage truck signs.

The application uses Django REST Framework to provide API functionality and PostgreSQL as its relational database.

The backend runs inside a Docker container and is served by Gunicorn. Docker Compose manages the application and database services.

The project also includes automated code quality checks and Django tests using GitHub Actions.

## Project goal
The goal of this project is to run the Truck Signs API and its PostgreSQL database using Docker Compose.

The existing Dockerfile, Docker Compose configuration, and entrypoint script were reviewed and adjusted to provide a reproducible containerized environment.

The application startup process includes database connectivity checks, database migrations, optional superuser creation, static file collection, and Gunicorn startup

### Project structure
The main project files include:
* src/ — Django application source code.
* Dockerfile — Builds the backend Docker image.
* docker-compose.yml — Configures the backend and PostgreSQL services.
* requirements.txt — Python dependencies.
* entrypoint.sh — Prepares and starts the Django application.
* example.env — Example environment variables.
* .gitignore — Prevents sensitive and generated files from being committed.
* .dockerignore — Reduces the Docker build context.
* .github/workflows/ — GitHub Actions workflows.

## project status
The following project components have been implemented/adjusted and tested:
* Docker image build.
* Docker Compose backend and database services.
* PostgreSQL connectivity.
* Automatic database migrations.
* Optional superuser creation..
* Static file collection.
* Gunicorn startup.
* Git version control and feature branch workflow.
* GitHub Actions checks.
* Pull request review workflow.

## Prerequisites
The following tools are required:
- Git
- Docker
- Docker Compose
- GitHub account for repository access and workflows.

Python 3.12 is used by the backend Docker image.

## Quickstart

1. Clone the repo:
```bash
git clone git@github.com:Developer-Akademie-DevSecOpsKurs/truck-signs-api.git
cd truck-signs-api
```
2. Copy the content of the example.env file into a .env file:
```bash
cp example.env .env / Copy-Item example.env .env
```
3. Build the Docker image and start the application
```bash
docker build -t truck-signs-api:test .
docker-compose build
```
To start the application use the following command:
```bash
docker-compose up -d
```
Docker Compose starts the backend and PostgreSQL services.

The backend entrypoint waits for PostgreSQL, applies migrations, optionally creates the configured superuser, collects static files, and starts Gunicorn.

4. Check the configuration and logs of running container
```bash
docker logs -f backend
docker logs db
docker compose config --images
```
5. Access the application
After the container running the `Django Admin is reachable` under 

`http://<YOUR_IP>:8020/admin`.

## Usage
After starting the application with Docker Compose, the API can be accessed locally.
- Access the Django Admin
```text
http://<YOUR_IP>:8020/admin
```
Log in using the superuser credentials configured in your `.env` file like the table.

| variables | example |
| --------- | ------- |
| DJANGO_SUPERUSER_USERNAME | superuser |
| DJANGO_SUPERUSER_EMAIL|developerakademie@yahoo.com|
| DJANGO_SUPERUSER_PASSWORD | admin_password123 |

* API Endpoints
The API provides endpoints for categories, products, product variations, colors, truck logos, orders, payments, comments, and customer image uploads.

The following endpoints are defined in the `tsa_products` URL configuration.

| HTTP Method | Endpoint | Description |
|---|---|---|
| GET | `/categories/` | Retrieve product categories |
| GET | `/lettering-item-categories/` | Retrieve lettering item categories |
| GET | `/products/` | Retrieve the product list |
| GET | `/product-category/<id>/` | Retrieve products by category |
| GET | `/product-variation-retrieve/<id>/` | Retrieve a product variation |
| GET | `/product-color/` | Retrieve available product colors |
| GET | `/product-detail/<id>/` | Retrieve product details |
| GET | `/truck-logo-list/` | Retrieve available truck logos |
| POST | `/order/<id>/create/` | Create an order |
| GET | `/order/<id>/retrieve/` | Retrieve an order |
| GET / POST | `/order-payment/<id>/` | Handle order payment |
| GET | `/comments/` | Retrieve comments |
| POST | `/comment/create/` | Create a comment |
| POST | `/upload-customer-image/` | Upload a customer image |

**Note:** The HTTP methods shown are typical for these operations. Check the corresponding Django views to confirm the exact supported methods and request parameters.

The endpoint paths above are relative to the API URL prefix configured in the main Django URL configuration.

Use a web browser or Postman to test the API endpoints.

- Run the Application

    - Start the services:
```bash
docker compose up -d
```
- Check the running containers:
```bash
docker compose ps
```
View backend logs:
```bash
docker compose logs -f backend
```
- Stop the application:
```bash
docker compose down
```
- Django Management Commands

Execute Django commands inside the backend container:
```bash
docker compose exec backend python manage.py showmigrations
```
Run the Django test suite:
```bash
docker compose exec -w /app/src backend python manage.py test --verbosity=2
```
* Github Actions
GitHub Actions is used to automate project checks and tests.

The workflows are located in:
- `.github/workflows/`
They help verify the project changes before they are merged through a pull request.