 /********************************************
 *	UC: Complementos de Bases de Dados 2022/2023
 *
 *	Projeto - Criação do Layout
 *		Nuno Reis (202000753)
 *		Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *
 ********************************************/
 USE WWIGlobal

 /********************************************
 *	Schemas
 ********************************************/
CREATE SCHEMA SystemInfo;
GO


 /********************************************
 *	Tabelas
 ********************************************/
 --DROP TABLE SystemInfo.SysUser
CREATE TABLE SystemInfo.SysUser (
	SysUserID INT UNIQUE NOT NULL,
    SysUserEmail NVARCHAR(30) NOT NULL,
	SysUserPassword NVARCHAR(20) NOT NULL,
	PRIMARY KEY ( SysUserID )
);
GO

--DROP TABLE SystemInfo.MailServer 
CREATE TABLE SystemInfo.MailServer (
	MaiSerID INT UNIQUE NOT NULL,
    MaiSerUserID INT NOT NULL,
    MaiSerMail NVARCHAR(30) NOT NULL,
	MaiSerDate TIMESTAMP NOT NULL,
	MaiSerToken INT NOT NULL,
	PRIMARY KEY ( MaiSerID ),
    FOREIGN KEY (MaiSerID) REFERENCES SystemInfo.SysUser(SysUserID)
);
GO

--DROP TABLE SystemInfo.ServerLog 
CREATE TABLE SystemInfo.ServerLog (
	SerLogID INT UNIQUE NOT NULL,
    SerLogUserID INT NOT NULL,
    SerLogError NVARCHAR(100) NOT NULL,
	SerLogDate Date NOT NULL,
	PRIMARY KEY ( SerLogID ),
    FOREIGN KEY (SerLogUserID) REFERENCES SystemInfo.SysUser(SysUserID)
);
GO