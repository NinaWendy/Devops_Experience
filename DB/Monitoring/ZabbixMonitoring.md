psql create user zbx_monitor with password 'zabbix' inherit;

grant pg_monitor to zbx_monitor;

