CREATE DATABASE QL_SV_Dao_Thi_Thao
USE QL_SV_Dao_Thi_Thao

CREATE TABLE KHOA
(MAKHOA char(5) PRIMARY KEY,
TENKHOA nvarchar (50),
NAMTL CHAR(5))
GO

CREATE TABLE LOP(
MALOP char(5)PRIMARY KEY,
TENLOP nvarchar(30),
KHOAHOC int,
HEDT nvarchar(50),
MAKHOA char(5) foreign key references KHOA(MAKHOA))
GO

CREATE TABLE SINHVIEN
(MASV char(10) PRIMARY KEY,
HOVATEN nvarchar(50) ,
TUOI INT CHECK (TUOI BETWEEN 18 AND 25),
NOISINH nvarchar (26),
MALOP char(5) foreign key references LOP(MALOP) )
go


insert into KHOA
values
 ('2101',N'Công nghệ thông tin','2015'),
 ('2102',N'Công nghệ Ô tô','2018'),
 ('2103',N'Ngôn ngữ Hàn Quốc','2010'),
 ('2104',N'Ngôn ngữ Nhật Bản','2010'),
 ('2105',N'Quản trị kinh doanh','2015')
 GO

insert into LOP
values 
('201',N'K18.IT3.01',18,N'Cao đẳng chính quy','2101'),
('202',N'K18.IT3.02',18,N'Cao đẳng chính quy','2101'),
('203',N'K19.OT3.01',19,N'Cao đẳng chính quy','2102'),
('204',N'K18.KR3.01',18,N'Cao đẳng chính quy','2103'),
('205',N'K19.JP3.01',19,N'Cao đẳng chính quy','2104'),
('206',N'K19.KR3.02',18,N'Cao đẳng chính quy','2103'),
('207',N'K19.JP3.02',19,N'Cao đẳng chính quy','2104'),
('208',N'K18.BA3.01',18,N'Cao đẳng chính quy','2105')
GO


insert into Sinhvien 
values
('001',N'Lê Thang Long',19,N'Tuyên Quang','201'),
('002',N'Nguyễn Văn Quyết',21,N'Hà Nội','201'),
('003',N'Hoàng Minh Phương',19,N'Thái Bình','204'),
('004',N'Phương Hoàng Long',18,N'Phú Thọ','203'),
('005',N'Trần Quang Tuấn',24,N'Nghệ An','202'),
('006',N'Trương Văn Dũng',23,N'Thanh Hóa','207')
GO

CREATE TABLE XOA_TEN_SV
(MASV char(10) PRIMARY KEY,
HOVATEN nvarchar(50) ,
TUOI INT CHECK (TUOI BETWEEN 18 AND 25),
NOISINH nvarchar (26),
MALOP char(5) foreign key references LOP(MALOP) )
go

--Câu 5: Tạo thủ tục tục Stored procedure có chức năng thêm sinh viên vào bảng
--SINHVIEN.
CREATE PROC SP_INSERT_SV @MASV CHAR(10),@HOVATEN NVARCHAR(50),@TUOI INT,
						@NOISINH NVARCHAR(26),@MALOP CHAR(5)
AS
	INSERT SINHVIEN
	VALUES (@MASV,@HOVATEN,@TUOI,@NOISINH,@MALOP)

EXEC SP_INSERT_SV '007',N'Đào Thị Thảo',19,N'Hà Nội','206'

SELECT * FROM SINHVIEN

--Câu 6: Tạo View đưa ra thông tin các lớp không còn sinh viên trong danh sách
CREATE VIEW_LOP_0_SV AS
SELECT * FROM LOP WHERE MALOP NOT IN (SELECT MALOP FROM SINHVIEN)

--Câu 7: Cho biết tổng số sinh viên trong danh sách SINHVIEN
SELECT COUNT(MASV) AS TONG_SV FROM SINHVIEN 

--Câu 8: Tạo View đưa ra thông tin các khoa thành lập vào năm 2010.
CREATE  VIEW VIEW_KHOA_TL2020 AS
SELECT * FROM KHOA WHERE NAMTL='2010'
SELECT * FROM VIEW_KHOA_TL2020

GO
--Câu 9: Cho biết thông tin các khoa có số lớp <=1 lớp.
SELECT KHOA.MAKHOA,TENKHOA,COUNT(*) AS SOLOP FROM KHOA,LOP WHERE KHOA.MAKHOA=LOP.MAKHOA 
GROUP BY KHOA.MAKHOA,TENKHOA HAVING COUNT(*) <=1

GO
--Câu 10: Tạo thủ tục Trigger có chức năng tự động nhập danh sách xoá tên vào bảng Xoá
--tên, sẽ tự động xoá tên trong danh sách bảng sinh viên.
CREATE TRIGGER TG_XOA_SV ON XOA_TEN_SV FOR INSERT
AS
	DELETE SINHVIEN FROM SINHVIEN,INSERTED WHERE SINHVIEN.MASV=INSERTED.MASV

INSERT XOA_TEN_SV VALUES ('007',N'Đào Thị Thảo',19,N'Hà Nội','206')

SELECT * FROM XOA_TEN_SV
