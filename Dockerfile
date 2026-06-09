FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends gcc rustc cargo && rm -rf /var/lib/apt/lists/*
RUN addgroup --system app && adduser --system --ingroup app aryan && chown -R aryan:app /app

USER aryan

COPY requirements.txt .

RUN python -m pip install --no-cache-dir -r requirements.txt --target=/app/libraries/

COPY . .

FROM gcr.io/distroless/python3-debian12 AS deployer

WORKDIR /app

COPY --from=builder /app /app
COPY --from=builder /etc/passwd /etc/group /etc/

ENV PYTHONPATH=/app/libraries/

USER aryan

EXPOSE 8000

CMD ["main.py"]
