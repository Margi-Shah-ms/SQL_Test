video link here: 
Smart Library Management System

## Project Overview
The **Smart Library Management System** is a relational database project built using **PostgreSQL**. The project models a complete library ecosystem that enables librarians to track books, authors, registered members, and borrowing transactions. 

It covers the full database lifecycle—from designing normalized schemas with primary and foreign key constraints to implementing CRUD operations, complex multi-table JOINs, nested subqueries, analytic window functions, and dynamic conditional logic.

---

## Technical Stack & Architecture
- **Database Engine:** PostgreSQL
- **Key Concepts Covered:**
  - Relational Schema Design & Entity Relationships
  - Data Integrity Constraints (Primary Keys, Foreign Keys, Unique Constraints)
  - Data Manipulation Language (DML) & Data Definition Language (DDL)
  - Complex SQL Queries (Joins, Subqueries, Aggregate Functions)
  - Advanced PostgreSQL Functions (Window Functions, Date/Time Utilities, String Manipulation, CASE Statements)

---

## System Architecture & Data Schema

The database consists of **4 core tables** designed with relational integrity:

```text
+------------------+         +------------------+
|     AUTHORS      |         |      BOOKS       |
+------------------+         +------------------+
| author_id (PK)   |<-------+| book_id (PK)     |
| name             |   1:N   | title            |
| email            |         | author_id (FK)   |
+------------------+         | category         |
                             | isbn             |
+------------------+         | published_date   |
|     MEMBERS      |         | price            |
+------------------+         | available_copies |
| member_id (PK)   |<---+    +------------------+
| name             |    |             ^
| email            |    |             | 1:N
| phone_number     |    | 1:N         |
| membership_date  |    |    +------------------+
+------------------+    |    |   TRANSACTIONS   |
                        |    +------------------+
                        +--->| transaction_idPK |
                             | member_id (FK)   |
                             | book_id (FK)     |
                             | borrow_date      |
                             | return_date      |
                             | fine_amount      |
                             +------------------+
```
### Table Breakdown
1. **`authors`**: Stores biographical details of book authors.
2. **`books`**: Contains catalog information, category classification, pricing, publication date, and real-time inventory counts (`available_copies`).
3. **`members`**: Tracks registered patrons, contact details, and initial registration dates.
4. **`transactions`**: Records borrowing and return activities, links members with books, and logs fine amounts for overdue returns.

---
## output: 
# 1. books
<img width="987" height="195" alt="image" src="https://github.com/user-attachments/assets/760383ef-0ed9-49b9-b2cf-62ea32949ba3" />

# 2. authors
<img width="446" height="171" alt="image" src="https://github.com/user-attachments/assets/916e03bb-543e-4e2c-ab08-8dc525312a5b" />

# 3. members 
<img width="724" height="133" alt="image" src="https://github.com/user-attachments/assets/ef5e7763-4953-4fae-8b20-28e49f7ec07d" />

# 4. transaction 
<img width="605" height="200" alt="image" src="https://github.com/user-attachments/assets/29d288c2-4598-454d-9ad9-04b57abd106a" />

### categorize books (new arrival / classic / regular)
<img width="426" height="186" alt="image" src="https://github.com/user-attachments/assets/5a687ae2-6782-4e42-82e4-e0cd7c140922" />

### assign a membership_status column (active / inactive)
<img width="423" height="142" alt="image" src="https://github.com/user-attachments/assets/b23be493-2429-42cf-9acd-63cfbc397e7c" />

## Core Features & Functionalities Implemented

### 1. Database Creation & Data Seeding
- Structured DDL scripts creating tables with integer-based primary keys and cascaded foreign key relationships.
- Comprehensive seed data providing edge cases for query testing (e.g., books with zero stock, unborrowed titles, inactive members, late returns with fines).

### 2. Operational CRUD Functionality
- **Inventory Control:** Automatic stock adjustment queries when a book is issued (`available_copies - 1`) or returned (`available_copies + 1`).
- **Data Pruning:** Deletion queries targeting inactive members who haven't borrowed books within the past year.
- **Availability Queries:** Immediate retrieval of books currently in stock.

### 3. Filtering, Sorting & Aggregation
- **Targeted Selection:** Filtering books by publication year (> 2015), price limits, and specific genre categories (`Science`, `Fantasy`).
- **Ranking & Limits:** Querying top 5 most expensive books using `ORDER BY` and `LIMIT`.
- **Group Statistics:** Aggregating total book counts, average library book prices, total fines collected, and borrowing frequency per member using `GROUP BY`, `SUM()`, `AVG()`, and `COUNT()`.

### 4. Advanced Multi-Table Relationships & Joins
- **`INNER JOIN`**: Matching books directly with their corresponding author details.
- **`LEFT JOIN`**: Fetching member borrowing histories while retaining members without transactions.
- **`RIGHT JOIN`**: Identifying books in the catalog that have never been checked out.
- **`FULL OUTER JOIN`**: Auditing gaps between members and transaction logs.

### 5. Subqueries & Nested Logic
- Retrieving books borrowed exclusively by members who registered after a specific date.
- Identifying the single most-borrowed title dynamically using nested subqueries.
- Subquery filtering for members without any borrowing history (`NOT IN`).

### 6. Date/Time & String Processing
- **Date Arithmetic:** Calculating exact return durations (`return_date - borrow_date`) to compute late return fees.
- **Formatting:** Standardizing output dates to standard formats (`DD-MM-YYYY`) via `TO_CHAR()`.
- **String Cleaning:** Converting book titles to uppercase, trimming padding spaces from author names, and substituting missing email entries using `COALESCE()`.

### 7. Analytical Window Functions
- **Ranking:** Ranking books based on overall popularity using `DENSE_RANK() OVER (...)`.
- **Cumulative Metrics:** Calculating running cumulative totals of books borrowed per member over time.
- **Moving Averages:** Computing 3-month rolling averages of library checkouts.

### 8. Conditional Logic (CASE Expressions)
- **Member Activity Tagging:** Dynamic classification of members as `'active'` or `'inactive'` based on checkout history within the last 6 months.
- **Catalog Categorization:** Automated labeling of books as `'new arrival'` (> 2020), `'classic'` (< 2000), or `'regular'`.

---

## How to Run
1. Open your PostgreSQL terminal or client tool (pgAdmin, DBeaver).
2. Create a new database:
   create database smart_library;
3. Execute `schema.sql` to generate tables and key constraints.
4. Execute `seed_data.sql` to populate sample entries.
5. Run any individual query from the `queries/` directory to analyze system data.
