

### Design Directory Overview

- **Focus**: Comprehensive database schema for a library management system.
    - Database Definition
    - Entity Relationship Diagram
    - Additional Documentation
- **Tables**: Incorporates `books`, `authors`, `patrons`, `loans`, `returns`, `checkouts`, `staff`, and `roles`.
- **Purpose**: Efficiently manages book handling, patron interactions, and library operations.
- **Relationships**: Creates detailed connections between books, authors, patrons, staff, and various library transactions.
- **Technical Specifications**: Employs data types like `serial`, `varchar`, `smallint`, `timestamp`,`date`, and `boolean`.
- **Usage**: Designed to support library management software, ensuring robust data handling and reporting capabilities.

---

### Create Directory Overview

- **Content**: Outlines the creation of the library database, including tables for books, authors, loans, and more.
    - Create schema and table statements
    - Insert records statements
    - Documentation for all keys and database level constraints.     
- **Tables**: 
  - `books`: Stores book details, linked to genres, statuses, conditions. Ensures ISBN length and modification dates.
  - `authors`: Contains author information, ensuring unique author identities.
  - `book_authors`: Establishes relationships between books and authors.
  - `genres`, `statuses`, `conditions`: Define book classifications, conditions, and availability.
  - `patrons`: Manages patron data with detailed constraints.
- **Insert Operations**: Populates tables with initial data, reflecting real-world scenarios.
- **Additional Tables**: `loans`, `returns`, `checkouts`, `staff`, `roles`. Each with unique constraints and relationships.
- **Emphasis**: Focuses on data integrity, consistency, and comprehensive relationships within the library system.

---

### Queries Directory Overview

#### General Overview of Library's Book Collection
- **Purpose**: Lists all books in the library's collection.
- **Details**: Includes title, ISBN, genre, and condition.
- **SQL Features**: Uses `LEFT JOIN`, `ORDER BY`.

#### Available Books and Author Information
- **Purpose**: Identifies available books with author details.
- **SQL Features**: Involves `CONCAT`, `String_agg`, `Common Table Expressions`, `LEFT JOIN`, `WHERE` filter, `ORDER BY`.

#### Books Never Loaned Out
- **Purpose**: Pinpoints books never loaned.
- **SQL Features**: Uses `NOT IN` subquery, `ORDER BY`.

#### Average Condition of Books
- **Purpose**: Analyzes average book condition.
- **SQL Features**: Involves `GROUP BY`, `ORDER BY`, `COUNT`, `CONCAT`, `SELECT` statement, subqueries, Mathematical Operators.

#### Days Book Loaned
- **Purpose**: Calculates loaned days for books.
- **SQL Features**: Uses `CASE` statements, `ORDER BY`, `Common Table Expressions`.

#### Overdue Returns
- **Purpose**: Identifies overdue returns and fines.
- **SQL Features**: Involves `JOIN`, `WHERE`, `ORDER BY`, `CONCAT`, `Common Table Expressions`, `WHERE` clause inequality.

#### Average Fines by Genre
- **Purpose**: Averages fine costs by book genre.
- **SQL Features**: Utilizes `GROUP BY`, `ORDER BY`, `Common Table Expressions`, `WHERE` clause inequality.

#### Staff Record Creation Count
- **Purpose**: Counts records created by staff.
- **SQL Features**: Uses `UNION`, `GROUP BY`, `COUNT`, `Common Table Expressions`, .

---

### Resultsets Directory Overview

- **Focus**: Comma seperated value (csv) files containing query outputs from `queries` directory.

