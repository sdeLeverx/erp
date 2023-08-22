
DROP VIEW IF EXISTS localized_fr_EmployeeService_Employee;
DROP VIEW IF EXISTS localized_de_EmployeeService_Employee;
DROP VIEW IF EXISTS localized_fr_EmployeeService_Device;
DROP VIEW IF EXISTS localized_de_EmployeeService_Device;
DROP VIEW IF EXISTS localized_fr_EmployeeService_Currencies;
DROP VIEW IF EXISTS localized_de_EmployeeService_Currencies;
DROP VIEW IF EXISTS localized_fr_uz_erp_Employee;
DROP VIEW IF EXISTS localized_de_uz_erp_Employee;
DROP VIEW IF EXISTS localized_fr_uz_erp_Device;
DROP VIEW IF EXISTS localized_de_uz_erp_Device;
DROP VIEW IF EXISTS localized_fr_sap_common_Currencies;
DROP VIEW IF EXISTS localized_de_sap_common_Currencies;
DROP VIEW IF EXISTS localized_EmployeeService_Employee;
DROP VIEW IF EXISTS localized_EmployeeService_Device;
DROP VIEW IF EXISTS localized_EmployeeService_Currencies;
DROP VIEW IF EXISTS localized_uz_erp_Employee;
DROP VIEW IF EXISTS localized_uz_erp_Device;
DROP VIEW IF EXISTS localized_sap_common_Currencies;
DROP VIEW IF EXISTS EmployeeService_Currencies_texts;
DROP VIEW IF EXISTS EmployeeService_Currencies;
DROP VIEW IF EXISTS EmployeeService_Device;
DROP VIEW IF EXISTS EmployeeService_Employee;
DROP TABLE IF EXISTS sap_common_Currencies_texts;
DROP TABLE IF EXISTS sap_common_Currencies;
DROP TABLE IF EXISTS uz_erp_Device;
DROP TABLE IF EXISTS uz_erp_Employee;

CREATE TABLE uz_erp_Employee (
  ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP(7),
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP(7),
  modifiedBy NVARCHAR(255),
  name NVARCHAR(100),
  email NVARCHAR(100),
  gender NVARCHAR(10),
  PRIMARY KEY(ID)
); 

CREATE TABLE uz_erp_Device (
  ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP(7),
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP(7),
  modifiedBy NVARCHAR(255),
  employee_ID NVARCHAR(36),
  title NVARCHAR(100),
  price DECIMAL(9, 2),
  currency_code NVARCHAR(3),
  PRIMARY KEY(ID)
); 

CREATE TABLE sap_common_Currencies (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(3) NOT NULL,
  symbol NVARCHAR(5),
  minorUnit SMALLINT,
  PRIMARY KEY(code)
); 

CREATE TABLE sap_common_Currencies_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(3) NOT NULL,
  PRIMARY KEY(locale, code)
); 

CREATE VIEW EmployeeService_Employee AS SELECT
  Employee_0.ID,
  Employee_0.createdAt,
  Employee_0.createdBy,
  Employee_0.modifiedAt,
  Employee_0.modifiedBy,
  Employee_0.name,
  Employee_0.email,
  Employee_0.gender
FROM uz_erp_Employee AS Employee_0; 

CREATE VIEW EmployeeService_Device AS SELECT
  Device_0.ID,
  Device_0.createdAt,
  Device_0.createdBy,
  Device_0.modifiedAt,
  Device_0.modifiedBy,
  Device_0.employee_ID,
  Device_0.title,
  Device_0.price,
  Device_0.currency_code
FROM uz_erp_Device AS Device_0; 

CREATE VIEW EmployeeService_Currencies AS SELECT
  Currencies_0.name,
  Currencies_0.descr,
  Currencies_0.code,
  Currencies_0.symbol,
  Currencies_0.minorUnit
FROM sap_common_Currencies AS Currencies_0; 

CREATE VIEW EmployeeService_Currencies_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM sap_common_Currencies_texts AS texts_0; 

CREATE VIEW localized_sap_common_Currencies AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.minorUnit
FROM (sap_common_Currencies AS L_0 LEFT JOIN sap_common_Currencies_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en'); 

CREATE VIEW localized_uz_erp_Device AS SELECT
  L.ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.employee_ID,
  L.title,
  L.price,
  L.currency_code
FROM uz_erp_Device AS L; 

CREATE VIEW localized_uz_erp_Employee AS SELECT
  L.ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.name,
  L.email,
  L.gender
FROM uz_erp_Employee AS L; 

CREATE VIEW localized_EmployeeService_Currencies AS SELECT
  Currencies_0.name,
  Currencies_0.descr,
  Currencies_0.code,
  Currencies_0.symbol,
  Currencies_0.minorUnit
FROM localized_sap_common_Currencies AS Currencies_0; 

CREATE VIEW localized_EmployeeService_Device AS SELECT
  Device_0.ID,
  Device_0.createdAt,
  Device_0.createdBy,
  Device_0.modifiedAt,
  Device_0.modifiedBy,
  Device_0.employee_ID,
  Device_0.title,
  Device_0.price,
  Device_0.currency_code
FROM localized_uz_erp_Device AS Device_0; 

CREATE VIEW localized_EmployeeService_Employee AS SELECT
  Employee_0.ID,
  Employee_0.createdAt,
  Employee_0.createdBy,
  Employee_0.modifiedAt,
  Employee_0.modifiedBy,
  Employee_0.name,
  Employee_0.email,
  Employee_0.gender
FROM localized_uz_erp_Employee AS Employee_0; 

CREATE VIEW localized_de_sap_common_Currencies AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.minorUnit
FROM (sap_common_Currencies AS L_0 LEFT JOIN sap_common_Currencies_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de'); 

CREATE VIEW localized_fr_sap_common_Currencies AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.minorUnit
FROM (sap_common_Currencies AS L_0 LEFT JOIN sap_common_Currencies_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr'); 

CREATE VIEW localized_de_uz_erp_Device AS SELECT
  L.ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.employee_ID,
  L.title,
  L.price,
  L.currency_code
FROM uz_erp_Device AS L; 

CREATE VIEW localized_fr_uz_erp_Device AS SELECT
  L.ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.employee_ID,
  L.title,
  L.price,
  L.currency_code
FROM uz_erp_Device AS L; 

CREATE VIEW localized_de_uz_erp_Employee AS SELECT
  L.ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.name,
  L.email,
  L.gender
FROM uz_erp_Employee AS L; 

CREATE VIEW localized_fr_uz_erp_Employee AS SELECT
  L.ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.name,
  L.email,
  L.gender
FROM uz_erp_Employee AS L; 

CREATE VIEW localized_de_EmployeeService_Currencies AS SELECT
  Currencies_0.name,
  Currencies_0.descr,
  Currencies_0.code,
  Currencies_0.symbol,
  Currencies_0.minorUnit
FROM localized_de_sap_common_Currencies AS Currencies_0; 

CREATE VIEW localized_fr_EmployeeService_Currencies AS SELECT
  Currencies_0.name,
  Currencies_0.descr,
  Currencies_0.code,
  Currencies_0.symbol,
  Currencies_0.minorUnit
FROM localized_fr_sap_common_Currencies AS Currencies_0; 

CREATE VIEW localized_de_EmployeeService_Device AS SELECT
  Device_0.ID,
  Device_0.createdAt,
  Device_0.createdBy,
  Device_0.modifiedAt,
  Device_0.modifiedBy,
  Device_0.employee_ID,
  Device_0.title,
  Device_0.price,
  Device_0.currency_code
FROM localized_de_uz_erp_Device AS Device_0; 

CREATE VIEW localized_fr_EmployeeService_Device AS SELECT
  Device_0.ID,
  Device_0.createdAt,
  Device_0.createdBy,
  Device_0.modifiedAt,
  Device_0.modifiedBy,
  Device_0.employee_ID,
  Device_0.title,
  Device_0.price,
  Device_0.currency_code
FROM localized_fr_uz_erp_Device AS Device_0; 

CREATE VIEW localized_de_EmployeeService_Employee AS SELECT
  Employee_0.ID,
  Employee_0.createdAt,
  Employee_0.createdBy,
  Employee_0.modifiedAt,
  Employee_0.modifiedBy,
  Employee_0.name,
  Employee_0.email,
  Employee_0.gender
FROM localized_de_uz_erp_Employee AS Employee_0; 

CREATE VIEW localized_fr_EmployeeService_Employee AS SELECT
  Employee_0.ID,
  Employee_0.createdAt,
  Employee_0.createdBy,
  Employee_0.modifiedAt,
  Employee_0.modifiedBy,
  Employee_0.name,
  Employee_0.email,
  Employee_0.gender
FROM localized_fr_uz_erp_Employee AS Employee_0; 

