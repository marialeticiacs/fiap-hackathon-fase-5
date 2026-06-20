# apps/volunteer-service/Dockerfile

# ---- Stage 1: dependências ----
FROM python:3.11-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---- Stage 2: runtime ----
FROM python:3.11-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

COPY --from=builder /install /usr/local
COPY --chown=appuser:appgroup app.py .

USER appuser

EXPOSE 8083

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:8083/health || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:8083", "--workers", "2", "--timeout", "60", "app:app"]