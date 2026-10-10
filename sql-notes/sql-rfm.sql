CREATE TABLE RFM_OR
(CustomerID VARCHAR(20),
LastInvoiceDate DATETIME,
FirstInvoiceDate DATETIME,
Recency INT,
Monetary INT,
Frequency INT,
Tenure INT,
Basket_Size FLOAT,
Frequency_Scale INT,
Recency_Scale INT,

Segment VARCHAR(50));

SELECT * FROM RFM_OR

---Müşteri ID eklenmesi
INSERT INTO RFM_OR(CustomerID)
SELECT DISTINCT Customer_ID FROM dbo.retail_II

---Son satın alma tarihi ekleme
UPDATE RFM_OR SET LastInvoiceDate=(SELECT MAX(InvoiceDate)
FROM dbo.retail_II r
where r. Customer_ID=RFM_OR.CustomerID)

--- Recency değerinin doldurulması

UPDATE RFM_OR SET Recency= DATEDIFF(DAY, LastInvoiceDate, '20120101')

---Müşterinin ilk satın alma tarihlerini elde etme

UPDATE RFM_OR SET FirstInvoiceDate=(SELECT MIN(InvoiceDate)
FROM dbo.retail_II r
where r. Customer_ID=RFM_OR.CustomerID)
---

---Tenure değerinin doldurulması
UPDATE RFM_OR SET Tenure=DATEDIFF(DAY,FirstInvoiceDate,'20120101')

---Frequency değerinin doldurulması
UPDATE RFM_OR SET Frequency= (SELECT COUNT(DISTINCT Invoice)  FROM dbo.retail_II r 
WHERE r.Customer_ID=RFM_OR.CustomerID)

---Monetary değerinin doldurulması
UPDATE RFM_OR SET Monetary= (SELECT SUM(Quantity*Price)  FROM dbo.retail_II r 
WHERE r.Customer_ID=RFM_OR.CustomerID)

---Basket size değerinin doldurulması
UPDATE RFM_OR SET Basket_Size= (Monetary/Frequency) FROM RFM_OR

---Scale hesapları
UPDATE RFM_OR SET Frequency_Scale = (SELECT rank_
FROM (SELECT CustomerID, Frequency, NTILE(5) OVER (ORDER BY Frequency) rank_ FROM RFM_OR) T 
WHERE CustomerID= RFM_OR.CustomerID)

UPDATE RFM_OR SET Recency_Scale = (SELECT rank_
FROM (SELECT CustomerID, Recency, NTILE(5) OVER (ORDER BY Recency) rank_ FROM RFM_OR) T 
WHERE CustomerID= RFM_OR.CustomerID)

--- Segment İsimleri

UPDATE RFM_OR SET Segment = 'Hibernating'
WHERE Recency_Scale LIKE '[1-2]' AND Frequency_Scale LIKE '[1-2]'


UPDATE RFM_OR SET Segment = 'At_Risk'
WHERE Recency_Scale LIKE '[1-2]' AND Frequency_Scale LIKE '[3-4]'
 

UPDATE RFM_OR SET Segment ='Cant_Loose' 
WHERE Recency_Scale LIKE  '[1-2]' AND Frequency_Scale LIKE '[5]'  

UPDATE RFM_OR SET Segment ='About_to_Sleep' 
WHERE Recency_Scale LIKE  '[3]' AND Frequency_Scale LIKE '[1-2]'  

UPDATE RFM_OR SET Segment ='Need_Attention' 
WHERE Recency_Scale LIKE  '[3]' AND Frequency_Scale LIKE '[3]' 

UPDATE RFM_OR SET Segment ='Loyal_Customers' 
WHERE Recency_Scale LIKE  '[3-4]' AND Frequency_Scale LIKE '[4-5]' 

UPDATE RFM_OR SET Segment ='Promising' 
WHERE Recency_Scale LIKE  '[4]' AND Frequency_Scale LIKE '[1]' 

UPDATE RFM_OR SET Segment ='New_Customers' 
WHERE Recency_Scale LIKE  '[5]' AND Frequency_Scale LIKE '[1]' 

UPDATE RFM_OR SET Segment ='Potential_Loyalists' 
WHERE Recency_Scale LIKE  '[4-5]' AND Frequency_Scale LIKE '[2-3]' 

UPDATE RFM_OR SET Segment ='Champions' 
WHERE Recency_Scale LIKE  '[5]' AND Frequency_Scale LIKE '[4-5]'

SELECT Segment, Count(CustomerID) As Musteri_Adet
FROM RFM_OR
WHERE Segment is not NULL
GROUP BY Segment





SELECT * FROM RFM_OR

