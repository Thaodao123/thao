CREATE DATABASE QL_ThietBiYTe
USE QL_ThietBiYTe

CREATE TABLE KHACHHANG
(MAKH INT PRIMARY KEY,
HOTEN NVARCHAR(50),
DIACHI NVARCHAR(60),
SODT CHAR(11),
LOAI NVARCHAR(20))
GO

CREATE TABLE NHAPHANPHOI
(MANHAPP CHAR(5) PRIMARY KEY,
TENNPP NVARCHAR(60),
DIACHI NVARCHAR(50),
SODT CHAR(11))
GO

CREATE TABLE THIETBI
(MATB CHAR(5) PRIMARY KEY,
TENTB NVARCHAR(40),
LOAI NVARCHAR(20),
MANHAPP CHAR(5) foreign key references NHAPHANPHOI(MANHAPP),
DVT NCHAR(6),
SOLUONG INT,
GIABAN FLOAT)
GO


CREATE TABLE HOADON
(MAHD INT PRIMARY KEY,
MAKH INT foreign key references KHACHHANG(MAKH),
MATB CHAR(5) foreign key references THIETBI(MATB),
DVT NCHAR(6),
SOLUONG INT)
GO


INSERT KHACHHANG
VALUES
(1,N'Nguyễn Văn Tuyên',N'Số 58 Phương Mai,Đống Đa,Hà Nội','0987665749',N'Bán buôn'),
(2,N'Nguyễn Thị Huyền',N'Số 800 Quang Trung,Hà Đông,Hà Nội','0977456687',N'Phòng khám'),
(3,N'Lê Nhật Anh',N'23 Lý Nam Đế,Hoàn Kiếm,Hà Nội','0388715268',N'Bán lẻ'),
(4,N'Sùng Văn Giàng',N'Lạng Sơn','0984559712',N'Bán buôn'),
(5,N'Hoàng Lê Nguyên',N'Thái Nguyên','0986115234',N'Bán buôn')
GO

INSERT NHAPHANPHOI
VALUES
('001',N'Công ty Cổ phần NXK thiết bị Y tế Việt Anh',N'280 Quang Trung,Hà Đông,Hà Nội','0988765870'),
('002',N'Công ty NXK thiết bị Y tế Việt Hưng',N'Kim Ngưu,Hai Bà Trưng,Hà Nội','0384779708'),
('003',N'Công ty Cổ phần NXK thiết bị Y tế Khánh Toàn',N'Ninh Bình','0988765900'),
('004',N'Công ty TNHH NXK thiết bị Y tế Đại Hùng',N'Thanh liệt,Thanh Xuân,Hà Nội','0988555333')
GO

INSERT THIETBI
VALUES
('100',N'Xe lăn điện Sunfast',N'Nhập khẩu','001',N'Cái',20,2200000),
('101',N'Nẹp chân gỗ',N'Nhập nội','003',N'Đôi',50,300000),
('102',N'Nhiệt kế điện tử-Sạc pin',N'Nhập khẩu','001',N'Cái',25,450000),
('103',N'Khẩu trang Y tế 2M',N'Nhập khẩu','002',N'Hộp',30,300000),
('104',N'Gậy trống 3 chân INOX',N'Nhập nội','001',N'Cái',45,180000)
GO


INSERT HOADON
VALUES
(1,2,'101',N'Đôi',10),
(2,3,'102',N'Cái',15)
GO

--Câu 4: Tạo View cho biết thông tin thiết bị có giá cao nhất? (1.0 điểm)
ALTER VIEW VIEW_GIA_MAX AS
SELECT * FROM THIETBI WHERE GIABAN=(SELECT MAX(GIABAN) FROM THIETBI)

SELECT * FROM VIEW_GIA_MAX
--Câu 5: Tạo View cho biết Loại khách hàng bán buôn. (1.0 điểm)
CREATE VIEW KHACHHANG_BUON_VIEW AS
SELECT * FROM KHACHHANG WHERE LOAI=N'Bán buôn'


--Câu 6: Đưa ra danh sách các nhà phân phối đang phân phối các thiết bị cho cửa hàng (Các
--nhà phân phối cho cửa hàng là những thiết bị có mã nhà phân phối trong bảng THIETBI).
--(1.0 điểm)
CREATE VIEW VIEW_nhaPP_chocuahang AS
SELECT TENNPP FROM NHAPHANPHOI WHERE MANHAPP IN(SELECT MANHAPP FROM THIETBI)

--Câu 7: Tạo thủ tục Stored procedure tạo ra chức năng thêm dữ liệu cho bảng THIETBI.
--(1.0 điểm)
CREATE PROC SP_INSERT_THIETBI @MATB CHAR(5),@TENTB NVARCHAR(40),@LOAI NVARCHAR(20),
							@MANHAPP CHAR(5),@DVT NCHAR(6),@SOLUONG INT,@GIABAN int
AS
INSERT THIETBI VALUES(@MATB,@TENTB,@LOAI,@MANHAPP,@DVT,@SOLUONG,@GIABAN)

EXEC SP_INSERT_THIETBI '105',N'Giường Y tế',N'Nhập nội','003',N'Cái',15,600000

select * from THIETBI
GO
--Câu 8: Sử dụng thủ tục Trigger tạo ra chức năng UPDATE cho một bản ghi của bảng
--NHAPHANPHOI, giúp cho việc cố định địa chỉ cho MA_NHAPP ‘003’ không thay đổi,
--mà sẽ cố định là ‘ Số 15 Thanh Phong, Kim Sơn, Ninh Bình’. (1.0 điểm)
CREATE TRIGGER TG_UPDATE_DIACH ON NHAPHANPHOI FOR UPDATE
AS
DECLARE @MA CHAR(5)
SET @MA=(SELECT MANHAPP FROM NHAPHANPHOI WHERE MANHAPP='003')
IF @MA=(SELECT MANHAPP FROM INSERTED)
	UPDATE NHAPHANPHOI SET DIACHI=N'Ninh Bình'	WHERE MANHAPP='003'

SELECT * FROM NHAPHANPHOI
UPDATE NHAPHANPHOI SET DIACHI=N'Hà Nội'	WHERE MANHAPP='003'

--Câu 9: Tính tổng số tiền của các mặt hàng hiện có (Tổng số tiền = Số lượng * đơn giá).
--(1.0 điểm)
SELECT SUM(SOLUONG*GIABAN) AS TONG_TIEN FROM THIETBI 
GO
--Câu 10: Tạo thủ tục cập nhật tự động khi nhập dữ liệu thông tin khách mua hàng vào bảng
--HOADON thì số lượng thiết bị khách mua sẽ giảm đi tương ứng số lượng của bảng
--THIETBI. (1.0 điểm)
CREATE TRIGGER SP_INSERT_HOADON ON HOADON FOR INSERT
AS
DECLARE @SOLUONG INT = (SELECT COUNT(*) FROM INSERTED,THIETBI
				WHERE INSERTED.MATB=THIETBI.MATB AND INSERTED.SOLUONG>THIETBI.SOLUONG)	
IF @SOLUONG >0
	BEGIN
		PRINT N'HẾT HÀNG'
		ROLLBACK TRAN
	END
ELSE
	BEGIN
		UPDATE THIETBI SET THIETBI.SOLUONG=THIETBI.SOLUONG-INSERTED.SOLUONG FROM INSERTED 
	END

SELECT * FROM THIETBI
SELECT * FROM  HOADON

INSERT HOADON VALUES (3,3,'100','Cái',15)
INSERT HOADON VALUES (4,3,'100','Cái',10)