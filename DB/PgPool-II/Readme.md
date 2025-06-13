
Features
- HA
- Connection Pooling
- Automatic failover
- Loadbalancing
- Replication

`apt-cache search enterprisedb`

`sudo apt-get -y install edb-as<xx>-pgpool<yy>-extensions`

`echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list`

`wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -`


`apt-get update`

`apt-get -y install pgpool2 libpgpool2 postgresql-14-pgpool2`