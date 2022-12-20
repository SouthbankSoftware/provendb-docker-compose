use provendb;
db.dummy_pdbignore.insertOne({});

db.getSiblingDB("provendb").createUser({
    user: "pdbuser",
    pwd: "click123", 
      roles: [ 
              {role:"readWrite", db: "provendb" }     
             ]
     },
     {  w: "majority" }
 );