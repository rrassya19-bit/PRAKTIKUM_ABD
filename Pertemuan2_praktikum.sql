--membuat database dengan spesifikasi file
CREATE DATABASE KampusPraktikum
ON PRIMARY
(
	NAME = KampusPraktikum_Primary,
	FILENAME = 'D:\SQLKampus\KampusPraktikum.mdf',
	SIZE = 10MB,
	FILEGROWTH = 5MB
)

LOG ON
(
	NAME = KampusPraktikum_Log,
	FILENAME = 'D:\SQLKampus\KampusPraktikum.ldf',
	SIZE = 5MB,
	FILEGROWTH = 5MB
);

--mengubah stuktur db, dengan mengubah filegroup
ALTER DATABASE kampusPraktikum
ADD FILEGROUP FG_Akademik;

--mengubah stuktur db, dengan mengubah nama db
ALTER DATABASE KampusPraktikum
MODIFY NAME = KampusPraktikumBaru;

--menghapus db secara permanen
DROP DATABASE KampusPraktikumBaru;

--mengakses database
USE KampusPraktikum;

--membuat schema dalam struktur db
CREATE SCHEMA akademik;
CREATE SCHEMA keuangan;

--menampilkan semua schema yang ada di dalam server
SELECT name --nama kolom
FROM sys.schemas; --nama tabel

--membuat tabel dalam db
CREATE TABLE akademik.Mahasiswa
(
	NIM CHAR(10) PRIMARY KEY,
	Nama VARCHAR (100)
	);
	
--mengubah schema
ALTER SCHEMA Keuangan
TRANSFER akademik.Mahasiswa;

--menghapus schema
DROP SCHEMA Keuangan;

--menghapus tabel
DROP TABLE Keuangan.Mahasiswa;

--menghapus schema
DROP SCHEMA Keuangan;

USE master;
GO

-- Menutup paksa semua koneksi ke database agar bisa dihapus
ALTER DATABASE D_Monitoring_TA SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Menghapus database
DROP DATABASE D_Monitoring_TA;
GO