// We first initiate the replica.
rs.initiate({
    _id: 'rs0',
    members: [
        {
            _id: 0,
            host: "mongo:27017"
        },
    ]
});

// if (!(typeof (PROVENDB_DB) === 'undefined' || typeof (PROVENDB_USER) === 'undefined' || typeof (PROVENDB_PASS) === 'undefined') && PROVENDB_DB !== "" && PROVENDB_USER !== "" && PROVENDB_PASS !== "") {
//     print("Waiting until current node becomes primary..")
//     while (rs.status().members.find(member => { return member.name === RS_HOST }).uptime < 20) { }
//     // while(rs.status().members.find(member => {return member.name === "mongo:27017"}).infoMessage !== ""){ }
//     print("Current node is now set to primary")

//     db.getSiblingDB(PROVENDB_DB).runCommand({ createRole: 'superuser', privileges: [], roles: [] });

//     db.getSiblingDB(PROVENDB_DB).createUser({
//         user: PROVENDB_USER,
//         pwd: PROVENDB_PASS,
//         roles: [{
//             role: 'readWrite',
//             db: PROVENDB_DB
//         }]
//     });
// }      