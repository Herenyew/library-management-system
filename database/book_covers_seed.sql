USE library_management_db;

SET @cover_column_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'books'
      AND COLUMN_NAME = 'cover_image_url'
);

SET @cover_column_sql = IF(
    @cover_column_exists = 0,
    'ALTER TABLE books ADD COLUMN cover_image_url VARCHAR(500) NULL AFTER available_copies',
    'SELECT 1'
);

PREPARE cover_column_statement FROM @cover_column_sql;
EXECUTE cover_column_statement;
DEALLOCATE PREPARE cover_column_statement;

INSERT INTO books (isbn, title, author, category, published_year, total_copies, available_copies, cover_image_url) VALUES
('978-1780899671', 'The Family Upstairs', 'Lisa Jewell', 'Thriller', 2019, 4, 4, 'assets/img/covers/book1.jpg'),
('978-0062060556', 'Before I Go to Sleep', 'SJ Watson', 'Thriller', 2011, 3, 0, 'assets/img/covers/book2.jpg'),
('978-1538742525', 'Never Lie', 'Freida McFadden', 'Thriller', 2023, 4, 4, 'assets/img/covers/book3.jpg'),
('978-0000000001', 'Love, Mom', 'Iliana Xander', 'Mystery', 2022, 4, 4, 'assets/img/covers/book4.jpg'),
('978-0008371487', 'How to Kill Your Family', 'Bella Mackie', 'Fiction', 2021, 3, 0, 'assets/img/covers/book5.jpg'),
('978-1524714680', 'One of Us Is Lying', 'Karen M. McManus', 'Mystery', 2017, 4, 4, 'assets/img/covers/book6.jpg'),
('978-1538742488', 'The Housemaid', 'Freida McFadden', 'Thriller', 2022, 4, 4, 'assets/img/covers/book7.jpg'),
('978-1250301697', 'The Silent Patient', 'Alex Michaelides', 'Thriller', 2019, 2, 0, 'assets/img/covers/book8.jpg'),
('978-0000000002', 'Read People Like a Book', 'Patrick King', 'Non-Fiction', 2020, 5, 5, 'assets/img/covers/book9.jpg'),
('978-0000000003', 'The Art of Being Alone', 'Renuka Gavrani', 'Non-Fiction', 2023, 5, 5, 'assets/img/covers/book10.jpg')
ON DUPLICATE KEY UPDATE
    title = VALUES(title),
    author = VALUES(author),
    category = VALUES(category),
    published_year = VALUES(published_year),
    cover_image_url = VALUES(cover_image_url);
