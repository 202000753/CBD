/*Indices
Nuno Reis		202000753*/

use master
create database STBRel
go

use STBRel
go

create schema ActiveData;
go
create schema ArchiveData;
go

create table ActiveData.Subject(
	SubjectID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name nvarchar(40) NOT NULL
)

create table ActiveData.Address(
	AddressID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AddressLine1 nvarchar (60) NOT NULL,
	AddressLine2 nvarchar (60),
	City nvarchar (30) NOT NULL,
	StateProvince nvarchar (30) NOT NULL,
	CountryRegion nvarchar (50) NOT NULL,
	PostalCode nvarchar (15) NOT NULL
)

create table ActiveData.Sys_User(
	UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name nvarchar (60) NOT NULL,
	Mail nvarchar(70) UNIQUE NOT NULL,
	Password nvarchar (35) NOT NULL,
	LastAccess datetime
)

create table ActiveData.UserAddress(
	UserID int NOT NULL FOREIGN KEY REFERENCES ActiveData.Sys_User (UserID),
	AddressID int NOT NULL FOREIGN KEY REFERENCES ActiveData.Address (AddressID),
	IsMainAddress bit NOT NULL,
	AddressType bit NOT NULL -- Urban 0, Rural 1 
	PRIMARY KEY (UserID, AddressID)
)	

create table ActiveData.School(
	SchoolID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name nvarchar(40) NOT NULL,
)

create table ActiveData.Guardian(
	GuardianID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UserID int NOT NULL foreign key references ActiveData.Sys_User(UserID)
)

create table ActiveData.Student (
	StudentID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UserID int NOT NULL foreign key references ActiveData.Sys_User (UserID),
	Gender char,
	BirthDate date NOT NULL,
	FamSize bit, --LE3 0 GT3 1
	Pstatus bit, --T 0 A 1
	Medu tinyint,
	Fedu tinyint,
	Mjob nvarchar (20),
	Fjob nvarchar (20),
	Reason nvarchar (20),
	Guardian_Relation nvarchar (20),
	TravelTime tinyint,
	StudyTime tinyint,
	Schoolsup bit, --No 0 Yes  1
	Famsup bit, --No 0 Yes  1
	Paid bit, --No 0 Yes  1
	Activities bit, --No 0 Yes  1
	Nursery bit, --No 0 Yes  1
	Higher bit, --No 0 Yes  1
	Internet bit, --No 0 Yes  1
	Romatic bit, --No 0 Yes  1
	Famrel tinyint,
	Freetime tinyint,
	Goout tinyint,
	Dalc tinyint,
	Walc tinyint,
	Health tinyint,
	SchoolID int NOT NULL foreign key references ActiveData.School (SchoolID),
	GuardianID int foreign key references ActiveData.Guardian(GuardianID)
)

create table ArchiveData.Cloosed_Course(
	SchoolYear smallint NOT NULL ,
	SubjectID int NOT NULL foreign key references ActiveData.Subject (SubjectID),
	StudentID int NOT NULL foreign key references ActiveData.Student (StudentID),
	Failures tinyint,
	Absences tinyint,
	P1_grade tinyint,
	P2_grade tinyint,
	P3_grade tinyint,
	PRIMARY KEY(SchoolYear, SubjectID, StudentID)
)

create table ActiveData.Current_Course(
	SubjectID int NOT NULL foreign key references ActiveData.Subject (SubjectID),
	StudentID int NOT NULL foreign key references ActiveData.Student (StudentID),
	Failures tinyint,
	Absences tinyint,
	P1_grade tinyint,
	P2_grade tinyint,
	P3_grade tinyint,
	PRIMARY KEY(SubjectID, StudentID)
)
go

----------------------------------------------------------------------------------------------------
-- Procedures
----------------------------------------------------------------------------------------------------
create or alter procedure gerarDados
as
begin
	declare @anoInicial int
	declare @anoFinal int
	declare @disciplina varchar(20)
	DECLARE @disciplinas TABLE (nome varchar(20))
	declare @nregisto int
	declare @subjectID int
	declare @times int

	set @nregisto = 1
	set @times = 1
	set @subjectID = 0
	set @anoInicial = 1960
	set @anoFinal = 2020

	insert into @disciplinas(nome) values ('Português')
	insert into ActiveData.Subject(Name) values ('Português')
	insert into @disciplinas(nome) values ('Inglês')
	insert into ActiveData.Subject(Name) values ('Inglês')
	insert into @disciplinas(nome) values ('Frances')
	insert into ActiveData.Subject(Name) values ('Frances')
	insert into @disciplinas(nome) values ('Matemática')
	insert into ActiveData.Subject(Name) values ('Matemática')
	insert into @disciplinas(nome) values ('Ciências')
	insert into ActiveData.Subject(Name) values ('Ciências')
	insert into @disciplinas(nome) values ('Físico-química')
	insert into ActiveData.Subject(Name) values ('Físico-química')
	insert into @disciplinas(nome) values ('Educação')
	insert into ActiveData.Subject(Name) values ('Educação')
	insert into @disciplinas(nome) values ('Visual')
	insert into ActiveData.Subject(Name) values ('Visual')
	insert into @disciplinas(nome) values ('TIC')
	insert into ActiveData.Subject(Name) values ('TIC')
	insert into @disciplinas(nome) values ('Educação Física')
	insert into ActiveData.Subject(Name) values ('Educação Física')

	insert into ActiveData.School(Name) values ('Escola Fernando Pessoa')
	insert into ActiveData.School(Name) values ('Escola José Saramago')
	insert into ActiveData.School(Name) values ('Escola Eça de Queiros')
	insert into ActiveData.School(Name) values ('Escola de Bocage')


	declare disciplina_Cursor cursor
	for select *
		from @disciplinas
	open disciplina_Cursor
	fetch next from disciplina_Cursor into @disciplina;

	WHILE @anoInicial <= @anoFinal
	BEGIN
		print'              '
		print'              '
		print'              '
		print''+ CAST(@anoInicial AS varchar)
		print'              '
		print'              '
		print'              '

		while @nregisto < (4400*@times)
		begin
			print'     '+ CAST(@nregisto AS varchar)
			SET IDENTITY_INSERT ActiveData.Sys_User ON; 
			insert into ActiveData.Sys_User(UserID, Name, Mail, Password, LastAccess) values (@nregisto, 'Aluno' + CAST(@nregisto AS varchar), 'emailaluno'+CAST(@nregisto AS varchar)+'@gmail.com', 'pass123', GETDATE())
			set @nregisto = @nregisto +1
			insert into ActiveData.Sys_User(UserID, Name, Mail, Password, LastAccess) values (@nregisto, 'EE'+CAST(@nregisto AS varchar), 'emailee'+CAST(@nregisto AS varchar)+'@gmail.com', 'pass123', GETDATE())
			SET IDENTITY_INSERT ActiveData.Sys_User Off;

			SET IDENTITY_INSERT ActiveData.Guardian ON; 
			insert into ActiveData.Guardian(GuardianID, UserID) values (@nregisto, @nregisto)
			SET IDENTITY_INSERT ActiveData.Guardian Off;

			SET IDENTITY_INSERT ActiveData.Student ON; 
			insert into ActiveData.Student(StudentID, UserID, BirthDate, SchoolID, GuardianID) values (@nregisto-1, @nregisto-1, '2008-11-11', ((rand()*4)+1), @nregisto)
			SET IDENTITY_INSERT ActiveData.Student Off;
				
			while (@@FETCH_STATUS = 0)
			begin
				print'          '+ CAST(@disciplina AS varchar)
				set @subjectID = (select SubjectID from ActiveData.Subject where Name like @disciplina);
			
				insert into ArchiveData.Cloosed_Course(SchoolYear, SubjectID, StudentID, P1_grade, P2_grade, P3_grade) values (@anoInicial, @subjectID, @nregisto-1, ((rand()*10)+10), ((rand()*10)+10), ((rand()*10)+10))
				fetch next from disciplina_Cursor into @disciplina;
			end
				
			set @nregisto = @nregisto +1

			close disciplina_Cursor
			open disciplina_Cursor
			fetch next from disciplina_Cursor into @disciplina;
		end
			
		set @times = @times +1;
		SET @anoInicial = @anoInicial + 1;
	end
		
end;

--exec gerarDados;

go;

----------------------------------------------------------------------------------------------------
-- Views
----------------------------------------------------------------------------------------------------
--Calcular, por ano, a percentagem de alunos com nota final (P3) maior ou igual a 15
CREATE VIEW [alunosNotaP3] AS
select T1.SchoolYear, (T1.n*100)/T2.n as Percentagem
from(select T1.SchoolYear, count(T1.StudentID) as n
		from(select SchoolYear, StudentID
			from ArchiveData.Cloosed_Course
			where  P3_grade >= 15
			group by SchoolYear, StudentID) as T1
		group by T1.SchoolYear) as T1
join(select T1.SchoolYear, count(T1.StudentID) as n
		from(select SchoolYear, StudentID
			from ArchiveData.Cloosed_Course
			group by SchoolYear, StudentID) as T1
		group by T1.SchoolYear) as T2
on T1.SchoolYear=T2.SchoolYear
go;


--Calcular, por cada ano, a escola com melhor média final
