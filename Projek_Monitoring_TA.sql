
-- 1. CREATE DATABASE + FILE
CREATE DATABASE D_Monitoring_TA
ON PRIMARY (
    NAME = '157_D_Monitoring_TA',   --Primary File             
    FILENAME = 'D:\SQLData\157_D_TA.mdf', 
    SIZE = 10MB,
    FILEGROWTH = 5MB
)
LOG ON (
    NAME = 'R_D_MONITORING_TA_Log',   --Log file      
    FILENAME = 'D:\SQLData\R_D_MONITORING_TA_Log.ldf', 
    SIZE = 5MB,
    FILEGROWTH = 5MB
);
GO



USE D_Monitoring_TA;
GO



--MENAMBAH FILEGROUP & SECONDARY FILE
ALTER DATABASE D_Monitoring_TA ADD FILEGROUP FG_Monitoring_TA; 

ALTER DATABASE D_Monitoring_TA   --mengubah struktur
ADD FILE (
    NAME = 'ARM_D_Monitoring_TA',
    FILENAME = 'D:\SQLData\ARM_D_Monitoring_TA.ndf', 
    SIZE = 5MB
) TO FILEGROUP FG_Monitoring_TA;   --Memasukkan file ARM_D_TA ke dalam Filegroup bernama FG_Monitoring_TA
GO


--MEMBUAT 3 SCHEMA BERBEDA
CREATE SCHEMA akademik;   --Untuk data master  
GO
CREATE SCHEMA aktivitas;   --Untuk pemantauan TA
GO
CREATE SCHEMA arsip;   --Schema tambahan untuk keperluan tugas
GO

ALTER SCHEMA aktivitas
TRANSFER TABLE akademik.Mahasiswa;
GO

--TABEL MAHASISWA
CREATE TABLE akademik.Mahasiswa (
    Nim CHAR(11) PRIMARY KEY,
    Nama VARCHAR(50) NOT NULL,
    Jurusan VARCHAR(30),
    Angkatan INT
);

--TABEL DOSEN
CREATE TABLE akademik.Dosen (
    NIDN CHAR(10) PRIMARY KEY,
    Nama VARCHAR(50) NOT NULL,
    Prodi VARCHAR(30),
    Email VARCHAR(30)
);

--TABEL LOG BIMBINGAN
CREATE TABLE akademik.Log_Bimbingan (
    ID_Log INT IDENTITY(1,1) PRIMARY KEY, 
    Nim CHAR(11),
    NIDN CHAR(10),
    Tanggal DATE,
    Materi TEXT,
    Status VARCHAR(20),
    CONSTRAINT FK_Log_Mhs FOREIGN KEY (Nim) REFERENCES akademik.Mahasiswa(Nim),
    CONSTRAINT FK_Log_Dosen FOREIGN KEY (NIDN) REFERENCES akademik.Dosen(NIDN)
);

--TABEL PENGAJUAN JADWAL
CREATE TABLE akademik.Pengajuan_Jadwal (
    ID_Pengajuan INT IDENTITY(1,1) PRIMARY KEY,
    Nim CHAR(11),
    NIDN CHAR(10),
    Tanggal_Usulan DATE,
    Jam_Usulan TIME,
    Kegiatan VARCHAR(100),
    Status VARCHAR(20) DEFAULT 'Menunggu',
    CONSTRAINT FK_Jadwal_Mhs FOREIGN KEY (Nim) REFERENCES akademik.Mahasiswa(Nim),
    CONSTRAINT FK_Jadwal_Dosen FOREIGN KEY (NIDN) REFERENCES akademik.Dosen(NIDN)
);
GO


--Isi Data Mahasiswa
INSERT INTO akademik.Mahasiswa (Nim, Nama, Jurusan, Angkatan)
VALUES ('20250140157', 'Ahmad Rassya Maulana', 'Teknologi Informasi', 2025),
       ('20250140175', 'Muhammad Raffi imdad Robbani', 'Teknologi Informasi', 2025);

--Isi Data Dosen
INSERT INTO akademik.Dosen (NIDN, Nama, Prodi, Email)
VALUES ('0518048401', 'Apriliya Kurnianti, S.T., M.Eng. ', 'Teknologi Informasi', 'aprilia@ft.umy.ac.id'),
       ('0707108402', 'Chayadi Oktomy N S, S.T., M.Eng., P.hD.', 'Teknologi Informasi', 'cahyadions@ft.umy.ac.id');

--Isi Data Monitoring
INSERT INTO aktivitas.Monitoring_TA (Nim, NIDN_Pembimbing, Judul_TA)
VALUES ('20250140157', '0518048401', 'Pengembangan AI untuk Deteksi Hama');

--Isi Data Log Bimbingan
INSERT INTO akademik.Log_Bimbingan (Nim, NIDN, Tanggal, Materi, Status)
VALUES ('20250140157', '0518048401', GETDATE(), 'Pembahasan Bab 1 Latar Belakang', 'Revisi');

--Isi Data Pengajuan Jadwal
INSERT INTO akademik.Pengajuan_Jadwal (Nim, NIDN, Tanggal_Usulan, Jam_Usulan, Kegiatan, Status)
VALUES ('20250140157', '0518048401', '2025-03-01', '10:00:00', 'Bimbingan Bab 2', 'Disetujui');
GO

-- 8. VERIFIKASI AKHIR
SELECT * FROM akademik.Mahasiswa;
SELECT * FROM akademik.Dosen;
SELECT * FROM akademik.Pengajuan_Jadwal;



--HAPUS SATU SCHEMA
DROP SCHEMA arsip; 
GO

-- VERIFIKASI
SELECT * FROM akademik.Mahasiswa;

