 /********************************************
 *	UC: Complementos de Bases de Dados 2022/2023
 *
 *	Projeto 1ª Fase - Migração da tabela States para o schema OldData
 *		Nuno Reis (202000753)
 *			Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *
 ********************************************/
USE WWIGlobal
GO

/****** Object:  Table [OldData].[States] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [OldData].[States](
	[Code] [varchar](50) NULL,
	[Name] [varchar](50) NULL
) ON [PRIMARY]
GO

INSERT [OldData].[States] ([Code], [Name]) VALUES (N'AL', N'Alabama')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'AK', N'Alaska')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'AZ', N'Arizona')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'AR', N'Arkansas')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'CA', N'California')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'CO', N'Colorado')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'CT', N'Connecticut')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'DE', N'Delaware')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'FL', N'Florida')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'GA', N'Georgia')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'HI', N'Hawaii')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'ID', N'Idaho')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'IL', N'Illinois')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'IN', N'Indiana')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'IA', N'Iowa')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'KS', N'Kansas')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'KY', N'Kentucky')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'LA', N'Louisiana')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'ME', N'Maine')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'MD', N'Maryland')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'MA', N'Massachusetts')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'MI', N'Michigan')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'MN', N'Minnesota')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'MS', N'Mississippi')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'MO', N'Missouri')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'MT', N'Montana')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'NE', N'Nebraska')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'NV', N'Nevada')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'NH', N'New Hampshire')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'NJ', N'New Jersey')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'NM', N'New Mexico')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'NY', N'New York')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'NC', N'North Carolina')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'ND', N'North Dakota')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'OH', N'Ohio')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'OK', N'Oklahoma')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'OR', N'Oregon')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'PA', N'Pennsylvania')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'RI', N'Rhode Island')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'SC', N'South Carolina')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'SD', N'South Dakota')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'TN', N'Tennessee')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'TX', N'Texas')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'UT', N'Utah')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'VT', N'Vermont')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'VA', N'Virginia')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'WA', N'Washington')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'WV', N'West Virginia')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'WI', N'Wisconsin')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'WY', N'Wyoming')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'DC', N'District of Columbia')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'AS', N'American Samoa')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'GU', N'Guam')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'MP', N'Northern Mariana Islands')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'PR', N'Puerto Rico')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'UM', N'United States Minor Outlying Islands')
INSERT [OldData].[States] ([Code], [Name]) VALUES (N'VI', N'Virgin Islands, U.S.')
GO
