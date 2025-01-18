# Use the official Dart image with the required SDK version
FROM dart:3.5.4 AS base

# Install dependencies for Flutter and Puppeteer (including Chromium and Node.js)
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    xz-utils \
    git \
    sudo \
    libxss1 \
    libnss3 \
    libx11-xcb1 \
    libgbm1 \
    ca-certificates \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (which includes npm)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Download and install the Flutter SDK
RUN curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.4-stable.tar.xz \
    && tar xf flutter_linux_3.24.4-stable.tar.xz -C /usr/local/ \
    && rm flutter_linux_3.24.4-stable.tar.xz

# Set the Flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Add git safe directory configuration
RUN git config --global --add safe.directory /usr/local/flutter

# Create a non-root user
RUN useradd -m flutteruser

# Switch to the non-root user
USER flutteruser

# Set the working directory for the backend
WORKDIR /home/flutteruser/app

# Copy the backend code
COPY backend/ /home/flutteruser/app/

# Copy the root pubspec.yaml from the root
COPY pubspec.yaml /home/flutteruser/app/

# Disable cli animations
RUN flutter config --no-cli-animations

# Install dependencies
RUN flutter pub get

# Install Puppeteer
RUN npm install puppeteer

# Install howlongtobeatpy via pip
RUN python3 -m venv /home/flutteruser/venv \
    && /home/flutteruser/venv/bin/pip install --upgrade pip \
    && /home/flutteruser/venv/bin/pip install howlongtobeatpy

# Set the Python environment for subsequent commands
ENV PATH="/home/flutteruser/venv/bin:${PATH}"

# Run the backend server
EXPOSE 8080
CMD ["dart", "main.dart"]
