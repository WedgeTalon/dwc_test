# DWC Customer Management Assessment Project

## Overview
This project is a customer management system built using the following technologies:
- ![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
- ![Vue.js](https://img.shields.io/badge/Vue.js-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white)
- ![Vuetify](https://img.shields.io/badge/Vuetify-1867C0?style=for-the-badge&logo=vuetify&logoColor=white)
- ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
- ![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

## Prerequisites
- Docker Desktop

### Download Docker Desktop
1. Visit the [Docker Desktop download page](https://www.docker.com/products/docker-desktop).
2. Download and install Docker Desktop for your operating system.
3. Follow the installation instructions provided on the Docker website.

## Installation

### Clone the Repository
```sh
git clone https://github.com/yourusername/dwc_test.git
cd dwc_test
```

### Using Docker Compose
1. Ensure Docker Desktop is running.
2. In the project directory, run the following command to start the containers:
   ```sh
   docker-compose up -d --build
   ```

### First Run Instructions
1. Install PHP dependencies:
   ```sh
   docker-compose exec php composer install
   ```
2. Install Node.js dependencies:
   ```sh
   docker-compose exec php npm install
   ```
3. Build the frontend:
   ```sh
   docker-compose exec php npm run build
   ```
4. Migrate the database:
   ```sh
   docker-compose exec php php artisan migrate
   ```
5. Seed the Database
   ```sh
   docker-compose exec php php artisan db:seed --class=CustomerSeeder
   ```

### Accessing the Website
- Open your web browser and navigate to [http://localhost:8080](http://localhost:8080) or [https://localhost](https://localhost).

### Accepting Self-Signed Certificates
When accessing [https://localhost](https://localhost), you may encounter a security warning due to the self-signed SSL certificate used in this local environment. To proceed safely:

1. When the warning appears, look for an option to continue to the website. This is usually labeled as "Advanced" or "Proceed anyway" depending on your browser.
2. Confirm that you're accessing `https://localhost` and accept the self-signed certificate to continue.

### Accessing the Database Tool
- Open your web browser and navigate to [http://localhost:9090](http://localhost:9090).

### Stopping the Docker Containers
When you are done, you can stop the running containers with the following command:
```sh
docker-compose down