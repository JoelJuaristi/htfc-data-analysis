FROM postgres:12-alpine

ENV POSTGRES_HOST=postgres
ENV POSTGRES_USER=postgres

COPY ./db/db_schema.sql /docker-entrypoint-initdb.d/01_schema.sql
COPY ./db/script.sql /docker-entrypoint-initdb.d/02_data.sql