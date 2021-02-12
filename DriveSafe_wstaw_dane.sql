-- Projektowanie hurtowni danych
-- Korporacja DriveSafe

-- 224319 Adam Kalisz 
-- 210204 Jakub Janiszewski 

USE drive_safe
GO

-- 1. Wczytanie danych z pliku csv do tabeli crash_reports jak Flat File

-- 2. Autowypelnienie tabeli data_ z zadanego okresu
DECLARE 
	@data_koncowa DATE = DATEFROMPARTS(2018, 01, 01),
	@data DATE = DATEFROMPARTS(2015, 01, 01)

WHILE @data < @data_koncowa
BEGIN
	-- CONVERT date standard: ISO (12)
	INSERT INTO data_
	SELECT CONVERT(varchar, @data, 12), YEAR(@data), MONTH(@data), DAY(@data), DATEPART(QUARTER, @data), DATENAME(WEEKDAY, @data)
	SET @data = DATEADD(DAY, 1, @data)
END
GO

-- 3. Wypelnienie pozostalych tabel wymiaru
INSERT INTO typ_wypadku
SELECT DISTINCT acrs_report_type FROM crash_reports
WHERE acrs_report_type IS NOT NULL
GO

INSERT INTO typ_drogi
SELECT DISTINCT route_type FROM crash_reports
WHERE route_type IS NOT NULL
GO

INSERT INTO typ_drogi
SELECT DISTINCT cross_street_type FROM crash_reports
WHERE cross_street_type NOT IN (
	SELECT typ_drogi FROM typ_drogi)
GO

INSERT INTO typ_osoby_niezmotoryzowanej
SELECT DISTINCT related_non_motorist FROM crash_reports
WHERE related_non_motorist IS NOT NULL
GO

INSERT INTO sprawca
SELECT DISTINCT at_fault FROM crash_reports
WHERE at_fault IS NOT NULL
GO

INSERT INTO typ_kolizji
SELECT DISTINCT collision_type FROM crash_reports
WHERE collision_type IS NOT NULL
GO

INSERT INTO pogoda
SELECT DISTINCT weather FROM crash_reports
WHERE weather IS NOT NULL
GO

INSERT INTO warunki_jezdne
SELECT DISTINCT surface_condition FROM crash_reports
WHERE surface_condition IS NOT NULL
GO

INSERT INTO widocznosc
SELECT DISTINCT light FROM crash_reports
WHERE light IS NOT NULL
GO

INSERT INTO organizacja_ruchu
SELECT DISTINCT traffic_control FROM crash_reports
WHERE traffic_control IS NOT NULL
GO

INSERT INTO stan_trzezwosci
SELECT DISTINCT driver_substance_abuse FROM crash_reports
WHERE driver_substance_abuse IS NOT NULL
GO

INSERT INTO stan_trzezwosci
SELECT DISTINCT non_motorist_substance_abuse FROM crash_reports
WHERE non_motorist_substance_abuse IS NOT NULL AND non_motorist_substance_abuse NOT IN (
	SELECT stan_trzezwosci FROM stan_trzezwosci)
GO

INSERT INTO uderzony_obiekt
SELECT DISTINCT first_harmful_event FROM crash_reports
WHERE first_harmful_event IS NOT NULL
GO

INSERT INTO typ_skrzyzowania
SELECT DISTINCT intersection_type FROM crash_reports
WHERE intersection_type IS NOT NULL
GO

INSERT INTO przebieg_drogi
SELECT DISTINCT road_alignment FROM crash_reports
WHERE road_alignment IS NOT NULL
GO

INSERT INTO stan_drogi
SELECT DISTINCT road_condition FROM crash_reports
WHERE road_condition IS NOT NULL
GO

INSERT INTO podzial_drogi
SELECT DISTINCT road_division FROM crash_reports
WHERE road_division IS NOT NULL
GO

-- 4. Rozszerzenie tabeli crash reports o kolumny zawierajace klucze obce
ALTER TABLE crash_reports ADD
	ID_typ_wypadku int,
	ID_data int,
	godzina tinyint,
	ID_typ_drogi int,
	ID_typ_drogi_2 int,
	ID_typ_osoby_niezmotoryzowanej int,
	ID_sprawca int,
	ID_typ_kolizji int,
	ID_pogoda int,
	ID_warunki_jezdne int,
	ID_widocznosc int,
	ID_organizacja_ruchu int,
	ID_stan_trzezwosci_kierowcy int, 
	ID_stan_trzezwosci_osoby_niezmotoryzowanej int,
	ID_pierwszy_uderzony_obiekt int,
	ID_typ_skrzyzowania int,
	ID_przebieg_drogi int,
	ID_stan_drogi int,
	ID_podzial_drogi int
GO

-- 5. Uzupelnienie kolumn z kluczami obcymi
UPDATE crash_reports
SET crash_reports.ID_typ_wypadku = tw.ID_typ_wypadku
FROM typ_wypadku AS tw
WHERE acrs_report_type = tw.typ_wypadku
GO

UPDATE crash_reports
SET ID_data = CONVERT(int, CONVERT(char(6), crash_date_time, 12))
GO

UPDATE crash_reports
SET godzina = DATEPART(HOUR, crash_date_time)
GO

UPDATE crash_reports
SET crash_reports.ID_typ_drogi = td.ID_typ_drogi 
FROM typ_drogi AS td
WHERE route_type = td.typ_drogi
GO

UPDATE crash_reports
SET crash_reports.ID_typ_drogi_2 = td.ID_typ_drogi
FROM typ_drogi AS td
WHERE cross_street_type = td.typ_drogi
GO

UPDATE crash_reports
SET crash_reports.ID_typ_osoby_niezmotoryzowanej = ts.ID_typ_osoby_niezmotoryzowanej
FROM typ_osoby_niezmotoryzowanej AS ts
WHERE related_non_motorist = ts.typ_osoby_niezmotoryzowanej
GO

UPDATE crash_reports
SET crash_reports.ID_sprawca = ts.ID_sprawca
FROM sprawca AS ts
WHERE at_fault = ts.sprawca
GO

UPDATE crash_reports
SET crash_reports.ID_typ_kolizji = tk.ID_typ_kolizji
FROM typ_kolizji AS tk
WHERE collision_type = tk.typ_kolizji
GO

UPDATE crash_reports
SET crash_reports.ID_pogoda = p.ID_pogoda
FROM pogoda AS p
WHERE weather = p.pogoda
GO

UPDATE crash_reports
SET crash_reports.ID_warunki_jezdne = wj.ID_warunki_jezdne
FROM warunki_jezdne AS wj
WHERE surface_condition = wj.warunki_jezdne
GO

UPDATE crash_reports
SET crash_reports.ID_widocznosc = w.ID_widocznosc
FROM widocznosc AS w
WHERE light = w.widocznosc
GO

UPDATE crash_reports
SET crash_reports.ID_organizacja_ruchu = o.ID_organizacja_ruchu
FROM organizacja_ruchu AS o
WHERE traffic_control = o.organizacja_ruchu
GO

UPDATE crash_reports
SET crash_reports.ID_stan_trzezwosci_kierowcy = st.ID_stan_trzezwosci
FROM stan_trzezwosci AS st
WHERE driver_substance_abuse = st.stan_trzezwosci
GO

UPDATE crash_reports
SET crash_reports.ID_stan_trzezwosci_osoby_niezmotoryzowanej = st.ID_stan_trzezwosci
FROM stan_trzezwosci AS st
WHERE non_motorist_substance_abuse = st.stan_trzezwosci
GO

UPDATE crash_reports
SET crash_reports.ID_pierwszy_uderzony_obiekt = uo.ID_uderzony_obiekt
FROM uderzony_obiekt AS uo
WHERE first_harmful_event = uo.uderzony_obiekt
GO

UPDATE crash_reports
SET crash_reports.ID_typ_skrzyzowania = ts.ID_typ_skrzyzowania
FROM typ_skrzyzowania AS ts 
WHERE intersection_type = ts.typ_skrzyzowania 
GO

UPDATE crash_reports
SET crash_reports.ID_przebieg_drogi = pd.ID_przebieg_drogi
FROM przebieg_drogi AS pd
WHERE road_alignment = pd.przebieg_drogi
GO

UPDATE crash_reports
SET crash_reports.ID_stan_drogi = sd.ID_stan_drogi
FROM stan_drogi AS sd
WHERE road_condition = sd.stan_drogi
GO

UPDATE crash_reports
SET crash_reports.ID_podzial_drogi = pd.ID_podzial_drogi
FROM podzial_drogi AS pd
WHERE road_division = pd.podzial_drogi
GO

-- 6. Uzupelnienie tabeli faktu
INSERT INTO wypadek
SELECT 
	cr.report_number,
	cr.ID_typ_wypadku,
	cr.ID_data,
	cr.godzina,
	cr.ID_typ_drogi,
	cr.ID_typ_drogi_2,
	cr.ID_typ_osoby_niezmotoryzowanej,
	cr.ID_sprawca,
	cr.ID_typ_kolizji,
	cr.ID_pogoda,
	cr.ID_warunki_jezdne,
	cr.ID_widocznosc,
	cr.ID_organizacja_ruchu,
	cr.ID_stan_trzezwosci_kierowcy,
	cr.ID_stan_trzezwosci_osoby_niezmotoryzowanej,
	cr.ID_pierwszy_uderzony_obiekt,
	cr.ID_typ_skrzyzowania,
	cr.ID_przebieg_drogi,
	cr.ID_stan_drogi,
	cr.ID_podzial_drogi
FROM crash_reports AS cr
GO

SELECT 
	w.ID_wypadku,
	tw.typ_wypadku,
	w.ID_data,
	w.godzina,
	td1.typ_drogi,
	td2.typ_drogi AS typ_drogi_2,
	tosn.typ_osoby_niezmotoryzowanej,
	s.sprawca,
	tk.typ_kolizji,
	p.pogoda,
	wj.warunki_jezdne,
	wid.widocznosc,
	orr.organizacja_ruchu,
	stk.stan_trzezwosci AS stan_trzezwosci_kierowcy,
	stn.stan_trzezwosci AS stan_trzezwosci_osoby_niezmotoryzowanej,
	uo.uderzony_obiekt,
	ts.typ_skrzyzowania,
	pd.przebieg_drogi,
	sd.stan_drogi,
	pdr.podzial_drogi
FROM wypadek AS w
	LEFT JOIN typ_wypadku AS tw ON tw.ID_typ_wypadku = w.ID_typ_wypadku
	LEFT JOIN typ_drogi AS td1 ON td1.ID_typ_drogi = w.ID_typ_drogi
	LEFT JOIN typ_drogi AS td2 ON td2.ID_typ_drogi = w.ID_typ_drogi_2
	LEFT JOIN typ_osoby_niezmotoryzowanej AS tosn ON tosn.ID_typ_osoby_niezmotoryzowanej = w.ID_typ_osoby_niezmotoryzowanej
	LEFT JOIN sprawca AS s ON s.ID_sprawca = w.ID_sprawca
	LEFT JOIN typ_kolizji AS tk ON tk.ID_typ_kolizji = w.ID_typ_kolizji
	LEFT JOIN pogoda AS p ON p.ID_pogoda = w.ID_pogoda
	LEFT JOIN warunki_jezdne AS wj ON wj.ID_warunki_jezdne = w.ID_warunki_jezdne
	LEFT JOIN widocznosc AS wid ON wid.ID_widocznosc = w.ID_widocznosc
	LEFT JOIN organizacja_ruchu AS orr ON orr.ID_organizacja_ruchu = w.ID_organizacja_ruchu
	LEFT JOIN stan_trzezwosci AS stk ON stk.ID_stan_trzezwosci = w.ID_stan_trzezwosci_kierowcy
	LEFT JOIN stan_trzezwosci AS stn ON stn.ID_stan_trzezwosci = w.ID_stan_trzezwosci_osoby_niezmotoryzowanej
	LEFT JOIN uderzony_obiekt AS uo ON uo.ID_uderzony_obiekt = w.ID_pierwszy_uderzony_obiekt
	LEFT JOIN typ_skrzyzowania AS ts ON ts.ID_typ_skrzyzowania = w.ID_typ_skrzyzowania
	LEFT JOIN przebieg_drogi AS pd ON pd.ID_przebieg_drogi = w.ID_przebieg_drogi
	LEFT JOIN stan_drogi AS sd ON sd.ID_stan_drogi = w.ID_stan_drogi
	LEFT JOIN podzial_drogi AS pdr ON pdr.ID_podzial_drogi = w.ID_podzial_drogi
WHERE
	w.ID_wypadku = 'MCP2969003Q'

SELECT * FROM crash_reports
WHERE report_number = 'MCP2969003Q'

USE master
GO

-- SELECT * FROM drive_safe..data_
-- SELECT * FROM drive_safe..typ_wypadku
-- SELECT * FROM drive_safe..typ_drogi
-- SELECT * FROM drive_safe..typ_osoby_niezmotoryzowanej
-- SELECT * FROM drive_safe..sprawca
-- SELECT * FROM drive_safe..typ_kolizji
-- SELECT * FROM drive_safe..pogoda
-- SELECT * FROM drive_safe..warunki_jezdne
-- SELECT * FROM drive_safe..widocznosc
-- SELECT * FROM drive_safe..organizacja_ruchu
-- SELECT * FROM drive_safe..stan_trzezwosci
-- SELECT * FROM drive_safe..uderzony_obiekt
-- SELECT * FROM drive_safe..typ_skrzyzowania
-- SELECT * FROM drive_safe..przebieg_drogi
-- SELECT * FROM drive_safe..stan_drogi
-- SELECT * FROM drive_safe..podzial_drogi
-- SELECT * FROM drive_safe..crash_reports

-- DELETE FROM drive_safe..data_
-- DELETE FROM drive_safe..typ_wypadku
-- DELETE FROM drive_safe..typ_drogi
-- DELETE FROM drive_safe..typ_osoby_niezmotoryzowanej
-- DELETE FROM drive_safe..sprawca
-- DELETE FROM drive_safe..typ_kolizji
-- DELETE FROM drive_safe..pogoda
-- DELETE FROM drive_safe..warunki_jezdne
-- DELETE FROM drive_safe..widocznosc
-- DELETE FROM drive_safe..organizacja_ruchu
-- DELETE FROM drive_safe..stan_trzezwosci
-- DELETE FROM drive_safe..uderzony_obiekt
-- DELETE FROM drive_safe..typ_skrzyzowania
-- DELETE FROM drive_safe..przebieg_drogi
-- DELETE FROM drive_safe..stan_drogi
-- DELETE FROM drive_safe..podzial_drogi

