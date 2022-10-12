select *
from ActiveData.Address;

select *
from ActiveData.School;

select *
from ActiveData.Subject;

select *
from ActiveData.Sys_User;

select *
from ActiveData.UserAddress;

select *
from ActiveData.Student;

select *
from ActiveData.Student_MultiLanguage;

select *
from ActiveData.Guardian;

select *
from ActiveData.ServidorMail;

select *
from ActiveData.Current_Course;

select *
from ArchiveData.Cloosed_Course;







select count(*)
from [OldData].['2017 student-BD$'];

select count(*)
from ArchiveData.Cloosed_Course cc
join ActiveData.Subject s
on cc.SubjectID=s.SubjectID
where cc.SchoolYear=2017 and s.Name like 'BD';

select count(*)
from [OldData].['2017 student-CBD$'];

select count(*)
from ArchiveData.Cloosed_Course cc
join ActiveData.Subject s
on cc.SubjectID=s.SubjectID
where cc.SchoolYear=2017 and s.Name like 'CBD';

select count(*)
from [OldData].['2017 student-MAT1$'];

select count(*)
from ArchiveData.Cloosed_Course cc
join ActiveData.Subject s
on cc.SubjectID=s.SubjectID
where cc.SchoolYear=2017 and s.Name like 'MAT1';

select count(*)
from [OldData].['2018 student-BD$'];

select count(*)
from ArchiveData.Cloosed_Course cc
join ActiveData.Subject s
on cc.SubjectID=s.SubjectID
where cc.SchoolYear=2018 and s.Name like 'BD';

select count(*)
from [OldData].['2018 student-CBD$'];

select count(*)
from ArchiveData.Cloosed_Course cc
join ActiveData.Subject s
on cc.SubjectID=s.SubjectID
where cc.SchoolYear=2018 and s.Name like 'CBD';

select count(*)
from [OldData].['2018 student-MAT1$'];

select count(*)
from ArchiveData.Cloosed_Course cc
join ActiveData.Subject s
on cc.SubjectID=s.SubjectID
where cc.SchoolYear=2018 and s.Name like 'MAT1';

select count(*)
from [OldData].['2019 student-BD$'];

select count(*)
from ArchiveData.Cloosed_Course cc
join ActiveData.Subject s
on cc.SubjectID=s.SubjectID
where cc.SchoolYear=2019 and s.Name like 'BD';

select count(*)
from [OldData].['2019 student-CBD$'];

select count(*)
from ArchiveData.Cloosed_Course cc
join ActiveData.Subject s
on cc.SubjectID=s.SubjectID
where cc.SchoolYear=2019 and s.Name like 'CBD';

select count(*)
from [OldData].['2019 student-MAT1$'];

select count(*)
from ArchiveData.Cloosed_Course cc
join ActiveData.Subject s
on cc.SubjectID=s.SubjectID
where cc.SchoolYear=2019 and s.Name like 'MAT1';