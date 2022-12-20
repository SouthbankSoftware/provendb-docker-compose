var userPresent = db.getSiblingDB(USER_DATABASES).runCommand({ usersInfo: { user: PROVENDB_USER, db: USER_DATABASES } }).users.length > 0;
if(!userPresent){
    db.getSiblingDB(USER_DATABASES).runCommand({ createRole: 'superuser', privileges: [], roles: [] });
    db.getSiblingDB(USER_DATABASES).runCommand({ createRole: 'superadmin', privileges: [], roles: [] });
    db.getSiblingDB(USER_DATABASES).runCommand({ createUser: PROVENDB_USER, pwd: PROVENDB_PASS, roles: [{ role: 'superadmin', db: USER_DATABASES }] })
}
db.getSiblingDB(USER_DATABASES).runCommand({ usersInfo: { user: PROVENDB_USER, db: USER_DATABASES } }).users