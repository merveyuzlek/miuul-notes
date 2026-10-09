---1)"Geciken Urunler" ortalama kaç gün geciktiğini getiren sorguyu yazınız.
SELECT AVG(Gecikme) Ort_Gecikme
FROM(
SELECT OrderID, RequiredDate, ShippedDate,
DAT_EDIFF(day,RequiredDate, ShippedDate) as Gecikme
FROM Orders
WHERE DATEDIFF(day,RequiredDate, ShippedDate)>0)A

--subquery olmadan
SELECT 
AVG(DATEDIFF(Day, RequiredDate, ShippedDate)) as Ort_Gecikme
FROM Orders
WHERE DATEDIFF(Day, RequiredDate, ShippedDate) >0

---2)"Erken Giden Urunler" in ortalama kaç gün erken gittiğini getiren sorguyu yazınız.
SELECT AVG(ErkenGönderim) Ort_ErkenGönderim
FROM(
SELECT OrderID, RequiredDate, ShippedDate,
DATEDIFF(day,RequiredDate, ShippedDate) as ErkenGönderim
FROM Orders
WHERE DATEDIFF(day,RequiredDate, ShippedDate)<0)A

--subquery olmadan
SELECT 
AVG(DATEDIFF(Day, RequiredDate, ShippedDate)) as Ort_ErkenGönderim
FROM Orders
WHERE DATEDIFF(Day, RequiredDate, ShippedDate)<0

---3)CustomerID bazında Toplam Ne Kadar Gelir elde edildiğini gösteren tabloyu getiren sorguyu yazınız. - Monetary
SELECT Customer_ID, SUM(Price*Quantity) as Monetary
FROM dbo.retail_II
GROUP BY Customer_ID

---4)CustomerID bazında 2011.12.30 tarihine göre Recency değerlerini gösteren tabloyu oluşturacak sorguyu yazınız.
SELECT Customer_ID, Max(InvoiceDate) as Last_Purchase_Date, DATEDIFF(DAY, MAX(InvoiceDate),'20111230') as Recency
FROM dbo.retail_II
GROUP BY Customer_ID

---5)Ülke bazında en fazla satın alınan ürünlerin toplam adedini gösteren tabloyu oluşturacak sorguyu yazınız.
SELECT * FROM 
(SELECT Country, [Description], SUM(Quantity) as Satis_Adet, SUM(Quantity*Price) as Ciro,
ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(Quantity) DESC) as Rank
FROM dbo.retail_II
GROUP BY Country, [Description]) A
WHERE Rank=1
