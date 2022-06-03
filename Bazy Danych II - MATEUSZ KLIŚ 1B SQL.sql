/*
Mateusz Klis - Grup 1B, 2022. 
Temat - "Siec sklepów rowerowych"

Skrypt - wersja finalna.
*/

/*
Etap 6 - tworzenie bazy danych
*/

USE [master]
GO

IF DB_ID(N'BD2_Mateusz_Klis') IS NOT NULL
DROP DATABASE BD2_Mateusz_Klis;
GO

CREATE DATABASE BD2_Mateusz_Klis
ON
(
NAME = BD2_Mateusz_Klis,
FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BD2_Mateusz_Klis.mdf',
SIZE = 10,
MAXSIZE = 200,
FILEGROWTH = 5
)
LOG ON (
NAME = BD2_Mateusz_Klis_log,
FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BD2_Mateusz_Klis_log.ldf',
SIZE = 10,
MAXSIZE = 100,
FILEGROWTH = 5
);
GO 

USE [BD2_Mateusz_Klis]
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DROP TABLE IF EXISTS [dbo.Punkty];
GO

CREATE TABLE [Punkty]
(
	[IDPunktu] INT IDENTITY(1,1) NOT NULL PRIMARY KEY ,
    [Liczebnosc_zespolu] tinyint  NULL ,
    [Typ_punktu] nvarchar(30)  NOT NULL ,
    [Miasto] nvarchar(50)  NOT NULL ,
    [Ulica] nvarchar(50)  NOT NULL ,
    [Numer_budynku] nvarchar(10)  NOT NULL
)

DROP TABLE IF EXISTS [dbo.Pracownicy];
GO

CREATE TABLE [Pracownicy]
(
    [PESEL] nvarchar(11)  NOT NULL PRIMARY KEY ,
    [Imie] nvarchar(50)  NOT NULL ,
    [Nazwisko] nvarchar(50)  NOT NULL ,
    [Plec] nvarchar(1)  NOT NULL ,
    [Numer_telefonu] nvarchar(22)  NOT NULL ,
    [Adres_email] nvarchar(150)  NOT NULL ,
    [Data_urodzenia] date  NOT NULL ,
    [Data_zatrudnienia] date  NOT NULL ,
    [Pensja] smallmoney  NOT NULL ,
    [Stanowisko] nvarchar(50)  NOT NULL ,
    [Dzial] nvarchar(50)  NOT NULL ,
    [Miasto] nvarchar(50)  NOT NULL ,
    [Ulica] nvarchar(50)  NOT NULL ,
    [Numer_budynku] nvarchar(10)  NOT NULL ,
    [IDPunktu] INT  NOT NULL 
)

DROP TABLE IF EXISTS [dbo.Klienci];
GO

CREATE TABLE [Klienci]
(
    [IDKlienta] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NIP] nvarchar(10)  NULL ,
    [Imie] nvarchar(50)  NOT NULL ,
    [Nazwisko] nvarchar(50)  NOT NULL ,
    [Plec] nvarchar(1)  NOT NULL ,
    [Numer_telefonu] nvarchar(22)  NOT NULL ,
    [Adres_email] nvarchar(150)  NOT NULL ,
    [Data_urodzenia] date  NOT NULL ,
    [Data_rejestracji] date  NOT NULL ,
    [Miasto] nvarchar(50)  NOT NULL ,
    [Ulica] nvarchar(50)  NOT NULL ,
    [Numer_budynku] nvarchar(10)  NOT NULL
)

DROP TABLE IF EXISTS [dbo.Produkty];
GO

CREATE TABLE [Produkty]
(
    [IDProduktu] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Nazwa] nvarchar(50)  NOT NULL ,
    [Kategoria] nvarchar(50)  NOT NULL ,
    [Opis] nvarchar(255)  NULL ,
    [Producent] nvarchar(50)  NOT NULL ,
    [Cena] smallmoney  NOT NULL ,
    [Status] nvarchar(50)  NOT NULL ,
    [Rabat] float  NULL
)

DROP TABLE IF EXISTS [dbo.Uslugi];
GO

CREATE TABLE [Uslugi]
(
    [IDUslugi] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Nazwa] nvarchar(50)  NOT NULL ,
    [Opis] nvarchar(255)  NULL ,
    [Cena] smallmoney  NOT NULL ,
    [Status] nvarchar(50)  NOT NULL ,
    [Rabat] float  NULL
)

DROP TABLE IF EXISTS [dbo.Zamowienia];
GO

CREATE TABLE [Zamowienia]
(
    [IDZamowienia] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Kwota_zamowienia] smallmoney  NOT NULL ,
    [Data_zlozenia] datetime  NOT NULL ,
    [Data_realizacji] datetime  NULL ,
    [Data_wyslania] datetime  NULL ,
    [Uwagi] nvarchar(255)  NULL ,
    [IDKlienta] INT  NOT NULL ,
    [IDPracownika] nvarchar(11)  NOT NULL
)

DROP TABLE IF EXISTS [dbo.Zamowienia_uslug];
GO

CREATE TABLE [Zamowienia_uslug]
(
    [IDZamowienia] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Kwota_zamowienia] smallmoney  NOT NULL ,
    [Data_rozpoczecia] datetime  NOT NULL ,
    [Data_zakonczenia] datetime  NULL ,
    [Uwagi] nvarchar(255)  NULL ,
    [IDKlienta] INT  NOT NULL ,
    [IDPracownika] nvarchar(11)  NOT NULL
)

DROP TABLE IF EXISTS [dbo.Stan_magazynu];
GO

CREATE TABLE [Stan_magazynu] (
    [IDPozycji] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [IDProduktu] int  NOT NULL ,
    [IDPunktu] int  NOT NULL ,
    [Ilosc] smallint  NOT NULL ,
    [Uwagi] nvarchar(255)  NULL
)

DROP TABLE IF EXISTS [dbo.Pozycje_zamowienia];
GO

CREATE TABLE [Pozycje_zamowienia] (
    [IDPozycji] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Ilosc] tinyint  NOT NULL ,
    [IDProduktu] INT  NOT NULL ,
    [IDZamowienia] INT  NOT NULL
)

DROP TABLE IF EXISTS [dbo.Pozycje_zamowienia_uslug];
GO

CREATE TABLE [Pozycje_zamowienia_uslug] (
    [IDPozycji] INT IDENTITY(1,1) NOT NULL  PRIMARY KEY,
    [Ilosc] tinyint  NOT NULL ,
    [IDUslugi] INT  NOT NULL ,
    [IDZamowienia] INT  NOT NULL
)

COMMIT TRANSACTION

USE [BD2_Mateusz_Klis]
GO

BEGIN TRANSACTION fk

ALTER TABLE [Pracownicy]
ADD FOREIGN KEY ([IDPunktu]) REFERENCES [Punkty]([IDPunktu])

ALTER TABLE [Zamowienia]
ADD FOREIGN KEY ([IDKlienta]) REFERENCES [Klienci]([IDKlienta])

ALTER TABLE [Zamowienia]
ADD FOREIGN KEY ([IDPracownika]) REFERENCES [Pracownicy]([PESEL])

ALTER TABLE [Zamowienia_uslug]
ADD FOREIGN KEY ([IDKlienta]) REFERENCES [Klienci]([IDKlienta])

ALTER TABLE [Zamowienia_uslug] 
ADD FOREIGN KEY ([IDPracownika]) REFERENCES [Pracownicy]([PESEL])

ALTER TABLE [Stan_magazynu]
ADD FOREIGN KEY ([IDProduktu]) REFERENCES [Produkty]([IDProduktu])

ALTER TABLE [Stan_magazynu]
ADD FOREIGN KEY ([IDPunktu]) REFERENCES [Punkty]([IDPunktu])

ALTER TABLE [Pozycje_zamowienia]
ADD FOREIGN KEY ([IDProduktu]) REFERENCES [Produkty]([IDProduktu])

ALTER TABLE [Pozycje_zamowienia]
ADD FOREIGN KEY ([IDZamowienia]) REFERENCES [Zamowienia]([IDZamowienia])

ALTER TABLE [Pozycje_zamowienia_uslug]
ADD FOREIGN KEY ([IDUslugi]) REFERENCES [Uslugi]([IDUslugi])

ALTER TABLE [Pozycje_zamowienia_uslug]
ADD FOREIGN KEY ([IDZamowienia]) REFERENCES [Zamowienia_uslug]([IDZamowienia])

COMMIT TRANSACTION fk