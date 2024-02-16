FROM python:3.10-slim-buster

USER root

WORKDIR /src

COPY ./analytics/requirements.txt requirements.txt

# Needed for dependencies used by psycopg2 (for Postgres client)
RUN apt update -y && apt install -y build-essential libpq-dev

# During the build, dependencies will be installed in the container itself so that the OS is compatible.
RUN pip install -r requirements.txt

COPY ./analytics .

CMD python app.py