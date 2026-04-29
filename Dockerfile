FROM python:3.12-slim
LABEL maintainer="Victor Perez"

WORKDIR /tool

#working without these lines, they were just added for nf-core compliance. 

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    ffmpeg \
    libsm6 \
    libxext6 \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .
RUN pip install --no-cache-dir .
