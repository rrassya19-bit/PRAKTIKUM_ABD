
USE KampusPraktikum
-- 1 – Membuat Login dan User Database
CREATE LOGIN staff
WITH PASSWORD = 'Staff123!';

CREATE LOGIN dosen
WITH PASSWORD = 'Dosen123!';

CREATE LOGIN mahasiswa
WITH PASSWORD = 'Mhs123!';
GO

CREATE USER staff_akademik FOR LOGIN staff;
CREATE USER dosen_akademik FOR LOGIN dosen;
CREATE USER mahasiswa_akademik FOR LOGIN mahasiswa;
GO


--VErifikasi
SELECT name, type_desc
FROM sys.database_principals
WHERE type_desc = 'SQL_USER';


-- 2 – User Mapping (Verifikasi hubungan login dan user)
SELECT dp.name AS UserName,
	   sp.name AS LoginName
FROM sys.database_principals dp
JOIN sys.server_principals sp
ON dp.sid = sp.sid
WHERE dp.type_desc = 'SQL_USER';


--3 – Memberikan Hak Akses dengan GRANT
--Staff akademik hanya boleh melihat dan menambah data mahasiswa.
GRANT SELECT, INSERT	
ON akademik.Mahasiswa
TO staff_akademik;

SELECT name --nama kolom
FROM sys.schemas; --nama tabel

--Dosen boleh melihat data mahasiswa dan mengubah data KRS.
GRANT SELECT
ON akademik.Mahasiswa
TO dosen_akademik;

GRANT SELECT, INSERT, UPDATE
ON akademik.KRS
TO dosen_akademik;

--Mahasiswa hanya boleh melihat data KRS.
GRANT SELECT
ON akademik.KRS
TO mahasiswa_akademik;


--Praktikum 4 – Membatasi Hak Akses dengan DENY
--Staff akademik tidak boleh menghapus data mahasiswa.
DENY DELETE
ON akademik.mahasiswa
TO staff_akademik;

--Mahasiswa tidak boleh mengubah data KRS.
DENY INSERT, UPDATE, DELETE
ON akademik.KRS
TO mahasiswa_akademik;


--Praktikum 5 – Mencabut Hak Akses dengan REVOKE
--Cabut hak INSERT staƯ akademik pada tabel Mahasiswa.
REVOKE INSERT
ON akademik.Mahasiswa
FROM staff_akademik;

--verifikasi
SELECT *
FROM fn_my_permissions('akademik.Mahasiswa', 'OBJECT');


--Praktikum 6 – Menggunakan Built-in Database Role
--Tambahkan staƯ_akademik ke role db_datareader.
ALTER ROLE db_datareader
ADD MEMBER staff_akademik;

--Tambahkan dosen_akademik ke role db_datawriter.
ALTER ROLE db_datawriter
ADD MEMBER dosen_akademik;

--verifikasi
SELECT dp1.name AS RoleName,
       dp2.name AS MemberName
FROM sys.database_role_members drm
JOIN sys.database_principals dp1
ON drm.role_principal_id = dp1.principal_id
JOIN sys.database_principals dp2
ON drm.member_principal_id = dp2.principal_id;


--Praktikum 7 – Membuat Custom Database Role
--Buat role untuk dosen.
CREATE ROLE role_dosen;

--Berikan hak akses:
GRANT SELECT
ON akademik.Mahasiswa
TO role_dosen;

GRANT SELECT, INSERT, UPDATE
ON akademik.KRS
TO role_dosen;

--Tambahkan anggota role:
ALTER ROLE role_dosen
ADD MEMBER dosen_akademik;


--Praktikum 8 – Studi Kasus Sistem Akademik
--Implementasi role staƯ:
CREATE ROLE role_staff;

GRANT SELECT, INSERT, UPDATE
ON akademik.Mahasiswa
TO role_staff;

DENY DELETE
ON akademik.Mahasiswa
TO role_staff;

ALTER ROLE role_staff
ADD MEMBER staff_akademik;

--Implementasi role mahasiswa:
CREATE ROLE role_mahasiswa;

GRANT SELECT
ON akademik.KRS
TO role_mahasiswa;

DENY INSERT, UPDATE, DELETE
ON akademik.KRS
TO role_mahasiswa;

ALTER ROLE role_mahasiswa
ADD MEMBER mahasiswa_akademik;


--Praktikum 9 – Simulasi Hak Akses
--Uji akses staƯ akademik:
EXECUTE AS USER = 'staff_akademik';
SELECT * FROM akademik.Mahasiswa;
REVERT;

--Uji akses mahasiswa:
EXECUTE AS USER = 'mahasiswa_akademik';
SELECT * FROM akademik.KRS;
REVERT;

--Uji apakah mahasiswa dapat menghapus data:
EXECUTE AS USER = 'mahasiswa_akademik';
DELETE FROM akademik.KRS WHERE IDKRS = 1;
REVERT;


--Praktikum 10 – Menampilkan Permission User
--Menampilkan seluruh permission database:
SELECT *
FROM fn_my_permissions(NULL, 'DATABASE');

--Menampilkan permission terhadap tabel Mahasiswa:
SELECT *
FROM fn_my_permissions('akademik.Mahasiswa', 'OBJECT');