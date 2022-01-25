use cbd

db.createCollection('Customers')

//Etapa 1
//1.
db.Customer.insert({
                    _id:1,
                    firstname:"Orlando",
                    lastname:"Gee",
                    emailaddress:"orlando0@adventure-works.com",
                    phone:[2455550173],
                    addresses:{
                        line:"8713 Yosemite Ct.",
                        city:"Bothell"
                    }
                })

db.Customer.insert([
                    {
                        _id:2,
                        firstname:"Keith",
                        lastname:"Harris",
                        emailaddress:"keith0@adventure-works.com",
                        phone:[2445550112,1925550173],
                        addresses:{
                            line:"1318 Lasalle Street",
                            city:"Bothell"
                        }
                    },
                    {
                        _id:3,
                        firstname:"Donna",
                        lastname:"Carreras",
                        emailaddress:"odonna0@adventure-works.com",
                        addresses:[{
                            line:"8713 Yosemite Ct.",
                            city:"Bothell"
                        },
                        {
                            line:"7943 Walnut Ave",
                            city:"Quebec"
                        }
                    ]
                    },
                    {
                        _id:4,
                        firstname:"Janet",
                        lastname:"Gates",
                        emailaddress:"janet1@adventure-works.com",
                        phone:[2455550173],
                        addresses:{
                            line:"52560 Free Street",
                            city:"Toronto"
                        }
                    }
])

//2.
db.Customer.find()

db.Customer.find({_id:1})
db.Customer.find({_id:1}).pretty()
db.Customer.find({phone:2455550173}).pretty()

db.Customer.find({"addresses.city" : "Toronto"}).pretty()
db.Customer.find({"addresses.city" : "Toronto"}).count()

db.Customer.find({$and: [{"addresses.city":"Bothell"},{firstname:"Donna"}]})
db.Customer.find({$or: [{_id:2},{ phone:2455550173}]})

db.Customer.find({phone: {$exists:false}}).pretty()

db.Customer.find({},{firstname:1})
db.Customer.find({},{firstname:1,_id:0})

db.Customer.find({},{firstname:1,_id:0}).sort({firstname:-1})
db.Customer.find({},{firstname:1,_id:0}).sort({firstname:1})

db.Customer.aggregate([{$group : {_id : "$addresses.city", num_cust : {$sum : 1}}}])

//3.
db.Customer.update({_id:1},{$set:{ emailaddress: "orlando@adventure-works.com" }})

db.Customer.update({ _id: 1 },{ $push: { phone: 210000089 } })

//4.
db.Customer.insert({_id:5, firstname:"Arnold"})
db.Customer.find({_id:5})
db.Customer.remove({_id:5})
db.Customer.find({_id:5})

//Etapa 2
//1.

//2.
use AdventureWorksMDB

//3.

//4.
db.Products.update({ ProductID: 771 },{ $push: { comment: {clientEmail: 'kim2@adventure-works.com', text: 'Muito Bom', reting: 5, date: new Date()} } })
db.Products.update({ ProductID: 771 },{ $push: { comment: {clientEmail: 'catherine0@adventure-works.com', text: 'Bom', reting: 4, date: new Date()} } })
db.Products.update({ ProductID: 772 },{ $push: { comment: {clientEmail: 'kim2@adventure-works.com', text: 'Suficiente', reting: 3, date: new Date()} } })
db.Products.update({ ProductID: 772 },{ $push: { comment: {clientEmail: 'catherine0@adventure-works.com', text: 'Insuficiente', reting: 2, date: new Date()} } })
db.Products.update({ ProductID: 772 },{ $push: { comment: {clientEmail: 'frances0@adventure-works.com', text: 'Mau', reting: 1, date: new Date()} } })
db.Products.update({ ProductID: 773 },{ $push: { comment: {clientEmail: 'kim2@adventure-works.com', text: 'Muito Bom', reting: 5, date: new Date()} } })
db.Products.update({ ProductID: 774 },{ $push: { comment: {clientEmail: 'catherine0@adventure-works.com', text: 'Bom', reting: 4, date: new Date()} } })
db.Products.update({ ProductID: 775 },{ $push: { comment: {clientEmail: 'kim2@adventure-works.com', text: 'Suficiente', reting: 3, date: new Date()} } })
db.Products.update({ ProductID: 776 },{ $push: { comment: {clientEmail: 'kim2@adventure-works.com', text: 'Mau', reting: 2, date: new Date()} } })

//Etapa 3
//1.

//2.

//3.

//4.

//5.

//6.

//7.
db.Products.update({ ProductID: 777 },{ $push: { comment: {clientEmail: 'kim2@adventure-works.com', text: 'Mau', reting: 2, date: new Date()} } })

//8.

//9.


















