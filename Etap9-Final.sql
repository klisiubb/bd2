/*
Etap 9 - Implementacja kodu wspomagajacego aplkiację uzytkowa
*/

USE [BD2_Mateusz_Klis]
GO

BEGIN TRANSACTION wspomagajace
GO

CREATE VIEW wyswietlPromocje AS
SELECT [Nazwa], [Cena] AS 'Cena aktualna', Cena - (Cena * Rabat) AS 'Cena promocyjna'
FROM [Produkty]
WHERE [Rabat] IS NOT NULL;
GO

CREATE VIEW wyswietlwycofaneProdukty AS
SELECT [Nazwa], [Status]
FROM [Produkty]
WHERE [Status] = 'Produkt wycofany'
GO

CREATE VIEW wyswietlPromocjeUslugi AS
SELECT [Nazwa], [Cena] AS 'Cena aktualna', Cena - (Cena * Rabat) AS 'Cena promocyjna'
FROM [Uslugi]
WHERE [Rabat] IS NOT NULL;
GO


CREATE VIEW wyswietlwycofaneUslugi AS
SELECT [Nazwa], [Status]
FROM Produkty
WHERE [Status] = 'Usluga wycofana';
GO

CREATE VIEW wyswietlPunkty AS
SELECT * FROM [Punkty]
GO

CREATE PROC wyswietlPracownikowWPunkcie @IDPunktu int
AS
SELECT * FROM [Pracownicy] WHERE [IDPunktu] = @IDPunktu
GO

CREATE PROC dodajPracownika(
@PESEL nvarchar(11),
@Imie nvarchar(50),
@Nazwisko nvarchar(50),
@Plec nvarchar(1),
@Numer_telefonu nvarchar(22),
@Adres_email nvarchar(150),
@Data_zatrudnienia date,
@Data_urodzenia date,
@Pensja smallmoney,
@Stanowisko nvarchar(50),
@Dzial nvarchar(50),
@Miasto nvarchar(50),
@Ulica nvarchar(50),
@Numer_budynku nvarchar(10),
@IDPunktu int)
AS
INSERT INTO Pracownicy VALUES(
@PESEL,
@Imie,
@Nazwisko,
@Plec,
@Numer_telefonu,
@Adres_email,
@Data_zatrudnienia,
@Data_urodzenia,
@Pensja,
@Stanowisko,
@Dzial,
@Miasto,
@Ulica,
@Numer_budynku,
@IDPunktu
)
GO

CREATE PROC dodajProdukt(
@Nazwa nvarchar(50),
@Kategoria nvarchar(50),
@Opis nvarchar(255),
@Producent nvarchar(50),
@Cena smallmoney,
@Status nvarchar(50),
@Rabat float)
AS
INSERT INTO Produkty VALUES(
@Nazwa,
@Kategoria,
@Opis,
@Producent,
@Cena,
@Status,
@Rabat)
GO

CREATE PROC dodajUsluge(
@Nazwa nvarchar(50),
@Opis nvarchar(255),
@Cena smallmoney)
AS
INSERT INTO Uslugi(Nazwa,Opis,Cena) VALUES(
@Nazwa,
@Opis,
@Cena)
GO

CREATE PROC wycofajProdukt (@IDProduktu int)
AS
UPDATE Produkty SET [Status] = 'Produkt wycofany' WHERE IDProduktu = @IDProduktu
GO

CREATE PROC wycofajUsluge (@IDUslugi int)
AS
UPDATE Uslugi SET [Status] = 'Usluga wycofana' WHERE IDUslugi = @IDUslugi
GO

CREATE PROC dodajRabatNaProdukt (@IDProduktu int, @Rabat float)
AS
UPDATE Produkty SET Rabat = @Rabat WHERE IDProduktu = @IDProduktu
GO

CREATE PROC dodajRabatNaUsluge (@IDUslugi int, @Rabat float)
AS
UPDATE Uslugi SET Rabat = @Rabat WHERE IDUslugi = @IDUslugi
GO

CREATE PROC zmienCeneProduktu (@IDProduktu int, @Cena smallmoney)
AS
UPDATE Produkty SET Cena = @Cena WHERE IDProduktu = @IDProduktu
GO

CREATE PROC zmienCeneUslugi (@IDUslugi int, @Cena smallmoney)
AS
UPDATE Uslugi SET Cena = @Cena WHERE IDUslugi = @IDUslugi
GO

COMMIT TRANSACTION wspomagajace
GO
