/*Niveis de Acesso à Informação
Nuno Reis		202000753*/
----------------------------------------------------------------------------------------------------
-- Views
----------------------------------------------------------------------------------------------------
use ProjectoCBD
go

create view [StudentGP] as
select st.*
from ActiveData.Student st
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'GP';
go

create view [Sys_UserGP] as
select s.*
from ActiveData.Sys_User s
join ActiveData.Student st
on st.UserID=s.UserID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'GP';
go

create view [AddressGP] as
select a.*
from ActiveData.Address a
join ActiveData.UserAddress ua
on ua.AddressID=a.AddressID
join ActiveData.Sys_User s
on s.UserID=ua.UserID
join ActiveData.Student st
on st.UserID=s.UserID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'GP';
go

create view [GuardianGP] as
select g.*
from ActiveData.Guardian g
join ActiveData.Student st
on st.GuardianID=g.GuardianID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'GP';
go

create view [Cloosed_CourseGP] as
select clc.*
from ArchiveData.Cloosed_Course clc
join ActiveData.Student st
on st.StudentID=clc.StudentID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'GP';
go

create view [SubjectCloosed_CourseGP] as
select s.*
from ActiveData.Subject s
join ArchiveData.Cloosed_Course clc
on clc.SubjectID=s.SubjectID
join ActiveData.Student st
on st.StudentID=clc.StudentID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'GP';
go

create view [Current_CourseGP] as
select cuc.*
from ActiveData.Current_Course cuc
join ActiveData.Student st
on st.StudentID=cuc.StudentID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'GP';
go

create view [SubjectCurrent_CourseGP] as
select s.*
from ActiveData.Subject s
join ActiveData.Current_Course cuc
on cuc.SubjectID=s.SubjectID
join ActiveData.Student st
on st.StudentID=cuc.StudentID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'GP';
go


create view [StudentMS] as
select st.*
from ActiveData.Student st
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'MS';
go

create view [Sys_UserMS] as
select s.*
from ActiveData.Sys_User s
join ActiveData.Student st
on st.UserID=s.UserID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'MS';
go

create view [AddressMS] as
select a.*
from ActiveData.Address a
join ActiveData.UserAddress ua
on ua.AddressID=a.AddressID
join ActiveData.Sys_User s
on s.UserID=ua.UserID
join ActiveData.Student st
on st.UserID=s.UserID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'MS';
go

create view [GuardianMS] as
select g.*
from ActiveData.Guardian g
join ActiveData.Student st
on st.GuardianID=g.GuardianID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'MS';
go

create view [Cloosed_CourseMS] as
select clc.*
from ArchiveData.Cloosed_Course clc
join ActiveData.Student st
on st.StudentID=clc.StudentID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'MS';
go

create view [SubjectCloosed_CourseMS] as
select s.*
from ActiveData.Subject s
join ArchiveData.Cloosed_Course clc
on clc.SubjectID=s.SubjectID
join ActiveData.Student st
on st.StudentID=clc.StudentID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'MS';
go

create view [Current_CourseMS] as
select cuc.*
from ActiveData.Current_Course cuc
join ActiveData.Student st
on st.StudentID=cuc.StudentID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'MS';
go

create view [SubjectCurrent_CourseMS] as
select s.*
from ActiveData.Subject s
join ActiveData.Current_Course cuc
on cuc.SubjectID=s.SubjectID
join ActiveData.Student st
on st.StudentID=cuc.StudentID
join ActiveData.School sc
on st.SchoolID=sc.SchoolID
where sc.Name like 'MS';
go

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
CREATE ROLE administrador;  
CREATE ROLE logUser;  
CREATE ROLE escola;  
CREATE ROLE utilizador;

--
grant control to administrador;
grant select to administrador;
grant insert to administrador;
grant update to administrador;
grant create table to administrador;
grant delete to administrador;

--
CREATE LOGIN LlogUserMS with password = 'PASSWORD';
CREATE USER UserMS FOR LOGIN LlogUserMS;
EXEC sp_addrolemember 'logUser', 'UserMS';

CREATE LOGIN LlogUserGP with password = 'PASSWORD';
CREATE USER UserGP FOR LOGIN LlogUserGP;
EXEC sp_addrolemember 'logUser', 'UserGP';


grant select on [dbo].[AddressMS] to UserMS
grant select on [dbo].[Cloosed_CourseMS] to UserMS
grant select on [dbo].[Current_CourseMS] to UserMS
grant select on [dbo].[GuardianMS] to UserMS
grant select on [dbo].[StudentMS] to UserMS
grant select on [dbo].[SubjectCloosed_CourseMS] to UserMS
grant select on [dbo].[SubjectCurrent_CourseMS] to UserMS
grant select on [dbo].[Sys_UserMS] to UserMS

grant select on [dbo].[AddressGP] to UserGP
grant select on [dbo].[Cloosed_CourseGP] to UserGP
grant select on [dbo].[Current_CourseGP] to UserGP
grant select on [dbo].[GuardianGP] to UserGP
grant select on [dbo].[StudentGP] to UserGP
grant select on [dbo].[SubjectCloosed_CourseGP] to UserGP
grant select on [dbo].[SubjectCurrent_CourseGP] to UserGP
grant select on [dbo].[Sys_UserGP] to UserGP

--
grant insert to escola;
grant update to escola;

CREATE LOGIN LescolaMS with password = 'PASSWORD';
CREATE USER UserEscolaMS FOR LOGIN LescolaMS;
EXEC sp_addrolemember 'escola', 'UserescolaMS';

CREATE LOGIN LescolaGP with password = 'PASSWORD';
CREATE USER UserEscolaGP FOR LOGIN LescolaGP;
EXEC sp_addrolemember 'escola', 'UserescolaGP';


grant select on [dbo].[AddressMS] to UserEscolaMS
grant select on [dbo].[Cloosed_CourseMS] to UserEscolaMS
grant select on [dbo].[Current_CourseMS] to UserEscolaMS
grant select on [dbo].[GuardianMS] to UserEscolaMS
grant select on [dbo].[StudentMS] to UserEscolaMS
grant select on [dbo].[SubjectCloosed_CourseMS] to UserEscolaMS
grant select on [dbo].[SubjectCurrent_CourseMS] to UserEscolaMS
grant select on [dbo].[Sys_UserMS] to UserEscolaMS

grant select on [dbo].[AddressGP] to UserEscolaGP
grant select on [dbo].[Cloosed_CourseGP] to UserEscolaGP
grant select on [dbo].[Current_CourseGP] to UserEscolaGP
grant select on [dbo].[GuardianGP] to UserEscolaGP
grant select on [dbo].[StudentGP] to UserEscolaGP
grant select on [dbo].[SubjectCloosed_CourseGP] to UserEscolaGP
grant select on [dbo].[SubjectCurrent_CourseGP] to UserEscolaGP
grant select on [dbo].[Sys_UserGP] to UserEscolaGP
go

--
create view [Cloosed_CourseEstudante] as
select u.Name as Aluno, su.Name, cc.P1_grade, cc.P2_grade, cc.P3_grade, cc.Absences, cc.Failures, cc.SchoolYear, sc.Name as Escola
from ArchiveData.Cloosed_Course cc
join ActiveData.Student s
on s.StudentID=cc.StudentID
join ActiveData.Sys_User u
on s.UserID=u.UserID
join ActiveData.Subject su
on su.SubjectID=cc.SubjectID
join ActiveData.School sc
on sc.SchoolID=s.SchoolID
where u.Name like 'Student1';
go

create view [Current_CourseEstudante] as
select u.Name as Aluno, su.Name, cc.P1_grade, cc.P2_grade, cc.P3_grade, cc.Absences, cc.Failures, sc.Name as Escola
from ArchiveData.Cloosed_Course cc
join ActiveData.Student s
on s.StudentID=cc.StudentID
join ActiveData.Sys_User u
on s.UserID=u.UserID
join ActiveData.Subject su
on su.SubjectID=cc.SubjectID
join ActiveData.School sc
on sc.SchoolID=s.SchoolID
where u.Name like 'Student1';
go


CREATE LOGIN Estudante with password = 'PASSWORD';
CREATE USER UserEstudante FOR LOGIN Estudante;
EXEC sp_addrolemember 'utilizador', 'UserEstudante';

grant select on [dbo].[Cloosed_CourseEstudante] to UserEstudante
grant select on [dbo].[Current_CourseEstudante] to UserEstudante