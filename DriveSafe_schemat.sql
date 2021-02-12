-- Projektowanie hurtowni danych
-- Korporacja DriveSafe

-- 224319 Adam Kalisz 
-- 210204 Jakub Janiszewski 

IF EXISTS(SELECT 1 FROM master.dbo.sysdatabases WHERE NAME = 'drive_safe') DROP DATABASE drive_safe
GO
CREATE DATABASE drive_safe
GO
USE drive_safe
GO

-- 1. Utworzenie tabel wymiarów

CREATE TABLE typ_wypadku(
	ID_typ_wypadku int IDENTITY(1,1),
	typ_wypadku varchar(30) UNIQUE,
	CONSTRAINT PK_typ_wypadku PRIMARY KEY(ID_typ_wypadku)
)
GO

CREATE TABLE data_(
	ID_data int,
	rok smallint,
	miesiac tinyint,
	dzien tinyint,
	kwartal tinyint,
	dzien_tygodnia varchar(12)
	CONSTRAINT PK_data PRIMARY KEY(ID_data)
)
GO

CREATE TABLE typ_drogi(
	ID_typ_drogi int IDENTITY(1,1),
	typ_drogi varchar(30) UNIQUE,
	CONSTRAINT PK_typ_drogi PRIMARY KEY(ID_typ_drogi)
)
GO

CREATE TABLE typ_osoby_niezmotoryzowanej(
	ID_typ_osoby_niezmotoryzowanej int IDENTITY(1,1),
	typ_osoby_niezmotoryzowanej varchar(30) UNIQUE,
	CONSTRAINT PK_typ_osoby_niezmotoryzowanej PRIMARY KEY(ID_typ_osoby_niezmotoryzowanej)
)
GO

CREATE TABLE sprawca(
	ID_sprawca int IDENTITY(1,1),
	sprawca varchar(20) UNIQUE,
	CONSTRAINT PK_sprawca PRIMARY KEY(ID_sprawca)
)
GO

CREATE TABLE typ_kolizji(
	ID_typ_kolizji int IDENTITY(1,1),
	typ_kolizji varchar(30) UNIQUE,
	CONSTRAINT PK_typ_kolizji PRIMARY KEY(ID_typ_kolizji)
)
GO

CREATE TABLE pogoda(
	ID_pogoda int IDENTITY(1,1),
	pogoda varchar(30) UNIQUE,
	CONSTRAINT PK_pogoda PRIMARY KEY(ID_pogoda)
)
GO

CREATE TABLE warunki_jezdne(
	ID_warunki_jezdne int IDENTITY(1,1),
	warunki_jezdne varchar(30) UNIQUE,
	CONSTRAINT PK_warunki_jezdne PRIMARY KEY(ID_warunki_jezdne)
)
GO

CREATE TABLE widocznosc(
	ID_widocznosc int IDENTITY(1,1),
	widocznosc varchar(30) UNIQUE,
	CONSTRAINT PK_widocznosc PRIMARY KEY(ID_widocznosc)
)
GO

CREATE TABLE organizacja_ruchu(
	ID_organizacja_ruchu int IDENTITY(1,1),
	organizacja_ruchu varchar(30) UNIQUE,
	CONSTRAINT PK_organizacja_ruchu PRIMARY KEY(ID_organizacja_ruchu)
)
GO

CREATE TABLE stan_trzezwosci(
	ID_stan_trzezwosci int IDENTITY(1,1),
	stan_trzezwosci varchar(50) UNIQUE,
	CONSTRAINT PK_stan_trzezwosci PRIMARY KEY(ID_stan_trzezwosci)
)
GO

CREATE TABLE uderzony_obiekt(
	ID_uderzony_obiekt int IDENTITY(1,1),
	uderzony_obiekt varchar(30) UNIQUE,
	CONSTRAINT PK_uderzony_obiekt PRIMARY KEY(ID_uderzony_obiekt)
)
GO

CREATE TABLE typ_skrzyzowania(
	ID_typ_skrzyzowania int IDENTITY(1,1),
	typ_skrzyzowania varchar(30) UNIQUE,
	CONSTRAINT PK_typ_skrzyzowania PRIMARY KEY(ID_typ_skrzyzowania)
)
GO

CREATE TABLE przebieg_drogi(
	ID_przebieg_drogi int IDENTITY(1,1),
	przebieg_drogi varchar(30) UNIQUE,
	CONSTRAINT PK_przebieg_drogi PRIMARY KEY(ID_przebieg_drogi)
)
GO

CREATE TABLE stan_drogi(
	ID_stan_drogi int IDENTITY(1,1),
	stan_drogi varchar(30) UNIQUE,
	CONSTRAINT PK_stan_drogi PRIMARY KEY(ID_stan_drogi)
)
GO

CREATE TABLE podzial_drogi(
	ID_podzial_drogi int IDENTITY(1,1),
	podzial_drogi varchar(50) UNIQUE,
	CONSTRAINT PK_podzial_drogi PRIMARY KEY(ID_podzial_drogi)
)
GO

-- 2. Utowrzenie tabeli faktu

CREATE TABLE wypadek(
	ID_wypadku varchar(12),
	ID_typ_wypadku int NOT NULL,
	ID_data int NOT NULL,
	godzina tinyint NOT NULL,
	ID_typ_drogi int,
	ID_typ_drogi_2 int,
	ID_typ_osoby_niezmotoryzowanej int,
	ID_sprawca int NOT NULL,
	ID_typ_kolizji int NOT NULL,
	ID_pogoda int NOT NULL,
	ID_warunki_jezdne int,
	ID_widocznosc int NOT NULL,
	ID_organizacja_ruchu int NOT NULL,
	ID_stan_trzezwosci_kierowcy int,
	ID_stan_trzezwosci_osoby_niezmotoryzowanej int,
	ID_pierwszy_uderzony_obiekt int NOT NULL,
	ID_typ_skrzyzowania int,
	ID_przebieg_drogi int,
	ID_stan_drogi int,
	ID_podzial_drogi int,
	CONSTRAINT PK_wypadek PRIMARY KEY(ID_wypadku),
	CONSTRAINT FK_wypadek_typ_wypadku FOREIGN KEY(ID_typ_wypadku) REFERENCES typ_wypadku(ID_typ_wypadku),
	CONSTRAINT FK_wypadek_data FOREIGN KEY(ID_data) REFERENCES data_(ID_data),
	CONSTRAINT FK_wypadek_typ_drogi FOREIGN KEY(ID_typ_drogi) REFERENCES typ_drogi(ID_typ_drogi),
	CONSTRAINT FK_wypadek_typ_drogi_2 FOREIGN KEY(ID_typ_drogi_2) REFERENCES typ_drogi(ID_typ_drogi),
	CONSTRAINT FK_wypadek_typ_osoby_niezmotoryzowanej FOREIGN KEY(ID_typ_osoby_niezmotoryzowanej) REFERENCES typ_osoby_niezmotoryzowanej(ID_typ_osoby_niezmotoryzowanej),
	CONSTRAINT FK_wypadek_sprawca FOREIGN KEY(ID_sprawca) REFERENCES sprawca(ID_sprawca),
	CONSTRAINT FK_wypadek_typ_kolizji FOREIGN KEY(ID_typ_kolizji) REFERENCES typ_kolizji(ID_typ_kolizji),
	CONSTRAINT FK_wypadek_pogoda FOREIGN KEY(ID_pogoda) REFERENCES pogoda(ID_pogoda),
	CONSTRAINT FK_wypadek_warunki_jezdne FOREIGN KEY(ID_warunki_jezdne) REFERENCES warunki_jezdne(ID_warunki_jezdne),
	CONSTRAINT FK_wypadek_widocznosc FOREIGN KEY(ID_widocznosc) REFERENCES widocznosc(ID_widocznosc),
	CONSTRAINT FK_wypadek_organizacja_ruchu FOREIGN KEY(ID_organizacja_ruchu) REFERENCES organizacja_ruchu(ID_organizacja_ruchu),
	CONSTRAINT FK_wypadek_stan_trzezwosci_kierowcy FOREIGN KEY(ID_stan_trzezwosci_kierowcy) REFERENCES stan_trzezwosci(ID_stan_trzezwosci),
	CONSTRAINT FK_wypadek_stan_trzezwosci_osoby_niezmotoryzowanej FOREIGN KEY(ID_stan_trzezwosci_osoby_niezmotoryzowanej) REFERENCES stan_trzezwosci(ID_stan_trzezwosci),
	CONSTRAINT FK_wypadek_pierwszy_uderzony_obiekt FOREIGN KEY(ID_pierwszy_uderzony_obiekt) REFERENCES uderzony_obiekt(ID_uderzony_obiekt),
	CONSTRAINT FK_wypadek_typ_skrzyzowania FOREIGN KEY(ID_typ_skrzyzowania) REFERENCES typ_skrzyzowania(ID_typ_skrzyzowania),
	CONSTRAINT FK_wypadek_przebieg_drogi FOREIGN KEY(ID_przebieg_drogi) REFERENCES przebieg_drogi(ID_przebieg_drogi),
	CONSTRAINT FK_wypadek_stan_drogi FOREIGN KEY(ID_stan_drogi) REFERENCES stan_drogi(ID_stan_drogi),
	CONSTRAINT FK_wypadek_podzial_drogi FOREIGN KEY(ID_podzial_drogi) REFERENCES podzial_drogi(ID_podzial_drogi)
)
GO
USE master