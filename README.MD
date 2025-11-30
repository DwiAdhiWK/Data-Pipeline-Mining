# Mining Parts Data Warehouse 
An end-to-end ETL pipeline project for mining equipment parts

# Repository Outline
- docker-compose.yml: PostgreSQL container
- dockerfile.txt: Python environment with required libraries
- etl_mining.ipynb: Complete ETL pipeline + validation
- interchange.xlsx: available parts with existing alternate 
- inventory.xlsx: Current stock per branch
- requirements.txt: pip packages
- sales.xlsx: Sales transactions
- sql_query_part_A.sql: sql script to query question in part A
- transfer.xlsx: excel file of transfer

# Stack
- Python
- PostgreSQL (star schema)
- Docker

# Database Schema

## Dimension Table
| Table           | Key            | Important Columns                              | Notes                              |
|-----------------|----------------|------------------------------------------------|------------------------------------|
| `dim_branch`    | `branch_id`    | `branch_name` (Jakarta, Banjarmasin, ...)      | UNIQUE                             |
| `dim_customer`  | `customer_id`  | `customer_name`                                | UNIQUE                             |
| `dim_part`      | `part_id`      | `part_number` (UNIQUE), `alt_part_number`, `part_name`, `category` | Supports alternate parts |
| `dim_date`      | `date_id` (YYYYMMDD) | `full_date`, `year`, `month`, `day`      | Date dimension                     |

## Fact Table

| Table              | Keys                                   | Measures                          | Notes                                      |
|--------------------|----------------------------------------|-----------------------------------|--------------------------------------------|
| `fact_sales`       | `sale_id` (PK), FK → branch, customer, part, date | `qty`, `unit_price`, `currency` | Main transaction fact                      |
| `fact_transfers`   | `transfer_id` (PK), FK → from/to branch, part, date | `qty`                   | Stock movement between branches            |
| `fact_inventory`   |`branch_id` | `part_id`  | `stock_on_hand`, `min_stock`, `uom` | Current snapshot (no date dimension) |

# How to Run

## Docker & Python 
### 1. Start PostgreSQL in Docker
docker-compose -f docker-compose.yml up

### 2. Wait ~10 seconds, then check
docker logs postgres_container

### 3. Create virtual environment & install dependencies
python -m venv venv
source venv/bin/activate    # Windows: venv\Scripts\activate
pip install -r requirements.txt

### 4. Open and run etl_mining.ipynb (Jupyter Notebook / VS Code / JupyterLab)
###    → All data will be loaded automatically into PostgreSQL

### 5. Validate (optional but recommended)
###    → Run the validation cell at the end → should show "ALL GOOD!"

## PostgreSQL 

1. Open **pgAdmin** or **DBeaver**  
2. Right-click **Servers** → **Register** → **Server** (or **Create → Connection** in DBeaver)  
3. Fill exactly like this:

| Field            | Value (copy-paste)       |
|------------------|--------------------------|
| Name             | Mining Warehouse (or anything) |
| Host             | `localhost`              |
| Port             | `5434`                   |
| Maintenance database | `postgres`          |
| Username         | `user`                   |
| Password         | `postgres`               |

4. Click **Save** / **Test Connection**  
   → If you see **“Connection successful”** → Docker is running correctly!  

5. Expand the server → expand **Databases**  
   → You must see **`mitra_db`** appear in the list

If `mitra_db` appears → PostgreSQL is 100% ready!  
If not → wait 10 more seconds and refresh (or run `docker logs postgres_container` to check)

Now you can safely run the Jupyter notebook.

host="localhost", port=5434, dbname="mitra_db", user="user", password="postgres"