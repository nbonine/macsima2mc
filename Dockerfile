# Use official micromamba image
FROM mambaorg/micromamba:2.5.0
LABEL maintainer="Victor Perez"

USER root
WORKDIR /tool

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    ffmpeg \
    libsm6 \
    libxext6 \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy everything (no environment.yml needed)
COPY . .

# Create empty environment then install everything with pip
RUN micromamba create --name app-env python=3.12 \
    && micromamba clean --all --yes

ENV PATH="/opt/conda/envs/app-env/bin:$PATH"

# Install everything from pyproject.toml
RUN micromamba run --name app-env pip install --no-cache-dir .

USER $MAMBA_USER