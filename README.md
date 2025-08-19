# Brew house

Your easy store cash register
[Click here for a quick demo](https://www.loom.com/share/614c6edcd6e74d0493909940b9c08224?sid=a2e17162-f18f-41d5-ac26-9a8c7b0067b6)

## Tech Stack

- Ruby on Rails 7.2
- Tailwind 4

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
