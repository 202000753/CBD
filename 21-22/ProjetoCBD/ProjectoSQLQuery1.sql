/*Tiago Paixão	201000625
Nuno Reis		202000753*/

create database ProjectoCBD
go
use ProjectoCBD
go

create schema OldData;
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

create table ActiveData.Student_MultiLanguage (
	StudentID int NOT NULL,
	Lang nvarchar (5) NOT NULL,
	Mjob varchar (20),
	Fjob varchar (20),
	Reason varchar (20),
	Guardian_Relation nvarchar (20)
	PRIMARY KEY (StudentID, Lang)
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

CREATE TABLE ActiveData.ServidorMail(
	mailID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	mailReceiver nvarchar (70) NOT NULL,
	tokenNumber nvarchar (10) NOT NULL,
	mailDateTime datetime NOT NULL
)

------STORED PROCEDURES/ FUNCTIONS
CREATE FUNCTION fnHashPassword (@password NVARCHAR(32))
Returns NVARCHAR(32)
AS
BEGIN
	return HASHBYTES('SHA1', @password)
END

CREATE or alter procedure PROCEDURE insertNewStudent (@mail nvarchar(70),
									@name nvarchar (60),
									@gender nvarchar,
									@birthdate datetime,
									@addressType bit,
									@famSize bit,
									@Pstatus bit,
									@Medu tinyint,
									@Fedu tinyint,
									@Mjob nvarchar(20),
									@Fjob nvarchar(20),
									@reason nvarchar(20),
									@guardianRelation nvarchar(20),
									@traveltime tinyint,
									@studytime tinyint,
									@schoolsup bit,
									@famsup bit,
									@paid bit,
									@activities bit,
									@nursery bit,
									@higher bit,
									@internet bit,
									@romantic bit,
									@famrel tinyint,
									@freetime tinyint,
									@goout tinyint,
									@Dalc tinyint,
									@Walc tinyint,
									@health tinyint,
									@schoolID int)
as
BEGIN
---falta apanhar o erro de o mail 
declare @currentTime nvarchar (60)
set @currentTime = CONVERT (nvarchar ,CONVERT (TIME, CURRENT_TIMESTAMP))
IF (@mail is NULL)
BEGIN
	SET @mail = @currentTime
END
insert into ActiveData.Sys_User (Mail, name, Password) values (@mail, @name, 'PASSWORD')
declare @userID int
declare @addressID int
set @userID = (select UserID from ActiveData.Sys_User where @mail = Mail)
insert into ActiveData.Student (UserID , BirthDate, Gender,FamSize, Pstatus, Medu, Fedu, Mjob, Fjob, Reason, Guardian_Relation, TravelTime, StudyTime, Schoolsup, Famsup, Paid, Activities, Nursery, Higher, Internet, Romatic, Famrel, Freetime, Goout, Walc, Dalc, Health, SchoolID) 
	values (@userID, @birthdate, @gender, @famSize, @Pstatus, @Medu, @Fedu, @Mjob, @Fjob, @reason, @guardianRelation, @traveltime, @studytime, @schoolsup, @famsup, @paid, @activities, @nursery, @higher, @internet, @romantic, @famrel, @freetime, @goout, @Dalc, @Walc, @health, @schoolID)
insert into ActiveData.Address (AddressLine1, City, StateProvince, CountryRegion, PostalCode)
	values (@currentTime,'City','StateProvince','CountryRegion','PostalCode')
set @addressID = (select AddressID from ActiveData.Address where AddressLine1 = @currentTime)
insert into ActiveData.UserAddress (UserID, AddressID, IsMainAddress, AddressType) values (@userID, @addressID, 1, @addressType)

END
go

select CURRENT_TIMESTAMP

--exec insertNewStudent @mail = 'goble@gmail.com', @name= 'Temp Name', @gender = 'M', @birthdate = '12/12/12', @addressType = 1, @famSize = 0, @Pstatus = 1, @Medu = 1, @Fedu = 1, @Mjob = 'MJOB', @Fjob = 'Fjob', @reason = 'reason', @guardianRelation = 'FATHER', @traveltime = 2, @studytime = 1, @schoolsup = 1, @famsup = 1, @paid = 1, @activities = 1, @nursery = 1, @higher = 1, @internet = 1, @romantic = 1, @famrel = 1, @freetime = 1, @goout = 1, @Dalc = 1, @Walc = 1, @health = 1, @schoolID = 443 --INSERE O ALUNO NA TABELA DE ALUNOS é melhor criar um stored procedure
--select * from ActiveData.Sys_User
--select * from ActiveData.Address


CREATE or alter procedure insertNewSubject (@name nvarchar (60))
as
insert into ActiveData.Subject (Name) values (@name)
go

CREATE or alter procedure insertRowCloosed_Course (@SchoolYear smallint,	@SubjectID int,	@StudentID int, @Failures tinyint, @Absences tinyint, @P1_grade tinyint, @P2_grade tinyint, @P3_grade tinyint)
as
insert into ArchiveData.Cloosed_Course (SchoolYear, SubjectID, StudentID, Failures, Absences, P1_grade, P2_grade, P3_grade) values (@SchoolYear,	@SubjectID,	@StudentID, @Failures, @Absences, @P1_grade, @P2_grade, @P3_grade)
go

CREATE or alter procedure registerStudentInSubject (@studentID int, @subjectID int, @failures tinyint) --REGISTA UM ALUNO EM UMA DISCIPLINA NO ANO ACTUAL
as
BEGIN
	insert into ActiveData.Current_Course (SubjectID, StudentID, Failures , Absences, P1_grade, P2_grade, P3_grade) values (@subjectID, @studentID, @failures, 0, NULL,NULL,NULL)
END
go

CREATE or alter procedure startSchoolYear (@year smallint)
as
BEGIN
	SELECT *
	INTO #temp_current --- tabela temporaria
	FROM ArchiveData.Cloosed_Course where SchoolYear = @year -1 --copia o ultimo ano para uma tabela temporaria
	DECLARE @StudentID int
	DECLARE @SubjectID int
	DECLARE @media float
	DECLARE @failures tinyint
	DECLARE StudentID_cursor CURSOR FOR
	select StudentID from #temp_current
	open StudentID_cursor
	Fetch next from StudentID_cursor into @StudentID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE SubjectID_cursor CURSOR FOR --infelizmente outro cursor dentro de um cursor --pelos vistos um cursor pode trazer mais que uma variavel
		select SubjectID from #temp_current where StudentID = @StudentID
		open SubjectID_cursor
		Fetch next from SubjectID_cursor into @SubjectID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @failures = (select Failures from #temp_current where StudentID = @StudentID and SubjectID = @SubjectID)
			SET @media = 0
			SET @media = (select P1_grade from #temp_current where StudentID = @StudentID and SubjectID = @SubjectID) / 1.0
			SET @media = @media + (select P2_grade from #temp_current where StudentID = @StudentID and SubjectID = @SubjectID)
			SET @media = @media + (select P3_grade from #temp_current where StudentID = @StudentID and SubjectID = @SubjectID)
			SET @media = @media/3.0 --NAO E a melhor forma mas funciona por agora
			IF (@media < 9.5)
				BEGIN
					--exec registerStudentInSubject (@StudentID = @StudentID, @subjectID = @subjectID, @failures = @failures +1)
					SET @failures = @failures + 1
					exec registerStudentInSubject @studentID = @StudentID , @SubjectID = @SubjectID, @Failures = @failures;
				END
		FETCH next from SubjectID_cursor  into @SubjectID
		END
		close SubjectID_cursor
		deallocate SubjectID_cursor
	FETCH next from StudentID_cursor  into @StudentID
	END
	close StudentID_cursor
	deallocate StudentID_cursor

	drop table #temp_current
END
GO

CREATE or alter procedure endSchoolYear (@year smallint) --FECHA O ANO ESCOLAR, RECEBE O ANO
as
BEGIN
	insert into ArchiveData.Cloosed_Course (SchoolYear, SubjectID, StudentID, Failures , Absences, P1_grade, P2_grade, P3_grade)
	select  @year ,SubjectID, StudentID, Failures , Absences, P1_grade, P2_grade, P3_grade from ActiveData.Current_Course --tudo o que estava na current foi para cloosed com o ano
	DELETE FROM ActiveData.Current_Course --remover tudo do current course
END
go

--Media de notas no ano letivo por escola
create or alter procedure dbo.spMediaNotasPorEscola
as
	declare @school nvarchar(30);
	declare @sum float;
	declare @average float;
	declare @count int;
	set @sum = 0;
	set @count = 0;
	set @average = 0;

	declare School_Cursor cursor
	for select Name
		from ActiveData.School;
	open School_Cursor
	fetch next from School_Cursor into @school;

	while (@@FETCH_STATUS = 0)
	begin
		set @sum = (select sum(P1_grade)+sum(P2_grade)+sum(P3_grade)
					from ActiveData.Current_Course c
					join (select st.StudentID
						from ActiveData.Student st
						join ActiveData.School sc
						on st.SchoolID=sc.SchoolID
						where sc.Name like @school) tb
					on tb.StudentID=c.StudentID)

		set @count = (select count(P1_grade)
					from ActiveData.Current_Course c
					join (select st.StudentID
						from ActiveData.Student st
						join ActiveData.School sc
						on st.SchoolID=sc.SchoolID
						where sc.Name like @school) tb
					on tb.StudentID=c.StudentID
					where c.P1_grade is not null) + (select count(P2_grade)
													from ActiveData.Current_Course c
													join (select st.StudentID
														from ActiveData.Student st
														join ActiveData.School sc
														on st.SchoolID=sc.SchoolID
														where sc.Name like @school) tb
													on tb.StudentID=c.StudentID
													where c.P2_grade is not null) + (select count(P3_grade)
																					from ActiveData.Current_Course c
																					join (select st.StudentID
																						from ActiveData.Student st
																						join ActiveData.School sc
																						on st.SchoolID=sc.SchoolID
																						where sc.Name like @school) tb
																					on tb.StudentID=c.StudentID
																					where c.P3_grade is not null);
																
		if (@count > 0)
			set @average = @sum / @count;
		print 'Media de notas da escola ' + @school + ': ' + cast(@average as varchar(10));
		print ' ';

		set @sum = 0;
		set @count = 0;
		set @average = 0;
		fetch next from School_Cursor into @school;
	end

	close School_Cursor;
	deallocate School_Cursor;
go

exec dbo.spMediaNotasPorEscola;

--Média de notas por ano letivo e período letivo por escola
create or alter procedure dbo.spMediaNotasPorEscolaPorPeriodo
as
	declare @school nvarchar(30);
	declare @sum float;
	declare @average float;
	declare @count int;
	declare @period int;
	set @sum = 0;
	set @count = 0;
	set @average = 0;

	declare School_Cursor cursor
	for select Name
		from ActiveData.School;
	open School_Cursor
	fetch next from School_Cursor into @school;

	while (@@FETCH_STATUS = 0)
	begin
		set @sum = (select sum(P1_grade)
					from ActiveData.Current_Course c
					join (select st.StudentID
						from ActiveData.Student st
						join ActiveData.School sc
						on st.SchoolID=sc.SchoolID
						where sc.Name like @school) tb
					on tb.StudentID=c.StudentID)

		set @count = (select count(P1_grade)
					from ActiveData.Current_Course c
					join (select st.StudentID
						from ActiveData.Student st
						join ActiveData.School sc
						on st.SchoolID=sc.SchoolID
						where sc.Name like @school) tb
					on tb.StudentID=c.StudentID
					where c.P1_grade is not null);
												
		if (@count > 0)
			set @average = @sum / @count;
		print 'Media de notas da escola ' + @school + ' no 1º periodo: ' + cast(@average as varchar(10));
		print ' ';

		set @sum = 0;
		set @count = 0;
		set @average = 0;

		set @sum = (select sum(P2_grade)
					from ActiveData.Current_Course c
					join (select st.StudentID
						from ActiveData.Student st
						join ActiveData.School sc
						on st.SchoolID=sc.SchoolID
						where sc.Name like @school) tb
					on tb.StudentID=c.StudentID)

		set @count = (select count(P2_grade)
					from ActiveData.Current_Course c
					join (select st.StudentID
						from ActiveData.Student st
						join ActiveData.School sc
						on st.SchoolID=sc.SchoolID
						where sc.Name like @school) tb
					on tb.StudentID=c.StudentID
					where c.P2_grade is not null);
												
		if (@count > 0)
			set @average = @sum / @count;
		print 'Media de notas da escola ' + @school + ' no 2º periodo: ' + cast(@average as varchar(10));
		print ' ';

		set @sum = 0;
		set @count = 0;
		set @average = 0;

		set @sum = (select sum(P3_grade)
					from ActiveData.Current_Course c
					join (select st.StudentID
						from ActiveData.Student st
						join ActiveData.School sc
						on st.SchoolID=sc.SchoolID
						where sc.Name like @school) tb
					on tb.StudentID=c.StudentID)

		set @count = (select count(P3_grade)
					from ActiveData.Current_Course c
					join (select st.StudentID
						from ActiveData.Student st
						join ActiveData.School sc
						on st.SchoolID=sc.SchoolID
						where sc.Name like @school) tb
					on tb.StudentID=c.StudentID
					where c.P3_grade is not null);
												
		if (@count > 0)
			set @average = @sum / @count;
		print 'Media de notas da escola ' + @school + ' no 3º periodo: ' + cast(@average as varchar(10));
		print ' ';

		set @sum = 0;
		set @count = 0;
		set @average = 0;
		fetch next from School_Cursor into @school;
	end

	close School_Cursor;
	deallocate School_Cursor;
go

exec dbo.spMediaNotasPorEscolaPorPeriodo;

--Lançar Nota
create or alter procedure dbo.spLancarNota @student nvarchar(30), @subject nvarchar(30), @period int, @grade float
as
	declare @studentID int
	declare @subjectID int

	set @studentID = (select s.StudentId
					from ActiveData.Student s
					join ActiveData.Sys_User u
					on s.UserID=u.UserID
					where u.Name like @student);

	set @subjectID = (select SubjectID
					from ActiveData.Subject
					where Name like @subject);

	if(@period = 1)
		if((select P1_grade
			from ActiveData.Current_Course
			where StudentID=@studentID and SubjectID=@subjectID) is null)
			update ActiveData.Current_Course
			set P1_grade = @grade
			where StudentID=@studentID and SubjectID=@subjectID;
		else
			print 'Nota já Lançada'
	if(@period = 2)
		if((select P2_grade
			from ActiveData.Current_Course
			where StudentID=@studentID and SubjectID=@subjectID) is null)
			update ActiveData.Current_Course
			set P2_grade = @grade
			where StudentID=@studentID and SubjectID=@subjectID;
		else
			print 'Nota já Lançada'
	if(@period = 3)
		if((select P3_grade
			from ActiveData.Current_Course
			where StudentID=@studentID and SubjectID=@subjectID) is null)
			update ActiveData.Current_Course
			set P3_grade = @grade
			where StudentID=@studentID and SubjectID=@subjectID;
		else
			print 'Nota já Lançada'
go

exec dbo.spLancarNota @student='Nuno Reis', @subject='MAT-2', @period=1, @grade=15;

--Inscrever aluno numa disciplina
create or alter procedure dbo.spInscreverAluno @student nvarchar(30), @subject nvarchar(30)
as
	declare @studentID int
	declare @subjectID int

	set @studentID = (select s.StudentId
					from ActiveData.Student s
					join ActiveData.Sys_User u
					on s.UserID=u.UserID
					where u.Name like @student);

	set @subjectID = (select SubjectID
					from ActiveData.Subject
					where Name like @subject);

	
	INSERT INTO ActiveData.Current_Course(SubjectID, StudentID) values (@subjectID, @studentID)
go

exec dbo.spInscreverAluno @student='Nuno Reis', @subject='MAT-2';

--Atualizar Nota
create or alter procedure dbo.spAtualizarNota @student nvarchar(30), @subject nvarchar(30), @period int, @grade float
as
	declare @studentID int
	declare @subjectID int

	set @studentID = (select s.StudentId
					from ActiveData.Student s
					join ActiveData.Sys_User u
					on s.UserID=u.UserID
					where u.Name like @student);

	set @subjectID = (select SubjectID
					from ActiveData.Subject
					where Name like @subject);

	if(@period = 1)
		if((select P1_grade
			from ActiveData.Current_Course
			where StudentID=@studentID and SubjectID=@subjectID) is not null)
			update ActiveData.Current_Course
			set P1_grade = @grade
			where StudentID=@studentID and SubjectID=@subjectID;
		else
			print 'Nota não Lançada'
	if(@period = 2)
		if((select P2_grade
			from ActiveData.Current_Course
			where StudentID=@studentID and SubjectID=@subjectID) is not null)
			update ActiveData.Current_Course
			set P2_grade = @grade
			where StudentID=@studentID and SubjectID=@subjectID;
		else
			print 'Nota não Lançada'
	if(@period = 3)
		if((select P3_grade
			from ActiveData.Current_Course
			where StudentID=@studentID and SubjectID=@subjectID) is not null)
			update ActiveData.Current_Course
			set P3_grade = @grade
			where StudentID=@studentID and SubjectID=@subjectID;
		else
			print 'Nota não Lançada'
go

exec dbo.spAtualizarNota @student='Nuno Reis', @subject='MAT-2', @period=3, @grade=20;

--Total de alunos inscritos em cada uma das disciplinas no ano aberto face ao ano
--anterior e a respetiva taxa de crescimento.
create or alter procedure dbo.spTotalAlunosInscritos
as
	declare @totalAlunos int;
	declare @taxaCrescimento float;
	declare @subject nvarchar(30);
	set @taxaCrescimento = 0;
	set @totalAlunos = 0;

	declare Subject_Cursor cursor
	for select Name
		from ActiveData.Subject;
	open Subject_Cursor
	fetch next from Subject_Cursor into @subject;

	while (@@FETCH_STATUS = 0)
	begin
		print 'Disciplina: ' + @subject;

		set @totalAlunos = (select count(*)
							from ActiveData.Current_Course c
							join ActiveData.Subject s
							on s.SubjectID=c.SubjectID
							where s.Name like @subject)

		print 'Total de alunos inscritos: ' + cast(@totalAlunos as varchar(10));
		print 'Taxa de crescimento: ' + cast(@taxaCrescimento as varchar(10));

		print ' '	
		set @totalAlunos = 0;
		set @taxaCrescimento = 0;
		fetch next from Subject_Cursor into @subject;
	end

	close Subject_Cursor;
	deallocate Subject_Cursor;
go

exec dbo.spTotalAlunosInscritos

--Total de alunos por escola/ano letivo
create or alter procedure dbo.spTotalAlunosEscola  @school nvarchar(30)
as
	select count(*)
	from ActiveData.Student st
	join ActiveData.School sc
	on st.SchoolID=sc.SchoolID
	where sc.Name like @school
go

exec dbo.spTotalAlunosEscola @school='GP'

--Consultar notas
create or alter procedure dbo.spConsultarNotas @userMail nvarchar(30), @password nvarchar(30), @studentName nvarchar(30)
as
	declare @guardianID int;
	declare @guardian int;
	set @guardianID = (select GuardianID
						from ActiveData.Guardian g
						join ActiveData.Sys_User u
						on g.UserID=u.UserID
						where u.Mail like @userMail);

	if @guardianID>0
		set @guardian = (select s.StudentID
						from ActiveData.Guardian g
						join ActiveData.Student s
						on g.GuardianID=s.GuardianID
						join ActiveData.Sys_User u
						on s.UserID=u.UserID
						where g.GuardianID=@guardianID
						and u.Name like @studentName);
	else
		set @guardian = (select s.StudentID
						from ActiveData.Student s
						join ActiveData.Sys_User u
						on s.UserID=u.UserID
						where u.Name like @studentName
						and u.Mail like @userMail);

	if @guardian>0
	begin
		select u.Name, c.SchoolYear, su.Name, c.P1_grade, c.P2_grade, c.P3_grade
		from ArchiveData.Cloosed_Course c
		join ActiveData.Student st
		on c.StudentID=st.StudentID
		join ActiveData.Subject su
		on c.SubjectID=su.SubjectID
		join ActiveData.Sys_User u
		on st.UserID=u.UserID
		where u.Name like @studentName;
		select u.Name, su.Name, c.P1_grade, c.P2_grade, c.P3_grade
		from ActiveData.Current_Course c
		join ActiveData.Student st
		on c.StudentID=st.StudentID
		join ActiveData.Subject su
		on c.SubjectID=su.SubjectID
		join ActiveData.Sys_User u
		on st.UserID=u.UserID
		where u.Name like @studentName;
	end
go

exec dbo.spConsultarNotas @userMail='filho@gmail.com', @password='123', @studentName='Filho'

Create or alter procedure recoverPasswordRequest (@mail nvarchar(70)) 
as
BEGIN
	IF EXISTS (select * from ActiveData.Sys_User where Mail = @mail)
	BEGIN
		insert into servidorMail (mailReceiver, tokenNumber, mailDateTime) VALUES (@mail, 'something', CURRENT_TIMESTAMP)
	END
	ELSE
	BEGIN
		PRINT N'ENVIAR ERRO A DIZER QUE NAO EXISTE ESSE USER';
	END
END

Create or alter procedure changePassword (@mail nvarchar(70), @newPassword1 nvarchar(32), @newPassword2 nvarchar(32))
as
BEGIN
declare @passwordHashed nvarchar (32)
	IF (@newPassword1 = @newPassword2) 
	BEGIN
		set @passwordHashed = dbo.fnHashPassword (@newPassword1)
		UPDATE ActiveData.Sys_User
		SET Password =  @passwordHashed
		where Mail = @mail
	END
END

Create or alter procedure tokenPasswordChange (@mail nvarchar(70), @tokenNumber nvarchar (10), @newPassword1 nvarchar(32), @newPassword2 nvarchar(32))
as
BEGIN
declare @tempoParaReset smallint
set @tempoParaReset = 60;
declare @tempoToken datetime 
	IF EXISTS (select * from ActiveData.Sys_User where Mail = @mail)
	BEGIN
		IF EXISTS (select * from servidorMail where mailReceiver = @mail AND tokenNumber = @tokenNumber)
		BEGIN
			set @tempoToken = (select mailDatetime from servidorMail where mailReceiver = @mail AND tokenNumber = @tokenNumber)
			IF (DATEDIFF (MINUTE, @tempoToken, CURRENT_TIMESTAMP) <= @tempoParaReset )
				BEGIN
					exec changePassword(@mail, @newPassowrd1, @newPassword2)
				END
			ELSE
				BEGIN
					PRINT N'ENVIAR ERRO A DIZER QUE O TOKEN EXPIROU';
				END
		END
		ELSE
		BEGIN
			PRINT N'ENVIAR ERRO A DIZER QUE NAO HA ESSE TOKEN PARA ESSE USER';
		END
	END
	ELSE
	BEGIN
		PRINT N'ENVIAR ERRO A DIZER QUE NAO EXISTE ESSE USER';
	END
END

Create or alter procedure changeToNewPassword (@mail nvarchar(70),@oldPassword nvarchar(32) , @newPassword1 nvarchar(32), @newPassword2 nvarchar(32))
as
BEGIN
	declare @hashedPW nvarchar (32)
	set @hashedPW = dbo.fnHashPassword(@oldPassword)
	IF EXISTS (select * from ActiveData.Sys_User where Mail = @mail AND Password = @hashedPW)
	BEGIN
		exec changePassword(@mail, @newPassowrd1, @newPassword2)
	END
	ELSE
	BEGIN
		PRINT N'ENVIAR ERRO A DIZER QUE COMBINACAO USER PASSWORD NAO EXISTE';
	END
END



---MIGRATION CODE

--procedimento de importacao
	exec migrateOldData
--drop procedure migrateOldData
CREATE or alter procedure migrateOldData -- CORRER DPS DA QUERY Q POPULA O SCHEMA OLD DATA COM A OLD DATA DATABASE
as
BEGIN
DECLARE @StudentID_curs nvarchar (20)
DECLARE @StudentID int
DECLARE @School nvarchar (60)
DECLARE @Year int
DECLARE @Sex nvarchar
DECLARE @BirthDate datetime
DECLARE @Address bit
DECLARE @FamSize bit
DECLARE @PStatus bit
DECLARE @AddressIN nvarchar(50)
DECLARE @FamSizeIN nvarchar(50)
DECLARE @PStatusIN nvarchar(50)
DECLARE @MEdu tinyint
DECLARE @FEdu tinyint
DECLARE @MJob nvarchar (20)
DECLARE @FJob nvarchar (20)
DECLARE @Reason nvarchar (20)
DECLARE @GuardianRelation nvarchar (20)
DECLARE @TravelTime tinyint
DECLARE @StudyTime tinyint
DECLARE @Failures tinyint
DECLARE @SchoolSup bit
DECLARE @FamSup bit
DECLARE @Paid bit
DECLARE @Activities bit
DECLARE @Nursery bit
DECLARE @Higher bit
DECLARE @Internet bit
DECLARE @Romantic bit
DECLARE @SchoolSupIN nvarchar(50)
DECLARE @FamSupIN nvarchar(50)
DECLARE @PaidIN nvarchar(50)
DECLARE @ActivitiesIN nvarchar(50)
DECLARE @NurseryIN nvarchar(50)
DECLARE @HigherIN nvarchar(50)
DECLARE @InternetIN nvarchar(50)
DECLARE @RomanticIN nvarchar(50)
DECLARE @FamRel tinyint
DECLARE @FreeTime tinyint
DECLARE @GoOut tinyint
DECLARE @Dalc tinyint
DECLARE @Walc tinyint
DECLARE @Health tinyint
DECLARE @Absences tinyint
DECLARE @P1 tinyint
DECLARE @P2 tinyint
DECLARE @P3 tinyint

DECLARE @sql NVARCHAR(MAX)
DECLARE @sql1 NVARCHAR(MAX)
DECLARE @ParmDefinition NVARCHAR(500);


DECLARE @SchoolID int
DECLARE @SubjectName nvarchar (15)
DECLARE @SubjectID int
DECLARE @mail nvarchar (60)
SET @mail = NULL
DECLARE @TabelaVelha nvarchar (50)
DECLARE Cur1 CURSOR FOR SELECT t.name as table_name from sys.tables t where schema_name(t.schema_id) = 'OldData'; --CORRER TODAS AS TABELAS Q METI NO OLD DATA
OPEN Cur1
FETCH NEXT FROM Cur1 INTO @TabelaVelha;
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SubjectName = SUBSTRING(@TabelaVelha, 15, LEN(@TabelaVelha) - 16)
	SET @sql = N'DECLARE StudentNumber_cursor CURSOR FOR select [Student Number] from OldData.[' + @TabelaVelha + ']';
	--DECLARE StudentNumber_cursor CURSOR FOR -----COMO FAZER ISTO SEM O REPLACE?
	--select (replace('select [Student Number] from OldData.[tab]','[tab]', @TabelaVelha))--CORRER TODAS AS LINHAS DA TABELA
	exec sp_executesql @sql
	--FUNCINOU PELOS VISTOS 
	open StudentNumber_cursor
	--codigo
	Fetch next from StudentNumber_cursor into @StudentID_curs
	print (@StudentID)
	WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @StudentID = CONVERT(int, @StudentID_curs)
		---------------------CARREGAR VALORES PARA AS VARIAVEIS 
				SET @sql = CONCAT (N'SET @School = (select school from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@School nvarchar (60) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @School = @School OUTPUT
				SET @sql = CONCAT (N'SET @Year = (select year from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@Year nvarchar (60) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @Year = @Year OUTPUT
				SET @sql = CONCAT (N'SET @sex = (select sex from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@sex nvarchar (60) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @sex = @sex OUTPUT				
				SET @sql = CONCAT (N'SET @BirthDate = (select [Birth Date] from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@BirthDate datetime OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @BirthDate = @BirthDate OUTPUT
				SET @sql = CONCAT (N'SET @AddressIN = (select address from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@AddressIN nvarchar(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @AddressIN = @AddressIN OUTPUT
				IF (@AddressIN LIKE 'U')
					BEGIN
						SET @Address = 0
					END
				ELSE
					BEGIN
						SET @Address = 1
					END
				--O ADDRESS DEVE ESTAR NA TABELA DE ADDRESS
				
				SET @sql = CONCAT (N'SET @FamSizeIN = (select famsize from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@FamSizeIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @FamSizeIN = @FamSizeIN OUTPUT
				IF (@FamSizeIN LIKE 'LE3')
					BEGIN
						SET @FamSize = 0
					END
				ELSE
					BEGIN
						SET @FamSize = 1
					END
				
				SET @sql = CONCAT (N'SET @PStatusIN = (select Pstatus from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@PStatusIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @PStatusIN = @PStatusIN OUTPUT
				IF (@PStatusIN LIKE 'T')
					BEGIN
						SET @PStatus = 0
					END
				ELSE
					BEGIN
						SET @PStatus = 1
					END
				
				SET @sql = CONCAT (N'SET @MEdu = (select Medu from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@MEdu tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @MEdu = @MEdu OUTPUT
				
				SET @sql = CONCAT (N'SET @FEdu = (select Fedu from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@FEdu tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @FEdu = @FEdu OUTPUT
				
				SET @sql = CONCAT (N'SET @Mjob = (select Mjob from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@Mjob NVARCHAR(20) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @Mjob = @Mjob OUTPUT
				
				SET @sql = CONCAT (N'SET @Fjob = (select Fjob from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@Fjob NVARCHAR(20) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @Fjob = @Fjob OUTPUT
				
				SET @sql = CONCAT (N'SET @Reason = (select reason from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@Reason NVARCHAR(20) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @Reason = @Reason OUTPUT
				
				SET @sql = CONCAT (N'SET @GuardianRelation = (select guardian from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@GuardianRelation NVARCHAR(20) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @GuardianRelation = @GuardianRelation OUTPUT
				
				SET @sql = CONCAT (N'SET @TravelTime = (select traveltime from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@TravelTime tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @TravelTime = @TravelTime OUTPUT
				
				SET @sql = CONCAT (N'SET @StudyTime = (select studytime from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@StudyTime tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @StudyTime = @StudyTime OUTPUT
				
				SET @sql = CONCAT (N'SET @SchoolSupIN = (select schoolsup from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@SchoolSupIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @SchoolSupIN = @SchoolSupIN OUTPUT
				IF (@SchoolSupIN LIKE 'no')
					BEGIN
						SET @SchoolSup = 0
					END
				ELSE
					BEGIN
						SET @SchoolSup = 1
					END
				
				SET @sql = CONCAT (N'SET @FamSupIN = (select famsup from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@FamSupIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @FamSupIN = @FamSupIN OUTPUT
				IF (@FamSupIN LIKE 'no')
					BEGIN
						SET @FamSup = 0
					END
				ELSE
					BEGIN
						SET @FamSup = 1
					END
				
				SET @sql = CONCAT (N'SET @PaidIN = (select paid from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@PaidIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @PaidIN = @PaidIN OUTPUT
				IF (@PaidIN LIKE 'no')
					BEGIN
						SET @Paid = 0
					END
				ELSE
					BEGIN
						SET @Paid = 1
					END
				
				SET @sql = CONCAT (N'SET @ActivitiesIN = (select activities from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@ActivitiesIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @ActivitiesIN = @ActivitiesIN OUTPUT
				IF (@ActivitiesIN LIKE 'no')
					BEGIN
						SET @Activities = 0
					END
				ELSE
					BEGIN
						SET @Activities = 1
					END
				
				SET @sql = CONCAT (N'SET @NurseryIN = (select nursery from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@NurseryIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @NurseryIN = @NurseryIN OUTPUT
				IF (@NurseryIN LIKE 'no')
					BEGIN
						SET @Nursery = 0
					END
				ELSE
					BEGIN
						SET @Nursery = 1
					END
				
				SET @sql = CONCAT (N'SET @HigherIN = (select higher from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@HigherIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @HigherIN = @HigherIN OUTPUT
				IF (@HigherIN LIKE 'no')
					BEGIN
						SET @Higher = 0
					END
				ELSE
					BEGIN
						SET @Higher = 1
					END
				
				SET @sql = CONCAT (N'SET @InternetIN = (select internet from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@InternetIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @InternetIN = @InternetIN OUTPUT
				IF (@InternetIN LIKE 'no')
					BEGIN
						SET @Internet = 0
					END
				ELSE
					BEGIN
						SET @Internet = 1
					END
				
				SET @sql = CONCAT (N'SET @RomanticIN = (select romantic from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@RomanticIN NVARCHAR(50) OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @RomanticIN = @RomanticIN OUTPUT
				IF (@RomanticIN LIKE 'no')
					BEGIN
						SET @Romantic = 0
					END
				ELSE
					BEGIN
						SET @Romantic = 1
					END
				
				SET @sql = CONCAT (N'SET @FamRel = (select famrel from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@FamRel tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @FamRel = @FamRel OUTPUT
				
				SET @sql = CONCAT (N'SET @FreeTime = (select freetime from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@FreeTime tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @FreeTime = @FreeTime OUTPUT
				
				SET @sql = CONCAT (N'SET @GoOut = (select goout from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@GoOut tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @GoOut = @GoOut OUTPUT
				
				SET @sql = CONCAT (N'SET @Dalc = (select Dalc from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@Dalc tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @Dalc = @Dalc OUTPUT
				
				SET @sql = CONCAT (N'SET @Walc = (select Walc from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@Walc tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @Walc = @Walc OUTPUT
				
				SET @sql = CONCAT (N'SET @Health = (select health from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@Health tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @Health = @Health OUTPUT
				
				SET @sql = CONCAT (N'SET @Failures = (select failures from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@Failures tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @Failures = @Failures OUTPUT
				
				SET @sql = CONCAT (N'SET @Absences = (select absences from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@Absences tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @Absences = @Absences OUTPUT
				
				SET @sql = CONCAT (N'SET @P1 = (select P1 from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@P1 tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @P1 = @P1 OUTPUT
				
				SET @sql = CONCAT (N'SET @P2 = (select P2 from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@P2 tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @P2 = @P2 OUTPUT
				
				SET @sql = CONCAT (N'SET @P3 = (select P3 from OldData.[', @TabelaVelha, '] where [Student Number] =  ',@StudentID ,' )')
				SET @ParmDefinition = N'@P3 tinyint OUTPUT';
				exec sp_executesql @sql, @ParmDefinition, @P3 = @P3 OUTPUT
		---------------------
		print (@StudentID)
		IF NOT EXISTS (SELECT * FROM ActiveData.School WHERE Name = @School)
		BEGIN
			insert into ActiveData.School(Name) values (@School)
		END
		SET @SchoolID = (select SchoolID from ActiveData.School where Name = @School)
		IF NOT EXISTS (SELECT * FROM ActiveData.Student WHERE StudentID = @StudentID) --ver se o aluno ja esta na tabela 
			BEGIN
				exec insertNewStudent @mail = @mail, @name= 'Temp Name', @gender = @Sex, @birthdate = @birthdate, @addressType = @Address, @famSize = @famSize, @Pstatus = @Pstatus, @Medu = @Medu, @Fedu = @Fedu, @Mjob = @Mjob, @Fjob = @Fjob, @reason = @reason, @guardianRelation = @guardianRelation, @traveltime = @traveltime, @studytime = @studytime, @schoolsup = @schoolsup, @famsup = @famsup, @paid = @paid, @activities = @activities, @nursery = @nursery, @higher = @higher, @internet = @internet, @romantic = @romantic, @famrel = @famrel, @freetime = @freetime, @goout = @goout, @Dalc = @Dalc, @Walc = @Walc, @health = @health, @schoolID = @SchoolID --INSERE O ALUNO NA TABELA DE ALUNOS é melhor criar um stored procedure
			END
		IF NOT EXISTS (SELECT * FROM ActiveData.Subject WHERE Name = @SubjectName) --ver se a disciplina ja esta na tabela 
			BEGIN
				exec insertNewSubject @name = @SubjectName
			END
		--AQUI A DISCIPLINA JA EXISTE DE CERTEZA POR ISSO
		SET @SubjectID = (select SubjectID from ActiveData.Subject where Name = @SubjectName)
		--DEPOIS DE TUDO METER OS CAMPOS NA TABELA CLOOSED COURSE
		exec insertRowCloosed_Course @schoolyear = @Year, @subjectID = @SubjectID, @studentID = @StudentID, @failures = @Failures , @absences = @Absences, @P1_grade =@P1, @P2_grade = @P2, @P3_grade = @P3
		FETCH next from StudentNumber_cursor  into @StudentID_curs
	END
	close StudentNumber_cursor
	deallocate StudentNumber_cursor
	FETCH NEXT FROM Cur1 INTO @tabelaVelha;
END
CLOSE Cur1;
deallocate Cur1;
END




--TABLE VALUE USER DEFINED FUNCTIONS (substituir views +/-)
--POR TESTAR 
--so esta a returnar a ultima
CREATE FUNCTION fnGetStudentGrades(@StudentID int)
RETURNS @retStudentGrades TABLE 
(
    -- Columns returned by the function
	SchoolYear smallint NOT NULL,
    StudentID int NOT NULL,
	SubjectID int NOT NULL,
	P1_grade tinyint,
	P2_grade tinyint,
	P3_grade tinyint
)
AS 
-- 
BEGIN
	IF @StudentID IS NOT NULL 
    BEGIN
    insert into @retStudentGrades SELECT SchoolYear, StudentID, SubjectID, P1_grade, P2_grade, P3_grade
    FROM ArchiveData.Cloosed_Course
    WHERE StudentID = @StudentID;
    END;
    RETURN;
END;


--select * from ArchiveData.Cloosed_Course where StudentID = 1
--select * from fnGetStudentGrades (1)






--CALCULOS
CREATE TABLE #SpaceUsed (
	 TableName sysname
	,NumRows BIGINT
	,ReservedSpace VARCHAR(50)
	,DataSpace VARCHAR(50)
	,IndexSize VARCHAR(50)
	,UnusedSpace VARCHAR(50)
	) 

DECLARE @str VARCHAR(500)
SET @str =  'exec sp_spaceused ''?'''
INSERT INTO #SpaceUsed 
EXEC sp_msforeachtable @command1=@str

SELECT * FROM #SpaceUsed ORDER BY TableName
SELECT TableName, NumRows, 
CONVERT(numeric(18,0),REPLACE(ReservedSpace,' KB','')) / 1024 as ReservedSpace_MB,
CONVERT(numeric(18,0),REPLACE(DataSpace,' KB','')) / 1024 as DataSpace_MB,
CONVERT(numeric(18,0),REPLACE(IndexSize,' KB','')) / 1024 as IndexSpace_MB,
CONVERT(numeric(18,0),REPLACE(UnusedSpace,' KB','')) / 1024 as UnusedSpace_MB
FROM #SpaceUsed
ORDER BY ReservedSpace_MB desc

select name, max_length
from sys.columns
where object_NAME(object_id) = 'Cloosed_Course'