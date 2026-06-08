FROM python:alpine AS builder

WORKDIR /app

RUN addgroup -S app && adduser -S aryan -G app  && chown aryan:app /app

COPY --chown=aryan:app requirements.txt .

RUN apk add --no-cache gcc musl-dev python3-dev && pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt --target=/app/libraries/

FROM gcr.io/distroless/python3 AS deployer

WORKDIR /app

COPY --from=builder /app/libraries /app/libraries

ENV PYTHONPATH=/app/libraries

COPY . .

EXPOSE 8000

CMD ["main.py"]
