FROM postgres:12-alpine

ENV POSTGRES_HOST=postgres
ENV POSTGRES_USER=postgres

COPY ./db/db_schema.sql /docker-entrypoint-initdb.d