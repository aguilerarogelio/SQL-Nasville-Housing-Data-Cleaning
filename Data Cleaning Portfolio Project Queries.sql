--DATA CLEANING SQL

SELECT *
FROM NashvilleHousing.dbo.HousingData 

-- DATE FORMATTING
SELECT SaleDate, CONVERT(Date,SaleDate) AS PropperDateFormat
FROM NashvilleHousing.dbo.HousingData

ALTER TABLE NashvilleHousing.dbo.HousingData
ADD SaleDateUpdtd Date

UPDATE NashvilleHousing.dbo.HousingData
SET SaleDateUpdtd = CONVERT(Date, SaleDate)

SELECT SaleDateUpdtd
FROM NashvilleHousing.dbo.HousingData


-- Populate Property Address data

SELECT PropertyAddress
FROM NashvilleHousing.dbo.HousingData
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) AS UpdtAdress
FROM NashvilleHousing.dbo.HousingData a
JOIN NashvilleHousing.dbo.HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing.dbo.HousingData a
JOIN NashvilleHousing.dbo.HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)
----Breaking out proprty adress

SELECT PropertyAddress
FROM NashvilleHousing.dbo.HousingData

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) AS City
FROM NashvilleHousing.dbo.HousingData

ALTER TABLE NashvilleHousing.dbo.HousingData
ADD PropertySplitAddress Nvarchar(255);

Update NashvilleHousing.dbo.HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing.dbo.HousingData
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing.dbo.HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT PropertyAddress, PropertySplitAddress, PropertySplitCity
FROM NashvilleHousing.dbo.HousingData

----Breaking out owner adress

Select OwnerAddress
From NashvilleHousing.dbo.HousingData

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing.dbo.HousingData

ALTER TABLE NashvilleHousing.dbo.HousingData
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing.dbo.HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing.dbo.HousingData
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing.dbo.HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing.dbo.HousingData
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing.dbo.HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
From NashvilleHousing.dbo.HousingData

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT (SoldAsVacant), Count(SoldAsVacant)
FROM NashvilleHousing.dbo.HousingData
GRUOP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing.dbo.HousingData


UPDATE NashvilleHousing.dbo.HousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

SELECT DISTINCT SoldAsVacant
FROM NashvilleHousing.dbo.HousingData

-- Remove Duplicates

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference 
            ORDER BY UniqueID)
         AS row_num
    FROM NashvilleHousing.dbo.HousingData)

--DELETE
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

Select *
From NashvilleHousing.dbo.HousingData

-- Delete Unused Columns

SELECT *
FROM NashvilleHousing.dbo.HousingData

ALTER TABLE NashvilleHousing.dbo.HousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



















