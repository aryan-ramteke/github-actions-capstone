FROM python:3.14-slim AS builder

WORKDIR /application
 
RUN addgroup --system app && adduser --system --ingroup app aryan

COPY requirements.txt .

RUN python -m pip install --no-cache-dir -r requirements.txt --target=/application/libraries/

# Copy only the app source and runtime files
COPY ./app ./routes ./services ./main.py /application/

# Ensure non-root user owns app files and installed libraries
RUN chown -R aryan:app /application /application/libraries

FROM cgr.dev/chainguard/python:latest AS deployer

WORKDIR /application

# Copy builder /app contents into final /app (use trailing slashes to avoid nesting)
COPY --from=builder /application/ /application/
COPY --from=builder /etc/passwd /etc/group /etc/

# Include both the app root and libraries on Python path
ENV PYTHONPATH=/application:/application/libraries

USER aryan

EXPOSE 8000

CMD ["main.py"]
