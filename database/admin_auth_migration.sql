USE library_management_db;

ALTER TABLE users
    MODIFY password VARCHAR(255) NOT NULL;

DELETE FROM users
WHERE (username = 'admin' AND password = 'admin123')
   OR (username = 'staff1' AND password = 'staff123');
