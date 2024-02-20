CREATE DATABASE NewLibrary

USE NewLibrary

CREATE TABLE Books
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(100) CHECK(LEN([Name]) BETWEEN 2 AND 100),
    Price MONEY,
    AuthorId INT FOREIGN KEY REFERENCES Authors(Id),
    [PageCount] INT CHECK([PageCount] >= 10)
)

CREATE TABLE Authors
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(20),
    Surname NVARCHAR(20)
)

-- Insert data into Authors table
INSERT INTO Authors
    ([Name], Surname)
VALUES
    ('John', 'Doe'),
    ('Jane', 'Smith'),
    ('Michael', 'Johnson')

-- Insert data into Books table
INSERT INTO Books
    ([Name], Price, AuthorId, [PageCount])
VALUES
    ('Book1', 20.50, 1, 150),
    ('Book2', 15.75, 2, 200),
    ('Book3', 25.00, 3, 180)

-- Id,Name,PageCount ve AuthorFullName columnlarının valuelarını qaytaran bir view yaradın
GO
CREATE VIEW VW_1
AS
    SELECT B.Id, B.Name, B.PageCount, CONCAT(A.Name, ' ', A.Surname) AS AuthorFullname
    FROM Books AS B
        INNER JOIN Authors AS A ON A.Id = B.AuthorId
GO

-- Göndərilmiş axtarış dəyərinə görə həmin axtarış dəyəri name və ya authorFullName-lərində olan Book-ları Id,Name,PageCount,AuthorFullName columnları şəklində göstərən procedure yazın
-- VIEW istifadə edə bilmədim
GO
CREATE PROCEDURE PR_1
    @searchValue NVARCHAR(100)
AS
SELECT B.Id, B.Name, B.PageCount, CONCAT(A.Name, ' ', A.Surname) AS AuthorFullname
FROM Books AS B
    INNER JOIN Authors AS A ON A.Id = B.AuthorId
WHERE B.Name LIKE '%' + @searchValue + '%'
    OR CONCAT(A.Name, ' ', A.Surname) LIKE '%' + @searchValue + '%'
GO

EXEC PR_1 'a'

-- Book tabledaki verilmiş id-li datanın qiymıətini verilmiş yeni qiymətə update edən procedure yazın.
GO
CREATE PROCEDURE PR_2
    @givenId INT,
    @newPrice MONEY
AS
UPDATE Books
SET Price = @newPrice
WHERE Id = @givenId
GO

EXEC PR_2 1, 100

-- Authors-ları Id,FullName,BooksCount,MaxPageCount şəklində qaytaran view yaradırsınız
GO
CREATE VIEW VW_2
AS
    SELECT A.Id, CONCAT(A.Name, ' ', A.Surname) AS FullName, COUNT(B.Id) AS BooksCount, MAX(B.PageCount) AS MaxPageCount
    FROM Authors AS A
        INNER JOIN Books AS B ON A.Id = B.AuthorId
    GROUP BY A.Id, A.Name, A.Surname
GO

-- Additional tasks

-- 1. Scalar functions
GO
CREATE FUNCTION FN_1
(@FirstName NVARCHAR(50), @LastName NVARCHAR(50))
RETURNS NVARCHAR(100)
AS
BEGIN
    RETURN CONCAT(@FirstName, ' ', @LastName)
END
GO

SELECT dbo.FN_1('John', 'Doe')

-- 2. Table-Valued functions
GO
CREATE FUNCTION FN_2
(@AuthorId INT)
RETURNS TABLE
AS
RETURN (
SELECT *
FROM Authors AS A
WHERE A.Id = @AuthorId
)
GO

SELECT *
FROM dbo.FN_2(1)
