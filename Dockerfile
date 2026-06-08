FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*
RUN groupadd -r app && useradd -r -g app aryan

COPY --chown=aryan:app requirements.txt .

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt --target=/app/libraries/

COPY . .
RUN chown -R aryan:app /app

FROM gcr.io/distroless/python3-debian12 AS deployer

WORKDIR /app

COPY --from=builder /app /app
COPY --from=builder /etc/passwd /etc/group /etc/

USER aryan

ENV PYTHONPATH=/app/libraries

EXPOSE 8000

CMD ["main.py"]
