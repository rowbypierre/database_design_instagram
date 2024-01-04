# Library Management System Database

## Overview

This document describes the database schema for the Library Management System. The schema is designed to efficiently manage and automate the various processes of a library, including book management, patron interactions, and record-keeping. Key aspects of the schema include primary keys for unique identification, foreign keys for relational integrity, and constraints to ensure data validity.

## Database Schema

### Tables and Descriptions

#### `books`
- **Primary Key**: `id` (unique identifier for each book).
    ```sql
    create table books (
	    id serial primary key,
    ```
- **Foreign Keys**: 
  - `genre_id` references `genres(id)`.
  - `status_id` references `statuses(id)`.
  - `condition_id` references `conditions(id)`.
  - `created_staff_id` and `modified_staff_id` reference `staff(id)`.
    ```sql
 	foreign key (genre_id)
		references genres(id),
	foreign key (status_id)
		references statuses(id),
	foreign key (condition_id)
		references conditions(id),
	foreign key (created_staff_id)
		references staff(id),
	foreign key (modified_staff_id)
		references staff(id),   
    ```
- **Constraints**: 
  - `modified` date is not earlier than `created`date.
  - `ISBN` is unique and at least 10 characters.
    ```sql
    ISBN varchar(15) unique not null ,
    ...
    check (
	        (modified is null or created <= modified)  
			and length(ISBN) >= 10
	)
    ```

#### `authors`
- **Primary Key**: `id` (unique identifier for each author).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `fname`: First name of the author.
  - `lname`: Last name of the author.
  - `mi`: Middle initial of the author.
  - `dob`: Date of birth of the author.
    ```sql
    fname varchar(30) not null,
    lname varchar(30) not null,
    mi varchar(10) not null,
    dob date not null,
    ```
- **Constraints**: 
  - Combination of `fname`, `lname`, `mi`, and `dob` must be unique.
  - Date of birth (`dob`) must be on or before the current date.
    ```sql
    unique(fname, lname, mi, dob),
    check (
        dob <= current_date 
    )
    ```

#### `book_authors`
- **Columns**:
  - `book_id`: References the `id` of a book in the `books` table.
  - `author_id`: References the `id` of an author in the `authors` table.
    ```sql
    book_id smallint not null,
    author_id smallint not null,
    ```
- **Foreign Keys**:
  - `book_id` references `books(id)`. On deletion of a book, corresponding entries in this table are also deleted.
  - `author_id` references `authors(id)`. On deletion of an author, corresponding entries in this table are also deleted.
    ```sql
    foreign key (book_id)
        references books(id) on delete cascade,
    foreign key (author_id)
        references authors(id) on delete cascade,
    ```
- **Constraints**:
  - Combination of `book_id` and `author_id` must be unique, ensuring each book-author pairing is unique.
    ```sql
    unique (book_id, author_id)
    ```

#### `statuses`
- **Primary Key**: `id` (unique identifier for each status).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `status`: Descriptive name of the status.
    ```sql
    status varchar(30) unique not null
    ```
- **Constraints**:
  - `status` must be unique and not null, ensuring each status is distinct.

#### `genres`
- **Primary Key**: `id` (unique identifier for each genre).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `genre`: Name of the genre.
    ```sql
    genre varchar(30) unique not null
    ```
- **Constraints**:
  - `genre` must be unique and not null, ensuring each genre is distinct.

#### `conditions`
- **Primary Key**: `id` (unique identifier for each condition).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `condition`: Description of the condition.
    ```sql
    condition varchar(30) unique not null
    ```
- **Constraints**:
  - `condition` must be unique and not null, ensuring each condition is distinct.

#### `patrons`
- **Primary Key**: `id` (unique identifier for each patron).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `fname`: First name of the patron.
  - `lname`: Last name of the patron.
  - `dob`: Date of birth of the patron.
  - `address`: Address of the patron.
  - `zip`: ZIP code of the patron's address.
  - `state`: State of the patron's address.
  - `phone`: Phone number of the patron.
  - `email`: Email address of the patron.
  - `created`: Timestamp when the patron record was created.
  - `created_staff_id`: ID of the staff member who created the patron record.
  - `modified`: Timestamp when the patron record was last modified.
  - `modified_staff_id`: ID of the staff member who last modified the patron record.
    ```sql
    fname varchar(30) not null,
    lname varchar(30) not null,
    dob date not null,
    address varchar(90),
    zip varchar(15),
    state varchar(30),
    phone varchar(15),
    email varchar(30),
    created timestamp with time zone default current_timestamp,
    created_staff_id smallint not null,
    modified timestamp with time zone,
    modified_staff_id smallint,
    ```
- **Foreign Keys**:
  - `created_staff_id` and `modified_staff_id` reference `staff(id)`.
    ```sql
    foreign key (created_staff_id)
        references staff(id),
    foreign key (modified_staff_id)
        references staff(id),
    ```
- **Constraints**:
  - Combination of `fname`, `lname`, `address`, and `dob` must be unique.
  - `dob` must be at least 14 years before the current date.
  - Either all or none of the `address`, `zip`, and `state` must be provided.
  - At least one of `phone` or `email` must be provided, and if provided, they must meet certain format requirements.
    ```sql
    unique (fname, lname, address, dob),
      check (
			  dob <= current_date - interval '14 year' 
			  and ((address is not null and length(zip) >= 5 and state is not null)
				  or (address is null and zip is null and state is null))	
			  and (modified is null or created <= modified)
			  -- and (coalesce((phone)::boolean::integer,0) + 
				  -- coalesce((email)::boolean::integer,0)) >= 1
			  and (phone is null or length(phone) >= 10)
			  and (email is null or email like '%@%')
	    )
    );
    ```

#### `loans`
- **Primary Key**: `id` (unique identifier for each loan).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `book_id`: References the `id` of a book in the `books` table.
  - `patron_id`: References the `id` of a patron in the `patrons` table.
  - `due`: The due date for the loan.
  - `renewals`: The number of times the loan has been renewed.
  - `checkout_id`: References the `id` of a checkout in the `checkouts` table.
  - `return_id`: References the `id` of a return in the `returns` table.
  - `created_staff_id`: ID of the staff member who created the loan record.
  - `created`: Timestamp when the loan record was created.
  - `modified_staff_id`: ID of the staff member who last modified the loan record.
  - `modified`: Timestamp when the loan record was last modified.
    ```sql
    book_id smallint not null,
    patron_id smallint not null,
    due date default current_date,
    renewals smallint default 0,
    checkout_id smallint not null,
    return_id smallint not null,
    created_staff_id smallint not null,
    created timestamp with time zone default current_timestamp,
    modified_staff_id smallint,
    modified timestamp with time zone,
    ```
- **Foreign Keys**:
  - `book_id` references `books(id)`.
  - `patron_id` references `patrons(id)`, with cascade delete.
  - `checkout_id` references `checkouts(id)`.
  - `return_id` references `returns(id)`.
  - `created_staff_id` and `modified_staff_id` reference `staff(id)`.
    ```sql
    foreign key (book_id)
        references books(id),
    foreign key (patron_id)
        references patrons(id) on delete cascade,
    foreign key (checkout_id)
        references checkouts(id),
    foreign key (return_id)
        references returns(id),
    foreign key (created_staff_id)
        references staff(id),
    foreign key (modified_staff_id)
        references staff(id),
    ```
- **Constraints**:
  - `modified` timestamp should not be earlier than `created` timestamp.
  - Due date (`due`) should not exceed 6 months from the current date.
  - Number of renewals (`renewals`) is limited to 3.
    ```sql
    check (
        (modified is null or created <= modified)
        and due <= current_date + interval '6 month'
        and renewals <= 3
    )
    ```

#### `returns`
- **Primary Key**: `id` (unique identifier for each return).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `date`: The date of the return.
  - `comment`: Additional comments about the return.
  - `overdue`: Boolean indicating if the return was overdue.
  - `fine`: The fine amount for overdue returns.
  - `created_staff_id`: ID of the staff member who created the return record.
  - `created`: Timestamp when the return record was created.
  - `modified_staff_id`: ID of the staff member who last modified the return record.
  - `modified`: Timestamp when the return record was last modified.
    ```sql
    date date not null,
    comment varchar(240) default '',
    overdue boolean not null,
    fine numeric default 0,
    created_staff_id smallint not null,
    created timestamp with time zone default current_timestamp,
    modified_staff_id smallint,
    modified timestamp with time zone,
    ```
- **Foreign Keys**:
  - `created_staff_id` and `modified_staff_id` reference `staff(id)`.
    ```sql
    foreign key (created_staff_id)
        references staff(id),
    foreign key (modified_staff_id)
        references staff(id),
    ```
- **Constraints**:
  - `date` should be between January 1, 2000, and the current date.
  - `fine` must be greater than or equal to 0.
  - `modified` timestamp should not be earlier than `created` timestamp.
    ```sql
    check (
        date between '2000-01-01' and current_date 
        and fine >= 0
        and (modified is null or created <= modified)
    )
    ```

#### `checkouts`
- **Primary Key**: `id` (unique identifier for each checkout).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `date`: The date of the checkout.
  - `comment`: Additional comments about the checkout.
  - `created_staff_id`: ID of the staff member who created the checkout record.
  - `created`: Timestamp when the checkout record was created.
  - `modified_staff_id`: ID of the staff member who last modified the checkout record.
  - `modified`: Timestamp when the checkout record was last modified.
    ```sql
    date date default current_date,
    comment varchar(240) default '',
    created_staff_id smallint not null,
    created timestamp with time zone default current_timestamp,
    modified_staff_id smallint,
    modified timestamp with time zone,
    ```
- **Foreign Keys**:
  - `created_staff_id` and `modified_staff_id` reference `staff(id)`.
    ```sql
    foreign key (created_staff_id)
        references staff(id),
    foreign key (modified_staff_id)
        references staff(id),
    ```
- **Constraints**:
  - `date` should not be earlier than January 1, 2000.
  - `modified` timestamp should not be earlier than `created` timestamp.
    ```sql
    check (
        date >= '2000-01-01'
        and (modified is null or created <= modified)
    )
    ```

#### `staff`
- **Primary Key**: `id` (unique identifier for each staff member).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `fname`: First name of the staff member.
  - `lname`: Last name of the staff member.
  - `active`: Boolean indicating if the staff member is active.
  - `dob`: Date of birth of the staff member.
  - `hire`: Hire date of the staff member.
  - `role_id`: References the role of the staff member in the `roles` table.
  - `created_staff_id`: ID of the staff member who created this record.
  - `created`: Timestamp when the staff record was created.
  - `modified_staff_id`: ID of the staff member who last modified this record.
  - `modified`: Timestamp when the staff record was last modified.
    ```sql
    fname varchar(30) not null,
    lname varchar(30) not null,
    active boolean not null,
    dob date not null,
    hire date not null,
    role_id smallint not null,
    created_staff_id smallint not null,
    created timestamp with time zone default current_timestamp,
    modified_staff_id smallint,
    modified timestamp with time zone,
    ```
- **Foreign Keys**:
  - `role_id` references `roles(id)`.
    ```sql
    foreign key (role_id)
        references roles(id),
    ```
- **Constraints**:
  - Combination of `fname`, `lname`, `dob`, and `role_id` must be unique.
  - `dob` must be at least 16 years before the current date.
  - `hire` date must be after the `dob` and not before January 1, 2000.
  - `modified` timestamp should not be earlier than `created` timestamp.
  - `created_staff_id` and `modified_staff_id` self-reference `staff(id)`.
    ```sql
    unique (fname, lname, dob, role_id),
    check (
			dob <= current_date - interval '16 year'
			and hire > dob 
			and hire > '2000-01-01'
			and (modified is null or 
				 (created <= modified
				 and modified_staff_id in (select id from staff))
			and created_staff_id in (select id from staff))
	)
);
    ```

#### `roles`
- **Primary Key**: `id` (unique identifier for each role).
    ```sql
    id serial primary key,
    ```
- **Columns**:
  - `role`: Name of the role.
    ```sql
    role varchar(30) unique not null
    ```
- **Constraints**:
  - `role` must be unique and not null, ensuring each role is distinct.


## Notes

This schema is designed to ensure data integrity and consistency across the library management system, with an emphasis on robust relationships between different entities such as books, authors, patrons, and staff.
