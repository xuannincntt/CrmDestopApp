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

-- id tự tăng, ngày tạo mặc định, người tạo mặc định
-- =========================
-- BẢNG QUẢN LÝ NHÂN VIÊN
-- =========================
CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_code VARCHAR(100),
	employee_name NVARCHAR(150),
    employee_birth_day DATE,
    employee_phone VARCHAR(50),
    employee_email VARCHAR(100),
    gender_id INT,
    employee_level_id INT,
    create_date TIMESTAMP,
    create_by VARCHAR(100),
    CONSTRAINT fk_employee_gender FOREIGN KEY (gender_id) REFERENCES gender(gender_id),
    CONSTRAINT fk_employee_level FOREIGN KEY (employee_level_id) REFERENCES employee_level(employee_level_id)
);

CREATE TABLE account (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    employee_id INT,
    account_type_id INT,
    owner_employee_id INT,
    create_date TIMESTAMP,
    CONSTRAINT fk_account_type FOREIGN KEY (account_type_id) REFERENCES account_type(account_type_id),
    CONSTRAINT fk_account_owner FOREIGN KEY (owner_employee_id) REFERENCES employee(employee_id)
);


-- =========================
-- BẢNG QUẢN LÝ KHÁCH HÀNG
-- =========================
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_code VARCHAR(100) UNIQUE NOT NULL,
    customer_name NVARCHAR(255) NOT NULL,
    customer_phone VARCHAR(50),
    customer_email VARCHAR(100),
    customer_address NVARCHAR(255),
    customer_birth_day DATE,
    gender_id INT,
    owner_employee_id INT,
    create_date TIMESTAMP,
    create_by VARCHAR(100),
    CONSTRAINT fk_account_gender FOREIGN KEY (gender_id) REFERENCES gender(gender_id),
    CONSTRAINT fk_account_owner FOREIGN KEY (owner_employee_id) REFERENCES employee(employee_id)
);

-- Người liên hệ thuộc khách hàng
CREATE TABLE contact (
    contact_id INT PRIMARY KEY,
    contact_name NVARCHAR(255) NOT NULL,
    contact_phone VARCHAR(50),
    contact_email VARCHAR(100),
    contact_salutation_id INT,
    account_id INT,
    create_date TIMESTAMP,
    create_by VARCHAR(100),
    CONSTRAINT fk_contact_salutation FOREIGN KEY (contact_salutation_id) REFERENCES contact_salutation(contact_salutation_id),
    CONSTRAINT fk_contact_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- =========================
-- BẢNG QUẢN LÝ KHÁCH HÀNG TIỀM NĂNG VÀ CƠ HỘI BÁN HÀNG
-- =========================
CREATE TABLE lead (
    lead_id INT PRIMARY KEY,
    lead_name NVARCHAR(255) NOT NULL,
    lead_phone VARCHAR(50),
    lead_email VARCHAR(100),
    lead_source_id INT,
    lead_potential_level_id INT,
    lead_stage_id INT,
    assigned_employee_id INT,
    create_date TIMESTAMP,
    create_by VARCHAR(100),
	daypassed as DATEDIFF(DAY, create_date, GETDATE()),
    CONSTRAINT fk_lead_source FOREIGN KEY (lead_source_id) REFERENCES lead_source(lead_source_id),
    CONSTRAINT fk_lead_potential FOREIGN KEY (lead_potential_level_id) REFERENCES lead_potential_level(lead_potential_level_id),
    CONSTRAINT fk_lead_stage FOREIGN KEY (lead_stage_id) REFERENCES lead_stage(lead_stage_id),
    CONSTRAINT fk_lead_employee FOREIGN KEY (assigned_employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE opportunity (
    opportunity_id INT PRIMARY KEY,
    opportunity_name NVARCHAR(255) NOT NULL,
    account_id INT,
    value DECIMAL(18,2), -- Giá trị cơ hội
    close_date DATE,
    opportunity_stage_id INT,
    owner_employee_id INT,
    create_date TIMESTAMP,
    create_by VARCHAR(100),
    CONSTRAINT fk_opp_account FOREIGN KEY (account_id) REFERENCES account(account_id),
    CONSTRAINT fk_opp_stage FOREIGN KEY (opportunity_stage_id) REFERENCES opportunity_stage(opportunity_stage_id),
    CONSTRAINT fk_opp_owner FOREIGN KEY (owner_employee_id) REFERENCES employee(employee_id)
);

-- =========================
-- BẢNG QUẢN LÝ HỢP ĐỒNG VÀ THANH TOÁN
-- =========================
CREATE TABLE contract (
    contract_id INT PRIMARY KEY,
    contract_code VARCHAR(100) UNIQUE NOT NULL,
    account_id INT,
    product_id INT,
    contract_type_id INT,
    contract_stage_id INT,
    contract_value DECIMAL(18,2),
    sign_date DATE,
    owner_employee_id INT,
    create_date TIMESTAMP,
    create_by VARCHAR(100),
    CONSTRAINT fk_contract_account FOREIGN KEY (account_id) REFERENCES account(account_id),
    CONSTRAINT fk_contract_product FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT fk_contract_type FOREIGN KEY (contract_type_id) REFERENCES contract_type(contract_type_id),
    CONSTRAINT fk_contract_stage FOREIGN KEY (contract_stage_id) REFERENCES contract_stage(contract_stage_id),
    CONSTRAINT fk_contract_owner FOREIGN KEY (owner_employee_id) REFERENCES employee(employee_id)
);

-- Thanh toán của hợp đồng (có thể chia thành nhiều đợt)
CREATE TABLE contract_payment (
    payment_id INT PRIMARY KEY,
    contract_id INT,
    payment_due_date DATE,
    payment_amount DECIMAL(18,2),
    payment_method_id INT,
    payment_status NVARCHAR(50),
    create_date TIMESTAMP,
    CONSTRAINT fk_payment_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id),
    CONSTRAINT fk_payment_method FOREIGN KEY (payment_method_id) REFERENCES payment_method(payment_method_id)
);

-- =========================
-- BẢNG QUẢN LÝ SẢN PHẨM (DỰ ÁN VÀ BẤT ĐỘNG SẢN)
-- =========================
CREATE TABLE project (
    project_id INT PRIMARY KEY,
    project_code VARCHAR(100) UNIQUE NOT NULL,
    project_name NVARCHAR(255) NOT NULL,
    project_location NVARCHAR(255),
	project_start_date DATE,
    project_end_date DATE,
    project_status VARCHAR(50),
    project_description TEXT,
    create_date TIMESTAMP,
    create_by VARCHAR(100)
);

-- Sản phẩm trong dự án (Căn hộ, lô đất, biệt thự...)
CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_code VARCHAR(100) UNIQUE NOT NULL,
    product_name NVARCHAR(255) NOT NULL,
	create_date TIMESTAMP,
    create_by VARCHAR(100)
    product_type_id INT,
    project_id INT,
	product_number INT,
    product_area DECIMAL(10,2),
    product_price DECIMAL(18,2),
    product_status NVARCHAR(50),    -- Trạng thái (Chưa bán, Đã giữ chỗ, Đã bán)
    CONSTRAINT fk_product_type FOREIGN KEY (product_type_id) REFERENCES product_type(product_type_id),
    CONSTRAINT fk_product_project FOREIGN KEY (project_id) REFERENCES project(project_id)
);