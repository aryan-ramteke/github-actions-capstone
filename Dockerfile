FROM python:3.14-slim AS builder

WORKDIR /app
 
RUN addgroup --system app && adduser --system --ingroup app aryan

COPY requirements.txt .

RUN python -m pip install --no-cache-dir -r requirements.txt --target=/app/libraries/

# Copy only the app source and runtime files
COPY app/ routes/ services/ main.py /app/

# Ensure non-root user owns app files and installed libraries
RUN chown -R aryan:app /app /app/libraries

FROM cgr.dev/chainguard/python:latest AS deployer

WORKDIR /app

COPY --from=builder /app /app
COPY --from=builder /etc/passwd /etc/group /etc/

# Include both the app root and libraries on Python path
ENV PYTHONPATH=/app:/app/libraries

USER aryan

EXPOSE 8000

CMD ["python", "main.py"]
