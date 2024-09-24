# SQL-Nasville-Housing-Data-Cleaning
This project focuses on cleaning and transforming a dataset containing housing information from the Nashville Housing market. The goal is to ensure data consistency, improve data quality, and prepare the dataset for analysis. Several SQL techniques are employed to handle various data cleaning tasks such as date formatting, filling missing values, splitting address information, updating records, and removing duplicates.

Date Formatting: 
Converted SaleDate from various formats to a proper SQL Date type for consistency.
Address Population: 
Used self-joins to populate missing PropertyAddress values based on matching ParcelID.
Splitting Address Fields: 
Broke down full property and owner addresses into separate columns for Address, City, and State.
Updating "Sold As Vacant" Field: Replaced 'Y' and 'N' values with more descriptive 'Yes' and 'No' values.
Duplicate Removal: 
Identified and removed duplicate entries based on key fields (ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference).
Dropping Unused Columns: 
Removed unnecessary columns such as OwnerAddress, TaxDistrict, and others to streamline the dataset.
