FROM python:3.14-slim AS builder

WORKDIR /app

# 1. Update the package lists and download latest .deb patches for the system libraries
# RUN apt-get update && apt-get install -y --no-install-recommends --download-only \
#     libexpat1 \
#     libncursesw6

RUN addgroup --system app && adduser --system --ingroup app aryan

COPY requirements.txt .

# Install as root so pip can write to system-controlled locations
# RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel
RUN python -m pip install --no-cache-dir -r requirements.txt --target=/app/libraries/

COPY . .

# Ensure non-root user owns app files and installed libraries
RUN chown -R aryan:app /app /app/libraries

USER aryan

FROM cgr.dev/chainguard/python:latest AS deployer

WORKDIR /app

# 2. Extract and overwrite the vulnerable base libraries with the patched versions
# COPY --from=builder /var/cache/apt/archives/libexpat1*.deb /tmp/
# COPY --from=builder /var/cache/apt/archives/libncursesw6*.deb /tmp/
COPY --from=builder /app /app
COPY --from=builder /etc/passwd /etc/group /etc/

ENV PYTHONPATH=/app/libraries/

USER aryan

EXPOSE 8000

CMD ["main.py"]
