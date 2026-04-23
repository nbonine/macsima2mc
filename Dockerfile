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

COPY environment.yml .

RUN micromamba env create --name app-env -f environment.yml \
    && micromamba clean --all --yes

ENV PATH="/opt/conda/envs/app-env/bin:$PATH"

# Copy ALL source code FIRST (required for pip install)
COPY . .

# Install the package
RUN micromamba run --name app-env pip install --no-cache-dir .

USER $MAMBA_USER