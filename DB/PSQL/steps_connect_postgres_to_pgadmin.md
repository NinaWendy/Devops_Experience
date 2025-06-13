
1. Install Postgres from official documentation
2. Install pgAdmin from its official documentation site
3. Add password to postgres user 
	`sudo -u posgres psql`
	`# alter user postgres with password 'password' `
4. Open pgAdmin:
	- On the interface click servers then register server
	- In the general tab under name write `localhost`
	- Switch to connection tab, hostname remains `localhost`, usernamme is `postgres` and password is `password`
