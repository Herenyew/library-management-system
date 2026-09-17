USE library_management_db;

SELECT id, isbn, title, author, category, published_year, available_copies
FROM books;

SELECT b.title, m.full_name, l.issue_date, l.due_date, l.status
FROM loans l
JOIN books b ON l.book_id = b.id
JOIN members m ON l.member_id = m.id
ORDER BY l.issue_date DESC;

SELECT full_name, email
FROM members
WHERE email LIKE '%example.com';

INSERT INTO members (member_code, full_name, email, phone, address)
VALUES ('MEM010', 'New Member', 'new.member@example.com', '0500000000', 'Sharjah, UAE');

UPDATE books
SET available_copies = available_copies - 1
WHERE id = 1;

DELETE FROM members
WHERE id = 10;
