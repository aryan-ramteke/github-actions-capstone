FROM python:3.14-slim AS builder

WORKDIR /application
 
RUN addgroup --system app && adduser --system --ingroup app aryan

COPY requirements.txt .

RUN python -m pip install --no-cache-dir -r requirements.txt --target=/application/libraries/

# Copy only the app source and runtime files
COPY app /application/app
COPY routes /application/routes
COPY services /application/services
COPY main.py /application/main.py

# Ensure non-root user owns app files and installed libraries
RUN chown -R aryan:app /application /application/libraries

FROM cgr.dev/chainguard/python:latest AS deployer

WORKDIR /application

# Copy builder output explicitly so the app package path is preserved
COPY --from=builder /application/app /application/app
COPY --from=builder /application/routes /application/routes
COPY --from=builder /application/services /application/services
COPY --from=builder /application/main.py /application/main.py
COPY --from=builder /application/libraries /application/libraries
COPY --from=builder /etc/passwd /etc/group /etc/

# Include both the app root and libraries on Python path
ENV PYTHONPATH=/application:/application/libraries

USER aryan

EXPOSE 8000

CMD ["main.py"]
