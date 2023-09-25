-- Let's expand the data model to include physical addresses for users
-- And accommodate the possibility of multiple users sharing the same address 
-- create two additional tables: one for addresses and one for the relationship between users and addresses
-- Here's how the updated data model could look:

-- Table: Users
-- UserId (Primary Key)
-- FName
-- LName
-- Email
-- Table: Addresses

-- Create Users Table
CREATE TABLE Users (
    UserId INT PRIMARY KEY,
    FName VARCHAR(50),
    LName VARCHAR(50),
    Email VARCHAR(100)
);


-- AddressId (Primary Key)
-- Street
-- City
-- ZipCode
-- Table: UserAddresses

-- Create Addresses Table
CREATE TABLE Addresses (
    AddressId INT PRIMARY KEY,
    Street VARCHAR(100),
    City VARCHAR(50),
    ZipCode VARCHAR(10)
);

-- UserAddressId (Primary Key)
-- UserId (Foreign Key referencing Users)
-- AddressId (Foreign Key referencing Addresses)

-- Create UserAddresses Table
CREATE TABLE UserAddresses (
    UserAddressId INT PRIMARY KEY,
    UserId INT,
    AddressId INT,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (AddressId) REFERENCES Addresses(AddressId)
);


-- In this model, the Users table remains unchanged. 
-- The Addresses table stores information about physical addresses, 
-- And the UserAddresses table serves as a many-to-many relationship between users and addresses, allowing multiple users to share the same address.

-- When a user has multiple addresses or multiple users share the same address, you'll create records in the UserAddresses table to represent these relationships. 
-- Each record will link a user to an address.


-- To return the email of users without a physical address 
-- Use a LEFT JOIN to join the Users table with the UserAddresses table 
-- Snd then filter out the records where there is no matching address

SELECT Users.Email
FROM Users
LEFT JOIN UserAddresses ON Users.UserId = UserAddresses.UserId
WHERE UserAddresses.UserAddressId IS NULL;

-- In this query, the LEFT JOIN retrieves all rows from the Users table and only the matching rows from the UserAddresses table
-- The WHERE clause filters out the rows where there is no matching address 
-- effectively giving you the email addresses of users without a physical address


-- To retrieve the user IDs of users who have three or more addresses:
-- use a SQL query with a GROUP BY clause and a HAVING clause to filter the results based on the count of addresses
SELECT UserAddresses.UserId
FROM UserAddresses
GROUP BY UserAddresses.UserId
HAVING COUNT(*) >= 3;

-- In this query, the GROUP BY groups the records in the UserAddresses table by UserId 
-- And then the HAVING clause filters the results to only include those groups where the count of records (i.e., addresses) is three or more

-- To retrieve the user IDs of users who have three or more addresses in California, 
-- Modify the query to include additional conditions in the WHERE clause
SELECT UA.UserId
FROM UserAddresses UA
JOIN Addresses A ON UA.AddressId = A.AddressId
WHERE A.City = 'California' -- Assuming 'California' is the city name for addresses in California
GROUP BY UA.UserId
HAVING COUNT(*) >= 3;

-- In this query, we use a JOIN between the UserAddresses and Addresses tables to connect the user addresses with their corresponding address information
-- Then, the WHERE clause filters for addresses with a city name of 'California' 
-- The GROUP BY and HAVING clauses work the same way as before, ensuring that you only retrieve user IDs who have three or more addresses in California




