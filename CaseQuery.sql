--🎯 CASE 1: En Çok Satış Yapan Müşteriler
--Kategori: Satış
--Senaryo: Satış departmanı, 2022 yılı içerisinde en çok alışveriş yapan ilk 10 müşteriyi öğrenmek istiyor.
/*
Görev:
Sales.SalesOrderHeader, 
Sales.SalesOrderDetail, 
Person.Person, 
Sales.Customer tablolarını kullan.
Toplam sipariş tutarına göre sıralama yap.
Sonuçlara müşteri adı ve e-posta adresini dahil et.
*/

Select Top 10
	SOH.CustomerID,
	P.FirstName,
	P.MiddleName,
	P.LastName,
	PE.EmailAddress,
	Count(SOH.SalesOrderID) AS OrderCount
	From Sales.SalesOrderDetail SOD
Join Sales.SalesOrderHeader SOH on SOH.SalesOrderID = SOD.SalesOrderID
Join Sales.Customer SC on SC.CustomerID = SOH.CustomerID 
Join Person.Person P on P.BusinessEntityID =SC.CustomerID
Join Person.EmailAddress PE on PE.BusinessEntityID = P.BusinessEntityID
Group By SOH.CustomerID,P.FirstName,P.MiddleName,P.LastName,PE.EmailAddress
Order By OrderCount Desc



--⚙️ CASE 2: Stokta Bitmeye Yakın Ürünler
--Kategori: Üretim / Stok
--Senaryo: Üretim yöneticisi, stokta 10 adetten az kalan ürünleri görmek istiyor.
/*
Görev:
Production.ProductInventory ve Production.Product tablolarını kullan.
Stok adedi (Quantity) 10’dan küçük olan ürünleri listele.
Ürün adı, stok miktarı ve konum (LocationID) gösterilsin.
*/

Select 
	PP.Name,
	PrI.Quantity,
	PrI.LocationID
From Production.Product PP 
Join Production.ProductInventory PrI on PrI.ProductID = PP.ProductID
Where PrI.Quantity <= 10




--👥 CASE 3: Departman Bazlı Çalışan Sayısı
--Kategori: İnsan Kaynakları
--Senaryo: İK yöneticisi, her departmanda kaç çalışan olduğunu öğrenmek istiyor.
/*
Görev:
HumanResources.Employee, 
HumanResources.EmployeeDepartmentHistory, 
HumanResources.Department tablolarını birleştir.
En güncel kayıtları al (çalışanlar zamanla departman değiştirmiş olabilir).
Departman adlarına göre gruplama yap, çalışan sayısını göster.
*/


Select 
	D.DepartmentID,
	D.Name,
	Count(BusinessEntityID) as DepartmentEmployeeCount
From HumanResources.EmployeeDepartmentHistory EDH
Join HumanResources.Department D on D.DepartmentID = EDH.DepartmentID
Group By D.DepartmentID,D.Name





--📦 CASE 4: En Çok Satılan Ürünler
--Kategori: Satış / Ürün Analizi
--Senaryo: Pazarlama ekibi, son 6 ayda en çok satılan 5 ürünü öğrenmek istiyor.
/*
Görev:
Sales.SalesOrderDetail ve Production.Product tablolarını kullan.
Son 6 aylık satışları filtrele.
Toplam satılan miktara göre sıralayıp ilk 5 ürünü getir.
Ürün adı ve toplam adet gösterilsin.
*/
Select Top 5
	P.Name,
	Count(SOD.SalesOrderID) as TotalOrderForProduct,
	SOD.ModifiedDate
From Sales.SalesOrderDetail SOD 
Join Production.Product P on P.ProductID = SOD.ProductID
Group By P.ProductID,P.Name,SOD.ModifiedDate
Order By TotalOrderForProduct desc




--💰 CASE 5: Tedarikçi Başına Ortalama Sipariş Maliyeti
--Kategori: Satın Alma / Tedarik
--Senaryo: Satın alma yöneticisi, tedarikçi başına yapılan ortalama ürün maliyetini öğrenmek istiyor.
/*
Görev:
Purchasing.PurchaseOrderHeader,
Purchasing.PurchaseOrderDetail, 
Purchasing.Vendor tablolarını kullan.
Her tedarikçinin toplam sipariş tutarını ve toplam sipariş sayısını hesapla.
Ortalama maliyeti bul (ToplamTutar / SiparişSayısı).
*/



Select
	PV.Name,
	SUM(POD.OrderQty) As TotalOrder,
	SUM(POH.SubTotal) As SubTotal,
	SUM(POH.SubTotal) / SUM(POD.OrderQty) As AvaregeCost
From 
Purchasing.PurchaseOrderDetail POD
Join Purchasing.PurchaseOrderHeader POH on POH.PurchaseOrderID = POD.PurchaseOrderID
Join Purchasing.Vendor PV on PV.BusinessEntityID = POH.VendorID
Group By PV.Name

--🕵 CASE 6: Adresi Aynı Olan Müşteriler
--Kategori: Veri Kalitesi / Müşteri
--Senaryo: CRM ekibi, aynı adreste birden fazla müşterinin kayıtlı olup olmadığını analiz etmek istiyor.

/*
Görev:
Person.Address, Sales.CustomerAddress, Sales.Customer tablolarını kullan.
Aynı AddressID'ye sahip birden fazla müşteri kaydı olan adresleri getir.
Adres bilgileri ve müşteri sayısı gösterilsin.
*/
--BU CASE İÇİN ASLINDA VİEWS YAZMIŞTIK KONTROL EDİLMELİ.






--📊 CASE 7: Aylık Satış Trend Analizi
--Kategori: Finans / Raporlama
--Zorluk: Orta
--Senaryo: Finans ekibi, 2021 ve 2022 yıllarında yapılan satışların her ay nasıl değiştiğini görmek istiyor.

--Görev:
--Sales.SalesOrderHeader tablosundan OrderDate ve TotalDue alanlarını kullan.
--Yıla ve aya göre gruplayarak toplam satış tutarını hesapla.
--Sonuçları YYYY-MM formatında sıralı olarak listele.

Select
  FORMAT(OrderDate, 'yyyy-MM') as YearMonth,
  SUM(TotalDue) as TotalSales
From Sales.SalesOrderHeader
Where YEAR(OrderDate) in (2011, 2014)
Group By FORMAT(OrderDate, 'yyyy-MM')
Order By YearMonth




--🚚 CASE 8: Geciken Siparişlerin Listesi
--Kategori: Lojistik / Operasyon
--Zorluk: Zor
--Senaryo: Lojistik yöneticisi, teslim tarihi geçen ancak henüz kargoya verilmemiş siparişleri listelemek istiyor.
--Görev:

--Sales.SalesOrderHeader tablosunda ShipDate, DueDate, Status gibi alanları incele.
--Teslim tarihi (DueDate) geçmiş, fakat ShipDate null olan siparişleri getir.
--Sipariş numarası, müşteri bilgisi ve gecikme süresini (bugün - DueDate) hesapla.


Select
    SOH.SalesOrderID,
    SOH.CustomerID,
    SOH.DueDate,
    DATEDIFF(day, SOH.DueDate, GETDATE()) as DelayDays
From Sales.SalesOrderHeader SOH
Where
    SOH.DueDate < GETDATE()
    and SOH.ShipDate is null
Order By DelayDays desc



--🧾 CASE 9: Çalışan Maaş Analizi (Confidential)
--Kategori: İnsan Kaynakları / Finans
--Zorluk: Orta
--Senaryo: İK ve Finans ekipleri, her departmandaki ortalama maaş farklarını incelemek istiyor.
--Görev:
--HumanResources.EmployeePayHistory, HumanResources.EmployeeDepartmentHistory, HumanResources.Department tablolarını birleştir.
--Her departmandaki ortalama maaşı hesapla.
--En güncel maaş bilgilerini al (EmployeePayHistory'deki son tarih).

Select D.DepartmentID,
       D.Name        as DepartmentName,
       AVG(EPH.Rate) as AverageSalary
From HumanResources.EmployeePayHistory EPH
         Join HumanResources.EmployeeDepartmentHistory EDH
              on EPH.BusinessEntityID = EDH.BusinessEntityID
                  and EDH.EndDate is null
         Join HumanResources.Department D
              on D.DepartmentID = EDH.DepartmentID
Where EPH.RateChangeDate = (Select MAX(RateChangeDate)
                            From HumanResources.EmployeePayHistory EPH2
                            Where EPH2.BusinessEntityID = EPH.BusinessEntityID)
Group By D.DepartmentID, D.Name
Order By D.DepartmentID



--🛒 CASE 10: Sepette Ürün Kalma Süresi
--Kategori: Müşteri Davranışı / Satış
--Zorluk: Zor
--Senaryo: Ekip, müşterilerin sipariş vermeden önce sepette ürünleri ne kadar süre tuttuğunu analiz etmek istiyor.
--Görev:

--Sales.ShoppingCartItem tablosunu kullan.

--DateCreated ve ModifiedDate sütunları arasındaki farkı gün cinsinden hesapla.

--En uzun süre sepette tutulan ilk 20 ürünü göster.

--🔧 CASE 11: Ürün Güncelleme Gerekliliği Analizi
--Kategori: Ürün Yönetimi
--Zorluk: Orta
--Senaryo: Ürün yönetimi, en son ne zaman güncellenmiş ürünlerin listesini almak ve yenilenmeye ihtiyaç duyanları görmek istiyor.
--Görev:

--Production.Product tablosundaki ModifiedDate alanına bak.

--2 yıldan uzun süredir güncellenmeyen ürünleri listele.

--Ürün adı, kategori ve güncellenmeyen gün sayısını göster.

--🏭 CASE 12: Tedarik Zinciri Zayıflık Noktaları
--Kategori: Tedarik Zinciri Yönetimi
--Zorluk: Zor
--Senaryo: Şirket, en geç teslim yapan tedarikçileri belirlemek istiyor.
--Görev:

--Purchasing.PurchaseOrderHeader, Purchasing.Vendor tablolarını birleştir.

--OrderDate ile ShipDate arasındaki farkı hesapla.

--Ortalama teslim süresi en uzun olan ilk 5 tedarikçiyi sırala.


