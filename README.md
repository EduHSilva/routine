# Project Name

## Overview

This project consists of a Go backend API and a Flutter frontend. The backend is a RESTful API, and the frontend is a
mobile application that interacts with the API. This guide provides instructions on how to set up and run the project
locally.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Backend Setup](#backend-setup)
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

## Backend Setup

### Environment Variables

Create a `.env` file in the backend root directory with the following structure:

```bash
ENV=dev
PORT=3007
DB_HOST=your_database_host
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_NAME=your_database_name
DB_PORT=5432
```

### Running the Backend

```bash
go mod tidy
make
```

## Frontend Setup

### Environment Variables

Create a `.env` file in the frontend root directory with the following structure:

```bash
URL_API=yourUrlApi
```

### Running the Frontend

```bash
flutter pub get
flutter run
```
