# Brew house

Your easy store cash register

## Tech Stack

- Ruby on Rails 7.2

## Prerequisites

- Ruby (3.3.0)

## Database Setup

1. Run database setup:
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed   # if you want to load sample data
   ```

## How to Run Server

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Start the Rails server:
   ```bash
   bin/rails server
   ```

3. Startup tailwind listener (on a separate terminal)
  ```bash
  bin/rails tailwindcss:watch
  ```

The application will be available at http://localhost:3000