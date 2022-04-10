/****** A quick Data Cleanning ****/

USE [My Portfolio];
SELECT * FROM dbo.[Nashvile Hausing Price]


--Changing Date-Format

SELECT SaleDate, CAST(SaleDate As Date) As SaleDateConveted
FROM dbo.[Nashvile Hausing Price]

ALTER TABLE [dbo].[Nashvile Hausing Price]
Add SaleDateConverted Date

UPDATE [dbo].[Nashvile Hausing Price]
SET SaleDateConverted = CAST(SaleDate As Date) 


--Identifying and Dealing with Nulls in PropertyAddress Column

SELECT PropertyAddress, ParcelID FROM dbo.[Nashvile Hausing Price]
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.[Nashvile Hausing Price] AS a 
JOIN dbo.[Nashvile Hausing Price] AS b
ON a.ParcelID = b.ParcelID 
AND
a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL 


--Separating Columns; PropertyAddress Column can be separated into 3 Columns

SELECT PropertyAddress 
From dbo.[Nashvile Hausing Price]

SELECT SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) As Adress,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) As Address
FROM [Nashvile Hausing Price]

ALTER TABLE [dbo].[Nashvile Hausing Price]
Add Address Nvarchar(255)

UPDATE dbo.[Nashvile Hausing Price]
SET Address = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [dbo].[Nashvile Hausing Price]
Add City Nvarchar(255)

UPDATE dbo.[Nashvile Hausing Price]
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * FROM [dbo].[Nashvile Hausing Price]


--The OwnerAddress Column can also be separated into 3 different Columns

SELECT PARSENAME(REPLACE(owneraddress, ',', '.'), 3),
PARSENAME(REPLACE(owneraddress, ',', '.'), 2),
PARSENAME(REPLACE(owneraddress, ',', '.'), 1)
OwnerAddress FROM dbo.[Nashvile Hausing Price]

ALTER TABLE [dbo].[Nashvile Hausing Price]
Add OwnerSpliAddress Nvarchar(255);

UPDATE [dbo].[Nashvile Hausing Price]
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',', '.'), 3)

ALTER TABLE [dbo].[Nashvile Hausing Price]
Add OwnerCity Nvarchar(255);

UPDATE [dbo].[Nashvile Hausing Price]
SET OwnerCity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2)

ALTER TABLE [dbo].[Nashvile Hausing Price]
Add State Nvarchar(255);

UPDATE [dbo].[Nashvile Hausing Price]
SET State = PARSENAME(REPLACE(owneraddress, ',', '.'), 1)

SELECT * FROM [dbo].[Nashvile Hausing Price]


--Changing "Y" and "N" to "Yes" and "No" respectively

SELECT SoldAsVacant,
		CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		End
FROM [dbo].[Nashvile Hausing Price]

UPDATE [dbo].[Nashvile Hausing Price]
SET SoldAsVacant = CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	End 


--Looking for Duplicates

SELECT UniqueID, COUNT(*)
FROM dbo.[Nashvile Hausing Price]
GROUP BY UniqueID
HAVING COUNT(*) > 1

