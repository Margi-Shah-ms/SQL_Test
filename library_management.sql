-- smart library management system  
-- 1. Authors Table
CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

-- 2. Books Table
CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author_id INT,
    category VARCHAR(100),
    isbn VARCHAR(20),
    published_date DATE,
    price NUMERIC,
    available_copies INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- 3. Members Table
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(20),
    membership_date DATE
);

-- 4. Transactions Table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    fine_amount NUMERIC,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);
-- implement CRUD opeations 
-- insert new books, authors, and members into the database.

INSERT INTO authors (author_id, name, email) VALUES
(1, '  J.K. Rowling  ', 'jkrowling@example.com'),
(2, 'George R.R. Martin', 'grrm@example.com'),
(3, '  Stephen Hawking  ', 'hawking@example.com'),
(4, 'Carl Sagan', NULL),
(5, 'James Clear', 'james@example.com');

INSERT INTO books (book_id, title, author_id, category, isbn, published_date, price, available_copies) VALUES
(1, 'A Brief History of Time', 3, 'Science', '9780553380163', '1988-04-01', 450.00, 4),
(2, 'Cosmos', 4, 'Science', '9780345331359', '1980-10-12', 650.00, 0),
(3, 'Harry Potter', 1, 'Fantasy', '9780747532699', '1997-06-26', 200.00, 5),
(4, 'A Game of Thrones', 2, 'Fantasy', '9780553103540', '1996-08-01', 350.00, 0),
(5, 'Atomic Habits', 5, 'Self-Help', '9780735211293', '2018-10-16', 300.00, 6),
(6, 'Physics of the Impossible', 3, 'Science', '9780307278821', '2021-05-11', 400.00, 2);

INSERT INTO members (member_id, name, email, phone_number, membership_date) VALUES
(1, 'Rahul Sharma', 'rahul@example.com', '9876543210', '2019-01-15'),
(2, 'Priya Verma', 'priya@example.com', '9876543211', '2021-05-10'),
(3, 'Amit Patel', 'amit@example.com', '9876543212', '2023-02-01'),
(4, 'Sneha Gupta', NULL, '9876543213', '2018-11-20');

INSERT INTO transactions (transaction_id, member_id, book_id, borrow_date, return_date, fine_amount) VALUES
(1, 1, 1, '2026-04-01', '2026-04-10', 0.00),
(2, 1, 2, '2026-05-01', '2026-05-20', 50.00),
(3, 1, 3, '2026-06-01', '2026-06-12', 0.00),
(4, 1, 5, '2026-07-01', NULL, 0.00),
(5, 2, 1, '2026-08-01', '2026-08-15', 10.00),
(6, 2, 6, '2026-09-01', NULL, 0.00);

-- update book availability after a book borrowed or returned. 
UPDATE books 
SET available_copies = available_copies - 1 
WHERE book_id = 1 AND available_copies > 0;
UPDATE books 
SET available_copies = available_copies + 1 
WHERE book_id = 1;

-- delete members who have not borrowed any books in the last year.
DELETE FROM members 
WHERE member_id NOT IN (
    SELECT DISTINCT member_id 
    FROM transactions 
    WHERE borrow_date >= CURRENT_DATE - INTERVAL '1 year'
);

-- retrieve all books with available copies. 
SELECT * 
FROM books 
WHERE available_copies > 0:

-- 2. use sql clauses (having, where, limit)
-- get books published after the year 2015 
select * from books where published_date > '2015-12-31';

-- retrieve the top 5 most expensive books. 
select * from books order by price desc limit 5;

-- find members who joined before 2022
select * from members where membership_date < '2022-01-01';

-- 3. apply sql operators (and, or, not)
-- get books where category = science and price < 500
select * from books where category = 'Science' and price <500;

-- find all books that are not available for borrowing.   
SELECT * FROM books WHERE NOT (available_copies > 0);

-- list all memebers who joined after 2020 or have borrowed more than 3 books.  
select * from members where membership_date > '2020-12-31' 
or member_id in (select member_id from transactions 
group by member_id having count(*) > 3);

-- sorting & grouping data (order by , group by)
-- list all books sorted by title in alphabetical order
select * from books order by title asc;

-- display the number of books borrowed by each member
select member_id, count(*) as books_borrowed from transactions group by member_id;

-- group books by category and show the total count
select category, count(*) as total_books from books group by category;

-- 5. use aggregate function (sum, avg, max, min, count)
-- find the total number of books in each category
select category, sum(available_copies) as total_copies from books group by category;

-- calculate the average price of books in the library
select avg(price) as average_price from books;

-- identify the most borrowed book
select book_id, count(*) as borrow_count from transactions group by book_id order by borrow_count desc limit 1;

-- calculate the total fines collected
select sum(fine_amount) as total_fines from transactions;

-- 6. establish primary & foreign key relationship. 
-- ensure books are linked to authors
select b.title, a.name as author_name from books b join authors a on b.author_id = a.author_id;


-- establish relationships between members and their transactions
select m.name, t.transaction_id, t.borrow_date from members m join transactions t on m.member_id = t.member_id;

--7. implement joins 
-- inner join- books with author names
select b.title, a.name as author_name 
from books b
inner join authors a on b.author_id = a.author_id;


-- left join- member details who borrowed books
select m.*, t.transaction_id, t.book_id 
from members m
left join transactions t on m.member_id = t.member_id;


-- right join- books that haven't been borrowed
select b.title 
from transactions t
right join books b on t.book_id = b.book_id
where t.transaction_id is null;


-- full outer join- members who have never borrowed a book
select m.name, t.transaction_id 
from members m
full outer join transactions t on m.member_id = t.member_id
where t.transaction_id is null;

-- 8 Use subqueries. 

-- books borrowed by members who registered after 2022
select * from books where book_id in (select distinct book_id 
from transactions where member_id in (
select member_id from members where membership_date > '2022-12-31'));

-- most borrowed book using subquery
select * from books where book_id = (select book_id from transactions 
group by book_id order by count(*) desc limit 1);

-- members who have never borrowed a book
select * from members where member_id not in
(select distinct member_id from transactions);

-- 9. Implement date & time functions 
-- extract the year from published_date to count books by publication year
select extract(year from published_date) as pub_year, count(*) 
from books group by pub_year;

-- find the difference in days between borrow_date and return_date
select transaction_id, (return_date - borrow_date) as duration_days 
from transactions where return_date is not null;

-- format borrow_date as dd-mm-yyyy
select to_char(borrow_date, 'dd-mm-yyyy') as formatted_borrow_date 
from transactions;

-- 10. use string manipulation functions
-- convert all book titles to uppercase
select upper(title) as uppercase_title from books;

-- trim whitespace from author names
select trim(name) as clean_author_name from authors;

-- replace missing email values with "not provided"
select name, replace(coalesce(email, ''), '', 'not provided') as email from members;

-- 11. implement window functions
-- rank books based on the number of times they have been borrowed
select book_id, count(*) as times_borrowed,
dense_rank() over (order by count(*) desc) as ra_nk
from transactions group by book_id;

-- show the cumulative number of books borrowed per member
select member_id, borrow_date,
count(*) over (partition by member_id order by borrow_date) as cumulative_borrowed
from transactions;


-- display the moving average of books borrowed in the last 3 months
select borrow_date, 
avg(count(*)) over (order by borrow_date 
range between interval '3 months'
preceding and current row) as moving_avg
from transactions group by borrow_date;


-- 12. apply sql case expressions
-- assign a membership_status column (active / inactive)
select member_id, name,
    case 
        when member_id in (
            select distinct member_id 
            from transactions 
            where borrow_date >= current_date - interval '6 months'
        ) then 'active'
        else 'inactive'
    end as membership_status
from members;


-- categorize books (new arrival / classic / regular)
select title, published_date,
    case 
        when extract(year from published_date) > 2020 then 'new arrival'
        when extract(year from published_date) < 2000 then 'classic'
        else 'regular'
    end as book_category
from books;

