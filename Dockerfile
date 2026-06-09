FROM python:3.11-slim AS builder

WORKDIR /app

RUN addgroup --system app && adduser --system --ingroup app aryan

COPY requirements.txt .

# Install as root so pip can write to system-controlled locations
RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel
RUN python -m pip install --no-cache-dir -r requirements.txt --target=/app/libraries/

COPY . .

# Ensure non-root user owns app files and installed libraries
RUN chown -R aryan:app /app /app/libraries

USER aryan

FROM gcr.io/distroless/python3-debian12 AS deployer

WORKDIR /app

COPY --from=builder /app /app
COPY --from=builder /etc/passwd /etc/group /etc/

ENV PYTHONPATH=/app/libraries/

USER aryan

EXPOSE 8000

CMD ["main.py"]
