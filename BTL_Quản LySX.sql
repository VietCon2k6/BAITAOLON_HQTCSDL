USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'QLSanXuat')
BEGIN
    ALTER DATABASE QLSanXuat SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QLSanXuat;
END
GO
-- TẠO DATABASE MỚI
CREATE DATABASE QLSanXuat;
GO

-- SỬ DỤNG DATABASE MỚI
USE QLSanXuat;
GO

-- 2. TẠO CÁC BẢNG (DDL) (Giữ nguyên như mã gốc)
-- Bảng Nhà cung cấp
CREATE TABLE NhaCungCap (
    MaNCC CHAR(5) PRIMARY KEY,
    TenNCC NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255),
    SDT VARCHAR(15) CHECK (SDT LIKE '[0-9]%')
);
GO
-- Bảng Nguyên liệu
CREATE TABLE NguyenLieu (
    MaNL CHAR(5) PRIMARY KEY,
    TenNL NVARCHAR(100) NOT NULL,
    DonVi NVARCHAR(50) NOT NULL DEFAULT N'Cái',
    GiaNhap DECIMAL(18, 2) NOT NULL DEFAULT 0 CHECK (GiaNhap >= 0),
    MaNCC CHAR(5) FOREIGN KEY REFERENCES NhaCungCap(MaNCC) NOT NULL
);
GO
-- Bảng Sản phẩm
CREATE TABLE SanPham (
    MaSP CHAR(5) PRIMARY KEY,
    TenSP NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255),
    DonGia DECIMAL(18, 2) NOT NULL DEFAULT 0 CHECK (DonGia >= 0),
    SoLuongTon INT NOT NULL DEFAULT 0 CHECK (SoLuongTon >= 0)
);
GO
-- Bảng Nhà máy
CREATE TABLE NhaMay (
    MaNM CHAR(5) PRIMARY KEY,
    TenNM NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255)
);
GO
-- Bảng Lệnh sản xuất
CREATE TABLE LenhSanXuat (
    MaLenh CHAR(5) PRIMARY KEY,
    MaSP CHAR(5) FOREIGN KEY REFERENCES SanPham(MaSP) NOT NULL,
    MaNM CHAR(5) FOREIGN KEY REFERENCES NhaMay(MaNM) NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    NgayBatDau DATE NOT NULL DEFAULT GETDATE()
);
GO
-- Bảng Chi tiết sản phẩm
CREATE TABLE ChiTietSanPham (
    MaSP CHAR(5) NOT NULL,
    MaNL CHAR(5) NOT NULL,
    SoLuongSuDung DECIMAL(10,2) NOT NULL CHECK (SoLuongSuDung > 0),
    PRIMARY KEY (MaSP, MaNL),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
    FOREIGN KEY (MaNL) REFERENCES NguyenLieu(MaNL)
);
GO

-- 3. THÊM DỮ LIỆU MẪU (DML) (Giữ nguyên như mã gốc)
INSERT INTO NhaMay VALUES
('NM001', N'Nhà máy Hà Nội', N'KCN Thăng Long, Hà Nội'),
('NM002', N'Nhà máy Đà Nẵng', N'KCN Hòa Khánh, Đà Nẵng'),
('NM003', N'Nhà máy Hồ Chí Minh', N'KCN Tân Tạo, TP.HCM'),
('NM004', N'Nhà máy Hải Phòng', N'KCN Tràng Duệ, Hải Phòng'),
('NM005', N'Nhà máy Cần Thơ', N'KCN Trà Nóc, Cần Thơ');
GO
INSERT INTO NhaCungCap VALUES
('NCC01', N'Công ty Linh kiện Việt', N'Hà Nội', '0905123456'),
('NCC02', N'Công ty Phụ kiện Tech', N'Hồ Chí Minh', '0912345678'),
('NCC03', N'Tập đoàn Điện tử Á Âu', N'Đà Nẵng', '0987654321'),
('NCC04', N'Công ty Nhựa & Vỏ Bọc', N'Bình Dương', '0901234567'),
('NCC05', N'Công ty Chip và Mạch', N'Hà Nội', '0978901234');
GO
INSERT INTO NguyenLieu VALUES
('NL001', N'Màn hình', N'Cái', 2000000, 'NCC01'),
('NL002', N'CPU', N'Cái', 5000000, 'NCC02'),
('NL003', N'RAM 16GB', N'Thanh', 1500000, 'NCC01'),
('NL004', N'Ổ cứng SSD 512GB', N'Cái', 1800000, 'NCC02'),
('NL005', N'Pin lithium', N'Cục', 900000, 'NCC01');
GO
INSERT INTO SanPham VALUES
('SP001', N'Laptop A', N'Laptop văn phòng', 15000000, 120),
('SP002', N'Laptop B', N'Laptop gaming', 25000000, 50),
('SP003', N'Máy tính bảng C', N'Máy tính bảng 10 inch', 8000000, 80),
('SP004', N'PC để bàn D', N'Máy tính đồng bộ cơ bản', 12000000, 65),
('SP005', N'Monitor E', N'Màn hình 27 inch 144Hz', 5000000, 90);
GO
INSERT INTO LenhSanXuat (MaLenh, MaSP, MaNM, SoLuong, NgayBatDau) VALUES
('LX001', 'SP001', 'NM001', 30, '2025-11-01'),
('LX002', 'SP002', 'NM002', 20, '2025-11-05'),
('LX003', 'SP003', 'NM001', 40, '2025-11-10'),
('LX004', 'SP004', 'NM003', 25, '2025-11-15'),
('LX005', 'SP005', 'NM004', 50, '2025-11-18');
GO
INSERT INTO ChiTietSanPham VALUES
-- Chi tiết cho SP001 (Laptop A)
('SP001', 'NL001', 1), ('SP001', 'NL002', 1), ('SP001', 'NL003', 2), ('SP001', 'NL004', 1), ('SP001', 'NL005', 1),
-- Chi tiết cho SP002 (Laptop B)
('SP002', 'NL001', 1), ('SP002', 'NL002', 1), ('SP002', 'NL003', 2), ('SP002', 'NL004', 1), ('SP002', 'NL005', 1),
-- Chi tiết cho SP003 (Máy tính bảng C)
('SP003', 'NL001', 1), ('SP003', 'NL002', 1), ('SP003', 'NL003', 1), ('SP003', 'NL005', 1),
-- Chi tiết cho SP004 (PC để bàn D)
('SP004', 'NL002', 1), ('SP004', 'NL003', 4), ('SP004', 'NL004', 1),
-- Chi tiết cho SP005 (Monitor E)
('SP005', 'NL001', 1), ('SP005', 'NL005', 1);
GO

-- 4. CÀI ĐẶT CHỈ MỤC (INDEXES)
-- Tăng tốc độ tìm kiếm theo ngày bắt đầu
CREATE INDEX IX_LenhSX_NgayBatDau ON LenhSanXuat (NgayBatDau DESC);
GO

-- 5. VIEWS
-- Tên view: VW_BaoCaoChiPhiNguyenLieu (Tổng giá thành nguyên liệu cần cho mỗi lệnh)
CREATE VIEW VW_BaoCaoChiPhiNguyenLieu
AS
SELECT 
    LX.MaLenh,
    SP.TenSP,
    LX.SoLuong AS SoLuongSanXuat,
    SUM(CT.SoLuongSuDung * NL.GiaNhap * LX.SoLuong) AS TongChiPhiNguyenLieu
FROM 
    LenhSanXuat LX
JOIN 
    ChiTietSanPham CT ON LX.MaSP = CT.MaSP
JOIN 
    NguyenLieu NL ON CT.MaNL = NL.MaNL
JOIN 
    SanPham SP ON SP.MaSP = LX.MaSP
GROUP BY 
    LX.MaLenh, SP.TenSP, LX.SoLuong;
GO

-- 6. THỦ TỤC (STORED PROCEDURES)
-- Tên thủ tục: SP_TaoLenhSXMoi (Thêm lệnh sản xuất mới, tự động tính MaLenh)
CREATE PROCEDURE SP_TaoLenhSXMoi
    @MaSP CHAR(5),
    @MaNM CHAR(5),
    @SoLuong INT,
    @NgayBatDau DATE
AS
BEGIN
    -- Kiểm tra điều kiện tồn tại
    IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        RAISERROR(N'Lỗi: Mã Sản phẩm không tồn tại.', 16, 1);
        RETURN;
    END

    -- Tự động tạo MaLenh mới (LX001, LX002, ...)
    DECLARE @NewMaLenh CHAR(5);
    SELECT @NewMaLenh = 'LX' + RIGHT('000' + CAST(ISNULL(MAX(CAST(SUBSTRING(MaLenh, 3, 3) AS INT)), 0) + 1 AS VARCHAR(3)), 3)
    FROM LenhSanXuat;

    INSERT INTO LenhSanXuat (MaLenh, MaSP, MaNM, SoLuong, NgayBatDau)
    VALUES (@NewMaLenh, @MaSP, @MaNM, @SoLuong, @NgayBatDau);

    SELECT N'Tạo lệnh sản xuất thành công. Mã lệnh: ' + @NewMaLenh AS ThongBao;
END
GO

-- 7. HÀM NGƯỜI DÙNG ĐỊNH NGHĨA (USER DEFINED FUNCTIONS)
-- Tên hàm: FN_TinhGiaThanhSP (Tính tổng giá thành nguyên liệu cho 1 sản phẩm)
CREATE FUNCTION FN_TinhGiaThanhSP (@MaSP CHAR(5))
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @GiaThanh DECIMAL(18, 2);

    SELECT 
        @GiaThanh = SUM(CT.SoLuongSuDung * NL.GiaNhap)
    FROM 
        ChiTietSanPham CT
    JOIN 
        NguyenLieu NL ON CT.MaNL = NL.MaNL
    WHERE 
        CT.MaSP = @MaSP;

    RETURN ISNULL(@GiaThanh, 0);
END
GO

-- 8. TRIGGER
-- Tên trigger: TR_CapNhatTonKhoSauLenhSX (Tự động cộng số lượng tồn kho sau khi thêm lệnh)
CREATE TRIGGER TR_CapNhatTonKhoSauLenhSX
ON LenhSanXuat
AFTER INSERT
AS
BEGIN
    -- Cộng số lượng sản xuất vào cột SoLuongTon của SanPham
    UPDATE SP
    SET SoLuongTon = SP.SoLuongTon + I.SoLuong
    FROM 
        SanPham SP
    JOIN 
        inserted I ON SP.MaSP = I.MaSP;
END
GO


-- Xem kết quả View
SELECT TOP 5 * FROM VW_BaoCaoChiPhiNguyenLieu;

-- Gọi Function
SELECT 
    SP.TenSP, 
    dbo.FN_TinhGiaThanhSP(SP.MaSP) AS GiaThanhNguyenLieu_MotSP
FROM SanPham SP
WHERE SP.MaSP = 'SP002';

-- Gọi Procedure (sẽ kích hoạt Trigger)
-- Trước khi gọi: SoLuongTon của SP001 là 120
SELECT SoLuongTon AS TonKhoTruocKhiSX FROM SanPham WHERE MaSP = 'SP001';
EXEC SP_TaoLenhSXMoi 'SP001', 'NM005', 10, '2025-12-01'; -- Tạo lệnh LX006, số lượng 10
-- Sau khi gọi: SoLuongTon của SP001 là 120 + 10 = 130 (Kết quả của Trigger)
SELECT SoLuongTon AS TonKhoSauKhiSX FROM SanPham WHERE MaSP = 'SP001';

-- =======================================================================
-- BẢO MẬT VÀ QUẢN TRỊ (MÃ THAY THẾ ĐÃ HỢP NHẤT VÀ SỬA LỖI)
-- =======================================================================

-- 0. XỬ LÝ LỖI TRÙNG LẶP (DROP CÁC ĐỐI TƯỢNG CŨ THEO THỨ TỰ)

-- 0.1. DỌN DẸP SCHEMA (Phải đưa bảng về dbo trước khi xóa Schema/User/Role)
-- Đưa bảng NhaCungCap về lại Schema gốc (dbo) nếu nó đang ở NCC_Private
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'NhaCungCap' AND SCHEMA_NAME(schema_id) = 'NCC_Private')
BEGIN
    ALTER SCHEMA dbo TRANSFER NCC_Private.NhaCungCap;
END
GO

-- Xóa Schema cũ
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'NCC_Private')
BEGIN
    DROP SCHEMA NCC_Private;
END
GO

-- 0.2. DỌN DẸP PRINCIPALS (Phải xóa thành viên, rồi xóa User, rồi xóa Login)
-- Xóa thành viên khỏi Role (nếu cần)
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_BaoCao') AND IS_ROLEMEMBER('Role_ChiDoc', 'User_BaoCao') = 1
BEGIN
    EXEC sp_droprolemember 'Role_ChiDoc', 'User_BaoCao';
END
GO

-- Xóa User
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_BaoCao')
BEGIN
    DROP USER User_BaoCao;
END
GO

-- Xóa Role
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Role_ChiDoc')
BEGIN
    DROP ROLE Role_ChiDoc;
END
GO

-- Xóa Login
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'ReadUserLogin')
BEGIN
    DROP LOGIN ReadUserLogin;
END
GO


-- ===================================
-- TẠO MỚI CÁC ĐỐI TƯỢNG (QUY TRÌNH)
-- ===================================

-- 1. TẠO LOGIN MỚI (Cấp Server)
CREATE LOGIN ReadUserLogin WITH PASSWORD = 'StrongPassword123!', CHECK_POLICY = ON;
GO

-- 2. TẠO USER MỚI (Cấp Database)
CREATE USER User_BaoCao FOR LOGIN ReadUserLogin;
GO

-- 3. TẠO ROLE VÀ PHÂN QUYỀN
CREATE ROLE Role_ChiDoc;
GO

-- Gán quyền SELECT (chỉ đọc) trên toàn bộ database schema dbo
GRANT SELECT ON SCHEMA::dbo TO Role_ChiDoc;
GO

-- Gán User vào Role
EXEC sp_addrolemember 'Role_ChiDoc', 'User_BaoCao';
GO

-- 4. BẢO MẬT DỮ LIỆU NHẠY CẢM (Sử dụng Schema)

-- Tạo Schema để cô lập bảng nhạy cảm
CREATE SCHEMA NCC_Private;
GO

-- Chuyển bảng NhaCungCap vào Schema mới
ALTER SCHEMA NCC_Private TRANSFER dbo.NhaCungCap;
GO

-- Ngăn chặn quyền SELECT trên bảng Nhà Cung Cấp cho Role chỉ đọc
DENY SELECT ON NCC_Private.NhaCungCap TO Role_ChiDoc;
GO