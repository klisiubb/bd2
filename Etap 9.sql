/*
Etap 9
Mateusz Klis
1b
*/

USE BD2_Projekt
GO

CREATE VIEW wyswietlPromocje AS
SELECT Nazwa, Cena AS 'Cena aktualna', Cena - (Cena * Rabat) AS 'Cena promocyjna'
FROM Produkty
WHERE Rabat IS NOT NULL;
GO


CREATE VIEW wyswietlwycofaneProdukty AS
SELECT Nazwa, Wycofany as 'Produkt wycofany'
FROM Produkty
WHERE Wycofany = 1;
GO

CREATE VIEW wyswietlPromocjeUslugi AS
SELECT Nazwa, Cena AS 'Cena aktualna', Cena - (Cena * Rabat) AS 'Cena promocyjna'
FROM Uslugi
WHERE Rabat IS NOT NULL;
GO


CREATE VIEW wyswietlwycofaneUslugi AS
SELECT Nazwa, Wycofany as 'Usluga wycofana'
FROM Produkty
WHERE Wycofany = 1;
GO

CREATE VIEW wyswietlPunkty AS
SELECT * FROM Punkt
GO

CREATE PROC wyswietlPracownikowWPunkcie @IDPunktu int
AS
SELECT * FROM Pracownicy WHERE IDPunktu = @IDPunktu
GO;

CREATE PROC dodajPracownika(
@PESEL nvarchar(11),
@Imie nvarchar(30),
@Nazwisko nvarchar(30),
@Plec nvarchar(1),
@NrTelefonu nvarchar(22),
@Adres_Zamieszkania nvarchar(150),
@Adres_Email nvarchar(150),
@Data_Urodzenia date,
@Data_Zatrudnienia date,
@Pensja smallmoney,
@Stanowisko nvarchar(30),
@Dzial nvarchar(30),
@IDPunktu int )
AS
INSERT INTO Pracownicy VALUES(
@PESEL,
@Imie,
@Nazwisko,
@Plec,
@NrTelefonu,
@Adres_Zamieszkania,
@Adres_Email,
@Data_Urodzenia,
@Data_Zatrudnienia,
@Pensja,
@Stanowisko,
@Dzial,
@IDPunktu)
GO

CREATE PROC dodajProdukt(
@Nazwa nvarchar(50),
@Kategoria nvarchar(30),
@Opis nvarchar(255),
@Producent nvarchar(30),
@Cena smallmoney)
AS
INSERT INTO Produkty(Nazwa,Kategoria,Opis,Producent,Cena) VALUES(
@Nazwa,
@Kategoria,
@Opis,
@Producent,
@Cena)
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
UPDATE Produkty SET Wycofany = 1 WHERE IDProduktu = @IDProduktu
GO

CREATE PROC wycofajUsluge (@IDUslugi int)
AS
UPDATE Uslugi SET Wycofany = 1 WHERE IDUslugi = @IDUslugi
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