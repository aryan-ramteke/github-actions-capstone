FROM python:3.14-slim AS builder

WORKDIR /app

RUN addgroup --system app && adduser --system --ingroup app aryan && chown -R aryan:app /app

USER aryan

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt --target=/app/libraries/

COPY . .

FROM gcr.io/distroless/python3-debian12 AS deployer

WORKDIR /app

COPY --from=builder /app /app

ENV PYTHONPATH=/app/libraries

USER aryan

EXPOSE 8000

CMD ["main.py"]
