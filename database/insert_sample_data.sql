USE FLC_CRM;
GO

-- =========================
-- DANH MỤC CƠ BẢN
-- =========================

INSERT INTO gender (gender_id, gender_code, gender_name) VALUES
(1, 'M', 'Nam'),
(2, 'F', 'Nữ'),
(3, 'O', 'Khác');

INSERT INTO account_type (account_type_id, account_type_code, account_type_name) VALUES
(1, 'ADMIN', 'Quản trị viên'),
(2, 'STAFF', 'Nhân viên')

INSERT INTO employee_level (employee_level_id, employee_level_code, employee_level_name) VALUES
(1, 'STAFF', 'Nhân viên'),
(2, 'LEADER', 'Trưởng nhóm'),
(3, 'MANAGER', 'Quản lý'),
(4, 'DIRECTOR', 'Giám đốc');

INSERT INTO customer_type (customer_type_id, customer_type_code, customer_type_name) VALUES
(1, 'BUYER', 'Khách hàng mua'),
(2, 'TENANT', 'Khách thuê'),
(3, 'INVESTOR', 'Nhà đầu tư'),
(4, 'AGENCY', 'Đại lý môi giới'),
(5, 'PARTNER', 'Đối tác chiến lược'),
(6, 'SUPPLIER', 'Nhà cung cấp');

INSERT INTO contact_salutation (contact_salutation_id, contact_salutation_code, contact_salutation_name) VALUES
(1, 'MR',  'Ông'),
(2, 'MRS', 'Bà'),
(3, 'MS',  'Cô'),
(4, 'BRO', 'Anh'),
(5, 'SIS', 'Chị')

INSERT INTO lead_potential_level (lead_potential_level_id, lead_potential_level_code, lead_potential_level_name) VALUES
(1, 'LOW', 'Thấp'),
(2, 'MEDIUM', 'Trung bình'),
(3, 'HIGH', 'Cao'),
(4, 'VERY_HIGH', 'Rất cao');

INSERT INTO lead_source (lead_source_id, lead_source_code, lead_source_name) VALUES
(1, 'WEB', 'Website'),
(2, 'EMAIL', 'Email Marketing'),
(3, 'SOCIAL', 'Mạng xã hội'),
(4, 'EVENT', 'Sự kiện / Hội thảo'),
(5, 'REFERRAL', 'Giới thiệu'),
(6, 'SALES', 'Trực tiếp từ Sales');

INSERT INTO lead_stage (lead_stage_id, lead_stage_code, lead_stage_name) VALUES
(1, 'NEW', 'Mới'),
(2, 'CONTACTED', 'Đã liên hệ'),
(3, 'QUALIFIED', 'Đã chuyển đổi'),
(4, 'DISQUALIFIED', 'Loại bỏ');

INSERT INTO opportunity_stage (opportunity_stage_id, opportunity_stage_code, opportunity_stage_name) VALUES
(1, 'PROSPECTING', 'Khảo sát nhu cầu'),
(2, 'NEGOTIATION', 'Đàm phán'),
(3, 'CLOSING', 'Chốt hợp đồng'),
(4, 'WON', 'Thành công'),
(5, 'LOST', 'Thất bại');

INSERT INTO contract_type (contract_type_id, contract_type_code, contract_type_name) VALUES
(1, 'SALES', 'Hợp đồng bán hàng'),
(2, 'SERVICE', 'Hợp đồng dịch vụ'),
(3, 'RENTAL', 'Hợp đồng cho thuê'),
(4, 'MAINTENANCE', 'Hợp đồng bảo trì');

INSERT INTO contract_stage (contract_stage_id, contract_stage_code, contract_stage_name) VALUES
(1, 'DRAFT', 'Bản nháp'),
(2, 'NEGOTIATION', 'Đàm phán'),
(3, 'SIGNED', 'Đã ký'),
(4, 'ACTIVE', 'Đang hiệu lực'),
(5, 'COMPLETED', 'Hoàn thành'),
(6, 'CANCELLED', 'Hủy bỏ');

INSERT INTO payment_option (payment_option_id, payment_option_code, payment_option_name) VALUES
(1, 'ONETIME', 'Thanh toán một lần'),
(2, 'INSTALLMENT', 'Thanh toán theo từng đợt');

INSERT INTO payment_method (payment_method_id, payment_method_code, payment_method_name) VALUES
(1, 'CASH', 'Tiền mặt'),
(2, 'BANK_TRANSFER', 'Chuyển khoản ngân hàng'),
(3, 'CREDIT_CARD', 'Thẻ tín dụng'),
(4, 'E_WALLET', 'Ví điện tử');

INSERT INTO product_type (product_type_id, product_type_code, product_type_name) VALUES
(1, 'APARTMENT', 'Căn hộ chung cư'),
(2, 'HOUSE', 'Nhà phố / Biệt thự'),
(3, 'LAND', 'Đất nền'),
(4, 'OFFICE', 'Văn phòng cho thuê'),
(5, 'SHOPHOUSE', 'Shophouse / Nhà phố thương mại');

-- =========================
-- BẢNG NHÂN VIÊN
-- =========================

