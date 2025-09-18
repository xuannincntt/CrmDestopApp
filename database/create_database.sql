-- Tạo Database
CREATE DATABASE FLC_CRM;
GO

USE FLC_CRM;
GO

-- =========================
-- DANH MỤC CƠ BẢN
-- =========================
CREATE TABLE gender (
    gender_id INT PRIMARY KEY,
    gender_code VARCHAR(50) UNIQUE NOT NULL,
    gender_name VARCHAR(50) NOT NULL
);

CREATE TABLE account_type (
    account_type_id INT PRIMARY KEY,
    account_type_code VARCHAR(100) UNIQUE NOT NULL,
    account_type_name VARCHAR(255) NOT NULL
);

CREATE TABLE employee_level (
    employee_level_id INT PRIMARY KEY,
    employee_level_code VARCHAR(100) UNIQUE NOT NULL,
    employee_level_name VARCHAR(255) NOT NULL
);

CREATE TABLE customer_type (
    customer_type_id INT PRIMARY KEY,
    customer_type_code VARCHAR(100) UNIQUE NOT NULL,
    customer_type_name VARCHAR(255) NOT NULL
);

CREATE TABLE contact_salutation (
    contact_salutation_id INT PRIMARY KEY,
    contact_salutation_code VARCHAR(50) UNIQUE NOT NULL,
    contact_salutation_name VARCHAR(50) NOT NULL
);

CREATE TABLE lead_potential_level (
    lead_potential_level_id INT PRIMARY KEY,
    lead_potential_level_code VARCHAR(100) UNIQUE NOT NULL,
    lead_potential_level_name VARCHAR(255) NOT NULL
);

CREATE TABLE lead_source (
    lead_source_id INT PRIMARY KEY,
    lead_source_code VARCHAR(100) UNIQUE NOT NULL,
    lead_source_name VARCHAR(255) NOT NULL
);

CREATE TABLE lead_stage (
    lead_stage_id INT PRIMARY KEY,
    lead_stage_code VARCHAR(100) UNIQUE NOT NULL,
    lead_stage_name VARCHAR(255) NOT NULL
);

CREATE TABLE opportunity_stage (
    opportunity_stage_id INT PRIMARY KEY,
    opportunity_stage_code VARCHAR(100) UNIQUE NOT NULL,
    opportunity_stage_name VARCHAR(255) NOT NULL
);

CREATE TABLE contract_type (
    contract_type_id INT PRIMARY KEY,
    contract_type_code VARCHAR(100) UNIQUE NOT NULL,
    contract_type_name VARCHAR(255) NOT NULL
);

CREATE TABLE contract_stage (
    contract_stage_id INT PRIMARY KEY,
    contract_stage_code VARCHAR(100) UNIQUE NOT NULL,
    contract_stage_name VARCHAR(255) NOT NULL
);

CREATE TABLE payment_option (
    payment_option_id INT PRIMARY KEY,
    payment_option_code VARCHAR(50) UNIQUE NOT NULL,
    payment_option_name VARCHAR(100) NOT NULL
);

CREATE TABLE payment_method (
    payment_method_id INT PRIMARY KEY,
    payment_method_code VARCHAR(100) UNIQUE NOT NULL,
    payment_method_name VARCHAR(255) NOT NULL
);

CREATE TABLE product_type (
    product_type_id INT PRIMARY KEY,
    product_type_code VARCHAR(100),
    product_type_name VARCHAR(255)
);

CREATE TABLE product_status (
    product_status_id INT PRIMARY KEY,
    product_status_code VARCHAR(100),
    product_status_name VARCHAR(255)
);

-- =========================
-- BẢNG QUẢN LÝ NHÂN VIÊN
-- =========================
CREATE TABLE employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_code VARCHAR(20),
    employee_name NVARCHAR(150) NOT NULL,
    employee_birth_day DATE,
    employee_phone VARCHAR(50),
    employee_email VARCHAR(100),
	employee_address NVARCHAR(255),
	employee_description TEXT,
    gender_id INT,
    employee_level_id INT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_by VARCHAR(100),
    CONSTRAINT fk_employee_gender FOREIGN KEY (gender_id) REFERENCES gender(gender_id),
    CONSTRAINT fk_employee_level FOREIGN KEY (employee_level_id) REFERENCES employee_level(employee_level_id)
);

CREATE TRIGGER trg_generate_employee_code
ON employee
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE e
    SET e.employee_code = 'EMP' + RIGHT('0000' + CAST(e.employee_id AS VARCHAR(4)), 4)
    FROM employee e
    INNER JOIN inserted i ON e.employee_id = i.employee_id;
END;
-- done

CREATE TABLE account (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    account_code VARCHAR(20),
    account_name VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    account_type_id INT,
	account_description TEXT,
    employee_id INT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_account_type FOREIGN KEY (account_type_id) REFERENCES account_type(account_type_id),
    CONSTRAINT fk_account_employee FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

drop table account

CREATE TRIGGER trg_generate_account_code
ON account
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE a
    SET a.account_code = 'ACC' + RIGHT('0000' + CAST(a.account_id AS VARCHAR(4)), 4)
    FROM account a
    INNER JOIN inserted i ON a.account_id = i.account_id;
END;
-- done

-- =========================
-- BẢNG QUẢN LÝ SẢN PHẨM (DỰ ÁN VÀ BẤT ĐỘNG SẢN)
-- =========================
CREATE TABLE project (
    project_id INT IDENTITY(1,1) PRIMARY KEY,
    project_code VARCHAR(20),
    project_name NVARCHAR(255) NOT NULL,
    project_address NVARCHAR(255),
    project_start_date DATE,
    project_end_date DATE,
    project_status VARCHAR(50),
    project_description NVARCHAR(MAX),
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_by VARCHAR(100),
	days_remaining AS 
        CASE 
            WHEN project_end_date >= CAST(GETDATE() AS DATE) 
            THEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), project_end_date)
            ELSE 0 
        END
);

CREATE TRIGGER trg_generate_project_code
ON project
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE p
    SET p.project_code = 'PRJ' + RIGHT('0000' + CAST(p.project_id AS VARCHAR(4)), 4)
    FROM project p
    INNER JOIN inserted i ON p.project_id = i.project_id;
END;
-- done

-- Sản phẩm trong dự án (Căn hộ, lô đất, biệt thự...)
CREATE TABLE product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_code VARCHAR(100),
    product_name NVARCHAR(255) NOT NULL,
    product_address NVARCHAR(255),
    product_number INT CHECK (product_number >= 0),
    product_area DECIMAL(10,2) CHECK (product_area >= 0),
    product_price DECIMAL(18,2) CHECK (product_price >= 0),
    create_date DATETIME DEFAULT GETDATE(),
    create_by VARCHAR(100),
    product_type_id INT NOT NULL,
    project_id INT,
    product_status_id INT NOT NULL,
    CONSTRAINT fk_product_type FOREIGN KEY (product_type_id) REFERENCES product_type(product_type_id),
    CONSTRAINT fk_product_project FOREIGN KEY (project_id) REFERENCES project(project_id),
    CONSTRAINT fk_product_status FOREIGN KEY (product_status_id) REFERENCES product_status(product_status_id)
);

CREATE TRIGGER trg_generate_product_code
ON product
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE p
    SET p.product_code = 'PRD' + RIGHT('0000' + CAST(p.product_id AS VARCHAR(4)), 4)
    FROM product p
    INNER JOIN inserted i ON p.product_id = i.product_id;
END;
-- done

-- =========================
-- BẢNG QUẢN LÝ KHÁCH HÀNG
-- =========================
CREATE TABLE customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_code VARCHAR(20),
    customer_name NVARCHAR(255) NOT NULL,
    customer_phone VARCHAR(50),
    customer_email VARCHAR(100),
    customer_address NVARCHAR(255),
    customer_birth_day DATE,
	customer_description TEXT,
    gender_id INT,
    employee_id INT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_by VARCHAR(100),
    CONSTRAINT fk_customer_gender FOREIGN KEY (gender_id) REFERENCES gender(gender_id),
    CONSTRAINT fk_customer_employee FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TRIGGER trg_generate_customer_code
ON customer
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE c
    SET c.customer_code = 'KH' + RIGHT('0000' + CAST(c.customer_id AS VARCHAR(4)), 4)
    FROM customer c
    INNER JOIN inserted i ON c.customer_id = i.customer_id;
END;
-- done

-- Người liên hệ thuộc khách hàng
CREATE TABLE contact (
    contact_id INT IDENTITY(1,1) PRIMARY KEY,
    contact_name NVARCHAR(255) NOT NULL,
    contact_phone VARCHAR(50),
    contact_email VARCHAR(100),
	contact_address VARCHAR(255),
    contact_salutation_id INT,
	contact_description TEXT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_by VARCHAR(100),
    CONSTRAINT fk_contact_salutation FOREIGN KEY (contact_salutation_id) REFERENCES contact_salutation(contact_salutation_id),
);

CREATE TABLE customer_contact (
    customer_contact_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    contact_id INT NOT NULL,
    role NVARCHAR(100), -- Vai trò (giám đốc, khách hàng, kế toán, ...)
    start_date DATE,
    end_date DATE,
    notes NVARCHAR(255),
    CONSTRAINT fk_customer_contact_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_customer_contact_contact FOREIGN KEY (contact_id) REFERENCES contact(contact_id)
);
-- done

-- =========================
-- BẢNG QUẢN LÝ KHÁCH HÀNG TIỀM NĂNG VÀ CƠ HỘI BÁN HÀNG
-- =========================
CREATE TABLE lead (
    lead_id INT IDENTITY(1,1) PRIMARY KEY,
    lead_code VARCHAR(20),
    lead_name NVARCHAR(255) NOT NULL,
    lead_phone VARCHAR(50),
    lead_email VARCHAR(100),
    lead_address NVARCHAR(255),
    lead_source_id INT,
    lead_potential_level_id INT,
    lead_stage_id INT,
    lead_description NVARCHAR(MAX),
    employee_id INT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_by VARCHAR(100),
    daypassed AS DATEDIFF(DAY, create_date, GETDATE()),
    CONSTRAINT fk_lead_source FOREIGN KEY (lead_source_id) REFERENCES lead_source(lead_source_id),
    CONSTRAINT fk_lead_potential FOREIGN KEY (lead_potential_level_id) REFERENCES lead_potential_level(lead_potential_level_id),
    CONSTRAINT fk_lead_stage FOREIGN KEY (lead_stage_id) REFERENCES lead_stage(lead_stage_id),
    CONSTRAINT fk_lead_employee FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TRIGGER trg_generate_lead_code
ON lead
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE l
    SET l.lead_code = 'LEAD' + RIGHT('0000' + CAST(l.lead_id AS VARCHAR(4)), 4)
    FROM lead l
    INNER JOIN inserted i ON l.lead_id = i.lead_id;
END;

CREATE TABLE lead_item (
    lead_product_id INT IDENTITY(1,1) PRIMARY KEY,
    lead_id INT,
    product_id INT,
    CONSTRAINT fk_leaditem_lead FOREIGN KEY (lead_id) REFERENCES lead(lead_id) ON DELETE CASCADE,
    CONSTRAINT fk_leaditem_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);
-- done

CREATE TABLE opportunity (
    opportunity_id INT IDENTITY(1,1) PRIMARY KEY,
    opportunity_code VARCHAR(100),
    opportunity_name NVARCHAR(255) NOT NULL,
    opportunity_description NVARCHAR(MAX),
    end_date DATE NOT NULL,
    create_date DATETIME DEFAULT GETDATE(),
    create_by VARCHAR(100),
    days_remaining AS DATEDIFF(DAY, GETDATE(), end_date),
    customer_id INT NOT NULL,
    opportunity_stage_id INT NOT NULL,
    employee_id INT NOT NULL,
    CONSTRAINT fk_opp_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_opp_stage FOREIGN KEY (opportunity_stage_id) REFERENCES opportunity_stage(opportunity_stage_id),
    CONSTRAINT fk_opp_employee FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TRIGGER trg_generate_oop_code
ON opportunity
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE o
    SET o.opportunity_code = 'OOP' + RIGHT('0000' + CAST(o.opportunity_id AS VARCHAR(4)), 4)
    FROM opportunity o
    INNER JOIN inserted i ON o.opportunity_id = i.opportunity_id;
END;

CREATE TABLE opportunity_item (
    opportunity_item_id INT IDENTITY(1,1) PRIMARY KEY,
    opportunity_id INT,
    product_id INT,
    quantity INT,
    sale_price DECIMAL(18,2),
    excepted_profit DECIMAL(18,2),
    CONSTRAINT fk_oppitem_op FOREIGN KEY (opportunity_id) REFERENCES opportunity(opportunity_id) ON DELETE CASCADE,
    CONSTRAINT fk_oppitem_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);
-- done

-- =========================
-- BẢNG QUẢN LÝ HỢP ĐỒNG VÀ THANH TOÁN
-- =========================
CREATE TABLE contract (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    contract_code VARCHAR(100),
    contract_name NVARCHAR(255) NOT NULL,
    contract_description NVARCHAR(MAX),
    contract_start_date DATE NOT NULL,
    contract_end_date DATE NOT NULL,
    create_date DATETIME DEFAULT GETDATE(),
    create_by VARCHAR(100),
    days_remaining AS DATEDIFF(DAY, GETDATE(), contract_end_date),
    customer_id INT NOT NULL,
    contract_type_id INT NOT NULL,
    contract_stage_id INT NOT NULL,
    employee_id INT NOT NULL,
    CONSTRAINT fk_contract_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_contract_type FOREIGN KEY (contract_type_id) REFERENCES contract_type(contract_type_id),
    CONSTRAINT fk_contract_stage FOREIGN KEY (contract_stage_id) REFERENCES contract_stage(contract_stage_id),
    CONSTRAINT fk_contract_employee FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TRIGGER trg_generate_contract_code
ON contract
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE c
    SET c.contract_code = 'CTR' + RIGHT('0000' + CAST(c.contract_id AS VARCHAR(4)), 4)
    FROM contract c
    INNER JOIN inserted i ON c.contract_id = i.contract_id;
END;

CREATE TABLE contract_item (
    contract_item_id INT PRIMARY KEY,
    contract_id INT,
    product_id INT,
    quantity INT,
    sale_price DECIMAL(18,2),
    cost_tax DECIMAL(18,2),
    grand_total DECIMAL(18,2),
    CONSTRAINT fk_citem_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id) ON DELETE CASCADE,
    CONSTRAINT fk_citem_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Tiền đặt cọc
CREATE TABLE deposit (
    deposit_id INT IDENTITY(1,1) PRIMARY KEY,
    deposit_code VARCHAR(100),
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_by VARCHAR(100),
    customer_id INT,
    product_id INT,
    deposit_cost DECIMAL(18,2),
    description TEXT,
    CONSTRAINT fk_deposit_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_deposit_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TRIGGER trg_generate_deposit_code
ON deposit
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE d
    SET d.deposit_code = 'DEP' + RIGHT('0000' + CAST(d.deposit_id AS VARCHAR(4)), 4)
    FROM deposit d
    INNER JOIN inserted i ON d.deposit_id = d.deposit_id;
END;
-- done

-- Thanh toán của hợp đồng (có thể chia thành nhiều đợt)
CREATE TABLE invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_code VARCHAR(50),
    contract_id INT NOT NULL,
    due_date DATE,
    total_amount DECIMAL(18,2) NOT NULL,
    payment_option_id INT, 
    status NVARCHAR(50) DEFAULT 'Pending',                   -- Pending / Paid / Overdue
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_by VARCHAR(100),
    CONSTRAINT fk_invoice_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id),
    CONSTRAINT fk_invoice_payment_option FOREIGN KEY (payment_option_id) REFERENCES payment_option(payment_option_id)
);

CREATE TRIGGER trg_generate_invoice_code
ON invoice
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE v
    SET v.invoice_code = 'INV' + RIGHT('0000' + CAST(v.invoice_id AS VARCHAR(4)), 4)
    FROM invoice v
    INNER JOIN inserted i ON v.invoice_id = v.invoice_id;
END;

CREATE TABLE payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_code VARCHAR(50),
    invoice_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    amount DECIMAL(18,2) NOT NULL,         -- Số tiền thanh toán
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    description NVARCHAR(255),
    create_by VARCHAR(100),
    CONSTRAINT fk_payment_invoice FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    CONSTRAINT fk_payment_method FOREIGN KEY (payment_method_id) REFERENCES payment_method(payment_method_id)
);

CREATE TRIGGER trg_payment_insert
ON payment
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET p.payment_code = 'PAY' + RIGHT('0000' + CAST(p.payment_id AS VARCHAR(4)), 4)
    FROM payment p
    INNER JOIN inserted i ON p.payment_id = i.payment_id;
END;
GO

CREATE TABLE installment_schedule (
    installment_id INT IDENTITY(1,1) PRIMARY KEY,
    contract_id INT NOT NULL,
    installment_no INT,                    -- Đợt số mấy
    due_date DATE,                         -- Ngày đến hạn
    amount DECIMAL(18,2) NOT NULL,         -- Số tiền phải trả
    status NVARCHAR(50) DEFAULT 'Pending', -- Pending / Paid / Overdue
    CONSTRAINT fk_installment_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id)
);
-- need check again