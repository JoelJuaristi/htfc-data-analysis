# HTFC Data Analysis

A data analysis tool for **Harborough Town Football Club**, built to process, explore, and derive insights from football-related data.

---

## 🚀 Project Structure

This repository is organized to support easy development and deployment of the analysis tool:

- `app/`: Main application code  
  - `db/`: Database-related files (e.g., Dockerfile, schema, migrations)
  - `...`: Other application modules (e.g., API, analysis scripts, UI)
- `documentation/`: Important documentation
- `README.md`: Project overview and instructions

---

## 🧰 Tech Stack

- **PostgreSQL**: Primary relational database  
- **Docker**: Containerization and environment management  
- **Python**: Data processing, analysis, and visualization  

---

## 🗄️ Setting up the Database

You can quickly spin up the database locally using Docker.

```
cd ./app/db/
docker build -t db .
docker run --name htfc-db -e POSTGRES_PASSWORD=postgres -p 5432:5432 ghcr.io/joeljuaristi/htfc-data-analysis/db:latest
```

