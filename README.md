# htfc-data-analysis
Repository used for buiding a data analysis tool for Harborough Town Football Club


## Database design

```
docker build -t db .
docker run --name htfc-db -e POSTGRES_PASSWORD=postgres -p 5432:5432 db
```