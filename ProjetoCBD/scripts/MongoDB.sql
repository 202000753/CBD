/*MongoDB
Nuno Reis		202000753*/

use ProjectoCBD
go


select *
from ActiveData.School;

select *
from ActiveData.Subject;

select g.GuardianID, u.Name, u.Mail, u.Password
from ActiveData.Guardian g
join ActiveData.Sys_User u
on g.UserID=u.UserID;

select s.StudentID, u.Name, u.Mail, u.Password, s.GuardianID, s.Gender, s.SchoolID
from ActiveData.Student s
join ActiveData.Sys_User u
on s.UserID=u.UserID;

select *
from ArchiveData.Cloosed_Course;