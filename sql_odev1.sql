-- SQL HomeWork

-- 1.INNER JOIN SORULARI
-- Müşterilerin Siparişleri
-- Müşteriler (Customers) ve siparişler (Orders) tablolarını kullanarak, en az 5 sipariş vermiş müşterilerin 
-- adlarını ve verdikleri toplam sipariş sayısını listeleyin.
SELECT Customers.company_name , count(*) as total_order
FROM Orders 
INNER JOIN Customers on Customers.customer_id = Orders.customer_id
GROUP BY customers.company_name 
HAVING COUNT(*) >=5
ORDER BY total_order DESC

-- 2.En Çok Satış Yapan Çalışanlar
-- Çalışanlar (Employees) ve siparişler (Orders) tablolarını kullanarak, her çalışanın toplam kaç sipariş aldığını 
-- ve en çok sipariş alan 3 çalışanı listeleyin.
SELECT Employees.employee_id, Employees.first_name, Employees.last_name, count(*) as total_order
FROM Orders 
INNER JOIN Employees ON Employees.employee_id = Orders.employee_id
GROUP BY Employees.employee_id, Employees.first_name , Employees.last_name 
ORDER BY total_order DESC LIMIT 3

-- En Çok Satılan Ürünler
-- Sipariş detayları (Order Details) ve ürünler (Products) tablolarını kullanarak, toplamda en fazla satılan 
-- (miktar olarak) ilk 5 ürünü listeleyin.
SELECT Products.product_id , Products.product_name, SUM(Order_details.quantity) as total_product
FROM Order_details 
INNER JOIN Products ON Products.product_id = Order_details.product_id
GROUP BY Products.product_id , Products.product_name
ORDER BY total_product DESC LIMIT 5

-- Her Müşterinin Aldığı Kategoriler
-- Müşteriler (Customers), siparişler (Orders), sipariş detayları (Order Details), ürünler (Products) ve kategoriler 
-- (Categories) tablolarını kullanarak, her müşterinin satın aldığı farklı kategorileri listeleyin.
SELECT Customers.company_name, Categories.category_name
FROM Orders
INNER JOIN Customers ON Customers.customer_id = Orders.customer_id
INNER JOIN Order_details ON Order_details.order_id = Orders.order_id
INNER JOIN Products ON Products.product_id = Order_details.product_id
INNER JOIN Categories ON Categories.category_id = Products.category_id
GROUP BY Customers.company_name, Categories.category_name
ORDER BY Customers.company_name 

-- Müşteri-Sipariş-Ürün Kombinasyonu
-- Müşteriler (Customers), siparişler (Orders), sipariş detayları (Order Details) ve ürünler (Products) tablolarını kullanarak, 
-- her müşterinin kaç farklı ürün satın aldığını ve toplam kaç adet aldığını listeleyin.
SELECT Customers.company_name, Products.product_name, sum(Order_details.quantity), count(*)
FROM Orders 
INNER JOIN Customers ON Customers.customer_id = Orders.customer_id
INNER JOIN Order_details ON Order_details.order_id = Orders.order_id
INNER JOIN Products ON Products.product_id = Order_details.product_id
GROUP BY Customers.company_name, Products.product_name
ORDER BY Customers.company_name

-- LEFT JOIN SORULARI
-- Hiç Sipariş Vermeyen Müşteriler
-- Müşteriler (Customers) ve siparişler (Orders) tablolarını kullanarak, hiç sipariş vermemiş müşterileri listeleyin.
SELECT Customers.customer_id, Customers.company_name, Orders.order_id
FROM Customers
LEFT JOIN Orders ON Orders.customer_id = Customers.customer_id 
WHERE Orders.order_id is null

-- Ürün Satmayan Tedarikçiler
-- Tedarikçiler (Suppliers) ve ürünler (Products) tablolarını kullanarak, hiç ürün satmamış tedarikçileri listeleyin.
SELECT Suppliers.supplier_id , Suppliers.company_name, Products.product_name 
FROM Suppliers
LEFT JOIN Products ON Products.supplier_id = Suppliers.supplier_id
WHERE Products.supplier_id  IS NULL

-- Siparişleri Olmayan Çalışanlar
-- Çalışanlar (Employees) ve siparişler (Orders) tablolarını kullanarak, hiç sipariş almamış çalışanları listeleyin.
SELECT Employees.employee_id, Employees.first_name, Employees.last_name, Orders.order_id
FROM Employees
LEFT JOIN Orders ON Orders.employee_id = Employees.employee_id
WHERE Orders.order_id IS NULL 

-- RIGHT JOIN SORULARI
-- Her Sipariş İçin Müşteri Bilgisi
-- RIGHT JOIN kullanarak, tüm siparişlerin yanında müşteri bilgilerini de listeleyin. Eğer müşteri bilgisi eksikse, 
-- "Bilinmeyen Müşteri" olarak gösterin.
SELECT Orders.order_id, Orders.customer_id,
COALESCE (Customers.company_name,'Bilinmeyen Müşteri') as customer_name ,Orders.employee_id, Orders.order_date 
FROM Customers
RIGHT JOIN Orders ON Orders.customer_id = Customers.customer_id 

-- Ürünler ve Kategorileri
-- RIGHT JOIN kullanarak, tüm kategoriler ve bu kategorilere ait ürünleri listeleyin. Eğer bir kategoriye ait ürün yoksa,
-- kategori adını ve "Ürün Yok" bilgisini gösterin.
SELECT Categories.category_name, COALESCE(Products.product_name, 'Ürün Yok') AS product_name
FROM Categories
RIGHT JOIN Products ON Products.category_id = Categories.category_id;

----------------------------------------------------------------------------------------------------------------------------------------
-- **Level 1**

-- 1️⃣ En Çok Satış Yapan Çalışanı Bulun
-- Her çalışanın (Employees) sattığı toplam ürün adedini hesaplayarak, en çok satış yapan ilk 3 çalışanı listeleyen bir sorgu yazınız.
-- İpucu: Orders, OrderDetails ve Employees tablolarını kullanarak GROUP BY ve ORDER BY yapısını oluşturun. TOP 3 veya 
-- LIMIT ile ilk 3 çalışanı seçin.
SELECT e.first_name, e.last_name, sum(od.quantity) as total_order
FROM Orders AS o
INNER JOIN Order_details AS od ON o.order_id = od.order_id
INNER JOIN Employees AS e ON e.employee_id = o.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY total_order DESC
LIMIT 3

-- 2️⃣ Aylık Satış Trendlerini Bulun
-- Siparişlerin (Orders) hangi yıl ve ayda ne kadar toplam satış geliri oluşturduğunu hesaplayan ve yıllara göre sıralayan 
-- bir sorgu yazınız.
-- İpucu: Orders ve OrderDetails tablolarını kullanın. Tarih bilgisini yıl ve aya göre gruplayın, toplam satış gelirini 
-- hesaplayarak sıralayın.
SELECT EXTRACT(YEAR FROM o.order_date) AS yil, EXTRACT(MONTH FROM o.order_date) AS ay, 
sum(od.quantity*od.unit_price) as total_price
FROM Orders AS o
INNER JOIN Order_details AS od ON o.order_id = od.order_id
GROUP BY yil, ay
ORDER BY yil , ay 

-- 3️⃣ En Karlı Ürün Kategorisini Bulun
-- Her ürün kategorisinin (Categories), o kategoriye ait ürünlerden (Products) yapılan satışlar sonucunda elde ettiği toplam 
-- geliri hesaplayan bir sorgu yazınız.
-- İpucu: Categories, Products, OrderDetails ve Orders tablolarını birleştirin. Kategori bazında gelir hesaplaması yaparak en
-- yüksekten en düşüğe sıralayın.
SELECT c.category_name, sum(od.quantity*od.unit_price) as total_price
FROM Order_details AS od
INNER JOIN Products AS p ON p.product_id = od.product_id
INNER JOIN Categories AS c ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY total_price DESC

-- 4️⃣ Belli Bir Tarih Aralığında En Çok Sipariş Veren Müşterileri Bulun
-- 1997 yılında en fazla sipariş veren ilk 5 müşteriyi listeleyen bir sorgu yazınız.
-- İpucu: Orders ve Customers tablolarını birleştirin. WHERE ile 1997 yılını filtreleyin, müşteri bazında sipariş sayılarını 
-- hesaplayarak sıralayın ve en fazla sipariş veren 5 müşteriyi seçin.
SELECT c.company_name, COUNT(*) AS total_order
FROM Orders AS o 
INNER JOIN Customers AS c ON c.customer_id = o.customer_id where order_date BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY c.company_name
ORDER BY total_order DESC 
LIMIT 5

-- 5️⃣ Ülkelere Göre Toplam Sipariş ve Ortalama Sipariş Tutarını Bulun
-- Müşterilerin bulunduğu ülkeye göre toplam sipariş sayısını ve ortalama sipariş tutarını hesaplayan bir sorgu yazınız. 
-- Sonucu toplam sipariş sayısına göre büyükten küçüğe sıralayın.
-- İpucu: Customers, Orders ve OrderDetails tablolarını birleştirin. Ülke bazında GROUP BY kullanarak toplam sipariş sayısını
-- ve ortalama sipariş tutarını hesaplayın.
SELECT c.country, count(o.order_id) AS sum_order, sum(od.unit_price*od.quantity)/count(DISTINCT o.order_id) AS avg_order
FROM Customers AS c
INNER JOIN Orders AS o ON c.customer_id = o.customer_id
INNER JOIN Order_details AS od ON od.order_id = o.order_id
GROUP BY c.country
ORDER BY sum_order DESC
----------------------------------------------------------------------------------------------------------------------------------------
-- **Level 2 - Mid** Çarşambaya kadar

-- AR_GE -> CTE (Common Table Expressions) ve PIVOT

-- 1️⃣ Her Çalışanın En Çok Satış Yaptığı Ürünü Bulun
-- Her çalışanın (Employees) sattığı ürünler içinde en çok sattığı (toplam adet olarak) ürünü bulun ve sonucu çalışana göre sıralayın.
SELECT first_name, last_name, product_name, total_order from (
	SELECT  e.first_name,
			e.last_name,
			p.product_name, 
			SUM(od.quantity) AS total_order,
			RANK() OVER (PARTITION BY e.employee_id ORDER BY SUM(od.quantity) DESC ) AS rnk
	FROM Employees AS e
	INNER JOIN Orders AS o ON o.employee_id = e.employee_id
	INNER JOIN Order_details AS od ON od.order_id = o.order_id
	INNER JOIN Products AS p ON p.product_id = od.product_id 
	GROUP BY e.first_name,e.last_name,p.product_name, e.employee_id
	ORDER BY e.first_name, total_order DESC
	
) AS max_order
WHERE rnk = 1
ORDER BY first_name, last_name

-- 2️⃣ Bir Ülkenin Müşterilerinin Satın Aldığı En Pahalı Ürünü Bulun
-- Belli bir ülkenin (örneğin "Germany") müşterilerinin verdiği siparişlerde satın aldığı en pahalı ürünü (UnitPrice olarak) bulun 
-- ve hangi müşterinin aldığını listeleyin.
WITH country_order AS(
	SELECT c.customer_id, p.product_name, od.unit_price
	FROM Customers AS c 
	INNER JOIN Orders AS o ON o.customer_id = c.customer_id
	INNER JOIN Order_Details AS od ON od.order_id = o.order_id
	INNER JOIN Products AS p ON p.product_id = od.product_id
), row_price AS (
	SELECT customer_id, product_name, unit_price, 
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY unit_price DESC) as row_num
	FROM country_order
)
SELECT customer_id, product_name, unit_price
FROM row_price
WHERE row_num = 1

-- 3️⃣ Her Kategoride (Categories) En Çok Satış Geliri Elde Eden Ürünü Bulun
-- Her kategori için toplam satış geliri en yüksek olan ürünü bulun ve listeleyin.
WITH max_income  AS(
	SELECT c.category_name, p.product_name, SUM(od.unit_price*od.quantity) as income
	FROM Categories AS c
	INNER JOIN Products AS p ON p.category_id = c.category_id
	INNER JOIN Order_Details AS od ON od.product_id = p.product_id
	GROUP BY c.category_name, p.product_name
	ORDER BY c.category_name, income DESC
), 
row_income AS (
	SELECT category_name, product_name, income,
	ROW_NUMBER() OVER (PARTITION BY category_name) as row_max
	FROM max_income
)
SELECT category_name, product_name, income
FROM row_income
WHERE row_max = 1 

-- 4️⃣ Arka Arkaya En Fazla Sipariş Veren Müşteriyi Bulun
-- Sipariş tarihleri (OrderDate) baz alınarak arka arkaya en fazla sipariş veren müşteriyi bulun. (Örneğin, bir müşteri ardışık 
-- günlerde kaç sipariş vermiş?)
WITH dates AS (
	SELECT c.customer_id,
	  	   c.company_name,
		   o.order_date,
		   LAG (o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date ) AS prev_date,
	   	   o.order_date - LAG (o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date ) AS fark   
	FROM Customers AS c
	INNER JOIN Orders AS o ON o.customer_id = c.customer_id
)
--SELECT customer_id,company_name, order_date, prev_date, fark
--FROM dates
,
group_date AS(
	SELECT customer_id, order_date, prev_date, fark,
	CASE
		WHEN fark <=1 OR fark IS NULL THEN 1
		ELSE 0 
	END AS group_art
	FROM dates
)
--SELECT customer_id, order_date, prev_date, fark, group_art
--FROM group_date
,
grouped_dates AS (
    SELECT customer_id, order_date, prev_date, fark, group_art,
           SUM(CASE WHEN group_art = 1 THEN 0 ELSE 1 END) 
               OVER (PARTITION BY customer_id ORDER BY order_date) AS group_num
    FROM group_date
)
--SELECT customer_id, order_date, prev_date, fark, group_art,group_num
--FROM grouped_dates
,
count_group AS (
    SELECT customer_id, group_num, COUNT(*) AS consecutive_orders
    FROM grouped_dates
    GROUP BY customer_id, group_num
)
SELECT customer_id, consecutive_orders
from count_group
ORDER BY consecutive_orders DESC
LIMIT 1

-- 5️⃣ Çalışanların Sipariş Sayısına Göre Kendi Departmanındaki Ortalamanın Üzerinde Olup Olmadığını Belirleyin
-- Her çalışanın aldığı sipariş sayısını hesaplayın ve kendi departmanındaki çalışanların ortalama sipariş sayısıyla karşılaştırın. 
-- Ortalama sipariş sayısının üstünde veya altında olduğunu belirten bir sütun ekleyin.

WITH first_query AS(
	SELECT e.employee_id, e.first_name, e.last_name,e.title ,COUNT(o.order_id) AS order_count
	FROM Employees AS e
	INNER JOIN Orders AS o ON o.employee_id = e.employee_id
	GROUP BY e.employee_id, e.first_name, e.last_name, e.title
	ORDER BY order_count DESC 
),
second_query AS(
	SELECT employee_id, first_name, last_name, order_count, 
	AVG(order_count) OVER (PARTITION BY title) AS avg_order
	FROM first_query
)
SELECT employee_id, first_name, last_name, order_count, avg_order,
CASE 
	WHEN order_count < avg_order THEN 'Ortalamanın altında'
	WHEN order_count > avg_order THEN 'Ortalamanın üstünde'
	ELSE 'Eşit ortalama'
END AS order_performance
FROM second_query

-- **Level 3 - Expert** Pazartesiye kadar

-- AR_GE -> CTE (Common Table Expressions), Window Functions, Recursive Queries, Pivot, Subqueries ve Advanced Aggregation

-- 1️⃣ Her Müşteri İçin En Son 3 Siparişi ve Toplam Harcamalarını Listeleyin
-- Her müşterinin en son 3 siparişini (OrderDate’e göre en güncel 3 sipariş) ve bu siparişlerde harcadığı toplam tutarı gösteren bir sorgu yazın.
-- Sonuç müşteri bazında sıralanmalı ve her müşterinin sadece en son 3 siparişi görünmelidir.
WITH last_order AS (
SELECT o.order_date, c.customer_id, o.order_id, p.unit_price, od.quantity,
ROW_NUMBER () OVER (PARTITION BY c.customer_id ORDER BY o.order_date DESC) AS row_num
FROM Customers AS c
INNER JOIN Orders AS O ON o.customer_id = c.customer_id
INNER JOIN Order_details AS od ON od.order_id = o.order_id 
INNER JOIN Products AS p ON p.product_id = od.product_id
),
row_order AS(
	SELECT order_date, customer_id, order_id, row_num,
	SUM (quantity*unit_price) OVER (PARTITION BY order_id) AS total_count
	FROM last_order 
	WHERE row_num BETWEEN 1 AND 3
)
SELECT order_date, customer_id, order_id, total_count
FROM row_order
ORDER BY customer_id, order_date DESC

-- 2️⃣ Aynı Ürünü 3 veya Daha Fazla Kez Satın Alan Müşterileri Bulun
-- Bir müşteri eğer aynı ürünü (ProductID) 3 veya daha fazla sipariş verdiyse, bu müşteriyi ve ürünleri listeleyen bir sorgu yazın.
-- Aynı ürün bir siparişte değil, farklı siparişlerde tekrar tekrar alınmış olabilir.
WITH group_customer AS(
	SELECT c.customer_id, p.product_id, p.product_name
	FROM Customers AS c
	INNER JOIN Orders AS o ON o.customer_id = c.customer_id
	INNER JOIN Order_details AS od ON od.order_id = o.order_id
	INNER JOIN Products AS p ON p.product_id = od.product_id
),
count_product AS(
	SELECT customer_id, product_id, product_name,
			COUNT(*) OVER (PARTITION BY customer_id, product_id ) AS count_rnk
	FROM group_customer
)
SELECT DISTINCT customer_id, product_name, count_rnk
FROM count_product
WHERE count_rnk >= 3
ORDER BY customer_id

-- 3️⃣ Bir Çalışanın 30 Gün İçinde Verdiği Siparişlerin Bir Önceki 30 Güne Göre Artış/ Azalışını Hesaplayın
-- Her çalışanın (Employees), sipariş sayısının son 30 gün içinde bir önceki 30 güne kıyasla nasıl değiştiğini hesaplayan bir sorgu yazın.
-- Çalışan bazında sipariş sayısı artış/azalış yüzdesi hesaplanmalı.
WITH date_series AS (
    SELECT e.employee_id, e.first_name, e.last_name,
			generate_series(
		         MIN(o.order_date),
		         MAX(o.order_date),
		        '30 days'::INTERVAL
		    )::DATE AS first_date, MAX(o.order_date)  AS max_d
	FROM employees AS e
	INNER JOIN orders AS o ON e.employee_id = o.employee_id
	GROUP BY e.employee_id 
	ORDER BY e.employee_id
),
create_lead AS (
	SELECT employee_id, first_name, last_name, first_date,
			COALESCE((LEAD(first_date) OVER (PARTITION BY employee_id) - '1 DAY'::INTERVAL)::DATE, max_d ) AS last_date
	FROM date_series
),
growth_percentage AS (
		SELECT cl.employee_id, cl.first_name, cl.last_name, cl.first_date, cl.last_date,
		       (SELECT COUNT(o.employee_id)
		        FROM orders as o
		        WHERE o.employee_id = cl.employee_id
		        AND o.order_date BETWEEN cl.first_date AND cl.last_date) AS total_amount
		FROM create_lead AS cl
		ORDER BY cl.employee_id, cl.first_date
),
lag_data AS(
    SELECT employee_id,first_name, last_name,first_date,last_date,total_amount,
        LAG(total_amount) OVER (PARTITION BY employee_id ORDER BY first_date) AS previous_total
    FROM growth_percentage
)
SELECT
    employee_id,first_name, last_name,first_date,last_date,total_amount,previous_total,
    CASE
        WHEN previous_total IS NULL OR previous_total = 0 THEN NULL
        ELSE round (((total_amount - previous_total)::numeric / previous_total) * 100,2)
    END AS growth_percentage
FROM lag_data
ORDER BY employee_id, first_date


-- 4️⃣ Her Müşterinin Siparişlerinde Kullanılan İndirim Oranının Zaman İçinde Nasıl Değiştiğini Bulun
-- Müşterilerin siparişlerinde uygulanan indirim oranlarının zaman içindeki trendini hesaplayan bir sorgu yazın.

-- Müşteri bazında hareketli ortalama indirim oranlarını hesaplayın ve sipariş tarihine göre artış/azalış eğilimi belirleyin.
WITH discount_trend AS (
    SELECT o.customer_id, o.order_date, od.discount,
          ROUND(AVG(od.discount::NUMERIC) OVER (
            	PARTITION BY o.customer_id 
            	ORDER BY o.order_date 
            	ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        		), 2) AS moving_discount
    FROM ORDERS AS o
    INNER JOIN Order_details AS od ON od.order_id = o.order_id
)
SELECT 
    customer_id,
    order_date,
    discount,
    moving_discount,
    moving_discount - LAG(moving_discount) OVER (PARTITION BY customer_id ORDER BY order_date) AS trend
FROM discount_trend
ORDER BY customer_id, order_date

