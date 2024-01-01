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

insert into books (title, genre_id, ISBN, status_id, condition_id, created_staff_id, modified_staff_id) values
('The Mystery of Time', 3, '9783161484100', 1, 1, 95, 95),
('Journey through Science', 17, '9781234567897', 1, 2, 96, 96),
('Exploring the Universe', 4, '9780306406157', 2, 3, 97, 97),
('Art and Creativity', 19, '9783598215001', 3, 4, 98, 98),
('Cooking with Flavors', 15, '9780143039952', 4, 5, 99, 99),
('The Secrets of History', 7, '9780395193958', 5, 6, 100, 100),
('Business and Ethics', 18, '9780525475464', 6, 2, 101, 101),
('Tales of Adventure', 1, '9780747532699', 7, 1, 102, 102),
('Biography of the Brave', 6, '9780691092616', 8, 3, 103, 103),
('Secrets of the Mind', 8, '9780756405675', 9, 4, 104, 104),
('World of Romance', 9, '9780307291367', 10, 5, 105, 105),
('Young Adult Fantasy', 11, '9781402894626', 1, 6, 106, 106),
('Childrens Tales', 12, '9780575070886', 2, 7, 107, 107),
('Poetry and Emotions', 14, '9780684843285', 3, 8, 108, 108),
('Travel the World', 16, '9780743247228', 4, 9, 109, 109),
('Understanding Science', 17, '9780812975298', 5, 10, 110, 110),
('Thrilling Mysteries', 10, '9780743447223', 6, 1, 111, 111),
('Graphic Novel Creations', 13, '9781861978769', 7, 2, 112, 112),
('Religious Insights', 20, '9780312428329', 8, 3, 113, 113),
('Artistic Expressions', 19, '9780307291374', 9, 4, 114, 114)
 ;

 insert into books (title, genre_id, ISBN, status_id, condition_id, created_staff_id, modified_staff_id) values
('Adventure in the Wild', 11, '9780140247749', 1, 1, 95, 95),
('The Modern Philosopher', 2, '9781593083769', 2, 2, 96, 96),
('Secrets of the Ocean', 5, '9781840226355', 3, 3, 97, 97),
('World War Chronicles', 7, '9780061122415', 4, 4, 98, 98),
('Innovations in Technology', 17, '9780140449112', 5, 5, 99, 99),
('The Artistic Mind', 19, '9780679783275', 6, 1, 100, 100),
('Journey Through Europe', 16, '9781593082076', 7, 2, 101, 101),
('Mystery of the Lost City', 3, '9780393964782', 8, 3, 102, 102),
('Legends of the East', 5, '9780451529583', 9, 4, 103, 103),   
('The Art of Cooking', 15, '9780143039990', 10, 5, 104, 104),
('Biography of an Artist', 6, '9780393040018', 1, 6, 105, 105),
('The Science of Everyday Life', 17, '9780140449327', 2, 7, 106, 106),
('Epic Fantasy Tales', 5, '9781593081939', 3, 8, 107, 107),   
('History of Civilizations', 7, '9780451529576', 4, 9, 108, 108),
('The Future of Space Travel', 4, '9781841956182', 5, 10, 109, 109),
('Tales of Courage', 1, '9780140449266', 6, 1, 110, 110),
('The Business Leader', 18, '9780140449181', 7, 2, 111, 111),
('Life in the Sahara', 16, '9780140449204', 8, 3, 112, 112),
('Cultures of the Amazon', 20, '9780312428399', 9, 4, 113, 113),
('Exploring the Deep Sea', 12, '9780575070888', 10, 5, 114, 114);



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

insert into authors (fname, lname, mi, dob) values
('John', 'Doe', 'A', '1971-01-15'),
('Jane', 'Smith', 'B', '1972-02-20'),
('Emily', 'Johnson', 'C', '1973-03-25'),
('Michael', 'Williams', 'D', '1974-04-30'),
('David', 'Brown', 'E', '1975-05-05'),
('Sarah', 'Jones', 'F', '1976-06-10'),
('Daniel', 'Miller', 'G', '1977-07-15'),
('Laura', 'Davis', 'H', '1978-08-20'),
('James', 'Garcia', 'I', '1979-09-25'),
('Linda', 'Rodriguez', 'J', '1980-10-30'),
('Robert', 'Martinez', 'K', '1981-11-05'),
('Patricia', 'Hernandez', 'L', '1982-12-10'),
('Mark', 'Lopez', 'M', '1983-01-15'),
('Elizabeth', 'Gonzalez', 'N', '1984-02-20'),
('Steven', 'Wilson', 'O', '1985-03-25'),
('Maria', 'Anderson', 'P', '1986-04-30'),
('Paul', 'Thomas', 'Q', '1987-05-05'),
('Jennifer', 'Taylor', 'R', '1988-06-10'),
('Andrew', 'Moore', 'S', '1989-07-15'),
('Jessica', 'Jackson', 'T', '1990-08-20'),
('Frank', 'Martin', 'U', '1991-09-25'),
('Sandra', 'Lee', 'V', '1992-10-30'),
('Kevin', 'Perez', 'W', '1993-11-05'),
('Ashley', 'Thompson', 'X', '1994-12-10'),
('Brian', 'White', 'Y', '1995-01-15');

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

insert into book_authors (book_id, author_id) values
(80, 2),
(80, 3),
(81, 4),
(81, 5),
(82, 6),
(82, 7),
(83, 8),
(83, 9),
(84, 10),
(85, 11),
(85, 12),
(86, 13),
(86, 14),
(87, 15),
(87, 16),
(88, 17),
(88, 18),
(89, 19),
(89, 20),
(90, 21),
(91, 22),
(91, 23),
(92, 24),
(92, 25),
(93, 1),
(94, 2),
(95, 3),
(96, 4),
(97, 5),
(98, 6),
(99, 7),
(100, 8),
(101, 9),
(102, 10),
(103, 11),
(104, 12),
(105, 13),
(106, 14),
(107, 15),
(108, 16),
(109, 5),
(110, 6),
(111, 7),
(112, 8),
(113, 9),
(114, 10),
(115, 11),
(116, 12),
(117, 13),
(118, 14),
(119, 15);

-- statuses table
create table statuses (
	id serial primary key,
	status varchar(30) unique not null
);

insert into statuses (status) values
('Available'),
('Checked Out'),
('Reserved'),
('Under Repair'),
('Lost'),
('Archived'),
('In Processing'),
('On Hold'),
('Withdrawn'),
('Reference Only');

-- genres table
create table genres (
	id serial primary key,
	genre varchar(30) unique not null
);

insert into genres (genre) values
('Fiction'),
('Non-Fiction'),
('Mystery'),
('Science Fiction'),
('Fantasy'),
('Biography'),
('History'),
('Self-Help'),
('Romance'),
('Thriller'),
('Young Adult'),
('Children'),
('Graphic Novel'),
('Poetry'),
('Cookbook'),
('Travel'),
('Science'),
('Business'),
('Art'),
('Religion');

-- conditions table
create table conditions (
	id serial primary key,
	condition varchar(30) unique not null
);

insert into conditions (condition) values
('New'),
('As New'),
('Fine'),
('Very Good'),
('Good'),
('Fair'),
('Poor'),
('Missing'),
('Damaged'),
('Repaired'),
('Binding Damaged'),
('Stained'),
('Ex-Library'),
('Annotated'),
('Highlighted'),
('Worn');

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
			-- and (coalesce((phone)::boolean::integer,0) + 
				-- coalesce((email)::boolean::integer,0)) >= 1
			and (phone is null or length(phone) >= 10)
			and (email is null or email like '%@%')
	)
);

insert into patrons (fname, lname, dob, address, zip, state, phone, email, created_staff_id) values
('Alex', 'Johnson', '1985-03-15', '123 Oak St', '27401', 'NC', '3361234567', 'alex.johnson@email.com', 95),
('Beth', 'Davis', '1990-07-22', '456 Pine St', '27405', 'NC', '3362345678', 'beth.davis@email.com', 96),
('Cara', 'Smith', '1983-11-30', '789 Maple Ave', '27408', 'NC', '3363456789', 'cara.smith@email.com', 97),
('David', 'Brown', '1975-05-16', '101 Ash Blvd', '27403', 'NC', '3364567890', 'david.brown@email.com', 98),
('Emily', 'White', '1992-12-10', '202 Elm St', '27409', 'NC', '3365678901', 'emily.white@email.com', 99),
('Frank', 'Martin', '1988-04-05', '505 Cedar Rd', '27410', 'NC', '3366789012', 'frank.martin@email.com', 100),
('Grace', 'Taylor', '1979-09-19', '808 Birch Dr', '27407', 'NC', '3367890123', 'grace.taylor@email.com', 101),
('Henry', 'Jones', '1995-02-28', '303 Dogwood Ln', '27455', 'NC', '3368901234', 'henry.jones@email.com', 102),
('Ivy', 'Lee', '2004-06-14', '707 Magnolia Ct', '27406', 'NC', '3369012345', 'ivy.lee@email.com', 103),
('Jack', 'Wilson', '1978-01-21', '404 Willow Way', '27411', 'NC', '3360123456', 'jack.wilson@email.com', 104),
('Kara', 'Evans', '1993-10-12', '606 Holly St', '27412', 'NC', '3361234501', 'kara.evans@email.com', 105),
('Liam', 'Miller', '1986-08-09', '909 Oakwood Ave', '27413', 'NC', '3362345602', 'liam.miller@email.com', 106),
('Mia', 'Thomas', '2001-03-03', '111 Spruce Ln', '27429', 'NC', '3363456703', 'mia.thomas@email.com', 107),
('Noah', 'Anderson', '1977-07-17', '212 Pinecone Rd', '27414', 'NC', '3364567804', 'noah.anderson@email.com', 108),
('Olivia', 'Harris', '1996-05-05', '313 Fir Cir', '27415', 'NC', '3365678905', 'olivia.harris@email.com', 109),
('Paul', 'Clark', '1989-12-12', '414 Redwood Blvd', '27416', 'NC', '3366789006', 'paul.clark@email.com', 110),
('Quinn', 'Roberts', '2002-02-02', '515 Sycamore St', '27417', 'NC', '3367890107', 'quinn.roberts@email.com', 111),
('Ryan', 'Edwards', '1980-10-10', '616 Juniper Rd', '27418', 'NC', '3368901208', 'ryan.edwards@email.com', 112),
('Sophia', 'Murphy', '1994-04-04', '717 Poplar Ln', '27419', 'NC', '3369012309', 'sophia.murphy@email.com', 113),
('Tyler', 'Garcia', '2005-01-01', '818 Firwood Dr', '27420', 'NC', '3360123401', 'tyler.garcia@email.com', 114);

insert into patrons (fname, lname, dob, address, zip, state, phone, email, created_staff_id) values
('Laura', 'Mitchell', '1987-08-25', '120 Walnut St', '27402', 'NC', '3369987654', 'laura.mitchell@email.com', 95),
('Ethan', 'Collins', '1972-03-11', '220 Oak St', '27403', 'NC', '3368876543', 'ethan.collins@email.com', 96),
('Ava', 'Bell', '2006-05-30', '320 Maple Ave', '27404', 'NC', '3367765432', 'ava.bell@email.com', 97),
('Mason', 'Murphy', '1999-07-19', '420 Ash Blvd', '27405', 'NC', '3366654321', 'mason.murphy@email.com', 98),
('Isabella', 'Rivera', '2003-01-03', '520 Elm St', '27406', 'NC', '3365543210', 'isabella.rivera@email.com', 99),
('Logan', 'Gomez', '1984-11-15', '620 Cedar Rd', '27407', 'NC', '3364432109', 'logan.gomez@email.com', 100),
('Sophie', 'King', '1991-09-23', '720 Birch Dr', '27408', 'NC', '3363321098', 'sophie.king@email.com', 101),
('Owen', 'Wright', '1986-04-07', '820 Dogwood Ln', '27409', 'NC', '3362210987', 'owen.wright@email.com', 102),
('Zoe', 'Lopez', '2000-10-27', '920 Magnolia Ct', '27410', 'NC', '3361109876', 'zoe.lopez@email.com', 103),
('Caleb', 'Hill', '1978-02-17', '1020 Willow Way', '27411', 'NC', '3360098765', 'caleb.hill@email.com', 104),
('Emma', 'Scott', '1994-06-06', '1120 Holly St', '27412', 'NC', '3369987650', 'emma.scott@email.com', 105),
('Aaron', 'Green', '1982-12-12', '1220 Oakwood Ave', '27413', 'NC', '3368876541', 'aaron.green@email.com', 106),
('Chloe', 'Adams', '2005-08-18', '1320 Spruce Ln', '27414', 'NC', '3367765439', 'chloe.adams@email.com', 107),
('Brayden', 'Nelson', '1976-03-03', '1420 Pinecone Rd', '27415', 'NC', '3366654338', 'brayden.nelson@email.com', 108),
('Mia', 'Carter', '1998-04-22', '1520 Fir Cir', '27416', 'NC', '3365543227', 'mia.carter@email.com', 109),
('Hunter', 'Phillips', '1985-10-10', '1620 Redwood Blvd', '27417', 'NC', '3364432116', 'hunter.phillips@email.com', 110),
('Lily', 'Evans', '1996-09-01', '1720 Sycamore St', '27418', 'NC', '3363321005', 'lily.evans@email.com', 111),
('Jordan', 'Torres', '1988-05-20', '1820 Juniper Rd', '27419', 'NC', '3362210994', 'jordan.torres@email.com', 112),
('Natalie', 'Parker', '2002-01-14', '1920 Poplar Ln', '27420', 'NC', '3361109883', 'natalie.parker@email.com', 113),
('Dylan', 'Edwards', '1979-07-08', '2020 Firwood Dr', '27421', 'NC', '3360098772', 'dylan.edwards@email.com', 114);

-- loans table
create table loans (
	id serial primary key,
	book_id smallint not null,
	patron_id smallint not null,
	due date default current_date,
	renewals smallint default 0,
	checkout_id smallint not null,
	return_id smallint,
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

insert into loans (book_id, patron_id, due, checkout_id, return_id, created_staff_id) values
(80, 4, '2023-12-29', 1, 1, 95),
(81, 5, '2023-12-02', 2, 2, 96),
(82, 6, '2024-01-04', 3, 3, 97),
(83, 7, '2023-12-06', 4, 4, 98),
(84, 8, '2023-12-09', 5, 5, 99),
(85, 9, '2023-12-12', 6, 6, 100),
(86, 10, '2024-01-14', 7, 7, 101),
(87, 11, '2023-12-16', 8, 8, 102),
(88, 12, '2024-01-18', 9, 9, 103),
(89, 13, '2023-12-20', 10, 10, 104),
(90, 14, '2024-01-22', 11, 11, 105),
(91, 15, '2023-12-24', 12, 12, 106),
(92, 16, '2024-01-26', 13, 13, 107),
(93, 17, '2023-12-28', 14, 14, 108),
(94, 18, '2024-01-30', 15, 15, 109),
(95, 19, '2024-02-01', 16, 16, 110),
(96, 20, '2024-02-03', 17, 17, 111),
(97, 21, '2024-02-05', 18, 18, 112),
(98, 22, '2024-02-07', 19, 19, 113),
(99, 23, '2024-02-09', 20, 20, 114);


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

insert into returns (date, comment, overdue, fine, created_staff_id, modified_staff_id) values
('2023-12-01', 'Returned on time', FALSE, 0, 95, 95),
('2023-11-28', 'Late return', TRUE, 1.50, 96, 96),
('2023-12-03', 'Returned early', FALSE, 0, 97, 97),
('2023-11-30', 'Slightly late', TRUE, 0.50, 98, 98),
('2023-12-02', 'On time', FALSE, 0, 99, 99),
('2023-11-29', 'Damaged cover', FALSE, 2.00, 100, 100),
('2023-12-04', 'Returned with notes', FALSE, 0, 101, 101),
('2023-11-25', 'Very late return', TRUE, 3.00, 102, 102),
('2023-12-05', 'On time, good condition', FALSE, 0, 103, 103),
('2023-11-26', 'Lost and replaced', TRUE, 15.00, 104, 104);

insert into returns (date, comment, overdue, fine, created_staff_id, modified_staff_id) values
('2023-11-23', 'Returned with bookmark', FALSE, 0, 105, 105),
('2023-11-21', 'Late, damaged pages', TRUE, 2.00, 106, 106),
('2023-12-06', 'On time, good condition', FALSE, 0, 107, 107),
('2023-11-24', 'Very late, cover damaged', TRUE, 4.00, 108, 108),
('2023-12-07', 'Returned on time', FALSE, 0, 109, 109),
('2023-11-22', 'Lost item, paid replacement', TRUE, 20.00, 110, 110),
('2023-12-08', 'Returned early', FALSE, 0, 111, 111),
('2023-11-20', 'Late, but in good condition', TRUE, 1.00, 112, 112),
('2023-12-09', 'On time, requires repair', FALSE, 0, 113, 113),
('2023-11-19', 'Late and missing pages', TRUE, 5.00, 114, 114);

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

insert into checkouts (date, comment, created_staff_id, modified_staff_id) values
('2023-11-15', 'Checked out for 2 weeks', 95, 95),
('2023-11-18', 'Special request', 96, 96),
('2023-11-20', 'New release', 97, 97),
('2023-11-22', 'Checked out by frequent patron', 98, 98),
('2023-11-25', 'Requested by teacher', 99, 99),
('2023-11-28', 'Popular novel', 100, 100),
('2023-11-30', 'Educational material', 101, 101),
('2023-12-02', 'Historical book', 102, 102),
('2023-12-04', 'Science fiction', 103, 103),
('2023-12-06', 'Biography', 104, 104);

insert into checkouts (date, comment, created_staff_id, modified_staff_id) values
('2023-11-16', 'Checked out for research', 105, 105),
('2023-11-19', 'Requested for book club', 106, 106),
('2023-11-21', 'Frequent user, new book', 107, 107),
('2023-11-23', 'Checkout for class project', 108, 108),
('2023-11-26', 'For weekend reading', 109, 109),
('2023-11-29', 'Popular among teenagers', 110, 110),
('2023-12-01', 'Requested by history enthusiast', 111, 111),
('2023-12-03', 'For leisure reading', 112, 112),
('2023-12-05', 'Checkout by a senior citizen', 113, 113),
('2023-12-07', 'Latest magazine issue', 114, 114);

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

insert into staff (fname, lname, active, dob, hire, role_id, created_staff_id, modified_staff_id) values
('John', 'Smith', TRUE, '1980-06-01', '2010-08-15', 1, 1, 1),
('Emily', 'Johnson', TRUE, '1985-09-12', '2015-07-20', 2, 1, 1),
('Michael', 'Brown', TRUE, '1978-04-22', '2008-03-10', 3, 1, 1),
('Sarah', 'Davis', TRUE, '1990-01-15', '2020-02-01', 4, 1, 1),
('David', 'Miller', TRUE, '1983-11-30', '2013-06-23', 5, 1, 1),
('Laura', 'Wilson', TRUE, '1992-05-19', '2022-01-15', 6, 1, 1),
('James', 'Taylor', TRUE, '1975-08-03', '2005-09-17', 7, 1, 1),
('Linda', 'Anderson', TRUE, '1987-12-25', '2017-10-30', 8, 1, 1),
('Robert', 'Thomas', TRUE, '1982-03-14', '2012-05-08', 9, 1, 1),
('Patricia', 'Jackson', TRUE, '1979-07-07', '2009-04-22', 10, 1, 1),
('Mark', 'White', TRUE, '1984-10-28', '2014-08-15', 11, 1, 1),
('Elizabeth', 'Harris', TRUE, '1991-02-20', '2021-03-05', 12, 1, 1),
('Steven', 'Martin', TRUE, '1976-09-11', '2006-12-01', 13, 1, 1),
('Maria', 'Garcia', TRUE, '1989-04-18', '2019-11-20', 14, 1, 1),
('Paul', 'Clark', TRUE, '1981-07-30', '2011-09-09', 15, 1, 1),
('Jennifer', 'Lewis', TRUE, '1993-03-03', '2023-05-10', 16, 1, 1),
('Andrew', 'Lee', TRUE, '1986-08-08', '2016-10-17', 17, 1, 1),
('Jessica', 'Walker', TRUE, '1994-01-22', '2024-07-01', 18, 1, 1),
('Frank', 'Robinson', TRUE, '1977-10-16', '2007-08-25', 19, 1, 1),
('Sandra', 'Lopez', TRUE, '1988-05-05', '2018-12-12', 20, 1, 1);

insert into staff (fname, lname, active, dob, hire, role_id, created_staff_id, modified_staff_id) values
('Alice', 'Morgan', FALSE, '1975-01-10', '2000-09-15', 20, 1, 1),
('Brian', 'Scott', FALSE, '1980-03-05', '2005-04-20', 19, 1, 1),
('Catherine', 'Baker', FALSE, '1985-07-22', '2010-08-01', 18, 1, 1),
('Derek', 'Hill', FALSE, '1978-05-15', '2003-11-10', 17, 1, 1),
('Evelyn', 'Adams', FALSE, '1983-09-30', '2008-06-25', 16, 1, 1),
('Felix', 'Ramirez', FALSE, '1990-12-20', '2015-05-05', 15, 1, 1),
('Grace', 'Torres', FALSE, '1972-11-08', '2000-09-15', 14, 1, 1),
('Hugo', 'Sanders', FALSE, '1986-06-03', '2011-07-15', 13, 1, 1),
('Irene', 'Price', FALSE, '1979-02-28', '2004-03-20', 12, 1, 1),
('Jason', 'Bell', FALSE, '1982-10-14', '2007-09-30', 11, 1, 1),
('Karen', 'Murphy', FALSE, '1984-04-09', '2009-05-22', 10, 1, 1),
('Luis', 'Rivera', FALSE, '1987-08-16', '2012-10-08', 9, 1, 1),
('Mia', 'Peterson', FALSE, '1976-11-23', '2001-12-03', 8, 1, 1),
('Nathan', 'Reed', FALSE, '1989-03-06', '2014-04-18', 7, 1, 1),
('Olivia', 'Cook', FALSE, '1981-07-19', '2006-08-07', 6, 1, 1),
('Peter', 'Russell', FALSE, '1992-02-11', '2017-03-29', 5, 1, 1),
('Quinn', 'Perry', FALSE, '1985-05-27', '2010-06-16', 4, 1, 1),
('Rachel', 'Brooks', FALSE, '1977-09-14', '2002-10-21', 3, 1, 1),
('Simon', 'Kennedy', FALSE, '1988-08-08', '2013-09-09', 2, 1, 1),
('Tina', 'Ward', FALSE, '1991-12-25', '2016-11-30', 1, 1, 1);


-- roles table
create table roles (
	id serial primary key,
	role varchar(30) unique not null
);

insert into roles (role) values
('Librarian'),
('Assistant Librarian'),
('Library Technician'),
('Circulation Manager'),
('Cataloger'),
('Archivist'),
('Collection Development Manager'),
('Digital Resources Manager'),
('Reference Librarian'),
('Youth Services Librarian'),
('Technical Services Librarian'),
('Library Director'),
('Library Assistant'),
('Outreach Coordinator'),
('Programming Coordinator'),
('IT Support Specialist'),
('Acquisitions Librarian'),
('Systems Librarian'),
('Research Librarian'),
('Metadata Librarian');