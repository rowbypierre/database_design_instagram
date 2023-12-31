
# Database Schema Definition

## Table: `books`
- `id`: Book unique identifier.
- `title`: Book's title.
- `author_id`: Foreign key reference to `authors.id`.
- `genre_id`: Foreign key reference to `genres.id`.
- `ISBN`: Book's ISBN.
- `status_id`: Foreign key reference to `status.id`.
- `condition_id`: Foreign key reference to `conditions.id`.
- `created_staff_id`: Foreign key reference to `staff.id`.
- `created`: Timestamp of when the book entry was created.
- `modified_staff_id`: Foreign key reference to `staff.id`.
- `modified`: Timestamp of when the book entry was last modified.

## Table: `authors`
- `id`: Author unique identifier.
- `fname`: Author's first name.
- `lname`: Author's last name.
- `mi`: Author's middle initials.
- `dob`: Author's date of birth.

## Table: `book_authors`
- `book_id`: Foreign key reference to `books.id`.
- `author_id`: Foreign key reference to `authors.id`.

## Table: `status`
- `id`: Status unique identifier.
- `status`: Description of the book's status (e.g., available).

## Table: `genres`
- `id`: Genre unique identifier.
- `genre`: Genre of the book.

## Table: `conditions`
- `id`: Condition unique identifier.
- `condition`: Condition of the book.

## Table: `patrons`
- `id`: Patron unique identifier.
- `fname`: Patron's first name.
- `lname`: Patron's last name.
- `address`: Patron's address.
- `zip`: Patron's ZIP code.
- `state`: Patron's State of residence.
- `phone`: Patron's phone number.
- `email`: Patron's email address.
- `created_staff_id`: Foreign key reference to `staff.id`.
- `created`: Timestamp of when the book entry was created.
- `modified_staff_id`: Foreign key reference to `staff.id`.
- `modified`: Timestamp of when the book entry was last modified.

## Table: `loans`
- `id`: Loan unique identifier.
- `book_id`: Foreign key reference to `books.id`.
- `patron_id`: Foreign key reference to `patrons.id`.
- `due`: Due date for the loan.
- `renewals`: Number of times the loan has been renewed.
- `checkout_id`: Foreign key reference to `checkouts.id`.
- `return_id`: Foreign key reference to `returns.id`.
- `created_staff_id`: Foreign key reference to `staff.id`.
- `created`: Timestamp of when the book entry was created.
- `modified_staff_id`: Foreign key reference to `staff.id`.
- `modified`: Timestamp of when the book entry was last modified.

## Table: `returns`
- `id`: Return unique identifier.
- `date`: Date of the return.
- `comment`: Any comments on the return.
- `overdue`: Whether the book was returned overdue.
- `fine`: Fine amount if the book was overdue.
- `created_staff_id`: Foreign key reference to `staff.id`.
- `created`: Timestamp of when the book entry was created.
- `modified_staff_id`: Foreign key reference to `staff.id`.
- `modified`: Timestamp of when the book entry was last modified.

## Table: `checkouts`
- `id`: Checkout unique identifier.
- `date`: Checkout date and time.
- `comment`: Comments on the checkout.
- `created_staff_id`: Foreign key reference to `staff.id`.
- `created`: Timestamp of when the book entry was created.
- `modified_staff_id`: Foreign key reference to `staff.id`.
- `modified`: Timestamp of when the book entry was last modified.

## Table: `staff`
- `id`: Staff unique identifier.
- `fname`: Staff member's first name.
- `lname`: Staff member's last name.
- `active`: Whether the staff member is currently employed.
- `hire`: Date the staff member was hired.
- `role`: Role of the staff member within the library.
- `created_staff_id`: Foreign key reference to `staff.id`.
- `created`: Timestamp of when the book entry was created.
- `modified_staff_id`: Foreign key reference to `staff.id`.
- `modified`: Timestamp of when the book entry was last modified.
