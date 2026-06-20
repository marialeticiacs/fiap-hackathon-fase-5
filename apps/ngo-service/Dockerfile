# apps/ngo-service/Dockerfile

# ---- Stage 1: dependências ----
FROM python:3.11-slim AS builder

WORKDIR /app

# Instalar dependências de compilação
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---- Stage 2: runtime ----
FROM python:3.11-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade \
    pip \
    setuptools \
    wheel

# Usuário não-root
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

# Copiar dependências instaladas do builder
COPY --from=builder /install /usr/local

# Copiar código
COPY --chown=appuser:appgroup app.py .

USER appuser

EXPOSE 8081

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:8081/health || exit 1

# Gunicorn em produção (não usar flask run)
CMD ["gunicorn", "--bind", "0.0.0.0:8081", "--workers", "2", "--timeout", "60", "app:app"]