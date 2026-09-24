--VERSI A-
--Tabel Mahasiswa
CREATE TABLE akademik.Mahasiswa_A(
	NIM CHAR(20),
	Nama CHAR(200),
	Alamat VARCHAR(255),
	NoHP VARCHAR(50),
	TanggalLahir DATETIME,
	Email VARCHAR(200),
);

--Tabel Dosen
CREATE TABLE sdm.Dosen_A (
	NIDN BIGINT,
	Nama CHAR(200),
	Jabatan VARCHAR(100),
	Gaji FLOAT,
	TanggakMasuk DATETIME,
);

--Tabel pembayaran
CREATE TABLE Keuangan.Pembayaran_A(
	ID BIGINT,
	NIM CHAR(20),
	Jumlah FLOAT,
	Ketrangan TEXT,
	TanggalBayar DATETIME,
);

--Versi B
--Tabel Mahasiswa
	CREATE TABLE akademik.Mahasiswa_B (
	DNIM CHAR(10),
	Nama VARCHAR(100),
	Alamat VARCHAR(150),
	NOHP VARCHAR(15),
	TanggalLahir DATE,
	Email VARCHAR(100)
);

CREATE SCHEMA sdm;
CREATE SCHEMA Keuangan;

SELECT name 
FROM sys.schemas;