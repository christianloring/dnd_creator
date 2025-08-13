# Deployment Guide

Simple deployment options for the D&D Creator app.

## Kamal (Recommended)

The app is configured for Kamal deployment:

```bash
# Install Kamal
gem install kamal

# Deploy
kamal deploy
```

## Environment Variables

Set these in production:

```bash
DATABASE_URL=postgresql://user:pass@host:port/db
SECRET_KEY_BASE=your_secret_key
RAILS_ENV=production
```

## Heroku

```bash
# Create app
heroku create your-app-name

# Add PostgreSQL
heroku addons:create heroku-postgresql:mini

# Set environment
heroku config:set RAILS_ENV=production
heroku config:set SECRET_KEY_BASE=$(bin/rails secret)

# Deploy
git push heroku main

# Setup database
heroku run bin/rails db:migrate
```

## Docker

```bash
# Build image
docker build -t dnd-creator .

# Run container
docker run -p 3000:3000 \
  -e DATABASE_URL=postgresql://user:pass@host:port/db \
  -e SECRET_KEY_BASE=your_secret_key \
  dnd-creator
```

## VPS Setup

Basic setup for a VPS:

```bash
# Install dependencies
sudo apt update
sudo apt install -y ruby postgresql nodejs

# Clone and setup
git clone https://github.com/christianloring/dnd_creator.git
cd dnd_creator
bundle install
bin/rails db:create db:migrate

# Start server
bin/rails server -b 0.0.0.0 -p 3000
```

## SSL Certificate

Using Let's Encrypt:

```bash
sudo apt install certbot
sudo certbot --nginx -d your-domain.com
```
