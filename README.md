# Scraper & Server (Node.js + Python + Docker)

## Overview
This project demonstrates the power of **Node.js** for web scraping (using Puppeteer and Chromium) and **Python (Flask)** for serving the scraped data. The application runs inside a multi-stage Docker container, ensuring efficiency and a small final image size.

---

## Features
- **Scrape a webpage** using Puppeteer.
- **Serve scraped data** via a Flask web server.
- **Multi-stage Docker build** for an optimized, lightweight container.
- **Fully containerized**—just build and run with Docker!

---

## Prerequisites
Ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Node.js (for local testing)](https://nodejs.org/)
- [Python (for local testing)](https://www.python.org/)

---

## Project Structure
```
/
├── Dockerfile            # Multi-stage Docker build
├── scrape.js             # Node.js Puppeteer script for web scraping
├── server.py             # Flask server to serve scraped data
├── package.json          # Node.js dependencies
├── requirements.txt      # Python dependencies
├── scraped_data.json     # Scraped output (generated at runtime)
└── README.md             # Documentation
```

---

## Installation & Setup

### 1️⃣ Build the Docker Image
Run the following command to build the Docker container, specifying the URL to scrape:
```sh
sudo docker build --build-arg SCRAPE_URL="https://example.com" -t scraper-server .
```
> Replace `https://example.com` with the actual website URL you want to scrape.

---

### 2️⃣ Run the Docker Container
Start the container and expose the Flask server on **port 5000**:
```sh
sudo docker run -p 5000:5000 scraper-server
```
This will start the server, and you should see output like:
```
 * Running on http://127.0.0.1:5000
 * Running on http://172.17.0.2:5000
```

---

### 3️⃣ Access the Scraped Data
Once the container is running, open a web browser and visit:
```
http://127.0.0.1:5000
```
If running on a remote machine, find its IP with:
```sh
curl ifconfig.me
```
Then access:
```
http://YOUR_PUBLIC_IP:5000
```

---

## File Explanations

### **scrape.js** (Node.js Scraper)
- Uses Puppeteer to launch a headless Chromium browser.
- Extracts the page title and first heading (`<h1>` tag) from the specified URL.
- Saves the extracted data to `scraped_data.json`.

### **server.py** (Flask Server)
- Loads `scraped_data.json`.
- Serves the data as JSON via an HTTP API (`http://127.0.0.1:5000`).

### **Dockerfile** (Multi-Stage Build)
- **Stage 1: Node.js & Puppeteer Scraper**
  - Installs **Chromium** and **Puppeteer**.
  - Runs `scrape.js` to generate `scraped_data.json`.
- **Stage 2: Python Flask Server**
  - Copies `scraped_data.json`.
  - Runs `server.py` to expose scraped data via HTTP.

---

## Troubleshooting

### ❌ Flask Server Not Found (`ModuleNotFoundError: No module named 'flask'`)
Ensure Flask is installed inside the container:
```sh
sudo docker exec -it CONTAINER_ID pip install flask
```

### ❌ Unable to Access Flask Server
- Check if the container is running:
  ```sh
  sudo docker ps
  ```
- If accessing remotely, ensure the firewall allows **port 5000**:
  ```sh
  sudo ufw allow 5000/tcp
  ```
- Try restarting the container:
  ```sh
  sudo docker restart CONTAINER_ID
  ```

---

## Conclusion
This project efficiently combines **Node.js & Puppeteer for scraping** and **Python Flask for serving data**, packaged neatly using Docker. 🚀

Happy coding! 🎉


