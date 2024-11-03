# Routine

## Overview

This project consists of a Go backend API and a Flutter frontend. The backend is a RESTful API, and the frontend is a
mobile application that interacts with the API. This guide provides instructions on how to set up and run the project
locally.

## Documentation

[Documentation](https://drive.google.com/drive/folders/1ZAmGGtibudneU68qirLa-FDqOuBvKO9z?usp=drive_link)

## Table of Contents

- [Prerequisites](#prerequisites)
- [Backend Setup](#backend)
    - [Backend Docs](#backend-docs)
    - [Integrations](#integrations)
    - [Environment Variables](#backend-environment-variables)
    - [Running the Backend](#running-the-backend)
   
- [Frontend Setup](#frontend-setup)
    - [Environment Variables](#frontend-environment-variables)
    - [Running the Frontend](#running-the-frontend)
- [License](#license)

## Prerequisites

Before running this project locally, ensure that you have the following installed:

- [Go](https://golang.org/dl/) (1.19 or higher)
- [Flutter](https://flutter.dev/docs/get-started/install) (2.x or higher)
- PostgreSQL (for the database)
- [Make](https://www.gnu.org/software/make/)

## Backend

### Backend Docs

[Documentation](https://routine-back.onrender.com/api/v1/swagger/index.html)

### Integrations
- GPT
  * link - https://console.groq.com/docs/overview
  * usage - for the user search on home
- Foods
   * link - https://trackapi.nutritionix.com/
   * usage - for search foods to meal of user diet

### Backend Environment Variables

Create a `.env` file in the backend root directory with the following structure:

```bash
ENV=dev
PORT=3007
DB_HOST=your_database_host
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_NAME=your_database_name
DB_PORT=5432
FOOD_API_HOST=
FOOD_API_KEY=
FOOD_APP_ID=
GPT_API_KEY=g
GPT_API_URL=
```

### Running the Backend

```bash
go mod tidy
make
```

## Frontend Setup

### Frontend Environment Variables

Create a `.env` file in the frontend root directory with the following structure:

```bash
URL_API=yourUrlApi
```

### Running the Frontend

```bash
flutter pub get
flutter run
```

### License

This project is licensed under the MIT License.

The key changes include:

1. **Fixed indentation for section headers** to ensure that links to those sections work.
2. **Clarified the environment variables section** in both the backend and frontend setup.

This should work properly with all links now rendering correctly.

