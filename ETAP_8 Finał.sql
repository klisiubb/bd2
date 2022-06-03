
USE [BD2_Mateusz_Klis]
GO

/*
Etap 8 - definicja nie deklaratywnych mechanizmow
*/
BEGIN TRANSACTION niedeklaratywne

ALTER TABLE [Klienci]
	ADD CONSTRAINT Data_rejestracji
	DEFAULT GETDATE() FOR [Data_rejestracji];
GO

ALTER TABLE [Pracownicy]
ADD CONSTRAINT pensjaMinimalna CHECK ([Pensja] >= 3010.00)
GO

ALTER TABLE [Produkty]
ADD CONSTRAINT cenaProduktuWiekszaOdZera CHECK ([Cena] >=0)
GO

ALTER TABLE [Uslugi]
ADD CONSTRAINT cenaUslugiWiekszaOdZera CHECK ([Cena] >=0)
GO

ALTER TABLE [Zamowienia]
ADD CONSTRAINT wartoscZamWiekszaOdZera CHECK ([Kwota_zamowienia] >=0)
GO

ALTER TABLE [Zamowienia_uslug]
ADD CONSTRAINT zamuslugwiekszeOdZera CHECK ([Kwota_zamowienia] >=0)
GO

DROP TRIGGER IF EXISTS [dbo].[sprawdzWiekKlienta]
GO

CREATE TRIGGER sprawdzWiekKlienta ON [Klienci]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @Age date;
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN	
		SET @Age = (SELECT [Data_urodzenia] FROM inserted)	
		IF Datediff(YEAR, @Age, Getdate()) <18
        BEGIN
			RAISERROR('Blad wiek ponizej 18 lat', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[sprawdzPlecKlienta]
GO

CREATE TRIGGER sprawdzPlecKlienta ON [Klienci]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @Sex nvarchar(1)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
	SET @Sex = (SELECT [Plec] FROM inserted)
	IF (@Sex NOT IN ('k','m','n') )
	BEGIN
		RAISERROR('Wprowadzono nie poprawna plec. Dopuszcza sie tylko wartosci: k,m,n', 16,1)
		ROLLBACK TRANSACTION
		END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[sprawdzTelefonKlienta]
GO

CREATE TRIGGER sprawdzTelefonKlienta ON [Klienci]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @phone nvarchar(22)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @phone = (SELECT [Numer_telefonu] FROM inserted)
		IF @phone LIKE '%[^0-9]%'
			BEGIN
			RAISERROR('Numer telefonu moze zawierac tylko cyfry', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[sprawdzDaneKlienta]
GO

CREATE TRIGGER sprawdzDaneKlienta ON [Klienci]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @firstname nvarchar(50)
	DECLARE @lastname nvarchar(50)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @firstname = (SELECT [Imie] FROM inserted)
		SET @lastname = (SELECT [Nazwisko] FROM inserted)
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

DROP TRIGGER IF EXISTS [dbo].[sprawdzEmail]
GO

CREATE TRIGGER sprawdzEmail ON [Klienci]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @email nvarchar(150)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @email = (SELECT [Adres_email] FROM inserted)
		IF @email NOT LIKE '%_@%_.__%'
			BEGIN
				RAISERROR('Wprowadzono niepoprawny adres email', 16,1)
				ROLLBACK TRANSACTION
			END
	END;
GO

DROP FUNCTION IF EXISTS [dbo].[IsValidNip]
GO

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

DROP TRIGGER IF EXISTS [dbo].[sprawdzNIP]
GO

CREATE TRIGGER sprawdzNIP ON [Klienci]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @nip nvarchar(10)

	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @nip = (SELECT [NIP] FROM inserted)
		IF dbo.isValidNip(@nip) = 0
			BEGIN
			RAISERROR('Podany NIP nie jest poprawnym numerem NIP', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

DROP FUNCTION IF EXISTS [dbo].[IsValidPesel]
GO

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

DROP TRIGGER IF EXISTS [dbo].[sprawdzPesel]
GO

CREATE TRIGGER sprawdzPesel ON [Pracownicy]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @pesel nvarchar(30)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @pesel = (SELECT [PESEL] FROM inserted)
		IF dbo.IsValidPesel(@pesel) = 0
			BEGIN
			RAISERROR(' Podany PESEL nie jest poprawnym numerem PESEL', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[sprawdzWiekPracownika]
GO

CREATE TRIGGER sprawdzWiekPracownika ON [Pracownicy]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @Age date;
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN	
		SET @Age = (SELECT [Data_urodzenia] FROM inserted)	
		IF Datediff(YEAR, @Age, Getdate()) <18
        BEGIN
			RAISERROR('Blad: Nie mozna zatrudnic osoby niepelnoletniej.', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[sprawdzPlecPracownika]
GO

CREATE TRIGGER sprawdzPlecPracownika ON [Pracownicy]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @Sex nvarchar(1)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
	SET @Sex = (SELECT [Plec] FROM inserted)
	IF (@Sex NOT IN ('k','m','n') )
	BEGIN
			RAISERROR('Wprowadzono nie poprawna plec. Dopuszcza sie tylko wartosci: k,m,n', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[sprawdzTelefonPracownika]
GO

CREATE TRIGGER sprawdzTelefonPracownika ON [Pracownicy]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @phone nvarchar(22)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @phone = (SELECT [Numer_telefonu] FROM inserted)
		IF @phone LIKE '%[^0-9]%'
			BEGIN
			RAISERROR('Numer telefonu moze zawierac tylko cyfry', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[sprawdzDanePracownika]
GO

CREATE TRIGGER sprawdzDanePracownika ON [Pracownicy]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @firstname nvarchar(50)
	DECLARE @lastname nvarchar(50)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @firstname = (SELECT [Imie] FROM inserted)
		SET @lastname = (SELECT [Nazwisko] FROM inserted)
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

DROP TRIGGER IF EXISTS [dbo].[sprawdzEmailPracownika]
GO

CREATE TRIGGER sprawdzEmailPracownika ON [Pracownicy]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @email nvarchar(150)
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @email = (SELECT [Adres_email] FROM inserted)
		IF @email NOT LIKE '%_@%_.__%'
			BEGIN
				RAISERROR('Wprowadzono niepoprawny adres email', 16,1)
				ROLLBACK TRANSACTION
			END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[walidacjaDaty1]
GO

CREATE TRIGGER walidacjaDaty1 ON [Zamowienia]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @zlozenie smalldatetime
	DECLARE @realizacja smalldatetime
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @zlozenie = (SELECT [Data_zlozenia] FROM inserted)
		SET @realizacja = (SELECT [Data_realizacji] FROM inserted)
		IF(DATEDIFF(HOUR,@zlozenie, GETDATE()) >= DATEDIFF(HOUR,@realizacja, GETDATE()))
			BEGIN
			RAISERROR('Data realizacji nie moze byc wczesniejsza niz data zlozenia zamowienia', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[walidacjaDaty2]
GO

CREATE TRIGGER walidacjaDaty2 ON [Zamowienia]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @realizacja smalldatetime
	DECLARE @wysylka smalldatetime
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @realizacja = (SELECT [Data_realizacji] FROM inserted)
		SET @wysylka = (SELECT [Data_wyslania] FROM inserted)
		IF(DATEDIFF(HOUR,@realizacja, GETDATE()) >= DATEDIFF(HOUR,@wysylka, GETDATE()))
			BEGIN
			RAISERROR('Data wysylki nie moze byc wczesniejsza niz data realizacji zamowienia', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO

DROP TRIGGER IF EXISTS [dbo].[walidacjaDaty3]
GO

CREATE TRIGGER walidacjaDaty3 ON [Zamowienia_uslug]
FOR INSERT
NOT FOR REPLICATION
AS
	DECLARE @rozpoczecia datetime
	DECLARE @zakoczenia datetime
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		SET @rozpoczecia = (SELECT [Data_rozpoczecia] FROM inserted)
		SET @zakoczenia = (SELECT [Data_zakonczenia] FROM inserted)
		IF(DATEDIFF(HOUR,@rozpoczecia, GETDATE()) >= DATEDIFF(HOUR,@zakoczenia, GETDATE()))
			BEGIN
			RAISERROR('Data zakonczenia nie moze byc wczesniejsza niz data rozpoczecia', 16,1)
			ROLLBACK TRANSACTION
		END
	END;
GO


COMMIT TRANSACTION niedeklaratywne