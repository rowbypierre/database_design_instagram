-- create database
create database library;

-- books table
create table books (
	id serial primary key,
	title varchar(120) not null,
	genre_id smallint not null,
	ISBN varchar(15) unique not null ,
	status_id smallint not null,
	condition_id smallint not null,
	created_staff_id smallint not null,
	created timestamp with time zone default current_timestamp,
	modified_staff_id smallint,
	modified timestamp with time zone,	
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
	check (
			(modified is null or created <= modified)  
			and length(ISBN) >= 10
	)
);

-- authors tables
create table authors (
	id serial primary key,
	fname varchar(30) not null,
	lname varchar(30) not null,
	mi varchar(10) not null,
	dob date not null,
	unique(fname, lname, mi, dob),
	check (
			dob <= current_date 
	)
);

-- book_authors table
create table book_authors (
	book_id smallint not null,
	author_id smallint not null,
	foreign key (book_id)
		references books(id) on delete cascade,
	foreign key (author_id)
		references authors(id) on delete cascade,
	unique (book_id, author_id)	
);

-- statuses table
create table statuses (
	id serial primary key,
	status varchar(30) unique not null
);

-- genres table
create table genres (
	id serial primary key,
	genre varchar(30) unique not null
);

-- conditions table
create table conditions (
	id serial primary key,
	condition varchar(30) unique not null
);

-- patrons table
create table patrons (
	id serial primary key,
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
	foreign key (created_staff_id)
		references staff(id),
	foreign key (modified_staff_id)
		references staff(id),
	unique (fname, lname, address, dob),
	check (
			dob <= current_date - interval '14 year' 
			and ((address is not null and length(zip) >= 5 and state is not null)
				or (address is null and zip is null and state is null))	
			and (modified is null or created <= modified)
			and (coalesce((phone)::boolean::integer,0) + 
				coalesce((email)::boolean::integer,0)) >= 1
			and (phone is null or length(phone) >= 10)
			and (email is null or email like '%@%')
	)
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
	modified timestamp with time zone,
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
	check (
			(modified is null or created <= modified)
			and due <= current_date + interval '6 month'
			and renewals <= 3
	)
);

-- returns table
create table returns (
	id serial primary key,
	date date not null,
	comment varchar(240) default '',
	overdue boolean not null,
	fine numeric default 0,
	created_staff_id smallint not null,
	created timestamp with time zone default current_timestamp,
	modified_staff_id smallint,
	modified timestamp with time zone,
	foreign key (created_staff_id)
		references staff(id),
	foreign key (modified_staff_id)
		references staff(id),
	check (
			date between '2000-01-01' and current_date 
			and fine >= 0
			and (modified is null or created <= modified)
	)
);

-- checkouts table
create table checkouts (
	id serial primary key,
	date date default current_date,
	comment varchar(240) default '',
	created_staff_id smallint not null,
	created timestamp with time zone default current_timestamp,
	modified_staff_id smallint,
	modified timestamp with time zone,
	foreign key (created_staff_id)
		references staff(id),
	foreign key (modified_staff_id)
		references staff(id),
	check (
			date >= '2000-01-01'
			and (modified is null or created <= modified)
	)
);

-- staff table
create table staff(
	id serial primary key,
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
	foreign key (role_id)
		references roles(id),
	foreign key (created_staff_id)
		references staff(id),
	foreign key (modified_staff_id)
		references staff(id),
	unique (fname, lname, dob, role_id),
	check (
			dob <= current_date - interval '16 year'
			and hire > dob 
			and hire > '2000-01-01'
			and (modified is null or created <= modified)
	)
);

-- roles table
create table roles (
	id serial primary key,
	role varchar(30) unique not null
);

















