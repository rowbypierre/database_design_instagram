-- create database
create database library;

-- books table
create table books (
	id serial primary key,
	title nvarchar(120) not null,
	genre_id smallint not null,
	ISBN varchar(15) unique not null ,
	status_id smallint not null,
	condition_id smallint not null,
	created_staff_id smallint not null,
	created timestamp with time zone default current_timestamp,
	modified_staff_id smallint,
	modified timestamp with time zone default current_timestamp,	
	foreign key (genre_id)
		references genre (id),
	foreign key (status_id)
		references status (id),
	foreign key (condition_id)
		references condition (id),
	foreign key (created_staff_id)
		references staff (id),
	foreign key (modified_staff_id)
		references staff (id)
);

-- authors tables
create table authors (
	id serial primary key,
	fname varchar(30) not null,
	lname varchar(30) not null,
	mi varchar(10) not null,
	dob date not null,
	unique(fname, lname, mi, dob)
);

-- book_authors table
create table book_authors (
	book_id smallint not null,
	author_id smallint not null,
	foreign key (book_id)
		references books (id),
	foreign key (author_id)
		references authors (id),
	primary key (book_id, author_id)	
);

-- status table
create table status (
	id serial primary key,
	status varchar(30) unique not null
);

-- genres table
create table genres (
	id serial primary key,
	genre varchar(30) unique not null
);

-- condition table
create table conditions (
	id serial primary key,
	condition varchar(30) unique not null
);

-- patrons table
create table patrons (
	id serial primary,
	fname varchar(30) not null,
	lname varchar(30) not null,
	address varchar(90) not null,
	zip smallint not null,
	state varchar(30) not null,
	phone varchar(15) not null,
	email varchar(30),
	created timestamp with time zone default current_timestamp
	created_staff_id smallint not null,
	modified timestamp with time zone default current_timestamp,
	modified_staff_id smallint,
	foreign key (created_staff_id)
		references staff (id),
	foreign key (modified_staff_id)
		references modified (id),
	unique (fname, lname, address)
);

-- loans table
create table loans (
	id serial primary key,
	book_id smallint not null,
	patron_id smallint not null,
	due date default current_date,
	renewals smallint default 0,
	checkout_id smallint not null,
	return_id smallint not null,
	created_staff_id smallint not null,
	created timestamp with time zone default current_timestamp,
	modified_staff_id smallint,
	modified timestamp with time zone default current_timestamp,
	foreign key (book_id)
		references books (id),
	foreign key (patron_id)
		references patrons (id),
	foreign key (checkout_id)
		references checkouts (id),
	foreign key (return_id)
		references returns (id),
	foreign key (created_staff_id)
		references staff (id),
	foreign key (modified_staff_id)
		references staff (id)
);

-- returns table
create table returns (
	id serial primary key,
	date date not null,
	comment varchar(240) default '',
	overdue boolean not null,
	fine numeric not null,
	created_staff_id smallint not null,
	created timestamp with time zone default current_timestamp,
	modified_staff_id smallint,
	modified timestamp with time zone default current_timestamp,
	foreign key (created_staff_id)
		references staff (id),
	foreign key (modified_staff_id)
		references staff (id)
);

-- checkouts table
create table checkouts (
	id serial primary key,
	date date default current_date,
	comment varchar(240) default '',
	created_staff_id smallint not null,
	created timestamp with time zone default current_timestamp,
	modified_staff_id smallint,
	modified timestamp with time zone default current_timestamp,
	foreign key (created_staff_id)
		references staff (id),
	foreign key (modified_staff_id)
		references staff (id)
);

-- staff table
create table staff(
	id serial primary key,
	fname varchar(30) not null,
	lname varchar(30) not null,
	active boolean not null,
	dob date not null,
	hire date not null check,
	role_id smallint not null,
	created_staff_id smallint not null,
	created timestamp with time zone default current_timestamp,
	modified_staff_id smallint,
	modified timestamp with time zone default current_timestamp,
	foreign key (role_id)
		references roles (id),
	foreign key (created_staff_id)
		references staff (id),
	foreign key (modified_staff_id)
		references staff (id),
	unique (fname, lname, dob, role_id),
)

-- roles table
create table roles (
	id serial primary key,
	role varchar(30) unique not null
)

















