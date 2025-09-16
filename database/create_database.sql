-- Tạo Database
CREATE DATABASE FLC_CRM;
GO

USE FLC_CRM;
GO

-- =========================
-- Bảng Nhân viên (Employees)
-- =========================
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Position NVARCHAR(50)
);
GO

-- =========================
-- Bảng Khách hàng tiềm năng (Leads)
-- =========================
CREATE TABLE Leads (
    LeadID INT IDENTITY(1,1) PRIMARY KEY,
    LeadName NVARCHAR(100) NOT NULL,
    Company NVARCHAR(100),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    EmployeeID INT NOT NULL, -- nhân sự phụ trách
    Address NVARCHAR(200),
    Source NVARCHAR(100),
    Notes NVARCHAR(MAX),
    StartDate DATE NOT NULL DEFAULT GETDATE(),
    DaysPassed AS DATEDIFF(DAY, StartDate, GETDATE()), -- cột computed
    Status NVARCHAR(20) NOT NULL CHECK (Status IN (N'Chưa liên hệ', N'Đã liên hệ', N'Chuyển đổi', N'Không chuyển đổi')),
    CONSTRAINT FK_Leads_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

-- =========================
-- Bảng Khách hàng chính thức (Customers)
-- =========================
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    BirthDate DATE,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Gender NVARCHAR(10) CHECK (Gender IN (N'Nam', N'Nữ', N'Khác')),
    BusinessField NVARCHAR(100),
    Address NVARCHAR(200),
    EmployeeID INT NOT NULL, -- nhân sự phụ trách
    Notes NVARCHAR(MAX),
    CONSTRAINT FK_Customers_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

-- =========================
-- Bảng Liên hệ khách hàng (CustomerContacts)
-- =========================
CREATE TABLE CustomerContacts (
    ContactID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    Relation NVARCHAR(50), -- quan hệ với khách hàng (vd: Vợ/Chồng, Trợ lý, Con, ...)
    Notes NVARCHAR(MAX),
    CONSTRAINT FK_Contacts_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO