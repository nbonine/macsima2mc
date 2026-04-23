# Use official micromamba image
FROM mambaorg/micromamba:2.5.0
LABEL maintainer="Victor Perez"

USER root
WORKDIR /app

# Update and install system dependencies (combined in one layer)
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    ffmpeg \
    libsm6 \
    libxext6 \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy environment.yml first for better caching
COPY environment.yml .

# Install conda dependencies
RUN micromamba env create --name app-env -f environment.yml \
    && micromamba clean --all --yes

# Add environment to PATH
ENV PATH="/opt/conda/envs/app-env/bin:$PATH"

# Copy only necessary files for pip install (better caching)
COPY pyproject.toml README.md requirements.txt ./

# Install the package
RUN micromamba run --name app-env pip install --no-cache-dir .

# Copy the rest of the application (src directory)
COPY src/ ./src/
COPY LICENSE ./

# Switch to non-root user
USER $MAMBA_USER

