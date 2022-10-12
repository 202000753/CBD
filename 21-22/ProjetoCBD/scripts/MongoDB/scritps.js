use STBWeb;

//Listar por Encarregado de Educação o “histórico de notas” dos alunos ao seu encargo;
//Listar por aluno as notas de um determinado ano letivo, e a respectiva média final;
//Listar por disciplina, os respetivos alunos e notas obtidas;

//Registar Relatorios
db.Cloosed_Course.update({$and: [{StudentID:"1"},{SubjectID:"3"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P3', Professor: 'Professor 3', Texto: "Texto1", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"2"},{SubjectID:"3"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P3', Professor: 'Professor 3', Texto: "Texto2", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"3"},{SubjectID:"3"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P3', Professor: 'Professor 3', Texto: "Texto3", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"4"},{SubjectID:"3"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P3', Professor: 'Professor 3', Texto: "Texto4", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"5"},{SubjectID:"2"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P2', Professor: 'Professor 2', Texto: "Texto5", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"6"},{SubjectID:"2"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P2', Professor: 'Professor 2', Texto: "Texto6", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"7"},{SubjectID:"2"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P2', Professor: 'Professor 2', Texto: "Texto7", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"8"},{SubjectID:"2"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P2', Professor: 'Professor 2', Texto: "Texto8", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"9"},{SubjectID:"2"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P2', Professor: 'Professor 2', Texto: "Texto9", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"10"},{SubjectID:"2"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P2', Professor: 'Professor 2', Texto: "Texto10", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"11"},{SubjectID:"1"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P1', Professor: 'Professor 1', Texto: "Texto11", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"12"},{SubjectID:"1"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P1', Professor: 'Professor 1', Texto: "Texto12", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"13"},{SubjectID:"1"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P1', Professor: 'Professor 1', Texto: "Texto13", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"14"},{SubjectID:"1"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P1', Professor: 'Professor 1', Texto: "Texto14", date: new Date()} } })
db.Cloosed_Course.update({$and: [{StudentID:"15"},{SubjectID:"1"}, {SchoolYear:"2017"}]}, { $push: { relatorio: {periodo: 'P1', Professor: 'Professor 1', Texto: "Texto15", date: new Date()} } })
