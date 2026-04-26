FROM python:3.12-slim
LABEL maintainer="Victor Perez"

WORKDIR /tool

#The explicit installation of libxml2-dev and libxslt-dev below
#was just added to work around the strict isolated environment 
#with which nf-core builds a container. The container was already
#working without these lines, they were just added for nf-core compliance. 

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    ffmpeg \
    libsm6 \
    libxext6 \
    procps \
    libxml2-dev \
    libxslt-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .
RUN pip install --no-cache-dir .
