 /********************************************
 *	UC: Complementos de Bases de Dados 2022/2023
 *
 *	Projeto 1ª Fase - Migração da tabela lookup para o schema OldData
 *		Nuno Reis (202000753)
 *			Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *
 ********************************************/
 USE WWIGlobal
GO

/****** Object:  Table [OldData].[lookup] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [OldData].[lookup](
	[IdCategory] [varchar](50) NULL,
	[Name] [varchar](50) NULL
) ON [PRIMARY]
GO

INSERT [OldData].[lookup] ([IdCategory], [Name]) VALUES (N'1', N'Novelty Shop')
INSERT [OldData].[lookup] ([IdCategory], [Name]) VALUES (N'2', N'Gas Station Shop')
INSERT [OldData].[lookup] ([IdCategory], [Name]) VALUES (N'3', N'Gift Shop')
INSERT [OldData].[lookup] ([IdCategory], [Name]) VALUES (N'4', N'24H Shop')
INSERT [OldData].[lookup] ([IdCategory], [Name]) VALUES (N'5', N'Kiosk ')
GO
