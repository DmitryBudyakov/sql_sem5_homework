# SQL. Семинар 5. Домашняя работа
USE lesson_5;

/*
Задание 1.
1. Создайте представление, в которое попадут автомобили
стоимостью  до 25 000 долларов.
2. Изменить в существующем представлении порог для стоимости: 
пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW)
3. Создайте представление, в котором будут только автомобили
марки “Шкода” и “Ауди”
*/

CREATE TABLE cars(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(20),
    Cost INT
);
INSERT INTO cars(Name, Cost) 
VALUES
('Audi', 52642),
('Mercedes', 57127),
('Skoda', 9000),
('Volvo', 29000),
('Bentley', 350000),
('Citroen', 21000),
('Hummer', 41400),
('Volkswagen', 41400);
SELECT * FROM cars;

/*
1.1 Создайте представление, в которое попадут автомобили
стоимостью  до 25 000 долларов.
*/
CREATE OR REPLACE VIEW cars_view_1 AS 
SELECT Name, Cost FROM cars
WHERE Cost < 25000
ORDER BY Name;
SELECT * FROM cars_view_1;
-- DROP VIEW cars_view_1;

/*
1.2 Изменить в существующем представлении порог для стоимости: 
пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW)
*/
ALTER VIEW cars_view_1 AS 
SELECT Name, Cost FROM cars
WHERE Cost < 30000
ORDER BY Name;
SELECT * FROM cars_view_1;

/*
1.3 Создайте представление, в котором будут только автомобили
марки “Шкода” и “Ауди”
*/
CREATE OR REPLACE VIEW cars_view_2 AS 
SELECT * FROM cars
WHERE Name = 'Skoda' OR Name = 'Audi'
ORDER BY Name;
SELECT * FROM cars_view_2;
-- DROP VIEW cars_view_2;

/*
Задание 2.
Вывести название и цену для всех анализов, которые продавались 5 февраля 2020
и всю следующую неделю.
------------------------------
Есть таблица анализов Analysis:
------------------------------
an_id — ID анализа;
an_name — название анализа;
an_cost — себестоимость анализа;
an_price — розничная цена анализа;
an_group — группа анализов.
-----------------------------------
Есть таблица групп анализов Groups:
-----------------------------------
gr_id — ID группы;
gr_name — название группы;
gr_temp — температурный режим хранения.
---------------------------
Есть таблица заказов Orders:
---------------------------
ord_id — ID заказа;
ord_datetime — дата и время заказа;
ord_an — ID анализа.
*/
CREATE TABLE analysis(
	an_id INT, -- ID анализа;
	an_name VARCHAR(100), -- название анализа;
	an_cost INT, -- себестоимость анализа;
	an_price INT,  -- розничная цена анализа;
	an_group INT -- группа анализов.
);

CREATE TABLE analysis_groups(
	gr_id INT, -- ID группы;
	gr_name VARCHAR(50), -- название группы;
	gr_temp INT -- температурный режим хранения.
);

CREATE TABLE analysis_orders(
	ord_id INT AUTO_INCREMENT PRIMARY KEY, -- ID заказа;
	ord_datetime DATETIME, -- дата и время заказа;
	ord_an INT -- ID анализа.
);

INSERT INTO analysis VALUES
(101,'Общий анализ крови',300,450,1),
(102,'Биохимический анализ крови',500,750,1),
(103,'Анализ крови на сахар',400,600,1),
(104,'Анализ крови на гормоны',600,900,1),
(105,'Иммунологический анализ крови',1000,1500,1),
(201,'Общий анализ мочи',300,450,2),
(301,'Исследования кала',400,600,3);
SELECT * FROM analysis;

INSERT INTO analysis_groups VALUES
(1,'Анализ крови',10),
(2,'Анализ мочи',10),
(3,'Анализ кала',10);
SELECT * FROM analysis_groups;

INSERT INTO analysis_orders(ord_datetime, ord_an) VALUES
('2020-02-01 10:00:00',101),
('2020-02-02 11:00:00',102),
('2020-02-03 10:00:00',103),
('2020-02-04 11:30:00',104),
('2020-02-05 09:30:00',105),
('2020-02-06 09:00:00',201),
('2020-02-07 08:30:00',301),
('2020-02-08 08:40:00',101),
('2020-02-09 11:00:00',102),
('2020-02-10 10:00:00',103),
('2020-02-11 09:00:00',104),
('2020-02-12 09:30:00',105),
('2020-02-13 09:00:00',201),
('2020-02-14 08:30:00',301),
('2020-02-15 10:00:00',101);
SELECT * FROM analysis_orders;

-- 2. Вывести название и цену для всех анализов, которые продавались 5 февраля 2020
-- и всю следующую неделю.
SELECT analysis_orders.ord_datetime, analysis.an_name, analysis.an_price 
FROM analysis
JOIN analysis_orders ON analysis.an_id = analysis_orders.ord_an
WHERE analysis_orders.ord_datetime BETWEEN '2020-02-05' AND '2020-02-13'
ORDER BY analysis_orders.ord_datetime;

/*
Задание 3. 
Добавьте новый столбец под названием «время до следующей станции».
*/
CREATE TABLE train_tbl (
	train_id INT,
    station VARCHAR(20),
    station_time TIME
);

INSERT INTO train_tbl VALUES
(110,'San Francisco','10:00:00'),
(110,'Redwood City','10:54:00'),
(110,'Palo Alto','11:02:00'),
(110,'San Jose','12:35:00'),
(120,'San Francisco','11:00:00'),
(120,'Palo Alto','12:49:00'),
(120,'San Jose','13:30:00');
SELECT * FROM train_tbl;

-- 3. Добавьте новый столбец под названием «время до следующей станции».
SELECT *,
TIMEDIFF(LEAD(station_time,1) OVER(PARTITION BY train_id), station_time) AS 'time_to_next_station'
FROM train_tbl;
