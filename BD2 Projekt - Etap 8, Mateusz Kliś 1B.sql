/*
	
    Mateusz Kliœ, Gr1B - Sieæ sklepów rowerowych, etap 8

*/

USE [BD2_Projekt]
GO

-- TABELA KLIENCI
---------------------------------------------------------------------------------------
-- Sprawdzenie pe³noletnoœci 
CREATE TRIGGER checkAgeClient ON Klienci
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @Age datetime;
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN	
		SET @Age = (SELECT Data_Urodzenia FROM inserted)	
		IF Datediff(YEAR, @Age, Getdate()) <18
        BEGIN
			RAISERROR('B³¹d: Wiek poni¿ej 18 lat.', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
---------------------------------------------------------------------------------------
-- Sprawdzanie p³ci
CREATE TRIGGER checkSexClient ON Klienci
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @Sex nvarchar(1)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
	SET @Sex = (SELECT P³eæ FROM inserted)
	IF (@Sex NOT IN ('k','m','n') )
	BEGIN
			RAISERROR('Wprowadzono nie poprawna p³eæ. Dopuszcza siê tylko wartoœci: k,m,n', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
---------------------------------------------------------------------------------------
-- Sprawdzanie  numeru telefonu
CREATE TRIGGER checkPhoneClient ON Klienci
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @phone nvarchar(22)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @phone = (SELECT NrTelefonu FROM inserted)
		IF @phone LIKE '%[^0-9]%'
			BEGIN
			RAISERROR('Numer telefonu mo¿e zawieraæ tylko cyfry', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
---------------------------------------------------------------------------------------
--Sprawdzenie imienia i nazwiska
CREATE TRIGGER checkNameClient ON Klienci
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @firstname nvarchar(30)
	DECLARE @lastname nvarchar(30)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @firstname = (SELECT Imiê FROM inserted)
		SET @lastname = (SELECT Nazwisko FROM inserted)
		IF @firstname LIKE '%[^A-Z]%'
			BEGIN
			RAISERROR('Wprowadzono niepoprawne imie', 16,1)
			ROLLBACK TRANSACTION
		END
		IF  @lastname LIKE '%[^A-Z]%'
			BEGIN
			RAISERROR('Wprowadzono niepoprawne nazwisko', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
---------------------------------------------------------------------------------------
--Sprawdzenie emaila
CREATE TRIGGER checkEmailClient ON Klienci
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @email nvarchar(150)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @email = (SELECT Adres_Email FROM inserted)
		IF @email NOT LIKE '%_@%_.__%'
			BEGIN
				RAISERROR('Wprowadzono niepoprawny adres email', 16,1)
				ROLLBACK TRANSACTION
			END
	END;
GO
---------------------------------------------------------------------------------------
-- Funkcja do walidacji nipu
CREATE FUNCTION IsValidNip
(
  @nip nvarchar(10)
)
RETURNS bit
AS
BEGIN
  IF ISNUMERIC(@nip) = 0
    RETURN 0
  DECLARE
    @weights AS TABLE
    (
      Position tinyint IDENTITY(1,1) NOT NULL,
      Weight tinyint NOT NULL
    )
  INSERT INTO @weights VALUES (6), (5), (7), (2), (3), (4), (5), (6), (7)
  IF SUBSTRING(@nip, 10, 1) = (SELECT SUM(CONVERT(TINYINT, SUBSTRING(@nip, Position, 1)) * Weight) % 11 FROM @weights)
    RETURN 1
  RETURN 0
END
GO
---------------------------------------------------------------------------------------
-- Trigger do sprawdzania nipu
CREATE TRIGGER checkNIP ON Klienci
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @nip nvarchar(10)

	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @nip = (SELECT NIP FROM inserted)
		IF dbo.IsValidNip(@nip) = 0
			BEGIN
			RAISERROR('Podany NIP nie jest poprawnym numerem NIP', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

--TABELA PRACOWNICY
---------------------------------------------------------------------------------------
-- Funkcja do walidacji peselu
CREATE FUNCTION IsValidPesel
(
	@pesel nvarchar(11)
)
RETURNS bit
AS
BEGIN

	IF ISNUMERIC(@pesel) = 0
		RETURN 0

	DECLARE
		@weights AS TABLE
		(
			Position tinyint IDENTITY(1,1) NOT NULL,
			Weight tinyint NOT NULL
		)

	INSERT INTO @weights VALUES (1), (3), (7), (9), (1), (3), (7), (9), (1), (3), (1)

	IF (SELECT SUM(CONVERT(TINYINT, SUBSTRING(@pesel, Position, 1)) * Weight) % 10 FROM @weights ) = 0
		RETURN 1

	RETURN 0

END
GO
---------------------------------------------------------------------------------------
-- trigger do walidacji peselu
CREATE TRIGGER checkPesel ON Pracownicy
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @pesel nvarchar(30)

	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @pesel = (SELECT PESEL FROM inserted)
		IF dbo.IsValidPesel(@pesel) = 0
			BEGIN
			RAISERROR(' Podany PESEL nie jest poprawnym numerem PESEL', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
--------------------------------------------------------------------------------------
-- Sprawdzenie pe³noletnoœci 
CREATE TRIGGER checkAgeWorker ON Pracownicy
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @Age datetime;
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN	
		SET @Age = (SELECT Data_Urodzenia FROM inserted)	
		IF Datediff(YEAR, @Age, Getdate()) <18
        BEGIN
			RAISERROR('B³¹d: Nie mo¿na zatrudniæ osoby niepe³noletniej.', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
---------------------------------------------------------------------------------------
-- Sprawdzanie p³ci
CREATE TRIGGER checkSexWorker ON Pracownicy
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @Sex nvarchar(1)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
	SET @Sex = (SELECT P³eæ FROM inserted)
	IF (@Sex NOT IN ('k','m','n') )
	BEGIN
			RAISERROR('Wprowadzono nie poprawna p³eæ. Dopuszcza siê tylko wartoœci: k,m,n', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
---------------------------------------------------------------------------------------
-- Sprawdzanie  numeru telefonu
CREATE TRIGGER checkPhoneWorker ON Pracownicy
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @phone nvarchar(22)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @phone = (SELECT NrTelefonu FROM inserted)
		IF @phone LIKE '%[^0-9]%'
			BEGIN
			RAISERROR('Numer telefonu mo¿e zawieraæ tylko cyfry', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
---------------------------------------------------------------------------------------
--Sprawdzenie imienia i nazwiska
CREATE TRIGGER checkNameWorker ON Pracownicy
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @firstname nvarchar(30)
	DECLARE @lastname nvarchar(30)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @firstname = (SELECT Imiê FROM inserted)
		SET @lastname = (SELECT Nazwisko FROM inserted)
		IF @firstname LIKE '%[^A-Z]%'
			BEGIN
			RAISERROR('Wprowadzono niepoprawne imie', 16,1)
			ROLLBACK TRANSACTION
		END
		IF  @lastname LIKE '%[^A-Z]%'
			BEGIN
			RAISERROR('Wprowadzono niepoprawne nazwisko', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
---------------------------------------------------------------------------------------
--Sprawdzenie emaila
CREATE TRIGGER checkEmailWorker ON Pracownicy
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @email nvarchar(150)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @email = (SELECT Adres_Email FROM inserted)
		IF @email NOT LIKE '%_@%_.__%'
			BEGIN
				RAISERROR('Wprowadzono niepoprawny adres email', 16,1)
				ROLLBACK TRANSACTION
			END
	END;
GO
---------------------------------------------------------------------------------------
-- dodanie Checka, na wartoœæ minimalnego wynagrodzenia
ALTER TABLE Pracownicy
ADD CONSTRAINT valueCheck CHECK (Pensja >= 3010.00)
GO

--TABELA Produkty
---------------------------------------------------------------------------------------
-- Cena nie mo¿e byæ ujemna
ALTER TABLE Produkty
ADD CONSTRAINT priceGreaterThanZero CHECK (Cena >=0)

--TABELA Us³ugi
---------------------------------------------------------------------------------------
-- Cena nie mo¿e byæ ujemna
ALTER TABLE Uslugi
ADD CONSTRAINT priceGreaterThanZero CHECK (Cena >=0)

--TABELA Zamowienia
---------------------------------------------------------------------------------------
-- Kwota zamówienia nie mo¿e byæ ujemna
ALTER TABLE Zamówienia
ADD CONSTRAINT valueGreaterThanZero CHECK (Kwota_Zamowienia >=0)
GO
---------------------------------------------------------------------------------------
--  Trigger sprawdzajacy poprawnosc wprowadzania daty realizacji i zamowienia
CREATE TRIGGER dateValidation1 ON Zamowienia
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @zlozenie smalldatetime
	DECLARE @realizacja smalldatetime
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @zlozenie = (SELECT Data_Z³o¿enia FROM inserted)
		SET @realizacja = (SELECT Data_Realizacji FROM inserted)
		IF(DATEDIFF(HOUR,@zlozenie, GETDATE()) >= DATEDIFF(HOUR,@realizacja, GETDATE()))
			BEGIN
			RAISERROR('Data realizacji nie mo¿e byæ wczeœniejsza ni¿ data z³o¿enia zamówienia', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
---------------------------------------------------------------------------------------
--  Trigger sprawdzajacy poprawnosc wprowadzania daty realizacji i wysylki
CREATE TRIGGER dateValidation2 ON Zamowienia
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @realizacja smalldatetime
	DECLARE @wysylka smalldatetime
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @realizacja = (SELECT Data_Realizacji FROM inserted)
		SET @wysylka = (SELECT Data_Wys³ania FROM inserted)
		IF(DATEDIFF(HOUR,@realizacja, GETDATE()) >= DATEDIFF(HOUR,@wysylka, GETDATE()))
			BEGIN
			RAISERROR('Data wysy³ki nie mo¿e byæ wczeœniejsza ni¿ data realizacji zamówienia', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

--TABELA Zamowienia_Us³ug
---------------------------------------------------------------------------------------
-- Kwota zamówienia nie mo¿e byæ ujemna
ALTER TABLE Zamówienia
ADD CONSTRAINT valueGreaterThanZero CHECK (Kwota_Zamowienia >=0)
GO
---------------------------------------------------------------------------------------
--  Trigger sprawdzajacy poprawnosc wprowadzania daty realizacji i wysylki
CREATE TRIGGER dateValidation2 ON Zamowienia_Uslug
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @rozpoczecia smalldatetime
	DECLARE @zakoczenia smalldatetime
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @rozpoczecia = (SELECT Data_Rozpoczecia FROM inserted)
		SET @zakoczenia = (SELECT Data_Zakoczenia FROM inserted)
		IF(DATEDIFF(HOUR,@rozpoczecia, GETDATE()) >= DATEDIFF(HOUR,@zakoczenia, GETDATE()))
			BEGIN
			RAISERROR('Data zakonczenia nie mo¿e byæ wczeœniejsza ni¿ data rozpoczecia', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO
