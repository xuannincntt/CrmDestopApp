USE FLC_CRM;
GO

-- =========================
-- Dữ liệu mẫu
-- =========================
INSERT INTO Employees (FullName, Phone, Email, Position)
VALUES 
(N'Nguyễn Văn A', '0901234567', 'a@flc.com', N'Kinh doanh'),
(N'Trần Thị B', '0912345678', 'b@flc.com', N'Tư vấn');

INSERT INTO Leads (LeadName, Company, Phone, Email, EmployeeID, Address, Source, Notes, Status)
VALUES
(N'Lê Hồng Minh', N'Công ty ABC', '0987654321', 'minh@abc.com', 1, N'Hà Nội', N'Hội thảo', N'Khách quan tâm đến sản phẩm A', N'Chưa liên hệ');

INSERT INTO Customers (CustomerName, BirthDate, Phone, Email, Gender, BusinessField, Address, EmployeeID, Notes)
VALUES
(N'Phạm Thu Trang', '1990-05-10', '0978123456', 'trang@gmail.com', N'Nữ', N'Bất động sản', N'Hồ Chí Minh', 2, N'Khách hàng VIP');

INSERT INTO CustomerContacts (CustomerID, Relation, Notes)
VALUES
(1, N'Chồng', N'Người đi cùng khi ký hợp đồng');
