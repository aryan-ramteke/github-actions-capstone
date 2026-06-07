FROM python:3.13-slim AS builder

WORKDIR app/

RUN addgroup -S app && adduser -S aryan -G app  && chown aryan:app app/

COPY --chown aryan:app requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt --target=app/libraries/

FROM gcr.io/distroless/python3 AS deployer

WORKDIR app/

RUN addgroup -S app && adduser -S aryan -G app  && chown aryan:app app/

USER aryan

COPY --from=builder app/libraries app/libraries

ENV PYTHONPATH=app/libraries

COPY . .

EXPOSE 8000

CMD ["main.py"]
