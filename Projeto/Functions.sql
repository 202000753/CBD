/*Funções
Tiago Paixão	201000625
Nuno Reis		202000753*/

use ProjectoCBD
go

CREATE FUNCTION fnHashPassword (@password NVARCHAR(32))
Returns NVARCHAR(32)
AS
BEGIN
	return HASHBYTES('SHA1', @password)
END;

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