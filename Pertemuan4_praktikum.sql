
--Membuat Login SQL Server
CREATE LOGIN operator_lab
WITH PASSWORD = 'Operator123';


--Verifikasi
SELECT name,type_desc
FROM sys.server_principals
WHERE name = 'Operator_lab';


--Membuat Login Windows
CREATE LOGIN [rassya\legion]
FROM WINDOWS;


--Verifikasi
SELECT name, type_desc
FROM sys.server_principals
WHERE name LIKE '%Rassya%';


--Mengubah Password Login
ALTER LOGIN operator_lab
WITH PASSWORD = 'PasswordBaru123';


--Menonaktifkan Login
ALTER LOGIN operator_lab DISABLE;


--Mengaktifkan Login
ALTER LOGIN operator_lab ENABLE;


--Verifikasi
SELECT name,type_desc is_disabled
FROM sys.server_principals
WHERE name = 'Operator_lab';


--Memberikan Server Role
ALTER SERVER ROLE dbcreator --Memberikan Role dbcreator
ADD MEMBER operator_lab;

ALTER SERVER ROLE securityadmin --Memberikan Role securityadmin
ADD MEMBER operator_lab;


--Verifikasi
SELECT
	sp.name AS LoginName,
	sr.name AS ServerRole
FROM sys.server_role_members srm
JOIN sys.server_principals sp
	ON srm.member_principal_id = sp.principal_id
JOIN sys.server_principals sr
	ON srm.role_principal_id = sr.principal_id
WHERE sp.name = 'operator_lab';


-- Menghapus Server Role
ALTER SERVER ROLE securityadmin 
DROP MEMBER operator_lab;


----Verifikasi
SELECT
	sp.name AS LoginName,
	sr.name AS ServerRole
FROM sys.server_role_members srm
JOIN sys.server_principals sp
	ON srm.member_principal_id = sp.principal_id
JOIN sys.server_principals sr
	ON srm.role_principal_id = sr.principal_id
WHERE sp.name = 'operator_lab';


--Menampilkan Semua Login Berdasarkan nama

SELECT
	name,
	type_desc,
	create_date,
	modify_date
FROM sys.server_principals
ORDER BY name;


--Menampilkan Semua Login Berdasarkan tanggal prmbuatan
SELECT
	name,
	type_desc,
	create_date,
	modify_date
FROM sys.server_principals
ORDER BY create_date;


--Menampilkan Semua Anggota Server Role
SELECT
	sp.name AS LoginName,
	sr.name AS ServerRole
FROM sys.server_role_members srm
JOIN sys.server_principals sp
	ON srm.member_principal_id = sp.principal_id
JOIN sys.server_principals sr
	ON srm.role_principal_id = sr.principal_id
ORDER BY sr.name, sp.name;