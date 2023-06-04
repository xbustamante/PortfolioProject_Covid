--GUIDED PROJECT_DATA CLEANING 

/*

Cleaning Data in SQL Queries

*/


SELECT* 
FROM PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
SELECT
SaleDate,
CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

/* Query below did not work*/
--Update PortfolioProject.dbo.NashvilleHousing
--Set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

SELECT
SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHousing

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
SELECT*
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID


SELECT a.ParcelID, 
a.PropertyAddress,
b.ParcelID as ParcelId2,
b.PropertyAddress as ProprtyAddress2,
ISNULL(a.PropertyAddress, b.PropertyAddress) as UpdatedPropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null
--ORDER BY a.PropertyAddress

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

--Double Check 
SELECT*
FROM PortfolioProject.dbo.NashvilleHousing 
ORDER BY PropertyAddress

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
--delimeter is ,

SELECT
PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as City
FROM PortfolioProject.dbo.NashvilleHousing 

ALTER TABLE NashvilleHousing
Add SplitPropertyAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set SplitPropertyAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add SplitPropertyCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set SplitPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing 

--delimeter is ,

SELECT
OwnerAddress,
 PARSENAME(REPLACE(OwnerAddress,',', '.'),3),
 PARSENAME(REPLACE(OwnerAddress,',', '.'),2),
 PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SplitOwnerAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set SplitOwnerAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SplitOwnerCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set SplitOwnerCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SplitOwnerState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set SplitOwnerState= PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
--Verify 
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT distinct(SoldAsVacant),
COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
CASE When SoldAsVacant='Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant 
END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant='Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant 
END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
With CTE1 as (
SELECT *,
Row_Number() Over (Partition by ParcelID, PropertyAddress,SalePrice,SaleDate, LegalReference
ORDER BY UniqueId) row_num
FROM PortfolioProject.dbo.NashvilleHousing)
--WHERE row_num > 1
--ORDER BY ParcelID

SELECT *
From CTE1
Where row_num > 1







---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
















