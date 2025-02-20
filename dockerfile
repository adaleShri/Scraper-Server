## Multi-stage Dockerfile

# Stage 1: Scraper using Node.js and Puppeteer
FROM node:18-slim AS scraper

# Install dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgbm1 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxrender1 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable to skip Puppeteer's Chromium download
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json ./
RUN npm install


# Copy scraper script
COPY scrape.js ./

# Run the scraper script
ARG SCRAPE_URL
ENV SCRAPE_URL=$SCRAPE_URL
RUN node scrape.js "$SCRAPE_URL"

# Stage 2: Web server using Python and Flask
FROM python:3.10-slim AS server

# Set working directory
WORKDIR /app

# Copy the scraped data from the previous stage
COPY --from=scraper /app/scraped_data.json ./

# Copy server script
COPY server.py ./

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 5000
EXPOSE 5000

# Run the Flask web server
CMD ["python", "server.py"]

