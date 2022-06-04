/*
Etap 10 - Testowanie bazy danych

*/
USE [BD2_Mateusz_Klis]
GO
BEGIN TRANSACTION
/*
Poprawne dane wprowadzane do bazy
*/

INSERT INTO Punkty(Typ_punktu,Miasto,Ulica,Numer_budynku) VALUES
('Punkt sprzedazy','Bielsko-Biala','3 maja','14/2a'),
('Magazyn','Bielsko-Biala','1 maja','24'),
('Punkt sprzedazy','Bydgoszcz','Rzeczna','137'),
('Magazyn','Bydgoszcz','Kwiatkowskiego','21'),
('Punkt sprzedazy','Katowice','Dworcowa','46'),
('Magazyn','Katowice','Dmowskiego','33/1d'),
('Punkt sprzedazy','Zielona Gora','Gorska','13'),
('Magazyn','Zielona Gora','Gorska','330')
GO

INSERT INTO Pracownicy VALUES
(85120859897,'Mateusz','Klis','m','607142652','mk@rowery.pl','2000-08-05','2020-06-05',3300.00,'Konsultant','Rowery','Lipowa','Podkosciol','10',1),
(99070235634,'Mateusz','Kowalski','m','605542653','mk2@rowery.pl','2000-07-05','2020-06-05',3300.00,'Konsultant','Rowery','Zywiec','Browarna','12',1),
(49070156196,'Sebastian','Kowalski','m','725542635','sk@rowery.pl','2000-02-02','2020-06-05',3400.00,'Konsultant','Rowery','Zywiec','Jeziorna','33',1),
(93090714526,'Marcin','Klis','m','800542635','mk3@rowery.pl','1980-01-02','2010-03-05',3800.00,'Konsultant','Rowery','Lipowa','Pszczela','37',1),
(93041679694,'Pawel','Jan','m','333442535','pj@rowery.pl','1999-11-22','2014-12-17',3800.00,'Magazynier','Rowery','Bielsko Biala','Schodowa','37',2),
(51012896338,'Marcin','Morski','m','552532435','mn@rowery.pl','1987-11-24','2010-03-05',3800.00,'Konsultant','Rowery','Bydgoszcz','Morska','17',3),
(68060151948,'Jakub','Wielkopolski','m','552532415','jw@rowery.pl','1997-01-24','2014-05-05',3600.00,'Konsultant','Rowery','Bydgoszcz','Wyspowa','7',3),
(50090977432,'Jakub','Kowalski','n','551732417','jk22@rowery.pl','1999-04-14','2004-05-05',3800.00,'Kierownik','Akcesoria','Bydgoszcz','Sportowa','11/3c',3),
(85091821565,'Marcin','Malopolski','m','654776553','mw@rowery.pl','1998-02-14','2016-11-05',3800.00,'Konsultant','Rowery','Bydgoszcz','Zawislna','21',3),
(82050759813,'Stanislaw','Zadrozny','n','553243115','sw@rowery.pl','1999-12-14','2015-12-05',3800.00,'Magazynier','Rowery','Bydgoszcz','Szybowcowa','37',4),
(49080876666,'Stanislaw','Polanski','m','543115555','sp@rowery.pl','1996-12-14','2017-11-05',4200.00,'Magazynier','Magazyn','Bydgoszcz','Dworska','7/3a',4),
(64060125471,'Robert','Slaski','m','543125532','rs@rowery.pl','1982-12-14','2015-11-05',4200.00,'Kierownik','Akcesoria','Katowice','Dworska','7/4a',5),
(97090633676,'Karina','Roza','k','788145512','kr@rowery.pl','1977-07-12','2017-12-04',3200.00,'Konsultant','Akcesoria','Katowice','Poboczna','32',5),
(71100426478,'Sandra','Rozanska','k','552345512','sr@rowery.pl','1967-05-14','2017-11-30',3200.00,'Konsultant','Akcesoria','Katowice','Dworska','11',5),
(50051776128,'Marcin','Dworski','m','875465552','md@rowery.pl','1987-06-14','2017-12-27',4300.00,'Magazynier','Akcesoria','Katowice','Dluga','211',6),
(56082589377,'Jan','Kowalski','m','875777895','jk3@rowery.pl','1997-06-12','2017-12-22',4300.00,'Magazynier','Magazyn','Gliwice','Dluzsza','21/1',6),
(84022348896,'Jan','Kowalczyk','m','552737825','jk4@rowery.pl','1969-11-12','2010-11-22',3300.00,'Kierownik','Rowery','Zielona Gora','Zamostowa','31/11',7),
(93053181464,'Zofia','Kowalczyk','k','553554765','zk@rowery.pl','1980-01-21','2010-11-22',3300.00,'Konsultant','Rowery','Zielona Gora','Zamostowa','31/11',7),
(91051177595,'Jakup','Gorski','m','425547651','jg@rowery.pl','1983-09-21','2012-07-22',3500.00,'Magazynier','Rowery','Zielona Gora','Pechowa','1/11',7)
GO

INSERT INTO Klienci(Imie,Nazwisko,Plec,Numer_telefonu,Adres_email,Data_urodzenia,Data_rejestracji,Miasto,Ulica,Numer_budynku) VALUES
('Mateusz','Klis','m','607142652','mk@rowery.pl','2000-05-08','2022-05-10','Lipowa','Podkosciol','10'),
('Sebastian','Klis','m','605142257','sk@rowery.pl','2005-12-29','2022-05-10','Lipowa','Podkosciol','10'),
('Roza','Maciek','k','885145353','rm@rowery.pl','2002-11-29','2021-04-10','Bielsko Biala','Schodowa','3/12'),
('Krzysztof','Maly','m','725145783','km@rowery.pl','2002-11-29','2021-04-10','Bialystok','Szkolna','17')
GO


INSERT INTO Produkty(Nazwa,Kategoria,Producent,Cena,[Status]) VALUES
('Rower BMX 29BNT','Rower','BNT',2500.00,'Dostepny'),
('Rower BMX 79BNX','Rower','BNX',3700.00,'Dostepny'),
('Rower BMX 79BNX Damski','Rower','BNX',3900.00,'Dostepny'),
('Rower BMX 79BNX Dzieciecy','Rower','BNX',3900.00,'Produkt wycofany'),
('Rower Miejski C20','Rower','Biker',1900.00,'Produkt wycofany'),
('Rower Miejski C30','Rower','Biker',2500.00,'Dostepny'),
('Rower BZW20','Rower','Biker',2400.00,'Dostepny'),
('Rower BZW50','Rower','Biker',5400.00,'Dostepny'),
('Rower BZW50','Rower','Biker',5400.00,'Dostepny'),
('Kask dzieciecy KIDS PRO','Akcesoria','Biker',99.00,'Dostepny'),
('Kask meski MEN PRO','Akcesoria','Biker',199.00,'Dostepny'),
('Kask damski WOMEN PRO','Akcesoria','Biker',199.00,'Dostepny'),
('Kask damski WOMEN PROv2','Akcesoria','Biker',159.00,'Dostepny'),
('Ochraniacze dzieciece','Akcesoria','PROTEBIKER',259.00,'Dostepny'),
('Ochraniacze','Akcesoria','PROTEBIKER',459.00,'Dostepny'),
('Pompka','Akcesoria','HELPBIKE',129.00,'Dostepny'),
('Siodelko profilowane','Akcesoria','HELPBIKE',329.00,'Dostepny'),
('Zestaw naprawczy','Akcesoria','HELPBIKE',229.00,'Dostepny')
GO

INSERT INTO Uslugi(Nazwa,Cena,[Status]) VALUES
('Serwis',199.00,'Dostepna'),
('Przeglad',99.00,'Dostepna'),
('Wymiana opon',150.00,'Dostepna'),
('Konserwacja',299.00,'Dostepna'),
('Przechowywanie',55.00,'Dostepna'),
('Naprawa hamulcy',220.00,'Dostepna')
GO

INSERT INTO Stan_magazynu(IDProduktu,IDPunktu,Ilosc) VALUES
(1,2,255),
(2,2,255),
(3,2,255),
(6,2,255),
(7,2,255),
(8,2,255),
(9,2,255),
(10,2,255),
(11,2,255),
(12,2,255),
(13,2,255),
(14,2,255),
(15,2,255),
(16,2,255),
(17,2,255),
(18,2,255),
(1,4,255),
(2,4,255),
(3,4,255),
(6,4,255),
(7,4,255),
(8,4,255),
(9,4,255),
(10,4,255),
(11,4,255),
(12,4,255),
(13,4,255),
(14,4,255),
(15,4,255),
(16,4,255),
(17,4,255),
(18,4,255),
(1,6,255),
(2,6,255),
(3,6,255),
(6,6,255),
(7,6,255),
(8,6,255),
(9,6,255),
(10,6,255),
(11,6,255),
(12,6,255),
(13,6,255),
(14,6,255),
(15,6,255),
(16,6,255),
(17,6,255),
(18,6,255),
(1,8,255),
(2,8,255),
(3,8,255),
(6,8,255),
(7,8,255),
(8,8,255),
(9,8,255),
(10,8,255),
(11,8,255),
(12,8,255),
(13,8,255),
(14,8,255),
(15,8,255),
(16,8,255),
(17,8,255),
(18,8,255)
GO

INSERT INTO Zamowienia(Data_zlozenia,IDKlienta,IDPracownika) VALUES
('2022-04-06',1,85120859897),
('2020-03-02',2,93041679694),
('2022-02-05',3,64060125471),
('2021-12-05',4,93053181464)
GO

INSERT INTO Zamowienia_uslug(Data_rozpoczecia,IDKlienta,IDPracownika) VALUES
('2019-05-13',4,84022348896),
('2019-05-12',4,84022348896),
('2020-03-17',2,51012896338)
GO

INSERT INTO Pozycje_zamowienia VALUES
(2,1,1),
(3,6,1),
(2,1,2),
(3,18,2),
(7,14,2),
(1,4,3),
(5,7,3),
(1,6,4),
(5,13,4),
(2,12,4)
GO

INSERT INTO Pozycje_zamowienia_uslug VALUES
(2,4,1),
(3,2,1),
(3,3,2),
(5,1,2),
(1,2,3),
(1,4,3)
GO

EXEC dodajPracownika @PESEL = '86030555736', @Imie = 'Andrzej',@Nazwisko = 'Stolarzewicz',@Plec = 'm', @Numer_telefonu ='555222111', @Adres_email = 'as@rowery.pl', @Data_zatrudnienia ='2000-01-03' ,
@Data_urodzenia = '1992-12-30', @Pensja = 4000.00, @Stanowisko = 'Kierownik', @Dzial = 'Rowery', @Miasto = 'Bielsko Biala', @Ulica = 'Lesna', @Numer_budynku = '11',@IDPunktu = 1; 
GO

EXEC dodajPracownika @PESEL = '04242597562', @Imie = 'Jolanta',@Nazwisko = 'Gorska',@Plec = 'k', @Numer_telefonu ='555333211', @Adres_email = 'jg@rowery.pl', @Data_zatrudnienia ='1999-10-10' ,
@Data_urodzenia = '1997-11-30', @Pensja = 3860.00, @Stanowisko = 'Magazynier', @Dzial = 'Nie dotyczy', @Miasto = 'Bielsko Biala', @Ulica = 'Zywiecka', @Numer_budynku = '13/a',@IDPunktu = 2; 
GO

EXEC dodajPracownika @PESEL = '98072769213', @Imie = 'Marcin',@Nazwisko = 'Ochocki',@Plec = 'm', @Numer_telefonu ='255333221', @Adres_email = 'mo@rowery.pl', @Data_zatrudnienia ='1979-11-05' ,
@Data_urodzenia = '1967-12-20', @Pensja = 3224.00, @Stanowisko = 'Konsultant', @Dzial = 'Sprzedaz', @Miasto = 'Bielsko Biala', @Ulica = 'Cieszynska', @Numer_budynku = '43',@IDPunktu = 1;
GO

SELECT K.Imie, K.Nazwisko, SUM(P.Cena*Pz.Ilosc) AS 'Kwota Zamowienia' FROM
Zamowienia AS Z INNER JOIN Pozycje_zamowienia AS PZ ON Z.IDZamowienia=PZ.IDZamowienia
INNER JOIN Produkty AS P ON PZ.IDProduktu=P.IDProduktu
INNER JOIN Klienci AS K ON Z.IDKlienta=K.IDKlienta
WHERE K.IDKlienta =1
GROUP BY K.Imie, K.Nazwisko

SELECT * FROM wyswietlPunkty
SELECT * FROM wyswietlwycofaneProdukty

/*Przyklad blednego zapytania
INSERT INTO Pracownicy VALUES(98051144332,'Jan','Kowalski3','z','222A','niepoprawny email','2022-04-06','2022-04-06',3300,'Tester','Test triggerow','Bielsko Biala', 'Zimowa','13',1)
*/
COMMIT TRANSACTION